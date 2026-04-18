# ARCHITECTURE.md

## Vision general

El sistema arranca como una aplicacion monolitica pequena en Java 21.
Ether monta el servidor HTTP y registra rutas. El backend contiene la
logica de generacion melodica y expone respuestas JSON. La pagina
principal se renderiza con `jte` y delega en JavaScript la visualizacion
y reproduccion del audio con Web Audio API.
El codigo del modulo vive en `backend/java/` para no mezclar la raiz del
repositorio con archivos del runtime.

## Modulos principales

- `web`:
  arranque de Ether, registro de rutas y handlers HTTP.
- `melody`:
  dominio de escalas, notas, requests y generacion de secuencias.
- `frontend`:
  render del HTML inicial con `jte`.
- `json`:
  adaptador local de Jackson al `JsonCodec` que Ether publica hoy.

## Flujo principal

1. El navegador pide `GET /`.
2. Ether entrega una pagina HTML renderizada con `jte`.
3. El usuario ajusta controles y pide una nueva melodía.
4. El frontend llama `GET /api/melodies/generate`.
5. El backend calcula la secuencia y responde JSON.
6. El frontend pinta la cuadrícula y reproduce la secuencia con
   osciladores del navegador.

## Restricciones

- Mantener una sola aplicacion mientras el dominio siga pequeno.
- Evitar dependencias de frameworks pesados fuera de Ether y `jte`.
- Mantener la generacion desacoplada de Jetty para poder extraerla
  luego a servicios o tests puros.
- Mantener el codigo Java contenido en `backend/java/`.

## Riesgos

- La Web Audio API no equivale a un motor musical completo.
  Mitigacion: limitar el MVP a melodias monofonicas.
- `jte` se usa aqui para render HTML, no para audio.
  Mitigacion: dejar ese rol explicitado en docs y codigo.
