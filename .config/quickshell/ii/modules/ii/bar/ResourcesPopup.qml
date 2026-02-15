import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts

StyledPopup {
    id: root

    // Helper function to format KiB to GiB
    function formatKiB(kb) {
        return (kb / (1024 * 1024)).toFixed(1) + " GiB";
    }

    Row {
        anchors.centerIn: parent
        spacing: 12

        Column {
            anchors.top: parent.top
            spacing: 8

            StyledPopupHeaderRow {
                icon: "planner_review"
                label: "CPU"
            }
            Column {
                spacing: 4
                StyledPopupValueRow {
                    icon: "bolt"
                    label: Translation.tr("Load:")
                    value: `${Math.round(ResourceUsage.cpuUsage * 100)}%`
                }
            }
        }

        Column {
            anchors.top: parent.top
            spacing: 8

            StyledPopupHeaderRow {
                icon: "planner_review"
                label: "GPU"
            }
            Column {
                spacing: 4
                StyledPopupValueRow {
                    icon: "bolt"
                    label: Translation.tr("Load:")
                    value: `${Math.round(ResourceUsage.gpuUsage * 100)}%`
                }
                StyledPopupValueRow {
                    icon: "clock_loader_60"
                    label: Translation.tr("Used:")
                    value: root.formatKiB(ResourceUsage.gpuVRamUsedMB)
                }
                StyledPopupValueRow {
                    icon: "empty_dashboard"
                    label: Translation.tr("Total:")
                    value: root.formatKiB(ResourceUsage.gpuVRamTotalMB)
                }
            }
        }

        Column {
            anchors.top: parent.top
            spacing: 8

            StyledPopupHeaderRow {
                icon: "memory"
                label: "RAM"
            }
            Column {
                spacing: 4
                StyledPopupValueRow {
                    icon: "clock_loader_60"
                    label: Translation.tr("Used:")
                    value: root.formatKiB(ResourceUsage.memoryUsed)
                }
                StyledPopupValueRow {
                    icon: "check_circle"
                    label: Translation.tr("Free:")
                    value: root.formatKiB(ResourceUsage.memoryFree)
                }
                StyledPopupValueRow {
                    icon: "empty_dashboard"
                    label: Translation.tr("Total:")
                    value: root.formatKiB(ResourceUsage.memoryTotal)
                }
            }
        }

        Column {
            visible: ResourceUsage.swapTotal > 0
            anchors.top: parent.top
            spacing: 8

            StyledPopupHeaderRow {
                icon: "swap_horiz"
                label: "Swap"
            }
            Column {
                spacing: 4
                StyledPopupValueRow {
                    icon: "clock_loader_60"
                    label: Translation.tr("Used:")
                    value: root.formatKiB(ResourceUsage.swapUsed)
                }
                StyledPopupValueRow {
                    icon: "check_circle"
                    label: Translation.tr("Free:")
                    value: root.formatKiB(ResourceUsage.swapFree)
                }
                StyledPopupValueRow {
                    icon: "empty_dashboard"
                    label: Translation.tr("Total:")
                    value: root.formatKiB(ResourceUsage.swapTotal)
                }
            }
        }
    }
}
