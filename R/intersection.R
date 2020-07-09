# areas_of_interest = get_areas()
areas_of_interest = spTransform(areas_of_interest, CRS("+proj=longlat"))

browser()


x = sp::over(points, areas_of_interest)
