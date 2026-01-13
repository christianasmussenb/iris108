# SISS domain map (MLTEST)

## Cubes

### FactInvoice (SISS.BI.CuboFacturacionCartera)
- Source class: SISS.St.FactInvoice
- Dimensions:
  - FechaFactura.FKDAT (fecha de factura)
  - Pagador.KUNRG (pagador)
  - Centro.ISHKOSTR (centro)
- Measures:
  - Fact Count
  - Total Facturado
  - Total Radicado
  - Total Impuesto
  - Total Copago
  - Total R60
  - Total Cartera
  - Glosa Eventos
  - Glosa Kostr

## Tables (staging / base)

### SISS.St.FactInvoice
- Factura cabecera con campos de importes y llaves (VBELN, FKDAT, KUNRG, ISHKOSTR)
- Totales: NETWR, VALORRD, MWSBK, ZUZAHLBETR, R60NETWR, R82TOTALFACT
- Glosas: GlosaEventCount, GlosaKostrCount, GlosaLastEvento
- Cutoff: CutoffTs

### SISS.St.R58
- Facturas (detalle de factura) con importes y fechas (FKDAT, ERDAT)

### SISS.St.R60
- Detalle por posicion de factura (VBELN, POSNR) con importes (NETWR)

### SISS.St.R615
- Eventos de glosa por factura (VBELN, EVENTO, KOSTR)

### SISS.St.R82
- Cartera y datos de pagador (KUNNR, NAMEK, TOTALFACT)

### SISS.St.GlosasAggByInvoice
- Agregado de glosas por factura (GlosaEventCount, KostrDistinctCount, LastEvento)

## Query shape (what can be asked)

- Medidas de facturacion/cartera por fecha (day)
- Totales por pagador y/o centro
- Conteo de facturas
- Conteo de eventos de glosa y glosa por Kostr

## Response shape (expected)

- Siempre incluir correlation_id y metadata (as_of_cutoff, executed_at, execution_ms)
- Para consultas KPI: tabla de filas con columnas = group_by + fecha + value
- Para consultas sin group_by: total unico con fecha o total global
