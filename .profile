add_path() {
  local dir="${1:-}"

  [[ -d "$dir" ]] || {
    printf "add_path: '%s' is not a directory\n" "$dir" >&2
    return 1
  }

  dir="$(cd "$dir" && pwd -P)" || return 1

  case ":$PATH:" in
  *":$dir:"*) return 0 ;;
  esac

  export PATH="$dir:$PATH"
}

add_path "/var/lib/flatpak/exports/bin"
add_path "$HOME/.local/share/flatpak/exports/bin"

add_path "$HOME/.config/bin"
add_path "$HOME/.cargo/bin"
add_path "$HOME/go/bin"

# show applications installed through flatpak without restarting
export XDG_DATA_DIRS="$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:$XDG_DATA_DIRS"
