libs <- c("keras", "tensorflow")
lapply(libs, library, character.only = TRUE)
Sys.setenv(TZ = "UTC")
options(keras.view_metrics = FALSE)

tf$config$threading$set_inter_op_parallelism_threads(1L)
tf$config$threading$set_intra_op_parallelism_threads(1L)
tf$compat$v1$disable_eager_execution()

MAINDIR <- "~/Lecture/GIT/Lecture-on-AI/Deep Learning/Prediction DMI"

lag <- -1  # lag, currently -1, -3 and -7
# Possible choice of learning rate
LRs <- c(0.05, 0.04, 0.03, 0.02, 0.01, 0.009, 0.008, 0.007, 0.006, 0.005, 0.004, 0.003, 0.002, 0.001, 0.0009, 0.0008, 0.0007, 0.0006, 0.0005, 0.0001)
num_convf1 <- 10     # total number of convolutional filters; first filter; possible choice: 10, 11, 12
num_convf2 <- 10     # total number of convolutional filters; second filter; possible choice: 10, 11, 12
num_hiddf <- 8       # total number of neurons; possible choice: 8, 9, 10
lr_value <- LRs[20]  # learning rate; pick inside LRs

fl <- paste0("C", sprintf("%02d", num_convf1), "C", sprintf("%02d", num_convf2), "D", sprintf("%02d", num_hiddf))
fl <- paste0(fl,"-lr_",sprintf("%g", lr_value))
fl <- paste0(fl,"_regularization")
fl <- paste0(fl,".hdf5")
model <- load_model_hdf5(filepath = paste(MAINDIR, fl, sep = "/"))

load(paste0(MAINDIR,"/IO.SST_ERSST.v5.",lag,".RData"))

idx <- which(Dates_train %in% as.Date("1961-09-01"))
img_tensor <- x_train[idx,,,,drop=FALSE]    # sample of SST with 3 channels

layer_outputs <- lapply(model$layers[2:10], function(layer) layer$output) 
activation_model <- keras_model(inputs = model$input, outputs = layer_outputs)

activations <- activation_model %>% predict(img_tensor)

first_layer_activation <- activations[[1]]
dim(first_layer_activation)

first_layer_pooling <- activations[[2]]
dim(first_layer_pooling)

second_layer_activation <- activations[[4]]
dim(second_layer_activation)

second_layer_pooling <- activations[[5]]
dim(second_layer_pooling)


libs <- c("metR", "sf", "rgdal", "ggthemes", "ggplot2")
lapply(libs, library, character.only = TRUE)

msk <- readOGR("~/Lecture/GIT/Lecture-on-AI/Machine Learning/Clustering/","ne_110m_land_GCM")
ne_110m_coast <- as(msk, "SpatialPolygonsDataFrame")



lon1 <- seq(30,135,5)
lon2 <- approx(lon1, n = 11)$y
lon3 <- approx(lon2, n = 5)$y

lat1 <- seq(-67.5,27.5,5)
lat2 <- approx(lat1, n = 10)$y
lat3 <- approx(lat2, n = 5)$y


grid1 <- expand.grid(lon = lon1, lat = lat1, lag = -3:-1)
grid1$SSTPOS <- as.vector(img_tensor[,,,3:1]); grid1$SSTPOS[grid1$SSTPOS < 0] <- 0 
grid1$SSTNEG <- as.vector(img_tensor[,,,3:1]); grid1$SSTNEG[grid1$SSTNEG >= 0] <- 0 

ggplot(data = grid1, aes(x=lon, y=lat)) +
  geom_contour2(aes(z = SSTPOS, label = ..level..), breaks = MakeBreaks(binwidth = 0.2, exclude = 0), linetype = 1) +
  geom_contour2(aes(z = SSTNEG, label = ..level..), breaks = MakeBreaks(binwidth = 0.2, exclude = 0), linetype = 2) +
  facet_grid(lag~., switch = "y") +
  coord_sf(xlim = range(grid1$lon), ylim = range(grid1$lat), expand = FALSE) +
  geom_polygon(data = ne_110m_coast,
               inherit.aes = FALSE,
               aes(x = long, y = lat, group = group),
               color = "black",
               fill = "white",
               size = 0.5
  ) +
  scale_x_longitude(breaks = seq(30,360,30)) +
  scale_y_latitude(breaks = seq(-60,60,30))


grid <- expand.grid(lon = lon1, lat = lat1, channel = 1:num_convf1)
grid$activation <- as.vector(first_layer_activation)

grid1 <- expand.grid(lon = lon1, lat = lat1)
grid1$SSTPOS <- as.vector(img_tensor[,,,1]); grid1$SSTPOS[grid1$SSTPOS < 0] <- 0 
grid1$SSTNEG <- as.vector(img_tensor[,,,1]); grid1$SSTNEG[grid1$SSTNEG >= 0] <- 0 

