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
  Set %response.Status = 500
  Set %response.ContentType = "text/plain"
  Write "internal_error: "_$ZERROR,!
  Quit $$$OK
}

ClassMethod GetCapabilities() As %Status
{
  Try {
    Set sc = ..RequireApiKey()
    If $$$ISERR(sc) Goto Done

    Set %response.ContentType = "text/plain"
    Do ..WriteConfigHead("agent_limits.yaml", "agent_limits")
    Do ..WriteConfigHead("dimensions.yaml", "dimensions")
    Do ..WriteConfigHead("kpi_registry.yaml", "kpi_registry")
    Do ..WriteConfigHead("cube_templates.yaml", "cube_templates")
  } Catch ex {
    Do ..WriteError(500, "internal_error", ex.DisplayString())
  }
Done
  Quit $$$OK
}

ClassMethod ExplainKpi() As %Status
{
  Set sc = $$$OK
  Try {
    Set sc = ..RequireApiKey()
    If $$$ISERR(sc) Goto Done

    Set tStream = %request.Content
    If tStream = "" {
      Do ..WriteError(400, "invalid_request", "body requerido")
      Set sc = $$$ERROR(400)
      Goto Done
    }
    Set tJson = tStream.Read()

    Set kpiId = ""
    Set sc = ..ExtractJsonValue(tJson, "kpi_id", .kpiId)
    If $$$ISERR(sc) Goto Done
    If kpiId = "" {
      Do ..WriteError(400, "invalid_request", "kpi_id requerido")
      Goto Done
    }

    Set regJson = $Get(^IRIS108.ConfigData("kpi_registry", "json"))
    If regJson = "" {
      Do ..WriteError(500, "config_missing", "kpi_registry no encontrado en ^IRIS108.ConfigData")
      Goto Done
    }

    Set kpiJson = ""
    Set sc = ..ExtractJsonObjectByKey(regJson, kpiId, .kpiJson)
    If $$$ISERR(sc) {
      Do ..WriteError(404, "kpi_not_found", "KPI no registrado")
      Goto Done
    }

    Set %response.ContentType = "text/plain"
    Write kpiJson,!
  } Catch ex {
    Do ..WriteError(500, "internal_error", ex.DisplayString())
  }
Done
  Quit $$$OK
}

