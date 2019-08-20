# !/usr/bin/env bash
path=data
mkdir -p data

docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geojson2poly total-area.geojson  $path/bounduary.poly
http://download.geofabrik.de/north-america.html
wget http://download.geofabrik.de/north-america/mexico-latest.osm.pbf -O $path/mexico.pbf

docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmconvert \
$path/mexico.pbf -B=$path/bounduary.poly -o=$path/juchitan.pbf

docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmosis \
--read-pbf file=$path/juchitan.pbf --write-xml $path/juchitan.osm

docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter \
$path/juchitan.osm --keep="building" > $path/juchitan-building.osm

docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit fc2frows \
div.geojson > $path/row.json

# docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit osm2new \
# $path/juchitan-building.osm $path/juchitan-building-new.osm

i=0
while IFS= read -r line; do
    echo $line > $path/feature.json
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geojson2poly $path/feature.json  $path/feature.poly
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmconvert \
        $path/juchitan-building.osm -B=$path/feature.poly -o=$path/juchitan-building-$i.osm
    i=$(($i + 1))
done < $path/row.json



