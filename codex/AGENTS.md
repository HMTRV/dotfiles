# Memoria personal compartida

## Voz y redacción

- Usar siempre primera persona singular al expresar acciones, propuestas y
  solicitudes: «revisé», «propongo», «necesito», «te confirmo».
- Al redactar mensajes, correos o borradores para que yo los envíe, escribir
  directamente con mi voz. Evitar hablar de mí en tercera persona, las formas
  impersonales y el plural de equipo («revisamos», «proponemos», «necesitamos»).
- En las respuestas del asistente, describir sus propias acciones también en
  primera persona singular. Conservar la atribución real de acciones ajenas y
  no presentar propuestas o tareas pendientes como hechos realizados.

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

## Skills locales

Estas viven fuera de este repositorio porque contienen contexto de trabajo que
no debe publicarse. El repositorio sólo guarda el puntero.

- **FortiGate VM en AWS detrás de un Gateway Load Balancer** (FortiOS,
  FortiManager, FortiAnalyzer, camino de datos GWLB/GENEVE/TGW): leer y seguir
  `~/.kiro/crew/skills/fortigate-ops/AGENTS.md` antes de ejecutar cualquier
  cosa. Define tres carriles por nivel de riesgo y las reglas duras. La premisa
  que cambia todo: los firewalls son instancias efímeras de un Auto Scaling
  Group, así que un cambio hecho directo en una instancia se pierde en el
  próximo reemplazo — los cambios van como código, por PR.

## Presentaciones Morris & Opazo

- Al crear o editar cualquier presentación, PowerPoint o PPTX, trabajar por
  defecto en el contexto de branding Morris & Opazo, salvo que el usuario
  pida explícitamente otra identidad visual.
- Antes de maquetar, leer `~/workspaces/morris-pptx-skill/SKILL.md` y
  `~/workspaces/morris-opazo-branding-skill/SKILL.md`, con sus referencias de
  diseño. Si cambia la ubicación, buscar la skill antes de reemplazarla.
- Usar sus patrones, Poppins, paleta navy/naranja, logos oficiales y pie
  corporativo. Incorporar iconografía significativa de los assets oficiales
  AWS y del set de conceptos; no usar emojis como sustituto.
- Revisar visualmente todas las láminas y conservar las reglas de marca.
  Los assets y el contenido de las skills permanecen fuera de este repositorio.

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
