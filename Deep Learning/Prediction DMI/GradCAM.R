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
fl <- paste0(fl,"-lr_",sprintf("%g", lr_value),".hdf5")
model <- load_model_hdf5(filepath = paste(MAINDIR, fl, sep = "/"))

lag <- -1  # lag, currently -1, -3 and -7
load(paste0(MAINDIR,"/IO.SST_ERSST.v5.",lag,".RData"))


idx <- which(Dates_train %in% as.Date("1961-09-01"))
img <- x_train[idx,,,,drop=FALSE]    # sample of SST with 3 channels

preds <- model$predict(img)        # prediction for 1 sample

SST_output <- model$output[, which.max(preds[1,])]

last_conv_layer <- model %>% get_layer("First_Conv")

# eager off
grads <- k_gradients(SST_output, last_conv_layer$output)[[1]]

pooled_grads <- k_mean(grads, axis = c(1, 2, 3))

iterate <- k_function(list(model$input),
                      list(pooled_grads, last_conv_layer$output[1,,,])) 

c(pooled_grads_value, conv_layer_output_value) %<-% iterate(list(img))

for (i in 1:num_convf1) {
  conv_layer_output_value[,,i] <- 
    conv_layer_output_value[,,i] * pooled_grads_value[[i]] 
}

heatmap <- apply(conv_layer_output_value, c(1,2), mean)

heatmap <- pmax(heatmap, 0) 
heatmap <- heatmap / max(heatmap)
# heatmap[heatmap == 0] <- NA

image(seq(30,135,5), seq(-67.5,27.5,5), heatmap)
contour(seq(30,135,5), seq(-67.5,27.5,5), as.matrix(img[,,,1]), add = TRUE)

libs <- c("metR", "sf", "rgdal", "ggthemes", "ggplot2")
lapply(libs, library, character.only = TRUE)

msk <- readOGR("~/Lecture/GIT/Lecture-on-AI/Machine Learning/Clustering/","ne_110m_land_GCM")
ne_110m_coast <- as(msk, "SpatialPolygonsDataFrame")


grid <- expand.grid(lon = seq(30,135,5), lat = seq(-67.5,27.5,5))
grid$SSTPOS <- as.vector(img[,,,1]); grid$SSTPOS[grid$SSTPOS >= 0] <- 0 
grid$SSTNEG <- as.vector(img[,,,1]); grid$SSTNEG[grid$SSTNEG < 0] <- 0 
grid$heatmap <- as.vector(heatmap)

ggplot(data = grid, aes(x=lon, y=lat)) +
  geom_raster(aes(fill = heatmap)) +
  geom_contour2(aes(z = SSTPOS, label = ..level..), breaks = MakeBreaks(binwidth = 0.2, exclude = 0), linetype = 2) +
  geom_contour2(aes(z = SSTNEG, label = ..level..), breaks = MakeBreaks(binwidth = 0.2), exclude = 0, linetype = 1) +
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
  scale_x_longitude(breaks = seq(30,360,60)) +
  scale_y_latitude(breaks = seq(-60,60,30))
