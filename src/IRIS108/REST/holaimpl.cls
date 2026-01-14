Class IRIS108.REST.holaimpl Extends %CSP.REST
{

ClassMethod Hello() As %DynamicObject
{
        Try {
           Return {"Hello": "World"}.%ToJSON()
        } Catch (ex) {
            Do ##class(%REST.Impl).%SetStatusCode("500")
            Return {"errormessage": "Server error"}
       }
}

ClassMethod PostHello(body As %DynamicObject) As %DynamicObject
{
        Try {
            Set temp = ##class(IRIS108.REST.hwobj).%New()
            Return {"Received": body}
        } Catch (ex) {
            Do ##class(%REST.Impl).%SetStatusCode("500")
            Return {"errormessage": "Server error"}
        }
}

}
