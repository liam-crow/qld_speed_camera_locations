library(dplyr)

# https://www.data.qld.gov.au/dataset/active-mobile-speed-camera-sites/resource/f6b5c37e-de9d-4041-8c18-f4d4b6c593a8
mobile_data <- read.csv("https://www.data.qld.gov.au/dataset/0fffea7f-6988-4b73-afee-5aa8af56afd2/resource/f6b5c37e-de9d-4041-8c18-f4d4b6c593a8/download/qpsactive_parkedmscamera.csv")

# https://www.data.qld.gov.au/dataset/active-mobile-speed-camera-sites/resource/d059503f-3685-4669-8c43-df5b74da8ba8
trailer_data <- read.csv("https://www.data.qld.gov.au/dataset/0fffea7f-6988-4b73-afee-5aa8af56afd2/resource/d059503f-3685-4669-8c43-df5b74da8ba8/download/rsct_sites.csv")

street_data <- read.csv("Road location and traffic data_20190910.txt")

head(trailer_data)
head(mobile_data)

trailer_data$Type <- "Trailer Speed Camera Site"

mobile_data$Site.No <- NULL
trailer_data$Location.Code <- NULL

colnames(trailer_data) <- c("location", "type")
colnames(mobile_data)  <- c("location", "type")

merge_locations <- rbind(mobile_data, trailer_data)

head(merge_locations)

merge_split <- merge_locations %>% tidyr::separate(location, c("Street","Suburb"), sep = ", ", remove = F)
