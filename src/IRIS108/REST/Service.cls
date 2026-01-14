Include %occStatus

Class IRIS108.REST.Service Extends %CSP.REST
{

Parameter HandleCorsRequest = 0;

XData UrlMap [ XMLNamespace = "https://www.intersystems.com/urlmap" ]
{
<Routes>
  <Route Url="/ping" Method="GET" Call="Ping" />
  <Route Url="/capabilities" Method="GET" Call="GetCapabilities" />
  <Route Url="/kpi/explain" Method="POST" Call="ExplainKpi" />
  <Route Url="/kpi/query" Method="POST" Call="QueryKpi" />
  <Route Url="/cube/query" Method="POST" Call="QueryCube" />
  <Route Url="/dq/status" Method="POST" Call="DqStatus" />
</Routes>
}

ClassMethod Ping() As %Status
{
  Set %response.ContentType = "application/json"
  Write "{""status"":""ok""}",!
  Quit $$$OK
}

Method OnError() As %Status
{
  Set response = ##class(%DynamicObject).%New()
  Do response.%Set("error", "internal_error")
  Do response.%Set("message", $ZERROR)
  Do response.%Set("status", $SYSTEM.Status.GetErrorText($ZSTATUS))
  Do %response.SetStatus(500)
  Do %response.SetHeader("Content-Type", "application/json")
  Do %response.Write(response.%ToJSON())
  Quit $$$OK
}

ClassMethod GetCapabilities() As %Status
{
  Set tStart = $ZTIMESTAMP
  Set sc = ..RequireApiKey()
  If $$$ISERR(sc) Quit sc

  Set sc = ##class(IRIS108.Util.Config).Load("agent_limits.yaml", .limits)
  If $$$ISERR(sc) Quit sc
  Set sc = ##class(IRIS108.Util.Config).Load("dimensions.yaml", .dims)
  If $$$ISERR(sc) Quit sc
  Set sc = ##class(IRIS108.Util.Config).Load("kpi_registry.yaml", .kpis)
  If $$$ISERR(sc) Quit sc
  Set sc = ##class(IRIS108.Util.Config).Load("cube_templates.yaml", .templates)
  If $$$ISERR(sc) Quit sc

  Set response = ##class(%DynamicObject).%New()
  Do response.%Set("kpis", kpis)
  Do response.%Set("dimensions", dims)
  Do response.%Set("cube_templates", templates)
  Do response.%Set("limits", limits)
  Do ..AddMetadata(.response, tStart)
  Do ..WriteJson(200, response)
  Quit $$$OK
}

ClassMethod ExplainKpi() As %Status
{
  Set tStart = $ZTIMESTAMP
  Set sc = ..RequireApiKey()
  If $$$ISERR(sc) Quit sc

  Set sc = ..ReadJsonBody(.req)
  If $$$ISERR(sc) Quit sc

  Set kpiId = $Get(req.%Get("kpi_id"), "")
  If kpiId = "" Quit ..WriteError(400, "invalid_request", "kpi_id requerido")

  Set sc = ##class(IRIS108.Util.Config).Load("kpi_registry.yaml", .kpis)
  If $$$ISERR(sc) Quit sc

  Set kpiMap = kpis.%Get("kpis")
  Set kpi = ""
  If $IsObject(kpiMap) Set kpi = kpiMap.%Get(kpiId)
  If '$IsObject(kpi) Quit ..WriteError(404, "kpi_not_found", "KPI no registrado")

  Set response = ##class(%DynamicObject).%New()
  Do response.%Set("kpi_id", kpiId)
  Do response.%Set("definition", kpi)
  Do ..AddMetadata(.response, tStart)
  Do ..WriteJson(200, response)
  Quit $$$OK
}

ClassMethod QueryKpi() As %Status
{
  Set tStart = $ZTIMESTAMP
  Set sc = ..RequireApiKey()
  If $$$ISERR(sc) Quit sc

  Set sc = ..ReadJsonBody(.req)
  If $$$ISERR(sc) Quit sc

  Set kpiId = $Get(req.%Get("kpi_id"), "")
  If kpiId = "" Quit ..WriteError(400, "invalid_request", "kpi_id requerido")

  Set sc = ##class(IRIS108.Util.Config).Load("agent_limits.yaml", .limits)
  If $$$ISERR(sc) Quit sc
  Set sc = ##class(IRIS108.Util.Config).Load("dimensions.yaml", .dims)
  If $$$ISERR(sc) Quit sc
  Set sc = ##class(IRIS108.Util.Config).Load("kpi_registry.yaml", .kpis)
  If $$$ISERR(sc) Quit sc
  Set sc = ##class(IRIS108.Util.Config).Load("cube_templates.yaml", .templates)
  If $$$ISERR(sc) Quit sc

  Set kpiMap = kpis.%Get("kpis")
  Set kpi = ""
  If $IsObject(kpiMap) Set kpi = kpiMap.%Get(kpiId)
  If '$IsObject(kpi) Quit ..WriteError(404, "kpi_not_found", "KPI no registrado")

  Set time = req.%Get("time")
  If '$IsObject(time) Quit ..WriteError(400, "invalid_request", "time requerido")

  Set grain = $Get(time.%Get("grain"), "")
  If grain = "" Quit ..WriteError(400, "invalid_request", "time.grain requerido")

  Set allowedGrains = kpi.%Get("allowed_grains")
  If '$IsObject(allowedGrains) Quit ..WriteError(400, "invalid_request", "KPI sin grains")
  If ' ..Contains(allowedGrains, grain) Quit ..WriteError(400, "invalid_request", "grain no permitido")

  Set limitsObj = limits.%Get("limits")
  Set limitsGrains = ""
  If $IsObject(limitsObj) Set limitsGrains = limitsObj.%Get("allowed_grains")
  If $IsObject(limitsGrains) {
    If ' ..Contains(limitsGrains, grain) Quit ..WriteError(400, "invalid_request", "grain no permitido por limites")
  }

  Set sc = ..ParseDate($Get(time.%Get("from"), ""), .fromYMD, .fromH)
  If $$$ISERR(sc) Quit sc
  Set sc = ..ParseDate($Get(time.%Get("to"), ""), .toYMD, .toH)
  If $$$ISERR(sc) Quit sc
  If fromH > toH Quit ..WriteError(400, "invalid_request", "time.from > time.to")

  Set maxDays = $Get(limitsObj.%Get("max_date_range_days"), 0)
  If maxDays > 0 {
    If ((toH - fromH) > maxDays) Quit ..WriteError(400, "invalid_request", "rango de fechas excede maximo")
  }

  Set groupBy = req.%Get("group_by")
  If $IsObject(groupBy) {
    If groupBy.%Size() > $Get(limitsObj.%Get("max_group_by"), 0) Quit ..WriteError(400, "invalid_request", "group_by excede maximo")
  }

  Set filters = req.%Get("filters")

  Set sc = ..ValidateGroupBy(groupBy, kpi)
  If $$$ISERR(sc) Quit sc
  Set sc = ..ValidateFilters(filters, kpi, dims)
  If $$$ISERR(sc) Quit sc

  Set templatesMap = templates.%Get("templates")
  Set mdxTemplates = kpi.%Get("mdx_templates")
  Set templateId = ""
  If $IsObject(mdxTemplates) Set templateId = mdxTemplates.%Get(grain)
  If templateId = "" Quit ..WriteError(500, "template_missing", "template no configurado para grain")

  Set template = ""
  If $IsObject(templatesMap) Set template = templatesMap.%Get(templateId)
  If '$IsObject(template) Quit ..WriteError(500, "template_missing", "template no encontrado")

  Set limit = $Get(limitsObj.%Get("max_rows_default"), 200)
  Set options = req.%Get("options")
  If $IsObject(options) Set limit = $Get(options.%Get("limit"), limit)
  If limit > $Get(limitsObj.%Get("max_rows_hard"), 5000) Quit ..WriteError(400, "invalid_request", "limit excede maximo")

  Set mdx = ..BuildMdx($Get(template.%Get("mdx"), ""), fromYMD, toYMD, groupBy, filters, limit)
  If mdx = "" Quit ..WriteError(500, "mdx_build_error", "no se pudo construir mdx")

  Set sc = ..ExecuteMdx($Get(template.%Get("bi_rest_endpoint"), ""), mdx, .biResp)
  If $$$ISERR(sc) Quit sc

  Set response = ##class(%DynamicObject).%New()
  Do response.%Set("kpi_id", kpiId)
  Do response.%Set("template_id", templateId)
  Do response.%Set("rows", ..NormalizeMdxResponse(biResp, groupBy))
  Do ..AddMetadata(.response, tStart)
  Do ..WriteJson(200, response)
  Quit $$$OK
}

ClassMethod QueryCube() As %Status
{
  Set tStart = $ZTIMESTAMP
  Set sc = ..RequireApiKey()
  If $$$ISERR(sc) Quit sc

  Set sc = ..ReadJsonBody(.req)
  If $$$ISERR(sc) Quit sc

  Set templateId = $Get(req.%Get("template_id"), "")
  If templateId = "" Quit ..WriteError(400, "invalid_request", "template_id requerido")

  Set sc = ##class(IRIS108.Util.Config).Load("cube_templates.yaml", .templates)
  If $$$ISERR(sc) Quit sc

  Set templatesMap = templates.%Get("templates")
  Set template = ""
  If $IsObject(templatesMap) Set template = templatesMap.%Get(templateId)
  If '$IsObject(template) Quit ..WriteError(404, "template_not_found", "template no encontrado")

  Set params = req.%Get("params")
  If '$IsObject(params) Quit ..WriteError(400, "invalid_request", "params requerido")

  Set sc = ..ParseDate($Get(params.%Get("from"), ""), .fromYMD, .fromH)
  If $$$ISERR(sc) Quit sc
  Set sc = ..ParseDate($Get(params.%Get("to"), ""), .toYMD, .toH)
  If $$$ISERR(sc) Quit sc

  Set groupBy = params.%Get("group_by")
  Set filters = params.%Get("filters")
  Set limit = $Get(params.%Get("limit"), 200)

  Set mdx = ..BuildMdx($Get(template.%Get("mdx"), ""), fromYMD, toYMD, groupBy, filters, limit)
  If mdx = "" Quit ..WriteError(500, "mdx_build_error", "no se pudo construir mdx")

  Set sc = ..ExecuteMdx($Get(template.%Get("bi_rest_endpoint"), ""), mdx, .biResp)
  If $$$ISERR(sc) Quit sc

  Set response = ##class(%DynamicObject).%New()
  Do response.%Set("template_id", templateId)
  Do response.%Set("rows", ..NormalizeMdxResponse(biResp, groupBy))
  Do ..AddMetadata(.response, tStart)
  Do ..WriteJson(200, response)
  Quit $$$OK
}

ClassMethod DqStatus() As %Status
{
  Set tStart = $ZTIMESTAMP
  Set sc = ..RequireApiKey()
  If $$$ISERR(sc) Quit sc

  Set sc = ..ReadJsonBody(.req)
  If $$$ISERR(sc) Quit sc

  Set sc = ..GetLastCutoff(.cutoff)
  If $$$ISERR(sc) Quit sc

  Set response = ##class(%DynamicObject).%New()
  Do response.%Set("cutoff", cutoff)
  Do ..AddMetadata(.response, tStart)
  Do ..WriteJson(200, response)
  Quit $$$OK
}

ClassMethod RequireApiKey() As %Status
{
  Set expected = $Get(^IRIS108.Config("ApiKey"))
  If expected = "" Quit ..WriteError(500, "api_key_not_configured", "ApiKey no configurada en ^IRIS108.Config(""ApiKey"")")
  Set provided = ..GetHeaderValue("X-API-Key")
  If provided = "" Quit ..WriteError(401, "unauthorized", "X-API-Key requerido")
  If provided '= expected Quit ..WriteError(401, "unauthorized", "X-API-Key invalida")
  Quit $$$OK
}

ClassMethod ReadJsonBody(ByRef req As %DynamicObject) As %Status
{
  Set tStream = %request.Content
  If tStream = "" Quit ..WriteError(400, "invalid_request", "body requerido")
  Set tJson = tStream.Read()
  Set sc = $$$OK
  Try {
    Set req = ##class(%DynamicObject).%FromJSON(tJson)
  } Catch ex {
    Do ..WriteError(400, "invalid_json", "body no es JSON valido")
    Set sc = $$$ERROR(400)
  }
  Quit sc
}

ClassMethod ParseDate(pValue As %String, ByRef ymd As %String, ByRef hDate As %Date) As %Status
{
  Set clean = $Translate(pValue, "-", "")
  If $Length(clean) '= 8 Quit ..WriteError(400, "invalid_request", "fecha invalida")
  Set ymd = clean
  Set hDate = $ZDATEH(clean, 8)
  Quit $$$OK
}

ClassMethod ValidateGroupBy(groupBy As %DynamicArray, kpi As %DynamicObject) As %Status
{
  If '$IsObject(groupBy) Quit $$$OK
  Set allow = kpi.%Get("allow")
  Set allowed = ""
  If $IsObject(allow) Set allowed = allow.%Get("group_by")
  If '$IsObject(allowed) Quit ..WriteError(400, "invalid_request", "group_by no permitido")

  Set i = 0
  Set sc = $$$OK
  For {
    Set i = i + 1
    If i > groupBy.%Size() Quit
    Set key = groupBy.%Get(i)
    If key = "" {
      Set sc = ..WriteError(400, "invalid_request", "group_by vacio")
      Quit
    }
    If ' ..Contains(allowed, key) {
      Set sc = ..WriteError(400, "invalid_request", "group_by no permitido")
      Quit
    }
  }
  If $$$ISERR(sc) Quit sc
  Quit $$$OK
}