ClassMethod QueryKpi() As %Status
{
  Set sc = $$$OK
  Try {
    Set %response.ContentType = "text/plain"
    Write "query_kpi:start",!
    Set sc = ..RequireApiKey()
    If $$$ISERR(sc) Goto Done

    Set tStream = %request.Content
    If tStream = "" {
      Do ..WriteError(400, "invalid_request", "body requerido")
      Set sc = $$$ERROR(400)
      Goto Done
    }
    Set tJson = tStream.Read()
    Write "query_kpi:body_ok",!

    Set kpiId = ""
    Set sc = ..ExtractJsonValue(tJson, "kpi_id", .kpiId)
    If $$$ISERR(sc) Goto Done
    If kpiId = "" {
      Do ..WriteError(400, "invalid_request", "kpi_id requerido")
      Goto Done
    }

    Set grain = ""
    Set sc = ..ExtractJsonValue(tJson, "grain", .grain)
    If $$$ISERR(sc) Goto Done
    If grain = "" {
      Do ..WriteError(400, "invalid_request", "time.grain requerido")
      Goto Done
    }

    Set fromVal = ""
    Set sc = ..ExtractJsonValue(tJson, "from", .fromVal)
    If $$$ISERR(sc) Goto Done
    If fromVal = "" {
      Do ..WriteError(400, "invalid_request", "time.from requerido")
      Goto Done
    }

    Set toVal = ""
    Set sc = ..ExtractJsonValue(tJson, "to", .toVal)
    If $$$ISERR(sc) Goto Done
    If toVal = "" {
      Do ..WriteError(400, "invalid_request", "time.to requerido")
      Goto Done
    }

    Set regJson = $Get(^IRIS108.ConfigData("kpi_registry", "json"))
    If regJson = "" {
      Do ..WriteError(500, "config_missing", "kpi_registry no encontrado en ^IRIS108.ConfigData")
      Goto Done
    }

    Set kpiJson = ""
    Set sc = ..ExtractJsonObjectByKey(regJson, kpiId, .kpiJson)
    If $$$ISERR(sc) {
      Do ..WriteError(404, "kpi_not_found", "KPI no registrado")
      Goto Done
    }

    Set mdxTplJson = ""
    Set sc = ..ExtractJsonObjectByKey(kpiJson, "mdx_templates", .mdxTplJson)
    If $$$ISERR(sc) {
      Do ..WriteError(500, "template_missing", "mdx_templates no configurado")
      Goto Done
    }

    Set templateId = ""
    Set sc = ..ExtractJsonValue(mdxTplJson, grain, .templateId)
    If $$$ISERR(sc) Goto Done
    If templateId = "" {
      Do ..WriteError(500, "template_missing", "template no configurado para grain")
      Goto Done
    }

    Set tplRegistry = $Get(^IRIS108.ConfigData("cube_templates", "json"))
    If tplRegistry = "" {
      Do ..WriteError(500, "config_missing", "cube_templates no encontrado en ^IRIS108.ConfigData")
      Goto Done
    }

    Set templateJson = ""
    Set sc = ..ExtractJsonObjectByKey(tplRegistry, templateId, .templateJson)
    If $$$ISERR(sc) {
      Do ..WriteError(500, "template_missing", "template no encontrado")
      Goto Done
    }

    Set mdxTemplate = ""
    Set sc = ..ExtractJsonValue(templateJson, "mdx", .mdxTemplate)
    If $$$ISERR(sc) Goto Done
    If mdxTemplate = "" {
      Do ..WriteError(500, "mdx_build_error", "template mdx vacio")
      Goto Done
    }

    Set sc = ..ParseDate(fromVal, .fromYMD, .fromH)
    If $$$ISERR(sc) Goto Done
    Set sc = ..ParseDate(toVal, .toYMD, .toH)
    If $$$ISERR(sc) Goto Done

    Set limit = 200
    Set mdx = ..BuildMdx(mdxTemplate, fromYMD, toYMD, "", "", limit)
    If mdx = "" {
      Do ..WriteError(500, "mdx_build_error", "no se pudo construir mdx")
      Goto Done
    }

    Write "query_kpi:mdx_ok",!
    Set sc = ..ExecuteMdxRaw(templateJson, mdx, .biRaw, .biUrl)
    If $$$ISERR(sc) Goto Done

    Write "query_kpi:bi_ok",!
    Write "kpi_id: "_kpiId,!
    Write "template_id: "_templateId,!
    Write "bi_url: "_$Get(biUrl),!
    Write "mdx:",!
    Write mdx,!
    Write "bi_response:",!
    Do ..WriteHeadFromString(biRaw, 10, 200)
  } Catch ex {
    Do ..WriteError(500, "internal_error", ex.DisplayString())
  }
Done
  Quit $$$OK
}

