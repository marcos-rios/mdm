# Limpiar la Mac desde cero y retirar el control corporativo

Revisión documental: 5 de noviembre de 2026. **Objetivo: borrar la instalación anterior, reinstalar macOS y configurar una Mac personal sin MDM, agentes, perfiles ni una asignación corporativa de DEP/ADE pendiente.** Borrar o ejecutar el bypass incluido no acredita por sí solo ese resultado.

## Resultado buscado y cómo comprobarlo

| Parte del objetivo | Comprobación necesaria |
|---|---|
| Empezar de cero | Borrado de la instalación identificada, reinstalación y cuenta nueva mediante el asistente normal. |
| No traer de vuelta la instalación corporativa | Configurar sin transferir cuentas, apps y ajustes anteriores; recuperar solo archivos personales seleccionados. |
| Retirar el control local | MDM sin inscripción informada, sin perfiles corporativos y sin sus agentes, extensiones o configuraciones de red en la instalación nueva. |
| Resolver DEP/ADE de forma duradera | Constancia de liberación del número de serie en Apple Business/ABM. El estado local y llegar al escritorio no sustituyen esa constancia. |
| Conservar el acceso | Sin Bloqueo de activación ajeno pendiente y con credenciales propias de la cuenta y recuperación. |
| Usar normalmente la Mac | Configuración y funcionamiento con Internet, sin bloqueos de dominios ni marcadores de bypass como condición para evitar la gestión. |