ClassMethod ValidateFilters(filters As %DynamicArray, kpi As %DynamicObject, dims As %DynamicObject) As %Status
{
  If '$IsObject(filters) Quit $$$OK

  Set allow = kpi.%Get("allow")
  Set allowed = ""
  If $IsObject(allow) Set allowed = allow.%Get("filters")
  If '$IsObject(allowed) Quit ..WriteError(400, "invalid_request", "filters no permitidos")

  Set dimsMap = dims.%Get("dimensions")

  Set i = 0
  Set sc = $$$OK
  For {
    Set i = i + 1
    If i > filters.%Size() Quit
    Set f = filters.%Get(i)
    If '$IsObject(f) {
      Set sc = ..WriteError(400, "invalid_request", "filter invalido")
      Quit
    }
    Set field = $Get(f.%Get("field"), "")
    If field = "" {
      Set sc = ..WriteError(400, "invalid_request", "filter.field requerido")
      Quit
    }
    If ' ..Contains(allowed, field) {
      Set sc = ..WriteError(400, "invalid_request", "filter.field no permitido")
      Quit
    }
    Set dim = ""
    If $IsObject(dimsMap) Set dim = dimsMap.%Get(field)
    If '$IsObject(dim) {
      Set sc = ..WriteError(400, "invalid_request", "dimension no registrada")
      Quit
    }
    Set op = $Get(f.%Get("op"), "")
    If op = "" {
      Set sc = ..WriteError(400, "invalid_request", "filter.op requerido")
      Quit
    }
    Set allowedOps = dim.%Get("allowed_ops")
    If '$IsObject(allowedOps) {
      Set sc = ..WriteError(400, "invalid_request", "filter.op no permitido")
      Quit
    }
    If ' ..Contains(allowedOps, op) {
      Set sc = ..WriteError(400, "invalid_request", "filter.op no permitido")
      Quit
    }
  }
  If $$$ISERR(sc) Quit sc
  Quit $$$OK
}

