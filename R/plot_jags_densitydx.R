
#' @title Density Plot Diagnostics
#' @author Sam Schildhauer
#' @description
#'  plot_jags_dens() takes a [list] output from [serodynamics::run_mod()]
#'  to create density plots for each chain run in the mcmc estimation.
#'  Defaults will produce every combination of antigen/antibody, parameters,
#'  and stratifications, unless otherwise specified.
#'  Antigen/antibody combinations and stratifications will vary by analysis.
#'  The antibody dynamic curve includes the following parameters:
#'  - y0 = baseline antibody concentration
#'  - y1 = peak antibody concentration
#'  - t1 = time to peak
#'  - r = shape parameter
#'  - alpha = decay rate
#' @param data A [base::list()] outputted from run_mod().
#' @param iso Specify [base::character()] string to produce plots of only a
#' specific antigen/antibody combination, entered with quotes. Default outputs
#' all antigen/antibody combinations.
#' @param param Specify [base::character()] string to produce plots of only a
#' specific parameter, entered with quotes. Options include:
#' - `alpha` = posterior estimate of decay rate
#' - `r` = posterior estimate of shape parameter
#' - `t1` = posterior estimate of time to peak
#' - `y0` = posterior estimate of baseline antibody concentration
#' - `y1` = posterior estimate of peak antibody concentration
#' @param strat Specify [base::character()] string to produce plots of specific
#' stratification entered in quotes.
#' @return A [base::list()] of [ggplot2::ggplot()] objects producing density
#' plots for all the specified input.
#' @export
#' @examples
#' if (!is.element(runjags::findjags(), c("", NULL))) {
#'   library(runjags)
#'   library(ggmcmc)
#'   set.seed(1)
#'   library(dplyr)
#'   strat1 <- serocalculator::typhoid_curves_nostrat_100 |>
#'     sim_case_data(n = 100) |>
#'     mutate(strat = "stratum 2")
#'   strat2 <- serocalculator::typhoid_curves_nostrat_100 |>
#'     sim_case_data(n = 100) |>
#'     mutate(strat = "stratum 1")
#'
#'   Dataset <- bind_rows(strat1, strat2)
#'
#'   jags_out <- run_mod(
#'     data = Dataset, # The data set input
#'     file_mod = fs::path_package("serodynamics", "extdata/model.jags"),
#'     nchain = 2, # Number of mcmc chains to run
#'     nadapt = 100, # Number of adaptations to run
#'     nburn = 100, # Number of unrecorded samples before sampling begins
#'     nmc = 500,
#'     niter = 1000, # Number of iterations
#'     strat = "strat"
#'   ) # Variable to be stratified
#' plot_jags_dens(
#'     data = jags_out, #A [serodynamics::run_mod()] [base::list()] output.
#'     iso = "HlyE_IgA", #A [base::character()] string specifying
#'     #nantigen/antibody of interest.
#'     param = "alpha",  #A [base::character()] string specifying parameter of
#'     # interest.
#'     strat = "stratum 1")  #A [base::character()] string specifying
#'     # stratification of interest.
#'     }

plot_jags_dens <- function(data,
                           iso = unique(data$curve_params$Iso_type),
                           param = unique(data$curve_params$Parameter_sub),
                           strat = unique(data$curve_params$Stratification)) {
  visualize_jags <- data[["curve_params"]]
  attributes_jags <- data[["attributes"]]

  dens_strat_list <- list()
  for (i in strat) {

    visualize_jags_sub <- visualize_jags |>
      dplyr::filter(.data$Stratification == i)

    # Creating open list to store ggplots
    density_out <- list()
    # Looping through the isos
    for (j in iso) {
      visualize_jags_plot <- visualize_jags_sub |>
        dplyr::filter(.data$Iso_type == j)

      # Will not loop through parameters, as we may want each to show on the
      # same plot by default.
      visualize_jags_plot <- visualize_jags_plot |>
        dplyr::filter(.data$Parameter_sub %in% param)

      visualize_jags_plot <- visualize_jags_plot |>
        # Changing parameter name to reflect the input
        dplyr::mutate(Parameter = paste0("iso = ", j, ", parameter = ",
                                         .data$Parameter_sub, ", strat = ",
                                         i),
                      value = log(.data$value))
      # Assigning attributes, which are needed to run ggs_density
      attributes(visualize_jags_plot) <- c(attributes(visualize_jags_plot),
                                           attributes_jags)
      # Creating density plot
      densplot <- ggmcmc::ggs_density(visualize_jags_plot) +
        ggplot2::theme_bw() +
        ggplot2::labs(x = "log(value)")
      density_out[[j]] <- densplot
    }
    dens_strat_list[[i]] <- density_out
  }
  dens_strat_list
}
