/* ------------------------------------------------------------------ *
 * Bundle derived from 0001/2. Final_extraction_longdata_004.sas
 * (idencosmos/research-data — 결산현황 추출, longdata_004).
 *
 * The upstream script fetches the ExpendituresSettlement API year by
 * year, parses the JSON into a character dataset `combine`, then runs
 * the PROC SQL below to type-convert every amount with input(...,best32.)
 * and attach Korean variable labels — DUSEAMT (불용액) being the study's
 * core variable. Here `combine` is stood in for with a small datalines
 * sample of the same columns so the PROC SQL runs in isolation; the
 * SELECT list, conversions and labels are the script's own, unchanged.
 * ------------------------------------------------------------------ */

/* stand-in for the API-parsed `combine` dataset: same character columns
   the upstream PROC SQL reads, a handful of representative rows */
data combine;
  length FSCL_YY $4 OFFC_CD $6 OFFC_NM $40 FSCL_CD $4 FSCL_NM $20
         ACCT_CD $4 ACCT_NM $20 FLD_CD $4 FLD_NM $20 SECT_CD $4 SECT_NM $20
         PGM_CD $6 PGM_NM $40 ACTV_CD $6 ACTV_NM $40 CITM_CD $4 CITM_NM $20
         ANEXP_BDGAMT_F ANEXP_BDGAMT_M PREY_BFWAMT OVR_EP_AMT
         RSVF_EP_DCS_IAMT RSVF_EP_DCS_MAMT BDTR_IAMT BDTR_MAMT
         AVDV_IAMT AVDV_MAMT FNT_IAMT FNT_MAMT ANEXP_BDG_CAMT
         EP_AMT EP_NAMT NEXT_YY_BFWAMT DUSEAMT $16;
  infile datalines dsd truncover;
  input FSCL_YY $ OFFC_CD $ OFFC_NM $ FSCL_CD $ FSCL_NM $ ACCT_CD $ ACCT_NM $
        FLD_CD $ FLD_NM $ SECT_CD $ SECT_NM $ PGM_CD $ PGM_NM $ ACTV_CD $ ACTV_NM $
        CITM_CD $ CITM_NM $ ANEXP_BDGAMT_F $ ANEXP_BDGAMT_M $ PREY_BFWAMT $
        OVR_EP_AMT $ RSVF_EP_DCS_IAMT $ RSVF_EP_DCS_MAMT $ BDTR_IAMT $ BDTR_MAMT $
        AVDV_IAMT $ AVDV_MAMT $ FNT_IAMT $ FNT_MAMT $ ANEXP_BDG_CAMT $
        EP_AMT $ EP_NAMT $ NEXT_YY_BFWAMT $ DUSEAMT $;
datalines;
2016,1100,국회,10,일반회계,10,일반회계,11,일반공공행정,110,입법및선거관리,1100,국회운영,1101,국회운영지원,110,인건비,580000,585000,0,0,0,0,0,0,0,0,0,0,585000,560000,560000,5000,20000
2016,1200,대법원,10,일반회계,10,일반회계,11,일반공공행정,120,사법,1200,사법행정,1201,법원운영,120,물건비,320000,325000,1000,0,0,0,0,0,0,0,0,0,326000,310000,310000,2000,14000
2017,1100,국회,10,일반회계,10,일반회계,11,일반공공행정,110,입법및선거관리,1100,국회운영,1101,국회운영지원,110,인건비,600000,606000,0,0,0,0,0,0,0,0,0,0,606000,590000,590000,4000,12000
2017,2800,국방부,10,일반회계,10,일반회계,15,국방,150,국방정책,2800,국방정책지원,2801,전력운영,150,물건비,1200000,1210000,0,0,50000,0,0,0,0,0,0,0,1260000,1200000,1200000,30000,30000
2018,2800,국방부,10,일반회계,10,일반회계,15,국방,150,국방정책,2800,국방정책지원,2801,전력운영,150,물건비,1300000,1315000,0,0,0,0,0,0,0,0,0,0,1315000,1280000,1280000,15000,20000
;
run;

/* ---- upstream PROC SQL (unchanged apart from writing to WORK) ---- */
proc sql;
create table longdata_004 as
select input(FSCL_YY, best32.) as FSCL_YY label="회계연도"
, OFFC_CD as OFFC_CD label="소관"
, OFFC_NM as OFFC_NM label="소관명"
, FSCL_CD as FSCL_CD label="회계"
, FSCL_NM as FSCL_NM label="회계명"
, ACCT_CD as ACCT_CD label="계정"
, ACCT_NM as ACCT_NM label="계정명"
, FLD_CD as FLD_CD label="분야"
, FLD_NM as FLD_NM label="분야명"
, SECT_CD as SECT_CD label="부문"
, SECT_NM as SECT_NM label="부문명"
, PGM_CD as PGM_CD label="프로그램"
, PGM_NM as PGM_NM label="프로그램명"
, ACTV_CD as ACTV_CD label="단위사업"
, ACTV_NM as ACTV_NM label="단위사업명"
, CITM_CD as CITM_CD label="지출목"
, CITM_NM as CITM_NM label="지출목명"
, input(ANEXP_BDGAMT_F, best32.) as ANEXP_BDGAMT_F label="세출예산액/당초지출계획액(원)"
, input(ANEXP_BDGAMT_M, best32.) as ANEXP_BDGAMT_M label="세출예산액/수정지출계획액(원)"
, input(PREY_BFWAMT, best32.) as PREY_BFWAMT label="전년도이월액(원)"
, input(OVR_EP_AMT, best32.) as OVR_EP_AMT label="초과지출승인액(원)"
, input(RSVF_EP_DCS_IAMT, best32.) as RSVF_EP_DCS_IAMT label="예비비지출결정증액(원)"
, input(RSVF_EP_DCS_MAMT, best32.) as RSVF_EP_DCS_MAMT label="예비비지출결정감액(원)"
, input(BDTR_IAMT, best32.) as BDTR_IAMT label="전용증액(원)"
, input(BDTR_MAMT, best32.) as BDTR_MAMT label="전용감액(원)"
, input(AVDV_IAMT, best32.) as AVDV_IAMT label="이용증액(원)"
, input(AVDV_MAMT, best32.) as AVDV_MAMT label="이용감액(원)"
, input(FNT_IAMT, best32.) as FNT_IAMT label="이체증액(원)"
, input(FNT_MAMT, best32.) as FNT_MAMT label="이체감액(원)"
, input(ANEXP_BDG_CAMT, best32.) as ANEXP_BDG_CAMT label="세출예산현액/지출계획현액(원)"
, input(EP_AMT, best32.) as EP_AMT label="지출액(원)"
, input(EP_NAMT, best32.) as EP_NAMT label="지출순액(원)"
, input(NEXT_YY_BFWAMT, best32.) as NEXT_YY_BFWAMT label="다음년도이월액(원)"
, input(DUSEAMT, best32.) as DUSEAMT label="불용액(원)"
from combine;
quit;
run;

/* show the converted result (불용액 by 회계연도/소관) */
proc print data=longdata_004 label;
  var FSCL_YY OFFC_NM ANEXP_BDG_CAMT EP_AMT DUSEAMT;
run;

proc means data=longdata_004 sum;
  class FSCL_YY;
  var DUSEAMT;
run;