ClassMethod QueryCube() As %Status
{
  Set tStart = $ZTIMESTAMP
  Set sc = ..RequireApiKey()
  If $$$ISERR(sc) Goto Done

  Set sc = ..ReadJsonBody(.req)
  If $$$ISERR(sc) Goto Done

  Set templateId = $Get(req.%Get("template_id"), "")
  If templateId = "" {
    Do ..WriteError(400, "invalid_request", "template_id requerido")
    Goto Done
  }

  Set sc = ##class(IRIS108.Util.Config).Load("cube_templates.yaml", .templates)
  If $$$ISERR(sc) {
    Do ..WriteError(500, "config_load_failed", $SYSTEM.Status.GetErrorText(sc))
    Goto Done
  }

  Set templatesMap = templates.%Get("templates")
  Set template = ""
  If $IsObject(templatesMap) Set template = templatesMap.%Get(templateId)
  If '$IsObject(template) {
    Do ..WriteError(404, "template_not_found", "template no encontrado")
    Goto Done
  }

  Set params = req.%Get("params")
  If '$IsObject(params) {
    Do ..WriteError(400, "invalid_request", "params requerido")
    Goto Done
  }

  Set sc = ..ParseDate($Get(params.%Get("from"), ""), .fromYMD, .fromH)
  If $$$ISERR(sc) Goto Done
  Set sc = ..ParseDate($Get(params.%Get("to"), ""), .toYMD, .toH)
  If $$$ISERR(sc) Goto Done

  Set groupBy = params.%Get("group_by")
  Set filters = params.%Get("filters")
  Set limit = $Get(params.%Get("limit"), 200)

  Set mdx = ..BuildMdx($Get(template.%Get("mdx"), ""), fromYMD, toYMD, groupBy, filters, limit)
  If mdx = "" {
    Do ..WriteError(500, "mdx_build_error", "no se pudo construir mdx")
    Goto Done
  }

  Set sc = ..ExecuteMdx($Get(template.%Get("bi_rest_endpoint"), ""), mdx, .biResp)
  If $$$ISERR(sc) Goto Done

  Set response = ##class(%DynamicObject).%New()
  Do response.%Set("template_id", templateId)
  Do response.%Set("rows", ..NormalizeMdxResponse(biResp, groupBy))
  Do ..AddMetadata(.response, tStart)
  Do ..WriteJson(200, response)
Done
  Quit $$$OK
}

ClassMethod DqStatus() As %Status
{
  Set tStart = $ZTIMESTAMP
  Set sc = ..RequireApiKey()
  If $$$ISERR(sc) Goto Done

  Set sc = ..ReadJsonBody(.req)
  If $$$ISERR(sc) Goto Done

  Set sc = ..GetLastCutoff(.cutoff)
  If $$$ISERR(sc) Goto Done

  Set response = ##class(%DynamicObject).%New()
  Do response.%Set("cutoff", cutoff)
  Do ..AddMetadata(.response, tStart)
  Do ..WriteJson(200, response)
Done
  Quit $$$OK
}

ClassMethod RequireApiKey() As %Status
{
  Set sc = $$$OK
  Set expected = $Get(^IRIS108.Config("ApiKey"))
  If expected = "" {
    Do ..WriteError(500, "api_key_not_configured", "ApiKey no configurada en ^IRIS108.Config(""ApiKey"")")
    Set sc = $$$ERROR(500)
    Goto Done
  }
  Set provided = ..GetHeaderValue("X-API-Key")
  If provided = "" {
    Do ..WriteError(401, "unauthorized", "X-API-Key requerido")
    Set sc = $$$ERROR(401)
    Goto Done
  }
  If provided '= expected {
    Do ..WriteError(401, "unauthorized", "X-API-Key invalida")
    Set sc = $$$ERROR(401)
    Goto Done
  }
Done
  Quit sc
}

ClassMethod ReadJsonBody(ByRef req As %DynamicObject) As %Status
{
  Set sc = $$$OK
  Set tStream = %request.Content
  If tStream = "" {
    Do ..WriteError(400, "invalid_request", "body requerido")
    Set sc = $$$ERROR(400)
    Goto Done
  }
  Set tJson = tStream.Read()
  Try {
    Set req = ##class(%DynamicObject).%FromJSON(tJson)
  } Catch ex {
    Do ..WriteError(400, "invalid_json", "body no es JSON valido")
    Set sc = $$$ERROR(400)
  }
Done
  Quit sc
}

