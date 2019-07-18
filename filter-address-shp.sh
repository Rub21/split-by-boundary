# !/usr/bin/env bash
mkdir -p data/
shpfile=$1
# rm data/*.geojson
ogr2ogr -f GeoJSON data/address.geojson $shpfile
#Total: 39451
jq ".features[] | .properties.file" data/address.geojson | sort | uniq |  tr -d \" > data/address-files.txt
while IFS= read -r line; do
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit filterbyprop \
    data/address.geojson --prop file="$line" > data/$line.geojson
    num=$(grep -o -i OBJECTID_1 data/$line.geojson | wc -l)
    echo $num,$line
done < data/address-files.txt
# aws s3 sync address/ s3://ds-data-projects/breña-buildings-footprints/