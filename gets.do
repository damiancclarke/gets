********************************************************************************
*** (0) Define t-stat
********************************************************************************
local tlimit 1.5

local misspec "The underlying model may be misspecified."
local misspec2 "If you wish to ignore this warning and proceed, use the 'skip' option"

********************************************************************************
*** (0) generate data
********************************************************************************
clear all
set obs 10000
set more off

gen y=rnormal()

foreach num of numlist 1(1)20 {
	gen x`num'=rnormal()
}

foreach num of numlist 21(1)40 {
	gen x`num'=runiform()
}

********************************************************************************
*** (1) Test unrestricted model for misspecification
********************************************************************************
reg y x*
predict resid, residuals
mvtest normality resid
if r(p_dh)<0.05 {
	display as error "`misspec'"
	display as error " The Dornik-Hansen test rejects normality of errors."
	display as error "`misspec2'."
}
else if r(p_dh)>=0.05 {
	display "Dornik-Hansen test for normality of errors not rejected."
}

qui reg y x* 
estat hettest
if r(p)<0.05 {
	display as error "`misspec'"
	display as error " The Breusch-Pagan test rejects homoscedasticity of errors."
	display as error "`misspec2'."
}
else if r(p_dh)>=0.05 {
	display "Breusch-Pagan test for homoscedasticity of errors not rejected."
}


********************************************************************************
*** (2) run first regression
********************************************************************************
reg y x*
scalar low=1000 // here we set an arbitrary high # to compare to our low tstat

* now we run a loop to find the lowest tstat, updating each time
foreach var of varlist x1-x40 {
	scalar tstat`var' = abs(_b[`var']/_se[`var'])
	if tstat`var'<low {
		scalar low=tstat`var'
	}
}

foreach var of varlist x* {
	if tstat`var'==low dis in yellow "I dropped `var'"
	if tstat`var'==low drop `var'
}


********************************************************************************
*** (3) loop until significant
********************************************************************************
dis low
while low<`tlimit' {
	qui reg y x*
	scalar low=1000
	foreach var of varlist x* {
		scalar tstat`var' = abs(_b[`var']/_se[`var'])
		if tstat`var'<low {
			scalar low=tstat`var'
		}
	}

	foreach var of varlist x* {
		if tstat`var'==low dis in yellow "I dropped `var'"
		if tstat`var'==low drop `var'
	}
}
