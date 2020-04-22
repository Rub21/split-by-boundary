# !/usr/bin/env bash
outputDir=data
rm -rf $outputDir
mkdir -p $outputDir


# NILE
# docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit bbox2fc \
# --bbox="30.410426936943182,5.487766360430384,39.418930263056815,18.520923057982287" >  $outputDir/bbox.geojson
# docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geojson2poly \
# $outputDir/bbox.geojson $outputDir/bounduary.poly

# # Bandar Abbas
# wget http://download.geofabrik.de/asia/iran-latest.osm.pbf -O $outputDir/osm.pbf 
# docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit bbox2fc \
# --bbox="55.49468994140625,26.72108039086171,57.14263916015625,27.435165209660347" >  $outputDir/bbox.geojson
# docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geojson2poly \
# $outputDir/bbox.geojson $outputDir/bounduary.poly


# # Alaska
# wget http://download.geofabrik.de/north-america/us-pacific-latest.osm.pbf -O $outputDir/osm.pbf 
# docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit bbox2fc \
# --bbox="-152.061767578125,59.772991625706695,-148.941650390625,61.58026393017926" >  $outputDir/bbox.geojson
# docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geojson2poly \
# $outputDir/bbox.geojson $outputDir/bounduary.poly


# Murmansk
wget http://download.geofabrik.de/russia-latest.osm.pbf -O $outputDir/osm.pbf 
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit bbox2fc \
--bbox="32.935638427734375,68.892714311174,33.435516357421875,69.0562945309115" >  $outputDir/bbox.geojson
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geojson2poly \
$outputDir/bbox.geojson $outputDir/bounduary.poly



# Clip the pbf file for the area
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmconvert \
$outputDir/osm.pbf  -B=$outputDir/bounduary.poly -o=$outputDir/osm-clip.pbf

# converting pbf -> osm
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmosis \
--read-pbf file=$outputDir/osm-clip.pbf --write-xml $outputDir/osm.osm

# Filter Pole and comunication tower
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter $outputDir/osm.osm \
--keep="tower=pole or 
        man_made=communications_tower or 
        tower:type=communication" > $outputDir/tower.osm

# converting osm -> geojson
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmtogeojson \
$outputDir/tower.osm> $outputDir/tower.geojson

# Cover point to Polygon, 20 meters distances
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit fc2square \
$outputDir/tower.geojson --radius=20 \
> $outputDir/tower-squares.geojson

# flatten
geojson-flatten $outputDir/tower-squares.geojson > $outputDir/murmansk_osm.geojson

