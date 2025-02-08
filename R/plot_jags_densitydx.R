
#' @title Density Plot Diagnostics
#' @author Sam Schildhauer
#' @description
#'  plot_jags_dens() takes a [list] output from the [serodynamics::run_mod()]
#'  function to create density plots for each chain run in the mcmc estimation.
#'  Defaults will produce every combination of antigen/antibody, parameters,
#'  and stratifications, unless otherwise specified.
#'  Antigen/antibody combinations and stratifications will vary by analysis.
#'  The antibody dynamic curve includes the following parameters:
#'  - y0 = baseline antibody concentration
#'  - y1 = peak antibody concentration
#'  - t1 = time to peak
#'  - r = shape parameter
#'  - alpha = decay rate
#' @param name description
#' @param data A [base::list()] outputted from run_mod().
#' @param iso Specify [string] to produce plots of only a specific
#' antigen/antibody combination, entered with quotes. Default outputs all
#' antigen/antibody combinations.
#' @param param Specify [string] to produce plots of only a specific parameter,
#' entered with quotes. Options include:
#' - `alpha` = posterior estimate of decay rate
#' - `r` = posterior estimate of shape parameter
#' - `t1` = posterior estimate of time to peak
#' - `y0` = posterior estimate of baseline antibody concentration
#' - `y1` = posterior estimate of peak antibody concentration
#' @param strat Specify [string] to produce plots of specific stratification
#' entered in quotes.
#' @return A [list] of [] objects producing density plots for all the specified
#' input.
#' @export
#' @examples
#' plot_jags_dens(
#'     data = [list], #A [serodynamics::run_mod()] [list] output
#'     iso = "hlya_IgG", #A [string] specifying antigen/antibody of interest.
#'     Default are all antigen/antibody combinations.
#'     param = "alpha",  #A [string] specifying parameter of interest. Default
#'     is all parameters.
#'     strat = 4),  #A [string] specifying stratification of interest. Default
#'     is all stratifications.

plot_jags_dens <- function(data,
                           iso = unique(visualize_jags_sub$Iso_type),
                           param = unique(visualize_jags_sub$Parameter_sub),
                           strat = NA) {
  visualize_jags <- data[["curve_params"]]
  attributes_jags <- data[["attributes"]]

  if (is.na(strat)) {
    stratification <- c("No stratification")
  } else {
    stratification <- unique(visualize_jags$Stratification)
  }

  dens_strat_list <- list()
  for (i in stratification) {

    if (i == "No stratification") {
      visualize_jags_sub <- visualize_jags
    } else {
      visualize_jags_sub <- visualize_jags |>
        dplyr::filter(.data$Stratification == i)
    }

    # Creating open list to store ggplots
    density_out <- list()
    # Looping through the isos
    for (j in iso) {
      visualize_jags_plot <- visualize_jags_sub |>
        dplyr::filter(.data$Iso_type == j)

      # Will not loop through parameters, as we may want each to show on the
      # same plot by default.
      visualize_jags_plot <- visualize_jags_plot |>
        dplry::filter(.data$Parameter_sub %in% param)

      visualize_jags_plot <- visualize_jags_plot |>
        # Changing parameter name to reflect the input
        dplyr::mutate(Parameter = paste0("iso = ", j, ", parameter = ",
                                         .data$Parameter_sub))
      # Assigning attributes, which are needed to run ggs_density
      attributes(visualize_jags_plot) <- c(attributes(visualize_jags_plot),
                                           attributes_jags)
      # Creating density plot
      densplot <- ggmcmc::ggs_density(visualize_jags_plot)
      density_out[[j]] <- densplot
    }
    dens_strat_list[[i]] <- density_out
  }
  dens_strat_list
}
