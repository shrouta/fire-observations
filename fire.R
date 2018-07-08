# Load Packages
library(plyr)

# Call data
fire_data_VIIRS <- read.csv(url("https://firms.modaps.eosdis.nasa.gov/active_fire/viirs/text/VNP14IMGTDL_NRT_USA_contiguous_and_Hawaii_7d.csv"))

fire_data_MODIS <- read.csv(("https://firms.modaps.eosdis.nasa.gov/active_fire/c6/text/MODIS_C6_USA_contiguous_and_Hawaii_7d.csv"))

# Subset data
fire_data_MODIS <- rename(fire_data_MODIS, c("bright_t31"="bright"))

fire_data_VIIRS <- rename(fire_data_VIIRS, c("bright_ti5"="bright"))
fire_vars <- c("latitude", "longitude", "acq_time", "acq_date", "bright")

fire_data_MODIS <- fire_data_MODIS[fire_vars]
fire_data_VIIRS <- fire_data_VIIRS[fire_vars]

fire_data <- rbind(fire_data_MODIS, fire_data_VIIRS)

# Limit the fire observations to Southern Oregon/Northern California. Can be changed for other fire observations.
fire_klamathon <- fire_data[ which(fire_data$latitude > 40 & fire_data$latitude < 42 & fire_data$longitude < -119), ]

# Date and Time
fire_klamathon$acq_time_std <- format( as.POSIXct(Sys.Date()) + fire_klamathon$acq_time*60, format="%H:%M:%S", tz="UCT")

fire_klamathon$date_time <- as.POSIXct(paste(fire_klamathon$acq_date, fire_klamathon$acq_time_std), format="%Y-%m-%d %H:%M:%S")

write.csv(fire_klamathon, file="fire_klamathon.csv")
