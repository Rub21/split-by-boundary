# !/usr/bin/env bash
path=/tmp/data
mkdir -p $path
osmPathFile=$1
osmFile="$(basename -- $osmPathFile)"
cp $osmPathFile ${PWD}
# docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmosis --read-pbf file=$osmFile --write-xml osm.osm
# docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter osm.osm --keep="project=tax_info and building=yes" -o=buildings.osm
# docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter osm.osm --keep="project=tax_info and address_source=wb" -o=address.osm
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter address.osm --out-key=file > address.txt
# We have to filter the adress, kepping only the base name of each name and save as  address-ok.txt
mkdir -p address
while IFS= read -r line; do
    echo $line
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter address.osm --keep="file=$line" -o=address/$line.osm
done < address-ok.txt
# aws s3 sync address/ s3://ds-data-projects/breña-buildings-footprints/