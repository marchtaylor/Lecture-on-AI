libs <- c("pracma", "metR", "sf", "rgdal", "ggthemes", "ggplot2", "kohonen", "raster", "rgeos")
lapply(libs, library, character.only = TRUE)

msk <- readOGR(".","ne_110m_land_GCM")
ne_110m_coast <- as(msk, "SpatialPolygonsDataFrame")

load("folr.passband.pentad.mean.Rdata")
OLR.filt.passband <- OLR.filt.passband[,73:1,]
lat <- lat[73:1]

idx.lat <- lat >= -17.5 & lat <= 22.5

OLR <- OLR.filt.passband[,idx.lat,]
OLR <- t(Reshape(OLR, 144*sum(idx.lat), 2190))


xdim <- 4
ydim <- 4
n.centers <- xdim*ydim
som.grid <- somgrid(xdim = xdim, ydim = ydim, topo = "rect", neighbourhood.fct = "gaussian")
som.out <- som(OLR, grid = som.grid, rlen = 999, dist.fcts = "sumofsquares")
# som.out <- som(OLR, grid = somgrid(xdim, ydim, "rect"), rlen = 5000, alpha = c(.5, .1))



grid <- setNames(expand.grid(lon, lat[idx.lat], 1:n.centers, stringsAsFactors = FALSE), c("lon", "lat", "k"))
grid$OLR <- NA
for(ii in 1:n.centers){
  grid[grid$k == ii, "OLR"] <- as.vector(som.out$codes[[1]][ii,])
}
grid <- merge(grid, cbind(k=1:16, expand.grid(x=1:4, y=LETTERS[1:4])))
grid$z <- 0

ggplot(data = grid, aes(x=lon, y=lat, z=OLR)) +
  geom_contour_fill(breaks = MakeBreaks(binwidth = 5, exclude = 0)) +
  facet_grid(y~x) +
  scale_fill_divergent(
    breaks = MakeBreaks(binwidth = 5, exclude = 0), 
    low = scales::muted("#2d004b", l = 20),
    mid = "white",
    high = scales::muted("#7f3b08", l = 20),
    name = "",
    guide = guide_colorstrip(barheight = 10)
  ) +
  geom_contour_fill(data = grid, aes(lon, lat, z = z)) +
  geom_polygon(data = ne_110m_coast,
               inherit.aes = FALSE,
               aes(x = long, y = lat, group = group),
               color = "black",
               fill = "transparent",
               size = 0.5
  ) +
  coord_sf(xlim = range(grid$lon), ylim = range(grid$lat), expand = FALSE) +
  scale_x_longitude(breaks = seq(30,360,60)) +
  scale_y_latitude(breaks = c(-17.5,0,22.5)) +
  theme_bw()

grid$z <- runif(NROW(grid), -35, 20)


ggplot(data = grid, aes(x=lon, y=lat, fill=z)) +
  geom_raster() +
  facet_grid(y~x) +
  scale_fill_divergent(
    breaks = MakeBreaks(binwidth = 5, exclude = 0), 
    low = scales::muted("#2d004b", l = 20),
    mid = "white",
    high = scales::muted("#7f3b08", l = 20),
    name = "",
    guide = guide_colorstrip(barheight = 10)
  ) +
  geom_polygon(data = ne_110m_coast,
               inherit.aes = FALSE,
               aes(x = long, y = lat, group = group),
               color = "black",
               fill = "transparent",
               size = 0.5
  ) +
  coord_sf(xlim = range(grid$lon), ylim = range(grid$lat), expand = FALSE) +
  scale_x_longitude(breaks = seq(30,360,60)) +
  scale_y_latitude(breaks = c(-17.5,0,22.5)) +
  theme_bw()


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


library(aweSOM)
somQuality(som = som.out, traindat = OLR)

