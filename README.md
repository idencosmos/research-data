# 불용액의 정권 연차별 변화와 국회 예산심의의 효율성

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![SAS 9.4](https://img.shields.io/badge/SAS-9.4%20Unicode-blue.svg)](https://www.sas.com/)

> **Annual Changes in Unused Budget by Administration and the Efficiency of National Assembly Budget Deliberation**

한국 정부 예산의 불용액(未使用 예산) 패턴을 정권별로 분석하고, 국회 예산심의의 효율성을 평가하는 연구 프로젝트입니다.

---

## 목차

- [연구 배경](#연구-배경)
- [디렉토리 구조](#디렉토리-구조)
- [데이터 설명](#데이터-설명)
  - [데이터 출처](#데이터-출처)
  - [데이터셋 목록](#데이터셋-목록)
  - [주요 변수](#주요-변수)
- [사용 방법](#사용-방법)
  - [필수 환경](#필수-환경)
  - [API 키 발급](#api-키-발급)
  - [실행 방법](#실행-방법)
- [인용](#인용)
- [라이선스](#라이선스)
- [연락처](#연락처)

---

## 연구 배경

**불용액(不用額)** 이란 예산으로 배정되었으나 실제로 사용되지 않고 남은 금액을 의미합니다. 불용액의 규모와 패턴은 정부의 예산 편성 및 집행 능력, 그리고 국회 예산심의의 효율성을 평가하는 중요한 지표가 됩니다.

본 연구는 다음 질문에 답하고자 합니다:
- 정권별로 불용액의 규모와 패턴이 어떻게 변화하는가?
- 국회의 예산심의 과정이 불용액 발생에 어떤 영향을 미치는가?
- 예산심의의 효율성을 높이기 위한 개선 방안은 무엇인가?

---

## 디렉토리 구조

```
research-data/
├── README.md                              # 프로젝트 문서 (현재 파일)
├── LICENSE                                # MIT 라이선스
└── 0001/                                  # 연구 데이터셋 #1
    ├── 1. Final_extraction_longdata_002.sas   # 예산편성현황 추출
    ├── 2. Final_extraction_longdata_004.sas   # 결산현황 추출
    └── 3. Final_extraction_longdata_GDP.sas   # GDP 데이터 추출
```

---

## 데이터 설명

### 데이터 출처

| 출처 | URL | 설명 |
|------|-----|------|
| 열린재정 | https://openapi.openfiscaldata.go.kr | 정부 예산/결산 데이터 API |
| 국가지표체계 | https://www.index.go.kr | GDP 등 국가 통계 지표 |

### 데이터셋 목록

| 데이터셋 | 파일 | 기간 | 설명 |
|----------|------|------|------|
| `longdata_002` | `1. Final_extraction_*.sas` | 2000-2018 | 세출/지출 예산편성현황 (정부안 vs 국회확정) |
| `longdata_004` | `2. Final_extraction_*.sas` | 2000-2018 | 세출/지출 결산현황 (불용액 포함) |
| `longdata_GDP` | `3. Final_extraction_*.sas` | - | GDP 데이터 |

### 주요 변수

#### 예산 분류 체계 (공통)

| 변수명 | 한글명 | 설명 |
|--------|--------|------|
| `FSCL_YY` | 회계연도 | 예산이 편성된 회계연도 |
| `OFFC_NM` | 소관명 | 예산을 관리하는 부처/기관 |
| `FSCL_NM` | 회계명 | 일반회계, 특별회계 등 |
| `ACCT_NM` | 계정명 | 세부 계정 분류 |
| `FLD_NM` | 분야명 | 예산 분야 (교육, 국방 등) |
| `SECT_NM` | 부문명 | 분야 내 세부 부문 |
| `PGM_NM` | 프로그램명 | 정책 프로그램 |
| `ACTV_NM` | 단위사업명 | 세부 단위사업 |

#### 예산편성현황 (longdata_002)

| 변수명 | 한글명 | 설명 |
|--------|--------|------|
| `Y_YY_MEDI_KCUR_AMT` | 금년도정부안 | 정부가 제출한 예산안 금액 (원) |
| `Y_YY_DFN_MEDI_KCUR_AMT` | 금년도국회확정 | 국회가 확정한 예산 금액 (원) |

#### 결산현황 (longdata_004) - 핵심 데이터

| 변수명 | 한글명 | 설명 |
|--------|--------|------|
| `ANEXP_BDGAMT_F` | 당초예산액 | 당초 편성된 세출예산액 |
| `ANEXP_BDGAMT_M` | 수정예산액 | 수정된 세출예산액 |
| `PREY_BFWAMT` | 전년도이월액 | 전년도에서 이월된 금액 |
| `ANEXP_BDG_CAMT` | 세출예산현액 | 실제 집행 가능한 예산 총액 |
| `EP_AMT` | 지출액 | 실제 지출된 금액 |
| `NEXT_YY_BFWAMT` | 다음년도이월액 | 다음 연도로 이월되는 금액 |
| **`DUSEAMT`** | **불용액** | **사용되지 않고 소멸되는 예산 (핵심 변수)** |

---

## 사용 방법

### 필수 환경

- **SAS 9.4** (Unicode 지원 버전)
  - API 응답의 한글 인코딩 처리를 위해 Unicode 지원 필수
- 필요 모듈: Base SAS, SAS/STAT

### API 키 발급

1. **열린재정 API**: https://openapi.openfiscaldata.go.kr 에서 회원가입 후 API 키 발급
2. **국가지표체계 API**: https://www.index.go.kr 에서 API 사용 신청

### 실행 방법

1. SAS 스크립트 내 경로 및 API 키 수정:
   ```sas
   %let dir=본인의_작업_디렉토리_경로;
   %let String01=발급받은_API_키;
   ```

2. 스크립트 실행 순서:
   ```
   1. Final_extraction_longdata_002.sas  → longdata_002.sas7bdat 생성
   2. Final_extraction_longdata_004.sas  → longdata_004.sas7bdat 생성
   3. Final_extraction_longdata_GDP.sas  → longdata_GDP.sas7bdat 생성
   ```

3. 생성된 SAS 데이터셋을 활용하여 분석 수행

---

## 인용

본 연구 또는 데이터를 사용하실 경우 아래와 같이 인용해 주세요.

### APA Style
```
김봉환, & 이권희. (2018). 불용액의 정권 연차별 변화와 국회 예산심의의 효율성.
```

### BibTeX
```bibtex
@article{kim2018unused,
  title={불용액의 정권 연차별 변화와 국회 예산심의의 효율성},
  author={김봉환 and 이권희},
  year={2018}
}
```

---

## 라이선스

이 프로젝트는 [MIT 라이선스](LICENSE) 하에 배포됩니다.

```
Copyright (c) 2018 LEE KWONHEE
```

---

## 연락처

- **Issues**: 버그 리포트 및 기능 요청은 [GitHub Issues](../../issues)를 이용해 주세요.
- **연구 관련 문의**: 논문 저자에게 직접 연락 바랍니다.
