```md
# IRIS Data Agent for ChatGPT (Custom GPT + Actions)

> 📚 **Para documentación completa y guías detalladas, consulta la [Wiki del Proyecto](WIKI.md)**

## 🚀 Inicio Rápido

**Documentación Disponible:**
- 📖 [**WIKI.md**](WIKI.md) - Wiki completa con guías de instalación, configuración, API reference y troubleshooting
- 📋 [**docs/SPRINT_STATUS.md**](docs/SPRINT_STATUS.md) - Estado actual del proyecto y resultados de pruebas
- ✅ [**BUENAS_PRACTICAS_IRIS_COMBINADAS.md**](BUENAS_PRACTICAS_IRIS_COMBINADAS.md) - Guía completa de buenas prácticas para IRIS
- 🔧 [**spec/validation_rules.md**](spec/validation_rules.md) - Reglas de validación server-side
- 🌐 [**spec/openapi.yaml**](spec/openapi.yaml) - Especificación OpenAPI 3.1

## Overview
This project implements a **natural-language data assistant** that allows business and technical users to query **InterSystems IRIS** data—specifically the **data architecture (raw/mart) and BI cubes/KPIs**—directly from the **ChatGPT interface** using a **Custom GPT** configured with **Actions**.

The solution exposes a small, **governed REST API** hosted **inside InterSystems IRIS**. ChatGPT uses this API to retrieve KPI results, cube analytics, and data-quality status. The architecture is designed to be **secure by default**, **read-only**, and **strictly limited** to pre-approved queries and dimensions (no free-form SQL/MDX from the model).

## Goals
- Provide **natural-language access** to IRIS KPIs and cube analytics from ChatGPT.
- Deliver **trusted answers** by forcing all numeric responses to be backed by API calls.
- Enforce **governance and safety** through allow-lists, templates, and hard limits (time range, rows, dimensions).
- Ensure **traceability** end-to-end using correlation IDs and audit logging in IRIS.
- Keep the implementation **simple and scalable**, enabling new KPIs and templates to be added without changing the GPT.

## Architecture
### Components
1. **Custom GPT (ChatGPT Plus and above)**
   - Contains instructions, examples, and a glossary of KPIs/dimensions.
   - Uses **Actions** defined by an **OpenAPI 3.1** specification.
   - Authentication is configured as **API Key** in the GPT editor.

2. **IRIS-hosted REST API (Data Agent Gateway)**
   - Implemented as an IRIS REST service (e.g., `%CSP.REST`).
   - Validates `X-API-Key` on every request.
   - Applies strict validation and governance:
     - Only registered KPIs can be queried (`kpi_registry.yaml`).
     - Only approved cube templates can be executed (`cube_templates.yaml`).
     - Filters and groupings are restricted by allow-lists (`dimensions.yaml`).
     - Hard limits for date ranges and result sizes (`agent_limits.yaml`).
   - Returns normalized JSON responses for ChatGPT to format.

3. **InterSystems IRIS BI (Cubes)**
   - KPI and cube queries are executed through **IRIS BI REST endpoints** (e.g., MDX/Pivot execution).
   - The assistant never receives permissions to run arbitrary queries; it only triggers registered templates.

4. **Data Quality (DQ)**
   - The API includes an endpoint to report last cutoff, completeness, latency, and issues.
   - This supports user trust and operational readiness for reporting.

## Supported Capabilities (MVP)
- Discover available KPIs, cubes, dimensions, grains, and limits (`GET /capabilities`).
- Explain KPI definitions and formulas (`POST /kpi/explain`).
- Query KPIs with controlled time ranges, groupings, and filters (`POST /kpi/query`).
- Execute **template-based** cube queries (no raw MDX from client) (`POST /cube/query`).
- Retrieve data-quality and cutoff status (`POST /dq/status`).

## Security Model
- **API Key authentication** via `X-API-Key` header (configured in the Custom GPT Actions settings).
- Read-only operations only.
- Strong server-side validation and allow-lists to prevent:
  - Free-form SQL/MDX execution
  - Excessive data extraction
  - Unauthorized dimensions/filters
- Standardized error responses and mandatory `correlation_id` for traceability.

## Repository Structure (suggested)
- `config/`
  - `agent_limits.yaml` — global hard limits (dates, rows, grains)
  - `dimensions.yaml` — allowed dimensions and filter operators
  - `kpi_registry.yaml` — KPI definitions + allowed group_by/filters + mapped templates
  - `cube_templates.yaml` — template registry (template_id → cube_id + params + MDX)
- `spec/`
  - `openapi.yaml` — OpenAPI 3.1 spec imported into Custom GPT Actions
  - `validation_rules.md` — server-side validation rules
  - `endpoint_behavior.md` — canonical endpoint behavior for implementation
- `src/` (or IRIS classes in your preferred layout)
  - REST service implementation
  - API key validation
  - BI REST execution adapter
  - response normalizers and logging

## Operational Notes
- The API always returns `correlation_id` and execution metadata to support audit trails.
- KPI onboarding is configuration-driven: add a KPI to `kpi_registry.yaml` + templates to `cube_templates.yaml`.
- The Custom GPT should be instructed to:
  - call Actions for any numeric claim,
  - ask for clarification if the user request is ambiguous,
  - never assume data availability without a successful API response.

## Estado actual (MLTEST)
- Cubo activo: `SISS` (SISS.BI.FactInvoiceCube).
- BI UI verificado en: `/csp/mltest/_DeepSee.UI.Analyzer.zen` y `/csp/mltest/_DeepSee.UI.MDXQuery.zen`.
- Configuración cargada desde globals cuando no existe `%SYS.YAML`.
- Web App REST: `/csp/iris108` con `IRIS108.REST.Service` (requiere recarga del Web Gateway si da 500 HTML).
- BI REST requiere credenciales desde globals: `^IRIS108.Config("BIUser")` y `^IRIS108.Config("BIPass")`.
- BI REST usa `^IRIS108.Config("BIBaseUrl")` (ej.: `http://172.10.250.26/irisestandar/api/deepsee/v3/MLTEST`).
- Debug controlado por flag `^IRIS108.Config("DebugWrite")` (solo para trazas temporales).
- Flags adicionales de debug:
  - `^IRIS108.Config("DebugIncludeRaw")` agrega `bi_response_raw` en `cube/query`.
  - `^IRIS108.Config("DebugKpi")` agrega headers `X-Debug-*` en `kpi/query`.