ClassMethod Contains(list As %DynamicArray, value As %String) As %Boolean
{
  If '$IsObject(list) Quit 0
  Set i = 0
  Set found = 0
  For {
    Set i = i + 1
    If i > list.%Size() Quit
    If list.%Get(i) = value {
      Set found = 1
      Quit
    }
  }
  Quit found
}

ClassMethod BuildMdx(template As %String, fromYMD As %String, toYMD As %String, groupBy As %DynamicArray, filters As %DynamicArray, limit As %Integer) As %String
{
  Set dateSet = "[FechaFactura].[H1].[FKDAT].&["_fromYMD_"] : [FechaFactura].[H1].[FKDAT].&["_toYMD_"]"
  Set rowAxis = dateSet
  Set buildOk = 1

  If $IsObject(groupBy) {
    Set i = 0
    For {
      Set i = i + 1
      If i > groupBy.%Size() Quit
      Set dim = ..DimMembers(groupBy.%Get(i))
      If dim = "" {
        Set buildOk = 0
        Quit
      }
      Set rowAxis = "CROSSJOIN("_rowAxis_","_dim_")"
    }
    If 'buildOk Quit ""
  }

  If limit > 0 {
    Set rowAxis = "HEAD("_rowAxis_","_limit_")"
  }

  Set slicers = ""
  If $IsObject(filters) {
    Set i = 0
    For {
      Set i = i + 1
      If i > filters.%Size() Quit
      Set f = filters.%Get(i)
      Set slicer = ..BuildFilterSlicer(f)
      If slicer = "" {
        Set buildOk = 0
        Quit
      }
      If slicers'="" Set slicers = slicers_", "
      Set slicers = slicers_slicer
    }
    If 'buildOk Quit ""
  }

  Set mdx = $Replace(template, "{{ROW_AXIS}}", rowAxis)
  If slicers = "" {
    Set mdx = $Replace(mdx, "WHERE ( {{WHERE_SLICERS}} )", "")
  } Else {
    Set mdx = $Replace(mdx, "{{WHERE_SLICERS}}", slicers)
  }
  Quit mdx
}