ClassMethod ParseDate(pValue As %String, ByRef ymd As %String, ByRef hDate As %Date) As %Status
{
  Set sc = $$$OK
  Set clean = $Translate(pValue, "-", "")
  If $Length(clean) '= 8 {
    Do ..WriteError(400, "invalid_request", "fecha invalida")
    Set sc = $$$ERROR(400)
    Goto Done
  }
  Set ymd = clean
  Set hDate = $ZDATEH(clean, 8)
Done
  Quit sc
}

ClassMethod ValidateGroupBy(groupBy As %DynamicArray, kpi As %DynamicObject) As %Status
{
  Set sc = $$$OK
  If '$IsObject(groupBy) Goto Done
  Set allow = kpi.%Get("allow")
  Set allowed = ""
  If $IsObject(allow) Set allowed = allow.%Get("group_by")
  If '$IsObject(allowed) {
    Do ..WriteError(400, "invalid_request", "group_by no permitido")
    Set sc = $$$ERROR(400)
    Goto Done
  }

  Set i = 0
  For {
    Set i = i + 1
    If i > groupBy.%Size() Quit
    Set key = groupBy.%Get(i)
    If key = "" {
      Do ..WriteError(400, "invalid_request", "group_by vacio")
      Set sc = $$$ERROR(400)
      Quit
    }
    If ' ..Contains(allowed, key) {
      Do ..WriteError(400, "invalid_request", "group_by no permitido")
      Set sc = $$$ERROR(400)
      Quit
    }
  }
  If $$$ISERR(sc) Goto Done
Done
  Quit sc
}

ClassMethod ValidateFilters(filters As %DynamicArray, kpi As %DynamicObject, dims As %DynamicObject) As %Status
{
  Set sc = $$$OK
  If '$IsObject(filters) Goto Done

  Set allow = kpi.%Get("allow")
  Set allowed = ""
  If $IsObject(allow) Set allowed = allow.%Get("filters")
  If '$IsObject(allowed) {
    Do ..WriteError(400, "invalid_request", "filters no permitidos")
    Set sc = $$$ERROR(400)
    Goto Done
  }

  Set dimsMap = dims.%Get("dimensions")

  Set i = 0
  For {
    Set i = i + 1
    If i > filters.%Size() Quit
    Set f = filters.%Get(i)
    If '$IsObject(f) {
      Do ..WriteError(400, "invalid_request", "filter invalido")
      Set sc = $$$ERROR(400)
      Quit
    }
    Set field = $Get(f.%Get("field"), "")
    If field = "" {
      Do ..WriteError(400, "invalid_request", "filter.field requerido")
      Set sc = $$$ERROR(400)
      Quit
    }
    If ' ..Contains(allowed, field) {
      Do ..WriteError(400, "invalid_request", "filter.field no permitido")
      Set sc = $$$ERROR(400)
      Quit
    }
    Set dim = ""
    If $IsObject(dimsMap) Set dim = dimsMap.%Get(field)
    If '$IsObject(dim) {
      Do ..WriteError(400, "invalid_request", "dimension no registrada")
      Set sc = $$$ERROR(400)
      Quit
    }
    Set op = $Get(f.%Get("op"), "")
    If op = "" {
      Do ..WriteError(400, "invalid_request", "filter.op requerido")
      Set sc = $$$ERROR(400)
      Quit
    }
    Set allowedOps = dim.%Get("allowed_ops")
    If '$IsObject(allowedOps) {
      Do ..WriteError(400, "invalid_request", "filter.op no permitido")
      Set sc = $$$ERROR(400)
      Quit
    }
    If ' ..Contains(allowedOps, op) {
      Do ..WriteError(400, "invalid_request", "filter.op no permitido")
      Set sc = $$$ERROR(400)
      Quit
    }
  }
  If $$$ISERR(sc) Goto Done
