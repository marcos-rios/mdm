#!/bin/bash
# ==============================================================================
#  preflight-inventario.sh
#
#  CORRELO ANTES DE BORRAR LA MAC. Es de SOLO LECTURA: no cambia nada.
#  Junta en un .txt el estado y el inventario del equipo (serie, modelo, macOS,
#  FileVault, enrolamiento, apps, usuarios admin, redes, perfiles) para que
#  tengas registro de qué había y qué reinstalar después del wipe.
#
#  IMPORTANTE: después de correrlo, COPIÁ el .txt fuera de la Mac (a un USB,
#  mail o nube), porque vas a borrar el disco.
#
#  USO:
#     bash scripts/preflight-inventario.sh            # guarda en ~/Desktop
#     sudo bash scripts/preflight-inventario.sh       # agrega 'profiles list'
#     bash scripts/preflight-inventario.sh /ruta/salida.txt
# ==============================================================================

set -uo pipefail

[ "$(uname -s)" = "Darwin" ] || { echo "Esto corre en macOS."; exit 1; }

TS="$(date +%Y%m%d-%H%M%S)"
OUT="${1:-$HOME/Desktop/inventario-pre-wipe-$TS.txt}"

# Si la salida es una terminal, mostramos y además guardamos.
exec > >(tee "$OUT") 2>&1

line() { printf '\n========== %s ==========\n' "$1"; }

echo "Inventario pre-wipe — $(date)"
echo "Archivo: $OUT"
echo "ACORDATE de copiar este archivo fuera de la Mac antes de borrar."

line "Equipo"
echo "Usuario actual: $(id -un)  (grupos: $(id -Gn))"
sw_vers 2>/dev/null
echo "Modelo: $(sysctl -n hw.model 2>/dev/null)"
echo -n "Nº de serie: "
ioreg -l 2>/dev/null | awk -F'"' '/IOPlatformSerialNumber/{print $4; exit}'

line "Enrolamiento MDM / DEP"
profiles status -type enrollment 2>/dev/null

line "FileVault"
fdesetup status 2>/dev/null || echo "(no se pudo leer; probá con sudo)"

line "Bloqueo de activación (revisar a mano)"
echo "No hay un comando confiable para esto. Verificá en:"
echo "  System Settings → General → About"
echo "  System Settings → (tu Apple ID) → Find My → Find My Mac"
echo "Si 'Find My Mac' está con TU Apple ID, podés desactivarlo vos."
echo "Si el Bloqueo de activación figura administrado por la organización: NO borres."

line "Usuarios admin (con Secure Token según estado)"
dscl . -read /Groups/admin GroupMembership 2>/dev/null
echo "--- Secure Token por usuario ---"
for u in $(dscl . -list /Users 2>/dev/null | grep -v '^_' | grep -vE '^(daemon|nobody|root)$'); do
  st=$(sysadminctl -secureTokenStatus "$u" 2>&1 | grep -o 'ENABLED\|DISABLED' | head -1)
  [ -n "$st" ] && echo "  $u: $st"
done

line "JumpCloud / agente"
ls -la /opt/jc 2>/dev/null && echo "(agente presente)" || echo "sin /opt/jc"
grep -l jcagent /etc/pam.d/* 2>/dev/null && echo "(hay jcagent en PAM)" || echo "sin jcagent en PAM"

line "Aplicaciones instaladas (/Applications)"
ls -1 /Applications 2>/dev/null

line "Apps corporativas detectadas"
ls -1 /Applications 2>/dev/null | grep -Ei 'jumpcloud|netskope|cortex|traps|paloalto|cloudflare|warp|forticlient|teamviewer|aptidog' || echo "ninguna por nombre conocido"

line "Homebrew (si está)"
command -v brew >/dev/null 2>&1 && { echo "formulae:"; brew list --formula 2>/dev/null; echo "casks:"; brew list --cask 2>/dev/null; } || echo "brew no instalado"

line "Redes / servicios de red"
networksetup -listallnetworkservices 2>/dev/null
echo "--- Wi-Fi conocidas (puede requerir permisos) ---"
networksetup -listpreferredwirelessnetworks en0 2>/dev/null || true

line "VPN / filtros / extensiones de sistema"
systemextensionsctl list 2>/dev/null || echo "(no se pudo listar)"

line "Perfiles de configuración"
if [ "$(id -u)" = "0" ]; then
  profiles list 2>/dev/null
else
  echo "(corré con sudo para 'profiles list')"
fi

line "Recordatorios antes de borrar"
cat <<'EOF'
  [ ] Backup verificado (Time Machine + copia aparte, probada).
  [ ] Este inventario copiado FUERA de la Mac.
  [ ] 'Find My Mac' desactivado con tu Apple ID (o confirmado que es tuyo).
  [ ] Contraseña de tu Apple ID personal a mano.
  [ ] Documentación de la cesión de los equipos guardada.
  [ ] Leíste docs/04-dep-borrar-y-reinstalar.md completo.
EOF

echo
echo "Listo. Guardado en: $OUT"
