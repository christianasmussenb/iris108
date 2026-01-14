# Estado del proyecto (IRIS108 REST)

## Avance
- Se identifico el ruteo correcto del REST con `%CSP.REST` y `UrlMap` usando `XMLNamespace`.
- Se ajusto `IRIS108.REST.Service.Ping()` para manejar errores sin romper la compilacion.
- Se encontro la especificacion `spec/openapi.yaml` (OpenAPI 3.1).
- Se genero `spec/swagger2.json` (OpenAPI 2.0) para usar con `/api/mgmnt`.
- Se intento regenerar las clases via `POST /api/mgmnt/v2/MLTEST/IRIS108`, pero el request hizo timeout.

## Problemas actuales
- El endpoint `/api/mgmnt` no respondio (timeout en 30s) al intentar regenerar clases.
- El Web Gateway/IIS devolvio 500 HTML en pruebas previas; revisar logs si reaparece.

## Acciones pendientes (siguiente sprint)
1. Verificar conectividad y respuesta del endpoint `http://172.10.250.26/api/mgmnt/` desde el servidor donde corre IRIS.
2. Reintentar `POST /api/mgmnt/v2/MLTEST/IRIS108` con `spec/swagger2.json`.
3. Confirmar que se generen `IRIS108.disp`, `IRIS108.impl`, `IRIS108.spec` en `MLTEST`.
4. Ajustar Web App `/csp/iris108`:
   - Si se usa generado por OpenAPI, el Dispatch Class debe ser `IRIS108.disp`.
   - Si se mantiene la clase manual, dejar `IRIS108.REST.Service`.
5. Probar `GET /csp/iris108/ping` y validar `Content-Type: application/json` y body.
6. Revisar y consolidar cambios locales:
   - `src/IRIS108/REST/Service.cls` modificado.
   - `spec/swagger2.json` nuevo.
   - Ver si `.vscode/settings.json` tiene cambios relacionados.

## Comando pendiente (cuando `/api/mgmnt` responda)
```bash
curl -i -u 'superuser:***' -H 'Content-Type: application/json' \
  --data-binary @spec/swagger2.json \
  http://172.10.250.26/api/mgmnt/v2/MLTEST/IRIS108
```