Done
  Quit sc
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
  Set sc = $$$OK
  Set baseUrl = $Get(^IRIS108.Config("BIBaseUrl"))
  If baseUrl = "" {
    Do ..WriteError(500, "bi_base_url_missing", "Configurar ^IRIS108.Config(""BIBaseUrl"")")
    Set sc = $$$ERROR(500)
    Goto Done
  }

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
  If $$$ISERR(sc) {
    Do ..WriteError(502, "bi_call_failed", $SYSTEM.Status.GetErrorText(sc))
    Set sc = $$$ERROR(502)
    Goto Done
  }

  Set raw = req.HttpResponse.Data.Read()
  Try {
    Set responseObj = ##class(%DynamicObject).%FromJSON(raw)
  } Catch ex {
    Do ..WriteError(502, "bi_invalid_response", "Respuesta BI no es JSON valido")
    Set sc = $$$ERROR(502)
  }
Done
  Quit sc
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
  Set sc = $$$OK
  Set cutoff = ""
  Set stmt = ##class(%SQL.Statement).%New()
  Set sc = stmt.%Prepare("SELECT MAX(CutoffTs) FROM SISS.St.FactInvoice")
  If $$$ISERR(sc) Goto Done
  Set rset = stmt.%Execute()
  If rset.%Next() {
    Set cutoff = rset.%Get(1)
  }
Done
  Quit sc
}

ClassMethod WriteJson(status As %Integer, response As %DynamicObject) As %Status
{
  Set %response.Status = status
  Set %response.ContentType = "application/json"
  Do %response.Write(response.%ToJSON())
  Quit $$$OK
}

ClassMethod WriteError(status As %Integer, code As %String, message As %String) As %Status
{
  Set %response.Status = status
  Set %response.ContentType = "text/plain"
  Write code_": "_message,!
  Quit $$$OK
}

ClassMethod WriteConfigHead(fileName As %String, label As %String) As %Status
{
  Set sc = $$$OK
  Set base = $Piece(fileName, ".", 1)
  Set tJson = $Get(^IRIS108.ConfigData(base, "json"))
  If tJson = "" {
    Write label_": global_not_found",!
    Goto Done
  }

  Write "== "_label_" ==",!
  Do ..WriteHeadFromString(tJson, 10, 200)
  Write "",!
Done
  Quit sc
}

