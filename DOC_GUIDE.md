# 📚 Guía de Documentación - IRIS108

Esta guía te ayuda a encontrar rápidamente la documentación que necesitas según tu rol o tarea.

## 🎯 ¿Qué necesitas hacer?

### Para Empezar (Nuevos Usuarios)

| Tarea | Documento | Sección |
|-------|-----------|---------|
| Entender qué es el proyecto | [WIKI.md](WIKI.md) | Visión General |
| Configurar el entorno | [WIKI.md](WIKI.md) | Inicio Rápido |
| Ver ejemplos de uso | [WIKI.md](WIKI.md) | API Reference |

### Desarrollo y Configuración

| Tarea | Documento | Sección |
|-------|-----------|---------|
| Configurar credenciales y globals | [WIKI.md](WIKI.md) | Configuración |
| Entender estructura del código | [WIKI.md](WIKI.md) | Desarrollo |
| Compilar e instalar | [WIKI.md](WIKI.md) | Desarrollo → Compilación |
| Buenas prácticas de ObjectScript | [BUENAS_PRACTICAS_IRIS_COMBINADAS.md](BUENAS_PRACTICAS_IRIS_COMBINADAS.md) | Todo el documento |

### Trabajar con la API

| Tarea | Documento | Sección |
|-------|-----------|---------|
| Ver endpoints disponibles | [WIKI.md](WIKI.md) | API Reference |
| Entender validaciones | [spec/validation_rules.md](spec/validation_rules.md) | Todo el documento |
| Ver comportamiento de endpoints | [spec/endpoint_behavior.md](spec/endpoint_behavior.md) | Todo el documento |
| Integrar con ChatGPT | [spec/openapi.yaml](spec/openapi.yaml) | Importar en Actions |
| Probar endpoints con curl | [WIKI.md](WIKI.md) | API Reference (ejemplos) |

### Administración y Troubleshooting

| Tarea | Documento | Sección |
|-------|-----------|---------|
| Resolver errores comunes | [WIKI.md](WIKI.md) | Troubleshooting |
| Ver estado del proyecto | [docs/SPRINT_STATUS.md](docs/SPRINT_STATUS.md) | Todo el documento |
| Debug y diagnóstico | [WIKI.md](WIKI.md) | Troubleshooting → Logs |
| Revisar pruebas realizadas | [docs/SPRINT_STATUS.md](docs/SPRINT_STATUS.md) | Pruebas detalladas |

### Configuración Avanzada

| Tarea | Documento | Sección |
|-------|-----------|---------|
| Agregar nuevos KPIs | [WIKI.md](WIKI.md) | Configuración → kpi_registry.yaml |
| Crear templates MDX | [WIKI.md](WIKI.md) | Configuración → cube_templates.yaml |
| Definir dimensiones | [WIKI.md](WIKI.md) | Configuración → dimensions.yaml |
| Ajustar límites | [WIKI.md](WIKI.md) | Configuración → agent_limits.yaml |

## 📁 Estructura de Documentación

```
iris108/
├── 📖 WIKI.md                                    # Wiki principal (EMPEZAR AQUÍ)
├── 📄 readme.md                                  # Overview y arquitectura técnica
├── 📚 DOC_GUIDE.md                               # Esta guía
├── ✅ BUENAS_PRACTICAS_IRIS_COMBINADAS.md       # Guía completa de buenas prácticas
│
├── docs/
│   └── 📋 SPRINT_STATUS.md                       # Estado actual y pruebas
│
├── spec/
│   ├── 🌐 openapi.yaml                           # Especificación OpenAPI 3.1
│   ├── 📜 swagger2.json                          # Especificación Swagger 2.0
│   ├── ✔️  validation_rules.md                   # Reglas de validación
│   ├── 🔧 endpoint_behavior.md                   # Comportamiento de endpoints
│   └── 🗺️  domain_map.md                         # Mapeo de dominios
│
└── config/
    ├── agent_limits.yaml                         # Límites globales
    ├── dimensions.yaml                           # Dimensiones permitidas
    ├── kpi_registry.yaml                         # Registro de KPIs
    └── cube_templates.yaml                       # Templates MDX
```

## 🔍 Por Rol

### Desarrollador Backend (ObjectScript)
1. **Primero lee:** [BUENAS_PRACTICAS_IRIS_COMBINADAS.md](BUENAS_PRACTICAS_IRIS_COMBINADAS.md)
2. **Luego consulta:** [WIKI.md](WIKI.md) → Desarrollo
3. **Para troubleshooting:** [WIKI.md](WIKI.md) → Troubleshooting
4. **Estado actual:** [docs/SPRINT_STATUS.md](docs/SPRINT_STATUS.md)

