
# TODO: https://stackoverflow.com/questions/37660950/how-to-create-2d-data-set-from-gaussian-distribution-in-r

#' @export
generate_points <- function(min_lat,
                            max_lat,
                            min_lng,
                            max_lng,
                            num_points = 1000,
                            sf = TRUE,
                            crs = 4326) {
  latitude = runif(num_points, min = min_lat, max = max_lat)
  longitude = runif(num_points, min = min_lng, max = max_lng)
  pointsdf = data.frame(longitude = longitude, latitude = latitude)

  if (sf) {
    pointsdf = sf::st_as_sf(pointsdf, coords = c("longitude", "latitude"), crs = crs)
  }

  pointsdf
}

#' @export
filter_to_area <- function(dataset,
                           min_lat,
                           max_lat,
                           min_lng,
                           max_lng) {
  dataset %>%
    dplyr::filter(latitude >= min_lat) %>%
    dplyr::filter(latitude <= max_lat) %>%
    dplyr::filter(longitude >= min_lng) %>%
    dplyr::filter(longitude >= min_lng)
}


# Note: Default values are specific to the centre of Edmonton.
# https://en.wikipedia.org/wiki/Geographic_coordinate_system
#' @export
m_per_deg_lat <- function(latMid = 53.546821) {
  m = 111132.92 - 559.82 * cos( 2 * latMid ) + 1.175 * cos( 4 * latMid ) - 0.0023 * cos( 6 * latMid )
  return(m)
}

#' @export
m_per_deg_lng <- function(lngMid = -113.489835) {
  m = 111412.84 * cos( lngMid ) - 93.5 * cos( 3 * lngMid ) + 0.118 * cos( 5 * lngMid )
  return(m)
}

#' @export
deg_lat_per_m <- function(latMid = 53.546821) {
  m = m_per_deg_lat(latMid)
  deg = 1 / m
  return(deg)
}

#' @export
deg_lng_per_m <- function(lngMid = -113.489835) {
  m = m_per_deg_lng(lngMid)
  deg = 1 / m
  return(deg)
}