## Configuración sin %SYS.YAML
Si `%SYS.YAML` no está disponible, la carga de configuración usa globals:
- `^IRIS108.ConfigData("agent_limits","json")`
- `^IRIS108.ConfigData("dimensions","json")`
- `^IRIS108.ConfigData("kpi_registry","json")`
- `^IRIS108.ConfigData("cube_templates","json")`

## Aprendizajes clave
- El Web Gateway puede seguir devolviendo 500 HTML aun con la clase compilada; requiere recarga/configuración del Gateway.
- En este entorno, `%SYS.YAML` no está disponible; se usa JSON en globals como fallback.
- El cubo operativo es `SISS`, y las medidas en MDX deben usar los nombres internos sin espacios (p.ej. `TotalFacturado`).
- El editor de Actions exige HTTPS y `servers.url` bajo el mismo origen.
- En versiones antiguas, algunos metodos de `%SQL.Statement/%ResultSet` no existen; usar SQL embebido para consultas simples.
- `%DynamicObject` puede fallar en operaciones multidimensionales; evitar patrones que asuman arrays.
- En errores 500 del Web Gateway, usar headers `X-Error-*` y flags de debug para diagnostico rapido.

## Mejores practicas aplicadas (IRIS108)
- JSON de error uniforme con headers `X-Error-Code` y `X-Error-Message`.
- Flags de debug puntuales (no persistentes) para inspeccionar `cube/query` y validaciones de `kpi/query`.
- Validaciones server-side basadas en `agent_limits`, `dimensions` y `kpi_registry`.
```
# Implementación "codex-ready" para IRIS + ChatGPT Actions
**codex-ready**: archivos de configuración + reglas de validación + mapeos KPI→(cubo/MDX template) + checklist de implementación en IRIS + notas exactas para configurar Actions con **API Key en el editor** (sin meter la key en el OpenAPI). Todo está alineado con lo documentado por **OpenAI Actions** y **InterSystems IRIS REST + BI REST (MDXExecute/PivotExecute)**. ([Plataforma OpenAI][1])

---

## 0) Precondiciones (hard requirements)

* **IRIS REST Service** implementado como clase que **subclasea `%CSP.REST`**. ([docs.intersystems.com][2])
* Autenticación en REST: **HTTP auth headers (recomendado por InterSystems)**. En tu caso: `X-API-Key`. ([docs.intersystems.com][3])
* Para consultas BI: usar **Business Intelligence REST API** (ej.: `POST /Data/MDXExecute`, `POST /Data/PivotExecute`). ([docs.intersystems.com][4])
* En el Custom GPT: configurar **API Key authentication en el GPT editor UI** (OpenAI cifra/guarda la key). No relies en que el modelo “invente headers”; la key se configura en la UI. ([Plataforma OpenAI][5])

---

## 1) Archivo `config/agent_limits.yaml` (MVP actual)

```yaml
version: "1.0.0"
api:
  base_path: "/csp/iris108"
  auth:
    header_name: "X-API-Key"

