# Loading the required R packages
libs <- c("pracma", "metR", "sf", "rgdal", "ggthemes", "ggplot2", "kohonen", "raster", "rgeos")
lapply(libs, library, character.only = TRUE)

# Setting the working directory, with the  data used 
setwd("~/Lecture/GIT/Lecture-on-AI/Machine Learning/Clustering/")

# Free vector and raster map data @ naturalearthdata.com.
msk <- readOGR(".","ne_110m_land_GCM")
ne_110m_coast <- as(msk, "SpatialPolygonsDataFrame")


# Loading the filtered OLR data
load("folr.passband.pentad.mean.Rdata")
OLR.filt.passband <- OLR.filt.passband[,73:1,]  # Changing the latitudes order
lat <- lat[73:1]

idx.lat <- lat >= -17.5 & lat <= 22.5   # Selecting latitudes of interest

# Extracting the tropical band
OLR <- OLR.filt.passband[,idx.lat,]
OLR <- t(Reshape(OLR, length(lon)*sum(idx.lat), 2190))

# Defining the grid
xdim <- 4
ydim <- 4
n.centers <- xdim*ydim
som.grid <- somgrid(
  xdim = xdim, 
  ydim = ydim,
  topo = "rect", 
  neighbourhood.fct = "gaussian"
)

# Runing the SOM
som.out <- som(
  OLR, 
  grid = som.grid, 
  rlen = 999,
  alpha = c(0.05, 0.01),
  radius <- c(2, 0),
  dist.fcts = "sumofsquares"
)

# Visualizing the nodes
ggplot(data = grid, aes(x=lon, y=lat, z=OLR)) +
  geom_contour_fill(breaks = MakeBreaks(binwidth = 5, exclude = 0)) +
  facet_grid(y~x) +
  geom_polygon(data = ne_110m_coast,
               inherit.aes = FALSE,
               aes(x = long, y = lat, group = group),
               color = "black",
               fill = "transparent",
               size = 0.5
  ) +
  scale_fill_divergent(
    breaks = MakeBreaks(binwidth = 5, exclude = 0), 
    low = scales::muted("#2d004b", l = 20),
    mid = "white",
    high = scales::muted("#7f3b08", l = 20),
    name = "",
    guide = guide_colorstrip(barheight = 10)
  ) +
  coord_sf(xlim = range(grid$lon), ylim = range(grid$lat), expand = FALSE) +
  scale_x_longitude(breaks = seq(30,360,60)) +
  scale_y_latitude(breaks = c(-17.5,0,22.5)) +
  theme_bw()


# Visualizing the filtered OLR anomalies averaged by nodes
grid <- setNames(expand.grid(lon, lat, 1:n.centers, stringsAsFactors = FALSE), c("lon", "lat", "k"))
grid$OLR <- NA

for(ii in 1:n.centers){
  grid[grid$k == ii, "OLR"] <- as.vector(apply(OLR.filt.passband[,,som.out$unit.classif == ii], 1:2, mean))
}
grid <- merge(grid, cbind(k=1:16, expand.grid(x=1:4, y=LETTERS[1:4])))
grid$OLR[grid$OLR >=-5 & grid$OLR <= 5] <- NA

ggplot(data = grid, aes(x=lon, y=lat, z=OLR)) +
  geom_polygon(data = ne_110m_coast,
               inherit.aes = FALSE,
               aes(x = long, y = lat, group = group),
               color = "black",
               fill = "transparent",
               size = 0.5
  ) +
  geom_contour_fill(breaks = MakeBreaks(binwidth = 5, exclude = 0)) +
  scale_fill_divergent(
    breaks = MakeBreaks(binwidth = 5, exclude = 0), 
    low = scales::muted("#2d004b", l = 20),
    mid = "white",
    high = scales::muted("#7f3b08", l = 20),
    name = "",
    guide = guide_colorstrip(barheight = 10)
  ) +
  facet_grid(y~x) +
  coord_sf(xlim = range(grid$lon), ylim = range(grid$lat), expand = FALSE) +
  scale_x_longitude(breaks = seq(30,360,60)) +
  scale_y_latitude(breaks = seq(-60,60,30)) +
  theme_bw()


# Quality of the SOM
library(aweSOM)
somQuality(som = som.out, traindat = OLR)

