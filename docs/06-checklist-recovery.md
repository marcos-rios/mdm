# Checklist imprimible — Recovery en una Mac con chip Apple

Revisión documental: 5 de noviembre de 2026. Consultar [04](04-dep-borrar-y-reinstalar.md) antes de usar esta hoja; guardarla en otro dispositivo o imprimirla. Los nombres entre paréntesis son los controles en inglés. No se confirmó el idioma ni la versión del equipo.

**Tu situación:** administrador local, DEP activo y sin acceso a TI. Las etapas de borrado solo aplican después de resolver los requisitos de la guía principal; no son el siguiente paso disponible ahora.

**Esta hoja no certifica el bypass de terceros. No borrar para probar si funciona.** El borrado no libera ADE y la activación puede requerir Internet.

## Antes de apagar

- [ ] Modelo, versión/build de macOS y estado local de `profiles status -type enrollment` registrados, con errores si los hubo.
- [ ] Respaldo externo comprobado; contraseña de respaldo y recuperación de FileVault disponibles si corresponden.
- [ ] Inventario opcional copiado fuera de la Mac. El script escribe un `.txt`; no acredita una baja ni la ausencia de bloqueo.
- [ ] Buscar mi Mac revisado: **Configuración del Sistema → tu nombre → iCloud → Ver todo/Mostrar más apps → Buscar mi Mac**.
- [ ] Bloqueo de activación resuelto; una opción ausente no se anotó como “desactivado”. Ver [Gate 1 y ejemplos oficiales](04-dep-borrar-y-reinstalar.md#gate-1--buscar-mi-mac-y-bloqueo-de-activación).
- [ ] Bloqueo y asignación/liberación Apple Business/ABM resueltos con constancia verificable. Como no hay TI disponible, consultar opciones al soporte; si siguen sin resolverse, no pasar al borrado.
- [ ] Solo con los requisitos resueltos: método elegido para el uso personal previsto, EACS si corresponde o Recovery/reinstalación.

## A. Entrar a Recovery, si hace falta

- [ ] Apagar. Mantener el botón de encendido hasta opciones de arranque → **Opciones (Options) → Continuar (Continue)**.
- [ ] Seleccionar usuario e introducir su contraseña si se solicita.
- [ ] No confundir montaje/desbloqueo con borrado. Si el objetivo es reparar login, pasar al apartado de reparación, sin borrar.

## B. Borrar por la ruta acordada

- [ ] En un sistema funcional, considerar **General → Transferir o restablecer → Borrar contenido y configuración (Erase All Content and Settings)**. EACS conserva el macOS instalado.
- [ ] Si se usa Recovery: **Utilidad de Discos (Disk Utility) → Continuar**.
- [ ] Identificar **Macintosh HD** de la instalación interna. No seleccionar el contenedor completo ni el dispositivo físico como indicaba la guía anterior.
- [ ] **Borrar (Erase)** → nombre `Macintosh HD`, APFS → **Borrar grupo de volúmenes (Erase Volume Group)** si aparece.
- [ ] Completar las confirmaciones correspondientes. Si pide otra cuenta, no seguir con credenciales ajenas: resolver el bloqueo.

## C. Activar y reinstalar

- [ ] Elegir idioma si se solicita y conectar a Internet cuando lo pida la activación.
- [ ] Después de activar: **Salir e ir a las Utilidades de Recuperación**.
- [ ] Si corresponde reinstalar: **Reinstalar macOS → Continuar** y completar el instalador.
- [ ] Si aparece **Administración remota (Remote Management)** de la empresa anterior, registrar el mensaje y resolver la baja administrativa. No ejecutar el bypass como continuación automática.

## D. Comprobar el resultado

- [ ] Si se va a usar: crear cuenta mediante el asistente normal; probar login, archivos, red y recuperación.
- [ ] Consultar `profiles status -type enrollment` y revisar perfiles y agentes por separado. “MDM: No” no prueba liberación del número de serie.

## Si falla el login tras retirar JumpCloud

FileVault puede desbloquear aunque PAM impida iniciar sesión; ese síntoma solo no confirma la causa.

- [ ] Recovery → Utilidad de Discos → **Montar (Mount)** el volumen de datos correcto; usar contraseña o clave de FileVault si hace falta.
- [ ] **Utilidades → Terminal**. Verificar el punto de montaje y la ruta de PAM de la instalación afectada.
- [ ] Consultar [la reparación de login en la guía principal](04-dep-borrar-y-reinstalar.md#si-quedaste-sin-poder-iniciar-sesión) y la [reparación de JumpCloud](https://jumpcloud.com/support/troubleshoot-incomplete-agent-uninstall). No aplicar un `sed` a una ruta de ejemplo sin identificar primero el volumen.
- [ ] Confirmar archivos afectados, guardar copias y comprobar la reparación antes de reiniciar.

## Para volver atrás

Consultar [05](05-rollback.md). Restaurar datos, quitar líneas de hosts y volver a gestionar son operaciones distintas. El script de rollback no deshace todos los cambios del bypass.

Fuentes: [Apple: EACS](https://support.apple.com/102664), [Apple: Utilidad de Discos en chip Apple](https://support.apple.com/es-lamr/102506), [Apple: ADE](https://support.apple.com/en-by/guide/deployment/dep73069dd57/web).
