# !/usr/bin/env bash
path=data
# rm -rf $path
# export MAPBOX_ACCESS_TOKEN=xx
mkdir -p data
wget http://download.geofabrik.de/africa/tanzania-latest.osm.pbf -O data/pakistan.pbf 

countries=(
    pakistan
)

for country in "${countries[@]}"; do
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmosis --read-pbf file=$path/$country.pbf --write-xml $path/osm.osm
    # power_polygon
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter $path/osm.osm \
    --keep="power=tower or 
            tower=pole" > $path/$country-power_polygon.osm
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmtogeojson \
    $path/$country-power_polygon.osm > $path/$country-power_polygon.geojson
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit addattributefc --prop "objtype=power_polygon" \
    $path/$country-power_polygon.geojson > $path/$country-power_polygon-fix.geojson 

    # university
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter $path/osm.osm \
    --keep="power=plant" > $path/$country-power_plant.osm
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmtogeojson \
    $path/$country-power_plant.osm > $path/$country-power_plant.geojson
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit addattributefc --prop "objtype=power_plant" \
    $path/$country-power_plant.geojson > $path/$country-power_plant-fix.geojson 

    # power_substation
   docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter $path/osm.osm \
     --keep="power=substation or 
            substation=transmission" > $path/$country-power_substation.osm
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmtogeojson \
    $path/$country-power_substation.osm > $path/$country-power_substation.geojson
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit addattributefc --prop "objtype=power_substation" \
    $path/$country-power_substation.geojson > $path/$country-power_substation-fix.geojson 


    # cooling_tower
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter $path/osm.osm \
    --keep="man_made=cooling_tower or 
            tower:type=cooling" > $path/$country-cooling_tower.osm
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmtogeojson \
    $path/$country-cooling_tower.osm > $path/$country-cooling_tower.geojson
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit addattributefc --prop "objtype=cooling_tower" \
    $path/$country-cooling_tower.geojson > $path/$country-cooling_tower-fix.geojson 

    # communications_tower
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter $path/osm.osm \
    --keep="man_made=communications_tower" > $path/$country-communications_tower.osm
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmtogeojson \
    $path/$country-communications_tower.osm > $path/$country-communications_tower.geojson
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit addattributefc --prop "objtype=communications_tower" \
    $path/$country-communications_tower.geojson > $path/$country-communications_tower-fix.geojson 
    zip $path/$country.zip $path/$country-*.osm
    rm $path/$country-*.osm
    
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geojson-merge \
        $path/$country-power_polygon-fix.geojson \
        $path/$country-power_plant-fix.geojson \
        $path/$country-power_substation-fix.geojson \
        $path/$country-cooling_tower-fix.geojson \
        $path/$country-communications_tower-fix.geojson \
        > $path/$country-objs.geojson
done