### Analista de BI / Data Engineer
1. **Primero lee:** [WIKI.md](WIKI.md) → Visión General
2. **Configurar KPIs:** [WIKI.md](WIKI.md) → Configuración → kpi_registry.yaml
3. **Templates MDX:** [WIKI.md](WIKI.md) → Configuración → cube_templates.yaml
4. **Ver ejemplos:** [docs/SPRINT_STATUS.md](docs/SPRINT_STATUS.md) → Pruebas

### Integrador / DevOps
1. **Primero lee:** [WIKI.md](WIKI.md) → Inicio Rápido
2. **Configuración:** [WIKI.md](WIKI.md) → Configuración
3. **API Spec:** [spec/openapi.yaml](spec/openapi.yaml)
4. **Troubleshooting:** [WIKI.md](WIKI.md) → Troubleshooting

### Administrador de Sistemas
1. **Primero lee:** [WIKI.md](WIKI.md) → Configuración
2. **Seguridad:** [WIKI.md](WIKI.md) → Buenas Prácticas → Seguridad
3. **Debug:** [WIKI.md](WIKI.md) → Troubleshooting → Logs
4. **Estado:** [docs/SPRINT_STATUS.md](docs/SPRINT_STATUS.md)

## 🆘 Resolución Rápida de Problemas

| Problema | Ir a |
|----------|------|
| Error 500 HTML | [WIKI.md](WIKI.md) → Troubleshooting → Error 500 |
| API Key inválida | [WIKI.md](WIKI.md) → Troubleshooting → API Key |
| BI REST timeout | [WIKI.md](WIKI.md) → Troubleshooting → BI REST Timeout |
| Respuesta vacía DQ | [WIKI.md](WIKI.md) → Troubleshooting → Respuesta Vacía DQ |
| Template MDX falla | [WIKI.md](WIKI.md) → Troubleshooting → Template MDX |

## 📞 Recursos Adicionales

### Enlaces Internos
- **Repositorio GitHub:** https://github.com/christianasmussenb/iris108
- **Management Portal:** http://172.10.250.26/irisestandar/csp/sys/UtilHome.csp
- **BI UI Analyzer:** http://172.10.250.26/irisestandar/csp/mltest/_DeepSee.UI.Analyzer.zen

### Enlaces Externos (InterSystems)
- [Creating REST Services](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GREST_csprest)
- [BI REST API Documentation](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=D2CLIENT_post_data_mdxexecute)
- [Securing REST Services](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GREST_securing)

### Enlaces Externos (OpenAI)
- [GPT Actions Documentation](https://platform.openai.com/docs/actions/introduction)
- [GPT Action Authentication](https://platform.openai.com/docs/actions/authentication)

## 🎓 Flujo de Aprendizaje Recomendado

### Nivel Principiante
1. Lee [readme.md](readme.md) para entender el overview
2. Lee [WIKI.md](WIKI.md) → Visión General
3. Sigue [WIKI.md](WIKI.md) → Inicio Rápido
4. Prueba los ejemplos de [WIKI.md](WIKI.md) → API Reference

### Nivel Intermedio
1. Estudia [WIKI.md](WIKI.md) → Arquitectura
2. Revisa [spec/validation_rules.md](spec/validation_rules.md)
3. Practica con [WIKI.md](WIKI.md) → Desarrollo
4. Experimenta con configuraciones en [WIKI.md](WIKI.md) → Configuración

### Nivel Avanzado
1. Profundiza en [BUENAS_PRACTICAS_IRIS_COMBINADAS.md](BUENAS_PRACTICAS_IRIS_COMBINADAS.md)
2. Crea nuevos KPIs y templates
3. Optimiza queries MDX
4. Contribuye mejoras al proyecto

## 📝 Notas

- **Documento principal:** Si solo vas a leer un documento, que sea [WIKI.md](WIKI.md)
- **Búsqueda rápida:** Usa Ctrl+F en los documentos markdown para buscar términos específicos
- **Actualizaciones:** Consulta [docs/SPRINT_STATUS.md](docs/SPRINT_STATUS.md) para el estado más reciente

---

**Última actualización:** 2026-01-29  
**Versión:** 1.0.0  
**Mantenido por:** Equipo IRIS108
