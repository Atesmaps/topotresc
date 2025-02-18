#!/bin/bash

echo "Creating shades"
# hill-shades
[ -d /mnt/shades ] || mkdir -p /mnt/shades
cd /mnt/shades
ogr2ogr -f GeoJSON tot_3043.geojson -s_srs EPSG:4326 -t_srs EPSG:3043 ../conf/tot.geojson
ogr2ogr -f GeoJSON andorra_3035.geojson -s_srs EPSG:4326 -t_srs EPSG:3035 ../conf/andorra.geojson
ogr2ogr -f GeoJSON tot_2154.geojson -s_srs EPSG:4326 -t_srs EPSG:2154 ../conf/tot.geojson
ogr2ogr -f GeoJSON picos_3043.geojson -s_srs EPSG:4326 -t_srs EPSG:3043 ../conf/picos.geojson

### Catalunya ###
# gdalbuildvrt -a_srs EPSG:3043 dem_cat.vrt ../dem/cat/*.txt
# gdalwarp -ts 62000 0 -multi -wo NUM_THREADS=ALL_CPUS -of GTiff  -overwrite -co COMPRESS=DEFLATE -co PREDICTOR=2 -co TILED=YES -t_srs EPSG:3857 -co BIGTIFF=YES -r bilinear -cutline tot_3043.geojson -crop_to_cutline dem_cat.vrt dem_cat.tif
# gdaldem hillshade -z 1.2 -multidirectional dem_cat.tif shades_cat.tif

### Andorra ###
echo "Andorra"
gdalwarp -overwrite -co COMPRESS=DEFLATE -co PREDICTOR=2 -co TILED=YES -t_srs EPSG:3857 -r bilinear -cutline andorra_3035.geojson -crop_to_cutline ../dem/tot25m/eu_dem_v11_E30N20.TIF dem_and.tif
gdaldem hillshade -z 1.2 -multidirectional dem_and.tif shades_and.tif

### França  ###
echo "França"
gdalbuildvrt -a_srs EPSG:2154 dem_fr.vrt ../dem/fr/*.asc
gdalwarp -ts 62000 0 -multi -wo NUM_THREADS=ALL_CPUS -of GTiff -overwrite -co COMPRESS=DEFLATE -co PREDICTOR=2 -co TILED=YES -t_srs EPSG:3857 -co BIGTIFF=YES -r bilinear  -cutline tot_2154.geojson -crop_to_cutline dem_fr.vrt dem_fr.tif
gdaldem hillshade -z 1.2 -multidirectional dem_fr.tif shades_fr.tif

### CAT + ES ###
echo "CAT + ES"
gdalbuildvrt -a_srs EPSG:25830 dem_cat_es.vrt ../dem/es/*_HU30_*.asc
gdalwarp -ts 62000 0 -multi -wo NUM_THREADS=ALL_CPUS -of GTiff -overwrite -co COMPRESS=DEFLATE -co PREDICTOR=2 -co TILED=YES -t_srs EPSG:3857 -co BIGTIFF=YES -r bilinear  -cutline tot_3043.geojson -crop_to_cutline dem_cat_es.vrt dem_cat_es.tif
gdaldem hillshade -z 1.2 -multidirectional dem_cat_es.tif shades_cat_es.tif

### Unir tots ###
echo "Creating dem_merged.tif"
gdalwarp --config GDAL_CACHEMAX 500 -wm 500 -multi -wo NUM_THREADS=ALL_CPUS -overwrite -co COMPRESS=DEFLATE -co PREDICTOR=2 -co TILED=YES -co BIGTIFF=YES -r bilinear dem_and.tif dem_fr.tif dem_cat_es.tif dem_merged.tif

### Picos ###
echo "Picos"
gdalbuildvrt -a_srs EPSG:25830 dem_picos.vrt ../dem/es/picos/*_HU30_*.asc
gdalwarp -ts 9500 0 -multi -wo NUM_THREADS=ALL_CPUS -of GTiff -overwrite -co COMPRESS=DEFLATE -co PREDICTOR=2 -co TILED=YES -t_srs EPSG:3857 -co BIGTIFF=YES -r bilinear  -cutline picos_3043.geojson -crop_to_cutline dem_picos.vrt dem_picos.tif
gdaldem hillshade -z 1.2 -multidirectional dem_picos.tif shades_picos.tif

# merge all shades
gdalbuildvrt shades_merged.vrt shades_and.tif shades_fr.tif shades_cat_es.tif shades_picos.tif

echo "Creating color_relief"
gdaldem color-relief -of PNG dem_merged.tif ../conf/color_relief.txt color_relief.tif
gdaldem color-relief -of PNG dem_picos.tif ../conf/color_relief.txt color_relief_picos.tif
gdalbuildvrt color_relief.vrt color_relief.tif color_relief_picos.tif
