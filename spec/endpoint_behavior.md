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
  - POST {bi_webapp_base}/Data/MDXExecute
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
