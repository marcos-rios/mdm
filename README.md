# Dejar la Mac limpia desde cero y sin control corporativo

Guía para borrar la instalación actual, reinstalar macOS, configurar la Mac como nueva y retirar toda la gestión corporativa que pueda resolverse y verificarse.

Revisión documental: **5 de noviembre de 2026**. Se revisaron los archivos y las fuentes enlazadas; no se ejecutaron los procedimientos en una Mac.

## Situación confirmada por vos

- Tenés una cuenta **administradora local**.
- El equipo tiene **DEP/ADE activo** (`Enrolled via DEP: Yes`).
- **No tenés acceso a alguien de TI** que gestione la baja desde las consolas.
- Indicás **macOS Sequoia 15**, actualizado dentro de esa versión; falta el número/build exacto.
- No tenés iniciada sesión en **iCloud/cuenta de Apple**, según tu respuesta sobre ese panel.

## Qué cuenta como objetivo cumplido

- macOS reinstalado y configurado como nuevo, con tu cuenta local.
- Sin restaurar las cuentas, aplicaciones ni configuraciones corporativas del sistema anterior.
- Sin inscripción MDM, perfiles ni agentes corporativos en la instalación nueva.
- Número de serie liberado de la organización en Apple Business/ABM y sin Bloqueo de activación ajeno pendiente.
- Funcionamiento normal conectado a Internet, sin depender de bloqueos de red o cambios de `hosts` para omitir la inscripción.

Una limpieza local con DEP todavía sin resolver es un **resultado parcial**. No se dará por terminada como “sin control corporativo”. La guía parte de tu acceso local y la falta de TI; el estado MDM y el Bloqueo de activación siguen por comprobar.

El contexto anterior indica que la empresa cerró y cedió los equipos. Conservá la documentación de esa cesión.

## Empezá por acá

Leé la [guía principal para tu caso](docs/04-dep-borrar-y-reinstalar.md). Incluye:

1. Qué podés comprobar con tu acceso local, sin modificar la gestión.
2. Cómo encontrar Buscar mi Mac y qué hacer si no aparece.
3. Qué falta resolver antes de borrar y qué puede consultarse al soporte de Apple o JumpCloud sin contar con TI.
4. Borrado y reinstalación, configuración como nueva y comprobaciones finales.
5. Qué hace el bypass incluido y por qué no acredita la desvinculación completa.

**Tener administrador local no acredita una liberación de Apple Business/ABM. Borrar tampoco libera el número de serie.** El bypass sigue sin estar validado para tu versión; no se presenta como una solución garantizada. [Apple: ADE](https://support.apple.com/en-by/guide/deployment/dep73069dd57/web), [Apple: liberar dispositivos](https://support.apple.com/guide/business/release-devices-axmec4d28461/1/web/1).

## Estructura

| Archivo | Propósito |
|---|---|
| [04 — Guía principal](docs/04-dep-borrar-y-reinstalar.md) | Sequoia 15, admin local, DEP y sin TI: requisitos, reinstalación desde cero y criterios de desvinculación completa. |
| [05 — Recuperación y rollback](docs/05-rollback.md) | Recuperar datos y revisar cambios locales; límites de una eventual entrega. |
| [06 — Checklist de Recovery](docs/06-checklist-recovery.md) | Hoja de consulta; el borrado queda condicionado a resolver los requisitos. |
| [Imágenes](docs/imagenes/README.md) | Procedencia y versión de los ejemplos oficiales. |
| [Referencias](referencias/enlaces.md) | Fuentes y límites de verificación. |

Se retiraron las guías 01, 02 y 03 para concentrar la documentación en tu situación. Se conservaron los números 04–06 para mantener las rutas ya usadas por los scripts.

Los cinco scripts siguen en [scripts/](scripts/), sin cambios ni ejecuciones. **Sus comentarios y mensajes son anteriores a esta reorganización y pueden citar las guías retiradas o recomendar recorridos que no aplican a tu caso.** Usá esta documentación para interpretar su alcance:

| Script | Alcance y límites observados al leerlo |
|---|---|
| [diagnostico.sh](scripts/diagnostico.sh) | Consulta el estado local. Oculta algunos errores y busca nombres conocidos; sus conclusiones no certifican una baja. Con `sudo`, la comprobación de usuario corresponde a root. |
| [preflight-inventario.sh](scripts/preflight-inventario.sh) | Consulta el sistema **y escribe un `.txt`**. Su ruta a Buscar mi Mac está incompleta: usar [04](docs/04-dep-borrar-y-reinstalar.md). Con `sudo` registra root y puede cambiar la carpeta de salida. |
| [remover-jumpcloud-local.sh](scripts/remover-jumpcloud-local.sh) | Script del proyecto para retirada local del agente; **no es el recorrido para resolver tu DEP**. Puede modificar PAM y avanzar al paso MDM aunque el agente permanezca. |
| [bypass-dep-recovery.sh](scripts/bypass-dep-recovery.sh) | Modifica volúmenes, cuentas, hosts y marcadores. Compatibilidad y resultado no verificados; análisis en [04](docs/04-dep-borrar-y-reinstalar.md). |
| [rollback-local.sh](scripts/rollback-local.sh) | Retira determinadas líneas de hosts. No revierte todos los cambios ni garantiza re-enrolamiento; ver [05](docs/05-rollback.md). |

## Si falla el login

La [guía principal conserva la reparación de PAM](docs/04-dep-borrar-y-reinstalar.md#si-quedaste-sin-poder-iniciar-sesión) que antes estaba en 02. Es una recuperación condicional tras una retirada incompleta del agente, no un paso que debas ejecutar ahora.
