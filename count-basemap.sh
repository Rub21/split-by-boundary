# !/usr/bin/env bash
path=data
rm -rf $path
mkdir -p $path

wget https://gist.githubusercontent.com/Rub21/d1d5f557d481d26919c3b30c4d7a868d/raw/75bbd635325b4bef3e381c8985503b8b8a4e3e78/Urban-area-Niamey-Niger.geojson \
-O $path/area.geojson

wget http://download.geofabrik.de/africa/niger-latest.osm.pbf  \
-O $path/niger-latest.osm.pbf

docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geojson2poly \
$path/area.geojson $path/bounduary.poly

docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmconvert \
$path/niger-latest.osm.pbf -B=$path/bounduary.poly -o=$path/niger-latest-clip.osm.pbf


docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmosis --read-pbf file=$path/niger-latest-clip.osm.pbf --write-xml $path/osm.osm

echo '{
    "building": "*",
    "highway": "*",
    "amenity": "waste_disposal"
}' > $path/config.json

docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmcounter \
$path/niger-latest-clip.osm.pbf --config $path/config.json --format csv > $path/output.csv