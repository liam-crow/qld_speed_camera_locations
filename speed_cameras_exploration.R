library(dplyr)
library(stringr)

# https://www.data.qld.gov.au/dataset/active-mobile-speed-camera-sites/resource/f6b5c37e-de9d-4041-8c18-f4d4b6c593a8
mobile_data <- read.csv("https://www.data.qld.gov.au/dataset/0fffea7f-6988-4b73-afee-5aa8af56afd2/resource/f6b5c37e-de9d-4041-8c18-f4d4b6c593a8/download/qpsactive_parkedmscamera.csv")

# https://www.data.qld.gov.au/dataset/active-mobile-speed-camera-sites/resource/d059503f-3685-4669-8c43-df5b74da8ba8
trailer_data <- read.csv("https://www.data.qld.gov.au/dataset/0fffea7f-6988-4b73-afee-5aa8af56afd2/resource/d059503f-3685-4669-8c43-df5b74da8ba8/download/rsct_sites.csv")

suburb_lat_long <- read.csv("Australian_Post_Codes_Lat_Lon.csv") %>% filter(state == "QLD")

# street_data <- read.csv("Road location and traffic data_20190910.txt")
# sd_filt <- street_data %>% 
#   filter(Longitude >= 152.5) %>% 
#   sample_frac(0.1)
# 
# # par(pty="s")
# with(
#   sd_filt,
#   plot(Longitude, Latitude)
# )

head(trailer_data)
head(mobile_data)

trailer_data$Type <- "Trailer Speed Camera Site"

mobile_data$Site.No <- NULL
trailer_data$Location.Code <- NULL

colnames(trailer_data) <- c("location", "type")
colnames(mobile_data)  <- c("location", "type")

merge_locations <- rbind(mobile_data, trailer_data)

head(merge_locations)

merge_split <- merge_locations %>% tidyr::separate(location, c("street","suburb"), sep = ", ", remove = F)

merge_split$suburb <- str_to_lower(merge_split$suburb)
suburb_lat_long$suburb <- str_to_lower(suburb_lat_long$suburb)

loc_join <- merge_split %>% left_join(suburb_lat_long, by = c("suburb"))

library(leaflet)
leaflet(data = loc_join %>% distinct()) %>% addTiles() %>% 
  addMarkers(~lon, ~lat, 
             popup = ~as.character(location), label = ~as.character(location),
             clusterOptions = markerClusterOptions(freezeAtZoom = 9))

