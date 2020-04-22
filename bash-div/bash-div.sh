# !/usr/bin/env bash
#from lxml import etree
path=data
mkdir -p data

#div file --> number of boundaries that you want
docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit fc2frows div.geojson > $path/row.json

#classification_dar should be on osm format, chance the format with JOSM (when I use geojsontoosm script doesn't work, the tool joins the girds)
i=0
while IFS= read -r line; do
    echo $line > $path/feature.json
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geojson2poly $path/feature.json  $path/feature.poly
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest osmconvert \
     $path/classification_dar.osm -B=$path/feature.poly -o=$path/classification_dar-$i.osm        
    docker run --rm -v ${PWD}:/mnt/data developmentseed/geokit:latest geokit osm2new \
     $path/classification_dar-$i.osm $path/classification_dar-$i-new.osm
    rm $path/classification_dar-$i.osm
    i=$(($i + 1))
done < $path/row.json
