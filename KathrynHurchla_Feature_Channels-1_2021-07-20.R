#To cite Redlistr or acknowledge its use, cite this Software note as follows, substituting the version of the application that you used for ‘version 0’:
#  Lee, C. K. F., Keith, D. A., Nicholson, E. and Murray, N. J. 2019. Redlistr: tools for the IUCN Red Lists of ecosystems and threatened species in R. – Ecography 42: 1050–1055 (ver. 0).

setwd("/Users/kathrynhurchla/Documents/GitHub/threatened-species")
getwd()

#install.packages("gganimate")
library(gganimate)
#gifski package for gif support with gganimate
#install.packages('gifski')
library(gifski)
#av package for av output from gganimate
#install.packages('av')
library(av)
library(ggplot2)
#dplyr for piping and help with dataframes
library(dplyr)
#install.packages('ggthemes')
library(ggthemes)
#To use the Colorblind Color Palette (Discrete) Scales from ggthemes
library(scales)
#library(rgeos)
#library(rgdal)
#install.packages("redlistr")
#library(redlistr)
#library(stringr)

## load the CSV file of points data (contains x,y plot coordinates) to a variable, downloaded from: 
##https://www.iucnredlist.org/resources/spatial-data-download
##Freshwater Groups (not comprehensive)
##All freshwater species.
##point  <10MB
#fwpoints <- read.csv("data/FW_GROUP_points.csv")

##Followed guidance on converting text file to a shapefile from: https://datacarpentry.org/r-raster-vector-geospatial/10-vector-csv-to-shapefile-in-r/
##Use str function to compactly display the internal structure of new variable R object
#str(fwpoints)
#head(fwpoints)
#summary(fwpoints)

##check column names
#names(fwpoints)

##Confirm the columns latitude and longitude contain spatial information.
#head(fwpoints$latitude)
#head(fwpoints$longitude)

## Metadata file that was downloaded with data cites a WGS_1984 Datum unprojected CRS
## Looked up the Proj4 for this at: https://www.spatialreference.org/ref/sr-org/14/#:~:text=Readable%20OGC%20WKT-,Proj4,-OGC%20WKT
## Per this updated tutorial, proj4 is outdated best practice, but mentions only shape files: https://inbo.github.io/tutorials/tutorials/spatial_crs_coding/

##I'm not sure how to write the CRS syntax, so skipping this for now. 
##We will need more researh or support to change this to a spatial file in order to use the redlistr library in the future.
#uprojWGS_1984 <- +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs

#fwpointssf <- st_as_sf(fwpoints, coords = c("latitude", "longitude"))

#??stack.SpatialPointsDataFrame

##Import data as a shapefile (.shp), we can use the rgdal::readOGR function.
#my.shapefile <- readOGR('./path/to/folder/', 'shapefile.shp')

# load the CSV file of points data to a variable, downloaded from: 
#https://www.iucnredlist.org/search/list
#filtered for Land regions = Sub-Saharan Africa and Marine Regions = Western Indian Ocean
subsahafr = read.csv("data/redlist_species_data_86de0f6e-a389-42af-bea4-15e2e992f905/points_data.csv")
summary(subsahafr)
head(subsahafr)

#Take a sum of the presence column containing number ones in each row, grouped by binomial
#Using aggregate:
aggregate(subsahafr$presence, by=list(Binomial=subsahafr$binomial, Legend=subsahafr$legend), FUN=sum)
  
#You can also use the dplyr package for that purpose with a pipe:
subsum <- subsahafr %>% 
  group_by(legend, binomial, year) %>% 
  summarise(Presence = sum(presence))

# try a quick scatter plot sized by presence of species
graph1 <- subsum %>%
  ggplot(aes(x=year, y=binomial, color=legend, size=Presence)) +
  geom_point()
graph1

# try a quick bargraph
f <- ggplot(subsahafr, aes(presence, binomial))
f + geom_col()

# try a dot plot
graph2 <- ggplot(subsum, aes(x = year)) +
  geom_dotplot(binwidth = 0.9) +
  scale_y_continuous(NULL, breaks = NULL)
graph2

subsum

#habitat and ecology
system <- c('Marine', 
            'Marine', 
            'Terrestrial, Marine', 
            'Marine', 
            'Marine', 
            'Freshwater (=Inland waters), Marine', 
            'Freshwater (=Inland waters), Marine', 
            'Marine', 
            'Freshwater (=Inland waters), Marine')
#IUCN RED LIST CATEGORY
status <- c('Endangered', 
            'Vulnerable', 
            'Vulnerable', 
            'Endangered', 
            'Endangered', 
            'Least Concern', 
            'Least Concern', 
            'Near Threatened', 
            'Least Concern') 
#geographic range
native <- c('Mauritius', 
            'Mauritius', 
            'Various', 
            'Mauritius', 
            'Mauritius', 
            'Various', 
            'Various', 
            'Mozambique; South Africa (KwaZulu-Natal)', 
            'Various')
threats <- c('Energy production & mining', 
             'Energy production & mining', 
             'Residential & commercial development, Agriculture & aquaculture, Biological resource use, Invasive and other problematic species, genes & diseases, Geological events, Climate change & severe weather', 
             'Energy production & mining', 
             'Energy production & mining', 
             'Biological resource use, Pollution', 
             'Natural system modifications, Pollution', 
             'Residential & commercial development, Energy production & mining, Pollution, Climate change & severe weather', 
             'Biological resource use')
