Class IRIS108.REST.holadisp Extends %CSP.REST
{

Parameter HandleCorsRequest = 0;

XData UrlMap [ XMLNamespace = "https://www.intersystems.com/urlmap" ]
{
<Routes>
            <Route Url="/hello" Method="GET" Call="Hello" />
            <Route Url="/hello" Method="POST" Call="PostHello" />
        </Routes>
}

ClassMethod Hello() As %Status
{
        Try {
            Do ##class(%REST.Impl).%SetContentType("application/json")
            If '##class(%REST.Impl).%CheckAccepts("application/json") {
                Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE, $$$ERROR($$$RESTBadAccepts))
                Quit
            }
            Set response = ##class(IRIS108.REST.holaimpl).Hello()
            Do ##class(%REST.Impl).%WriteResponse(response)
        } Catch (ex) {
            Do ##class(%REST.Impl).%SetStatusCode("400")
            Return {"errormessage": "Client error"}
        }
        Quit $$$OK
}

ClassMethod PostHello() As %Status
{
        Try {
            Do ##class(%REST.Impl).%SetContentType("application/json")
            If '##class(%REST.Impl).%CheckAccepts("application/json") {
                Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE, $$$ERROR($$$RESTBadAccepts))
                Quit
            }
            Set response = ##class(IRIS108.REST.holaimpl).PostHello(%request.Data)
            Do ##class(%REST.Impl).%WriteResponse(response)
        } Catch (ex) {
            Do ##class(%REST.Impl).%SetStatusCode("400")
            Return {"errormessage": "Client error"}
        }
        Quit $$$OK
}

}
