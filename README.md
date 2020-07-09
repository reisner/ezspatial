# EZ Spatial

Process, Plot and Analyze spatial data with ease. Default values are for Edmonton, because Edmonton is best :)

## Installation

```
devtools::install_github("reisner/ezspatial")
```

## Examples

Generate sample data:

```
points = ezspatial::generate_points(num_points = 5000)
```

### Counting events in a grid

```
grid = ezspatial::create_grid(num_rows = 50, num_cols = 50)
raster = ezspatial::rasterize_points(points, grid)
map_raster(raster, label = "Counting Events")
```

![Grid Counts](/image/gridcounts.png)


### Generating 2D-KDE and plotting

```

```
