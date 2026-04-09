Project Title:

Undiagnosed Diabetes and Access to Care: NHANES Analysis (Code Sample)

Overview:

This repository contains a sample of analysis code from a research project examining disparities in undiagnosed diabetes using data from the National Health and Nutrition Examination Survey (NHANES).

The code demonstrates the construction of an analytic sample, use of complex survey weights, and estimation of regression models assessing relationships between insurance coverage, access to care, and diagnosis outcomes.

This repository is intended as a methods and coding sample.

Contents:
03_analysis_models.do
Main analysis file, including:
Sample restrictions and analytic subpopulation construction
Survey design specification (svyset)
Descriptive statistics
Regression models (OLS and logistic)
Selected model extensions
/output/
Directory for regression tables generated via outreg2

Data:

The analytic dataset (analysis_sample.dta) is not included.

The original project used publicly available NHANES data. Data cleaning, harmonization, and variable construction scripts are not included in this repository.

Requirements:
Stata
outreg2 package (for exporting regression results)

Notes on Variable Definitions:

This code preserves variable names and category definitions from the original analysis. Some variables reflect analytic groupings constructed for that project (e.g., demographic and access-to-care measures).

These definitions should be interpreted as part of the original empirical specification rather than as normative or current best-practice measurement choices.

Purpose of This Repository:

This repository is designed to demonstrate:

Experience working with complex survey data (NHANES)
Applied econometric modeling (OLS and logistic regression)
Use of interaction terms in policy-relevant contexts
Reproducible workflow structure in Stata

Author: Ayesha Ali
Applied Microeconomics — Health Policy