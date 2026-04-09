/******************************************************************
Filename: 			03_analysis_models.do
Date last edited:	04/08/2026
Date created:		06/08/2017

Purpose:
Runs summary statistics and main regression models for analysis of
undiagnosed diabetes disparities using an already-prepared NHANES
analysis sample.

Inputs:
- analysis_sample.dta (prepared analytic file; not included in repo)

Outputs:
- regression tables in /output

Requirements:
- Stata
- outreg2 package
- Survey design variables and prepared covariates already constructed

Notes:
This repository contains analysis code for selected sections of a working paper. 
This code assumes an already-prepared analytic dataset.  Data cleaning and
harmonization scripts are not included in this public version. 
The original working file, ihea.do, was created on 06/08/2017, and 
includes detailed notes on previous edits. 

******************************************************************/


/*****************************************************************/

* Set project paths for output files.
global projroot "."
global outdir "$projroot/output"

/*****************************************************************/
* Generate subpop variable.
gen dexn13 = 1 if datayear<2013 & ridageyr>20 & preg==0 & ridstatr==2 & lbxgh<. & dmarried<. & dnoins12<. & immig<. & dempl<. & dp125<. & dmlang==0 & bmi30<. & cvdabd<. & dbps140<. & lbxtc<.
*Set Survey Weights.
svyset sdmvpsu [pw=wtmec2yr], psu(sdmvpsu) strata(sdmvstra)
/*****************************************************************/

/*****************************************************************/

* Descriptive Statistics
svy, subpop(all1 if (dexn13==1 & dndm==0))vce(linearized): mean dnoins12 dnoinsnow, over(dnonwh)
svy, subpop(all1 if (dexn13==1 & dndm==1))vce(linearized): mean dnoins12 dnoinsnow, over(dnonwh)
svy, subpop(all1 if (dexn13==1 & dndm==1 & dnukdm==0))vce(linearized): mean dnoins12 dnoinsnow, over(dnonwh)
svy, subpop(all1 if (dexn13==1 & dndm==1 & dnukdm==1))vce(linearized): mean dnoins12 dnoinsnow, over(dnonwh)

*
* Summary Stats by Insurance Status 
svy, subpop(all1 if (dexn13==1 & dndm==1 & dnoins12==0))vce(linearized): mean ridageyr male rwhite rblack rmexam rothis rother immig dnoeng dmarried dnocoll dp125 dempl dnukdm
svy, subpop(all1 if (dexn13==1 & dndm==1 & dnoins12==1))vce(linearized): mean ridageyr male rwhite rblack rmexam rothis rother immig dnoeng dmarried dnocoll dp125 dempl dnukdm

foreach var of varlist male rwhite rblack rmexam rothis rother immig dnoeng dmarried dnocoll dp125 dempl dnukdm {
tab `var' dnoins12 if dexn13==1 & dndm==1, chi2
}
ttest ridageyr if dexn13==1 & dndm==1, by(dnoins12)

* Summary statistics by analytic race/ethnicity grouping used in specification
svy, subpop(all1 if (dexn13==1 & dndm==1 & rwhite==0))vce(linearized): mean ridageyr male rwhite rblack rmexam rothis rother immig dnoeng dmarried dnocoll dp125 dempl dnoins12 dnukdm
svy, subpop(all1 if (dexn13==1 & dndm==1 & rwhite==1))vce(linearized): mean ridageyr male rwhite rblack rmexam rothis rother immig dnoeng dmarried dnocoll dp125 dempl dnoins12 dnukdm

foreach var of varlist male rwhite rblack rmexam rothis rother immig dnoeng dmarried dnocoll dp125 dempl dnoins12 dnukdm {
tab `var' rwhite if dexn13==1 & dndm==1, chi2
}
ttest ridageyr if dexn13==1 & dndm==1, by(rwhite)



/*****************************************************************/
* Model Building - OLS and Logistic Odds Ratios Side-by-Side Comparison

* No Control Variables, OLS
* Main specification:
* Interaction between insurance status and NHANES analytic race/ethnicity grouping to assess differences in diagnosis gaps across subpopulations
svy, subpop(all1 if (dexn13==1 & dndm==1 )) vce(linearized): reg dnukdm dnonwh##dnoins12
outreg2 using "$outdir/temp", excel replace cttop(OLS, no controls) stats(coef ci) label

* Full Set of Control Variables
svy, subpop(all1 if (dexn13==1 & dndm==1 )) vce(linearized): reg dnukdm dnonwh##dnoins12 dnoeng immig male ridageyr ridagesq dmarried dnocoll dp125  dempl i.year
outreg2 using "$outdir/temp", excel cttop(OLS, full model) stats(coef ci) label

* No Control Variables, logistic 
svy, subpop(all1 if (dexn13==1 & dndm==1 )) vce(linearized): logistic dnukdm dnonwh##dnoins12
outreg2 using "$outdir/temp", excel eform cttop(logistic, no controls) stats(coef ci) label

* Full Set of Control Variables, logistic 
svy, subpop(all1 if (dexn13==1 & dndm==1 )) vce(linearized): logistic dnukdm dnonwh##dnoins12 dnoeng immig male ridageyr ridagesq dmarried dnocoll dp125  dempl i.year
outreg2 using "$outdir/temp", excel  eform cttop(logistic, full model) stats(coef ci) label


/*****************************************************************/
* Selected model extensions
* Full Model, adding "no place of usual care" as a control variable

* Full model, sample of adults <65 only
svy, subpop(all1 if (dexn13==1 & dndm==1 & ridageyr<65)) vce(linearized): logistic dnukdm dnonwh##dnoins12 dnoeng immig male ridageyr ridagesq dmarried dnocoll dp125 dempl i.year
outreg2 using "$outdir/temp", excel eform replace cttop(full model) stats(coef ci) label

* Same outcome, alternate predictors of interest: No Usual Source of Care OR Usual Care is Emergency Room
svy, subpop(all1 if (dexn13==1 & dndm==1 )) vce(linearized): logistic dnukdm dnonwh##dnoucare2 dnoeng immig male ridageyr ridagesq dmarried dnocoll dp125 dempl i.year
outreg2 using "$outdir/temp", excel eform cttop(ER or No Usual Source of Care) stats(coef ci) label


/*****************************************************************/
*				

