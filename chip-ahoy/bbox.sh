# !/usr/bin/env bash

rm -rf data/
mkdir -p data/
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit bbox2fc --bbox="13.088345,52.3382448,13.7611609,52.6755087" > data/berlin.geojson
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit bbox2fc --bbox="28.575611,40.797731,29.363880,41.208139" >  data/istanbul.geojson
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit bbox2fc --bbox="106.68411,-6.3773566,106.99242,-6.0667737" >  data/jakarta.geojson
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit bbox2fc --bbox="39.184456,-6.8790072,39.356117,-6.7317368" >  data/dar.geojson

cities=(dar istanbul jakarta berlin)
for city in "${cities[@]}"; do
   # Get all the tiles for the city
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit tilecover data/$city.geojson --zoom=18 > data/_tiles.geojson
    # download labels.npz 
    aws s3 cp s3://ds-data-projects/FFDA/zoom-18/$city/labels.npz data/
    # split the clases, result in as a json file
    python read.py
    # Get the classes tiles
    node index.js data/_tiles.geojson data/_hospital.json > data/$city-hospital-18.geojson
    node index.js data/_tiles.geojson data/_residential.json > data/$city-residential-18.geojson
    node index.js data/_tiles.geojson data/_sports.json > data/$city-sports-18.geojson
    node index.js data/_tiles.geojson data/_industry.json > data/$city-industry-18.geojson
    node index.js data/_tiles.geojson data/_commercial.json > data/$city-commercial-18.geojson
    node index.js data/_tiles.geojson data/_transportation.json > data/$city-transportation-18.geojson
    node index.js data/_tiles.geojson data/_government.json > data/$city-government-18.geojson
    node index.js data/_tiles.geojson data/_place_of_worship.json > data/$city-place_of_worship-18.geojson
    node index.js data/_tiles.geojson data/_school.json > data/$city-school-18.geojson
    node index.js data/_tiles.geojson data/_university.json > data/$city-university-18.geojson
    # remove files
    rm data/_*
    rm  data/labels.npz
    # upload files
    aws s3 sync data/ s3://ds-data-projects/FFDA/zoom-18/$city/classes/ --exclude "*" --include "$city-*-18.geojson"
done