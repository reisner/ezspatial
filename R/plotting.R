#' @export
map_raster <- function(rasterized,
                       title = "Heatmap",
                       low = "white",
                       high = scales::muted("red")) {
  rtp = raster::rasterToPolygons(rasterized)
  rtp@data$id <- 1:nrow(rtp@data)   # add id column for join
  rtpFort <- ggplot2::fortify(rtp, data = rtp@data)
  rtpFortMer <- merge(rtpFort, rtp@data, by.x = 'id', by.y = 'id')  # join data

  bbox = sf::st_bbox(rasterized)
  box = c(left = as.numeric(bbox$xmin),
          bottom = as.numeric(bbox$ymin),
          right = as.numeric(bbox$xmax),
          top = as.numeric(bbox$ymax))

  ggmap::ggmap(ggmap::get_stamenmap(box, maptype = "toner-background", extent = "device")) +
    ggplot2::geom_polygon(data = rtpFortMer,
                          ggplot2::aes(x = long, y = lat, group = group, fill = layer),
                          alpha = 0.7,
                          size = 0) +
    ggplot2::scale_fill_gradient(low = low, high = high) +
    ggplot2::theme(legend.position = "bottom") +
    ggplot2::theme(axis.line = ggplot2::element_blank(),
                   axis.text = ggplot2::element_blank(),
                   axis.ticks = ggplot2::element_blank(),
                   plot.margin = grid::unit(c(0, 0, 0, 0), 'lines')) +
    ggplot2::xlab('') +
    ggplot2::ylab('') +
    ggplot2::ggtitle(title) +
    ggplot2::theme(legend.position = "none")
}

#' @export
map_raster_leaflet <- function(rasterized, colors = "Reds") {
  colors = "Reds"
  pal = leaflet::colorNumeric(colors, raster::values(rasterized), na.color = "transparent")

  map = leaflet::leaflet() %>%
          leaflet::addTiles() %>%
          leaflet::addProviderTiles(leaflet::providers$Stamen.Toner) %>%
          leaflet::addRasterImage(rasterized, colors = pal, opacity = 0.8) %>%
          leaflet::addLegend(pal = pal, values = raster::values(rasterized), title = "Supply")

  map
}

#' @export
plot_kde <- function(kdedata) {
  image(kdedata)
}

#' @export
plot_kde_persp <- function(kdedata, title = "KDE Perspective Plot") {
  colors = colorRampPalette(c("blue", "red"))(100)
  z = kdedata$z
  z.facet.center = (z[-1, -1] + z[-1, -ncol(z)] + z[-nrow(z), -1] + z[-nrow(z), -ncol(z)]) / 4 # height of facets
  z.facet.range = cut(z.facet.center, 100) # Range of the facet center on a 100-scale (number of colors)
  # This looks weird with lots of data (i.e. n >= 500 from kde2d).
  # Setting border = NA makes it displayable, but doesnt look great. Fiddling
  # with "border" and lwd helps a bit.
  persp(kdedata, theta = 30, phi = 30, expand = 0.2,
        shade = NA, col = colors[z.facet.range], border = NA, #"grey80",
        box = FALSE, main = title)
}

#' @export
plot_kde_contours <- function(kdedata, title = "KDE Contour Plot") {
  contour(kdedata, main = title)
}


#
# create_leaflet_plot <- function(kde_data, name, pointsdata) {
#   contour_data = contourLines(kde_data, nlevels = 15) # Any more than 15 and the layers are no longer transparent
#   contour_levels = as.factor(sapply(contour_data, `[[`, "level"))
#   number_of_levels = length(levels(contour_levels))
#
#   polygons = lapply(1:length(contour_data), function(i)
#     Polygons(list(Polygon(cbind(contour_data[[i]]$x, contour_data[[i]]$y))), ID=i))
#   spatial_polygons = SpatialPolygons(polygons)
#
#   colors = heat.colors(number_of_levels, NULL)[contour_levels]
#
#   m <- leaflet(spatial_polygons) %>%
#     addTiles() %>%
#     addProviderTiles(providers$Stamen.Toner) %>%
#     addPolygons(color = colors, stroke = FALSE, group = "contours") %>%
#     addCircleMarkers(pointsdata$longitude,
#                      pointsdata$latitude,
#                      radius = 4,
#                      opacity = 0.5,
#                      col = "blue",
#                      group = name) %>%
#     addLayersControl(
#       overlayGroups = c("contours", name),
#       options = layersControlOptions(collapsed = FALSE)
#     )
#
#   saveWidget(m, file=paste(name, ".html", sep=''))
# }




# map = leaflet() %>%
#         addProviderTiles(providers$Stamen.TonerLite,
#           options = providerTileOptions(noWrap = TRUE)
#         )
# layers = input$layers
# if (length(layers) > 0) {
#   display_layer = NULL
#   if (length(layers) == 1) {
#     display_layer = dataset[[layers]] # layers is a character string if there's only one 😠
#   } else {
#     layerstack = raster::stack()
#     for (layer_name in layers) {
#       layer = dataset[[layer_name]]
#       layerstack = raster::stack(layerstack, layer)
#     }
#     display_layer = do.call(input$agg_function, c(layerstack))
#     #display_layer = max(layerstack)
#   }
#   #values(display_layer)[values(display_layer) == 0] = NA
#   #colors = colorNumeric(c("#0C2C84", "#41B6C4", "#FFFFCC"), values(display_layer), na.color = "transparent"),
#   #palette = colorBin("Blues", domain = 0:1)
#   #palette = colorBin("Spectral", domain = 0:1)
#   palette = colorBin("YlOrRd", domain = 0:1)
#   colors = colorNumeric(palette, values(display_layer), na.color = "transparent")
#   #colors = colorQuantile(palette, values(display_layer), na.color = "transparent")
#   map = map %>%
#           addRasterImage(display_layer,
#                          colors = colors,
#                          opacity = 0.7)
# } else {
#   map = fitBounds(map, xl, yl, xu, yu)
