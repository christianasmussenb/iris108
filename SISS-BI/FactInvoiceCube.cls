/// SISS.BI.FactInvoiceCube
Class SISS.BI.FactInvoiceCube Extends %DeepSee.CubeDefinition [ DependsOn = SISS.St.FactInvoice, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="SISS" displayName="SISS.BI.SISS_FactInvoice" description="SISS.BI.FactInvoiceCube" disabled="false" abstract="false" sourceClass="SISS.St.FactInvoice" namedFactNums="true" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="FechaFactura" disabled="false" hasAll="false" allCaption="All FechaFactura" allDisplayName="FechaFactura" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="FKDAT" disabled="false" sourceProperty="FKDAT" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="2">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Pagador" disabled="false" hasAll="false" allCaption="All Pagador" allDisplayName="Pagador" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="KUNGR" disabled="false" sourceProperty="KUNRG" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="3">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Centro" disabled="false" hasAll="false" allCaption="All Centro" allDisplayName="Centro" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="ISHKOSTR" disabled="false" sourceProperty="ISHKOSTR" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="4">
      </level>
    </hierarchy>
  </dimension>
  <measure name="TotalFacturado" disabled="false" sourceProperty="NETWR" aggregate="SUM" type="number" hidden="false" searchable="false" factNumber="1">
  </measure>
  <measure name="TotalRadicado" disabled="false" sourceProperty="VALORRD" aggregate="SUM" type="number" hidden="false" searchable="false" factNumber="2">
  </measure>
  <measure name="TotalImpuesto" disabled="false" sourceProperty="MWSBK" aggregate="SUM" type="number" hidden="false" searchable="false" factNumber="3">
  </measure>
  <measure name="TotalCopago" disabled="false" sourceProperty="ZUZAHLBETR" aggregate="SUM" type="number" hidden="false" searchable="false" factNumber="4">
  </measure>
  <measure name="TotalR60" disabled="false" sourceProperty="R60NETWR" aggregate="SUM" type="number" hidden="false" searchable="false" factNumber="5">
  </measure>
  <measure name="TotalCartera" disabled="false" sourceProperty="R82TOTALFACT" aggregate="SUM" type="number" hidden="false" searchable="false" factNumber="6">
  </measure>
</cube>
}

Parameter DOMAIN;

}
