Class IRIS108.REST.Service Extends %CSP.REST
{

XData UrlMap
{
<Routes>
  <Route Url="/capabilities" Method="GET" Call="GetCapabilities" />
  <Route Url="/kpi/explain" Method="POST" Call="ExplainKpi" />
  <Route Url="/kpi/query" Method="POST" Call="QueryKpi" />
  <Route Url="/cube/query" Method="POST" Call="QueryCube" />
  <Route Url="/dq/status" Method="POST" Call="DqStatus" />
</Routes>
}

ClassMethod GetCapabilities() As %Status
{
  Quit ..NotImplemented("capabilities")
}

ClassMethod ExplainKpi() As %Status
{
  Quit ..NotImplemented("kpi/explain")
}

ClassMethod QueryKpi() As %Status
{
  Quit ..NotImplemented("kpi/query")
}

ClassMethod QueryCube() As %Status
{
  Quit ..NotImplemented("cube/query")
}

ClassMethod DqStatus() As %Status
{
  Quit ..NotImplemented("dq/status")
}

ClassMethod NotImplemented(endpoint As %String) As %Status
{
  Set response = ##class(%DynamicObject).%New()
  Set response.error = "not_implemented"
  Set response.endpoint = endpoint
  Do %response.SetStatus(501)
  Do %response.SetHeader("Content-Type", "application/json")
  Do %response.Write(response.%ToJSON())
  Quit $$$OK
}

}