#taxonomy
phylum <- c('Mollusca', 
            'Mollusca', 
            'Arthropoda', 
            'Mollusca', 
            'Mollusca', 
            'Chordata', 
            'Chordata', 
            'Tracheophyta', 
            'Chordata')
# known as
name <- c('Indian Ocean Punk-rock Snail', 
          'Indian Ocean Vent Mussel', 
          'Coconut Crab', 
          'Scaly-foot Snail', 
          'Indian Ocean Cinderella Snail', 
          'Paintedfin Goby', 
          'Girdled Goby', 
          'Thalassodendron leptocaule', 
          'Bigeye Trevally')
# Population trend
trend <- c('Unknown', 
           'Unknown', 
           'Decreasing', 
           'Unknown', 
           'Unknown', 
           'Unknown', 
           'Stable', 
           'Stable', 
           'Decreasing')

#duplicate dataframe
subsum1 <- subsum
#add vectors above as new columns with $-Operator
subsum1$system <- system

#test it
subsum1

#add the rest of the columns
subsum1$phylum <- phylum
subsum1$name <- name
subsum1$native <- native
subsum1$status <- status
subsum1$trend <- trend
subsum1$threats <- threats
#view updated dataframe
subsum1

#run dotplot again on this updated dataframe
graph3 <- ggplot(subsum1, aes(x = year, fill = factor(status))) +
  geom_dotplot(stackgroups = TRUE, binwidth = 0.8, binpositions = "all") +
  #hide y axis label 'count' which is not meaningful, and will be described in title
  scale_y_continuous(NULL, breaks = NULL) +
  #show every second x axis label (to correct the decimals 2018.5, 2019.5, that were showing without this)
  scale_x_continuous(breaks = subsum1$year[seq(1, length(subsum1$year), by =2)]) +
  #add Theme with nothing other than a background color
  #theme_solid(fill = "white")
  #add Theme inspired by fivethirtyeight.com plots
  theme_fivethirtyeight() + 
  #add colorblind scale theme for dot fills
  scale_fill_colorblind() +
  #hide legend for fill, which will be labelled once on first top dots appearing of each color
  guides(fill = FALSE) +
  #add source caption with a line break
  labs(caption = "Source: The IUCN Red List of Threatened Species.\nVersion 2021-1. https://www.iucnredlist.org") +
  # add visual breathing room between caption and x axis labels
  theme(plot.caption = element_text(vjust = - 5, size = 12)) + #Change position downwards
  #hide major grid lines (x axis lines; fivethirtyeight theme had hidden the y axis grid lines already)
  theme(panel.grid.major = element_blank()) +
  #set font size of x axis labels (years)
  theme(axis.text.x = element_text(size = 16)) +
  annotate(geom = "text", x = 2019.5, y = 3, label = "Vulnerable", hjust = "left", size = 6) +
  annotate(geom = "text", x = 2019.5, y = 2.475, label = "Near\nThreatened", hjust = "left", size = 6) +
  annotate(geom = "text", x = 2019.5, y = 2.0175, label = "Least\nConcern", hjust = "left", size = 6) +
  annotate(geom = "text", x = 2019.5, y = 1.225, label = "Endangered", hjust = "left", size = 6) 

graph3


#run as a scatterplot in order to incorporate shapes
#change point shapes and colors
graph3 <- ggplot(subsum1, aes(x = year, y = Presence, group = system)) +
  geom_point(aes(shape = system, color = status, size = Presence)) +
 
  #hide y axis label 'count' which is not meaningful, and will be described in title
  #scale_y_continuous(NULL, breaks = NULL) +
  #show every second x axis label (to correct the decimals 2018.5, 2019.5, that were showing without this)
  scale_x_continuous(breaks = subsum1$year[seq(1, length(subsum1$year), by =2)]) +
  #add Theme with nothing other than a background color
  #theme_solid(fill = "white")
  #add Theme inspired by fivethirtyeight.com plots
  theme_fivethirtyeight() + 
  #add colorblind scale theme for dot fills
  scale_color_colorblind() +
  #hide legend for fill, which will be labelled once on first top dots appearing of each color
  guides(fill = FALSE) +
  #add source caption with a line break
  labs(caption = "Source: The IUCN Red List of Threatened Species.\nVersion 2021-1. https://www.iucnredlist.org") +
  # add visual breathing room between caption and x axis labels
  theme(plot.caption = element_text(vjust = - 5, size = 12)) + #Change position downwards
  #hide major grid lines (x axis lines; fivethirtyeight theme had hidden the y axis grid lines already)
  theme(panel.grid.major = element_blank()) +
  #set font size of x axis labels (years)
  theme(axis.text.x = element_text(size = 12)) 
  #annotate(geom = "text", x = 2019.5, y = 3, label = "Vulnerable", hjust = "left", size = 6) +
  #annotate(geom = "text", x = 2019.5, y = 2.475, label = "Near\nThreatened", hjust = "left", size = 6) +
  #annotate(geom = "text", x = 2019.5, y = 2.0175, label = "Least\nConcern", hjust = "left", size = 6) +
  #annotate(geom = "text", x = 2019.5, y = 1.225, label = "Endangered", hjust = "left", size = 6) 

graph3
