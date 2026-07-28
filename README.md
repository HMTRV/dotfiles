# Dotfiles de Alacritty, tmux y Codex

Fuente de verdad portable para reproducir la misma experiencia de terminal y
las mismas instrucciones personales seguras de Codex en todos mis Macs.

Este repositorio es público. Su contenido está diseñado para no incluir
credenciales, direcciones internas, rutas de usuario ni estado efímero.

## Qué se sincroniza

- Alacritty: tema, fuente, ventana, teclado y arranque automático de tmux.
- tmux: prefijo `C-Space`, navegación, popups, estado, TPM y scripts auxiliares.
- Memoria de Codex: `codex/AGENTS.md`, enlazado como
  `$CODEX_HOME/AGENTS.md` (por defecto, `~/.codex/AGENTS.md`).
- Dependencias: `Brewfile`.

No se sincronizan credenciales, claves SSH, `~/.codex/config.toml`, sesiones,
historiales, logs ni bases de datos internas de Codex. Cada laptop inicia sesión
en Codex por separado.

## Instalar en una laptop nueva

```sh
git clone https://github.com/HMTRV/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

El instalador:

1. instala las dependencias declaradas en `Brewfile`;
2. respalda cualquier archivo anterior bajo `~/.dotfiles-backup/<fecha>`;
3. crea enlaces para Alacritty, tmux y la memoria global de Codex;
4. instala los plugins de tmux en las revisiones verificadas de
   `config/tmux/plugins.lock`;
5. recarga tmux si ya está ejecutándose.

Si Homebrew todavía no está instalado, instálalo desde
[brew.sh](https://brew.sh) y vuelve a ejecutar el instalador.

### Varias suscripciones de Codex

Si las cuentas usan el mismo `CODEX_HOME`, no hace falta ninguna configuración
adicional. Si una cuenta está aislada en otro directorio, enlaza la misma memoria
ejecutando una vez:

```sh
CODEX_HOME="$HOME/.codex-trabajo" ./install.sh --skip-packages --skip-plugins
```

Repite el comando por cada `CODEX_HOME`. Sólo se comparte `AGENTS.md`; la
autenticación y el estado de cada suscripción siguen separados.

### Clonar desde Kali con acceso mínimo

El script `scripts/bootstrap-kali-dotfiles.sh` instala Git si hace falta y clona
el repositorio público por HTTPS. No crea claves ni autentica una cuenta de
GitHub.

En Kali:

```sh
curl -fsSLo bootstrap-kali-dotfiles.sh \
  https://raw.githubusercontent.com/HMTRV/dotfiles/main/scripts/bootstrap-kali-dotfiles.sh
less bootstrap-kali-dotfiles.sh
chmod +x bootstrap-kali-dotfiles.sh
./bootstrap-kali-dotfiles.sh
```

Revisa el archivo antes de ejecutarlo y no invoques el script completo con
`sudo`; él solicita privilegios sólo si debe instalar Git. Si Git ya existe, se
prefiere el clon directo.

También se puede clonar directamente:

```sh
git clone https://github.com/HMTRV/dotfiles.git ~/dotfiles
```

## Actualizar una laptop

```sh
~/dotfiles/bin/sync
```

Este primer paso obtiene y muestra los cambios sin ejecutarlos. Después de
revisar `git -C ~/dotfiles diff HEAD..origin/main`, aplica la actualización:

```sh
~/dotfiles/bin/sync --apply
```

La aplicación exige un avance lineal, desactiva hooks Git durante la integración,
reconcilia enlaces y plugins fijados, valida los archivos y recarga tmux.

## Publicar cambios

Como los archivos activos son enlaces, al editar
`~/.config/alacritty/alacritty.toml` o `~/.config/tmux/tmux.conf` se modifica
directamente el repositorio. Para revisar y propagar:

```sh
cd ~/dotfiles
git diff
./bin/publish "Ajusta configuración de terminal"
```

`publish` valida, prepara solamente los archivos conocidos del repositorio,
crea el commit y lo sube. Después ejecuta `~/dotfiles/bin/sync` en los demás
equipos. Para no publicar el correo personal, configura en este repositorio un
correo `noreply` de GitHub:

```sh
git config user.email "HMTRV@users.noreply.github.com"
```

`bin/check` inspecciona también archivos ocultos, formatos de claves y patrones
comunes de tokens. GitHub complementa este control con secret scanning y
protección de push.

## Modelo de seguridad

- `main` sólo acepta avances lineales; se bloquean borrados y force-push.
- GitHub Actions está desactivado porque este repositorio no necesita CI.
- Los plugins de tmux se descargan desde orígenes exactos y commits completos
  verificados; no se ejecuta código nuevo sólo porque cambió una rama externa.
- La sincronización remota se revisa antes de ejecutar una versión nueva de los
  scripts.
- Los controles reducen accidentes, pero una toma de la cuenta de GitHub todavía
  exige revocar sesiones y revisar el repositorio.

## Recuperación

Los archivos que existían antes del primer enlace quedan en
`~/.dotfiles-backup/<fecha>`. Para restaurar uno, elimina únicamente su enlace y
mueve el archivo respaldado a su ubicación original.
