
library(plotly)
library(viridis)


source("./RCODE/UAVtools_Lib.R")


configure_exiftoolr(
  command = "exiftool.exe",
  perl_path = NULL,
  allow_win_exe = TRUE,
  quiet = FALSE
)

  
#imgPaths <- list.files("FLIR_data", full.names = TRUE)
imgPaths <- list.files("G:/O meu disco/Alqueva/Alqueva_20230720/term", full.names = TRUE,pattern=".JPG$")

pb <- txtProgressBar(1,length(imgPaths), style=3)
  

 
for(i in seq_along(imgPaths)){
    
    imgPath <- imgPaths[i]
    
    timg <- suppressWarnings(
              convertToThermalImage(imgPath, 
                                  outFolder="G:/O meu disco/Alqueva/Alqueva_20230720/term_raw", 
                                  exiftoolpath=paste0(getwd(),"/")))
    
    # png(filename = paste0("./OUT/FLIR_Thermal_",i,".png"), res=300, width=3000, height=3800)
    # plot(timg/100, col=magma(200))#col=heat.colors(100))
    # dev.off()
    setTxtProgressBar(pb, i)
}
  
