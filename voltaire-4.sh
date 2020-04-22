# !/usr/bin/env bash
outputDir=data
rm -rf $outputDir
mkdir -p $outputDir

export AWS_PROFILE=devseed
countries=(
    pakistan
    zambia
    nigeria
)
for country in "${countries[@]}"; do
        aws s3 cp s3://ds-data-projects/voltaire/$country/substation/osm.geojson $outputDir/osm.geojson
        # Cover point to Polygon, 30 meters distances
        docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit fc2square \
        $outputDir/osm.geojson --radius=30 > $outputDir/osm-fixed.geojson
        # # flatten
        geojson-flatten  $outputDir/osm-fixed.geojson > $outputDir/osm-buffered.geojson
        aws s3 cp $outputDir/osm-buffered.geojson s3://ds-data-projects/voltaire/$country/substation/
        rm $outputDir/*.geojson
done
