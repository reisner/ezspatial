# EZ Spatial

Process, Plot and Analyze spatial data with ease. Default values are for Edmonton, because Edmonton is best :)

## Installation

```
install.packages("devtools")
devtools::install_github("reisner/ezspatial")
```

## Examples

Generate sample data:

```
min_lat = 53.381661
max_lat = 53.673092
min_lng = -113.764219
max_lng = -113.246489
sf_points = ezspatial::generate_points(min_lat, max_lat, min_lng, max_lng, num_points = 5000)
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
grids = ezspatial::create_grid(min_lat, max_lat, min_lng, max_lng, num_rows = 50, num_cols = 50)
raster = ezspatial::rasterize_points(sf_points, grids)
map_raster(raster, title = "Heatmap - Counting Events")
```

<img src="/image/gridcounts.png" height="50%" width="50%">


### Generating 2D-KDE and plotting

Use the `radius_in_metres` parameter to define the bin-width (the area of effect of each point).
```
grids = ezspatial::create_grid(min_lat, max_lat, min_lng, max_lng, num_rows = 50, num_cols = 50)
kde = ezspatial::generate_kde_sf(min_lat, max_lat, min_lng, max_lng, sf_points, radius_in_metres = 10000)
raster_layer = ezspatial::rasterize_kde(kde, grids)
ezspatial::map_raster(raster_layer, title = "Heatmap - Smoothed")
```

<img src="/image/smoothed.png" height="50%" width="50%">

You can also plot the kde values directly using one of:

```
ezspatial::plot_kde(kde)
ezspatial::plot_kde_persp(kde) # Can be pretty slow!
ezspatial::plot_kde_contours(kde)
```

There is also a single function entry point for the above 2D-KDE / Rasterization workflow:

```
library(dplyr)
# E-scooter locations:
dataset = RSocrata::read.socrata("https://data.edmonton.ca/resource/vq44-ni9f.json") %>%
  mutate(longitude = as.numeric(longitude), latitude = as.numeric(latitude))

raster_layer = ezspatial::kde_and_rasterize(dataset, min_lat, max_lat, min_lng, max_lng, 50, 50, 500)
ezspatial::map_raster(raster_layer, title = "Heatmap - Scooter Locations")
```

<img src="/image/scooters.png" height="50%" width="50%">

### Leaflet Plots

The above raster layers can also be plotted in leaflet:

```
map = ezspatial::map_raster_leaflet(raster_layer)
saveWidget(map, file = "map.html")
```

### Convenience Functions

For converting between lat/long and metres, you can use:

```
> ezspatial::deg_lng_per_m()
[1] 9.717732e-06
> ezspatial::deg_lat_per_m()
[1] 9.041933e-06
> ezspatial::m_per_deg_lat()
[1] 110595.8
> ezspatial::m_per_deg_lng()
[1] 102904.7
```

But these are dependant on where you are on the globe, so if you're not plotting points near Edmonton, you'll have to use:

```
# Somewhere in the Atlantic Ocean... (0,0)
> deg_lng_per_m(lngMid = 0)
[1] 8.983155e-06
> deg_lat_per_m(latMid = 0)
[1] 9.043695e-06
> m_per_deg_lat(latMid = 0)
[1] 110574.3
> m_per_deg_lng(lngMid = 0)
[1] 111319.5
```

So, if you know your lat/lng ranges and you know you want 300m grid cells, you can figure out how many grid cells this corresponds to:

```
grid_in_m = 300
xl = -113.7067697598
xu = -113.3412240000
yl = 53.3962310731233
yu = 53.6446442889423
lng_diff = xu - xl
lat_diff = yu - yl
ncols = round(lat_diff / (ezspatial::deg_lng_per_m() * grid_in_m))
nrows = round(lng_diff / (ezspatial::deg_lat_per_m() * grid_in_m))
```
