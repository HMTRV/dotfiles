#!/usr/bin/env bash

set -Eeuo pipefail

readonly repo_owner="HMTRV"
readonly repo_name="dotfiles"
readonly clone_dir="${1:-${HOME}/dotfiles}"
readonly repository_url="https://github.com/${repo_owner}/${repo_name}.git"

log() {
  printf '\n==> %s\n' "$1"
}

die() {
  printf '\nERROR: %s\n' "$1" >&2
  exit 1
}

install_dependencies() {
  local missing=0

  command -v git >/dev/null 2>&1 || missing=1

  if [[ "$missing" -eq 0 ]]; then
    return
  fi

  command -v apt-get >/dev/null 2>&1 ||
    die "Falta Git y no existe apt-get."

  log "Instalando Git"
  if [[ "$EUID" -eq 0 ]]; then
    apt-get update
    apt-get install -y git ca-certificates
  elif command -v sudo >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y git ca-certificates
  else
    die "Se necesita root o sudo para instalar Git."
  fi
}

clone_or_update() {
  if [[ -d "${clone_dir}/.git" ]]; then
    local current_url
    current_url=$(git -C "$clone_dir" remote get-url origin) ||
      die "El repositorio existente no tiene un remoto origin."
    [[ "$current_url" == "$repository_url" ]] ||
      die "El remoto origin no es el repositorio público esperado: ${current_url}"
    log "Actualizando el repositorio existente ${clone_dir}"
    git -C "$clone_dir" -c core.hooksPath=/dev/null pull --ff-only
  elif [[ -e "$clone_dir" ]]; then
    die "El destino ${clone_dir} existe pero no es un repositorio Git."
  else
    log "Clonando en ${clone_dir}"
    git -c core.hooksPath=/dev/null clone -- "$repository_url" "$clone_dir"
  fi
}

main() {
  if [[ "$EUID" -eq 0 ]]; then
    die "Ejecuta este script como usuario normal; usará sudo sólo para instalar Git."
  fi
  install_dependencies
  clone_or_update

  log "Listo"
  printf '%s\n' \
    "Repositorio: ${clone_dir}" \
    "Acceso GitHub: HTTPS público, sin credenciales" \
    "Para actualizar: git -C ${clone_dir} pull --ff-only"
}

main "$@"
