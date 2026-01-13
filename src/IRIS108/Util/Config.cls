Include %occStatus

Class IRIS108.Util.Config
{

ClassMethod Load(fileName As %String, ByRef config As %DynamicObject) As %Status
{
  Set path = ..ConfigPath(fileName)
  If path = "" Quit $SYSTEM.Status.Error(5001, "Ruta de config no definida")
  Set sc = $$$OK

  If '##class(%Dictionary.ClassDefinition).%ExistsId("%SYS.YAML") {
    Quit $SYSTEM.Status.Error(5001, "%SYS.YAML no disponible en este IRIS")
  }
  Try {
    Set config = $classmethod("%SYS.YAML", "ParseFile", path)
  } Catch ex {
    Try {
      Set config = $classmethod("%SYS.YAML", "LoadFile", path)
    } Catch ex2 {
      Set sc = $SYSTEM.Status.Error(5001, "No se pudo parsear YAML: "_ex2.DisplayString())
    }
  }

  Quit sc
}

ClassMethod ConfigPath(fileName As %String) As %String
{
  Set root = $Get(^IRIS108.Config("ConfigRoot"), "config")
  If $Extract(root, $Length(root)) = "/" {
    Quit root_fileName
  }
  Quit root_"/"_fileName
}

}
