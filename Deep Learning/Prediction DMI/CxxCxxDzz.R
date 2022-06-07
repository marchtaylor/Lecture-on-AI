libs <- c("keras", "tensorflow", "xts", "lubridate", "ggplot2")
lapply(libs, library, character.only = TRUE)
Sys.setenv(TZ = "UTC")
options(keras.view_metrics = FALSE)

tf$config$threading$set_inter_op_parallelism_threads(1L)
tf$config$threading$set_intra_op_parallelism_threads(1L)
tf$compat$v1$disable_eager_execution()

MAINDIR <- "~/Lecture/GIT/Lecture-on-AI/Deep Learning/Prediction DMI"

lag <- -1  # lag, currently -1, -3 and -7
load(paste0(MAINDIR,"/IO.SST_ERSST.v5.",lag,".RData"))
lbatch <- dim(x_valid)[1]
IN <- 1:floor(lbatch/2)
OUT <- (floor(lbatch/2)+1):lbatch

x_test <- x_valid[OUT,,,]
y_test <- y_valid[OUT,]
Dates_test <- Dates_valid[OUT]

x_valid <- x_valid[IN,,,]
y_valid <- y_valid[IN,]
Dates_valid <- Dates_valid[IN]


xdim <- dim(x_train)[2]   # original number of grid points of the input layer, between 25°–135°E
ydim <- dim(x_train)[3]   # original number of grid points of the input layer, between 70°S–30°N
zdim <- dim(x_train)[4]   # original number of input layers (Sea-Surface Temperature x 3)
xdim2 <- xdim/4
ydim2 <- ydim/4
cf1 <- c(3L, 3L)          # size of the convolutional filter #1
cf2 <- c(3L, 3L)          # size of the convolutional filter #2
pl1_size <- c(2L, 2L)     # size of the pooling layer to extract the largest value
pl2_size <- c(2L, 2L)　　 # size of the pooling layer to extract the largest value
strd_size <- c(1L, 1L)
conv_drop <- 0.5          # ~50% of units dropped
# Possible choice of learning rate
LRs <- c(0.05, 0.04, 0.03, 0.02, 0.01, 0.009, 0.008, 0.007, 0.006, 0.005, 0.004, 0.003, 0.002, 0.001, 0.0009, 0.0008, 0.0007, 0.0006, 0.0005, 0.0001)
dc_value <- 0.9
batch_size <- 24                    # size of the mini batch (i.e., number of samples/time step) for each epoch
epoch_size <- 500                   # number of epochs (i.e., number of time the complete train subset is seen)
sample_size <- dim(x_train)[1]      # total number of time samples to train for the CNN model
input_shape <- c(xdim, ydim, zdim)  # size of the input


num_convf1 <- 10     # total number of convolutional filters; first filter; possible choice: 10, 11, 12
num_convf2 <- 10     # total number of convolutional filters; second filter; possible choice: 10, 11, 12
num_hiddf <- 8       # total number of neurons; possible choice: 8, 9, 10
lr_value <- LRs[20]  # learning rate; pick inside LRs
padding <- "same"
layer_activation <- "relu"

# input layer
inputs <- layer_input(shape = input_shape, name = "IO_SST")

# outputs compose input + dense layers
predictions <- inputs %>%
  layer_conv_2d(kernel_size = cf1, 
                filter = num_convf1, 
                activation = layer_activation,
                strides = strd_size,
                padding = padding,
                bias_initializer = "RandomNormal",
                kernel_initializer = "normal",
                kernel_regularizer = regularizer_l2(l = 0.01),
                name = "First_Conv",
                data_format = "channels_last") %>%
  layer_average_pooling_2d(pool_size = pl1_size,
                           data_format = "channels_last",
                           name = "First_Avg_Pool") %>% 
  layer_dropout(rate = conv_drop, name = "First_Drp") %>%
  layer_conv_2d(kernel_size = cf2, 
                filter = num_convf2,
                activation = layer_activation,
                strides = strd_size,
                padding = padding,
                bias_initializer = "RandomNormal",
                kernel_initializer = "normal",
                kernel_regularizer = regularizer_l2(l = 0.01),
                name = "Second_Conv",
                data_format = "channels_last") %>%
  layer_average_pooling_2d(pool_size = pl2_size,
                           data_format = "channels_last",
                           name = "Second_Avg_Pool") %>% 
  layer_dropout(rate = conv_drop, name = "Second_Drp") %>%
  layer_flatten(name = "Flatting") %>%
  layer_dense(units = num_hiddf, kernel_initializer = "normal", activation = "relu", name = "Hidden_Layer") %>% 
  layer_dense(units = 1, activation = "linear", name = "Connection")

model <- keras_model(inputs = inputs, outputs = predictions)


model %>% compile(
  loss = "mse",
  optimizer = optimizer_rmsprop(learning_rate = lr_value),
  metrics = c('mean_absolute_error')
)

history <- model %>% fit(
  x_train 
  , y_train
  , batch_size = batch_size
  , epochs = 500
  , validation_data = list(x_test, y_test)
)

fl <- paste0("C", sprintf("%02d", num_convf1), "C", sprintf("%02d", num_convf2), "D", sprintf("%02d", num_hiddf))
fl <- paste0(fl,"-lr_",sprintf("%g", lr_value))
fl <- paste0(fl,".hdf5")
save_model_hdf5(object = model, filepath = paste(MAINDIR, fl, sep = "/"))

plot(history)

pred_train <- model %>% predict(x_train) %>% xts(order = Dates_train)
pred_test <- model %>% predict(x_test) %>% xts(order = Dates_test)
pred_valid <- model %>% predict(x_valid) %>% xts(order = Dates_valid)

obs_train <- xts(y_train, Dates_train)
obs_test <- xts(y_test, Dates_test)
obs_valid <- xts(y_valid, Dates_valid)

autoplot(cbind(obs_train, pred_train), facet = NULL)
autoplot(cbind(obs_valid, pred_valid), facet = NULL)
autoplot(cbind(obs_test, pred_test), facet = NULL)


k_clear_session() 
