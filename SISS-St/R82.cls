Class SISS.St.R82 Extends %Persistent
{

Property RunId As %String(MAXLEN = 64);

Property ExtractedAt As %TimeStamp;

Property CutoffTs As %TimeStamp;

Property BUKRS As %String(MAXLEN = 16);

Property FKART As %String(MAXLEN = 16);

Property FKDAT As %String(MAXLEN = 16);

Property ISHEINRI As %String(MAXLEN = 16);

Property ISHKOSTR As %String(MAXLEN = 32);

Property ISHKTART As %String(MAXLEN = 32);

Property KUNNR As %String(MAXLEN = 32);

Property MWSBK As %String(MAXLEN = 32);

Property NAMEK As %String(MAXLEN = 128);

Property NETWR As %String(MAXLEN = 32);

Property TOTALFACT As %String(MAXLEN = 32) [ SqlFieldName = TOTAL_FACT ];

Property VBELN As %String(MAXLEN = 32);

Property XBLNR As %String(MAXLEN = 32);

Index IDXR82VBELN On VBELN;

Index IDXR82CUTOFF On CutoffTs;

Index IDXR82BUKRS On BUKRS;

Storage Default
{
<Data name="R82DefaultData">
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
<Value>BUKRS</Value>
</Value>
<Value name="6">
<Value>FKART</Value>
</Value>
<Value name="7">
<Value>FKDAT</Value>
</Value>
<Value name="8">
<Value>ISHEINRI</Value>
</Value>
<Value name="9">
<Value>ISHKOSTR</Value>
</Value>
<Value name="10">
<Value>ISHKTART</Value>
</Value>
<Value name="11">
<Value>KUNNR</Value>
</Value>
<Value name="12">
<Value>MWSBK</Value>
</Value>
<Value name="13">
<Value>NAMEK</Value>
</Value>
<Value name="14">
<Value>NETWR</Value>
</Value>
<Value name="15">
<Value>TOTALFACT</Value>
</Value>
<Value name="16">
<Value>VBELN</Value>
</Value>
<Value name="17">
<Value>XBLNR</Value>
</Value>
</Data>
<DataLocation>^SISS.St.R82D</DataLocation>
<DefaultData>R82DefaultData</DefaultData>
<ExtentSize>207</ExtentSize>
<IdLocation>^SISS.St.R82D</IdLocation>
<IndexLocation>^SISS.St.R82I</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,16,$lb("-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000"),$lb(21,21,21,21,21,21,21,21,21,21,21,21,21,21,21),$lb(758198320,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,758198320))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>4</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(415,428,442,456,470,484,498,512,526,540,554,568,582,595,608,621),$lb(1,1,1,1,1,1,0,1,1,1,1,1,1,0,1),$lb(875640064,825556992,842530816,842530816,875692032,875692032,892731392,892731392,925892608,925892608,942931968,942931968,959971328,876165120,892416512,825360384,842399744,842399744,875560960,875560960,892600320,892600320,909639680,909639680,942800896,942800896,959774720,892941568,909129728,808976384,842072064,909259008))</Histogram>
<Selectivity>1</Selectivity>
</Property>
<Property name="BUKRS">
<AverageFieldSize>6</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" 1000"," 1000"," 1000"," 1000"," 1000"," 1000"," 1000"," 1000"," 1000"," 1000"," 1000"," 1000"," 1000"," 1000"," 1000"," 1000"),$lb(6,6,6,6,6,6,6,6,6,6,6,6,6,6,6),$lb(540094512,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,540094512))</Histogram>
<OutlierSelectivity>.999999:1000</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="CutoffTs">
<AverageFieldSize>21</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb("2016-06-01 05:00:00","2016-06-01 05:00:00","2016-06-01 05:00:00","2016-06-30 05:00:00","2016-06-30 05:00:00","2016-06-30 05:00:00","2016-06-30 05:00:00","2016-06-30 05:00:00","2016-12-31 05:00:00","2016-12-31 05:00:00","2016-12-31 05:00:00","2016-12-31 05:00:00","2016-12-31 05:00:00","2016-12-31 05:00:00","2016-12-31 05:00:00","2016-12-31 05:00:00"),$lb(20,20,8,20,20,20,20,5,20,20,20,20,20,20,20),$lb(842019126,0,0,0,0,808525872,858791984,0,0,0,0,0,0,0,0,808856883,825371955,0,0,0,0,0,0,0,0,0,0,0,0,0,0,842019126))</Histogram>
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ExtractedAt">
<AverageFieldSize>21</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb("2026-01-08 08:45:08","2026-01-08 08:45:08","2026-01-08 08:45:08","2026-01-08 09:46:53","2026-01-08 09:46:53","2026-01-08 09:46:53","2026-01-08 09:46:53","2026-01-08 09:46:53","2026-01-08 09:46:53","2026-01-08 09:46:53","2026-01-08 09:50:44","2026-01-08 09:50:44","2026-01-08 09:50:44","2026-01-08 09:50:44","2026-01-08 09:50:44","2026-01-08 09:50:44"),$lb(20,20,12,20,20,20,20,20,20,14,20,20,20,20,20),$lb(842019382,0,0,0,0,943338549,960115766,0,0,0,0,0,0,0,0,0,0,0,0,875969077,892353076,0,0,0,0,0,0,0,0,0,0,842019382))</Histogram>
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="FKART">
<AverageFieldSize>6</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" NF01"," NF01"," NF01"," NF01"," NF01"," NF01"," NF01"," NF01"," NF01"," NF01"," NF01"," NF01"," NF01"," NF01"," NF01"," ZISH"),$lb(6,6,6,6,6,6,6,6,6,6,6,6,6,6,1),$lb(542000688,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1313222705,1514754888,542787923))</Histogram>
<OutlierSelectivity>.942029:"NF01"</OutlierSelectivity>
<Selectivity>1.9324%</Selectivity>
</Property>
<Property name="FKDAT">
<AverageFieldSize>6</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" 2016"," 2016"," 2016"," 2016"," 2016"," 2016"," 2016"," 2016"," 2016"," 2016"," 2016"," 2016"," 2016"," 2016"," 2016"," 2016"),$lb(6,6,6,6,6,6,6,6,6,6,6,6,6,6,6),$lb(540160049,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,540160049))</Histogram>
<OutlierSelectivity>.999999:2016</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="ISHEINRI">
<AverageFieldSize>5.77</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," 1000"," 1000"," 1000"," 1000"," 1000"," 1000"," 1000"," 1000"," 1000"," 1000"," 1000"," 1000"," 1000"," 1000"," 1000"),$lb(1,6,6,6,6,6,6,6,6,6,6,6,6,6,6),$lb(536870912,0,825241648,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,540094512))</Histogram>
<OutlierSelectivity>.942029:1000</OutlierSelectivity>
<Selectivity>5.7971%</Selectivity>
</Property>
<Property name="ISHKOSTR">
<AverageFieldSize>5.21</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," 0010"," 0010"," 0010"," 0010"," 0010"," 0010"," 0010"," 0010"," 0010"," 0010"," 0010"," 0010"," 0010"),$lb(2,2,1,6,6,6,6,6,6,6,6,6,6,6,6),$lb(536870912,0,0,0,0,0,808464688,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,540028977))</Histogram>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="ISHKTART">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "),$lb(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,536870912))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="KUNNR">
<AverageFieldSize>6</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" 0000"," 0000"," 0000"," 0000"," 0000"," 0000"," 0000"," 0000"," 0000"," 0000"," 0000"," 0000"," 0000"," 0000"," 0000"," 0000"),$lb(6,6,6,6,6,6,6,6,6,6,6,6,6,6,6),$lb(540028976,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,540028976))</Histogram>
<OutlierSelectivity>.999999:"0000"</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="MWSBK">
<AverageFieldSize>6</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" 0.00"," 0.00"," 0.00"," 0.00"," 0.00"," 0.00"," 0.00"," 0.00"," 0.00"," 0.00"," 0.00"," 0.00"," 0.00"," 0.00"," 0.00"," 0.00"),$lb(6,6,6,6,6,6,6,6,6,6,6,6,6,6,6),$lb(540028464,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,540028464))</Histogram>
<OutlierSelectivity>.999999:"0.00"</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="NAMEK">
<AverageFieldSize>6</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" ASEG"," CALP"," COOM"," COOM"," COOM"," COOM"," COOM"," DEL"," FLOR"," PAC"," SANC"," SOAT"," SOAT"," SOAT"," SOAT"," SOAT"),$lb(1,2,6,6,6,6,1,1,1,1,2,6,6,6,6),$lb(541152069,1095976263,1128352848,1095520256,1330597120,0,0,0,0,0,0,0,0,1129271117,1145392128,1145392128,1179406162,1179406162,1346454272,1346454272,1396788803,1095648000,1329681408,0,0,0,0,0,0,0,0,542330689))</Histogram>
<OutlierSelectivity>.376812:"COOM"</OutlierSelectivity>
<Selectivity>4.4513%</Selectivity>
</Property>
<Property name="NETWR">
<AverageFieldSize>8.52</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" 10.00"," 110.15"," 12009.60"," 1363.00"," 150.00"," 169.00"," 204.00"," 2222.00"," 279.15"," 3000000.00"," 404.15"," 501.00"," 582.95"," 800.00"," 83.40"," 9703.25"),$lb(2,2,2,2,2,1,2,2,1,1,1,2,1,2,1),$lb(540094510,808333360,825241137,825241137,842018873,842018873,859190062,859190062,892350000,892350000,909717040,825637166,842019886,808726064,842150446,842150446,926494257,842479918,858796080,858796080,875574318,875574318,892350766,808529456,942812729,892875310,942682158,808463920,858666032,942878260,959918131,540620592))</Histogram>
<Selectivity>1.0989%</Selectivity>
</Property>
<Property name="RunId">
<AverageFieldSize>38</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" 1449FE0E-016A-4DBD-B610-012976E758FA"," 1449FE0E-016A-4DBD-B610-012976E758FA"," 1449FE0E-016A-4DBD-B610-012976E758FA"," 1449FE0E-016A-4DBD-B610-012976E758FA"," 1449FE0E-016A-4DBD-B610-012976E758FA"," 1449FE0E-016A-4DBD-B610-012976E758FA"," 1449FE0E-016A-4DBD-B610-012976E758FA"," 1449FE0E-016A-4DBD-B610-012976E758FA"," 508B4B26-1816-42EE-B5BF-2F5DBF82ED95"," 508B4B26-1816-42EE-B5BF-2F5DBF82ED95"," 508B4B26-1816-42EE-B5BF-2F5DBF82ED95"," 508B4B26-1816-42EE-B5BF-2F5DBF82ED95"," 508B4B26-1816-42EE-B5BF-2F5DBF82ED95"," 731F5341-F34D-4F4A-BFE6-77DD2AF6D810"," 731F5341-F34D-4F4A-BFE6-77DD2AF6D810"," 731F5341-F34D-4F4A-BFE6-77DD2AF6D810"),$lb(38,38,38,38,38,38,38,1,38,38,38,38,1,38,38),$lb(540095540,0,0,0,0,0,0,0,0,0,0,0,0,0,0,825504825,892352578,0,0,0,0,0,0,0,0,892352578,926101830,0,0,0,0,540488497))</Histogram>
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="TOTALFACT">
<AverageFieldSize>8.52</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" 10.00"," 110.15"," 12009.60"," 1363.00"," 150.00"," 169.00"," 204.00"," 2222.00"," 279.15"," 3000000.00"," 404.15"," 501.00"," 582.95"," 800.00"," 83.40"," 9703.25"),$lb(2,2,2,2,2,1,2,2,1,1,1,2,1,2,1),$lb(540094510,808333360,825241137,825241137,842018873,842018873,859190062,859190062,892350000,892350000,909717040,825637166,842019886,808726064,842150446,842150446,926494257,842479918,858796080,858796080,875574318,875574318,892350766,808529456,942812729,892875310,942682158,808463920,858666032,942878260,959918131,540620592))</Histogram>
<Selectivity>1.0989%</Selectivity>
</Property>
<Property name="VBELN">
<AverageFieldSize>6</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" 0035"," 0090"," 0090"," 0090"," 0090"," 0090"," 0090"," 0090"," 0090"," 0090"," 0090"," 0090"," 0090"," 0090"," 0090"," 0090"),$lb(3,6,6,6,6,6,6,6,6,6,6,6,6,6,6),$lb(540028979,859111424,959447040,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,540028985))</Histogram>
<OutlierSelectivity>.951691:"0090"</OutlierSelectivity>
<Selectivity>4.8309%</Selectivity>
</Property>
<Property name="XBLNR">
<AverageFieldSize>6</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" 0035"," 0090"," 0090"," 0090"," 0090"," 0090"," 0090"," 0090"," 0090"," 0090"," 0090"," 0090"," 0090"," 0090"," 0090"," 0090"),$lb(3,6,6,6,6,6,6,6,6,6,6,6,6,6,6),$lb(540028979,859111424,959447040,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,540028985))</Histogram>
<OutlierSelectivity>.951691:"0090"</OutlierSelectivity>
<Selectivity>4.8309%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-20</BlockCount>
</SQLMap>
<SQLMap name="IDXR82BUKRS">
<BlockCount>-4</BlockCount>
</SQLMap>
<SQLMap name="IDXR82CUTOFF">
<BlockCount>-4</BlockCount>
</SQLMap>
<SQLMap name="IDXR82VBELN">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^SISS.St.R82S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
