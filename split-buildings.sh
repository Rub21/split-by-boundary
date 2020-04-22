# !/usr/bin/env bash
outputDir=data-padang
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit fc2frows \
$outputDir/landuses.geojson > $outputDir/polygons.json

# Clip
indexFile=1
mkdir -p $outputDir/shp

while IFS= read -r line; do
    # echo $indexFile
    # echo "$line" > $outputDir/shp/$indexFile.json
    # ogr2ogr -f "ESRI Shapefile" $outputDir/shp/$indexFile.shp $outputDir/shp/$indexFile.json
    # python shp2geojson.py $outputDir/shp/$indexFile.shp > $outputDir/$indexFile-polygon.json
    # ogr2ogr -clipsrc $outputDir/shp/$indexFile.shp $outputDir/shp/padang-$indexFile-cliped.shp $outputDir/padang.shp
    # python shp2geojson.py $outputDir/shp/padang-$indexFile-cliped.shp > $outputDir/padang-$indexFile-cliped.geojson
    numfeatures=$(grep -o "properties" $outputDir/padang-$indexFile-cliped.geojson | wc -l)
    echo $indexFile, $numfeatures, $outputDir/padang-$indexFile-cliped.geojson
    indexFile=$((indexFile + 1))
done < $outputDir/polygons.json