add_env_path() {
  local var="$1"
  local dir="$2"

  [[ -n "$var" && -n "$dir" ]] || {
    printf "add_env_path: missing arguments\nusage: add_env_path <var> <dir>\n" >&2
    return 1
  }

  [[ -d "$dir" ]] || {
    printf "add_env_path: '%s' is not a directory\n" "$dir" >&2
    return 1
  }

  dir="$(cd "$dir" && pwd -P)" || return 1

  local cur
  eval "cur=\"\${$var}\""
  case ":$cur:" in
  *":$dir:"*) return 0 ;;
  esac

  eval "export $var=\"$dir:\$cur\""
}

add_env_path PATH "/var/lib/flatpak/exports/bin"
add_env_path PATH "$HOME/.local/share/flatpak/exports/bin"

add_env_path PATH "$HOME/.config/bin"
add_env_path PATH "$HOME/.cargo/bin"
add_env_path PATH "$HOME/go/bin"

# applications
add_env_path XDG_DATA_DIRS "/var/lib/flatpak/exports/share"
add_env_path XDG_DATA_DIRS "$HOME/.local/share/flatpak/exports/share"
add_env_path XDG_DATA_DIRS "$HOME/.var/app/com.valvesoftware.Steam/.local/share"
