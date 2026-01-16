# Estado del proyecto (IRIS108 REST)

## Avance (sprint actual)
- Se estabilizo el flujo de BI REST con credenciales obligatorias en globals:
  - `^IRIS108.Config("BIUser")`, `^IRIS108.Config("BIPass")`, `^IRIS108.Config("BIBaseUrl")`.
- Se corrigio el envio de JSON hacia `/Data/MDXExecute` usando `EntityBody` con `%Stream.TmpCharacter`.
- Se alineo el parseo de `BIBaseUrl` con `ParseBaseUrl/JoinPath` (evita `%Net.URLParser` no disponible).
- Se corrigieron incompatibilidades de version:
  - `$SYSTEM.Util.UTCNow()` y `GetMilliSecondsBetween()` no existen -> fallback seguro.
  - `%CSP.Response.Write()` no existe -> usar `Write`.
- Se actualizo `GET /capabilities` para devolver JSON con `kpis`, `cubes`, `limits`, `metadata`.
- Se implementaron validaciones en `kpi/query` segun `spec/validation_rules.md` (rango, group_by, filters, limits).
- Se corrigio `dq/status` para usar SQL embebido compatible con versiones antiguas.
- Se agregaron headers de error (`X-Error-Code`, `X-Error-Message`) para diagnostico.
- Se controlo el debugging de `QueryCube` con flag `^IRIS108.Config("DebugWrite")`.
- Se agregaron flags de debug puntuales:
  - `^IRIS108.Config("DebugIncludeRaw")` para incluir `bi_response_raw` en `cube/query`.
  - `^IRIS108.Config("DebugKpi")` para exponer headers de validacion en `kpi/query`.
- Resultado: `POST /csp/iris108/kpi/query` y `POST /csp/iris108/cube/query` responden 200 con JSON limpio.

## Pruebas realizadas (rango 20160101–20160630)
- `GET /csp/iris108/ping` OK.
- `GET /csp/iris108/capabilities` OK (JSON estructurado).
- `POST /csp/iris108/dq/status` OK (JSON; `cutoff` puede salir vacio si no hay dato).
- `POST /csp/iris108/kpi/query` OK: filas con `fecha`+`value` normalizadas. Traza: `911A3058-4A1C-4D76-BAC0-DCCE047C0475` (fact_count 20160101–20160630).
- `POST /csp/iris108/cube/query` OK: filas con `fecha`+`value` usando template `FACTINV_FACT_COUNT_BY_DAY`. Traza: `99FCBC21-1A62-4538-A30F-07F200FD9CA1` (fact_count 20160101–20160630).

## Problemas actuales
- El endpoint `/api/mgmnt` no respondio (timeout en 30s) al intentar regenerar clases.
- Pendiente: `/api/mgmnt` sigue sin responder para regenerar clases.
- Revisar otros KPIs/plantillas con rango de prueba para confirmar normalizacion (solo validado fact_count/template FACTINV_FACT_COUNT_BY_DAY).

## Buenas practicas aplicadas
- Configuracion sensible en globals; no hardcodear credenciales en codigo.
- Uso consistente de `WriteError` y `WriteJson` para evitar 500 HTML del Web Gateway.
- Envio de JSON a BI REST con `EntityBody` y `Content-Type: application/json`.
- Trazas controladas por flag (`^IRIS108.Config("DebugWrite")`) para diagnostico sin romper respuestas.
- Fallbacks defensivos para metodos no disponibles en la version de IRIS.
- SQL embebido para queries simples cuando las APIs `%SQL.Statement/%ResultSet` no existen.
- Debug por headers (`X-Error-*`, `X-Debug-*`) para diagnostico sin exponer datos sensibles en logs.

## Acciones pendientes (siguiente sprint)
1. Verificar conectividad y respuesta del endpoint `http://172.10.250.26/api/mgmnt/` desde el servidor donde corre IRIS.
2. Reintentar `POST /api/mgmnt/v2/MLTEST/IRIS108` con `spec/swagger2.json`.
3. Confirmar que se generen `IRIS108.disp`, `IRIS108.impl`, `IRIS108.spec` en `MLTEST`.
4. Validar KPIs adicionales y templates restantes (rango 20160101–20160630) para confirmar normalizacion consistente.
5. Unificar `agent_limits.base_path` en globals a `/csp/iris108` si no está ya alineado.
6. Limpiar trazas (desactivar `DebugWrite`/debug flags en prod) tras cerrar pruebas.

