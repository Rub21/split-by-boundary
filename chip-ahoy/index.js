const fs = require('fs');
const args = process.argv.slice(2);
let geojson = JSON.parse(fs.readFileSync(args[0], 'utf8'));
let images = JSON.parse(fs.readFileSync(args[1], 'utf8'));
let imgs = {};
images.forEach(img => {
    imgs[`(${img.replace(/-/g, ',').replace('.jpg', '')})`] = true;
});
geojson.features = geojson.features.filter(tile => {
    return imgs[tile.id];
});
console.log(JSON.stringify(geojson));
