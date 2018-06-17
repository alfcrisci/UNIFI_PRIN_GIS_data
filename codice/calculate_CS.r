library(raster)

setwd("/home/alf/alf_github/UNIFI_PRIN_raster_data/ISPRA_CS")

diff_CS=raster("ISPRA_CS_2015.tif")-raster("ISPRA_CS_2012.tif")
writeRaster(diff_CS,"ISPRA_CS_diff_2015_2012.tif")

diff_CS=raster("ISPRA_CS_2016.tif")-raster("ISPRA_CS_2015.tif")
writeRaster(diff_CS,"ISPRA_CS_diff_2016_2015.tif")