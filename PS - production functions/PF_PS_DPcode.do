eststo clear
cd "~/github/grad-IO/PS - production functions"
use "/Users/aastha/github/grad-IO/PS - production functions/firms-cleaned.dta", clear
gen log_output = ln(routput)
gen log_capital = ln(rcapn)
gen log_labor = ln(worker)

egen mean_output = mean(log_output)
egen mean_labor = mean(log_labor)
egen mean_capital = mean(log_capital)

gen output_d = log_output - mean_output
gen labor_d = log_labor - mean_labor
gen capital_d = log_capital - mean_capital

reg output_d labor_d capital_d, robust nocons
eststo
estadd local fixed "no" , replace

***************************************************
* Question 2
***************************************************

xtset firm year
xtreg output_d capital_d labor_d,robust fe
eststo 
estadd local fixed "yes" , replace
*esttab, unstack scalars(r2) 
*esttab , cells(b) s(fixed N, label("fixed effects")) ar2 se
esttab, ar2 se cells("b(fmt(3))") s(fixed N, label("fixed effects") fmt(0)) label
estout using PF_PS.doc
* OLS estimation of production functions will yield biased parameter estimates because it does not account for the unobserved productivity shocks. A fixed-effect estimator would solve the simultaneity problem only if we are willing to assume that the unobserved, firm-specific productivity is time-invariant.

*****************************************************
* Question 3
******************************************************

gen y = ln(routputva)
gen l = ln(worker)
gen k = ln(rcapn)
gen i = ln(rinv)
gen m = ln(rmata)


 xtabond2 y L.y L(0/2).(l k), gmm(L.y) iv(L(0/1).k L.l)
eststo 
estout using PF_PS.doc, append
