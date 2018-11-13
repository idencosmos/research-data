%let dir=D:\OneDrive\Github\SAS-Projects\0002\sas7bdat\;
%let lib=json;
%let String01=WBQMR1000052520180323030651FWHGU;/*apiKey*/
%let var_want=FSCL_YY
OFFC_NM
FSCL_NM
ACCT_NM
FLD_NM
SECT_NM
PGM_NM
ACTV_NM
Y_YY_MEDI_KCUR_AMT
Y_YY_DFN_MEDI_KCUR_AMT
;

libname &lib "&dir";

%macro json(String05, date_s, date_e);

	%do date_want=&date_s %to &date_e;
	data L001_&date_want;run;

		%let string02=1;
		%do %until (&check=200);

		%let url=&string05?FSCL_YY=&date_want&key=&string01&type=json&pindex=&string02&psize=1000;

		filename out "&dir.SeriesDataOut.txt" recfm=v lrecl=999999999;
		proc http out=out url="&url" method="post" ct="application/json";
		run;

		data raw;
		infile "&dir.SeriesDataOut.txt" dsd lrecl=999999999 dlm='{}[]:,';
		input raw : $2000.@@;
		if _n_=5 then call symput('check', scan(raw,2));
		run;

		data temp;
		merge raw raw(firstobs=2 rename=(raw=_raw));
		if mod(_n_,2) eq 0;
		run;

		data temp;
		set temp;
		if raw='' then group+1;
		run;

		proc transpose data=temp out=data_one(drop=_:);
		by group;
		id raw;
		var _raw;
		run;

		data L001_&date_want;
		set L001_&date_want data_one;
		run;

		%let string02=%eval(&string02+1);

		%end;

	%end;

%mend;

%json(String05=http://openapi.openfiscaldata.go.kr/ExpenditureBudgetInit, date_s=2000, date_e=2018);

/*변수명, 변수 형태 변경_start*/
data combine;
set L001_2000-L001_2018;
keep &var_want;
if FSCL_YY="" then delete;
run;
/*변수명, 변수 형태 변경_end*/

proc sql;
create table &lib..longdata_002 as
select input(FSCL_YY, best32.) as FSCL_YY label="회계연도"
, OFFC_NM as OFFC_NM label="소관명"
, FSCL_NM as FSCL_NM label="회계명"
, ACCT_NM as ACCT_NM label="계정명"
, FLD_NM as FLD_NM label="분야명"
, SECT_NM as SECT_NM label="부문명"
, PGM_NM as PGM_NM label="프로그램명"
, ACTV_NM as ACTV_NM label="단위사업명"
, input(Y_YY_MEDI_KCUR_AMT, best32.)*1000 as Y_YY_MEDI_KCUR_AMT label="금년도정부안(원)"
, input(Y_YY_DFN_MEDI_KCUR_AMT, best32.)*1000 as Y_YY_DFN_MEDI_KCUR_AMT label="금년도국회확정(원)"
from combine;
quit;
run;
