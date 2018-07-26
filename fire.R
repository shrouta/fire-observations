# Load Packages
library(plyr)
library(geojsonio)

# Sets the geographic parameters of the fire - change these to focus the map on different fires. Enter these as latitude and longitude in signed degree format.
# Northern bound
LatBoundN <- SET THIS

# Southern bound
LatBoundS <- SET THIS

# Western Bound
LonBoundW <- SET THIS
  
# Eastern Bound
LonBoundE <- SET THIS

# Calls all fire hotspot data from MODIS and VIIRS
fire_data_VIIRS <- read.csv(url("https://firms.modaps.eosdis.nasa.gov/active_fire/viirs/text/VNP14IMGTDL_NRT_USA_contiguous_and_Hawaii_7d.csv"))

fire_data_MODIS <- read.csv(("https://firms.modaps.eosdis.nasa.gov/active_fire/c6/text/MODIS_C6_USA_contiguous_and_Hawaii_7d.csv"))

# Concatenates MODIS and VIIRS data so that brightness (proxy for fire intensity) can be combined
fire_data_MODIS <- rename(fire_data_MODIS, c("bright_t31"="bright"))

fire_data_VIIRS <- rename(fire_data_VIIRS, c("bright_ti5"="bright"))
fire_vars <- c("latitude", "longitude", "acq_time", "acq_date", "bright")

fire_data_MODIS <- fire_data_MODIS[fire_vars]
fire_data_VIIRS <- fire_data_VIIRS[fire_vars]

fire_data <- rbind(fire_data_MODIS, fire_data_VIIRS)

# Limit the fire observations.
fire_specific <- fire_data[ which(fire_data$latitude > LatBoundS & fire_data$latitude < LatBoundN & fire_data$longitude < LonBoundW & fire_data$longitude < LonBoundE), ]

# Creates a date and time variable for use by leaflet
fire_specific$acq_time_std <- format( as.POSIXct(Sys.Date()) + fire_klamathon$acq_time*60, format="%H:%M:%S", tz="UCT")

fire_specific$time <- as.POSIXct(paste(fire_klamathon$acq_date, fire_klamathon$acq_time_std), format="%Y-%m-%d %H:%M:%S")

# Outputs CSV and GEOJSON data
write.csv(fire_specific, file="fire-leaflet/data/fire.csv")
geojson_write(fire_specific, file="fire-leaflet/data/fire")
