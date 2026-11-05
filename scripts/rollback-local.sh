#!/bin/bash
# ==============================================================================
#  rollback-local.sh
#
#  Deshace los cambios LOCALES del bypass de DEP/MDM, principalmente el bloqueo
#  de los dominios de enrolamiento de Apple en /etc/hosts. Hace copia de
#  respaldo antes de tocar nada.
#
#  OJO: quitar el bloqueo RE-EXPONE el equipo al re-enrolamiento ADE. Usalo solo
#  si querés volver al estado gestionado o entregar la Mac. Si querés seguir
#  usándola sin MDM, NO corras esto: dejá el bloqueo puesto.
#
#  NO borra el usuario admin temporal (eso se hace a mano desde
#  System Settings → Users & Groups, logueado desde OTRA cuenta admin).
#  Para el rollback completo (volver a gestionado/fábrica) ver docs/05-rollback.md.
#
#  USO:
#     sudo bash scripts/rollback-local.sh            # interactivo
#     sudo bash scripts/rollback-local.sh --dry-run  # solo muestra qué haría
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
confirm() { local a; read -r -p "$(echo -e "${YEL}»${NC} $1 [s/N]: ")" a; [[ "$a" =~ ^([sS]|[sS][iI]|[yY]|[yY][eE][sS])$ ]]; }

DRY=0
[ "${1:-}" = "--dry-run" ] && DRY=1

[ "$(uname -s)" = "Darwin" ] || die "Esto corre en macOS. Estás en $(uname -s)."
[ "$(id -u)" = "0" ] || die "Necesita root. Corré:  sudo bash scripts/rollback-local.sh"

DOMAINS=(deviceenrollment.apple.com mdmenrollment.apple.com iprofiles.apple.com)
HOSTS=/etc/hosts

echo
echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   Rollback local del bypass (bloqueo en /etc/hosts)   ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
echo

warn "Quitar el bloqueo RE-EXPONE el equipo al re-enrolamiento ADE."
warn "Si querés seguir usando la Mac SIN MDM, cancelá y no toques nada."
echo

# Mostrar qué líneas de bloqueo hay
found=0
say "Líneas de bloqueo encontradas en $HOSTS:"
for d in "${DOMAINS[@]}"; do
  esc="${d//./\\.}"
  if grep -qE "^[[:space:]]*0\.0\.0\.0[[:space:]]+$esc" "$HOSTS" 2>/dev/null; then
    grep -nE "^[[:space:]]*0\.0\.0\.0[[:space:]]+$esc" "$HOSTS" | sed 's/^/     /'
    found=1
  fi
done
if [ "$found" = "0" ]; then
  ok "No hay bloqueo de dominios de enrolamiento en $HOSTS. Nada que revertir."
  exit 0
fi
echo

if [ "$DRY" = "1" ]; then
  say "(--dry-run) No se modifica nada. Se quitarían las líneas de arriba."
  exit 0
fi

confirm "¿Quitar esas líneas de $HOSTS? (se guarda copia de respaldo)" || { say "Cancelado. No se tocó nada."; exit 0; }

ts="$(date +%Y%m%d-%H%M%S)"
cp -p "$HOSTS" "$HOSTS.bak-$ts" || die "No pude hacer backup de $HOSTS"
ok "Backup: $HOSTS.bak-$ts"

for d in "${DOMAINS[@]}"; do
  esc="${d//./\\.}"
  sed -i '' "/^[[:space:]]*0\.0\.0\.0[[:space:]][[:space:]]*$esc/d" "$HOSTS"
done

# Verificación
left=0
for d in "${DOMAINS[@]}"; do
  esc="${d//./\\.}"
  grep -qE "^[[:space:]]*0\.0\.0\.0[[:space:]]+$esc" "$HOSTS" 2>/dev/null && { bad "Todavía está: $d"; left=1; }
done
[ "$left" = "0" ] && ok "Bloqueo removido de $HOSTS."

echo
say "Pendientes que NO automatizo (ver docs/05-rollback.md):"
echo "   • Borrar el admin temporal: System Settings → Users & Groups (desde OTRA cuenta admin)."
echo "   • Rollback completo a gestionado/fábrica: erase online sin bloqueo (Nivel 1)."
echo
warn "Si el equipo queda online, Apple puede re-enrolarlo en el próximo check-in."
