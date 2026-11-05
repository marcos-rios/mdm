#!/bin/bash
# ==============================================================================
#  diagnostico.sh
#
#  QUÉ HACE: lee el estado de enrolamiento y de JumpCloud de ESTA Mac y te dice
#  qué ruta seguir. Es de SOLO LECTURA: no cambia nada, no desinstala nada.
#
#  USO:
#     bash scripts/diagnostico.sh         # checks básicos (sin sudo)
#     sudo bash scripts/diagnostico.sh    # agrega checks que necesitan root
#
#  Al final imprime un veredicto con el documento/script que te corresponde.
# ==============================================================================

set -uo pipefail

# Colores (se desactivan si la salida no es una terminal)
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
hr()   { echo -e "${CYAN}────────────────────────────────────────────────────────${NC}"; }

IS_ROOT=0
[ "$(id -u)" = "0" ] && IS_ROOT=1

echo
echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   Diagnóstico MDM / JumpCloud — solo lectura          ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"

# Solo corre en macOS
if [ "$(uname -s)" != "Darwin" ]; then
  bad "Este script es para macOS (uname = $(uname -s)). Corré en la Mac."
  exit 1
fi

# ---------------------------------------------------------------------------
# 1. Datos del equipo
# ---------------------------------------------------------------------------
hr; say "Equipo"
sw=$(sw_vers -productVersion 2>/dev/null || echo "?")
model=$(sysctl -n hw.model 2>/dev/null || echo "?")
serial=$(ioreg -l 2>/dev/null | awk -F'"' '/IOPlatformSerialNumber/{print $4; exit}')
echo "   macOS:      $sw"
echo "   Modelo:     $model"
echo "   Nº serie:   ${serial:-?}   (lo pide ABM/Apple Support si hay que liberar DEP)"

# ---------------------------------------------------------------------------
# 2. Admin local
# ---------------------------------------------------------------------------
hr; say "Cuenta actual"
if id -Gn 2>/dev/null | tr ' ' '\n' | grep -qx admin; then
  ok "Tu usuario ($(id -un)) es administrador."
  IS_ADMIN=1
else
  warn "Tu usuario ($(id -un)) NO está en el grupo admin. Vas a necesitar un admin local."
  IS_ADMIN=0
fi

# ---------------------------------------------------------------------------
# 3. Enrolamiento (DEP / MDM)
# ---------------------------------------------------------------------------
hr; say "Enrolamiento (profiles status -type enrollment)"
enroll="$(profiles status -type enrollment 2>/dev/null)"
echo "$enroll" | sed 's/^/   /'

DEP="unknown"; MDM="unknown"
echo "$enroll" | grep -qi "Enrolled via DEP: Yes" && DEP="yes"
echo "$enroll" | grep -qi "Enrolled via DEP: No"  && DEP="no"
echo "$enroll" | grep -qi "MDM enrollment: Yes"   && MDM="yes"
echo "$enroll" | grep -qi "MDM enrollment: No"    && MDM="no"

# ---------------------------------------------------------------------------
# 4. Agente JumpCloud
# ---------------------------------------------------------------------------
hr; say "Agente JumpCloud"
AGENT="no"
if [ -d /opt/jc ]; then
  AGENT="yes"
  warn "Existe /opt/jc → el agente está instalado."
  [ -x /opt/jc/bin/removeAgent ] && ok "Encontrado el desinstalador: /opt/jc/bin/removeAgent"
else
  ok "No existe /opt/jc (agente no instalado o ya removido)."
fi

jc_user=$(launchctl list 2>/dev/null | grep -i jumpcloud)
if [ -n "$jc_user" ]; then
  warn "Servicios JumpCloud en tu sesión de usuario:"; echo "$jc_user" | sed 's/^/     /'
else
  ok "Sin servicios JumpCloud en la sesión de usuario."
fi

if [ "$IS_ROOT" = "1" ]; then
  jc_sys=$(launchctl list 2>/dev/null | grep -Ei 'jumpcloud|jcagent|darwin-agent')
  if [ -n "$jc_sys" ]; then
    warn "Servicios JumpCloud a nivel sistema:"; echo "$jc_sys" | sed 's/^/     /'
  else
    ok "Sin servicios JumpCloud a nivel sistema."
  fi
else
  say "(Corré con sudo para revisar servicios del sistema.)"
fi

