# DECISIONS.md

### DEC-0001 - Backend minimo sobre Ether con frontend servido en el mismo proceso

- Fecha: 2026-04-17
- Estado: `accepted`
- Relacionado con specs: `SPEC-0001`
- Relacionado con tareas: `TASK-0001`, `TASK-0002`
- Contexto: el repo empieza vacio y necesita una base pequena para
  validar la idea antes de separar servicios o agregar infraestructura.
- Decision: usar una sola aplicacion Java 21 con Ether para exponer la
  API REST y servir la pagina inicial desde el mismo proceso.
- Consecuencias: menos complejidad operativa y una integracion simple
  entre API y UI; a cambio, el frontend queda acoplado temporalmente al
  backend.
- Reemplaza: `none`

### DEC-0002 - `jte` se usa solo para render HTML; el audio vive en el navegador

- Fecha: 2026-04-17
- Estado: `accepted`
- Relacionado con specs: `SPEC-0001`
- Relacionado con tareas: `TASK-0002`
- Contexto: `jte.gg` es un motor de templates Java, no una libreria de
  reproduccion musical.
- Decision: usar `jte` para renderizar el HTML inicial y delegar la
  reproduccion a JavaScript con Web Audio API.
- Consecuencias: la interfaz inicial es facil de servir desde Java;
  cualquier evolucion de audio avanzada debera ocurrir en el cliente o
  mediante otra integracion dedicada.
- Reemplaza: `none`

### DEC-0003 - `Makefile` para build y `justfile` para operacion

- Fecha: 2026-04-17
- Estado: `accepted`
- Relacionado con specs: `SPEC-0001`
- Relacionado con tareas: `TASK-0001`, `TASK-0002`, `TASK-0003`
- Contexto: se necesita una interfaz operativa simple sin mezclar
  responsabilidades ni duplicar comandos.
- Decision: usar `Makefile` como unica fuente para build y validacion, y
  `justfile` como task runner de entrada. `just` puede delegar en
  `make`, pero `make` no debe depender de `just`.
- Consecuencias: el workflow queda mas claro para humanos y agentes; si
  aparece una nueva tarea de construccion, debe ir primero a `make` y
  exponerse en `just` solo como wrapper cuando haga falta.
- Reemplaza: `none`

### DEC-0004 - El modulo Java vive en `backend/java/ether-music/`

- Fecha: 2026-04-17
- Estado: `accepted`
- Relacionado con specs: `SPEC-0001`
- Relacionado con tareas: `TASK-0001`, `TASK-0002`, `TASK-0003`
- Contexto: la raiz del repo estaba acumulando archivos del modulo Java y
  eso mezcla documentacion, orquestacion y codigo ejecutable.
- Decision: mover `pom.xml` y `src/` a `backend/java/ether-music/` y
  dejar en la raiz solo documentacion y entrypoints operativos.
- Consecuencias: la navegacion del repo queda mas clara; cualquier
  comando o documento que apunte al modulo debe referenciar la nueva
  ruta.
- Reemplaza: `none`

### DEC-0005 - El modulo Java usa Maven Wrapper como entrypoint de build

- Fecha: 2026-04-17
- Estado: `accepted`
- Relacionado con specs: `SPEC-0001`
- Relacionado con tareas: `TASK-0001`, `TASK-0002`, `TASK-0003`
- Contexto: la operacion del modulo no debe depender de la version de
  Maven instalada globalmente en cada maquina.
- Decision: ejecutar build, test y run del modulo mediante `./mvnw`
  dentro de `backend/java/ether-music/`.
- Consecuencias: `make` y `just` deben invocar el wrapper del modulo y
  la documentacion debe mostrar ese path como fuente de verdad.
- Reemplaza: `none`

### DEC-0006 - Despliegue unico en k3s con Helm y una sola replica

- Fecha: 2026-04-24
- Estado: `accepted`
- Relacionado con specs: `SPEC-0002`
- Relacionado con tareas: `TASK-0102`, `TASK-0103`
- Contexto: el proyecto necesita un camino reproducible a produccion y
  la referencia operativa ya existe en `HouseDB`, pero `ether-music`
  persiste en SQLite local.
- Decision: desplegar `ether-music` como una unica release Helm en k3s,
  publicada en `music.v1.rafex.cloud`, con una sola replica y un PVC
  para `/app/data`.
- Consecuencias: el despliegue queda alineado al servidor actual y es
  sencillo de operar; a cambio, no se debe habilitar escalado horizontal
  mientras la persistencia siga basada en SQLite.
- Reemplaza: `none`
