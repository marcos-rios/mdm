#!/bin/bash
# ==============================================================================
#  remover-jumpcloud-local.sh
#
#  Ruta SOPORTADA para desinstalar JumpCloud desde la propia Mac, sin admin de
#  la consola. Pensado para equipos con "Enrolled via DEP: No".
#
#  Respeta el orden correcto (clave para no quedar sin login):
#     1) Quitar el AGENTE JumpCloud primero.
#     2) Recién después limpiar PAM y quitar el perfil MDM.
#  (Si quitás el MDM antes, el agente pierde Full Disk Access y no puede
#   deshacer su config de PAM → el login de usuario y de pantalla falla.)
#
#  USO:
#     sudo bash scripts/remover-jumpcloud-local.sh
#     sudo bash scripts/remover-jumpcloud-local.sh /ruta/a/remove_mac_agent.sh
#
#  No es un bypass de DEP/ADE. Si tu equipo da "Enrolled via DEP: Yes" esto no
#  lo libera de Apple Business Manager. Corré antes: bash scripts/diagnostico.sh
# ==============================================================================

set -uo pipefail

if [ -t 1 ]; then
  RED=$'\033[1;31m'; GRN=$'\033[1;32m'; YEL=$'\033[1;33m'
  BLU=$'\033[1;34m'; CYAN=$'\033[1;36m'; NC=$'\033[0m'
else
  RED=''; GRN=''; YEL=''; BLU=''; CYAN=''; NC=''
fi
say()  { echo -e "${BLU}ℹ${NC} $*"; }
ok()   { echo -e "${GRN}✓${NC} $*"; }
warn() { echo -e "${YEL}!${NC} $*"; }
bad()  { echo -e "${RED}✗${NC} $*"; }
die()  { bad "$*"; exit 1; }
hr()   { echo -e "${CYAN}────────────────────────────────────────────────────────${NC}"; }

confirm() { # confirm "pregunta" -> 0 si el usuario escribe s/si/y/yes
  local ans
  read -r -p "$(echo -e "${YEL}»${NC} $1 [s/N]: ")" ans
  [[ "$ans" =~ ^([sS]|[sS][iI]|[yY]|[yY][eE][sS])$ ]]
}

REMOVE_SCRIPT="${1:-}"

# ---------------------------------------------------------------------------
# 0. Preflight
# ---------------------------------------------------------------------------
[ "$(uname -s)" = "Darwin" ] || die "Esto corre en macOS. Estás en $(uname -s)."
[ "$(id -u)" = "0" ] || die "Necesita root. Corré:  sudo bash scripts/remover-jumpcloud-local.sh"

echo
echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   Remover JumpCloud (agente + PAM) — ruta soportada   ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
echo

enroll="$(profiles status -type enrollment 2>/dev/null)"
echo "$enroll" | sed 's/^/   /'
if echo "$enroll" | grep -qi "Enrolled via DEP: Yes"; then
  echo
  warn "Este equipo figura con enrolamiento AUTOMATIZADO (DEP/ADE: Yes)."
  warn "Esto NO lo libera de Apple Business Manager. Ver docs/02 (sección 4)."
  confirm "Entendido, ¿seguir igual con la desinstalación del agente?" || { say "Cancelado."; exit 0; }
fi

echo
warn "Antes de seguir, confirmá que tenés:"
echo "   • Backup de tus archivos (Time Machine o copia)."
echo "   • Un SEGUNDO usuario administrador local (red de seguridad por si falla el login)."
echo "   • Tu contraseña local actual y, si usás FileVault, tu clave de recuperación."
echo
confirm "¿Tenés todo eso y querés continuar?" || { say "Frená, armá la red de seguridad y volvé."; exit 0; }

# ---------------------------------------------------------------------------
# 1. Quitar el AGENTE primero
# ---------------------------------------------------------------------------
hr; say "Paso 1 — Desinstalar el agente JumpCloud"

if [ ! -d /opt/jc ] && [ -z "$REMOVE_SCRIPT" ]; then
  ok "No existe /opt/jc: parece que el agente ya no está. Paso al chequeo de PAM."
else
  ran_remove=0
  if [ -n "$REMOVE_SCRIPT" ]; then
    [ -f "$REMOVE_SCRIPT" ] || die "No encuentro el script indicado: $REMOVE_SCRIPT"
    say "Voy a ejecutar el script oficial que pasaste: $REMOVE_SCRIPT"
    confirm "¿Ejecutar 'sh $REMOVE_SCRIPT' como root?" && { sh "$REMOVE_SCRIPT"; ran_remove=1; }
  elif [ -x /opt/jc/bin/removeAgent ]; then
    say "Encontré el desinstalador incluido: /opt/jc/bin/removeAgent"
    say "(Desde el agente 2.21.2 también borra el keychain de confianza del dispositivo.)"
    confirm "¿Ejecutar /opt/jc/bin/removeAgent?" && { /opt/jc/bin/removeAgent; ran_remove=1; }
  else
    warn "Hay /opt/jc pero no encuentro /opt/jc/bin/removeAgent."
    echo "   Descargá 'remove_mac_agent.sh' SOLO desde jumpcloud.com"
    echo "   (artículo: Install or Uninstall the JumpCloud Agent) y volvé a correr:"
    echo "       sudo bash scripts/remover-jumpcloud-local.sh /ruta/remove_mac_agent.sh"
  fi

  if [ "$ran_remove" = "1" ]; then
    sleep 2
    if [ -d /opt/jc ]; then
      warn "/opt/jc todavía existe. Puede que el desinstalador no haya terminado."
    else
      ok "Agente removido (/opt/jc ya no está)."
    fi
  fi
