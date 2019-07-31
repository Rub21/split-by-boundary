# !/usr/bin/env bash
path=/tmp/data
mkdir -p $path
pbfUrl=$1
bbox=$2
pbfFile="$(basename -- $pbfUrl)"
country="${pbfFile%.*}"
country="${country%.*}"
# wget urlPbf

echo $country

# bbox to geojson
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit bbox2fc --bbox="$bbox" > bounduary.geojson
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geojson2poly bounduary.geojson bounduary.poly
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmconvert $pbfFile -B=bounduary.poly -o=clip-$pbfFile
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmosis --read-pbf file=clip-$osmFile --write-xml osm.osm

# Hospitals
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter osm.osm \
--keep="amenity=hospital or amenity=clinic or building=hospital" > hospital.osm

# University
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter osm.osm \
--keep="amenity=university or amenity=college or building=university or landuse=university" > university.osm
# docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter university.osm --out-key=amenity

# school
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter osm.osm \
--keep="amenity=place_of_worship or building=place_of_worship or building=church or building=cathedral or building=chapel or building=mosque or building=synagogue or building=temple or building=shrine or landuse=place_of_worship or landuse=religious" > place_of_worship.osm
# docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter place_of_worship.osm --out-key=amenity
