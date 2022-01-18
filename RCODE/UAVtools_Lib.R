
library(Thermimage)
library(exiftoolr)
library(raster)
library(tools)
library(dplyr)


getImageMetadata <- function(inputFolder, inputFileType="jpg", takeoffHeight=NULL){
  
  fl <- list.files(inputFolder,pattern = paste(".",inputFileType,"$",sep=""), full.names = TRUE)
  #print(fl)
  
  outMetaData <- matrix(NA, nrow = length(fl),ncol = 8,
                        dimnames=list(1:length(fl), 
						c("fname","alt","lat","lon","roll","yaw","pitch","ralt"))) %>% 
    as.data.frame()
  
  outMetaData <- as.data.frame(outMetaData)
  
  metaTags <- c("GPSAltitude","GPSLatitude","GPSLongitude",
                "GimbalRollDegree","GimbalYawDegree",
				"GimbalPitchDegree","RelativeAltitude")
  
  cat("\n\nRetrieving image metadata:\n\n")
  
  pb <- txtProgressBar(min=1,max=length(fl),style=3)
  
  for(i in 1:length(fl)){
    
    fname <- fl[i]
    exifInfo <- exif_read(fname, tags = metaTags)
    outMetaData[i, 1] <- basename(fname)
    outMetaData[i, 2] <- as.numeric(exifInfo[1,"GPSAltitude"])
    outMetaData[i, 3] <- as.numeric(exifInfo[1,"GPSLatitude"])
    outMetaData[i, 4] <- as.numeric(exifInfo[1,"GPSLongitude"])
    outMetaData[i, 5] <- as.numeric(exifInfo[1,"GimbalRollDegree"])
    outMetaData[i, 6] <- as.numeric(exifInfo[1,"GimbalYawDegree"])
    outMetaData[i, 7] <- as.numeric(exifInfo[1,"GimbalPitchDegree"])
	  outMetaData[i, 8] <- as.numeric(exifInfo[1,"RelativeAltitude"])

	
	
    setTxtProgressBar(pb,i)
  }
  
  
  if(!is.null(takeoffHeight)){
    outMetaData <- outMetaData %>% mutate(raltuav = takeoffHeight + ralt)
  }
  
  write.csv(outMetaData, paste(inputFolder,"/_imageMetadata.csv",sep=""),
            row.names = FALSE, quote = FALSE)
  
  return(outMetaData)
}


convertToThermalImage <- function(imgPath, outFolder, exiftoolpath="C:/exiftool/"){
  
  if(!file.exists(imgPath) | dir.exists(imgPath)){
    stop("Could not find the input image file: \n", imgPath,"!\n")
  }
  
  img  <- readflirJPG(imgPath, exiftoolpath = exiftoolpath)
  cams <- flirsettings(imgPath, exiftoolpath = exiftoolpath, camvals="")
  
  ObjectEmissivity <-  cams$Info$Emissivity              # Image Saved Emissivity - should be ~0.95 or 0.96
  dateOriginal <-      cams$Dates$DateTimeOriginal       # Original date/time extracted from file
  dateModif <-   cams$Dates$FileModificationDateTime     # Modification date/time extracted from file
  PlanckR1 <-    cams$Info$PlanckR1                      # Planck R1 constant for camera  
  PlanckB <-     cams$Info$PlanckB                       # Planck B constant for camera  
  PlanckF <-     cams$Info$PlanckF                       # Planck F constant for camera
  PlanckO <-     cams$Info$PlanckO                       # Planck O constant for camera
  PlanckR2 <-    cams$Info$PlanckR2                      # Planck R2 constant for camera
  OD <-          cams$Info$ObjectDistance                # object distance in metres
  FD <-          cams$Info$FocusDistance                 # focus distance in metres
  ReflT <-       cams$Info$ReflectedApparentTemperature  # Reflected apparent temperature
  AtmosT <-      cams$Info$AtmosphericTemperature        # Atmospheric temperature
  IRWinT <-      cams$Info$IRWindowTemperature           # IR Window Temperature
  IRWinTran <-   cams$Info$IRWindowTransmission          # IR Window transparency
  RH <-          cams$Info$RelativeHumidity              # Relative Humidity
  h <-           cams$Info$RawThermalImageHeight         # sensor height (i.e. image height)
  w <-           cams$Info$RawThermalImageWidth          # sensor width (i.e. image width)
  
  temperature <- raw2temp(img, ObjectEmissivity, OD, ReflT, AtmosT, IRWinT, IRWinTran, RH,
                        PlanckR1, PlanckB, PlanckF, PlanckO, PlanckR2)
  
  dims <- dim(temperature)
  
  # Tabulate output temperature matrix, convert to numeric, 
  # multiply by the 100 scale factor and round the values to zero decimal plates
  #
  v <- round(as.numeric(t(temperature))*100)
  
  outRaster <- raster(nrows=dims[1], ncols=dims[2], vals=v, crs=NA, 
            resolution=1, xmn=0,xmx=dims[2],ymn=0,ymx=dims[1])
  dataType(outRaster) <- "INT2S"
  
  writeRaster(outRaster, paste(outFolder,"/",file_path_sans_ext(basename(imgPath)),".tif",sep=""),
              overwrite = TRUE, datatype = "INT2S")
}



convertAllImagesToThermal <- function(inputFolder, outputFolder, inputFileType = "jpg", 
                                      exiftoolpath="C:/exiftool/"){
  
  if(inputFolder == outputFolder){
    stop("Input and ouput folders must be different!")
  }
  if(!dir.exists(inputFolder)){
    stop("inputFolder does not exists!")
  }
  if(!dir.exists(outputFolder)){
    stop("outputFolder does not exists!")
  }
  
  fl <- list.files(inputFolder,pattern = paste(".",inputFileType,"$",sep=""), full.names = TRUE)
  #print(fl)  
  
  cat("\n\nConvert radiometric image files to temperature:\n\n")
  pb <- txtProgressBar(min=1,max=length(fl),style=3)
  
  for(i in 1:length(fl)){
  
    convertToThermalImage(imgPath = fl[i], 
                          outFolder=outputFolder, 
                          exiftoolpath=exiftoolpath)
    
    setTxtProgressBar(pb,i)
  }
}




