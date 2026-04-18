# ARCHITECTURE.md

## Vision general

El sistema arranca como una aplicacion monolitica pequena en Java 21.
Ether monta el servidor HTTP y registra rutas. El backend contiene la
logica de generacion melodica y expone respuestas JSON. La pagina
principal se renderiza con `jte` y delega en JavaScript la visualizacion
y reproduccion del audio con Web Audio API.
El codigo del modulo vive en `backend/java/ether-music/` para no mezclar
la raiz del repositorio con archivos del runtime.
La aplicacion persiste las composiciones generadas en SQLite local para
exponer un historial simple via API.

## Modulos principales

- `web`:
  arranque de Ether, registro de rutas y handlers HTTP.
- `melody`:
  dominio de escalas, notas, requests y generacion de secuencias.
- `frontend`:
  render del HTML inicial con `jte`.
- `json`:
  adaptador local de Jackson al `JsonCodec` que Ether publica hoy.
- `db`:
  persistencia SQLite de composiciones y consulta del historial.

## Flujo principal

1. El navegador o cliente HTTP invoca uno de los endpoints de
   composicion.
2. Ether enruta la request al handler correspondiente.
3. El mapper opcional traduce intencion, palabras o datos de codigo a un
   `MelodyRequest`.
4. El generador produce la secuencia, paleta y metadatos musicales.
5. La composicion se guarda en SQLite.
6. El cliente recibe JSON y puede reproducir o listar canciones.

## Restricciones

- Mantener una sola aplicacion mientras el dominio siga pequeno.
- Evitar dependencias de frameworks pesados fuera de Ether y `jte`.
- Mantener la generacion desacoplada de Jetty para poder extraerla
  luego a servicios o tests puros.
- Mantener el codigo Java contenido en `backend/java/ether-music/`.

## Riesgos

- La Web Audio API no equivale a un motor musical completo.
  Mitigacion: limitar el MVP a melodias monofonicas.
- `jte` se usa aqui para render HTML, no para audio.
  Mitigacion: dejar ese rol explicitado en docs y codigo.
