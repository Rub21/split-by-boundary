# !/usr/bin/env bash
outputDir=data

# converting pbf -> osm
# docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmosis \
# --read-pbf file=$outputDir/osm.pbf --write-xml $outputDir/osm.osm

# Filter Pole and comunication tower
# docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter $outputDir/osm.osm \
# --keep="landuse=commercial or 
#         landuse=industrial" > $outputDir/landuse.osm



docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter $outputDir/landuse.osm \
--keep=@user=Rub21 > $outputDir/landuse-rub21.osm