%let dir=D:\OneDrive\Github\SAS-Projects\0002\sas7bdat\;
%let lib=A0002;

libname &lib "&dir";

%let data=longdata_GDP;
%let url=http://www.index.go.kr/openApi/xml_stts.do?userId=idencosmos&idntfcId=3T1U05B582198A15&statsCode=273601;

filename out temp;
filename map temp;
filename map_re temp;
proc http url="&url"
method="get" out=out;
run;
libname raw xmlv2 xmlfileref=out xmlmap=map automap=replace;

	data map;
	 infile map dsd  lrecl=999999999;
	 input raw: $2000.@@;
	run;

	data map_re;
	set map;
	if index(raw,'<LENGTH>')^=0 then raw='<LENGTH>2000</LENGTH>';
	run;

	data _null_;
	set map_re;
	file map_re;
	put raw;
	run;

libname raw xmlv2 xmlfileref=out xmlmap=map_re;

proc sql;
	create table &lib..&data as
	select *
	from raw._name5
	where _name4_ordinal=2;
quit;
run;
