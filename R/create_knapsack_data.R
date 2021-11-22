#' Create knapsack
#'
#' @param n is the number of samples
#' @param seed is defines which seed to use. Default value is 42 with some extra specifications of kind.
#'
#' @return returns a data.frame of generated knapsack data. The data has 2 columns and n rows.
#' @importFrom stats runif
#' @export

create_knapsack_data <- function(n, seed = set.seed(42, kind = "Mersenne-Twister", normal.kind = "Inversion")){
  suppressWarnings(RNGversion(min(as.character(getRversion()),"3.5.3"))) #version needs to be changed to use testing
  seed
  knapsack_objects <- data.frame(w=sample(1:4000, size = n, replace = TRUE), v=runif(n = n, 0, 10000))
  return(knapsack_objects)
}
