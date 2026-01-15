# Estado del proyecto (IRIS108 REST)

## Avance (sprint actual)
- Se estabilizo el flujo de BI REST con credenciales obligatorias en globals:
  - `^IRIS108.Config("BIUser")`, `^IRIS108.Config("BIPass")`, `^IRIS108.Config("BIBaseUrl")`.
- Se corrigio el envio de JSON hacia `/Data/MDXExecute` usando `EntityBody` con `%Stream.TmpCharacter`.
- Se alineo el parseo de `BIBaseUrl` con `ParseBaseUrl/JoinPath` (evita `%Net.URLParser` no disponible).
- Se corrigieron incompatibilidades de version:
  - `$SYSTEM.Util.UTCNow()` y `GetMilliSecondsBetween()` no existen -> fallback seguro.
  - `%CSP.Response.Write()` no existe -> usar `Write`.
- Se controlo el debugging de `QueryCube` con flag `^IRIS108.Config("DebugWrite")`.
- Resultado: `POST /csp/iris108/kpi/query` y `POST /csp/iris108/cube/query` responden 200 con JSON limpio.

## Pruebas realizadas (rango 20160101–20160630)
- `GET /csp/iris108/ping` OK.
- `POST /csp/iris108/kpi/query` OK (BI devuelve respuesta valida).
- `POST /csp/iris108/cube/query` OK (JSON con `rows`, `metadata`, `trace_id`).

## Problemas actuales
- El endpoint `/api/mgmnt` no respondio (timeout en 30s) al intentar regenerar clases.
- `cube/query` devuelve `rows: []` en el rango probado; validar si hay datos o si el MDX/filters requieren ajustes.

## Buenas practicas aplicadas
- Configuracion sensible en globals; no hardcodear credenciales en codigo.
- Uso consistente de `WriteError` y `WriteJson` para evitar 500 HTML del Web Gateway.
- Envio de JSON a BI REST con `EntityBody` y `Content-Type: application/json`.
- Trazas controladas por flag (`^IRIS108.Config("DebugWrite")`) para diagnostico sin romper respuestas.
- Fallbacks defensivos para metodos no disponibles en la version de IRIS.

## Acciones pendientes (siguiente sprint)
1. Verificar conectividad y respuesta del endpoint `http://172.10.250.26/api/mgmnt/` desde el servidor donde corre IRIS.
2. Reintentar `POST /api/mgmnt/v2/MLTEST/IRIS108` con `spec/swagger2.json`.
3. Confirmar que se generen `IRIS108.disp`, `IRIS108.impl`, `IRIS108.spec` en `MLTEST`.
4. Verificar datos reales en el cubo `SISS` para el rango y confirmar que `rows` no venga vacio.
5. Revisar si `QueryKpi` debe devolver JSON normalizado (alinear con `spec/endpoint_behavior.md`).
6. Limpiar trazas si ya no se requieren (desactivar `DebugWrite` en prod).

## Comando pendiente (cuando `/api/mgmnt` responda)
```bash
curl -i -u 'superuser:***' -H 'Content-Type: application/json' \
  --data-binary @spec/swagger2.json \
  http://172.10.250.26/api/mgmnt/v2/MLTEST/IRIS108
```