limits:
  max_date_range_days: 400
  max_rows_default: 200
  max_rows_hard: 5000
  max_group_by: 3
  allowed_grains: ["day"]

response_contract:
  always_include:
    - correlation_id
    - metadata.executed_at
    - metadata.execution_ms
    - metadata.as_of_cutoff
```

---

## 2) Archivo `config/dimensions.yaml` (MVP actual)

```yaml
dimensions:
  pagador:
    type: "string"
    description: "Pagador (KUNRG)"
    allowed_ops: ["eq", "in", "nin"]
  centro:
    type: "string"
    description: "Centro (ISHKOSTR)"
    allowed_ops: ["eq", "in", "nin"]
```

---

## 3) Archivo `config/kpi_registry.yaml` (MVP actual)

```yaml
kpis:
  fact_count:
    name: "Cantidad de facturas"
    unit: "count"
    default_grain: "day"
    allowed_grains: ["day"]
    source:
      type: "cube"
      cube_id: "SISS"
      measure: "%COUNT"
    allow:
      group_by: ["pagador", "centro"]
      filters: ["pagador", "centro"]
    mdx_templates:
      day: "FACTINV_FACT_COUNT_BY_DAY"

  total_facturado:
    name: "Total facturado"
    unit: "currency"
    default_grain: "day"
    allowed_grains: ["day"]
    source:
      type: "cube"
      cube_id: "SISS"
      measure: "TotalFacturado"
    allow:
      group_by: ["pagador", "centro"]
      filters: ["pagador", "centro"]
    mdx_templates:
      day: "FACTINV_TOTAL_FACTURADO_BY_DAY"
```

---

## 4) Archivo `config/cube_templates.yaml` (MVP actual)

```yaml
templates:
  FACTINV_FACT_COUNT_BY_DAY:
    cube_id: "SISS"
    description: "Cantidad de facturas por dia, opcionalmente agrupado y filtrado"
    bi_rest_endpoint: "/Data/MDXExecute"
    params:
      from: { type: "date", required: true }
      to:   { type: "date", required: true }
      group_by: { type: "string_array", required: false, max_items: 2 }
      filters:  { type: "filter_array", required: false }
      limit:    { type: "int", required: false, default: 200, max: 5000 }
    mdx: |
      SELECT
        { [Measures].[%COUNT] } ON 0,
        NON EMPTY {{ROW_AXIS}} ON 1
      FROM [SISS]
      WHERE ( {{WHERE_SLICERS}} )

  FACTINV_TOTAL_FACTURADO_BY_DAY:
    cube_id: "SISS"
    description: "Total facturado por dia, opcionalmente agrupado y filtrado"
    bi_rest_endpoint: "/Data/MDXExecute"
    params:
      from: { type: "date", required: true }
      to:   { type: "date", required: true }
      group_by: { type: "string_array", required: false, max_items: 2 }
      filters:  { type: "filter_array", required: false }
      limit:    { type: "int", required: false, default: 200, max: 5000 }
    mdx: |
      SELECT
        { [Measures].[TotalFacturado] } ON 0,
        NON EMPTY {{ROW_AXIS}} ON 1
      FROM [SISS]
      WHERE ( {{WHERE_SLICERS}} )
