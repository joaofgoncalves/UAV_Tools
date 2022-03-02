
# UAV Tools


Tools for processing DJI's image data from Unoccupied Aerial Vehicles (UAV) in R:


| Function name                   | Description                                               |
|:--------------------------------|:----------------------------------------------------------|
| _getImageMetadata()_            | Retrieves geographical metadata from DJI images and enables altitude corrections  to be applied based on barometric heights (useful for Phantom 4 for instance - see tutorial below)                                                    |
| _convertToThermalImage()_       | Retrieves metadata from DJI thermal imagery and converts raw thermal data into temperature (°C)                    |
| _convertAllImagesToThermal()_   | Converts all thermal images in a folder from raw thermal data into temperature (°C)                                |



# TUTORIALS

## I. Running altitude corrections in Agisoft Metashape using image exif metadata and barometric height measurements

## Required tools

- Install R | https://cran.r-project.org/bin/windows/base

- Install RStudio Desktop | https://www.rstudio.com 

- Install exifTool | https://exiftool.org 

- Install required R packages (run the line below in the R console): `` install.packages(c("Thermimage", "exiftoolr", "dplyr", "raster", "tools")) ``

- Install Git (optional) | https://git-scm.com/downloads 


## Pre-processing preparation

Get take-off ground height for the home point coordinates using a Digital Elevation Model (DEM).

Input that value in function ``getImageMetadata()`` parameter _takeoffHeight_


## Processing in R

- Download/clone the repository from: https://github.com/joaofgoncalves/UAV_Tools. To clone the repository open the command line and do: 

``git clone https://github.com/joaofgoncalves/UAV_Tools``

- Go to the repository and open the RStudio project file: UAV_Tools.Rproj

- Open/Load script_getImageMetadata.R in RStudio

- Set exiftool.exe location in function ``configure_exiftool()``

- Define the input folder where the UAV images are located and take-off height in the script

- Run the script (Source) … this will take a few minutes


## Running Agisoft Metashape

- Workflow > Add photos > Add Folder

- Go to Chunk > Import > Import Reference > Go to file _imageMetadata.csv inside the photos folder 
   - Check if the Coordinate System is defined as WGS 84
   - Set the columns correctly 


Now, run the remaining workflow 

- Align Photos

- Build Dense Cloud

- Build DEM

- Build Orthomosaic



