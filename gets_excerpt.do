*webuse set "http://users.ox.ac.uk/~ball3491/"
use Data/gets_data
qui ds y* u* time, not
local xvars `r(varlist)' 
local lags l.dcoinc l.gd l.ggeq l.ggfeq l.ggfr l.gnpq l.gydq l.gpiq l.fmrra l.fmbase l.fm1dq l.fm2dq l.fsdj l.fyaaac l.lhc l.lhur l.mu l.mo 
gets y5 `xvars' `lags' l.y6 l2.y6 l3.y6 l4.y6, ts
exit
