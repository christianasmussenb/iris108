Class SISS.BI.CuboFacturacionCartera Extends %DeepSee.CubeDefinition
{

XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube
name="FactInvoice"
displayName="FactInvoice"
owner="_SYSTEM"
caption="Facturacion y Cartera"
sourceClass="SISS.St.FactInvoice"
>

<measure name="Fact Count" displayName="Fact Count"
sourceExpression="1"
aggregate="SUM" />

<measure name="Total Facturado" displayName="Total Facturado"
sourceExpression="+%source.NETWR"
aggregate="SUM" />

<measure name="Total Radicado" displayName="Total Radicado"
sourceExpression="+%source.VALORRD"
aggregate="SUM" />

<measure name="Total Impuesto" displayName="Total Impuesto"
sourceExpression="+%source.MWSBK"
aggregate="SUM" />

<measure name="Total Copago" displayName="Total Copago"
sourceExpression="+%source.ZUZAHLBETR"
aggregate="SUM" />

<measure name="Total R60" displayName="Total R60"
sourceExpression="+%source.R60NETWR"
aggregate="SUM" />

<measure name="Total Cartera" displayName="Total Cartera"
sourceExpression="+%source.R82TOTALFACT"
aggregate="SUM" />

<measure name="Glosa Eventos" displayName="Glosa Eventos"
sourceProperty="GlosaEventCount"
aggregate="SUM" />

<measure name="Glosa Kostr" displayName="Glosa Kostr"
sourceProperty="GlosaKostrCount"
aggregate="SUM" />

<dimension name="FechaFactura" displayName="FechaFactura"
allCaption="Todas las fechas" allDisplayName="Todas las fechas">
<hierarchy name="H1">
<level name="FKDAT" displayName="FKDAT"
sourceProperty="FKDAT" />
</hierarchy>
</dimension>

<dimension name="Pagador" displayName="Pagador"
allCaption="Todos los pagadores" allDisplayName="Todos los pagadores">
<hierarchy name="H1">
<level name="KUNRG" displayName="KUNRG"
sourceProperty="KUNRG" />
</hierarchy>
</dimension>

<dimension name="Centro" displayName="Centro"
allCaption="Todos los centros" allDisplayName="Todos los centros">
<hierarchy name="H1">
<level name="ISHKOSTR" displayName="ISHKOSTR"
sourceProperty="ISHKOSTR" />
</hierarchy>
</dimension>

</cube>
}

}
