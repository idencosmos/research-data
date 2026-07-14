/* ------------------------------------------------------------------ *
 * Bundle derived from 0001/1. Final_extraction_longdata_002.sas
 * (idencosmos/research-data — 예산편성현황 추출, longdata_002).
 *
 * The upstream script fetches the ExpenditureBudgetInit API year by
 * year and parses it into a character dataset `combine`, then runs the
 * PROC SQL below: input(...,best32.) plus a *1000 rescale from 천원 to
 * 원 for the 정부안 / 국회확정 amounts, with Korean labels. Here `combine`
 * is stood in for with a small datalines sample of the same columns so
 * the transform runs in isolation; the SELECT list, the *1000 scaling
 * and the labels are the script's own, unchanged.
 * ------------------------------------------------------------------ */

/* stand-in for the API-parsed `combine` dataset: same character columns
   the upstream PROC SQL reads */
data combine;
  length FSCL_YY $4 OFFC_NM $40 FSCL_NM $20 ACCT_NM $20 FLD_NM $20
         SECT_NM $20 PGM_NM $40 ACTV_NM $40
         Y_YY_MEDI_KCUR_AMT Y_YY_DFN_MEDI_KCUR_AMT $16;
  infile datalines dsd truncover;
  input FSCL_YY $ OFFC_NM $ FSCL_NM $ ACCT_NM $ FLD_NM $ SECT_NM $ PGM_NM $
        ACTV_NM $ Y_YY_MEDI_KCUR_AMT $ Y_YY_DFN_MEDI_KCUR_AMT $;
datalines;
2016,국회,일반회계,일반회계,일반공공행정,입법및선거관리,국회운영,국회운영지원,580000,585000
2016,대법원,일반회계,일반회계,일반공공행정,사법,사법행정,법원운영,320000,326000
2017,국회,일반회계,일반회계,일반공공행정,입법및선거관리,국회운영,국회운영지원,600000,606000
2017,국방부,일반회계,일반회계,국방,국방정책,국방정책지원,전력운영,1200000,1260000
2018,국방부,일반회계,일반회계,국방,국방정책,국방정책지원,전력운영,1300000,1315000
;
run;

/* ---- upstream PROC SQL (unchanged apart from writing to WORK) ---- */
proc sql;
create table longdata_002 as
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

/* show the rescaled 정부안 vs 국회확정 amounts */
proc print data=longdata_002 label;
  var FSCL_YY OFFC_NM Y_YY_MEDI_KCUR_AMT Y_YY_DFN_MEDI_KCUR_AMT;
run;
