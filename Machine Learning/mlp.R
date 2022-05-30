options(java.parameters = "-Xmx20g")
libs <- c("caret")
lapply(libs, library, character.only = TRUE)
Sys.setenv(TZ = "GMT")


load("/Users/pascaloettli/Lecture/GIT/Lecture-on-AI/Machine Learning/Data_for_caret.RData")


tuneLength <- 10  # Number of times the parameters are randomly selected
number <- 500      # Number of resampling iterations

preProcess <- "range"  # Pre-processing of the predictor data
# preProcess <- c("center", "scale")


# Algorithm parameters
tgrid <- data.frame(
  layer1 = sample(2:20, replace = TRUE, size = tuneLength)
  ,layer2 = sample(c(0, 2:20), replace = TRUE, size = tuneLength)
  ,layer3 = sample(c(0, 2:20), replace = TRUE, size = tuneLength)
)


TrC_boot632 <- trainControl(
  method = "boot632"                    # Resampling method 
  , search = "grid"                     # Pickup parameter in user-defined parameters
  , number = number                     # Number of resampling iterations
  , summaryFunction = defaultSummary    # Afunction to compute performance metrics across resamples
  , savePredictions = "all"
  , returnResamp = "all"
  , allowParallel = TRUE
)

mlp.out <- 
  train(x = x.Calib.DATA
        , y = y.Calib.DATA
        , trControl = TrC_boot632
        , tuneGrid = tgrid              # Data frame of random parameters defined above
        , method = "mlpML"              # Name of the algorithm
        , metric = "RMSE"               # Name of the metric to find the best model
        , maximize = FALSE
        , preProcess = preProcess       
        , linout = TRUE
  )

predict(bart.out, x.Valid.DATA)

