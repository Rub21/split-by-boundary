# !/usr/bin/env bash
path=data
mkdir -p data

# #You need the boundary `total_area.geojson` (where you want to work), after that you need to convert from geojson to poly file. The `total-area.geojson` file should be outside of the data folder
# docker run --rm -v "$PWD":/mnt/data developmentseed/geokit:latest geojson2poly bounduaries.geojson  $path/bounduary.poly
# "$PWD"

# # #Now you need to download the area from geofabrick, so you need the link, for this you can enter to this web site `http://download.geofabrik.de/`and obtain the country that you need to download.
# wget http://download.geofabrik.de/asia/philippines-latest.osm.pbf -O $path/Philippinas.pbf

# #After that you need to obtain only the part that you want, it means from all the country you need only the data where cover the boundary 
# docker run --rm -v "$PWD":/mnt/data developmentseed/geokit:latest osmconvert \
# $path/Philippinas.pbf -B=$path/bounduary.poly -o=$path/manila.pbf

# #Then, you need to convert from pbf to osm file
# docker run --rm -v "$PWD":/mnt/data developmentseed/geokit:latest osmosis \
# --read-pbf file=$path/manila.pbf --write-xml $path/manila.osm

# #After that you need to filter the objects or features that you want to work 
# docker run --rm -v "$PWD":/mnt/data developmentseed/geokit:latest osmfilter \
# $path/manila.osm --keep="landuse=industrial amenity=marketplace" > $path/osm_data.osm


# convert to geojson
docker run --rm -v "$PWD":/mnt/data developmentseed/geokit:latest osmtogeojson \
$path/osm_data.osm > $path/osm_data.geojson


#filter the geojson by landuse
docker run --rm -v "$PWD":/mnt/data developmentseed/geokit:latest geokit filterbyprop \
$path/osm_data.geojson --prop landuse=industrial > $path/landuse.geojson


#filter the geojson by amenity
docker run --rm -v "$PWD":/mnt/data developmentseed/geokit:latest geokit filterbyprop \
$path/osm_data.geojson --prop amenity=marketplace > $path/amenity.geojson

# Merge
docker run --rm -v "$PWD":/mnt/data developmentseed/geokit:latest geojson-merge \
$path/amenity.geojson $path/landuse.geojson >  $path/result.geojson


# Filter by geo
docker run --rm -v "$PWD":/mnt/data developmentseed/geokit:latest geokit filterbygeometry  \
 $path/result.geojson --geos Point >  $path/result-POINT.geojson

# Filter by geo
docker run --rm -v "$PWD":/mnt/data developmentseed/geokit:latest geokit filterbygeometry  \
 $path/result.geojson --geos Polygon >  $path/result-POLYGON.geojson