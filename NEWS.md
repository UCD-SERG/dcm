# serodynamics (development version)

* Initial CRAN submission.

## New features

* Fixing SEES data and added jags_post for SEES (#63)
* Added SEES data set data folder and documentation (#41)
* `as_case_data()` now creates column `visit_num` (#47, #50)
* Added `postprocess_jags_output()` to API (#33)
* Added `initsfunction()` to API (#37)
* Added participant IDs as names to `nsmpl` element of `prep_data()` output (#34)
* Added `initsfunction()` to API (#37)
* Added `as_case_data()` to API (#31)
* Added `prep_priors()` to API (#30)
* Added `autoplot()` method for `case_data` objects (#28)
* Added examples for `sim_pop_data()`, `autoplot.case_data()` (#18)
* Added attributes as a return to the run_mod function (#24)
* exported `run_mod()` function (#22)
* Function that runs jags with option of stratification included. (#14)
* Changed package name to serodynamics. (#19, #20)

## Bug fixes

None yet

## Developer-facing changes

* Added snapshot test for `run_mod()`
* Clarified `prep_data()` internals using `{dplyr}` (#34)
* Removed ".R" suffix from jags model files 
to prevent them from getting linted as R files (#34)
* Added `dobson.Rmd` minimal vignette (#36)
* Overall cleaning to get checks working (#28)
* Added units tests for `prep_data()`, `sim_case_data()` (#18)
* Added various GitHub Actions (#10, #15, #18)

# serodynamics 0.0.0

Started development.
