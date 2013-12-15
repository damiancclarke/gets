*webuse set "http://users.ox.ac.uk/~ball3491/"
use gets_data
ds y* u* time, not

local xvars `r(varlist)' 
local lags l.dcoinc l.gd l.ggeq l.ggfeq l.ggfr l.gnpq l.gydq l.gpiq l.fmrra /*
*/ l.fmbase l.fm1dq l.fm2dq l.fsdj l.fyaaac l.lhc l.lhur l.mu l.mo 

gets y5 `xvars' `lags' l.y5 l2.y5 l3.y5 l4.y5, ts
