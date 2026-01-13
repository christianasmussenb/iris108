Class SISS.BI.CubeUtil
{

ClassMethod Build(pCubeName As %String) As %Status
{
    if pCubeName="" {
        return $SYSTEM.Status.Error(5001, "Nombre de cubo requerido")
    }
    set sc = $SYSTEM.Status.OK()
    try {
        do ##class(SISS.Etl.Log).Info("Cube build start="_pCubeName)
        if ##class(%Dictionary.ClassDefinition).%ExistsId("%DeepSee.CubeManager.Utils") {
            set sc = $classmethod("%DeepSee.CubeManager.Utils", "BuildCube", pCubeName)
        } else {
            set sc = $SYSTEM.Status.Error(5001, "No se encontro utilitario para construir cubos")
        }
    } catch ex {
        set sc = $SYSTEM.Status.Error(5001, "Error construyendo cubo: "_ex.DisplayString())
    }
    if $SYSTEM.Status.IsError(sc) {
        do ##class(SISS.Etl.Log).Error("Cube build error="_$SYSTEM.Status.GetErrorText(sc))
    } else {
        do ##class(SISS.Etl.Log).Info("Cube build end="_pCubeName_" status=OK")
    }
    return sc
}

ClassMethod BuildFacturacionCartera() As %Status
{
    return ..Build("FactInvoice")
}

}
