# EZ Spatial

Process, Plot and Analyze spatial data with ease. Default values are for Edmonton, because Edmonton is best :)

## Installation

```
devtools::install_github("reisner/ezspatial")
```

## Examples

Generate sample data:

```
sf_points = ezspatial::generate_points(num_points = 5000)
```

By default, this generates points in an `sf` dataframe:
```
> sf_points
Simple feature collection with 5000 features and 0 fields
geometry type:  POINT
dimension:      XY
bbox:           xmin: -113.7642 ymin: 53.38166 xmax: -113.2466 ymax: 53.67309
epsg (SRID):    4326
proj4string:    +proj=longlat +datum=WGS84 +no_defs
First 10 features:
                     geometry
1  POINT (-113.2649 53.54397)
2  POINT (-113.2831 53.62626)
3  POINT (-113.4584 53.59097)
4  POINT (-113.4633 53.57645)
5   POINT (-113.3521 53.5534)
6  POINT (-113.5636 53.53652)
7   POINT (-113.429 53.61401)
8   POINT (-113.5652 53.4885)
9   POINT (-113.5976 53.5914)
10 POINT (-113.3431 53.51948)
```

### Counting events in a grid

```
grid = ezspatial::create_grid(num_rows = 50, num_cols = 50)
raster = ezspatial::rasterize_points(sf_points, grid)
map_raster(raster, title = "Heatmap - Counting Events")
```

![Grid Counts](/image/gridcounts.png) <!-- .element height="50%" width="50%" -->


### Generating 2D-KDE and plotting

Use the `radius_in_metres` parameter to define the bin-width (the area of effect of each point).
```
grid = ezspatial::create_grid(num_rows = 50, num_cols = 50)
kde = generate_kde_sf(sf_points, radius_in_metres = 10000)
raster_layer = rasterize_kde(kde, grid)
map_raster(raster_layer, title = "Heatmap - Smoothed")
```

![Grid Counts](/image/smoothed.png) <!-- .element height="50%" width="50%" -->


### Leaflet Plots

The above raster layers can also be plotted in leaflet:

```
map = map_raster_leaflet(raster_layer)
saveWidget(map, file = "map.html")
```

### Convenience Functions




# grid_in_m = 300
# convert_and_add_geo_features <- function(dataset,
#                                          grid_in_m,
#                                          xl = -113.7067697598,
#                                          xu = -113.3412240000,
#                                          yl = 53.3962310731233,
#                                          yu = 53.6446442889423,
#                                          format = 'dataframe') {
#   lng_diff = xu - xl
#   lat_diff = yu - yl
#   ncols = round(lat_diff / (deg_lng_per_m() * grid_in_m))
#   nrows = round(lng_diff / (deg_lat_per_m() * grid_in_m))
