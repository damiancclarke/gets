{smcl}
{* septiembre 22, 2013 @ 02:49:50}{...}
{hline}
help for {hi:gets}
{hline}

{title:Title}

{p 8 20 2}
    {hi:gets} {hline 2} A General-to-Specific modelling algorithm

{title:Syntax}

{p 8 20 2}
{cmdab:gets} {it:{help varnames:depvar}} {it:{help varnames:indepvars}} {ifin} [{it:{help weight}}] [{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Options}
{synopt :{cmd:vce(}{it:vcetype}{cmd:)}}determines the type of standard error (robust, cluster, bootstrap, or jackknife) reported in
the estimated regression model
{p_end}
{...}
{synopt :{cmd:xt(be|fe|re)}}specifies that the model is based on panel data, and whether a random-effects (RE), fixed-effects (FE),
or between-effects (BE) model should be estimated. {help xtset} must be specified prior to using this option.
{p_end}
{...}
{synopt :{opt ts}}specifies that the model is based on time-series data. {help tsset} must be specified prior to using this option.
{p_end}
{...}
{synopt :{opt nodiag:nostic}}turns off the initial diagnostic tests for model misspecification; this should be used with caution.
{p_end}
{...}
{synopt :{cmdab:tlimit(}#{cmdab:)}}sets the critical t-value above which variables are considered as important in the terminal specification
(default value is 1.96).
{p_end}
{...}
{synopt :{cmdab:num:search(}#{cmdab:)}}defines the number of search paths to follow in the model (5 by default), if a large dataset is used,
fewer search paths may be preferred.
{p_end}
{...}
{synopt :{opt nopart:ition}}uses the full sample of data in all search paths, and does not run out of sample testing.
{p_end}
{...}
{synopt :{opt noserial}}requests that no serial correlation test is performed if panel data is being used; this option should only
be specified with the {cmd:xt} option.
{p_end}
{...}
{synopt :{opt verbose}}requests full program output of each search path explored.
{p_end}
{...}
{synoptline}
{p2colreset}


{title:Description}

{p 6 6 2}
{hi:gets} is an algorithm for general-to-specific model prediction in Stata.  It is designed to search a large number of variables, and from these
select the 'best' model based on relevance and explanatory power. From a user-defined general unrestricted model (GUM), {cmd:gets} searches for the
best possible final model among optimal subsets of the general model as per the general-to-specific modelling process described in the econometric
literature. The user passes the GUM to {cmd:gets} as a {it:{help varnames:depvar}} and a group of {it:{help varnames:indepvars}} which are potentially
important elements in the GUM.  The initial GUM is tested for congruence, and then multiple search paths are followed.  A potential final specification
is reached when no further restrictions of the GUM remain congruent, and/or no further insignificant variables remain.

{p 6 6 2}
{hi:gets} allows the user to run the model prediction algorithm for time-series, cross-sectional, or panel data models.  In the case of time series
or panel data models, the user must specifiy the {cmd:ts} or {cmd:xt} option, and {help tsset} or {help xtset} the data respectively. For panel data
models, the user written xtserial command is used.  This option does not accept factor variable operators (for example #, c#). If factor variable
operators are used with the {cmd:xt} option, {cmd:noserial} should be specified.  The {hi:gets} command accepts {help fvvarlist:factor variables} of
the form # and c#, however does not accept the i{c 46} operator.  For users who wish to include a full set of dummy variables, these should be generated
and passed as {it:{help indepvars}} {c 150} perhaps via Stata's {help tab:tab, gen()} command.

{p 6 6 2}
For further details regarding the functionality of {cmd:gets} or general-to-specific modelling in general, refer to
{it: General to Specific Modelling in Stata} available at: {browse "https://sites.google.com/site/damiancclarke/research#TOC-Work-in-Progress":https://sites.google.com/site/damiancclarke/research}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Search the auto dataset for the significant predictors of car price{break}

{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. gets price mpg rep78 headroom trunk weight length foreign turn displace}{p_end}

    {hline}

{pstd}Search the National Longitudinal (panel) Survey for significant predictors of log wages{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse nlswork}{p_end}
{phang2}{cmd:. gets ln_w grade age c.age#c.age ttl_exp c.ttl_exp#c.ttl_exp tenure c.tenure#c.tenure 2.race not_smsa south msp nev_mar union, xt(fe)}{p_end}

    {hline}

{pstd}Predict variables for Hoover and Perez (1999)'s time-series model 5{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse set http://users.ox.ac.uk/~ball3491/}{p_end}
{phang2}{cmd:. webuse gets_data}{p_end}
{phang2}{cmd:. qui ds y* u* time, not}{p_end}
{phang2}{cmd:. local xvars `r(varlist)'}{p_end}
{phang2}{cmd:. local lags l.dcoinc l.gd l.ggeq l.ggfeq l.ggfr l.gnpq l.gydq l.gpiq l.fmrra l.fmbase l.fm1dq l.fm2dq l.fsdj l.fyaaac l.lhc l.lhur l.mu l.mo}{p_end}

{phang2}{cmd:. gets y5 `xvars' `lags' l.y6 l2.y6 l3.y6 l4.y6, ts}{p_end}

    {hline}


{marker results}{...}
{title:Saved results}

{pstd}
{cmd:gets} saves the following in {cmd:e()}:

{synoptset 10 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(fit)}}Bayesian Information Criterion of final specification {p_end}

{synoptset 10 tabbed}{...}
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
{browse "http://www.stata-journal.com/article.html?article=st0039":{it: Testing for serial correlation in linear panel-data models}},
Stata Journal 3(2): 168-177.

{marker HooverPerez1999}{...}
{phang}
Hoover, K.D. and S.J. Perez., 1999.
{browse "http://ideas.repec.org/p/fth/caldec/97-27.html":{it: Data mining reconsidered: encompassing the general-to-specific approach to specification search}},
Econometrics Journal 2: 167-191.
{p_end}


{title:Acknowledgements}

    {p 4 4 2} I thank Marta Dormal, Dr. Bent Nielsen,  Dr. Nicolas Van de Sijpe and George Vega for useful
		comments and advice.  I also thank the Comisi{c o'}n Nacional de Investigaci{c o'}n Cient{c i'}fica
		y Tecnol{c o'}gica of the Government of Chile who supported my research during the writing of this
		program. 


{title:Also see}

{psee}
Online:  {manhelp regress_postestimation R} {manhelp regress_postestimation_time_series R}, {manhelp xtreg_postestimation XT}



{title:Author}

{pstd}
Damian C. Clarke, Department of Economics, University of Oxford. {browse "mailto:damian.clarke@economics.ox.ac.uk":damian.clarke@economics.ox.ac.uk}
{p_end}
