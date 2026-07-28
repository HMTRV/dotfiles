#!/bin/sh

# Portapapeles compatible con macOS y escritorios Linux habituales.
if command -v pbcopy >/dev/null 2>&1; then
  exec pbcopy
elif command -v wl-copy >/dev/null 2>&1; then
  exec wl-copy
elif command -v xclip >/dev/null 2>&1; then
  exec xclip -selection clipboard
fi

printf '%s\n' "No se encontró pbcopy, wl-copy ni xclip" >&2
exit 1