```

---

## 5) Reglas de validación (codex-ready) `spec/validation_rules.md`

```md
# Validation Rules (server-side)

## Authentication
- Require header X-API-Key on every request.
- If missing/invalid: 401 UNAUTHORIZED.

## KPI Query Contract
- kpi_id must exist in config/kpi_registry.yaml
- time.from <= time.to
- date range days <= limits.max_date_range_days
- time.grain must be in KPI.allowed_grains AND limits.allowed_grains
- group_by length <= limits.max_group_by
- group_by values must be in KPI.allow.group_by
- filters[*].field must be in KPI.allow.filters AND exist in config/dimensions.yaml
- filters[*].op must be in dimensions[field].allowed_ops
- options.limit <= limits.max_rows_hard

## Cube Query Contract
- template_id must exist in config/cube_templates.yaml
- params must satisfy template.params schema
- Must NOT accept raw MDX from client (only template_id + params)

## Response Contract
- Always include correlation_id (UUID)
- Always include metadata.executed_at (UTC ISO8601)
- Always include metadata.execution_ms (int)
- Always include metadata.as_of_cutoff (UTC ISO8601)
```

---

## 6) Mapeo “hard” de endpoints a comportamiento (para CODEX) `spec/endpoint_behavior.md`

(Esto amarra tus endpoints IRIS a lo documentado: REST propio + BI REST.)

```md
# Endpoint Behavior

