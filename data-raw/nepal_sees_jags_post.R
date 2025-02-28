nepal_sees <- readr::read_csv(
                              here::here() |>
                                fs::path("/inst/extdata/
                                         SEES_Case_Nepal_ForSeroKinetics_
                                         02-13-2025.csv"))

dataset <- nepal_sees |>
  as_case_data(id_var = "person_id",
               biomarker_var = "antigen_iso",
               value_var = "result",
               time_in_days = "dayssincefeveronset")

nepal_sees_jags_post <- run_mod(
  data = dataset, # The data set input
  file_mod = fs::path_package("serodynamics", "extdata/model.jags"),
  nchain = 2, # Number of mcmc chains to run
  nadapt = 100, # Number of adaptations to run
  nburn = 100, # Number of unrecorded samples before sampling begins
  nmc = 500,
  niter = 1000, # Number of iterations
  strat = "bldculres" # Stratification
) 

usethis::use_data(nepal_sees_jags_post, overwrite = TRUE)
