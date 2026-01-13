Class SISS.St.GlosasAggByInvoice Extends %Persistent
{

Property VBELN As %String(MAXLEN = 32) [ Required ];

Property GlosaEventCount As %Integer [ SqlFieldName = GLOSA_EVENT_COUNT ];

Property KostrDistinctCount As %Integer [ SqlFieldName = KOSTR_DISTINCT_COUNT ];

Property LastEvento As %String(MAXLEN = 32) [ SqlFieldName = LAST_EVENTO ];

Index IDXGlosaVBELN On VBELN [ Unique ];

Storage Default
{
<Data name="GlosasAggDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VBELN</Value>
</Value>
<Value name="3">
<Value>GlosaEventCount</Value>
</Value>
<Value name="4">
<Value>KostrDistinctCount</Value>
</Value>
<Value name="5">
<Value>LastEvento</Value>
</Value>
</Data>
<DataLocation>^SISS.St.GlosasAggD</DataLocation>
<DefaultData>GlosasAggDefaultData</DefaultData>
<ExtentSize>396</ExtentSize>
<IdLocation>^SISS.St.GlosasAggD</IdLocation>
<IndexLocation>^SISS.St.GlosasAggI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,16,$lb("-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000"),$lb(21,21,21,21,21,21,21,21,21,21,21,21,21,21,21),$lb(758198320,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,758198320))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3.36</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(1,27,54,81,108,135,162,188,214,240,266,292,318,344,370,396),$lb(0,0,0,0,1,1,1,0,1,1,1,0,1,1,1),$lb(822083584,822083584,842465280,842465280,892600320,892600320,942735360,942735360,825243648,808976384,859111424,859111424,909246464,909246464,943194112,825767936,842085376,825491456,875560960,875560960,909508608,909508608,959578112,842609152,858863616,825753600,875823104,875823104,925892608,925892608,959840256,859387392))</Histogram>
<Selectivity>1</Selectivity>
</Property>
<Property name="GlosaEventCount">
<AverageFieldSize>3</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(1,2,3,3,3,3,4,4,4,4,4,4,5,6,8,27),$lb(0,0,1,1,1,0,1,1,1,1,1,0,0,0,0),$lb(822083584,822083584,838860800,838860800,855638016,0,0,0,0,0,0,855638016,872415232,0,0,0,0,0,0,0,0,0,0,872415232,889192448,889192448,905969664,905969664,939524096,939524096,842465280,842465280))</Histogram>
<OutlierSelectivity>.386364:4</OutlierSelectivity>
<Selectivity>3.4091%</Selectivity>
</Property>
<Property name="KostrDistinctCount">
<AverageFieldSize>3</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1),$lb(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1),$lb(822083584,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,822083584))</Histogram>
<OutlierSelectivity>.999999:1</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="LastEvento">
<AverageFieldSize>4</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" GA"," GI"," GI"," RO"," RO"," RO"," RO"," RO"," RO"," RO"," RO"," RO"," RO"," RO"," RO"," RR"),$lb(2,4,1,4,4,4,4,4,4,4,4,4,4,4,2),$lb(541540608,1090519040,1224736768,0,0,1195966464,1380909056,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1325400064,1375731712,542265856))</Histogram>
<OutlierSelectivity>.815657:"RO"</OutlierSelectivity>
<Selectivity>3.0724%</Selectivity>
</Property>
<Property name="VBELN">
<AverageFieldSize>12</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-8</BlockCount>
</SQLMap>
<SQLMap name="IDXGlosaVBELN">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^SISS.St.GlosasAggS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
