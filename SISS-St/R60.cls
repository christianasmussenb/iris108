Class SISS.St.R60 Extends %Persistent
{

Property RunId As %String(MAXLEN = 64);

Property ExtractedAt As %TimeStamp;

Property CutoffTs As %TimeStamp;

Property VBELN As %String(MAXLEN = 32);

Property POSNR As %String(MAXLEN = 16);

Property FKDAT As %String(MAXLEN = 16);

Property ERDAT As %String(MAXLEN = 16);

Property FKART As %String(MAXLEN = 16);

Property PATNR As %String(MAXLEN = 32);

Property KUNRG As %String(MAXLEN = 32);

Property ISHKOSTR As %String(MAXLEN = 32);

Property ISHKTART As %String(MAXLEN = 32);

Property NETWR As %String(MAXLEN = 32);

Property FKIMG As %String(MAXLEN = 32);

Property VRKME As %String(MAXLEN = 16);

Property PRCTR As %String(MAXLEN = 32);

Property KOSTL As %String(MAXLEN = 32);

Property AUFNR As %String(MAXLEN = 32);

Index IDXR60VBELN On VBELN;

Index IDXR60VBELNPOS On (VBELN, POSNR);

Index IDXR60CUTOFF On CutoffTs;

Storage Default
{
<Data name="R60DefaultData">
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
<Value>POSNR</Value>
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
<Value>NETWR</Value>
</Value>
<Value name="15">
<Value>FKIMG</Value>
</Value>
<Value name="16">
<Value>VRKME</Value>
</Value>
<Value name="17">
<Value>PRCTR</Value>
</Value>
<Value name="18">
<Value>KOSTL</Value>
</Value>
<Value name="19">
<Value>AUFNR</Value>
</Value>
</Data>
<DataLocation>^SISS.St.R60D</DataLocation>
<DefaultData>R60DefaultData</DefaultData>
<ExtentSize>192</ExtentSize>
<IdLocation>^SISS.St.R60D</IdLocation>
<IndexLocation>^SISS.St.R60I</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,16,$lb("-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000"),$lb(21,21,21,21,21,21,21,21,21,21,21,21,21,21,21),$lb(758198320,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,758198320))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>4</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(577,589,602,615,628,641,654,667,680,693,706,719,732,744,756,768),$lb(1,0,1,1,1,1,1,1,1,0,1,1,1,1,1),$lb(892811008,926351360,943259648,892877056,909128192,808583168,825556992,825556992,842530816,842530816,875626496,875626496,892600320,892600320,909574144,909574144,942669824,942669824,959643648,909718272,925906432,808845312,825819136,825819136,858914816,858914816,875823104,875823104,892731392,892731392,909639680,926300160))</Histogram>
<Selectivity>1</Selectivity>
</Property>
<Property name="AUFNR">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "),$lb(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,536870912))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="CutoffTs">
<AverageFieldSize>21</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb("2016-06-01 05:00:00","2016-06-01 05:00:00","2016-06-01 05:00:00","2016-06-01 05:00:00","2016-12-31 05:00:00","2016-12-31 05:00:00","2016-12-31 05:00:00","2016-12-31 05:00:00","2016-12-31 05:00:00","2016-12-31 05:00:00","2016-12-31 05:00:00","2016-12-31 05:00:00","2016-12-31 05:00:00","2016-12-31 05:00:00","2016-12-31 05:00:00","2016-12-31 05:00:00"),$lb(20,20,20,5,20,20,20,20,20,20,20,20,20,20,20),$lb(842019126,0,0,0,0,0,0,808856880,825371955,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,842019126))</Histogram>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="ERDAT">
<AverageFieldSize>10</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" 20160331"," 20160421"," 20160503"," 20160601"," 20160603"," 20160613"," 20160613"," 20160613"," 20160614"," 20160620"," 20160622"," 20160623"," 20160706"," 20160727"," 20161115"," 20161206"),$lb(6,6,6,8,7,10,10,8,7,8,8,6,7,5,6),$lb(540160049,858992896,875704576,875704576,892351232,892351232,909127936,822083584,855638016,808648704,825425920,0,0,0,0,855638016,872415232,825491456,842006528,805306368,838860800,838860800,855638016,909259520,925906432,808845312,842465280,808923703,825307445,825308416,842020352,540160049))</Histogram>
<OutlierSelectivity>.161458:20160613</OutlierSelectivity>
<Selectivity>1.6771%</Selectivity>
</Property>
<Property name="ExtractedAt">
<AverageFieldSize>21</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb("2026-01-08 08:13:38","2026-01-08 08:13:38","2026-01-08 08:13:38","2026-01-08 08:13:38","2026-01-08 09:46:49","2026-01-08 09:46:49","2026-01-08 09:46:49","2026-01-08 09:46:49","2026-01-08 09:46:49","2026-01-08 09:46:49","2026-01-08 09:46:49","2026-01-08 09:46:49","2026-01-08 09:46:49","2026-01-08 09:46:49","2026-01-08 09:46:49","2026-01-08 09:46:49"),$lb(20,20,20,12,20,20,20,20,20,20,20,20,20,20,20),$lb(842019382,0,0,0,0,0,0,943337779,960115766,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,842019382))</Histogram>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="FKART">
<AverageFieldSize>6</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" NF01"," NF01"," NF01"," NF01"," NF01"," NF01"," NF01"," NF01"," NF01"," NF01"," NF01"," NF01"," NF01"," NF01"," NF01"," NF01"),$lb(6,6,6,6,6,6,6,6,6,6,6,6,6,6,6),$lb(542000688,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,542000688))</Histogram>
<OutlierSelectivity>.999999:"NF01"</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="FKDAT">
<AverageFieldSize>10</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" 20160331"," 20160421"," 20160503"," 20160601"," 20160603"," 20160613"," 20160613"," 20160613"," 20160614"," 20160620"," 20160622"," 20160623"," 20160706"," 20160727"," 20161115"," 20161206"),$lb(6,6,6,8,7,10,10,8,7,8,8,6,7,5,6),$lb(540160049,858992896,875704576,875704576,892351232,892351232,909127936,822083584,855638016,808648704,825425920,0,0,0,0,855638016,872415232,825491456,842006528,805306368,838860800,838860800,855638016,909259520,925906432,808845312,842465280,808923703,825307445,825308416,842020352,540160049))</Histogram>
<OutlierSelectivity>.161458:20160613</OutlierSelectivity>
<Selectivity>1.6771%</Selectivity>
</Property>
<Property name="FKIMG">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "),$lb(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,536870912))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="ISHKOSTR">
<AverageFieldSize>11.32</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," 0010000000"," 0010000000"," 0010000000"," 0010000000"," 0010000001"," 0010000003"," 0010000003"," 0010000003"," 0010000003"," 0010000003"," 0010000004"," 0010000010"," 0010000017"," 0010000063"),$lb(2,1,12,12,12,10,10,12,12,12,12,10,9,10,9),$lb(536870912,0,0,0,808464688,0,0,0,0,0,0,805306368,822083584,822083584,855638016,0,0,0,0,0,0,0,0,855638016,872415232,808714240,825229312,805306368,922746880,825688064,909312000,540028977))</Histogram>
<OutlierSelectivity>.338542:"0010000003"</OutlierSelectivity>
<Selectivity>6.6146%</Selectivity>
</Property>
<Property name="ISHKTART">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "),$lb(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,536870912))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="KOSTL">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "),$lb(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,536870912))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="KUNRG">
<AverageFieldSize>12</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" 0000000002"," 0000000002"," 0000000002"," 0000000002"," 0000000002"," 0000000002"," 0000000005"," 0000000005"," 0000000005"," 0000000005"," 0000000005"," 0000000007"," 0000000009"," 0000000009"," 0000700004"," 0000700110"),$lb(12,12,12,12,12,10,12,12,12,12,10,10,12,5,8),$lb(540028976,0,0,0,0,0,0,0,0,0,0,838860800,889192448,0,0,0,0,0,0,0,0,889192448,922746880,922746880,956301312,0,0,808464432,925904944,808465408,825307136,540028976))</Histogram>
<OutlierSelectivity>.348958:"0000000005"</OutlierSelectivity>
<Selectivity>4.0690%</Selectivity>
</Property>
<Property name="NETWR">
<AverageFieldSize>8.41</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" 10052.35"," 110.15"," 12380.60"," 125.10"," 150.00"," 19.80"," 2174.75"," 271.00"," 279.15"," 3167.50"," 515.40"," 708.00"," 8003.20"," 8003.20"," 83.40"," 9703.25"),$lb(2,2,3,2,2,1,2,3,1,1,1,1,9,2,1),$lb(540094512,808465714,825241137,825241137,842217520,859320366,892219696,842346033,892350000,892350000,959330352,825830968,842086196,825701422,925969968,825110576,959328565,842479918,858863159,858863159,892417326,892417326,925906990,925906990,942682163,0,0,808465198,858666032,942878260,959918131,540620592))</Histogram>
<OutlierSelectivity>.130208:"8003.20"</OutlierSelectivity>
<Selectivity>1.0607%</Selectivity>
</Property>
<Property name="PATNR">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "),$lb(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,536870912))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="POSNR">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "),$lb(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,536870912))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="PRCTR">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "),$lb(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,536870912))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="RunId">
<AverageFieldSize>38</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" 1449FE0E-016A-4DBD-B610-012976E758FA"," 1449FE0E-016A-4DBD-B610-012976E758FA"," 1449FE0E-016A-4DBD-B610-012976E758FA"," 1449FE0E-016A-4DBD-B610-012976E758FA"," 1449FE0E-016A-4DBD-B610-012976E758FA"," 1449FE0E-016A-4DBD-B610-012976E758FA"," 1449FE0E-016A-4DBD-B610-012976E758FA"," 1449FE0E-016A-4DBD-B610-012976E758FA"," 1449FE0E-016A-4DBD-B610-012976E758FA"," 1449FE0E-016A-4DBD-B610-012976E758FA"," 1449FE0E-016A-4DBD-B610-012976E758FA"," 1449FE0E-016A-4DBD-B610-012976E758FA"," 4014D74C-3711-4F5F-BC3D-12B8E7875DFF"," 4014D74C-3711-4F5F-BC3D-12B8E7875DFF"," 4014D74C-3711-4F5F-BC3D-12B8E7875DFF"," 4014D74C-3711-4F5F-BC3D-12B8E7875DFF"),$lb(38,38,38,38,38,38,38,38,38,38,38,1,38,38,38),$lb(540095540,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,825504825,875573556,0,0,0,0,0,0,540291121))</Histogram>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="VBELN">
<AverageFieldSize>12</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" 0090000003"," 0090000025"," 0090000038"," 0090000059"," 0090000082"," 0090000102"," 0090000129"," 0090000157"," 0090000184"," 0090000206"," 0090000229"," 0090000254"," 0090000333"," 0090000364"," 0090000420"," 0090000464"),$lb(9,9,9,9,8,9,9,9,8,9,9,8,9,8,9),$lb(540028985,808648704,842334208,842334208,859308032,859308032,892928000,892928000,942800896,808989184,825242112,808583168,842596352,842596352,892796928,892796928,942931968,825766912,842020352,808845312,842596352,842596352,892600320,842347520,858993408,858980352,909377536,859190272,875704320,842006528,909377536,540028985))</Histogram>
<Selectivity>0.5208%</Selectivity>
</Property>
<Property name="VRKME">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "),$lb(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,536870912))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-20</BlockCount>
</SQLMap>
<SQLMap name="IDXR60CUTOFF">
<BlockCount>-4</BlockCount>
</SQLMap>
<SQLMap name="IDXR60VBELN">
<BlockCount>-4</BlockCount>
</SQLMap>
<SQLMap name="IDXR60VBELNPOS">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^SISS.St.R60S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