ClassMethod WriteHeadFromString(value As %String, maxLines As %Integer, chunkSize As %Integer) As %Status
{
  Set sc = $$$OK
  Set lineCount = 0
  Set newline = $Char(10)
  If value [ newline {
    For {
      If lineCount >= maxLines Quit
      Set line = $Piece(value, newline, lineCount + 1)
      If line = "" Quit
      Write line,!
      Set lineCount = lineCount + 1
    }
    Quit sc
  }

  Set start = 1
  For {
    If lineCount >= maxLines Quit
    If start > $Length(value) Quit
    Write $Extract(value, start, start + chunkSize - 1),!
    Set start = start + chunkSize
    Set lineCount = lineCount + 1
  }
  Quit sc
}

ClassMethod ExtractJsonValue(json As %String, key As %String, ByRef value As %String) As %Status
{
  Set sc = $$$OK
  Set value = ""
  Set keyToken = """"_key_""""
  Set pos = $Find(json, keyToken)
  If pos = 0 {
    Do ..WriteError(400, "invalid_request", key_" requerido")
    Set sc = $$$ERROR(400)
    Goto Done
  }

  Set pos = $Find(json, ":", pos)
  If pos = 0 {
    Do ..WriteError(400, "invalid_request", key_" requerido")
    Set sc = $$$ERROR(400)
    Goto Done
  }

  Set i = pos
  For {
    Set ch = $Extract(json, i)
    If ch = " "!(ch = $Char(9))!(ch = $Char(10))!(ch = $Char(13)) {
      Set i = i + 1
      Continue
    }
    Quit
  }

  If $Extract(json, i) '= """" {
    Do ..WriteError(400, "invalid_request", key_" requerido")
    Set sc = $$$ERROR(400)
    Goto Done
  }
  Set j = i + 1
  Set escape = 0
  For {
    Set ch = $Extract(json, j)
    If ch = "" Quit
    If escape {
      Set escape = 0
    } Else {
      If ch = "\" Set escape = 1
      If ch = """" Quit
    }
    Set j = j + 1
  }
  If $Extract(json, j) '= """" {
    Do ..WriteError(400, "invalid_request", key_" requerido")
    Set sc = $$$ERROR(400)
    Goto Done
  }
  Set value = $Extract(json, i + 1, j - 1)
Done
  Quit sc
}

ClassMethod ExtractJsonObjectByKey(json As %String, key As %String, ByRef objJson As %String) As %Status
{
  Set sc = $$$OK
  Set objJson = ""
  Set keyToken = """"_key_""""
  Set pos = $Find(json, keyToken)
  If pos = 0 {
    Set sc = $$$ERROR(404)
    Goto Done
  }

  Set pos = $Find(json, "{", pos)
  If pos = 0 {
    Set sc = $$$ERROR(404)
    Goto Done
  }

  Set i = pos - 1
  Set depth = 0
  Set inString = 0
  Set escape = 0
  For {
    Set ch = $Extract(json, i)
    If ch = "" Quit
    If inString {
      If escape {
        Set escape = 0
      } Else {
        If ch = "\" Set escape = 1
        If ch = """" Set inString = 0
      }
    } Else {
      If ch = """" Set inString = 1
      If ch = "{" Set depth = depth + 1
      If ch = "}" {
        Set depth = depth - 1
        If depth = 0 {
          Set objJson = $Extract(json, pos - 1, i)
          Quit
        }
      }
    }
    Set i = i + 1
  }
  If objJson = "" Set sc = $$$ERROR(404)
Done
  Quit sc
}

ClassMethod ExecuteMdxRaw(templateJson As %String, mdx As %String, ByRef raw As %String, ByRef urlUsed As %String) As %Status
{
  Set sc = $$$OK
  Set raw = ""
  Set urlUsed = ""
  Try {
    Set endpoint = ""
    Set sc = ..ExtractJsonValue(templateJson, "bi_rest_endpoint", .endpoint)
    If $$$ISERR(sc) Goto Done
    If endpoint = "" {
      Do ..WriteError(500, "bi_endpoint_missing", "bi_rest_endpoint requerido")
      Set sc = $$$ERROR(500)
      Goto Done
    }

    Set baseUrl = $Get(^IRIS108.Config("BIBaseUrl"))
    If baseUrl = "" {
      Do ..WriteError(500, "bi_base_url_missing", "Configurar ^IRIS108.Config(""BIBaseUrl"")")
      Set sc = $$$ERROR(500)
      Goto Done
    }

    Set req = ##class(%Net.HttpRequest).%New()
    Set sc = ..ParseBaseUrl(baseUrl, .host, .port, .isHttps, .basePath)
    If $$$ISERR(sc) Goto Done
    Set req.Server = host
    Set req.Port = port
    Set req.Https = isHttps
    Set path = ..JoinPath(basePath, endpoint)
    Set ns = $Get(^IRIS108.Config("BINamespace"), "")
    If ns'="" {
      Set path = ..AppendQuery(path, "Namespace", ns)
      Set path = ..AppendQuery(path, "namespace", ns)
      Set path = ..AppendQuery(path, "NS", ns)
      Set path = ..AppendQuery(path, "$NAMESPACE", ns)
    }
    Set urlUsed = ..BuildUrl(isHttps, host, port, path)
    Set req.Location = path
    Do req.SetHeader("Content-Type", "application/json")
    If ns'="" Do req.SetHeader("Namespace", ns)
    If ns'="" Do req.SetHeader("X-IRIS-Namespace", ns)

    Set payload = "{""MDX"":"""_..JsonEscape(mdx)_"""}"
    Set sc = req.Post(path, payload)
    If $$$ISERR(sc) {
      Do ..WriteError(502, "bi_call_failed", $SYSTEM.Status.GetErrorText(sc))
      Set sc = $$$ERROR(502)
      Goto Done
    }

    If '$IsObject(req.HttpResponse) {
      Do ..WriteError(502, "bi_call_failed", "respuesta vacia")
      Set sc = $$$ERROR(502)
      Goto Done
    }

    Set raw = ""
    Set data = req.HttpResponse.Data
    If $IsObject(data) {
      Set raw = data.Read(4000)
      If 'data.AtEnd Set raw = raw_$Char(10)_"...truncated..."
    }
  } Catch ex {
    Do ..WriteError(500, "bi_exception", ex.DisplayString())
    Set sc = $$$ERROR(500)
  }
Done
  Quit sc
}

ClassMethod JsonEscape(value As %String) As %String
{
  Set clean = $Get(value)
  Set clean = $Replace(clean, "\", "\\")
  Set clean = $Replace(clean, """", "\""")
  Set clean = $Replace(clean, $Char(13,10), "\n")
  Set clean = $Replace(clean, $Char(13), "\n")
  Set clean = $Replace(clean, $Char(10), "\n")
  Quit clean
}

ClassMethod ParseBaseUrl(url As %String, ByRef host As %String, ByRef port As %Integer, ByRef isHttps As %Boolean, ByRef path As %String) As %Status
{
  Set sc = $$$OK
  Set host = ""
  Set port = 0
  Set isHttps = 0
  Set path = ""

  Set scheme = $Piece(url, "://", 1)
  Set rest = $Piece(url, "://", 2, 999)
  If rest = "" {
    Do ..WriteError(500, "invalid_base_url", "BIBaseUrl invalido")
    Set sc = $$$ERROR(500)
    Goto Done
  }

  Set isHttps = (scheme = "https")
  Set hostPort = $Piece(rest, "/", 1)
  Set path = "/"_$Piece(rest, "/", 2, 999)
  If path = "/" Set path = ""

  Set host = hostPort
  If hostPort [ ":" {
    Set host = $Piece(hostPort, ":", 1)
    Set port = +$Piece(hostPort, ":", 2)
  } Else {
    Set port = $Select(isHttps:443, 1:80)
  }

  If host = "" {
    Do ..WriteError(500, "invalid_base_url", "BIBaseUrl sin host")
    Set sc = $$$ERROR(500)
  }
Done
  Quit sc
}

ClassMethod JoinPath(basePath As %String, endpoint As %String) As %String
{
  Set b = $Get(basePath)
  Set e = $Get(endpoint)
  If b = "" Quit e
  If e = "" Quit b
  If $Extract(b, $Length(b)) = "/" {
    If $Extract(e, 1) = "/" Quit $Extract(b, 1, $Length(b) - 1)_e
    Quit b_e
  }
  If $Extract(e, 1) = "/" Quit b_e
  Quit b_"/"_e
}

ClassMethod AppendQuery(path As %String, key As %String, value As %String) As %String
{
  If value = "" Quit path
  If path [ "?" Quit path_"&"_key_"="_value
  Quit path_"?"_key_"="_value
}

ClassMethod BuildUrl(isHttps As %Boolean, host As %String, port As %Integer, path As %String) As %String
{
  Set scheme = $Select(isHttps:"https", 1:"http")
  Set url = scheme_"://"_host
  If (isHttps & (port'=443))!(('isHttps) & (port'=80)) Set url = url_":"_port
  Quit url_path
}

ClassMethod GetHeaderValue(headerName As %String) As %String
{
  Set envName = "HTTP_"_$Translate($ZConvert(headerName, "U"), "-", "_")
  Set value = $Get(%request.CgiEnvs(envName))
  If value = "" Set value = $Get(%request.CgiEnvs(headerName))
  Quit value
}

}
