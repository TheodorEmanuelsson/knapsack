#' Solving the knapsack problem through dynamic programming
#'
#' @param x is a data.frame containing knapsack data. It has two columns: v with values and w with weights.
#' @param W is a numeric scalar which defined the maximum possible weight knapsack can handle before breaking.
#'
#' @return a list object containing the best bag value given the weight and the elements that make up the best bag.
#' 
#' @export

knapsack_dynamic <- function(x, W){
  stopifnot(is.data.frame(x) == TRUE, colnames(x) == c("w","v"),is.integer(x[,1]) == TRUE, 
            is.numeric(W) == TRUE, length(W) == 1, W > 0)
  
  n <- nrow(x)
  
  # Create sub-problems matrix with 0 everywhere to skip assigning zeros
  m <- matrix(0, nrow = n, ncol = W)
  #elements <- vector()
  for (i in 2:n) { # We must start from two because we cant use negative indexing
    for (j in 1:W) {
      if(x$w[i] > j){
        m[i,j] <- m[i-1,j]
      }else{
        m[i,j] <- max(m[i-1,j], m[i-1, j-x$w[i]] + x$v[i]) 
      }         
    }
  }
  value <- round(m[n,W])
  
  # to find the elements we need to go some steps back
  dp <- m
  w <- W
  i <- n
  elements=vector()
  repeat{
    if(any(dp[i,w] - dp[i-1,w - x$w[i]] == x$v[i])){
      elements <- append(elements, i)
      i = i-1
      w = w - x$w[i+1]
    }else{
      i = i-1 
    }
    if(i == 0){
      break
    }
  }
  return(list(value = value, elements = elements))
}
