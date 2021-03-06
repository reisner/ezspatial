#' @export
create_grid <- function(min_lat,
                        max_lat,
                        min_lng,
                        max_lng,
                        num_rows = 100,
                        num_cols = 100) {
  raster::raster(nrows = num_rows,
                 ncols = num_cols,
                 xmn = min_lng,
                 xmx = max_lng,
                 ymn = min_lat,
                 ymx = max_lat)
}

#' @export
rasterize_points <- function(pointsdf,
                             grids,
                             return_df = FALSE) {
  if (is.null(pointsdf$weight)) {
    pointsdf$weight = 1 # Treat each event equally.
  }

  # Not needed with sf df:
  # sp::coordinates(pointsdf) = ~longitude + latitude
  raster_layer = raster::rasterize(pointsdf,
                                   grids,
                                   fun = 'count',
                                   field = 'weight',
                                   background = 0)

  if (return_df) {
    cell_data = data.frame(raster::rasterToPoints(raster_layer)) %>%
    dplyr::rename(events = layer) %>%
    dplyr::rename(longitude = x) %>%
    dplyr::rename(latitude = y)

    return(cell_data)
  } else {
    return(raster_layer)
  }
}

#' @export
rasterize_kde <- function(kde_data, grids, normalize = TRUE) {
  x = kde_data$x
  y = kde_data$y
  z = c(kde_data$z) # z values, one column after another
  point_data = data.frame(longitude = rep(x, length(y)),
                          latitude = rep(y, each = length(x)),
                          z = z)
  sp::coordinates(point_data) = ~longitude + latitude
  raster_layer = raster::rasterize(point_data, grids, fun = mean, field = 'z')

  if (normalize) {
    raster::values(raster_layer) = 100 * raster::values(raster_layer) / max(raster::values(raster_layer), na.rm = TRUE) # Normalize to [0,100]
  }

  raster_layer
}

#   if (transform) {
#     percentile = ecdf(kde_data$z)
#     kde_data$z = percentile(kde_data$z)
#     #kde_data$z = log(kde_data$z)
#     #kde_data$z = 1/rank(kde_data$z)
#   }
#   # Normalize to [0, 100]
#   kde_data$z = 100 * kde_data$z / max(kde_data$z)
#

#' @export
kde_and_rasterize <- function(dataset,
                              min_lat,
                              max_lat,
                              min_lng,
                              max_lng,
                              num_grid_rows,
                              num_grid_cols,
                              kde_radius_in_m) {
  grids = create_grid(min_lat, max_lat, min_lng, max_lng, num_rows = num_grid_rows, num_cols = num_grid_cols)
  kde = generate_kde(min_lat, max_lat, min_lng, max_lng, dataset, radius_in_metres = kde_radius_in_m)
  raster_layer = rasterize_kde(kde, grids)

  raster_layer
}
