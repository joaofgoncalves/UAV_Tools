
# Load the functions/utilities

source("./RCODE/UAVtools_Lib.R")

# Configure exif tools executable

configure_exiftoolr(
  command = "exiftool.exe",
  perl_path = NULL,
  allow_win_exe = TRUE,
  quiet = FALSE
)


# Load image metadata and use a correction of height based on the
# DJI P4 barometer

imgMeta <-  getImageMetadata(inputFolder   = "C:/Users/JG/Desktop/CG_voo_fotogrametrico-20230531-v01/",
                             inputFileType = "JPG", 
                             takeoffHeight = 109.66,
                             recursive = TRUE)

imgMeta <- imgMeta %>% mutate(ralt_uav = raltuav - 1.585)

head(imgMeta)



write.csv(imgMeta,
          "C:/Users/JG/Desktop/CG_voo_fotogrametrico-20230531-v01/_imageMetadata_v2.csv",
          row.names = FALSE)
