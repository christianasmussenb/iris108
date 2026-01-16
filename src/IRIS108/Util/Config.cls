Include %occStatus

Class IRIS108.Util.Config
{

ClassMethod Load(fileName As %String, ByRef config As %DynamicObject) As %Status
{
  Set path = ..ConfigPath(fileName)
  If path = "" Quit $SYSTEM.Status.Error(5001, "Ruta de config no definida")
  Set sc = $$$OK

  If ##class(%Dictionary.ClassDefinition).%ExistsId("%SYS.YAML") {
    Try {
      Set config = $classmethod("%SYS.YAML", "ParseFile", path)
    } Catch ex {
      Try {
        Set config = $classmethod("%SYS.YAML", "LoadFile", path)
      } Catch ex2 {
        Set sc = $SYSTEM.Status.Error(5001, "No se pudo parsear YAML: "_ex2.DisplayString())
      }
    }
  } Else {
    Set sc = ..LoadJsonFallback(path, fileName, .config)
  }

  Quit sc
}

ClassMethod LoadJsonFallback(path As %String, fileName As %String, ByRef config As %DynamicObject) As %Status
{
  Set jsonPath = path
  If $Extract(path, $Length(path) - 4, $Length(path)) = ".yaml" {
    Set jsonPath = $Extract(path, 1, $Length(path) - 5)_".json"
  }

  Set stream = ##class(%Stream.FileCharacter).%New()
  Set stream.Filename = jsonPath
  If '##class(%File).Exists(jsonPath) {
    Quit ..LoadFromGlobals(fileName, .config)
  }

  Set tJson = ""
  While 'stream.AtEnd {
    Set tJson = tJson _ stream.Read()
  }
  Do stream.Close()

  Set sc = $$$OK
  Try {
    Set config = ##class(%DynamicObject).%FromJSON(tJson)
  } Catch ex {
    Set sc = $SYSTEM.Status.Error(5001, "JSON invalido: "_ex.DisplayString())
  }
  Quit sc
}

ClassMethod LoadFromGlobals(fileName As %String, ByRef config As %DynamicObject) As %Status
{
  Set base = $Piece(fileName, ".", 1)
  Set tJson = $Get(^IRIS108.ConfigData(base, "json"))
  If tJson = "" Quit $SYSTEM.Status.Error(5001, "Config en globals no encontrada: "_base)

  Set sc = $$$OK
  Try {
    Set config = ##class(%DynamicObject).%FromJSON(tJson)
  } Catch ex {
    Set sc = $SYSTEM.Status.Error(5001, "JSON invalido en globals: "_ex.DisplayString())
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

/// Carga un archivo de config (YAML/JSON) y lo escribe en globals como JSON.
/// Facilita alinear los globals `^IRIS108.ConfigData` con los archivos del repo.
ClassMethod SyncFileToGlobals(fileName As %String) As %Status
{
  Set sc = $$$OK
  Set config = ""
  Set sc = ..Load(fileName, .config)
  If $$$ISERR(sc) Quit sc

  If '$IsObject(config) Quit $SYSTEM.Status.Error(5001, "Config vacia para "_fileName)
  Try {
    Set base = $Piece(fileName, ".", 1)
    Set ^IRIS108.ConfigData(base, "json") = config.%ToJSON()
  } Catch ex {
    Set sc = $SYSTEM.Status.Error(5001, "No se pudo serializar "_fileName_": "_ex.DisplayString())
  }
  Quit sc
}

/// Sincroniza todos los archivos soportados (agent_limits, dimensions, kpi_registry, cube_templates) a globals.
ClassMethod SyncAllToGlobals() As %Status
{
  Set files = ##class(%ListOfDataTypes).%New()
  Do files.Insert("agent_limits.yaml")
  Do files.Insert("dimensions.yaml")
  Do files.Insert("kpi_registry.yaml")
  Do files.Insert("cube_templates.yaml")

  Set sc = $$$OK
  Set i = files.Next("")
  For {
    If i = "" Quit
    Set file = files.GetAt(i)
    Set sc = ..SyncFileToGlobals(file)
    If $$$ISERR(sc) Quit
    Set i = files.Next(i)
  }
  Quit sc
}

}
