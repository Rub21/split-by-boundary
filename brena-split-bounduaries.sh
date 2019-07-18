# !/usr/bin/env bash
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit fc2frows bounduary.geojson > bounduary.json
indexFile=1
path=/tmp/data
rm -rf $path
mkdir -p $path

while IFS= read -r line; do
    echo $indexFile
    echo "$line" > $path/$indexFile.json
    ogr2ogr -nlt POLYGON -skipfailures $path/$indexFile.shp $path/$indexFile.json OGRGeoJSON
    ogr2ogr -clipsrc $path/$indexFile.shp $path/$indexFile-address.shp brena_rooftops._final/brena_rooftops.shp
    # clip
    ogr2ogr -clipsrc $path/$indexFile.shp $path/$indexFile-address.shp taxes_geocoded_wblock/taxes_geocoded_wblock.shp
    ogr2ogr -f GeoJSON $path/$indexFile-address.geojson $path/$indexFile-address.shp
    sed -i -e 's/Ã?/Ñ/g' $path/$indexFile-address.geojson
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geojsontoosm $path/$indexFile-address.geojson > $path/$indexFile-address.osm
    rm $path/$indexFile-address.geojson-e
    zip $path/address-$indexFile.zip $path/$indexFile-address*
    indexFile=$((indexFile + 1))
done < bounduary.json
