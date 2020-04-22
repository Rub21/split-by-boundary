# !/usr/bin/env bash
outputDir=data

# converting pbf -> osm
# docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmosis \
# --read-pbf file=$outputDir/osm.pbf --write-xml $outputDir/osm.osm

docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter $outputDir/osm.osm \
--keep="Project=hp_lac" > $outputDir/hp_lac.osm

docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter $outputDir/hp_lac.osm \
--keep="landuse=residential" > $outputDir/landuse.osm

docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter $outputDir/hp_lac.osm \
--keep="building=yes" > $outputDir/building.osm

docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmtogeojson \
$outputDir/landuse.osm > $outputDir/landuse_elpozo.geojson

docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmtogeojson \
$outputDir/building.osm > $outputDir/building_elpozo.geojson