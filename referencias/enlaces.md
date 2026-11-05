# Enlaces de referencia

Revisión documental: **5 de noviembre de 2026**. Se consultaron páginas oficiales y se leyó el código local. No se ejecutaron acciones en macOS ni se accedió a las consolas de la organización. Una página disponible no certifica compatibilidad con una versión instalada que todavía no se conoce.

## JumpCloud

| Fuente oficial | Uso en la guía |
|---|---|
| [Install or Uninstall the JumpCloud Agent](https://jumpcloud.com/support/install-the-agent) | Página vigente leída: retirada desde consola para equipos activos; desinstalador incluido para el supuesto manual documentado; token si existe protección. El script descargable es de limpieza, no la primera opción. |
| [Un-enroll Mac Computers and Remove Apple MDM](https://jumpcloud.com/support/un-enroll-devices-from-mdm) | Política de inscripción, retirada por API/dispositivo y alcance global de eliminar la configuración MDM. Su ruta UI “Ventura y posteriores” no refleja el cambio de ubicación en Sequoia; contrastar con Apple. |
| [Troubleshoot: Incomplete Mac Agent Uninstall](https://jumpcloud.com/support/troubleshoot-incomplete-agent-uninstall) | Relación entre el orden de retirada, Full Disk Access y PAM; reparación desde Recovery. El nombre de montaje del ejemplo no es universal. |

Se reemplazó el antiguo enlace `https://jumpcloud.com/support/uninstall-the-agent`, que no devolvió contenido legible. No se pudo respaldar la afirmación original sobre la versión 2.21.2 y la conversión a equipo “no gestionado” al borrar un keychain.

## Apple: cuentas, Buscar y Bloqueo de activación

| Fuente oficial | Qué se verificó |
|---|---|
| [Configurar Buscar](https://support.apple.com/102648) ([español](https://support.apple.com/es-es/102648)) | Ruta por iCloud y Ver todo; origen de los dos ejemplos visuales de Tahoe 26. Se leyó la página en inglés y el resultado oficial en español. |
| [Bloqueo de activación en Mac](https://support.apple.com/es-es/102541) | Desactivar Buscar mi Mac mediante iCloud → Ver todo/Mostrar más apps. Se verificó el contenido indexado oficial; la apertura directa devolvió límite de solicitudes. |
| [Servicios de cuentas de Apple administradas](https://support.apple.com/guide/business/service-access-with-managed-apple-accounts-axm171b3ee95/1/web/1) | Buscar no está disponible con una cuenta administrada. Esto no acredita liberación de hardware. |
| [Retirar Bloqueo de activación](https://support.apple.com/en-us/108934) | Ayuda con prueba de compra y contacto con la organización. No establece una garantía de liberación de ABM. |
| [Desactivar Bloqueo de activación desde Apple Business](https://support.apple.com/nl-nl/guide/business/axm812df1dd8/web) | Revisión administrativa del bloqueo y requisito de no haber liberado antes el equipo. Página oficial consultada en inglés aunque el prefijo regional sea `nl-nl`. |
| [Información del Sistema](https://support.apple.com/es-lamr/guide/mac-help/syspr35536/27/mac/27) | Cómo abrir el reporte. No se verificó que un campo de Bloqueo de activación aparezca en todas las versiones: su ausencia no se interpreta como “Disabled”. |

## Apple: inscripción, perfiles y borrado

| Fuente oficial | Qué se verificó |
|---|---|
| [Automated Device Enrollment](https://support.apple.com/en-by/guide/deployment/dep73069dd57/web) | Opción de impedir retirada del perfil e inscripción exigida en macOS 14 o posterior. No respalda una garantía de bypass por hosts. |
| [Liberar dispositivos en Apple Business](https://support.apple.com/guide/business/release-devices-axmec4d28461/1/web/1) | Ruta actual Devices → Inventory → Release from Organization; estado Released y borrado/restauración posterior. Contenido oficial indexado verificado; algunas aperturas directas devolvieron HTTP 429. |
| [Cambios para empresas en macOS Sequoia](https://support.apple.com/en-gb/121011) | En macOS 15, Profiles pasó a General → Device Management. |
| [Device Management en macOS 26](https://support.apple.com/en-gb/guide/mac-help/mh35474/26/mac/26) | Selección del perfil y control de eliminación; puede requerirse el administrador. |
| [Ubicación de perfiles según macOS](https://support.apple.com/en-gu/102192) | El apartado final distingue Sequoia 15, Ventura/Sonoma y versiones anteriores. Se usa para resolver diferencias de ubicación, no como procedimiento de baja de JumpCloud. |
| [Revisar y eliminar perfiles](https://support.apple.com/guide/personal-safety/review-and-delete-configuration-profiles-ips327569a75/web) | Efectos de quitar un perfil y sus ajustes/datos. La ruta genérica de esa página debe contrastarse con las referencias de versión anteriores. |
| [Borrar contenido y configuración (EACS)](https://support.apple.com/102664) | Requisitos, contraseñas, reinicios y activación; conserva macOS. No libera ADE. |
| [Borrar con Utilidad de Discos en chip Apple](https://support.apple.com/es-lamr/102506) | Selección de Macintosh HD, grupo de volúmenes, activación por Internet y regreso a las utilidades para reinstalar. También enlaza cómo entrar a Recovery. |
| [Secure Token, bootstrap token y propiedad del volumen](https://support.apple.com/guide/deployment/use-secure-and-bootstrap-tokens-dep24dbdcf9e/web) | Son conceptos distintos de ser administrador local. Un fallo de FileVault no diagnostica por sí solo la causa. |
| [Alcance de Time Machine](https://support.apple.com/en-in/guide/mac-help/mh35860/mac) | No incluye los archivos de la instalación de macOS. |
| [Snapshots locales](https://support.apple.com/en-ca/102154) | Residen en el disco original; no sustituyen un respaldo externo antes de borrar. |
| [Restaurar desde un respaldo](https://support.apple.com/102551) | Reinstalar si hace falta y recuperar información con Asistente de Migración. |
| [Eliminar usuario o grupo](https://support.apple.com/en-euro/guide/mac-help/mchlp1557/27/mac/27) | Control de información → Delete User y alternativas para la carpeta de inicio. Usar la ayuda de la versión instalada si la pantalla difiere. |

La documentación actual de Apple usa **Apple Business**; el proyecto conserva **ABM** para reconocer el nombre anterior. Las rutas con `/26/` o `/27/` son ediciones de los manuales oficiales consultados; no son una afirmación sobre la versión del equipo ni una validación del bypass en esas ediciones. Algunas traducciones de Apple y rutas genéricas no se actualizan al mismo tiempo.

## Código de terceros y código local

- [assafdori/bypass-mdm](https://github.com/assafdori/bypass-mdm): se leyó el README de origen atribuido por el script. Es de terceros y sus afirmaciones no son documentación oficial de Apple ni prueba de que funcione en tu Mac. No se fijó una revisión ni se estableció equivalencia exacta con la copia local. El README consultado incluso indica conectar a Wi-Fi para activar: no respalda la antigua regla “siempre offline”.
- Se leyeron los cinco archivos de [scripts/](../scripts/), sin ejecutarlos ni modificarlos. Las diferencias relevantes entre su comportamiento y las guías se describen en el [índice](../README.md#estructura), [análisis de bypass](../docs/04-dep-borrar-y-reinstalar.md#método-experimental-incluido-qué-se-pudo-verificar) y [rollback](../docs/05-rollback.md#nivel-2--revisar-los-cambios-locales-del-bypass-sin-borrar).

## Qué falta confirmar en tu equipo

Ya confirmaste administrador local, DEP activo y falta de acceso a TI. Esos datos definen el alcance de la guía; las rutas sin DEP y los procedimientos de consola se retiraron.

1. Versión/build de macOS, idioma y agentes realmente instalados.
2. Estado local actual de MDM y FileVault; DEP ya está confirmado por vos.
3. Tipo de cuenta de Apple, estado de Buscar/Bloqueo de activación y texto exacto cuando falta o falla un control.
4. Opciones reales de soporte ante Apple/JumpCloud sin un contacto de TI, y eventual constancia de resolución del bloqueo y de la asignación/liberación por serie.
5. Compatibilidad real del bypass y recuperación en la versión exacta. Esta revisión documental **no la acredita** y no se realizaron pruebas destructivas para comprobarla.

Ninguno de estos datos impidió corregir la documentación. Deben resolverse antes de usarla para las acciones a las que aplican; no publicar contraseñas, tokens, claves de recuperación ni el inventario completo para hacerlo.
