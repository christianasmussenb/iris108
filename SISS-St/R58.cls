Class SISS.St.R58 Extends %Persistent
{

Property RunId As %String(MAXLEN = 64);

Property ExtractedAt As %TimeStamp;

Property CutoffTs As %TimeStamp;

Property VBELN As %String(MAXLEN = 32);

Property BELNR As %String(MAXLEN = 32);

Property FKDAT As %String(MAXLEN = 16);

Property ERDAT As %String(MAXLEN = 16);

Property FKART As %String(MAXLEN = 16);

Property PATNR As %String(MAXLEN = 32);

Property KUNRG As %String(MAXLEN = 32);

Property ISHKOSTR As %String(MAXLEN = 32);

Property ISHKTART As %String(MAXLEN = 32);

Property ESTRAD As %String(MAXLEN = 16);

Property NUMRA As %String(MAXLEN = 32);

Property FEEST As %String(MAXLEN = 16);

Property FEREG As %String(MAXLEN = 16);

Property NETWR As %String(MAXLEN = 32);

Property WAERS As %String(MAXLEN = 8);

Property MWSBK As %String(MAXLEN = 32);

Property ZUZAHLBETR As %String(MAXLEN = 32);

Property VALORRD As %String(MAXLEN = 32);

Property VALNOTCRE As %String(MAXLEN = 32);

Index IDXR58VBELN On VBELN;

Index IDXR58FKDAT On FKDAT;

Index IDXR58KUNRG On KUNRG;

Storage Default
{
<Data name="R58DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RunId</Value>
</Value>
<Value name="3">
<Value>ExtractedAt</Value>
</Value>
<Value name="4">
<Value>CutoffTs</Value>
</Value>
<Value name="5">
<Value>VBELN</Value>
</Value>
<Value name="6">
<Value>BELNR</Value>
</Value>
<Value name="7">
<Value>FKDAT</Value>
</Value>
<Value name="8">
<Value>ERDAT</Value>
</Value>
<Value name="9">
<Value>FKART</Value>
</Value>
<Value name="10">
<Value>PATNR</Value>
</Value>
<Value name="11">
<Value>KUNRG</Value>
</Value>
<Value name="12">
<Value>ISHKOSTR</Value>
</Value>
<Value name="13">
<Value>ISHKTART</Value>
</Value>
<Value name="14">
<Value>ESTRAD</Value>
</Value>
<Value name="15">
<Value>NUMRA</Value>
</Value>
<Value name="16">
<Value>FEEST</Value>
</Value>
<Value name="17">
<Value>FEREG</Value>
</Value>
<Value name="18">
<Value>NETWR</Value>
</Value>
<Value name="19">
<Value>WAERS</Value>
</Value>
<Value name="20">
<Value>MWSBK</Value>
</Value>
<Value name="21">
<Value>ZUZAHLBETR</Value>
</Value>
<Value name="22">
<Value>VALORRD</Value>
</Value>
<Value name="23">
<Value>VALNOTCRE</Value>
</Value>
</Data>
<DataLocation>^SISS.St.R58D</DataLocation>
<DefaultData>R58DefaultData</DefaultData>
<ExtentSize>86</ExtentSize>
<IdLocation>^SISS.St.R58D</IdLocation>
<IndexLocation>^SISS.St.R58I</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,16,$lb("-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000"),$lb(21,21,21,21,21,21,21,21,21,21,21,21,21,21,21),$lb(758198320,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,758198320))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>4</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(259,264,270,276,282,288,294,300,306,312,318,324,329,334,339,344),$lb(1,1,2,1,2,1,0,2,1,2,1,2,1,2,1),$lb(842348800,892928000,909377536,909377536,925892608,805306368,905969664,926285824,942800896,838860800,939524096,943194112,959709184,842609664,858796032,805306368,905969664,808845312,825360384,838860800,939524096,825753600,842268672,872415232,956301312,842596352,859045888,872415232,956301312,859373568,875823104,859059200))</Histogram>
<Selectivity>1</Selectivity>
</Property>
<Property name="BELNR">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "),$lb(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,536870912))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="CutoffTs">
<AverageFieldSize>21</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb("2016-06-01 05:00:00","2016-06-01 05:00:00","2016-06-01 05:00:00","2016-12-31 05:00:00","2016-12-31 05:00:00","2016-12-31 05:00:00","2016-12-31 05:00:00","2016-12-31 05:00:00","2016-12-31 05:00:00","2016-12-31 05:00:00","2016-12-31 05:00:00","2016-12-31 05:00:00","2016-12-31 05:00:00","2016-12-31 05:00:00","2016-12-31 05:00:00","2016-12-31 05:00:00"),$lb(20,20,5,20,20,20,20,20,20,20,20,20,20,20,20),$lb(842019126,0,0,0,0,808856880,825371955,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,842019126))</Histogram>
<OutlierSelectivity>.848837:"2016-12-31 05:00:00"</OutlierSelectivity>
<Selectivity>15.1163%</Selectivity>
</Property>
<Property name="ERDAT">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "),$lb(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,536870912))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="ESTRAD">
<AverageFieldSize>2.1</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," "," "," "," 1"," 2"),$lb(2,2,2,2,2,2,2,2,2,2,2,2,2,1,1),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,822083584,822083584,838860800,540147712))</Histogram>
<OutlierSelectivity>.895349:</OutlierSelectivity>
<Selectivity>5.2326%</Selectivity>
</Property>
<Property name="ExtractedAt">
<AverageFieldSize>21</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb("2026-01-08 08:13:38","2026-01-08 08:13:38","2026-01-08 08:13:38","2026-01-08 09:46:51","2026-01-08 09:46:51","2026-01-08 09:46:51","2026-01-08 09:46:51","2026-01-08 09:46:51","2026-01-08 09:46:51","2026-01-08 09:46:51","2026-01-08 09:46:51","2026-01-08 09:46:51","2026-01-08 09:46:51","2026-01-08 09:46:51","2026-01-08 09:46:51","2026-01-08 09:46:51"),$lb(20,20,12,20,20,20,20,20,20,20,20,20,20,20,20),$lb(842019382,0,0,0,0,943337779,960115766,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,842019382))</Histogram>
<OutlierSelectivity>.848837:"2026-01-08 09:46:51"</OutlierSelectivity>
<Selectivity>15.1163%</Selectivity>
</Property>
<Property name="FEEST">
<AverageFieldSize>10</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" 00000000"," 00000000"," 00000000"," 00000000"," 00000000"," 00000000"," 00000000"," 00000000"," 00000000"," 00000000"," 00000000"," 00000000"," 00000000"," 00000000"," 20160912"," 20180612"),$lb(10,10,10,10,10,10,10,10,10,10,10,10,10,1,4),$lb(540028976,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,808464432,842019126,909130033,942683697,540160049))</Histogram>
<OutlierSelectivity>.895349:"00000000"</OutlierSelectivity>
<Selectivity>2.6163%</Selectivity>
</Property>
<Property name="FEREG">
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
<Property name="NUMRA">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "),$lb(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,536870912))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="PATNR">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "),$lb(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,536870912))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="RunId">
<AverageFieldSize>38</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" 1449FE0E-016A-4DBD-B610-012976E758FA"," 1449FE0E-016A-4DBD-B610-012976E758FA"," 1449FE0E-016A-4DBD-B610-012976E758FA"," 1449FE0E-016A-4DBD-B610-012976E758FA"," 1449FE0E-016A-4DBD-B610-012976E758FA"," 1449FE0E-016A-4DBD-B610-012976E758FA"," 1449FE0E-016A-4DBD-B610-012976E758FA"," 1449FE0E-016A-4DBD-B610-012976E758FA"," 1449FE0E-016A-4DBD-B610-012976E758FA"," 1449FE0E-016A-4DBD-B610-012976E758FA"," 1449FE0E-016A-4DBD-B610-012976E758FA"," 1449FE0E-016A-4DBD-B610-012976E758FA"," 1449FE0E-016A-4DBD-B610-012976E758FA"," 4014D74C-3711-4F5F-BC3D-12B8E7875DFF"," 4014D74C-3711-4F5F-BC3D-12B8E7875DFF"," 4014D74C-3711-4F5F-BC3D-12B8E7875DFF"),$lb(38,38,38,38,38,38,38,38,38,38,38,38,1,38,38),$lb(540095540,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,825504825,875573556,0,0,0,0,540291121))</Histogram>
<OutlierSelectivity>.848837:"1449FE0E-016A-4DBD-B610-012976E758FA"</OutlierSelectivity>
<Selectivity>15.1163%</Selectivity>
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
<Histogram>$lb(.06666666666666666667,0,0,$lb(" 0090000003"," 0090000016"," 0090000059"," 0090000079"," 0090000090"," 0090000100"," 0090000159"," 0090000202"," 0090000240"," 0090000279"," 0090000348"," 0090000359"," 0090000403"," 0090000422"," 0090000431"," 0090000464"),$lb(9,9,9,9,8,9,8,9,9,8,9,8,9,9,9),$lb(540028985,808648704,825622528,825622528,892928000,892928000,926482432,926482432,959447040,809054208,825241600,808452096,892928000,825571584,842019328,808583168,875560960,875560960,926482432,842479872,859060224,876085248,892928000,859126016,875574016,808648704,842137600,842137600,858849280,858849280,909377536,540028985))</Histogram>
<Selectivity>1.1628%</Selectivity>
</Property>
<Property name="WAERS">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "),$lb(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,536870912))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="ZUZAHLBETR">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "),$lb(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,536870912))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-12</BlockCount>
</SQLMap>
<SQLMap name="IDXR58FKDAT">
<BlockCount>-4</BlockCount>
</SQLMap>
<SQLMap name="IDXR58KUNRG">
<BlockCount>-4</BlockCount>
</SQLMap>
<SQLMap name="IDXR58VBELN">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^SISS.St.R58S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