ClassMethod DimMembers(key As %String) As %String
{
  If key = "pagador" Quit "[Pagador].[H1].[KUNGR].Members"
  If key = "centro" Quit "[Centro].[H1].[ISHKOSTR].Members"
  Quit ""
}

ClassMethod BuildFilterSlicer(filter As %DynamicObject) As %String
{
  Set field = $Get(filter.%Get("field"), "")
  Set op = $Get(filter.%Get("op"), "")
  Set value = filter.%Get("value")
  Set level = ""
  If field = "pagador" Set level = "[Pagador].[H1].[KUNGR]"
  If field = "centro" Set level = "[Centro].[H1].[ISHKOSTR]"
  If level = "" Quit ""

  Set members = level_".Members"
  If op = "eq" Quit level_".&["_..EscapeKey(value)_"]"
  If op = "in" {
    Set set = ..BuildMemberSet(level, value)
    Quit set
  }
  If op = "nin" {
    Set set = ..BuildMemberSet(level, value)
    Quit "EXCEPT("_members_","_set_")"
  }
  Quit ""
}

ClassMethod BuildMemberSet(level As %String, value) As %String
{
  If $IsObject(value) {
    If value.%IsA("%DynamicArray") {
      Set i = 0
      Set set = "{"
      For {
        Set i = i + 1
        If i > value.%Size() Quit
        If i > 1 Set set = set_","
        Set set = set_level_".&["_..EscapeKey(value.%Get(i))_"]"
      }
      Set set = set_"}"
      Quit set
    }
  }
  Quit "{"_level_".&["_..EscapeKey(value)_"]}"
}

