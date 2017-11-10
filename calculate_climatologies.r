# Please check R packages

if ( !require(raster)) { install.packages("raster") }
if ( !require(rts)) { install.packages("rts") }
        
library(raster)
library(rts)


proj_32N=readRDS("projections/proj_32N.rds")
proj_3003=readRDS("projections/proj_3003.rds")

files=list.files(path="Rdata",pattern="NASA.*_UNIFI.rds",full.names=T)

data_NASA=sapply(files,readRDS)

month=c("-01-","-02-","-03-","-04-","-05-",
        "-06-","-07-","-08-","-09-","-10-",
        "-11-","-12-")

month_name=toupper(c("gen","feb","mar","apr","mag",
             "giu","lug","ago","set","ott",
             "nov","dic"))

dir.create("NASA_IBIMET_TS_tif")

#############################################################################################################################################à

index_modis_day=as.Date(gsub("_LSTday","",gsub("MOD11A2_","",unlist(lapply(data_NASA[[1]],names)))),format="%Y.%m.%d")
modis_day_TS <- rts(stack(data_NASA[[1]]),as.Date(index_modis_day))
modis_day_TS_monthly=apply.monthly(modis_day_TS,mean,na.rm=T)

id_mese=format(as.Date(index(modis_day_TS_monthly)),"%Y_%m")

for ( i in 1:length(id_mese)) {
                              writeRaster(projectRaster(modis_day_TS_monthly[[i]],crs=proj_32N),filename=paste0("NASA_IBIMET_TS_tif","/","NASA_PRIN_LST_day_",id_mese[i],".tif"))
                              }
                                
climatology_MODIS_day=list()

for (  i in 1:12) {

  id_month=grep(month[i],index(modis_day_TS_monthly))
  climatology_MODIS_day[[i]]=calc(modis_day_TS_monthly[[id_month]]@raster,mean)
  writeRaster(projectRaster(climatology_MODIS_day[[i]],crs=proj_32N),filename=paste0("NASA_IBIMET_TS_tif","/","NASA_PRIN_LST_day_",month_name[i],"_clim_2000-2017.tif"))

}

saveRDS(climatology_MODIS_day,"Rdata/NASA_PRIN_climatology_MODIS_day.rds")

#############################################################################################################################################à

index_modis_night=as.Date(gsub("_LSTnight","",gsub("MOD11A2_","",unlist(lapply(data_NASA[[2]],names)))),format="%Y.%m.%d")
modis_night_TS <- rts(stack(data_NASA[[2]]),as.Date(index_modis_night))
modis_night_TS_monthly=apply.monthly(modis_night_TS,mean,na.rm=T)

id_mese=format(as.Date(index(modis_night_TS_monthly)),"%Y_%m")

for ( i in 1:length(id_mese)) {
  writeRaster(projectRaster(modis_night_TS_monthly[[i]],crs=proj_32N),filename=paste0("NASA_IBIMET_TS_tif","/","NASA_PRIN_LST_night_",id_mese[i],".tif"))
}


climatology_MODIS_night=list()

for (  i in 1:12) {
  id_month=grep(month[i],index(modis_day_TS_monthly))
  climatology_MODIS_night[[i]]=calc(modis_night_TS_monthly[[id_month]]@raster,mean)
  writeRaster(projectRaster(climatology_MODIS_night[[i]],crs=proj_32N),filename=paste0("NASA_IBIMET_TS_tif","/","NASA_PRIN_LST_night_",month_name[i],"_clim_2000-2017.tif"))
}

saveRDS(climatology_MODIS_day,"Rdata/NASA_PRIN_climatology_MODIS_night.rds")

#############################################################################################################################################à

index_NDVI_night=as.Date(gsub("_NDVI","",gsub("MOD13Q1.006_","",unlist(lapply(data_NASA[[4]],names)))),format="%Y.%m.%d")
NDVI_TS <- rts(stack(data_NASA[[4]]),as.Date(index_NDVI_night))
NDVI_TS_monthly=apply.monthly(NDVI_TS,mean,na.rm=T)

id_mese=format(as.Date(index(NDVI_TS_monthly)),"%Y_%m")

for ( i in 1:length(id_mese)) {
  writeRaster(projectRaster(NDVI_TS_monthly[[i]],crs=proj_32N),filename=paste0("NASA_IBIMET_TS_tif","/","NASA_PRIN_NDVI_",id_mese[i],".tif"))
}

climatology_NDVI=list()

for (  i in 1:12) {
  id_month=grep(month[i],index(NDVI_TS_monthly))
  climatology_NDVI[[i]]=calc(NDVI_TS_monthly[[id_month]]@raster,mean)
  writeRaster(projectRaster(climatology_NDVI[[i]],crs=proj_32N),filename=paste0("NASA_IBIMET_TS_tif","/","NASA_PRIN_NDVI_",month_name[i],"_clim_2000-2017.tif"))
}


saveRDS( climatology_NDVI,"Rdata/NASA_PRIN_climatology_MODIS_NDVI.rds")

#############################################################################################################################################à

index_EVI_night=as.Date(gsub("_EVI","",gsub("MOD13Q1.006_","",unlist(lapply(data_NASA[[3]],names)))),format="%Y.%m.%d")
EVI_TS <- rts(stack(data_NASA[[3]]),as.Date(index_EVI_night))
EVI_TS_monthly=apply.monthly(EVI_TS,mean,na.rm=T)

id_mese=format(as.Date(index(EVI_TS_monthly)),"%Y_%m")

for ( i in 1:length(id_mese)) {
  writeRaster(projectRaster(EVI_TS_monthly[[i]],crs=proj_32N),filename=paste0("NASA_IBIMET_TS_tif","/","NASA_PRIN_EVI_",id_mese[i],".tif"))
}

climatology_EVI=list()

for (i in 1:12) {
  id_month=grep(month[i],index(EVI_TS_monthly))
  climatology_EVI[[i]]=calc(EVI_TS_monthly[[id_month]]@raster,mean)
  writeRaster(projectRaster(climatology_EVI[[i]],crs=proj_32N),filename=paste0("NASA_IBIMET_TS_tif","/","NASA_PRIN_EVI_",month_name[i],"_clim_2000-2017.tif"))
}

saveRDS(climatology_EVI,"Rdata/NASA_PRIN_climatology_MODIS_EVI.rds")

#####################################################################################################################################
if ( file.exists("DTM10K_REGTOSC.tif")) {
                 dem_reg_3003=raster("DTM10K_REGTOSC.tif")
                 proj4string(dem_reg_3003)=proj_3003
                 UNIFI_AreaInquadramento=readRDS("UNIFI_AreaInquadramento.rds")
                 UNIFI_AreaInquadramento_3003=spTransform(UNIFI_AreaInquadramento,proj_3003)
                 dem_inq=projectRaster(crop(dem_reg_3003,extent(UNIFI_AreaInquadramento_3003)),crs=proj_32N)
                 saveRDS(dem_inq,"Rdata/REGTOS_dem_area_inq.rds")
}
#####################################################################################################################################

