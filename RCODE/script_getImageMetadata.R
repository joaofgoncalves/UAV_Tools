
# Load the functions/utilities

source("UAVtools_Lib.R")

# Configure exif tools executable

configure_exiftoolr(
  command = "exiftool.exe",
  perl_path = NULL,
  allow_win_exe = TRUE,
  quiet = FALSE
)


# Load image metadata and use a correction of height based on the
# DJI P4 barometer

imgMeta <-  getImageMetadata(inputFolder   = "./MySurveyData",
                             inputFileType = "JPG", 
                             takeoffHeight = 70)
