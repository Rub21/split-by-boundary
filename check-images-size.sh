# !/usr/bin/env bash
path=/tmp/data
mkdir -p $path
BUCKET_FOLDER=s3://wbg-geography01/GEP/DRONE/JUCHITAN/
aws s3 ls $BUCKET_FOLDER | awk '{print $2}'  > $path/images.csv
echo "folder, imagen, size, s3" > $path/results.csv
while IFS= read -r line; do
    echo $path/$line
    # aws s3 sync $BUCKET_FOLDER$line $path/$line --exclude "*" --include "000021_*.jpg"
    for i in {0..5}
    do
        aws s3 cp $BUCKET_FOLDER${line}000035_Cam${i}.jpg $path/$line
        size=$(exiftool -b $path/${line}000035_Cam${i}.jpg  -ImageSize)
        echo $line, ${line}000035_Cam${i}.jpg, $size, $BUCKET_FOLDER${line}000035_Cam${i}.jpg >> $path/results.csv
    done
done < $path/images.csv
