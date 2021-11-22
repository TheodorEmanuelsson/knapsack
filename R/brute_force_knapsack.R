#' Solving the knapsack problem through brute force
#'
#' @param x is a data.frame containing knapsack data. It has two columns: v with values and w with weights.
#' @param W is a numeric scalar which defined the maximum possible weight knapsack can handle before breaking.
#' @param parallel is a boolean for if the function should use parallel programming.
#' 
#' @details This function solves a the knapsack problem by using the brute force method. It takes a data.frame of weights and values, see function create_knapsack_data() for creating knapsack data.
#' Then specify a maximum weight that the knapsack can hold (parameter W). The function will then return the optimal bag (in terms of value) and the indicies for the items that are put in the optimal bag.
#' The function allows for parallel computations in Unixbased systems and in Windows. If the function is run on a Windows machine the parallel computations will be made using a cluster of instances of R.
#' 
#' @return a list object containing the best bag value given the weight and the elements that make up the best bag.
#' 
#' @importFrom parallel detectCores mclapply parSapply makeCluster
#' 
#' @export

brute_force_knapsack <- function(x, W, parallel = FALSE){
  stopifnot(is.data.frame(x) == TRUE, colnames(x) == c("w","v"), is.integer(x[,1]) == TRUE, 
            is.numeric(W) == TRUE, length(W) == 1, W > 0, all(x > 0))
  
  # Complexity
  complexity <- 2^(nrow(x))-1
  # Matrix of binary combinations of items
  binaryMatrix <- sapply(1:(complexity), function(i) as.integer(intToBits(i)[1:nrow(x)]))
  
  # check all combinations of bags 
  checkBag <- function(x, W, column){
    combo <- binaryMatrix[,column] # select each combo
    weight <- sum(x[1] * combo) # sum of weight for active boxes in current bag 
    currval <- sum(x[2] * combo) # sum of value for active boxes in current bag
    if(weight <= W){ # Store only combinations that fit
      output <- currval
    }else{output <- NA}
    return(output)
  }
  
  if(parallel == FALSE){
    combin <- sapply(1:ncol(binaryMatrix), FUN = checkBag, x=x, W=W)
  } else if(parallel == TRUE){
    cores <- parallel::detectCores()-1 # Leave one core free?
    if(Sys.info()[['sysname']] == "Linux" | Sys.info()[['sysname']] == "Darwin"){
      combin <- unlist(parallel::mclapply(1:ncol(binaryMatrix), FUN = checkBag, x=x, W=W, mc.cores = cores)) # Linux solution for paralleling 
    } else if(Sys.info()[['sysname']] == "Windows"){
      cluster <- parallel::makeCluster(cores)
      combin <- parallel::parSapply(cl = cluster, 1:ncol(binaryMatrix), FUN = checkBag, x = x, W=W)
    }else{
      stop("Error: User not running a valid system")
    }
  } else{
    stop("Error: parallel must be a boolean")
  }
  value <- max(combin, na.rm = TRUE)
  position <- which(combin == value)
  elements <- which(intToBits(position) > 0)
  return(list(value = value, elements = elements))
}