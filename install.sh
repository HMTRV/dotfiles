#!/bin/sh

set -eu

dotfiles_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
codex_home_dir=${CODEX_HOME:-"$HOME/.codex"}
install_packages=1
install_plugins=1

usage() {
  printf '%s\n' \
    "Uso: ./install.sh [--skip-packages] [--skip-plugins]" \
    "" \
    "Enlaza Alacritty, tmux y la memoria global de Codex." \
    "Los archivos existentes se guardan bajo ~/.dotfiles-backup."
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --skip-packages)
      install_packages=0
      ;;
    --skip-plugins)
      install_plugins=0
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Opción desconocida: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

backup_dir="$HOME/.dotfiles-backup/$(date '+%Y%m%d-%H%M%S')"
backup_created=0

link_file() {
  source_path="$dotfiles_dir/$1"
  target_path="$2"

  if [ ! -f "$source_path" ]; then
    printf 'Falta el archivo fuente: %s\n' "$source_path" >&2
    exit 1
  fi

  mkdir -p "$(dirname -- "$target_path")"

  if [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$source_path" ]; then
    printf 'OK      %s\n' "$target_path"
    return
  fi

  if [ -e "$target_path" ] || [ -L "$target_path" ]; then
    backup_path="$backup_dir/$1"
    mkdir -p "$(dirname -- "$backup_path")"
    mv "$target_path" "$backup_path"
    backup_created=1
    printf 'BACKUP  %s -> %s\n' "$target_path" "$backup_path"
  fi

  ln -s "$source_path" "$target_path"
  printf 'LINK    %s -> %s\n' "$target_path" "$source_path"
}

if [ "$install_packages" -eq 1 ]; then
  if [ "$(uname -s)" != "Darwin" ]; then
    printf '%s\n' "Aviso: Brewfile está orientado a macOS; se omiten paquetes." >&2
  elif ! command -v brew >/dev/null 2>&1; then
    printf '%s\n' \
      "Homebrew no está instalado." \
      "Instálalo desde https://brew.sh y vuelve a ejecutar ./install.sh." >&2
    exit 1
  else
    brew bundle --file "$dotfiles_dir/Brewfile"
  fi
fi

chmod +x \
  "$dotfiles_dir/config/tmux/scripts/copy.sh" \
  "$dotfiles_dir/config/tmux/scripts/wg_status.sh" \
  "$dotfiles_dir/bin/check" \
  "$dotfiles_dir/bin/publish" \
  "$dotfiles_dir/bin/sync"

link_file "config/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
link_file "config/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
link_file "config/tmux/scripts/copy.sh" "$HOME/.config/tmux/scripts/copy.sh"
link_file "config/tmux/scripts/wg_status.sh" "$HOME/.config/tmux/scripts/wg_status.sh"
link_file "codex/AGENTS.md" "$codex_home_dir/AGENTS.md"

plugins_dir="$HOME/.config/tmux/plugins"
tpm_dir="$plugins_dir/tpm"

if [ "$install_plugins" -eq 1 ]; then
  if [ ! -d "$tpm_dir/.git" ]; then
    mkdir -p "$plugins_dir"
    git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
  fi
  "$tpm_dir/bin/install_plugins"
fi

if tmux list-sessions >/dev/null 2>&1; then
  tmux source-file "$HOME/.config/tmux/tmux.conf"
  printf '%s\n' "RELOAD  tmux"
fi

if [ "$backup_created" -eq 1 ]; then
  printf '\nRespaldo recuperable: %s\n' "$backup_dir"
fi

printf '%s\n' "Instalación terminada."
