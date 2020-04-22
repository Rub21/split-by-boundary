# !/usr/bin/env bash
path=data
# rm -rf $path
# export MAPBOX_ACCESS_TOKEN=xx
mkdir -p data
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit bbox2fc --bbox="13.088345,52.3382448,13.7611609,52.6755087" > $path/germany.geojson
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit bbox2fc --bbox="32.810669,39.890773,32.906799,39.95607" >  $path/turkey.geojson
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
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmtogeojson \
    $path/$country-hospital.osm > $path/$country-hospital.geojson
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit addattributefc --prop "objtype=hospital" \
    $path/$country-hospital.geojson > $path/$country-hospital-fix.geojson 

    # university
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter $path/osm.osm \
    --keep="amenity=university or 
            amenity=college or 
            building=university or 
            landuse=university" > $path/$country-university.osm
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmtogeojson \
    $path/$country-university.osm > $path/$country-university.geojson
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit addattributefc --prop "objtype=university" \
    $path/$country-university.geojson > $path/$country-university-fix.geojson 

    # school
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter $path/osm.osm \
    --keep="amenity=school or 
            amenity=kindergarten or 
            building=school or 
            landuse=school or 
            building=kindergarten or 
            landuse=kindergarten" > $path/$country-school.osm
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmtogeojson \
    $path/$country-school.osm > $path/$country-school.geojson
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit addattributefc --prop "objtype=school" \
    $path/$country-school.geojson > $path/$country-school-fix.geojson 

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
            landuse=religious" > $path/$country-place_of_worship.osm
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmtogeojson \
    $path/$country-place_of_worship.osm > $path/$country-place_of_worship.geojson
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit addattributefc --prop "objtype=place_of_worship" \
    $path/$country-place_of_worship.geojson > $path/$country-place_of_worship-fix.geojson 

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
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmtogeojson \
    $path/$country-government.osm > $path/$country-government.geojson
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit addattributefc --prop "objtype=government" \
    $path/$country-government.geojson > $path/$country-government-fix.geojson 

    # transportation
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter $path/osm.osm \
    --keep="building=transportation or 
            building=train_station or 
            public_transport=transportation or 
            aeroway=hangar" > $path/$country-transportation.osm
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmtogeojson \
    $path/$country-transportation.osm > $path/$country-transportation.geojson
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit addattributefc --prop "objtype=transportation" \
    $path/$country-transportation.geojson > $path/$country-transportation-fix.geojson 

    # commercial
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter $path/osm.osm \
    --keep="building=supermarket or
            building=commercial or
            shop=supermarket or
            shop=department_store or
            shop=mall or
            landuse=commercial" > $path/$country-commercial.osm
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmtogeojson \
    $path/$country-commercial.osm > $path/$country-commercial.geojson
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit addattributefc --prop "objtype=commercial" \
    $path/$country-commercial.geojson > $path/$country-commercial-fix.geojson 

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
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmtogeojson \
    $path/$country-industry.osm > $path/$country-industry.geojson
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit addattributefc --prop "objtype=industry" \
    $path/$country-industry.geojson > $path/$country-industry-fix.geojson 

    # sport
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmfilter $path/osm.osm \
    --keep="building=stadium or
            leisure=stadium or
            leisure=sports_centre or
            leisure=fitness_centre" > $path/$country-sport.osm
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmtogeojson \
    $path/$country-sport.osm > $path/$country-sport.geojson
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit addattributefc --prop "objtype=sport" \
    $path/$country-sport.geojson > $path/$country-sport-fix.geojson 

    zip $path/$country.zip $path/$country-*.osm
    rm $path/$country-*.osm

    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geojson-merge \
        $path/$country-hospital-fix.geojson \
        $path/$country-university-fix.geojson \
        $path/$country-school-fix.geojson \
        $path/$country-place_of_worship-fix.geojson \
        $path/$country-government-fix.geojson \
        $path/$country-transportation-fix.geojson \
        $path/$country-commercial-fix.geojson \
        $path/$country-industry-fix.geojson \
        $path/$country-sport-fix.geojson  \
        > $path/$country-objs.geojson
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest tippecanoe \
    -l osm -n osm-latest -o $path/$country-objs.mbtiles -z12 -Z4 -pscfk -f $path/$country-objs.geojson
#   mapbox upload devseed.ffda-$country-objs $path/$country-objs.mbtiles
done