ClassMethod EscapeKey(value As %String) As %String
{
  Set clean = $ZSTRIP($Get(value), "<W")
  Quit $Replace(clean, "]", "]]")
}

ClassMethod ExecuteMdx(endpoint As %String, mdx As %String, ByRef responseObj As %DynamicObject) As %Status
{
  Set baseUrl = $Get(^IRIS108.Config("BIBaseUrl"))
  If baseUrl = "" Quit ..WriteError(500, "bi_base_url_missing", "Configurar ^IRIS108.Config(""BIBaseUrl"")")

  Set parser = ##class(%Net.URLParser).%New()
  Do parser.Parse(baseUrl)

  Set req = ##class(%Net.HttpRequest).%New()
  Set req.Server = parser.Host
  Set req.Port = parser.Port
  Set req.Https = (parser.Scheme = "https")
  Set path = parser.Path _ endpoint
  If parser.Path = "" Set path = endpoint
  Set req.Location = path
  Do req.SetHeader("Content-Type", "application/json")

  Set payload = ##class(%DynamicObject).%New()
  Do payload.%Set("MDX", mdx)
  Set json = payload.%ToJSON()

  Set sc = req.Post(path, json)
  If $$$ISERR(sc) Quit ..WriteError(502, "bi_call_failed", $SYSTEM.Status.GetErrorText(sc))

  Set raw = req.HttpResponse.Data.Read()
  Try {
    Set responseObj = ##class(%DynamicObject).%FromJSON(raw)
  } Catch ex {
    Do ..WriteError(502, "bi_invalid_response", "Respuesta BI no es JSON valido")
    Set sc = $$$ERROR(502)
  }
  If $$$ISERR(sc) Quit sc
  Quit $$$OK
}

