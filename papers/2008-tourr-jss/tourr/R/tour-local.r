#' The local tour.
#' 
#' The local tour alternates between the starting position and a 
#' nearby random projection.
#' 
#' Usually, you will not call this function directly, but will pass it to 
#' a method that works with tour paths like \code{\link{save_history}}, 
#' or \code{\link{animate}}
#' 
#' @param start initial projection matrix
#' @param angle distance in radians to stay within
#' @param ... Not Used
#' @examples
#' animate_xy(flea[, 1:3], local_tour(basis_init(3, 2)))
#' animate_xy(flea[, 1:3], local_tour(basis_init(3, 2), 0.2))
#' animate_xy(flea[, 1:3], local_tour(basis_random(3, 2), 0.2))
local_tour <- function(start, angle = pi / 4, ...) {
  odd <- TRUE
  
  generator <- function(current, data) {
    if (odd) {
      new_basis <- start
    } else {
      new <- basis_random(nrow(start), ncol(start))
      dist <- runif(1, 0, angle)
      new_basis <- step_angle(geodesic_info(start, new), dist)
    }
    odd <<- !odd
    
    new_basis
  }

  new_tour_path("local", generator) 
}