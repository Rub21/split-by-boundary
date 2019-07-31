# !/usr/bin/env bash
rm -rf data/
mkdir -p data/
cp $1 data/
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmosis --read-pbf file=data/osm.pbf --write-xml data/osm.osm
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter  data/osm.osm --keep="project=tax_info" -o=data/project.osm
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter  data/osm.osm --keep="address_source=wb" -o=data/address_source.osm
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter  data/address_source.osm --keep="@user=Rub21" -o=data/rub21.osm
# docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit osmtogeojson rub21.osm > rub21.geojson