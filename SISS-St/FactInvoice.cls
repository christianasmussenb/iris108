Class SISS.St.FactInvoice Extends %Persistent
{

Property VBELN As %String(MAXLEN = 32) [ Required ];

Property FKDAT As %String(MAXLEN = 16);

Property ERDAT As %String(MAXLEN = 16);

Property FKART As %String(MAXLEN = 16);

Property KUNRG As %String(MAXLEN = 32);

Property ISHKOSTR As %String(MAXLEN = 32);

Property ISHKTART As %String(MAXLEN = 32);

Property NETWR As %String(MAXLEN = 32);

Property MWSBK As %String(MAXLEN = 32);

Property ZUZAHLBETR As %String(MAXLEN = 32);

Property VALORRD As %String(MAXLEN = 32);

Property VALNOTCRE As %String(MAXLEN = 32);

Property R60NETWR As %String(MAXLEN = 32) [ SqlFieldName = R60_NETWR ];

Property R60COUNT As %Integer [ SqlFieldName = R60_COUNT ];

Property R82NETWR As %String(MAXLEN = 32) [ SqlFieldName = R82_NETWR ];

Property R82TOTALFACT As %String(MAXLEN = 32) [ SqlFieldName = R82_TOTALFACT ];

Property R82NAMEK As %String(MAXLEN = 128) [ SqlFieldName = R82_NAMEK ];

Property R82MWSBK As %String(MAXLEN = 32) [ SqlFieldName = R82_MWSBK ];

Property GlosaEventCount As %Integer [ SqlFieldName = GLOSA_EVENT_COUNT ];

Property GlosaKostrCount As %Integer [ SqlFieldName = GLOSA_KOSTR_COUNT ];

Property GlosaLastEvento As %String(MAXLEN = 32) [ SqlFieldName = GLOSA_LAST_EVENTO ];

Property CutoffTs As %TimeStamp;

Index IDXFactVBELN On VBELN [ Unique ];

Index IDXFactFKDAT On FKDAT;

Index IDXFactKUNRG On KUNRG;

Storage Default
{
<Data name="FactInvoiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VBELN</Value>
</Value>
<Value name="3">
<Value>FKDAT</Value>
</Value>
<Value name="4">
<Value>ERDAT</Value>
</Value>
<Value name="5">
<Value>FKART</Value>
</Value>
<Value name="6">
<Value>KUNRG</Value>
</Value>
<Value name="7">
<Value>ISHKOSTR</Value>
</Value>
<Value name="8">
<Value>ISHKTART</Value>
</Value>
<Value name="9">
<Value>NETWR</Value>
</Value>
<Value name="10">
<Value>MWSBK</Value>
</Value>
<Value name="11">
<Value>ZUZAHLBETR</Value>
</Value>
<Value name="12">
<Value>VALORRD</Value>
</Value>
<Value name="13">
<Value>VALNOTCRE</Value>
</Value>
<Value name="14">
<Value>R60NETWR</Value>
</Value>
<Value name="15">
<Value>R60COUNT</Value>
</Value>
<Value name="16">
<Value>R82NETWR</Value>
</Value>
<Value name="17">
<Value>R82TOTALFACT</Value>
</Value>
<Value name="18">
<Value>R82NAMEK</Value>
</Value>
<Value name="19">
<Value>R82MWSBK</Value>
</Value>
<Value name="20">
<Value>GlosaEventCount</Value>
</Value>
<Value name="21">
<Value>GlosaKostrCount</Value>
</Value>
<Value name="22">
<Value>GlosaLastEvento</Value>
</Value>
<Value name="23">
<Value>CutoffTs</Value>
</Value>
</Data>
<DataLocation>^SISS.St.FactInvoiceD</DataLocation>
<DefaultData>FactInvoiceDefaultData</DefaultData>
<ExtentSize>86</ExtentSize>
<IdLocation>^SISS.St.FactInvoiceD</IdLocation>
<IndexLocation>^SISS.St.FactInvoiceI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,16,$lb("-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000"),$lb(21,21,21,21,21,21,21,21,21,21,21,21,21,21,21),$lb(758198320,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,758198320))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>4</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(1463,1468,1474,1480,1486,1492,1498,1504,1510,1516,1522,1528,1533,1538,1543,1548),$lb(3,2,2,3,2,3,1,2,3,2,3,2,3,2,3),$lb(825505331,855638016,939524096,909639680,926154752,926154752,942669824,805306368,905969664,943063040,959578112,838860800,939524096,876165120,892351488,808714240,825229312,805306368,905969664,825622528,842137600,838860800,939524096,842530816,858980352,855638016,939524096,859308032,875757568,855638016,939524096,825570360))</Histogram>
<Selectivity>1</Selectivity>
</Property>
<Property name="CutoffTs">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,16,$lb("-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000"),$lb(21,21,21,21,21,21,21,21,21,21,21,21,21,21,21),$lb(758198320,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,758198320))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="ERDAT">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "),$lb(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,536870912))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="FKART">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "),$lb(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,536870912))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="FKDAT">
<AverageFieldSize>10</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" 20160331"," 20160415"," 20160601"," 20160603"," 20160607"," 20160613"," 20160613"," 20160615"," 20160622"," 20160627"," 20160711"," 20160726"," 20160912"," 20161115"," 20161129"," 20161206"),$lb(6,6,8,8,7,10,8,7,8,6,7,6,5,7,6),$lb(540160049,858992896,875640064,875640064,909127936,822083584,855638016,855638016,922746880,808910848,825425920,0,0,855638016,889192448,825556992,842137600,838860800,922746880,909260544,925970688,825294848,842399744,926037504,959525376,809054514,825307445,825556992,842596352,825374976,842020352,540160049))</Histogram>
<Selectivity>3.0303%</Selectivity>
</Property>
<Property name="GlosaEventCount">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,16,$lb(-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000),$lb(21,21,21,21,21,21,21,21,21,21,21,21,21,21,21),$lb(758198320,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,758198320))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="GlosaKostrCount">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,16,$lb(-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000),$lb(21,21,21,21,21,21,21,21,21,21,21,21,21,21,21),$lb(758198320,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,758198320))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="GlosaLastEvento">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "),$lb(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,536870912))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="ISHKOSTR">
<AverageFieldSize>12</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" 0010000002"," 0010000002"," 0010000003"," 0010000003"," 0010000003"," 0010000003"," 0010000003"," 0010000003"," 0010000003"," 0010000003"," 0010000003"," 0010000003"," 0010000003"," 0010000004"," 0010000004"," 0010000006"),$lb(12,10,12,12,12,12,12,12,12,12,12,12,10,12,10),$lb(540028977,0,0,838860800,855638016,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,855638016,872415232,0,0,872415232,905969664,540028977))</Histogram>
<OutlierSelectivity>.767442:"0010000003"</OutlierSelectivity>
<Selectivity>7.7519%</Selectivity>
</Property>
<Property name="ISHKTART">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "),$lb(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,536870912))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="KUNRG">
<AverageFieldSize>12</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" 0000000002"," 0000000002"," 0000000002"," 0000000002"," 0000000002"," 0000000002"," 0000000002"," 0000000002"," 0000000002"," 0000000002"," 0000000002"," 0000000002"," 0000000004"," 0000000005"," 0000000007"," 0000000007"),$lb(12,12,12,12,12,12,12,12,12,12,12,10,10,10,12),$lb(540028976,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,838860800,872415232,872415232,889192448,889192448,922746880,0,0,540028976))</Histogram>
<OutlierSelectivity>.767442:"0000000002"</OutlierSelectivity>
<Selectivity>7.7519%</Selectivity>
</Property>
<Property name="MWSBK">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "),$lb(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,536870912))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="NETWR">
<AverageFieldSize>8.35</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" 10052.35"," 110.15"," 1112.00"," 1195.25"," 125.10"," 125.10"," 14.65"," 169.00"," 19.80"," 271.00"," 296.00"," 404.15"," 515.40"," 800.75"," 87.55"," 9703.25"),$lb(2,3,3,2,8,2,2,2,1,2,1,1,1,2,1),$lb(540094512,808465714,825241137,808333621,825372208,825372208,959786546,825832750,842346033,0,0,842346033,875443765,875443765,909717040,909717040,959330352,825830968,842477870,925969968,959852080,842610222,875574318,875574318,892417326,892417326,942682158,808463927,925775157,943140405,959918131,540620592))</Histogram>
<Selectivity>2.2727%</Selectivity>
</Property>
<Property name="R60COUNT">
<AverageFieldSize>2.95</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,1,$lb(-10000000000000000000,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1),$lb(0,1,1,1,1,1,1,1,1,1,1,1,1,1,1),$lb(758198320,758198320,822083584,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,822083584))</Histogram>
<OutlierSelectivity>.953488:1</OutlierSelectivity>
<Selectivity>4.6512%</Selectivity>
</Property>
<Property name="R60NETWR">
<AverageFieldSize>5.23</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," 10052.35"," 110.15"," 1112"," 12380.6"," 125.1"," 1259.65"," 144.05"," 169"," 204"," 271"," 3860.35"," 515.4"," 800.75"," 87.55"," 9703.25"),$lb(1,2,3,2,3,4,2,2,1,2,1,1,1,2,1),$lb(536870912,0,825241653,808465714,825241137,808333621,825360384,825307648,842217520,859320366,892219648,774963200,959329845,842348846,875834928,875834928,909705216,825637120,842019840,808714240,925958144,842477824,859321904,859321904,892417326,892417326,942682158,808463927,925775157,943140405,959918131,540620592))</Histogram>
<Selectivity>2.2727%</Selectivity>
</Property>
<Property name="R82MWSBK">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "),$lb(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,536870912))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="R82NAMEK">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "),$lb(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,536870912))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="R82NETWR">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "),$lb(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,536870912))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="R82TOTALFACT">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "),$lb(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,536870912))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="VALNOTCRE">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "),$lb(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,536870912))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="VALORRD">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "),$lb(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,536870912))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="VBELN">
<AverageFieldSize>12</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="ZUZAHLBETR">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "),$lb(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,536870912))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-8</BlockCount>
</SQLMap>
<SQLMap name="IDXFactFKDAT">
<BlockCount>-4</BlockCount>
</SQLMap>
<SQLMap name="IDXFactKUNRG">
<BlockCount>-4</BlockCount>
</SQLMap>
<SQLMap name="IDXFactVBELN">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^SISS.St.FactInvoiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
