#!/bin/sh

# Estado VPN genérico para la barra de tmux.
# No imprime direcciones, nombres de conexiones ni topología interna.
connected=0

if command -v wg >/dev/null 2>&1 &&
  [ -n "$(wg show interfaces 2>/dev/null)" ]; then
  connected=1
elif command -v scutil >/dev/null 2>&1 &&
  scutil --nc list 2>/dev/null | grep -q '(Connected)'; then
  connected=1
fi

if [ "$connected" -eq 1 ]; then
  printf '#[fg=#7faa6a]VPN on'
else
  printf '#[fg=#d84a3a]VPN off'
fi
