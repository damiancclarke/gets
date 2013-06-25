*! gets: General to specific algorithm for model selection
*! Version 1.1.0June 25, 2013 @ 11:33:48
*! Author: Damian C. Clarke
*! Department of Economics
*! The University of Oxford
*! damian.clarke@economics.ox.ac.uk

cap program drop gets
program gets, eclass
	syntax varlist
	
	tempvar resid
	preserve
	keep `varlist'
	****************************************************************************
	*** (1) Test unrestricted model for misspecification
	****************************************************************************
	tokenize `varlist'
	local y `1'
	macro shift
	local x `*'
	
	qui reg `y' `x'
	predict `resid', residuals
	qui mvtest normality `resid'
   local misspec "Respecify using nodiagnostic if you wish to continue without"
   local misspec2 "specification tests. This option should be used with caution"
	if r(p_dh)<0.05 {
		display as error " The Doornik-Hansen test rejects normality of errors."
		display as error "`misspec'"
		display as error "`misspec2'."
	}
	else if r(p_dh)>=0.05 {
		display "Dornik-Hansen test for normality of errors not rejected."
	}
	
	drop `resid'
	
	qui reg `y' `x'
	qui estat hettest
	if r(p)<0.05 {
		display as error " The Breusch-Pagan test rejects homoscedasticity of errors."
		display as error "`misspec'"
		display as error "`misspec2'."
	}
	else if r(p)>=0.05 {
		display "Breusch-Pagan test for homoscedasticity of errors not rejected."
	}	

	qui reg `y' `x'
   qui estat ovtest
	if r(p)<0.05 {
		display as error " The Breusch-Pagan test rejects homoscedasticity of errors."
		display as error "`misspec'"
		display as error "`misspec2'."
	}
	else if r(p)>=0.05 {
		display "RESET test for misspecification not rejected.  Continuing analysis."
	}	

	****************************************************************************
	*** (2) Run regression for underlying model
	****************************************************************************		
	foreach searchpath of numlist 1(1)5 {
		qui reg `y' `x'
      global Fbase=e(F)
      qui dis "the base F is" $Fbase

	****************************************************************************
	*** (3) Sort by t-stat, remove least explanatory variable from varlist
	****************************************************************************
		mata: tsort(st_matrix("e(b)"), st_matrix("e(V)"), `searchpath')
		local num e(var)
		local t = e(t)
		
		tokenize `varlist'  // find lowest t-value variable
		macro shift
		dis "```num'''"
		qui dis "The lowest t-value is " in green e(t) in yellow " and is variable " in green "```num'''"
		global remove ```num'''
		
		tokenize `varlist'  // remove lowest t-value variable
		macro shift
		qui ds `y' $remove, not
		local newvarlist `r(varlist)'


		qui reg `y' `newvarlist'
      if e(F)>$Fbase {
         qui dis "New F improves on GUM.  Keep going"
      }
      else if e(F)<$Fbase {
         dis as error "This model does not improve the F-statistic."
         dis as error "respecify using the option nodiagnostic if you wish to continue with this search path."
         dis as error "Use nodiagnostic with precaution."
         exit 498
         }
		mata: tsort(st_matrix("e(b)"), st_matrix("e(V)"), 1)
		local num e(var)
		local t = e(t)

		****************************************************************************
		*** (4) Loop until all variables are significant
		****************************************************************************
		while `t'<1.96 {
			tokenize `newvarlist'  // find lowest t-value variable
			qui dis "```num'''"
			qui dis "The lowest t-value is " in green e(t) in yellow " and is variable " in green "```num'''"
			
			global remove ```num''' $remove
			qui ds `y' $remove, not
			local newvarlist `r(varlist)'
			
			qui reg `y' `newvarlist'
         if e(F)>$Fbase {
            qui dis "New F improves on GUM.  Keep going"
         }
         else if e(F)<$Fbase {
            dis as error "This model does not improve the F-statistic."
            dis as error "respecify using the option, nodiagnostic if you wish to /*
            */ continue with this search path."
            dis as error "Use nodiagnostic with precaution."
            exit 498
         }
			cap mata: tsort(st_matrix("e(b)"), st_matrix("e(V)"), 1)
			if _rc==3202 {
				dis as error "No variables are found to be significant at given significance level"
				exit 3202
			}
			local num e(var)
			local t = e(t)
			qui dis `t'
		}
		
		dis in green "Results for search path `searchpath':"
		dis in yellow "removed variables are: " in green "$remove"
		dis in yellow "remaining variables are: " in green "`newvarlist'"

		qui reg `y' `newvarlist'

      ****************************************************************************
		*** (5) Determine model fit
		****************************************************************************
      global BICbest=1000000
      global BICbestname Model
      qui estat ic
      matrix BIC=r(S)
      local BIC=BIC[1,6]
      if `BIC'<$BICbest {
         global BICbest `BIC'
         global BICbestname Model`searchpath'
         global modelvars `newvarlist'
      }
   }	
	restore
   dis $BICbest
   dis "$BICbestname"
   dis "$modelvars"
end

********************************************************************************
*** (X) Mata code for selecting irrelevant variables
********************************************************************************
cap mata: mata drop tsort()
mata:
void tsort(real matrix B, real matrix V, real scalar num) {
	real vector se
	real vector t
	real vector tsort
	real vector tnum	
	real matrix X
	real scalar dimn
	real vector a
	
	se = diagonal(V)
	se = sqrt(se)
	t=abs(B':/se)
	dimn = length(t)
	if (dimn==1) {
		_error(3202)
	}
	
	t=t[|1\ dimn-1|]
	a = 1::dimn-1
	X = (t, a)
	tsort = sort(X, 1)
	tnum = tsort[num,1]
	tvar = tsort[num,2]
	st_numscalar("e(t)", tnum)
	st_numscalar("e(var)", tvar)
}
end
