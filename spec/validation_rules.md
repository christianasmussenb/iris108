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
