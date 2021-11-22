#' Solving the knapsack problem through heuristic approach
#'
#' @param x is a data.frame containing knapsack data. It has two columns: v with values and w with weights.
#' @param W is a numeric scalar which defined the maximum possible weight knapsack can handle before breaking.
#' @param opt indicates whether or not the better version should be used (for tests it is set to FALSE)
#' 
#' @return a list object containing the best bag value given the weight and the elements that make up the best bag.
#' 
#' 
#' @export

greedy_knapsack <- function(x, W, opt = TRUE){
  stopifnot(is.data.frame(x) == TRUE, colnames(x) == c("w","v"),is.integer(x[,1]) == TRUE, 
            is.numeric(W) == TRUE, length(W) == 1, W > 0)
  
  x$ID <- 1:nrow(x) # ID column
  x <- subset(x, x[1] <= W)# Remove items that weigh more than W
  
  x$ratio <- x[2] / x[1] # The value per unit of weigh
  x <- x[order(x$ratio$v, decreasing = TRUE),] # Sort the data by descending order
  
  currval <- 0
  currweight <- 0
  
  i <- 0
  
  # in a first step we choose all top observations that still fit in the sack and 
  # and stop if the next one is not fitting anymore
  repeat{
    
    i <- i + 1
    currweight <- currweight + x$w[i]
    currval <- currval + x$v[i]
    
    if((currweight + x$w[i+1]) > W | i == nrow(x)) break
  }
  
  currele <- x$ID[1:i]
  
  if(opt == TRUE){ #this is checking if can put any other element in the sack that comes later
    
    diff <- W - currweight
    j <- i + 1
    
    repeat{ 
      j <- j + 1 #we can skip the one we did not use before
      if(x$w[j] < diff){
        currweight <- currweight + x$w[j]
        currval <- currval + x$v[j]
        diff <- diff - x$w[j]
        currele <- append(currele,x$ID[j])
      }
      if(j >= nrow(x)) break 
    }
  }
  
  return(list(value = round(currval), elements = currele))
}
