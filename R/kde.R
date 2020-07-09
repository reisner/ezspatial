







# library(MASS)
# library(raster)
# library(rgdal) # to ensure this installed OK -- some issues on ubuntu 16.
# library(sp)
#
#
# rasterize_kde <- function(kde_data, grid) {
#   x = kde_data$x
#   y = kde_data$y
#   z = c(kde_data$z) # z values, one column after another
#   point_data = data.frame(longitude = rep(x, length(y)),
#                           latitude = rep(y, each = length(x)),
#                           z = z)
#   coordinates(point_data) = ~longitude + latitude
#   raster_layer = rasterize(point_data, grid, fun = mean, field = 'z')
#
#   return(raster_layer)
# }
#
