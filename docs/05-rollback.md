# Rollback — recuperar datos o devolver la Mac

Revisión documental: 5 de noviembre de 2026. Tu situación es administrador local, DEP activo y sin acceso a TI. Esta guía sirve para recuperar datos o revisar cambios si llegaron a realizarse; no indica que debas ejecutar un rollback ahora. Hay tres operaciones distintas: recuperar archivos, volver a gestionar el equipo y deshacer cambios locales. **No existe una reversión completa garantizada del bypass incluido.**

## 0. Punto de recuperación: respaldo externo antes de modificar

Hacé un respaldo externo con Time Machine y verificá archivos de muestra; conservá también la contraseña si está cifrado. No lo describas como una imagen exacta de todo el sistema: Time Machine no incluye los archivos propios de la instalación de macOS. Puede ser necesario reinstalar macOS y luego migrar aplicaciones, cuentas y datos. [Apple: alcance de Time Machine](https://support.apple.com/en-in/guide/mac-help/mh35860/mac).

No uses `tmutil localsnapshot` como respaldo de un borrado: los snapshots locales están en el disco original y se pierden al borrarlo. [Apple: snapshots locales](https://support.apple.com/en-ca/102154).

Restaurar datos no restaura la asignación del número de serie en Apple Business, el estado del servidor MDM ni un código de recuperación que nunca guardaste. Conservar una copia de archivos tampoco garantiza que puedas activar o iniciar la Mac tras borrar: resolvé antes los requisitos de [04](04-dep-borrar-y-reinstalar.md).

Para recuperar datos después de reinstalar, usá [Asistente de Migración con un respaldo Time Machine](https://support.apple.com/102551). Revisá qué cuentas, aplicaciones y ajustes migrás: una restauración puede volver a traer componentes corporativos. Comprobá de nuevo MDM y agentes; no presupongas que el respaldo certifica su retirada.

## Nivel 1 — Borrar para entregar o volver a gestionar

Es una referencia para una posible entrega futura. Volver a gestión necesita coordinación administrativa que hoy no tenés disponible; no es una solución para tu objetivo actual de uso personal.

No se puede prometer que “se re-enrola solo”. Depende de la asignación vigente, un servicio MDM operativo, su configuración y la conectividad. Estar registrado en Apple Business no equivale a estar asignado actualmente a un servidor que responda.

1. Acordá con el receptor si recibirá una Mac personal liberada o una Mac que seguirá gestionada. Si debe quedar personal, la organización tiene que resolver el bloqueo y liberarla **antes** del borrado; dejar el bypass no cumple ese objetivo.
2. Respaldá los archivos que vas a conservar y verificá las credenciales de recuperación.
3. Resolvé Buscar mi Mac/Bloqueo de activación siguiendo [04, Gate 1](04-dep-borrar-y-reinstalar.md#gate-1--buscar-mi-mac-y-bloqueo-de-activación). La ruta incluye **tu nombre → iCloud → Ver todo/Mostrar más apps → Buscar mi Mac**. Cerrar una sesión visible no certifica el estado administrativo del equipo.
4. Si hubo modificaciones en `hosts`, revisarlas según Nivel 2. Su retirada requiere un plan: puede cambiar la conectividad y exponer una inscripción pendiente.
5. Seguí [el borrado oficial de 04](04-dep-borrar-y-reinstalar.md#procedimiento-oficial-una-vez-resueltos-los-requisitos). La activación puede requerir Internet. EACS conserva la versión instalada de macOS: no vuelve necesariamente a la versión de fábrica.
6. Si vas a entregarla sin configurar, no crees otra cuenta personal: al llegar al asistente inicial, apagá como indica Apple. Si debe volver a gestión, el administrador y el receptor deben completar y verificar la inscripción.

**Remote Management** acredita que aparece un flujo de administración, no que el agente, perfiles y políticas ya estén instalados ni que una baja previa haya sido revertida por completo. Si el MDM de la empresa dejó de funcionar, puede no ser posible terminar la configuración; no borres contando con que esa pantalla será una devolución funcional.

[Apple: borrado y entrega](https://support.apple.com/102664), [Apple: ADE](https://support.apple.com/en-by/guide/deployment/dep73069dd57/web).

## Nivel 2 — Revisar los cambios locales del bypass, sin borrar

Al leer [el script incluido](../scripts/bypass-dep-recovery.sh), se observaron estos cambios posibles. No se verificó cuáles llegaron a realizarse en tu Mac:

| Cambio | Alcance de una posible reversión |
|---|---|
| Volumen de datos renombrado a `Data` | El rollback no restaura su nombre previo. Se necesita conocer el nombre y el volumen originales. |
| Cuenta temporal en Directory Services y carpeta de usuario | El rollback no la elimina. El default local es `macadmin` / nombre `Mac Admin`, no `Apple`; puede haberse cambiado en las preguntas o variables. |
| Líneas en `hosts` | El rollback solo intenta quitar líneas que empiezan con `0.0.0.0` seguidas de determinados dominios. No restaura el archivo completo ni prueba que esas líneas fueran del bypass. |
| `.AppleSetupDone` | El rollback no lo cambia. No lo borres como método genérico de recuperación: puede alterar el flujo de configuración. |
| Marcadores en `ConfigurationProfiles/Settings` | Se crean y se borran archivos. Sin copia del estado anterior no hay una reversión exacta documentada. No se confirmó que “se regeneran solos”. |

El script de rollback hace una copia del `hosts` actual antes de editarlo. Para inspeccionar **solo lo que ese script detectaría**, desde la carpeta del proyecto:

```bash
sudo bash scripts/rollback-local.sh --dry-run
```

Si se decide retirar esas líneas tras revisarlas y resolver el estado de inscripción, su modo de escritura es:

```bash
sudo bash scripts/rollback-local.sh
```

Esto es una modificación local de red; no reinstala JumpCloud, no recupera los marcadores anteriores ni libera Apple Business. Su búsqueda y borrado usan patrones sin límite final de nombre de dominio: revisá cada línea detectada, incluidos alias o dominios con sufijos, antes de confirmar. “No hay bloqueo” significa que no encontró **sus patrones**, no que no exista ningún bloqueo por hosts, DNS, filtro o red.

Si se va a eliminar una cuenta temporal, identificarla primero y hacerlo desde **otra cuenta administradora funcional**, con respaldo y acceso a FileVault comprobados. En versiones recientes, **Usuarios y grupos → información de la cuenta → Eliminar usuario**; otras versiones usan “−”. Si el control no aparece, consultar la ayuda de esa versión en lugar de borrar su carpeta a mano. [Apple: eliminar usuarios](https://support.apple.com/en-euro/guide/mac-help/mchlp1557/27/mac/27).

## Qué no se puede garantizar

- Reconstruir el estado previo exacto sin un respaldo adecuado y registros de lo cambiado.
- Volver a gestionar un equipo si las consolas, credenciales o servicios ya no funcionan.
- Quitar la asignación de Apple Business mediante cambios locales.
- Que retirar tres líneas de hosts reactive o desactive ADE de inmediato.
- Que una copia de datos recupere una Mac detenida por Bloqueo de activación.

## Resumen

| Querés… | Qué hace falta |
|---|---|
| Recuperar archivos | Respaldo externo verificado y método de restauración compatible. |
| Devolverla gestionada | Coordinación y verificación con el administrador receptor; Nivel 1. |
| Entregarla para uso personal sin gestión | Resolver bloqueo y liberación administrativa, luego borrar/restaurar. |
| Retirar solo líneas de hosts | Revisar el alcance limitado del Nivel 2. |
| Saber si quedó realmente dada de baja | Coincidencia entre comprobación local y confirmación de las consolas. |
