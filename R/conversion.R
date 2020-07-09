# Convert from UTM to Lat/Lng
from = CRS("+init=epsg:3776")
to = CRS("+proj=longlat")
points = SpatialPoints(cbind(training_data$X_Coord, training_data$Y_Coord), proj4string = from)
points = spTransform(points, to)
