# !/usr/bin/env bash

rm -rf data/
mkdir -p data/
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit bbox2fc --bbox="13.088345,52.3382448,13.7611609,52.6755087" > data/berlin.geojson
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit bbox2fc --bbox="28.575611,40.797731,29.363880,41.208139" >  data/istanbul.geojson
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit bbox2fc --bbox="106.68411,-6.3773566,106.99242,-6.0667737" >  data/jakarta.geojson
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit bbox2fc --bbox="39.184456,-6.8790072,39.356117,-6.7317368" >  data/dar.geojson

cities=(dar istanbul jakarta berlin)
for city in "${cities[@]}"; do
   # Dar 17
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit tilecover data/$city.geojson --zoom=17 > data/tiles-$city-17.geojson
    echo "image"  > data/tiles-$city-17.csv
    aws s3 ls s3://ds-data-projects/FFDA/zoom-17/$city/tiles/ | awk '{print $4}'  >> data/tiles-$city-17.csv
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest csvjson data/tiles-$city-17.csv > data/tiles-$city-17.json
    node index.js data/tiles-$city-17.geojson  data/tiles-$city-17.json > data/$city-chip-ahoy-17.geojson

    # Dar 18
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit tilecover data/$city.geojson --zoom=18 > data/tiles-$city-18.geojson
    echo "image"  > data/tiles-$city-18.csv
    aws s3 ls s3://ds-data-projects/FFDA/zoom-18/$city/tiles/ | awk '{print $4}'  >> data/tiles-$city-18.csv
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest csvjson data/tiles-$city-18.csv > data/tiles-$city-18.json
    node index.js data/tiles-$city-18.geojson  data/tiles-$city-18.json > data/$city-chip-ahoy-18.geojson
done