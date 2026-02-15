pragma Singleton
pragma ComponentBehavior: Bound

import qs.modules.common
import QtQuick
import Quickshell
import Quickshell.Io

/**
 * Simple polled resource usage service with RAM, Swap, and CPU usage.
 */
Singleton {
    id: root

    property real cpuUsage: 0
    property real cpuTempC: 0
    property var previousCpuStats

    property real gpuUsage: 0
    property real gpuVRamUsed: 0
    property real gpuVRamTotal: 0
    property real gpuTempC: 0

    property real memoryTotal: 1
    property real memoryFree: 0
    property real memoryUsed: memoryTotal - memoryFree
    property real memoryUsedPercentage: memoryUsed / memoryTotal

    property real swapTotal: 1
    property real swapFree: 0
    property real swapUsed: swapTotal - swapFree
    property real swapUsedPercentage: swapTotal > 0 ? (swapUsed / swapTotal) : 0

    property string maxAvailableMemoryString: kibToGibString(ResourceUsage.memoryTotal)
    property string maxAvailableSwapString: kibToGibString(ResourceUsage.swapTotal)

    readonly property int historyLength: Config?.options.resources.historyLength ?? 60
    property list<real> cpuUsageHistory: []
    property list<real> gpuUsageHistory: []
    property list<real> memoryUsageHistory: []
    property list<real> swapUsageHistory: []

    function kibToGibString(kb) {
        return (kb / (1024 * 1024)).toFixed(1) + " GiB";
    }

    function updateMemoryUsageHistory() {
        memoryUsageHistory = [...memoryUsageHistory, memoryUsedPercentage];
        if (memoryUsageHistory.length > historyLength) {
            memoryUsageHistory.shift();
        }
    }
    function updateSwapUsageHistory() {
        swapUsageHistory = [...swapUsageHistory, swapUsedPercentage];
        if (swapUsageHistory.length > historyLength) {
            swapUsageHistory.shift();
        }
    }
    function updateCpuUsageHistory() {
        cpuUsageHistory = [...cpuUsageHistory, cpuUsage];
        if (cpuUsageHistory.length > historyLength) {
            cpuUsageHistory.shift();
        }
    }
    function updateGpuUsageHistory() {
        gpuUsageHistory = [...gpuUsageHistory, gpuUsage];
        if (gpuUsageHistory.length > historyLength) {
            gpuUsageHistory.shift();
        }
    }
    function updateHistories() {
        updateCpuUsageHistory();
        updateGpuUsageHistory();
        updateMemoryUsageHistory();
        updateSwapUsageHistory();
    }

    Timer {
        interval: 1
        running: true
        repeat: true
        onTriggered: {
            fileMeminfo.reload();
            fileStat.reload();
            cpuTempFD.reload();
            gpuUsageFD.reload();
            gpuTempFD.reload();
            gpuVRamTotalFD.reload();
            gpuVRamUsedFD.reload();

            // Parse memory and swap usage
            const textMeminfo = fileMeminfo.text();
            memoryTotal = Number(textMeminfo.match(/MemTotal: *(\d+)/)?.[1] ?? 1);
            memoryFree = Number(textMeminfo.match(/MemAvailable: *(\d+)/)?.[1] ?? 0);
            swapTotal = Number(textMeminfo.match(/SwapTotal: *(\d+)/)?.[1] ?? 1);
            swapFree = Number(textMeminfo.match(/SwapFree: *(\d+)/)?.[1] ?? 0);

            // Parse CPU usage
            const textStat = fileStat.text();
            const cpuLine = textStat.match(/^cpu\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/);
            if (cpuLine) {
                const stats = cpuLine.slice(1).map(Number);
                const total = stats.reduce((a, b) => a + b, 0);
                const idle = stats[3];

                if (previousCpuStats) {
                    const totalDiff = total - previousCpuStats.total;
                    const idleDiff = idle - previousCpuStats.idle;
                    cpuUsage = totalDiff > 0 ? (1 - idleDiff / totalDiff) : 0;
                }

                previousCpuStats = {
                    total,
                    idle
                };
            }
            cpuTempC = parseFloat((Number(cpuTempFD.text() ?? 0) / 1000).toFixed(1));

            // Parse GPU usage
            gpuUsage = Number(gpuUsageFD.text() ?? 0) / 100;
            gpuVRamUsed = (Number(gpuVRamUsedFD.text() ?? 0) / 1024).toFixed(1);
            gpuVRamTotal = (Number(gpuVRamTotalFD.text() ?? 0)) / 1024;
            gpuTempC = (Number(gpuTempFD.text() ?? 0) / 1000).toFixed(1);

            root.updateHistories();
            interval = Config.options?.resources?.updateInterval ?? 3000;
        }
    }

    FileView {
        id: fileMeminfo
        path: "/proc/meminfo"
    }
    FileView {
        id: fileStat
        path: "/proc/stat"
    }
    FileView {
        id: cpuTempFD
        path: "/sys/class/drm/card0/device/hwmon/hwmon2/temp1_input"
    }

    FileView {
        id: gpuUsageFD
        path: "/sys/class/drm/card1/device/gpu_busy_percent"
    }
    FileView {
        id: gpuTempFD
        path: "/sys/class/drm/card1/device/hwmon/hwmon1/temp1_input"
    }
    FileView {
        id: gpuVRamTotalFD
        path: "/sys/class/drm/card1/device/mem_info_vram_total"
    }
    FileView {
        id: gpuVRamUsedFD
        path: "/sys/class/drm/card1/device/mem_info_vram_used"
    }
}
