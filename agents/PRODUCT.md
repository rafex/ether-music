# PRODUCT.md

## Problema

Hoy no existe un producto donde una persona pueda explorar musica
generada por reglas programaticas desde una interfaz web simple y una
API reutilizable. El repo tiene solo estructura documental y una idea
visual aislada.

## Usuarios

- Persona curiosa por la musica generativa:
  quiere experimentar con escalas, tempo y patrones sin montar un DAW.
- Desarrollador que integra audio procedural:
  necesita una API HTTP clara para pedir nuevas melodias y reutilizar
  la logica de generacion en otras interfaces.

## Objetivos

- Exponer una API REST para generar melodias reproducibles desde un
  cliente web.
- Ofrecer un frontend inicial que permita generar, visualizar y
  escuchar la secuencia sin herramientas externas.
- Construir la base documental y tecnica para evolucionar luego a
  composicion mas rica, persistencia y exportacion.

## No objetivos

- No competir con un secuenciador musical profesional en esta fase.
- No resolver sintetizadores avanzados, mezcla ni exportacion MIDI/WAV
  todavia.
- No introducir autenticacion, multiusuario ni almacenamiento
  persistente en el MVP inicial.

## Valor diferencial

La propuesta combina una API programable con una interfaz ligera para
explorar musica algoritmica. Ether permite un backend pequeno y
explicito; `jte` sirve una capa HTML controlada; el navegador reproduce
audio directamente sin depender de plugins pesados.
