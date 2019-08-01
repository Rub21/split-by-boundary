import numpy as np
import json

data = np.load('data/labels.npz')
lst = data.files
classes = {
    'hospital': [],
    'university': [],
    'school': [],
    'place_of_worship': [],
    'government': [],
    'transportation': [],
    'commercial': [],
    'industry': [],
    'sports': [],
    'residential': []
}
for item in lst:
    if data[item][1]==1: classes["hospital"].append(item)
    if data[item][2]==1: classes["university"].append(item)
    if data[item][3]==1: classes["school"].append(item)
    if data[item][4]==1: classes["place_of_worship"].append(item)
    if data[item][5]==1: classes["government"].append(item)
    if data[item][6]==1: classes["transportation"].append(item)
    if data[item][7]==1: classes["commercial"].append(item)
    if data[item][8]==1: classes["industry"].append(item)
    if data[item][9]==1: classes["sports"].append(item)
    if data[item][10]==1: classes["residential"].append(item)
data.close()

for c in classes:
    with open("data/_" + c + ".json", 'w') as f:
        json.dump(classes[c], f)