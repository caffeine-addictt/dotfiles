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

add_path "$HOME/.cargo/bin"
add_path "$HOME/go/bin"
add_path "$HOME/.config/bin"
