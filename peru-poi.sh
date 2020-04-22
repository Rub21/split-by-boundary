# !/usr/bin/env bash
outputDir=data
# rm -rf $outputDir
# export MAPBOX_ACCESS_TOKEN=xx
# mkdir -p data
# wget http://download.geofabrik.de/south-america/peru-latest.osm.pbf -O data/osm.pbf 


# docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmosis \
# --read-pbf file=$outputDir/osm.pbf --write-xml $outputDir/osm.osm

# commercial
# docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter $outputDir/osm.osm \
#     --keep="building=supermarket or
#             shop=supermarket or
#             shop=department_store or
#             shop=mall or
#             landuse=commercial" > $outputDir/osm-commercial.osm

docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmtogeojson \
    $outputDir/osm-commercial.osm > $outputDir/osm-commercial.geojson

docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit centroid \
    $outputDir/osm-commercial.geojson > $outputDir/osm-commercial-centroid.geojson

#Bank
# docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter $outputDir/osm.osm \
#     --keep="amenity=bank  or
#         amenity=atm" > $outputDir/osm-bank.osm

docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmtogeojson \
    $outputDir/osm-bank.osm > $outputDir/osm-bank.geojson

docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit centroid \
    $outputDir/osm-bank.geojson > $outputDir/osm-bank-centroid.geojson