ggplot(data = grid, aes(x=lon, y=lat)) +
  geom_raster(aes(fill = activation)) +
  # geom_contour2(data = grid1, aes(z = SSTPOS, label = ..level..), breaks = MakeBreaks(binwidth = 0.2, exclude = 0), linetype = 1) +
  # geom_contour2(data = grid1, aes(z = SSTNEG, label = ..level..), breaks = MakeBreaks(binwidth = 0.2, exclude = 0), linetype = 2) +
  facet_grid(channel~., switch = "y") +
  scale_fill_divergent(
    breaks = MakeBreaks(binwidth = 0.2, exclude = 0), 
    low = "blue", 
    mid = "yellow",
    high = "red", 
    name = "") +
  coord_sf(xlim = range(grid$lon), ylim = range(grid$lat), expand = FALSE) +
  geom_polygon(data = ne_110m_coast,
               inherit.aes = FALSE,
               aes(x = long, y = lat, group = group),
               color = "black",
               fill = "white",
               size = 0.5
  ) +
  scale_x_longitude(breaks = seq(30,360,30)) +
  scale_y_latitude(breaks = seq(-60,60,30)) +
  guides(fill="none")



grid <- expand.grid(lon = lon2, lat = lat2, channel = 1:num_convf1)
grid$pooling <- as.vector(first_layer_pooling)

ggplot(data = grid, aes(x=lon, y=lat)) +
  geom_raster(aes(fill = pooling)) +
  # geom_contour2(data = grid1, aes(z = SSTPOS, label = ..level..), breaks = MakeBreaks(binwidth = 0.2, exclude = 0), linetype = 1) +
  # geom_contour2(data = grid1, aes(z = SSTNEG, label = ..level..), breaks = MakeBreaks(binwidth = 0.2, exclude = 0), linetype = 2) +
  facet_grid(channel~., switch = "y") +
  scale_fill_divergent(
    breaks = MakeBreaks(binwidth = 0.2, exclude = 0), 
    low = "blue", 
    mid = "yellow",
    high = "red", 
    name = "") +
  coord_sf(xlim = range(grid$lon), ylim = range(grid$lat), expand = FALSE) +
  geom_polygon(data = ne_110m_coast,
               inherit.aes = FALSE,
               aes(x = long, y = lat, group = group),
               color = "black",
               fill = "white",
               size = 0.5
  ) +
  scale_x_longitude(breaks = seq(30,360,30)) +
  scale_y_latitude(breaks = seq(-60,60,30)) +
  guides(fill="none")



grid <- expand.grid(lon = lon2, lat = lat2, channel = 1:num_convf2)
grid$activation <- as.vector(second_layer_activation)

ggplot(data = grid, aes(x=lon, y=lat)) +
  geom_raster(aes(fill = activation)) +
  # geom_contour2(data = grid1, aes(z = SSTPOS, label = ..level..), breaks = MakeBreaks(binwidth = 0.2, exclude = 0), linetype = 1) +
  # geom_contour2(data = grid1, aes(z = SSTNEG, label = ..level..), breaks = MakeBreaks(binwidth = 0.2, exclude = 0), linetype = 2) +
  facet_grid(channel~., switch = "y") +
  scale_fill_divergent(
    breaks = MakeBreaks(binwidth = 0.2, exclude = 0), 
    low = "blue", 
    mid = "yellow",
    high = "red", 
    name = "") +
  coord_sf(xlim = range(grid$lon), ylim = range(grid$lat), expand = FALSE) +
  geom_polygon(data = ne_110m_coast,
               inherit.aes = FALSE,
               aes(x = long, y = lat, group = group),
               color = "black",
               fill = "white",
               size = 0.5
  ) +
  scale_x_longitude(breaks = seq(30,360,30)) +
  scale_y_latitude(breaks = seq(-60,60,30)) +
  guides(fill="none")


grid <- expand.grid(lon = lon3, lat = lat3, channel = 1:num_convf2)
grid$pooling <- as.vector(second_layer_pooling)

ggplot(data = grid, aes(x=lon, y=lat)) +
  geom_raster(aes(fill = pooling)) +
  # geom_contour2(data = grid1, aes(z = SSTPOS, label = ..level..), breaks = MakeBreaks(binwidth = 0.2, exclude = 0), linetype = 1) +
  # geom_contour2(data = grid1, aes(z = SSTNEG, label = ..level..), breaks = MakeBreaks(binwidth = 0.2, exclude = 0), linetype = 2) +
  facet_grid(channel~., switch = "y") +
  scale_fill_divergent(
    breaks = MakeBreaks(binwidth = 0.2, exclude = 0), 
    low = "blue", 
    mid = "yellow",
    high = "red", 
    name = "") +
  coord_sf(xlim = range(grid$lon), ylim = range(grid$lat), expand = FALSE) +
  geom_polygon(data = ne_110m_coast,
               inherit.aes = FALSE,
               aes(x = long, y = lat, group = group),
               color = "black",
               fill = "white",
               size = 0.5
  ) +
  scale_x_longitude(breaks = seq(30,360,30)) +
  scale_y_latitude(breaks = seq(-60,60,30)) +
  guides(fill="none")
