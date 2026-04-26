# TRACEABILITY.md

| Spec | Estado | Tareas | Decisiones | Archivos principales | Validacion | Observaciones |
| --- | --- | --- | --- | --- | --- | --- |
| `SPEC-0001` | `done` | `TASK-0001`, `TASK-0002`, `TASK-0003` | `DEC-0001`, `DEC-0002`, `DEC-0003`, `DEC-0004`, `DEC-0005` | `backend/java/ether-music/pom.xml`, `backend/java/ether-music/src/main/java/**`, `backend/java/ether-music/src/main/jte/pages/home.jte` | `make test`; `GET /`; `GET /api/melodies/generate` | Primera base ejecutable del proyecto sobre Ether. |
| `SPEC-0002` | `active` | `TASK-0101`, `TASK-0102`, `TASK-0103` | `DEC-0003`, `DEC-0004`, `DEC-0005`, `DEC-0006` | `.github/workflows/*.yml`, `backend/java/Dockerfile`, `helm/ether-music/**`, `pipelines/*.md` | `make test`; `make verify`; `helm lint helm/ether-music`; `helm template ether-music ./helm/ether-music` | Despliegue en k3s basado en el patron operativo de HouseDB. |
