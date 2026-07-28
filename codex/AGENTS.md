# Memoria personal compartida

## Alacritty y tmux

- La fuente de verdad de mi configuración está en `~/dotfiles`.
- Al modificar Alacritty o tmux, trabaja sobre los archivos dentro de ese
  repositorio; `~/.config/alacritty/alacritty.toml` y
  `~/.config/tmux/tmux.conf` son enlaces administrados por `~/dotfiles/install.sh`.
- Conserva la experiencia actual: Alacritty abre o adjunta la sesión tmux
  `main`, el prefijo de tmux es `C-Space` y la estética usa la paleta cálida
  definida en los archivos existentes.
- Mantén portabilidad entre Macs Intel y Apple Silicon. No introduzcas rutas
  absolutas de usuario ni un prefijo específico de Homebrew; resuelve comandos
  mediante el shell o usa `$HOME`.
- Después de cambiar estos dotfiles ejecuta `~/dotfiles/bin/check` y recarga
  tmux con `tmux source-file ~/.config/tmux/tmux.conf`.
- Si se desea propagar un cambio, primero valida y revisa el diff; publica con
  `~/dotfiles/bin/publish "descripción breve"` solamente cuando el usuario lo
  haya solicitado.

## Seguridad

- Este repositorio es público. Trata todo archivo versionado como información
  visible para terceros.
- Nunca sincronices credenciales o estado efímero de Codex. En particular, no
  versionar `~/.codex/auth.json`, `config.toml` completo, historiales, sesiones,
  logs, bases SQLite, claves SSH, tokens, correos personales, redes internas ni
  nombres de clientes.
- No ejecutes automáticamente una actualización remota. Primero usa
  `~/dotfiles/bin/sync`, revisa el diff y sólo después aplica con
  `~/dotfiles/bin/sync --apply`.
- Conserva los plugins de tmux fijados a las revisiones declaradas en
  `config/tmux/plugins.lock`.
- Las cuentas o suscripciones de Codex pueden ser distintas; esta memoria se
  comparte por Git y por el enlace `$CODEX_HOME/AGENTS.md` (por defecto,
  `~/.codex/AGENTS.md`), no por copiar el estado interno de Codex.
