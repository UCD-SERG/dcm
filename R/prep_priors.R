#' @title Prepare priors
#'The function is preparing a set of hyperparameters for a Bayesian model that characterizes antibody (or biomarker) responses. 
#'It assumes that each antigen-isotype is modeled by 5 parameters, which are transformed by taking their logarithm 
#'(with the fifth parameter adjusted as shape-1). These 5 parameters are named in the code as:
#'1. y0
#'2. y1,
#'3. t1,
#'4. alpha, and
#'5. shape 
#'
#' @param max_antigens [integer]: how many antigen-isotypes will be modeled
#'
#' @returns a [list] with elements:
#' n_params: Number of model parameters (log-transformed y0, y1, t1, alpha, shape-1).
#' mu.hyp: Hyperparameter means for the log-transformed model parameters.
#' prec.hyp: Diagonal precision matrix for the normal priors, setting the inverse variance for each parameter.
#' omega: Diagonal scale matrix used with the Wishart prior to shape the covariance structure.
#' wishdf: Degrees of freedom for the Wishart prior (set to 20).
#' prec.logy.hyp: Hyperparameters (e.g., shape and rate) for the precision (inverse variance) of the log-scale biomarkers.

#' @export
#'
#' @examples
#' prep_priors(max_antigens = 2)
prep_priors <- function(max_antigens) {
  # Model parameters
  n_params <- 5 # Assuming 5 model parameters [ y0, y1, t1, alpha, shape]
  mu_hyp <- array(NA, dim = c(max_antigens, n_params))
  prec_hyp <- array(NA, dim = c(max_antigens, n_params, n_params))
  omega <- array(NA, dim = c(max_antigens, n_params, n_params))
  wishdf <- rep(NA, max_antigens)
  prec_logy_hyp <- array(NA, dim = c(max_antigens, 2))

  # Fill parameter arrays
 # the parameters are log(c(y0,  y1,    t1,  alpha, shape-1))
  for (k.test in 1:max_antigens) {
    mu_hyp[k.test, ] <- c(1.0, 7.0, 1.0, -4.0, -1.0)
    prec_hyp[k.test, , ] <- diag(c(1.0, 0.00001, 1.0, 0.001, 1.0))
    omega[k.test, , ] <- diag(c(1.0, 50.0, 1.0, 10.0, 1.0))
    wishdf[k.test] <- 20
    prec_logy_hyp[k.test, ] <- c(4.0, 1.0)
  }
  
  
  # uninformative testing priors
  # for (k.test in 1:max_antigens) {
  #   mu_hyp[k.test, ] <- c(1.0, 1.0, 1.0, -4.0, -1.0)
  #   prec_hyp[k.test, , ] <- diag(c(0.00001, 1e-8, 0.00001, 0.00001, 0.00001))
  #   omega[k.test, , ] <- diag(c(1.0, 50.0, 1.0, 10.0, 1.0))
  #   wishdf[k.test] <- 20
  #   prec_logy_hyp[k.test, ] <- c(4.0, 1.0)
  # }

  # test for change

  # Return results as a list

  to_return <- list(
    "n_params" = n_params,
    "mu.hyp" = mu_hyp,
    "prec.hyp" = prec_hyp,
    "omega" = omega,
    "wishdf" = wishdf,
    "prec.logy.hyp" = prec_logy_hyp
  ) |>
    structure(class = c("curve_params_priors", "list"))

  return(to_return)
}
