# Instrucciones del repositorio de dotfiles

Este repositorio es la fuente de verdad para la configuración personal de
Alacritty, tmux y la memoria global segura de Codex.

- El repositorio es público: todo cambio debe ser apto para exposición pública.
- Edita los archivos versionados; no reemplaces los enlaces bajo `~/.config`.
- Mantén compatibilidad con macOS tanto en Apple Silicon como en Intel.
- No agregues rutas absolutas de usuario ni de Homebrew.
- No versionar credenciales, `~/.codex/auth.json`, historiales, sesiones,
  bases SQLite, logs, tokens, correos personales, direcciones de red internas
  ni nombres de clientes.
- Después de un cambio ejecuta `./bin/check`.
- No agregues dependencias ejecutables remotas sin fijar origen y revisión
  completa. Actualiza `config/tmux/plugins.lock` de forma intencional.
- No agregues workflows de GitHub Actions: están desactivados deliberadamente.
- Si cambian dependencias o el flujo de instalación, actualiza `Brewfile` y
  `README.md`.
- La configuración canónica está en:
  - `config/alacritty/alacritty.toml`
  - `config/tmux/tmux.conf`
  - `config/tmux/scripts/`
  - `codex/AGENTS.md`
