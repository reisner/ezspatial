
# TODO: https://stackoverflow.com/questions/37660950/how-to-create-2d-data-set-from-gaussian-distribution-in-r

generate_points <- function(num_points = 1000,
                            min_lat = 53.381661,
                            max_lat = 53.673092,
                            min_lng = -113.764219,
                            max_lng = -113.246489,
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

filter_to_area <- function(dataset,
                           min_lat = 53.381661,
                           max_lat = 53.673092,
                           min_lng = -113.764219,
                           max_lng = -113.246489) {
  dataset %>%
    dplyr::filter(latitude >= min_lat) %>%
    dplyr::filter(latitude <= max_lat) %>%
    dplyr::filter(longitude >= min_lng) %>%
    dplyr::filter(longitude >= min_lng)
}


# Note: Default values are specific to the centre of Edmonton.
# https://en.wikipedia.org/wiki/Geographic_coordinate_system
m_per_deg_lat <- function(latMid = 53.546821) {
  m = 111132.92 - 559.82 * cos( 2 * latMid ) + 1.175 * cos( 4 * latMid ) - 0.0023 * cos( 6 * latMid )
  return(m)
}

m_per_deg_lng <- function(lngMid = -113.489835) {
  m = 111412.84 * cos( lngMid ) - 93.5 * cos( 3 * lngMid ) + 0.118 * cos( 5 * lngMid )
  return(m)
}

deg_lat_per_m <- function(latMid = 53.546821) {
  m = m_per_deg_lat(latMid)
  deg = 1 / m
  return(deg)
}

deg_lng_per_m <- function(lngMid = -113.489835) {
  m = m_per_deg_lng(lngMid)
  deg = 1 / m
  return(deg)
}
