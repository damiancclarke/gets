{smcl}
{* 17 August 2013}{...}
{hline}
help for {hi:gets}
{hline}

{title:Title}

{p 8 20 2}
    {hi:gets} {hline 2} A General-to-Specific modelling algorithm

{title:Syntax}

{p 8 20 2}
{cmdab:gets} yvar xvars [if] [in] [weight] [{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Options}
{synopt :{cmd:vce(}{it:vcetype}{cmd:)}}determines the type of standard error reported in the estimated regression model, and allows standard errors that are robust to certain types of misspecification. vcetype may be robust, cluster clustvar, bootstrap, or jackknife.
{p_end}
{...}
{synopt :{cmd:xt(be|fe|re)}}specifies that the model is based on panel data. The user must specify whether they wish to estimate a random-effects (RE), fixed-effects (FE), or between-effects (BE) model. {help xtset} must be specified prior to using this option.
{p_end}
{...}
{synopt :{opt ts}}specifies that the model is based on time-series data. {help tsset} must be specified prior to using this option, and if specified, time-series operators may be used.
{p_end}
{...}
{synopt :{opt nodiag:nostic}}turns off the initial diagnostic tests for model misspecification. This should be used with caution.
{p_end}
{...}
{synopt :{cmdab:tlimit(}#{cmdab:)}}sets the critical t-value above which variables are considered as important in the terminal specification. By default this is a value of 1.96.
{p_end}
{...}
{synopt :{cmdab:num:search(}#{cmdab:)}}defines the number of search paths to follow in the model. If not specified, 5 search paths are followed. If a large dataset is used, fewer search paths may be preferred.
{p_end}
{...}
{synopt :{opt nopart:ition}}uses the full sample of data in all search paths, and does not engage in out of sample testing.
{p_end}
{...}
{synopt :{opt noserial}}requests that no serial correlation test is performed if panel data is being used. This option should only be specified with the {cmd:xt} option.
{p_end}
{...}
{synopt :{opt verbose}}requests full program output of each search path explored.
{p_end}
{...}
{synoptline}
{p2colreset}


{title:Description}

{p 6 6 2}
{hi:gets} is an algorithm for general-to-specific model prediction in Stata.  From a user-defined general unrestricted model (GUM), {cmd:gets} searches for the best possible final model among optimal subsets of the general model. The user passes the GUM to {cmd:gets} as a {it:yvar} and a group of {it:xvars} which are potentially important elements in the GUM.  The initial GUM is tested for congruence, and then multiple search paths are followed.  A potential final specification is reached when no further restrictions of the GUM remain congruent, and/or no further insignificant variables remain.

{p 6 6 2}
{hi:gets} allows the user to run the model prediction algorithm for a time-series, cross-sectional, or panel data models.  In the case of time series or panel data models, the user must specifiy the {cmd:ts} or {cmd:xt} option, and {help tsset} or {help xtset} the data respectively.  For panel data models, the user written xtserial command is used.  This option does not accept factor variable operators (for example i., c#). If factor variable operators are used with the {cmd:xt} option, {cmd:noserial} should be specified.

{p 6 6 2}
For further details regarding the functionality of {cmd:gets} or general-to-specific modelling in general, refer to {it: General to Specific Modelling in Stata} available at: {browse "https://sites.google.com/site/damiancclarke/research"}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Search the auto dataset for the significant predictors of car price{break}

{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. gets price mpg rep78 headroom trunk weight length foreign turn displace}{p_end}

    {hline}

{pstd}Predict variables for Hoover and Perez (1999)'s time-series model 5{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:. webset http://users.ox.ac.uk/~ball3491/}{p_end}
{phang2}{cmd:. webuse gets_data}{p_end}
{phang2}{cmd:. qui ds y* u* time, not}{p_end}
{phang2}{cmd:. local xvars `r(varlist)'}{p_end}
{phang2}{cmd:. local lags l.dcoinc l.gd l.ggeq l.ggfeq l.ggfr l.gnpq l.gydq l.gpiq l.fmrra l.fmbase l.fm1dq l.fm2dq l.fsdj l.fyaaac l.lhc l.lhur l.mu l.mo}{p_end}

{phang2}{cmd:. gets y5 `xvars ́ `lags ́ l.y6 l2.y6 l3.y6 l4.y6, ts}{p_end}

    {hline}


{marker results}{...}
{title:Saved results}

{pstd}
{cmd:gets} saves the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(fit)}}Bayesian Information Criterion of final specification {p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}List of variables from the final specification {p_end}
	

{marker references}{...}
{title:References}

{marker Clarke2013}{...}
{phang}
Clarke D.C., 2013.
{browse "https://sites.google.com/site/damiancclarke/research":{it:General to Specific Modelling in Stata}.}
Manuscript.

{marker Drukker2003}{...}
{phang}
Drukker D.M., 2003.
{it: Testing for serial correlation in linear panel-data models}
Stata Journal 3(2): 168-177.

{marker HooverPerez1999}{...}
{phang}
Hoover, K.D. and S.J. Perez., 1999.
{it: Data mining reconsidered: encompassing the general-to-specific approach to specification search}
Econometrics Journal 2: 167-191.
{p_end}


{title:Acknowledgements}

    {p 4 4 2} I thank Dr. Nicolas Van de Sijpe, Dr. Bent Nielsen and Marta Dormal for useful comments and 
		advice.  I also thank the Comisi{c o'}n Nacional de Investigaci{c o'}n Cient{c i'}fica
		y Tecnol{c o'}gica of the Government of Chile who supported my research during the writing of this
		program. 


{title:Also see}

{psee}
Online:  {manhelp regress_postestimation R} {manhelp regress_postestimation_time_series R}, {manhelp xtreg_postestimation XT}



{title:Author}

{pstd}
Damian C. Clarke, Department of Economics, University of Oxford. {browse "mailto:damian.clarke@economics.ox.ac.uk"}
{p_end}
