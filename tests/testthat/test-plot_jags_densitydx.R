
test_that(
  desc = "results are consistent with ggplot output",
  code = {
    library(runjags)
    set.seed(1)
    library(dplyr)
    strat1 <- serocalculator::typhoid_curves_nostrat_100 |>
      sim_case_data(n = 100) |>
      mutate(strat = "stratum 2")
    strat2 <- serocalculator::typhoid_curves_nostrat_100 |>
      sim_case_data(n = 100) |>
      mutate(strat = "stratum 1")

    dataset <- bind_rows(strat1, strat2)

    withr::with_seed(
      1,
      code = {
        results <- run_mod(
          data = dataset, #The data set input
          file_mod = fs::path_package("serodynamics", "extdata/model.jags"),
          nchain = 2, #Number of mcmc chains to run
          nadapt = 100, #Number of adaptations to run
          nburn = 100, #Number of unrecorded samples before sampling begins
          nmc = 100,
          niter = 100, #Number of iterations
          strat = "strat"
        )  |>
          suppressWarnings()
        results <- plot_jags_dens(results)
      }
    ) |>
      # Testing for any errors
      expect_no_error()
    # Test to ensure output is a list object
    expect_true(is.list(results))
    # Test to ensure that a piece of the list is a ggplot object
    expect_true(ggplot2::is.ggplot(results$`stratum 1`$HlyE_IgA))
  }
)
