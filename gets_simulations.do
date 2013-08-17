/* gets_simulations              damiancclarke             yyyy-mm-dd:2013-08-16
*---|----1----|----2----|----3----|----4----|----5----|----6----|----7----|----8

gets_simulations.do tests the program gets.ado using models specified in the
article "Data Mining Reconsidered..." by Hoover and Perez (1999).  In this file
we generate each of the 9 models from Hoover and Perez, and then test whether
gets.ado recovers the true model.  We simulate each model 1000 times in order
to compare results from gets.ado with the benchmark process described in
Hoover and Perez's table 7.

This was simulated on August 17th, 2013, and uses v 1.2.0 of gets.ado.  Future
simulations will get identical results (if using the same seed) as long as the
same version of gets.ado is used.
*/


clear all
version 11.2
cap log close
set more off
set mem 2000m

*******************************************************************************
*** (0) Globals and Locals
*******************************************************************************
global Base "~/computacion/StataPrograms/gets"
global Data "~/computacion/StataPrograms/gets/Data"
global Log "~/computacion/StataPrograms/gets/Log"
global Results "~/computacion/StataPrograms/gets/Results"


local xvars dcoinc gd ggeq ggfeq ggfr gnpq gydq gpiq fmrra fmbase fm1dq fm2dq /*
*/ fsdj fyaaac lhc lhur mu mo
local lxvars l.dcoinc l.gd l.ggeq l.ggfeq l.ggfr l.gnpq l.gydq l.gpiq l.fmrra /*
*/ l.fmbase l.fm1dq l.fm2dq l.fsdj l.fyaaac l.lhc l.lhur l.mu l.mo 

local yvars y1 y2p y3 y4 y5 y6 y7p y8p y9p
local correct1 
local correct2 L.y2
local correct3 L.y3 L2.y3
local correct4 fm1dq
local correct5 ggeq
local correct6 ggeq fm1dq
local correct7 fm1dq L.fm1dq L.y7
local correct8 ggeq L.ggeq L.y8
local correct9 fm1dq L.fm1dq ggeq L.ggeq L.y9

local tl=invttail(130, 0.01/2)
dis "`tl'"

cap mkdir $Log
cap mkdir $Results

cap log close
log using "$Log/gets_simulations.txt", text replace

file open result using "$Results/gets_sim_results.txt", write replace
file write result "model numvars correctvars vars" _n
*******************************************************************************
*** (1) Import data
*******************************************************************************
use "$Data/HP1999"
gen time=_n
tsset time

*******************************************************************************
*** (2) Create additional variables and models
*******************************************************************************
drop in 1/6

set seed 1001
foreach sim of numlist 1(1)1000 {
	dis "`sim'"

	gen u=rnormal()
	gen ustar=0.75*l.u+u*sqrt(7/4)

	gen y1=130*u
	gen y2=130*ustar
	gen y2p=0.75*l.y2+85.99*u
	gen y3=0.00172*u in 1
	replace y3=0.395*l.y3+0.00172*u in 2
	replace y3=0.395*l.y3+0.3995*l2.y3+0.00172*u in 3/134
	gen y4=1.33*fm1dq +9.73*u
	gen y5=-0.046*ggeq + 0.11*u
	gen y6=0.67*fm1dq-0.023*ggeq+4.92*u
	gen y6A=0.67*fm1dq-0.32*ggeq+4.92*u
	gen y6B=0.67*fm1dq-0.65*ggeq+4.92*u
	gen y7p=1.33*fm1dq+9.73*ustar
	gen y7=0.75*l.y7+1.33*fm1dq-0.9975*l.fm1dq+6.73*u
	gen y8=-0.046*ggeq+0.11*ustar
	gen y8p=0.75*l.y8-0.046*ggeq+0.00345*l.ggeq+0.073*u
	gen y9=0.67*fm1dq-0.023*ggeq+4.92*ustar
	gen y9p=0.75*l.y9-0.023*ggeq+0.01725*l.ggeq+0.067*fm1dq-0.5025*l.fm1dq+3.25*u


*******************************************************************************
*** (2) Test models, determine gauge and potency
*******************************************************************************
	foreach n of numlist 1(1)9 {
		gets y`n' l.y`n' l2.y`n' l3.y`n' l4.y`n' `xvars' `lxvars', ts tlimit(`tl')
		fvunab numvars: `e(gets)'
		local included `: word count `numvars''
		local correct=0
		foreach var1 of local correct`n' {
			foreach var2 of local numvars {
				if `"`var1'"'==`"`var2'"' local ++correct
			}
		}
		local tstatreturn		
		foreach var of local numvars {
			local tstatind=_b[`var']/_se[`var']
			local tstatreturn "`tstatreturn' `tstatind'"
		}
		file write result "`n' `included' `correct' `numvars'`tstatreturn'" _n
	}
	drop u ustar y*
}


cap log close
file close result
