#!/usr/bin/python
import json
import ogr
import sys
driver = ogr.GetDriverByName('ESRI Shapefile')
data_source = driver.Open(sys.argv[1], 0)
fc = {
    'type': 'FeatureCollection',
    'features': []
}
lyr = data_source.GetLayer(0)
for feature in lyr:
    fc['features'].append(feature.ExportToJson(as_object=True))
    
print(json.dumps(fc))

