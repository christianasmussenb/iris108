```md
# IRIS Data Agent for ChatGPT (Custom GPT + Actions)

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

## 1) Archivo `config/agent_limits.yaml`

(Esto lo ocupa el endpoint `/capabilities` y la validación server-side.)

```yaml
version: "1.0.0"
api:
  base_path: "/api/gpt/v1"
  auth:
    header_name: "X-API-Key"

limits:
  max_date_range_days: 400
  max_rows_default: 200
  max_rows_hard: 5000
  max_group_by: 3
  allowed_grains: ["day", "week", "month"]

response_contract:
  always_include:
    - correlation_id
    - metadata.executed_at
    - metadata.execution_ms
    - metadata.as_of_cutoff
```

---

## 2) Archivo `config/dimensions.yaml`

(“Semantic layer” mínimo: tipos, descripciones y lista blanca.)

```yaml
dimensions:
  aseguradora:
    type: "string"
    description: "Aseguradora/Isapre/Fonasa según catálogo interno"
    allowed_ops: ["eq", "in", "nin"]
  sucursal:
    type: "string"
    description: "Centro/Clínica/Sucursal"
    allowed_ops: ["eq", "in", "nin"]
  prestacion:
    type: "string"
    description: "Código prestación (arancel/convenio)"
    allowed_ops: ["eq", "in", "nin"]
  canal:
    type: "string"
    description: "Ambulatorio / Hospitalario / Urgencia (según modelo)"
    allowed_ops: ["eq", "in", "nin"]
  estado:
    type: "string"
    description: "Estado del documento (p.ej. emitida/anulada/glosada)"
    allowed_ops: ["eq", "in", "nin"]
```

---

## 3) Archivo `config/kpi_registry.yaml`

Este es el “mapa” que le impide al LLM pedir cualquier cosa.
**Regla:** el backend sólo ejecuta KPIs registrados acá.

```yaml
kpis:

  glosa_rate:
    name: "Tasa de glosa"
    unit: "percent"
    default_grain: "month"
    allowed_grains: ["day", "week", "month"]
    source:
      type: "cube"
      cube_id: "FIN_CX"
      numerator_measure: "monto_glosado"
      denominator_measure: "monto_facturado"

    allow:
      group_by: ["aseguradora", "sucursal", "prestacion", "canal"]
      filters: ["aseguradora", "sucursal", "prestacion", "canal", "estado"]

    mdx_templates:
      day:   "FIN_CX_GLOSA_RATE_BY_DAY"
      week:  "FIN_CX_GLOSA_RATE_BY_WEEK"
      month: "FIN_CX_GLOSA_RATE_BY_MONTH"

    caveats:
      - "Puede variar por corte de carga si el periodo está abierto."
      - "Excluye anulaciones si filter.estado != 'anulada'."

  recaudo_rate:
    name: "Tasa de recaudo"
    unit: "percent"
    default_grain: "month"
    allowed_grains: ["week", "month"]
    source:
      type: "cube"
      cube_id: "FIN_CX"
      numerator_measure: "monto_pagado"
      denominator_measure: "monto_facturado"

    allow:
      group_by: ["aseguradora", "sucursal"]
      filters: ["aseguradora", "sucursal", "estado"]

    mdx_templates:
      week:  "FIN_CX_RECAUDO_RATE_BY_WEEK"
      month: "FIN_CX_RECAUDO_RATE_BY_MONTH"
```

---

## 4) Archivo `config/cube_templates.yaml`

Estos templates son lo único que `/cube/query` puede ejecutar.
(Se ejecutan vía BI REST API: `/Data/MDXExecute` o `/Data/PivotExecute`, según tu decisión; ambos están documentados.) ([docs.intersystems.com][4])

```yaml
templates:

  FIN_CX_GLOSA_RATE_BY_MONTH:
    cube_id: "FIN_CX"
    description: "Tasa de glosa mensual, opcionalmente agrupado y filtrado"
    bi_rest_endpoint: "/Data/MDXExecute"
    params:
      from: { type: "date", required: true }
      to:   { type: "date", required: true }
      group_by: { type: "string_array", required: false, max_items: 3 }
      filters:  { type: "filter_array", required: false }
      limit:    { type: "int", required: false, default: 200, max: 5000 }

    # Nota: placeholders estilo {{param}} para sustitución controlada
    # (server-side debe validar group_by/filters contra kpi_registry + dimensions.yaml)
    mdx: |
      SELECT
        { [Measures].[monto_glosado] / NULLIF([Measures].[monto_facturado], 0) } ON 0,
        NON EMPTY {{ROW_AXIS}} ON 1
      FROM [FIN_CX]
      WHERE ( {{WHERE_SLICERS}} )

  FIN_CX_RECAUDO_RATE_BY_MONTH:
    cube_id: "FIN_CX"
    description: "Tasa de recaudo mensual"
    bi_rest_endpoint: "/Data/MDXExecute"
    params:
      from: { type: "date", required: true }
      to:   { type: "date", required: true }
      group_by: { type: "string_array", required: false, max_items: 2 }
      filters:  { type: "filter_array", required: false }
      limit:    { type: "int", required: false, default: 200, max: 5000 }
    mdx: |
      SELECT
        { [Measures].[monto_pagado] / NULLIF([Measures].[monto_facturado], 0) } ON 0,
        NON EMPTY {{ROW_AXIS}} ON 1
      FROM [FIN_CX]
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

## GET /api/gpt/v1/capabilities
- Read config/*.yaml and return:
  - kpis list, cubes list, limits
  - correlation_id

## POST /api/gpt/v1/kpi/explain
- Validate X-API-Key
- Validate kpi_id exists
- Return definition/formula/source/caveats from registry

## POST /api/gpt/v1/kpi/query
- Validate X-API-Key
- Validate request vs Validation Rules
- Resolve mdx_template_id = kpi_registry[kpi_id].mdx_templates[time.grain]
- Build safe ROW_AXIS and WHERE_SLICERS from allow-lists
- Execute BI REST call:
  - POST {bi_webapp_base}/Data/MDXExecute   (documented)
- Normalize BI response into rows/totals + metadata + correlation_id

## POST /api/gpt/v1/cube/query
- Validate X-API-Key
- Validate template_id exists + params schema
- Execute BI REST call:
  - POST {bi_webapp_base}/Data/MDXExecute or /Data/PivotExecute (template-defined)
- Return columns/rows + metadata + correlation_id

## POST /api/gpt/v1/dq/status
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
  - url: https://<TU-DOMINIO>/api/gpt/v1

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
