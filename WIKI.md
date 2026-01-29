# IRIS108 - Wiki del Proyecto

## 📖 Índice

1. [Visión General](#visión-general)
2. [Arquitectura](#arquitectura)
3. [Inicio Rápido](#inicio-rápido)
4. [Configuración](#configuración)
5. [API Reference](#api-reference)
6. [Desarrollo](#desarrollo)
7. [Troubleshooting](#troubleshooting)
8. [Buenas Prácticas](#buenas-prácticas)
9. [Estado del Proyecto](#estado-del-proyecto)
10. [Referencias](#referencias)

---

## Visión General

**IRIS108** es un asistente de datos basado en lenguaje natural que permite a usuarios de negocio y técnicos consultar datos de **InterSystems IRIS**—específicamente la arquitectura de datos (raw/mart) y cubos BI/KPIs—directamente desde la interfaz de **ChatGPT** usando un **Custom GPT** configurado con **Actions**.

### Objetivos Principales

- ✅ Proporcionar **acceso en lenguaje natural** a KPIs de IRIS y analytics de cubos desde ChatGPT
- ✅ Entregar **respuestas confiables** forzando que todas las respuestas numéricas estén respaldadas por llamadas API
- ✅ Aplicar **governance y seguridad** mediante allow-lists, templates y límites estrictos
- ✅ Asegurar **trazabilidad** end-to-end usando correlation IDs y audit logging en IRIS
- ✅ Mantener la implementación **simple y escalable**

### Características Clave

- 🔒 **Seguridad**: API Key authentication, operaciones read-only, validación estricta
- 📊 **BI Integration**: Acceso a cubos IRIS BI mediante templates MDX controlados
- 🎯 **Governance**: KPIs y dimensiones permitidas definidas en configuración
- 📝 **Trazabilidad**: Correlation IDs y metadata en todas las respuestas
- ⚡ **Performance**: Límites de datos y rangos de tiempo configurables

---

## Arquitectura

### Componentes del Sistema

```
┌─────────────────────┐
│   ChatGPT Custom    │
│      GPT + Actions  │
└──────────┬──────────┘
           │ HTTPS + API Key
           ▼
┌─────────────────────┐
│  IRIS REST API      │
│  /csp/iris108       │
│  (Data Agent)       │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  InterSystems IRIS  │
│  BI (Cubos/KPIs)    │
│  Namespace: MLTEST  │
└─────────────────────┘
```

### Stack Tecnológico

- **Backend**: InterSystems IRIS (ObjectScript)
- **BI**: InterSystems IRIS BI (MDX, Cubos OLAP)
- **API**: REST sobre CSP (`%CSP.REST`)
- **Configuración**: Globals de IRIS (fallback sin `%SYS.YAML`)
- **Autenticación**: API Key vía header `X-API-Key`
- **Frontend**: ChatGPT Custom GPT con OpenAPI 3.1 Actions

### Flujo de Datos

1. Usuario hace pregunta en ChatGPT
2. Custom GPT identifica necesidad de datos numéricos
3. GPT llama API REST con Action correspondiente
4. API valida request contra allow-lists y límites
5. API ejecuta template MDX en BI REST
6. API normaliza respuesta y retorna JSON a GPT
7. GPT presenta respuesta en lenguaje natural al usuario

---

## Inicio Rápido

### Prerrequisitos

- InterSystems IRIS (versión documentada en el proyecto)
- Acceso al namespace `MLTEST`
- Cubo BI `SISS` configurado y disponible
- Credenciales de acceso a BI REST

### Configuración Mínima en IRIS

```objectscript
// 1. Configurar credenciales BI
Set ^IRIS108.Config("BIUser") = "usuario_bi"
Set ^IRIS108.Config("BIPass") = "password_bi"
Set ^IRIS108.Config("BIBaseUrl") = "http://172.10.250.26/irisestandar/api/deepsee/v3/MLTEST"

// 2. Configurar API Key
Set ^IRIS108.Config("ApiKey") = "MI_API_KEY_SEGURA_123"

// 3. Cargar configuraciones JSON (ver sección Configuración)
Set ^IRIS108.ConfigData("agent_limits","json") = "{...}"
Set ^IRIS108.ConfigData("dimensions","json") = "{...}"
Set ^IRIS108.ConfigData("kpi_registry","json") = "{...}"
Set ^IRIS108.ConfigData("cube_templates","json") = "{...}"
```

### Prueba Rápida

```bash
# 1. Verificar disponibilidad
curl -i http://172.10.250.26/irisestandar/csp/iris108/ping

# 2. Verificar capacidades
curl -i -H 'X-API-Key: MI_API_KEY_123' \
  http://172.10.250.26/irisestandar/csp/iris108/capabilities

# 3. Consultar un KPI
curl -i -H 'X-API-Key: MI_API_KEY_123' \
  -H 'Content-Type: application/json' \
  -d '{
    "kpi_id": "fact_count",
    "time": {"from": "20160101", "to": "20160630", "grain": "day"}
  }' \
  http://172.10.250.26/irisestandar/csp/iris108/kpi/query
```

---

## Configuración

### Variables de Configuración (Globals)

#### Configuración del Sistema

```objectscript
// URLs y Credenciales
^IRIS108.Config("BIBaseUrl")      // Base URL del BI REST API
^IRIS108.Config("BIUser")         // Usuario para autenticación BI
^IRIS108.Config("BIPass")         // Password para autenticación BI
^IRIS108.Config("ApiKey")         // API Key para clientes externos

// Flags de Debug (solo desarrollo)
^IRIS108.Config("DebugWrite")          // true/false - Habilita trazas generales
^IRIS108.Config("DebugIncludeRaw")     // true/false - Incluye bi_response_raw en cube/query
^IRIS108.Config("DebugKpi")            // true/false - Headers X-Debug-* en kpi/query
```

### Archivos de Configuración

El proyecto usa configuración basada en YAML (o JSON en globals como fallback):

#### 1. `config/agent_limits.yaml`

Define límites globales y contratos de respuesta:

```yaml
version: "1.0.0"
api:
  base_path: "/csp/iris108"
  auth:
    header_name: "X-API-Key"

limits:
  max_date_range_days: 400      # Máximo rango de fechas
  max_rows_default: 200         # Filas por defecto
  max_rows_hard: 5000           # Límite absoluto de filas
  max_group_by: 3               # Máximo número de agrupaciones
  allowed_grains: ["day"]       # Granularidades permitidas
```

#### 2. `config/dimensions.yaml`

Define dimensiones permitidas para filtrado y agrupación:

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

#### 3. `config/kpi_registry.yaml`

Registra KPIs disponibles y sus restricciones:

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

#### 4. `config/cube_templates.yaml`

Define templates MDX seguros para ejecución:

```yaml
templates:
  FACTINV_FACT_COUNT_BY_DAY:
    cube_id: "SISS"
    description: "Cantidad de facturas por dia"
    bi_rest_endpoint: "/Data/MDXExecute"
    params:
      from: {type: "date", required: true}
      to: {type: "date", required: true}
      group_by: {type: "string_array", required: false, max_items: 2}
      filters: {type: "filter_array", required: false}
      limit: {type: "int", required: false, default: 200, max: 5000}
    mdx: |
      SELECT
        { [Measures].[%COUNT] } ON 0,
        NON EMPTY {{ROW_AXIS}} ON 1
      FROM [SISS]
      WHERE ( {{WHERE_SLICERS}} )
```

### Cargar Configuración en IRIS

```objectscript
// Cargar desde archivo JSON
Set stream = ##class(%Stream.FileCharacter).%New()
Do stream.LinkToFile("/opt/irisapp/config/agent_limits.json")
Set json = stream.Read()
Set ^IRIS108.ConfigData("agent_limits","json") = json
```

---

## API Reference

### Endpoints Disponibles

#### 1. `GET /csp/iris108/ping`

Verificar disponibilidad del servicio.

**Request:**
```bash
curl -i http://servidor/csp/iris108/ping
```

**Response:**
```json
{"status": "ok"}
```

---

#### 2. `GET /csp/iris108/capabilities`

Obtener capacidades del sistema (KPIs, cubos, límites).

**Request:**
```bash
curl -i -H 'X-API-Key: MI_API_KEY' \
  http://servidor/csp/iris108/capabilities
```

**Response:**
```json
{
  "kpis": ["fact_count", "total_facturado"],
  "cubes": ["SISS"],
  "limits": {
    "max_date_range_days": 400,
    "max_rows_default": 200,
    "max_rows_hard": 5000
  },
  "correlation_id": "uuid",
  "metadata": {
    "executed_at": "2024-01-01T00:00:00Z",
    "execution_ms": 10
  }
}
```

---

#### 3. `POST /csp/iris108/kpi/explain`

Obtener definición y fórmula de un KPI.

**Request:**
```bash
curl -i -H 'X-API-Key: MI_API_KEY' \
  -H 'Content-Type: application/json' \
  -d '{"kpi_id": "fact_count"}' \
  http://servidor/csp/iris108/kpi/explain
```

**Response:**
```json
{
  "kpi_id": "fact_count",
  "name": "Cantidad de facturas",
  "unit": "count",
  "definition": "...",
  "correlation_id": "uuid"
}
```

---

#### 4. `POST /csp/iris108/kpi/query`

Consultar valores de KPI con filtros y agrupaciones.

**Request:**
```bash
curl -i -H 'X-API-Key: MI_API_KEY' \
  -H 'Content-Type: application/json' \
  -d '{
    "kpi_id": "fact_count",
    "time": {
      "from": "20160101",
      "to": "20160630",
      "grain": "day"
    },
    "group_by": ["pagador"],
    "filters": [
      {"field": "centro", "op": "eq", "value": "1000"}
    ],
    "options": {
      "limit": 100
    }
  }' \
  http://servidor/csp/iris108/kpi/query
```

**Response:**
```json
{
  "rows": [
    {"fecha": "2016-01-01", "pagador": "PAG001", "value": 150},
    {"fecha": "2016-01-02", "pagador": "PAG001", "value": 142}
  ],
  "metadata": {
    "executed_at": "2024-01-01T00:00:00Z",
    "execution_ms": 245,
    "as_of_cutoff": "2024-01-01T00:00:00Z",
    "row_count": 2
  },
  "correlation_id": "uuid"
}
```

**Validaciones:**
- `kpi_id` debe existir en registry
- `time.from <= time.to`
- Rango de días <= `max_date_range_days`
- `group_by` solo puede usar dimensiones permitidas para el KPI
- `filters` solo pueden usar campos y operadores permitidos
- `limit` no puede exceder `max_rows_hard`

---

#### 5. `POST /csp/iris108/cube/query`

Ejecutar template MDX predefinido.

**Request:**
```bash
curl -i -H 'X-API-Key: MI_API_KEY' \
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
  http://servidor/csp/iris108/cube/query
```

**Response:**
```json
{
  "rows": [
    {"fecha": "2016-01-01", "value": 150},
    {"fecha": "2016-01-02", "value": 142}
  ],
  "metadata": {
    "executed_at": "2024-01-01T00:00:00Z",
    "execution_ms": 312,
    "row_count": 2
  },
  "correlation_id": "uuid"
}
```

**Nota:** Nunca se acepta MDX crudo del cliente, solo `template_id` + `params`.

---

#### 6. `POST /csp/iris108/dq/status`

Consultar estado de calidad de datos y cutoffs.

**Request:**
```bash
curl -i -H 'X-API-Key: MI_API_KEY' \
  -H 'Content-Type: application/json' \
  -d '{
    "subject": "fact_invoice",
    "time": {"from": "20160101", "to": "20160630"}
  }' \
  http://servidor/csp/iris108/dq/status
```

**Response:**
```json
{
  "subject": "fact_invoice",
  "cutoff": "2016-06-30T23:59:59Z",
  "completeness": "100%",
  "issues": [],
  "correlation_id": "uuid",
  "metadata": {
    "executed_at": "2024-01-01T00:00:00Z"
  }
}
```

**Nota:** Si no hay datos en la tabla DQ, `cutoff` puede estar vacío.

---

### Manejo de Errores

Todos los endpoints devuelven errores en formato JSON consistente:

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid date range",
    "details": {...}
  },
  "correlation_id": "uuid"
}
```

**Headers adicionales:**
- `X-Error-Code`: Código de error
- `X-Error-Message`: Mensaje de error

**Códigos de Error Comunes:**
- `401`: API Key inválida o ausente
- `400`: Request mal formado o validación fallida
- `404`: Recurso no encontrado (KPI, template)
- `500`: Error interno del servidor

---

## Desarrollo

### Estructura del Repositorio

```
iris108/
├── config/                      # Configuraciones YAML
│   ├── agent_limits.yaml
│   ├── dimensions.yaml
│   ├── kpi_registry.yaml
│   └── cube_templates.yaml
├── docs/                        # Documentación
│   └── SPRINT_STATUS.md
├── spec/                        # Especificaciones API
│   ├── openapi.yaml            # OpenAPI 3.1
│   ├── swagger2.json           # Swagger 2.0
│   ├── validation_rules.md     # Reglas de validación
│   ├── endpoint_behavior.md    # Comportamiento endpoints
│   └── domain_map.md           # Mapeo de dominios
├── src/                        # Código fuente
│   └── IRIS108/
│       ├── REST/
│       │   └── Service.cls     # Servicio REST principal
│       └── Util/
│           └── Config.cls      # Utilidades de configuración
├── SISS-BI/                    # Clases BI
├── SISS-St/                    # Clases de staging
├── readme.md                   # Documentación principal
├── BUENAS_PRACTICAS_IRIS_COMBINADAS.md  # Guía de buenas prácticas
└── WIKI.md                     # Este archivo (Wiki central)
```

### Compilación e Instalación

#### Desde Terminal IRIS

```objectscript
// 1. Cambiar a namespace correcto
ZN "MLTEST"

// 2. Compilar clases
Do $system.OBJ.CompilePackage("IRIS108", "ckr")

// 3. Verificar compilación
Write $System.Status.GetErrorText($system.OBJ.CompilePackage("IRIS108", "ckr"))
```

#### Desde VS Code

1. Instalar extensión "InterSystems ObjectScript"
2. Configurar conexión en `settings.json`
3. Usar comando "Compile Current File" (`Ctrl+Shift+P`)

### Testing

#### Tests Manuales (curl)

Ver ejemplos completos en [API Reference](#api-reference) y en `docs/SPRINT_STATUS.md`.

#### Traces de Debug

```objectscript
// Habilitar debug temporalmente
Set ^IRIS108.Config("DebugWrite") = "true"

// Habilitar raw BI response
Set ^IRIS108.Config("DebugIncludeRaw") = "true"

// Habilitar headers debug KPI
Set ^IRIS108.Config("DebugKpi") = "true"

// Deshabilitar después de debug
Kill ^IRIS108.Config("DebugWrite")
Kill ^IRIS108.Config("DebugIncludeRaw")
Kill ^IRIS108.Config("DebugKpi")
```

### Workflow de Desarrollo

1. **Modificar código**: Editar `.cls` en VS Code
2. **Compilar**: `Do $system.OBJ.Compile("IRIS108.REST.Service", "ck")`
3. **Probar**: Ejecutar curl con endpoint modificado
4. **Debug**: Revisar logs y usar flags de debug si necesario
5. **Validar**: Verificar que response JSON es correcto
6. **Commit**: Guardar cambios en git

---

## Troubleshooting

### Problemas Comunes

#### 1. Error 500 HTML del Web Gateway

**Síntoma:** Respuesta HTML en lugar de JSON con error 500.

**Causa:** Error en ObjectScript antes de enviar headers JSON.

**Solución:**
- Usar `WriteError()` y `WriteJson()` consistentemente
- Verificar compilación exitosa: `Do $system.OBJ.Compile(...)`
- Revisar logs en Management Portal
- Usar flags de debug para inspeccionar flujo

#### 2. API Key Inválida

**Síntoma:** 401 Unauthorized

**Causa:** Header `X-API-Key` ausente o no coincide con global.

**Solución:**
```objectscript
// Verificar API Key configurada
Write ^IRIS108.Config("ApiKey")

// Actualizar si necesario
Set ^IRIS108.Config("ApiKey") = "NUEVA_KEY"
```

#### 3. BI REST Timeout

**Síntoma:** Request a `/cube/query` o `/kpi/query` tarda mucho o falla.

**Causa:** 
- Rango de fechas muy grande
- Cubo no optimizado
- Credenciales BI incorrectas

**Solución:**
```objectscript
// Verificar credenciales BI
Write ^IRIS108.Config("BIUser")
Write ^IRIS108.Config("BIBaseUrl")

// Probar con rango pequeño
// from: "20160101", to: "20160107"
```

#### 4. Respuesta Vacía de DQ

**Síntoma:** `cutoff` vacío en `/dq/status`

**Causa:** Tabla `SISS_St.FactInvoice` sin datos o `CutoffTs` NULL.

**Solución:**
- Verificar que hay datos: `SELECT COUNT(*) FROM SISS_St.FactInvoice`
- Esto es normal si no hay cutoff registrado
- Response JSON es correcto con `cutoff: ""`

#### 5. Template MDX No Funciona

**Síntoma:** Error al ejecutar template en `/cube/query`

**Causa:**
- Template ID no existe en `cube_templates.yaml`
- Measure name incorrecto (debe ser nombre interno sin espacios)
- Cubo no existe o no está compilado

**Solución:**
```objectscript
// Verificar cubo existe
Write ##class(%DeepSee.Utils).%GetCubeDefinition("SISS")

// Verificar measure names
// Usar nombres internos: "TotalFacturado" no "Total Facturado"
```

### Logs y Diagnóstico

#### Management Portal

1. Acceder a `http://servidor/csp/sys/UtilHome.csp`
2. Navegar a "System Operation" → "Messages"
3. Filtrar por namespace `MLTEST`
4. Buscar errores recientes

#### Globals para Debug

```objectscript
// Ver configuración completa
Do ##class(IRIS108.Util.Config).DumpConfig()

// Ver última respuesta BI (si debug habilitado)
Write ^IRIS108.Debug("LastBIResponse")

// Ver último error
Write ^IRIS108.Debug("LastError")
```

#### Headers de Debug

Al activar flags de debug, los headers de respuesta incluyen información adicional:

- `X-Debug-Template-Id`: Template MDX usado
- `X-Debug-Validation-Status`: Estado de validaciones
- `X-Error-Code`: Código de error cuando falla
- `X-Error-Message`: Mensaje de error cuando falla

---

## Buenas Prácticas

### Seguridad

✅ **DO**
- Usar API Key authentication en todos los endpoints
- Validar todos los inputs contra allow-lists
- Nunca aceptar MDX/SQL crudo del cliente
- Rotar API Keys periódicamente
- Usar HTTPS en producción

❌ **DON'T**
- Hardcodear credenciales en código
- Exponer raw SQL/MDX en logs
- Devolver stack traces al cliente
- Permitir date ranges ilimitados

### Performance

✅ **DO**
- Definir límites razonables en `agent_limits.yaml`
- Usar índices en tablas DQ
- Optimizar templates MDX
- Cachear resultados de `/capabilities`

❌ **DON'T**
- Permitir queries sin límite de filas
- Ejecutar MDX sin filtros de tiempo
- Cargar configuración en cada request

### Mantenimiento

✅ **DO**
- Documentar todos los KPIs nuevos en registry
- Versionar cambios en templates MDX
- Mantener CHANGELOG actualizado
- Probar templates antes de producción
- Deshabilitar flags de debug en prod

❌ **DON'T**
- Modificar templates en producción sin testing
- Dejar flags de debug habilitados permanentemente
- Cambiar schemas de response sin versionar API

### Código ObjectScript

✅ **DO**
- Usar `$$$OK` y `$$$ISERR` para status codes
- Implementar manejo de errores robusto
- Usar `WriteError()` y `WriteJson()` para responses
- Agregar `correlation_id` a todas las responses
- Incluir metadata en responses

❌ **DON'T**
- Usar `Write` directamente (usar `WriteJson`)
- Ignorar errores de compilación
- Mezclar HTML y JSON en responses
- Dejar código debug en producción

Ver más detalles en [BUENAS_PRACTICAS_IRIS_COMBINADAS.md](BUENAS_PRACTICAS_IRIS_COMBINADAS.md).

---

## Estado del Proyecto

### Estado Actual (Última Actualización)

✅ **Completado:**
- API REST funcional con todos los endpoints
- Validación server-side implementada
- Integración con BI REST operativa
- Credenciales en globals (no hardcoded)
- Manejo de errores JSON consistente
- Debug flags implementados
- Templates MDX básicos funcionando

🔄 **En Progreso:**
- Validación exhaustiva de todos los templates
- Optimización de queries MDX
- Documentación de KPIs adicionales

⏳ **Pendiente:**
- Regeneración de clases vía `/api/mgmnt` (endpoint no responde)
- Testing de KPIs adicionales
- Implementación de caching
- Dashboard de monitoreo

### Métricas

- **KPIs Registrados**: 2 (fact_count, total_facturado)
- **Templates MDX**: 2
- **Dimensiones**: 2 (pagador, centro)
- **Endpoints**: 6 operacionales
- **Cubo Activo**: SISS (FactInvoiceCube)

Ver más detalles en [docs/SPRINT_STATUS.md](docs/SPRINT_STATUS.md).

---

## Referencias

### Documentación Interna

- [README.md](readme.md) - Documentación principal del proyecto
- [BUENAS_PRACTICAS_IRIS_COMBINADAS.md](BUENAS_PRACTICAS_IRIS_COMBINADAS.md) - Guía completa de buenas prácticas
- [docs/SPRINT_STATUS.md](docs/SPRINT_STATUS.md) - Estado actual del sprint
- [spec/validation_rules.md](spec/validation_rules.md) - Reglas de validación
- [spec/endpoint_behavior.md](spec/endpoint_behavior.md) - Comportamiento de endpoints
- [spec/openapi.yaml](spec/openapi.yaml) - Especificación OpenAPI 3.1

### Documentación Externa

#### InterSystems IRIS
- [Creating REST Services](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GREST_csprest)
- [Securing REST Services](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GREST_securing)
- [BI REST API - MDXExecute](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=D2CLIENT_post_data_mdxexecute)

#### OpenAI
- [GPT Actions Introduction](https://platform.openai.com/docs/actions/introduction)
- [GPT Action Authentication](https://platform.openai.com/docs/actions/authentication)

### Contacto y Soporte

Para preguntas o soporte, consultar:
- Repositorio: https://github.com/christianasmussenb/iris108
- Management Portal: http://172.10.250.26/irisestandar/csp/sys/UtilHome.csp

---

**Última actualización:** 2026-01-29  
**Versión del proyecto:** 1.0.0  
**Namespace:** MLTEST  
**Cubo BI:** SISS (SISS.BI.FactInvoiceCube)
