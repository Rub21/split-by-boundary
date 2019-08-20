# !/usr/bin/env bash
path=data
# rm -rf $path
mkdir -p data
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit bbox2fc --bbox="13.088345,52.3382448,13.7611609,52.6755087" > $path/germany.geojson
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit bbox2fc --bbox="28.575611,40.797731,29.363880,41.208139" >  $path/turkey.geojson
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit bbox2fc --bbox="106.68411,-6.3773566,106.99242,-6.0667737" >  $path/indonesia.geojson
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit bbox2fc --bbox="39.184456,-6.8790072,39.356117,-6.7317368" >  $path/tanzania.geojson

wget http://download.geofabrik.de/africa/tanzania-latest.osm.pbf -O data/tanzania.pbf 
wget http://download.geofabrik.de/asia/indonesia-latest.osm.pbf -O data/indonesia.pbf
wget http://download.geofabrik.de/europe/turkey-latest.osm.pbf -O data/turkey.pbf
wget http://download.geofabrik.de/europe/germany-latest.osm.pbf -O data/germany.pbf

countries=(
    tanzania
    germany
    turkey
    indonesia
)

for country in "${countries[@]}"; do
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geojson2poly $path/$country.geojson $path/bounduary.poly
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmconvert $path/$country.pbf -B=$path/bounduary.poly -o=$path/clip-$country.pbf
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmosis --read-pbf file=$path/clip-$country.pbf --write-xml $path/osm.osm
    # Hospitals
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter $path/osm.osm \
    --keep="amenity=hospital or 
            amenity=clinic or 
            buildin=hospital or 
            landuse=hospital" > $path/$country-hospital.osm

    # university
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter $path/osm.osm \
    --keep="amenity=university or 
            amenity=college or 
            building=university or 
            landuse=university" > $path/$country-university.osm

    # school
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter $path/osm.osm \
    --keep="amenity=school or 
            amenity=kindergarten or 
            building=school or 
            landuse=school or 
            building=kindergarten or 
            landuse=kindergarten" > $path/$country-school.osm
    
    # place_of_worship
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter $path/osm.osm \
    --keep="building=place_of_worship or 
            building=church or 
            building=cathedral or 
            building=chapel or 
            building=mosque or 
            building=synagogue or 
            building=temple or 
            building=shrine or 
            amenity=place_of_worship or 
              landuse=place_of_worship or 
            landuse=religious" > $path/$country-school.osm

    # government
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter $path/osm.osm \
    --keep="building=government or 
            building=civic or 
            amenity=courthouse or 
            office=government or 
            government=ministry or 
            government=prosecutor or 
            government=tax or 
            government=register_office or 
            office=administrative or 
            amenity=library or 
            amenity=community_centre or 
            amenity=townhall" > $path/$country-government.osm
    
    # transportation
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter $path/osm.osm \
    --keep="building=transportation or 
            building=train_station or 
            public_transport=transportation or 
            aeroway=hangar" > $path/$country-transportation.osm
    
    # commercial
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter $path/osm.osm \
    --keep="building=supermarket or
            building=commercial or
            shop=supermarket or
            shop=department_store or
            shop=mall or
            landuse=commercial" > $path/$country-commercial.osm

    # industry
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter $path/osm.osm \
    --keep="building=industrial or
            building=warehouse or
            building=production_hall or
            building=high_bay_warehouse or
            landuse=industrial or
            power=plant or
            power=substation or
            power=station" > $path/$country-industry.osm

    # sport
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter $path/osm.osm \
    --keep="building=stadium or
            leisure=stadium or
            leisure=sports_centre or
            leisure=fitness_centre" > $path/$country-sport.osm
    zip $path/$country.zip $path/$country-*.osm
    rm $path/$country-*.osm
done