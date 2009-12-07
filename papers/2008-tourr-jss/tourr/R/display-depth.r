#' Display 3d projection with depth cues
#' 
#' Suggestion to use gray background and colour saturation (instead of 
#' gray shading) by Graham Wills.
#' Animate a 3d projection with depth cues.
#'
#' @param data matrix, or data frame containing numeric columns
#' @param tour_path tour path generator, defaults to the grand tour
#' @param ... other arguments passed on to \code{\link{animate}}
#' @seealso \code{\link{animate}} for options that apply to all animations
#' @keywords hplot
#' @aliases display_depth animate_depth
#' @usage display_depth(data, ...)
#'        animate_depth(data, tour_path = grand_tour(3), ...)
#' 
#' @examples
#' animate_depth(flea[, 1:6])
display_depth <- function(data,  ...)
{
  shades <- hcl(240, 
    c = seq(0, 60, length = 100), 
    l = seq(80, 20, length = 100)
  )
  
  rng <- limit <- NULL
  init <- function(data) {
    if (is.null(limit)) {
      first_eigen <- sqrt(eigen(var(data[, 1:2]))$values[1])
      limit <<- 3 * first_eigen
    }
    rng <<- c(-limit, limit)    
  }
  
  render_frame <- function() {
    par(pty = "s", mar = rep(1,4))
    blank_plot(xlim = rng, ylim = rng)
  }
  render_transition <- function() {
    rect(-1.99, -1.99, 1.99, 1.99, col="grey80", border=NA)
  }
  render_data <- function(data, proj, geodesic) {
    x <- data %*% proj
    x <- scale(x, center = TRUE, scale = FALSE)

    depth <- x[, 3]
    # depth ranges mostly between -1 and 1, 
    # so depth_std should lie between 0 and 1
    depth_std <- depth / 2 + 0.5 
    size <- 0.5 + depth_std * 3
    shade <- shades[round(depth_std * 100)]
    
    ord <- order(depth_std)
    points(x[ord, 1:2], pch = 20, cex = size[ord] , col = shade[ord], ...)
  }

  list(
    init = init,
    render_frame = render_frame,
    render_transition = render_transition,
    render_data = render_data,
    render_target = nul
  )
}


# not being documented.  already aliased somewhere else
animate_depth <- function(data, tour_path = grand_tour(3), ...) {  

  animate(
    data = data, tour_path = tour_path,
    display = display_depth(data, ...),
    ...
  )
}
