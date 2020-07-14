#' @export
generate_kde_sf <- function(min_lat,
                            max_lat,
                            min_lng,
                            max_lng,
                            points,
                            radius_in_metres = 100,
                            grid_n = 1000) {
  points %>%
    sf::st_coordinates() %>%
    data.frame() %>%
    dplyr::rename(longitude = X, latitude = Y) %>%
    generate_kde(min_lat, max_lat, min_lng, max_lng, ., radius_in_metres, grid_n)
}

#' @export
generate_kde <- function(min_lat,
                         max_lat,
                         min_lng,
                         max_lng,
                         pointsdf,
                         radius_in_metres = 100,
                         grid_n = 1000) {
  lims = c(min_lng, max_lng, min_lat, max_lat)
  kde_h = get_h_for_radius_m(radius_in_metres)

  MASS::kde2d(pointsdf$longitude, pointsdf$latitude, kde_h, n = grid_n, lims = lims)
}

#' @export
get_h_for_radius_m <- function(radius_in_m) {
  c(radius_in_m * deg_lng_per_m(),
    radius_in_m * deg_lat_per_m())
}