## Plan de trabajo (siguiente sprint)
1. Alinear configuraciones en globals con el repo (`agent_limits`, `kpi_registry`, `dimensions`, `cube_templates`).
2. Corregir `kpi/query`:
   - Validacion de `time.grain` con formato real.
   - Normalizacion de respuesta (rows + metadata + correlation_id).
3. Corregir `cube/query`:
   - Inspeccionar `bi_response_raw` con debug.
   - Ajustar `NormalizeMdxResponse` para el shape real de BI.
4. Endurecer manejo de errores:
   - Asegurar JSON en errores y headers `X-Error-*`.
   - Documentar casos limite (cutoff null, rows vacias).
5. Pruebas de cierre:
   - Ejecutar los `curl` de `docs/SPRINT_STATUS.md` y registrar resultados.

## Comando pendiente (cuando `/api/mgmnt` responda)
```bash
curl -i -u 'superuser:***' -H 'Content-Type: application/json' \
  --data-binary @spec/swagger2.json \
  http://172.10.250.26/api/mgmnt/v2/MLTEST/IRIS108
```

---

## Pruebas detalladas (fin de sprint)

### 1) Ping
- Objetivo: validar disponibilidad del servicio REST.
- Request:
```bash
curl -i \
  http://172.10.250.26/irisestandar/csp/iris108/ping
```
- Esperado:
  - HTTP 200
  - Body JSON simple: `{"status":"ok"}`

### 2) Capabilities
- Objetivo: validar lectura de configuraciones y contrato JSON base.
- Request:
```bash
curl -i \
  -H 'X-API-Key: MI_API_KEY_123' \
  http://172.10.250.26/irisestandar/csp/iris108/capabilities
```
- Esperado:
  - HTTP 200
  - JSON con `kpis`, `cubes`, `limits`, `correlation_id`, `metadata`

### 3) KPI Query (fact_count)
- Objetivo: validar consulta KPI por rango de fechas y grain.
- Request:
```bash
curl -i \
  -H 'X-API-Key: MI_API_KEY_123' \
  -H 'Content-Type: application/json' \
  -d '{
    "kpi_id": "fact_count",
    "time": { "from": "20160101", "to": "20160630", "grain": "day" }
  }' \
  http://172.10.250.26/irisestandar/csp/iris108/kpi/query
```
- Esperado:
  - HTTP 200
  - JSON con filas, `correlation_id` y `metadata`

### 4) Cube Query (template)
- Objetivo: validar ejecucion de template MDX.
- Request:
```bash
curl -i \
  -H 'X-API-Key: MI_API_KEY_123' \
  -H 'Content-Type: application/json' \
  -d '{
    "template_id": "FACTINV_FACT_COUNT_BY_DAY",
    "params": {
      "from": "20160101",
      "to": "20160630",
      "group_by": [],
      "filters": [],
      "limit": 200
    }
  }' \
  http://172.10.250.26/irisestandar/csp/iris108/cube/query
```
- Esperado:
  - HTTP 200
  - JSON con `rows`, `metadata`, `trace_id`

### 5) DQ Status
- Objetivo: validar consulta de cutoff.
- Request:
```bash
curl -i \
  -H 'X-API-Key: MI_API_KEY_123' \
  -H 'Content-Type: application/json' \
  -d '{
    "subject": "fact_invoice",
    "time": { "from": "20160101", "to": "20160630" }
  }' \
  http://172.10.250.26/irisestandar/csp/iris108/dq/status
```
- Esperado:
  - HTTP 200
  - JSON con `cutoff`, `correlation_id`, `metadata`
  - Si `MAX(CutoffTs)` devuelve NULL, `cutoff` sale vacio (dato no disponible en tabla)

### Notas
- Ver configuracion en globals (MLTEST):
  - http://172.10.250.26/irisestandar/csp/sys/exp/UtilExpGlobalView.csp?$ID2=IRIS108.Config&$NAMESPACE=MLTEST&$NAMESPACE=MLTEST