Si solo se limpia el disco pero sigue sin resolverse la asignación corporativa, se registra como **limpieza local parcial, DEP pendiente**. El objetivo completo no se marca como logrado. [Apple: liberación y borrado posterior](https://support.apple.com/guide/business/release-devices-axmec4d28461/1/web/1), [Apple: ADE](https://support.apple.com/en-by/guide/deployment/dep73069dd57/web).

## Tu situación y el siguiente paso

**Confirmado por vos:** tenés administrador local, DEP/ADE activo y no tenés acceso a alguien de TI. Indicás macOS Sequoia 15 actualizado dentro de esa versión y ninguna sesión de iCloud/cuenta de Apple iniciada. No se interpreta “última versión de Sequoia” como otra versión mayor de macOS. El modelo M4 proviene del contexto anterior; falta el número/build exacto para ajustar diferencias puntuales.

Con ese acceso, lo siguiente es registrar la información que falta y preparar un respaldo, sin retirar perfiles, agentes ni borrar la Mac. En Terminal, estas consultas son de lectura:

```bash
sw_vers
profiles status -type enrollment
fdesetup status
```

`sw_vers` da la versión/build; `profiles` informa la inscripción local y `fdesetup status` el estado de FileVault. Un error queda pendiente, no equivale a “No”. El estado MDM y el de los agentes no se deducen solo de DEP. No hace falta publicar el número de serie.

Después, revisá Buscar mi Mac/Bloqueo de activación con Gate 1. **No desinstales JumpCloud como intento de liberar DEP:** son tareas distintas. Quitar MDM antes de que el agente limpie PAM puede afectar el login. [JumpCloud: desinstalación incompleta](https://jumpcloud.com/support/troubleshoot-incomplete-agent-uninstall).

Sin TI disponible, podés consultar directamente al soporte de Apple y JumpCloud qué opciones y documentos aceptan para un equipo cedido por una empresa cerrada. La ayuda para Bloqueo de activación no garantiza una liberación de ABM. [Apple: solicitud de ayuda](https://support.apple.com/en-us/108934), [JumpCloud: documentación del agente](https://jumpcloud.com/support/install-the-agent).

Por ahora no hay una secuencia validada que permita prometer que, tras borrar, podrás usar esta Mac sin re-enrolamiento. El apartado de borrado más abajo queda como referencia condicionada; no es el siguiente paso de tu situación actual.

## Qué logra esto y qué no

- Un borrado elimina datos locales; **no libera** el número de serie de Apple Business (antes Apple Business Manager, ABM).
- Desinstalar JumpCloud, retirar MDM, liberar el número de serie y resolver Bloqueo de activación son tareas diferentes.
- Apple indica borrar y restaurar después de liberar un equipo. La organización debe resolver el Bloqueo de activación **antes** de liberarlo, porque luego pierde la posibilidad de gestionarlo desde ese servicio. [Apple: liberar dispositivos](https://support.apple.com/guide/business/release-devices-axmec4d28461/1/web/1).
- No se validó que el script de terceros evite ADE en tu versión. Apple documenta una experiencia de inscripción obligatoria en macOS 14 o posterior para equipos registrados que no se inscribieron durante la configuración inicial; llegar al escritorio no prueba una baja permanente. [Apple: ADE](https://support.apple.com/en-by/guide/deployment/dep73069dd57/web).

## Requisitos antes de borrar

El borrado es irreversible para los datos de ese disco. Si algo está pendiente, conservá la instalación actual y resolvelo antes de iniciar un borrado. No uses el asistente de borrado como prueba del estado del bloqueo.

### Gate 1 — Buscar mi Mac y Bloqueo de activación

**En tu caso no hay sesión de cuenta de Apple iniciada:** puede no aparecer tu nombre ni el acceso a iCloud. No necesitás iniciar sesión para seguir este diagnóstico. Esa ausencia no certifica que no exista Bloqueo de activación de una cuenta anterior ni resuelve DEP. Registrá lo que muestre el sistema y aclaralo con soporte antes de borrar si el bloqueo sigue sin poder confirmarse.

La ruta siguiente sirve si sí hay una cuenta iniciada; no es un requisito para que inicies una ahora. **Buscar mi Mac se encuentra dentro de iCloud**, no directamente debajo del nombre. Según la versión:

1. Abrí **Configuración/Ajustes del Sistema (System Settings)** desde el menú Apple.
2. Entrá en **tu nombre → iCloud**.
3. En **Guardado en iCloud (Saved to iCloud)**, pulsá **Ver todo (See All)**. En otras versiones puede decir **Mostrar más apps (Show More Apps)**.
4. Desplazate por la lista y abrí **Buscar mi Mac (Find My Mac)**.
5. Leé su estado. Para desactivarlo antes de ceder o borrar la Mac, usá el control de desactivación y la contraseña de la **cuenta de Apple que lo tiene asociado**; confirmá que quede desactivado. Si no se puede, conservá el mensaje.

La desactivación de Buscar es el método que Apple documenta para retirar el Bloqueo de activación personal. No basta con apagar solo **Red de Buscar (Find My network)**. [Apple: Bloqueo de activación en Mac](https://support.apple.com/es-es/102541).

**Ejemplos oficiales de macOS Tahoe 26 en inglés; tu sistema informado es Sequoia 15 y no tiene una sesión de Apple iniciada. Estas imágenes solo orientan sobre el panel con cuenta iniciada; no representan tu pantalla.** En el primero, Apple resalta “See All”; en el segundo, la fila “Find My Mac” está desactivada en el equipo de ejemplo.

![Ejemplo de Apple: iCloud en macOS Tahoe 26, con See All resaltado](https://cdsassets.apple.com/live/7WUAS350/images/icloud/macos-tahoe-26-system-settings-apple-account-icloud-see-all-magnifier.png)

![Ejemplo de Apple: Saved to iCloud en macOS Tahoe 26, con Find My Mac en la lista](https://cdsassets.apple.com/live/7WUAS350/images/icloud/find-my/macos-tahoe-26-system-settings-apple-account-icloud-plus-see-all-find-my-mac-off.png)

Fuente: [Apple, configurar Buscar](https://support.apple.com/102648). [Procedencia y disponibilidad de las imágenes](imagenes/README.md). Son imágenes externas: para consultarlas sin red, guardá la página o una copia de las imágenes previamente.

**Si aparece algo diferente:**

| Lo que ves | Qué permite concluir y cómo seguir |
|---|---|
| No aparece tu nombre o pide iniciar sesión | No hay una sesión de cuenta personal visible en ese panel. Eso solo no prueba ausencia de Bloqueo de activación. No inicies sesión como método de diagnóstico. |
| No encontrás Buscar mi Mac | Revisá iCloud, Ver todo/Mostrar más apps y el desplazamiento de la lista. Anotá macOS y el tipo de cuenta; la ausencia no significa “desactivado”. |
| Cuenta de Apple administrada por una organización | Las cuentas administradas no pueden usar Buscar; eso no demuestra que el hardware esté libre de un bloqueo previo. [Apple: servicios de cuentas administradas](https://support.apple.com/guide/business/service-access-with-managed-apple-accounts-axm171b3ee95/1/web/1). |
| Control deshabilitado, restricciones o error | Puede haber una limitación administrativa o de cuenta. No diagnostiques la causa solo por el control; se necesita revisar el mensaje y la gestión. |
| Buscar mi Mac aparece desactivado | Es el estado de esa función mostrado en esa cuenta/sesión; no es un certificado de liberación de ABM. |
| Pide una cuenta que no es tuya al activar | No se puede deducir que sea un bloqueo “de organización”: también puede ser una cuenta personal anterior. No pruebes credenciales ajenas; solicitá la retirada al titular o asistencia con prueba de compra. |

**General → Acerca de/Información (About)** muestra datos del equipo, pero no es una comprobación universal de Bloqueo de activación. Podés abrir **Información del Sistema (System Information)** con Opción + menú Apple y revisar Hardware; si tu versión muestra un campo de estado de activación, registralo como dato adicional. La presencia, ausencia o traducción de ese campo no se verificó para tu instalación. No uses un campo ausente como resultado “Disabled”. [Apple: abrir el informe del sistema](https://support.apple.com/es-lamr/guide/mac-help/syspr35536/27/mac/27).

Si existe gestión corporativa, la organización debe comprobar el bloqueo en su consola y resolverlo antes de liberar la Mac. Si no hay acceso, queda pendiente: una carta de cesión puede ayudar a documentar propiedad, pero no asegura que Apple acepte una solicitud ni que libere ABM. [Apple: retirar Bloqueo de activación](https://support.apple.com/en-us/108934), [Apple: control del bloqueo desde Apple Business](https://support.apple.com/nl-nl/guide/business/axm812df1dd8/web).

### Gate 2 — Backup verificado e inventario

- Hacé una copia externa con Time Machine como recuperación de emergencia y una copia aparte de tus archivos personales. Comprobá archivos de muestra y conservá la contraseña del respaldo cifrado. Para la instalación limpia, recuperá solo los archivos que elijas; no migres automáticamente las apps, cuentas ni ajustes de la Mac corporativa.
- No cuentes un snapshot local como respaldo para un borrado: está en el mismo disco. Tampoco supongas que Time Machine reconstruirá exactamente el sistema y la gestión; ver [05](05-rollback.md).
- Opcionalmente, desde la carpeta del proyecto:

```bash
bash scripts/preflight-inventario.sh
```

Ese script consulta el sistema y **escribe un `.txt`** en `~/Desktop` por defecto. Sin `sudo` no incluye el listado completo de perfiles; puede omitir consultas que fallen. Su ruta impresa hacia Buscar mi Mac está incompleta: usá Gate 1. Si hace falta el inventario privilegiado, pasá una ruta de salida absoluta que exista y sea distinta de una copia anterior; con `sudo`, no des por hecho el directorio personal ni el usuario que quedarán registrados.

Copiá el informe fuera de la Mac. Incluye serie, usuarios y redes: guardalo de forma privada. No confirma recuperación, baja MDM ni ausencia de bloqueo.

### Gate 3 — Propiedad, credenciales y estado administrativo

- Conservá prueba de compra/cesión y acceso a tu cuenta de Apple, su contraseña y segundo factor, si corresponde.
- Confirmá que los datos necesarios ya están respaldados y que podés recuperar el respaldo.
- Para una cesión definitiva sin gestión, pedí constancia de liberación por número de serie y resolución del bloqueo. La baja de JumpCloud no sustituye esto. Si nadie puede confirmarlo, **no hay una ruta de borrado sin re-enrolamiento validada en este repositorio**.

## Procedimiento oficial, una vez resueltos los requisitos

### Paso 1 — Preparar la baja

**Este paso está pendiente en tu situación:** no tenés una persona de TI disponible. Consultar a Apple/JumpCloud sobre un equipo cedido y las opciones de soporte no implica que la baja esté resuelta. No asumir que el perfil se volvió inofensivo por el cierre de la empresa.

Solo si se obtiene una resolución verificable del bloqueo y de la asignación/liberación, se puede evaluar el borrado oficial descrito a continuación. Tener admin local no reemplaza esa resolución. No se incluye una ruta de consola que hoy no podés realizar.

### Paso 2 — Elegir el método de borrado

**Recorrido principal para tu objetivo:** borrar la instalación mediante Recovery y reinstalar macOS con el paso 3; después configurarla como nueva. No es necesario desinstalar manualmente cada agente del sistema anterior para seguir ese recorrido una vez resueltos los requisitos. El borrado no resuelve por sí mismo la asignación de Apple.

Como alternativa para borrar datos y ajustes conservando el sistema ya instalado, en Apple Silicon con un sistema funcional, Apple ofrece **Borrar contenido y configuración (Erase All Content and Settings)**. En macOS 13 o posterior: **Configuración del Sistema → General → Transferir o restablecer (Transfer or Reset) → Borrar contenido y configuración**.

El asistente puede pedir contraseña administradora, mostrar qué eliminará y pedir la cuenta de Apple para cerrar sesión. Después reinicia y puede solicitar red para activar la Mac. **EACS conserva el macOS instalado; no es una reinstalación completa ni retira por sí mismo ADE.** En Monterey 12, la opción está en el menú de Preferencias del Sistema y solo existe en modelos compatibles; esa versión no es una instrucción de instalación para una M4. [Apple: EACS y requisitos](https://support.apple.com/102664).

### Paso 3 — Recovery y reinstalación, si hacen falta

Para el recorrido de borrado y reinstalación desde cero, seguir [la guía de Apple para chip Apple](https://support.apple.com/es-lamr/102506), con los requisitos anteriores resueltos:

1. Apagar, mantener presionado el encendido hasta las opciones de arranque y elegir **Options → Continue**. Seleccionar usuario y contraseña si se solicitan.
2. Abrir **Utilidad de Discos → Continuar**. Identificar la instalación interna afectada. La guía de Apple selecciona **Macintosh HD**, no el contenedor APFS completo ni el dispositivo físico.
3. Usar **Borrar**, nombre `Macintosh HD`, formato APFS; elegir **Borrar grupo de volúmenes** si aparece. La eliminación de volúmenes internos adicionales exige identificarlos antes: no borrar discos externos ni imágenes de Recovery por parecido de nombre.
4. Completar las confirmaciones de borrado y cuenta que correspondan. Al reiniciar puede pedir idioma y **conexión a Internet para activar**.
5. Tras activar, elegir **Salir e ir a las Utilidades de Recuperación** y **Reinstalar macOS**, si esa es la ruta elegida. Seguir las pantallas y no interrumpir la instalación.

Se retiró la instrucción de mantener el equipo offline y conectar solo para descargar: no describe correctamente el flujo de activación. Si el disco no aparece, el borrado falla o hay una cuenta desconocida, detener el procedimiento y seguir la resolución específica de Apple.

### Paso 4 — Completar la configuración y comprobar

Completá el asistente normal y creá tu cuenta local. Cuando ofrezca transferir información desde otra Mac o Time Machine, elegí continuar sin transferirla; la etiqueta exacta depende de la versión. Reinstalá tus aplicaciones desde sus fuentes oficiales y copiá únicamente los documentos personales que quieras conservar. No restaures íntegramente el respaldo corporativo como parte de esta limpieza: Asistente de Migración puede transferir apps, cuentas y ajustes. [Apple: alcance de la migración](https://support.apple.com/102613).

Si aparece **Administración remota (Remote Management)** para la empresa anterior, registrar el mensaje: la baja administrativa sigue sin resolverse; no usar el bypass como paso automático de reparación.

Después del inicio, sin aplicar bloqueos de red ni scripts de bypass, registrá estas consultas de lectura:

```bash
profiles status -type enrollment
sudo profiles list
systemextensionsctl list
```

Para considerar terminada la parte local, MDM debe informar que no hay inscripción y no deben aparecer perfiles corporativos. Revisá también **Configuración del Sistema → General → Administración de dispositivos (Device Management)** en Sequoia 15; si el panel falta, contrastá con la consulta en lugar de deducir el estado solo por la interfaz. [Apple: ubicación del panel en Sequoia](https://support.apple.com/en-gb/121011).

Revisá aplicaciones, ítems de inicio/extensiones y VPN, filtros, proxy o DNS que pudieran haber vuelto mediante una transferencia o instalación posterior. Un listado de extensiones puede incluir componentes legítimos; identificá cada uno y leé su estado, sin borrar por parecido de nombre. Una búsqueda vacía por nombres conocidos no acredita por sí sola ausencia de todo control.

Probá login, conexión fuera de redes corporativas, FileVault y recuperación. Reiniciá y volvé a comprobar la inscripción y los perfiles. Registrá ambas líneas DEP/MDM: `MDM: No` no prueba liberación del número de serie. Si DEP sigue indicando `Yes` o aparece Remote Management, la desvinculación queda pendiente aunque puedas usar el escritorio. [Apple: inscripción automatizada](https://support.apple.com/en-by/guide/deployment/dep73069dd57/web).

### Cierre del objetivo

- [ ] macOS reinstalado y configurado como nuevo, sin migrar el entorno corporativo.
- [ ] Sin inscripción MDM ni perfiles corporativos, con consultas completadas sin errores.
- [ ] Sin agentes, extensiones ni configuraciones corporativas identificadas en la instalación nueva.
- [ ] Bloqueo de activación ajeno resuelto y recuperación propia conservada.
- [ ] Liberación de Apple Business/ABM confirmada por serie.
- [ ] Uso normal con Internet, sin depender de un bypass para evitar inscripción.

Si falta una confirmación, anotá el punto exacto pendiente. **“Quité lo posible localmente” no se convierte en “Mac completamente desvinculada” mientras DEP o un control corporativo siga sin resolverse.**

## Método experimental incluido: qué se pudo verificar

**Este apartado no define un resultado final aceptado como “sin control corporativo”.** Describe el código existente y sus límites.

Se conserva [bypass-dep-recovery.sh](../scripts/bypass-dep-recovery.sh) como código existente del proyecto. **Se leyó, no se ejecutó ni se certificó para una M4 o una versión de macOS.** El origen atribuido en sus comentarios es [assafdori/bypass-mdm](https://github.com/assafdori/bypass-mdm); no se comprobó que esta copia coincida con una revisión concreta del original.

| Elemento | Comportamiento observado al leer el archivo |
|---|---|
| Intérprete | Tiene shebang de Bash y usa arrays, `select` y `[[ ... ]]`. Si se estudia su invocación, corresponde Bash; no se debe presentar `sh` como portable. |
| Volúmenes | Los busca por nombres y carpetas; puede renombrar el volumen de datos a `Data`. No garantiza que haya seleccionado la instalación correcta. |
| Cuenta | Modifica la base local de Directory Services. Defaults: nombre `Mac Admin`, usuario `macadmin`, contraseña `changeme`. Las variables `BYPASS_REALNAME`, `BYPASS_USER` y `BYPASS_PASS` solo cambian valores por defecto: siguen existiendo preguntas interactivas. |
| Contraseña | Se pide y se imprime sin ocultarla. No usar credenciales reales ni asumir que quedan fuera del historial o de una captura. |
| Red | Intenta añadir tres dominios a un archivo `hosts` del volumen elegido. Encontrar esas líneas no prueba que el sistema arrancado las esté usando ni que eviten ADE. |
| Configuración | Crea `.AppleSetupDone` y modifica marcadores de `ConfigurationProfiles`. No elimina Bloqueo de activación ni libera un registro en Apple. |
| Resultado | Algunas operaciones solo emiten advertencias; el texto “Completed Successfully” no valida cada cambio ni el resultado después de arrancar. No hay copia integral previa ni transacción de deshacer. |

**Pendiente antes de considerarlo un procedimiento operativo:** versión/build exacta, compatibilidad de escritura y rutas entre Sistema/Datos desde Recovery, selección de volúmenes, creación de cuenta, Secure Token/propiedad del volumen y efecto real de los marcadores/ADE. Esto requiere revisión técnica y pruebas en un entorno autorizado de esa versión; no se resuelve leyendo un mensaje de éxito.

No se mantuvo una secuencia de “borrar y luego probar el bypass”: no hay evidencia suficiente para asegurar recuperación o éxito después del borrado. Tampoco se puede asegurar que solo las actualizaciones mayores cambien su comportamiento.

## Después del primer arranque

- Comprobar login, archivos y conectividad, y registrar cualquier gestión restante.
- Revisar FileVault en **Privacidad y seguridad → FileVault**. Un error al activarlo **no demuestra por sí solo** falta de Secure Token: conservar el error y revisar requisitos, cuenta, políticas y propiedad del volumen. Crear otra cuenta tampoco garantiza resolverlo. [Apple: tokens y propiedad del volumen](https://support.apple.com/guide/deployment/use-secure-and-bootstrap-tokens-dep24dbdcf9e/web).
- No dar por terminada la baja ni desactivar actualizaciones de seguridad para conservar un bypass.
- Para usar Buscar con una cuenta personal, seguir la ruta de Gate 1 y las autorizaciones de Apple una vez aclarada la propiedad y la gestión. Activarlo no elimina la asignación corporativa.

## Si algo sale mal

| Síntoma | Cómo continuar |
|---|---|
| Remote Management reaparece | Verificar la asignación y baja con la organización; no prueba un problema de `hosts`. |
| Pide otra cuenta de Apple | Resolver el bloqueo con su titular o soporte; no identifica automáticamente un bloqueo corporativo. |
| No se puede activar FileVault | Registrar el error y revisar requisitos; no asumir falta de token ni recomendar usarlo sin FileVault como solución. |
| No activa o no reinstala | Comprobar conexión y seguir el error documentado por Apple; ADE y activación no son lo mismo. |
| FileVault desbloquea pero falla el login | Revisar [la reparación de login](#si-quedaste-sin-poder-iniciar-sesión) solo si el problema corresponde a PAM tras la retirada del agente. |
| Se necesita volver atrás | Leer [05](05-rollback.md): restaurar datos no garantiza restaurar gestión ni deshacer todos los cambios. |

## Importante sobre la versión de macOS

Tu versión informada es Sequoia 15; las capturas oficiales de Tahoe 26 son solo ejemplos de otra versión. Para resolver una diferencia puntual de pantalla se necesita el número/build de `sw_vers`, el idioma y el texto exacto visible. No hay sesión de cuenta de Apple iniciada según tu respuesta. Para una baja administrativa se necesita además confirmación de la organización por serie, no una captura sin opción de Buscar.

## Si quedaste sin poder iniciar sesión

Esta reparación se conserva por si una retirada previa del agente dejó el login averiado. No es una instrucción para desinstalar JumpCloud en tu situación actual.


Si FileVault desbloquea pero el login falla después de retirar el agente, puede coincidir con el problema PAM que describe JumpCloud; también hay otras causas. Aplicá esto solo si se confirmó que quedaron referencias al módulo ausente.

1. En Apple Silicon, apagá y mantené presionado el encendido hasta las opciones de arranque. Elegí **Options → Continue**; puede pedir seleccionar un usuario y su contraseña. [Apple: entrar a Recovery](https://support.apple.com/es-lamr/102506).
2. En **Utilidad de Discos (Disk Utility)**, seleccioná el volumen de datos de esa instalación y usá **Montar (Mount)**. Si está cifrado, necesitás una contraseña autorizada de FileVault o su clave de recuperación. No uses Borrar.
3. Abrí **Utilidades → Terminal** en la barra de menús. El artículo de JumpCloud usa `/Volumes/Macintosh HD/etc/pam.d/`. Comprobá que corresponda a la instalación afectada: los nombres, los puntos de montaje y los enlaces hacia Datos pueden diferir. No asumas que `/etc/pam.d` de Recovery es el del sistema instalado.
4. Con la ruta correcta, revisá los archivos. Ejemplo de lectura para el nombre del artículo:

```bash
ls -ld "/Volumes/Macintosh HD/etc/pam.d"
grep -nH 'jcagent' "/Volumes/Macintosh HD/etc/pam.d/authorization"
```

5. Solo en los archivos existentes afectados, guardá una copia y aplicá la reparación documentada. Este es el ejemplo para `authorization`; si el montaje tiene otro nombre, ajustá la ruta comprobada antes de usarlo:

```bash
cp -p "/Volumes/Macintosh HD/etc/pam.d/authorization" "/Volumes/Macintosh HD/etc/pam.d/authorization.antes-reparacion"
sed -i '.bak' '/jcagent/d' "/Volumes/Macintosh HD/etc/pam.d/authorization"
```

6. Revisá también `screensaver`, `screensaver_new`, `screensaver_ls` y `screensaver_new_ls`, uno por uno, con el mismo criterio. No todos tienen que existir. No sobrescribas una copia anterior de recuperación.
7. Volvé a leer los archivos activos para confirmar qué cambió; reiniciá y probá el login solo si la reparación terminó sin errores. Si la ruta no existe, no es escribible o no está claro qué volumen es, detené la edición y buscá asistencia.

[JumpCloud: instrucciones y cinco archivos de PAM](https://jumpcloud.com/support/troubleshoot-incomplete-agent-uninstall). El ejemplo de volumen del proveedor no constituye una ruta verificada para tu instalación.
