
options(scipen = 999)
library(runjags)
    
    dataset <- serodynamics_example(
      "SEES_Case_Nepal_ForSeroKinetics_02-13-2025.csv"
    ) |>
      readr::read_csv() |>
      dplyr::mutate(
        .by = person_id,
        visit_num = dplyr::row_number()
      ) |>
      as_case_data(
        id_var = "person_id",
        biomarker_var = "antigen_iso",
        value_var = "result",
        time_in_days = "dayssincefeveronset"
      )
    
    results <- run_mod(
      data = dataset, # The data set input
      file_mod = serodynamics_example("model.jags"),
      nchain = 2, # Number of mcmc chains to run
      nadapt = 100, # Number of adaptations to run
      nburn = 100, # Number of unrecorded samples before sampling begins
      nmc = 100,
      niter = 1000, # Number of iterations
      strat = NA # Variable to be stratified
    ) |>
      suppressWarnings() |>
      magrittr::use_series("curve_params")


test.1 <- results %>% group_by(Iso_type, Parameter_sub) %>% summarise(mean = mean(value), sd = sd(value))

wide_predpar_df <- results %>%
  select(-Parameter) %>%
  rename(parameter = Parameter_sub,
         antigen_iso = Iso_type) %>%
  pivot_wider(names_from = "parameter", values_from="value") %>%
  rowwise() %>%
  #mutate(y1 = y0+y1) %>%
  droplevels() %>%
  ungroup() %>%
  rename(r = shape)


autoplot(serocalculator::as_curve_params(wide_predpar_df))