fi

# ---------------------------------------------------------------------------
# 2. Revisar y limpiar PAM (solo si el agente YA no está)
# ---------------------------------------------------------------------------
hr; say "Paso 2 — Revisar PAM (líneas jcagent que rompen el login)"

PAM_FILES=(authorization screensaver screensaver_new screensaver_ls screensaver_new_ls)
pam_hits=$(grep -l jcagent /etc/pam.d/* 2>/dev/null || true)

if [ -z "$pam_hits" ]; then
  ok "Sin líneas 'jcagent' en /etc/pam.d. Nada que limpiar."
else
  echo "   Archivos con 'jcagent':"; echo "$pam_hits" | sed 's/^/     /'
  if [ -d /opt/jc ]; then
    bad "OJO: el agente (/opt/jc) todavía está. NO conviene tocar PAM a mano todavía:"
    echo "   dejá que el desinstalador del agente lo limpie. Resolvé el Paso 1 primero."
  else
    ts="$(date +%Y%m%d-%H%M%S)"
    warn "El agente ya no está pero quedaron líneas jcagent. Hay que limpiarlas ANTES de reiniciar."
    if confirm "¿Borrar las líneas 'jcagent' de PAM? (se guarda copia .bak-$ts de cada archivo)"; then
      for f in "${PAM_FILES[@]}"; do
        path="/etc/pam.d/$f"
        if [ -f "$path" ] && grep -q jcagent "$path"; then
          cp -p "$path" "$path.bak-$ts"
          sed -i '' '/jcagent/d' "$path"
          ok "Limpiado $path (copia en $path.bak-$ts)"
        fi
      done
      # Por si hubiera jcagent en algún archivo de pam.d no listado arriba
      leftover=$(grep -l jcagent /etc/pam.d/* 2>/dev/null | grep -vE '\.bak-' || true)
      if [ -n "$leftover" ]; then
        warn "Todavía hay 'jcagent' en:"; echo "$leftover" | sed 's/^/     /'
        echo "   Revisalos a mano siguiendo el artículo oficial de JumpCloud"
        echo "   'Troubleshoot: Incomplete Agent Uninstall'."
      else
        ok "PAM limpio."
      fi
    else
      warn "No limpiaste PAM. NO reinicies hasta hacerlo, o el login puede fallar."
    fi
  fi
fi

# ---------------------------------------------------------------------------
# 3. Perfil MDM (paso guiado — se hace desde System Settings)
# ---------------------------------------------------------------------------
hr; say "Paso 3 — Quitar el perfil MDM"
if echo "$enroll" | grep -qi "MDM enrollment: Yes"; then
  echo "   El perfil MDM se quita desde la interfaz (es lo soportado):"
  echo "     System Settings → Privacy & Security → Profiles"
  echo "     (o General → Device Management → Remove)"
  echo "     Seleccioná el perfil 'MDM Enrollment' y tocá el botón '−' / Remove."
  echo "   Como el agente ya no está, nada lo vuelve a instalar."
  echo "   Si NO aparece el botón para quitarlo → es ADE/supervisado: ver docs/02 (sección 4)."
else
  ok "El estado actual ya dice 'MDM enrollment: No'. No hay perfil que quitar."
fi

# ---------------------------------------------------------------------------
# 4. Verificación
# ---------------------------------------------------------------------------
hr; say "Verificación"
echo "   /opt/jc:"; [ -d /opt/jc ] && bad "   sigue existiendo" || ok "   no existe"
echo "   Estado de enrolamiento ahora:"
profiles status -type enrollment 2>/dev/null | sed 's/^/     /'
echo "   PAM:"; grep -l jcagent /etc/pam.d/* 2>/dev/null | grep -vE '\.bak-' | sed 's/^/     (queda) /' || true
grep -lq jcagent /etc/pam.d/* 2>/dev/null || ok "   sin jcagent"

echo
ok "Listo lo automatizable. Cuando quites el perfil MDM, reiniciá y volvé a correr:"
echo "     bash scripts/diagnostico.sh"
echo "   El resultado buscado es:  Enrolled via DEP: No / MDM enrollment: No"
echo
