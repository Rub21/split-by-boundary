# !/usr/bin/env bash
path=/tmp/data
mkdir -p $path
osmPathFile=$1
osmFile="$(basename -- $osmPathFile)"
# cp $osmPathFile ${PWD}
# docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geojson2poly dar.json dar.poly
# docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmconvert $osmFile -B=dar.poly -o=clip-$osmFile
# docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmosis --read-pbf file=clip-$osmFile --write-xml osm.osm

# Hospitals
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter osm.osm \
--keep="amenity=hospital or amenity=clinic or building=hospital" > hospital.osm

docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter hospital.osm --out-key=amenity

# University
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter osm.osm \
--keep="amenity=university or amenity=college or building=university or landuse=university" > university.osm
# docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter university.osm --out-key=amenity

# school
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter osm.osm \
--keep="amenity=place_of_worship or building=place_of_worship or building=church or building=cathedral or building=chapel or building=mosque or building=synagogue or building=temple or building=shrine or landuse=place_of_worship or landuse=religious" > place_of_worship.osm
# docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter place_of_worship.osm --out-key=amenity
