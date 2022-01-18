
source("C:/MyFiles/R-dev/UAV_Tools/RCODE/UAVtools_Lib.R")

configure_exiftoolr(
  command = "C:/Anaconda3/exiftool.exe",
  perl_path = NULL,
  allow_win_exe = TRUE,
  quiet = FALSE
)

imgMeta <- 
  getImageMetadata(inputFolder = "C:/Users/JG/Desktop/TESTE_CARRECO/pics/v1",
                   inputFileType = "JPG", takeoffHeight = 49.28)



