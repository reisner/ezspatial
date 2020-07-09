
generate_kde <- function(pointsdf, kde_h, grid_n, lims) {
  kde = kde2d(pointsdf$longitude, pointsdf$latitude, kde_h, n = grid_n, lims = as.numeric(lims))
}