# ---------------------------------------------------------------------------
# 5. PAM (crítico: líneas jcagent rotas = login que falla)
# ---------------------------------------------------------------------------
hr; say "Configuración PAM (login)"
PAM_HIT="no"
if ls /etc/pam.d >/dev/null 2>&1; then
  pam_files=$(grep -l jcagent /etc/pam.d/* 2>/dev/null)
  if [ -n "$pam_files" ]; then
    PAM_HIT="yes"
    bad "Hay líneas 'jcagent' en archivos de PAM. Si el agente ya no está, LIMPIALAS ANTES de reiniciar:"
    echo "$pam_files" | sed 's/^/     /'
  else
    ok "Sin líneas 'jcagent' en /etc/pam.d."
  fi
else
  warn "No pude leer /etc/pam.d."
fi

# ---------------------------------------------------------------------------
# 6. Perfiles y extensiones (requiere root para el listado completo)
# ---------------------------------------------------------------------------
hr; say "Perfiles instalados"
if [ "$IS_ROOT" = "1" ]; then
  prof="$(profiles list 2>/dev/null)"
  if echo "$prof" | grep -qi jumpcloud; then
    warn "Aparecen perfiles con 'jumpcloud':"
    echo "$prof" | grep -i jumpcloud | sed 's/^/     /'
  else
    echo "$prof" | sed 's/^/   /' | head -20
    ok "No veo perfiles con 'jumpcloud' en el listado."
  fi
else
  say "(Corré con sudo para 'profiles list'.)"
fi

hr; say "Extensiones de sistema (systemextensionsctl list)"
ext="$(systemextensionsctl list 2>/dev/null)"
if echo "$ext" | grep -Eiq 'jumpcloud|netskope|cortex|paloalto|cloudflare|forticlient'; then
  warn "Extensiones de productos corporativos activas:"
  echo "$ext" | grep -Ei 'jumpcloud|netskope|cortex|paloalto|cloudflare|forticlient' | sed 's/^/     /'
else
  ok "Sin extensiones de los productos corporativos conocidos."
fi

# ---------------------------------------------------------------------------
# VEREDICTO
# ---------------------------------------------------------------------------
echo
echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                     VEREDICTO                          ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
echo "   DEP (ADE): $DEP     MDM: $MDM     Agente: $AGENT     PAM jcagent: $PAM_HIT"
echo

if [ "$PAM_HIT" = "yes" ] && [ "$AGENT" = "no" ]; then
  bad "RIESGO DE LOCKOUT: el agente no está pero quedaron líneas jcagent en PAM."
  echo "   → Limpialas AHORA, antes de reiniciar. Ver docs/02-guia-macbook-m4-sin-admin.md (A3)"
  echo "     o corré: sudo bash scripts/remover-jumpcloud-local.sh"
  echo
fi

if [ "$DEP" = "yes" ]; then
  warn "Equipo con enrolamiento AUTOMATIZADO (DEP/ADE: Yes)."
  echo "   No hay baja local soportada. La baja real la hace Apple Business Manager"
  echo "   o Apple Support con prueba de propiedad."
  echo "   → Para borrar + reinstalar evitando el re-enrolamiento: docs/04-dep-borrar-y-reinstalar.md"
  echo "     ANTES de borrar corré:  bash scripts/preflight-inventario.sh  (y verificá Activation Lock)"
  echo "   → Workaround desde Recovery (NO es baja de ABM): scripts/bypass-dep-recovery.sh"
  echo "   → Vía oficial permanente: docs/02 (sección 4) y docs/03."
elif [ "$DEP" = "no" ]; then
  if [ "$MDM" = "yes" ] || [ "$AGENT" = "yes" ]; then
    ok "Ruta SOPORTADA sin admin (tu caso típico):"
    echo "   1) Quitar el agente JumpCloud primero (orden importa por PAM)."
    echo "   2) Quitar el perfil MDM."
    echo "   → Guía:   docs/02-guia-macbook-m4-sin-admin.md"
    echo "   → Script: sudo bash scripts/remover-jumpcloud-local.sh"
  else
    ok "No se detecta MDM activo ni agente JumpCloud. Puede que ya esté limpio."
    echo "   → Repetí este diagnóstico tras reiniciar para confirmar."
  fi
else
  warn "No pude determinar el estado DEP/MDM. Pegá la salida de arriba para revisarla."
fi
echo