## GET /csp/iris108/capabilities
- Read config/*.yaml and return:
  - kpis list, cubes list, limits
  - correlation_id

## POST /csp/iris108/kpi/explain
- Validate X-API-Key
- Validate kpi_id exists
- Return definition/formula/source/caveats from registry

## POST /csp/iris108/kpi/query
- Validate X-API-Key
- Validate request vs Validation Rules
- Resolve mdx_template_id = kpi_registry[kpi_id].mdx_templates[time.grain]
- Build safe ROW_AXIS and WHERE_SLICERS from allow-lists
- Execute BI REST call:
  - POST {bi_webapp_base}/Data/MDXExecute   (documented)
- Normalize BI response into rows/totals + metadata + correlation_id

## POST /csp/iris108/cube/query
- Validate X-API-Key
- Validate template_id exists + params schema
- Execute BI REST call:
  - POST {bi_webapp_base}/Data/MDXExecute or /Data/PivotExecute (template-defined)
- Return columns/rows + metadata + correlation_id

## POST /csp/iris108/dq/status
- Validate X-API-Key
- Return last cutoff + completeness + issues from your DQ table (not BI)
```

BI REST endpoints referenciados: `/Data/MDXExecute` y `/Data/PivotExecute`. ([docs.intersystems.com][4])

---

## 7) OpenAPI “importable” (stub) `spec/openapi.yaml`

Esto es lo mínimo que necesita Actions: schema + securitySchemes apiKey (la key se carga en el editor). ([Plataforma OpenAI][1])

```yaml
openapi: 3.1.0
info:
  title: IRIS Data Agent API
  version: 1.0.0
servers:
  - url: https://<TU-DOMINIO>/csp/iris108

components:
  securitySchemes:
    ApiKeyAuth:
      type: apiKey
      in: header
      name: X-API-Key

security:
  - ApiKeyAuth: []

paths:
  /capabilities:
    get:
      operationId: getCapabilities
      responses:
        "200": { description: OK }

  /kpi/explain:
    post:
      operationId: explainKpi
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required: [kpi_id]
              properties:
                kpi_id: { type: string }
      responses:
        "200": { description: OK }

  /kpi/query:
    post:
      operationId: queryKpi
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required: [kpi_id, time]
              properties:
                kpi_id: { type: string }
                time:
                  type: object
                  required: [from, to, grain]
                  properties:
                    from: { type: string }
                    to: { type: string }
                    grain: { type: string, enum: [day, week, month] }
                group_by:
                  type: array
                  items: { type: string }
                filters:
                  type: array
                  items:
                    type: object
                    required: [field, op, value]
                    properties:
                      field: { type: string }
                      op: { type: string }
                      value: {}
                options:
                  type: object
                  properties:
                    limit: { type: integer }
      responses:
        "200": { description: OK }

  /cube/query:
    post:
      operationId: queryCubeTemplate
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required: [template_id, params]
              properties:
                template_id: { type: string }
                params: { type: object }
      responses:
        "200": { description: OK }

  /dq/status:
    post:
      operationId: dataQualityStatus
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required: [subject, time]
              properties:
                subject: { type: string }
                time:
                  type: object
                  required: [from, to]
                  properties:
                    from: { type: string }
                    to: { type: string }
      responses:
        "200": { description: OK }
```

---

## Pruebas rapidas (curl)

Nota: la API key se obtiene de `^IRIS108.Config("ApiKey")` en el namespace `MLTEST`.

### Ping
```bash
curl -i \
  http://172.10.250.26/irisestandar/csp/iris108/ping
```

### Capabilities
```bash
curl -i \
  -H 'X-API-Key: MI_API_KEY_123' \
  http://172.10.250.26/irisestandar/csp/iris108/capabilities
```

### KPI Query (fact_count)
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

### Cube Query (template)
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

### DQ Status
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
Nota: si `MAX(CutoffTs)` devuelve NULL, el campo `cutoff` saldra vacio.

---

## 8) Checklist de implementación en IRIS (mínimo, sin inventar)

1. Crear REST service en IRIS con `%CSP.REST` y publicar como Web Application. ([docs.intersystems.com][2])
2. Configurar seguridad del REST con **HTTP authentication headers** (InterSystems lo recomienda). ([docs.intersystems.com][3])
3. Habilitar/asegurar acceso a **BI REST API** para ejecutar MDX (`/Data/MDXExecute`). ([docs.intersystems.com][4])
4. Implementar los endpoints del paquete arriba y validación estricta por allow-lists.
5. (Opcional) Generar/mostrar documentación de tus REST APIs (InterSystems tiene mecanismos para listar/documentar). ([docs.intersystems.com][6])
6. En el Custom GPT: importar `spec/openapi.yaml` y configurar **API Key Auth** en el editor. ([Plataforma OpenAI][5])

---

Si quieres “cerrarlo” aún más para CODEX, el siguiente paso es que me digas **los KPIs exactos del MVP (8–12)** y los **nombres reales** de cubo/medidas/dimensiones en tu IRIS BI; con eso te devuelvo el `kpi_registry.yaml` y `cube_templates.yaml` *ya* con IDs finales (sin placeholders) y con los allow-lists completos.

[1]: https://platform.openai.com/docs/actions/introduction?utm_source=chatgpt.com "GPT Actions"
[2]: https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GREST_csprest&utm_source=chatgpt.com "Creating a REST Service Manually"
[3]: https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GREST_securing&utm_source=chatgpt.com "Securing REST Services - InterSystems Documentation"
[4]: https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=D2CLIENT_post_data_mdxexecute&utm_source=chatgpt.com "/Data/MDXExecute | Client-Side APIs for InterSystems IRIS ..."
[5]: https://platform.openai.com/docs/actions/authentication?utm_source=chatgpt.com "GPT Action authentication | OpenAI API"
[6]: https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GREST_discover_doc&utm_source=chatgpt.com "Listing and Documenting REST APIs | Creating REST Services"