ClassMethod NormalizeMdxResponse(biResp As %DynamicObject, groupBy As %DynamicArray) As %DynamicArray
{
  Set rows = ##class(%DynamicArray).%New()
  If '$IsObject(biResp) Quit rows
  Set axes = biResp.%Get("Axes")
  If '$IsObject(axes) Quit rows
  Set axis0 = axes.%Get(1)
  Set axis1 = axes.%Get(2)
  If '$IsObject(axis0) Quit rows
  If '$IsObject(axis1) Quit rows
  Set measures = axis0.%Get("Tuples")
  Set tuples = axis1.%Get("Tuples")
  If '$IsObject(measures) Quit rows
  If '$IsObject(tuples) Quit rows
  Set mCount = measures.%Size()
  If mCount < 1 Quit rows

  Set data = biResp.%Get("Data")
  If '$IsObject(data) Quit rows

  Set tCount = tuples.%Size()
  Set i = 0
  For {
    Set i = i + 1
    If i > tCount Quit
    Set tuple = tuples.%Get(i)
    Set members = tuple.%Get("Members")
    If '$IsObject(members) Continue

    Set row = ##class(%DynamicObject).%New()
    Set member1 = members.%Get(1)
    Set fecha = ""
    If $IsObject(member1) Set fecha = $Get(member1.%Get("Caption"), $Get(member1.%Get("Name"), ""))
    Do row.%Set("fecha", fecha)

    If $IsObject(groupBy) {
      Set j = 0
      For {
        Set j = j + 1
        If j > groupBy.%Size() Quit
        Set key = groupBy.%Get(j)
        Set member = members.%Get(j + 1)
        Set val = ""
        If $IsObject(member) Set val = $Get(member.%Get("Caption"), $Get(member.%Get("Name"), ""))
        Do row.%Set(key, val)
      }
    }

    Set dataIndex = ((i - 1) * mCount) + 1
    Do row.%Set("value", $Get(data.%Get(dataIndex), ""))
    Do rows.%Push(row)
  }
  Quit rows
}

ClassMethod AddMetadata(ByRef response As %DynamicObject, startTs As %TimeStamp) As %Status
{
  Do response.%Set("correlation_id", $SYSTEM.Util.CreateGUID())
  Set meta = ##class(%DynamicObject).%New()
  Do meta.%Set("executed_at", $ZDATETIME($SYSTEM.Util.UTCNow(), 3, 1))
  Do meta.%Set("execution_ms", ..ElapsedMs(startTs))
  Set sc = ..GetLastCutoff(.cutoff)
  If $$$ISOK(sc) Do meta.%Set("as_of_cutoff", cutoff)
  Do response.%Set("metadata", meta)
  Quit $$$OK
}

ClassMethod ElapsedMs(startTs As %TimeStamp) As %Integer
{
  Set endTs = $ZTIMESTAMP
  Set ms = $SYSTEM.Util.GetMilliSecondsBetween(startTs, endTs)
  Quit ms
}

ClassMethod GetLastCutoff(ByRef cutoff As %String) As %Status
{
  Set cutoff = ""
  Set stmt = ##class(%SQL.Statement).%New()
  Set sc = stmt.%Prepare("SELECT MAX(CutoffTs) FROM SISS.St.FactInvoice")
  If $$$ISERR(sc) Quit sc
  Set rset = stmt.%Execute()
  If rset.%Next() {
    Set cutoff = rset.%Get(1)
  }
  Quit $$$OK
}

ClassMethod WriteJson(status As %Integer, response As %DynamicObject) As %Status
{
  Do %response.SetStatus(status)
  Do %response.SetHeader("Content-Type", "application/json")
  Do %response.Write(response.%ToJSON())
  Quit $$$OK
}

ClassMethod WriteError(status As %Integer, code As %String, message As %String) As %Status
{
  Set response = ##class(%DynamicObject).%New()
  Do response.%Set("error", code)
  Do response.%Set("message", message)
  Do %response.SetStatus(status)
  Do %response.SetHeader("Content-Type", "application/json")
  Do %response.Write(response.%ToJSON())
  Quit $$$ERROR(status)
}

ClassMethod GetHeaderValue(headerName As %String) As %String
{
  Set envName = "HTTP_"_$Translate($ZConvert(headerName, "U"), "-", "_")
  Set value = $Get(%request.CgiEnvs(envName))
  If value = "" Set value = $Get(%request.CgiEnvs(headerName))
  Quit value
}

}
