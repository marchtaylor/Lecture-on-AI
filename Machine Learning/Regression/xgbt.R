libs <- c("caret", "xgboost")
lapply(libs, library, character.only = TRUE)
Sys.setenv(TZ = "GMT")


load("/Users/pascaloettli/Lecture/GIT/Lecture-on-AI/Machine Learning/Data_for_caret.RData")


tuneLength <- 10  # Number of times the parameters are randomly selected
number <- 500      # Number of resampling iterations

preProcess <- "range"  # Pre-processing of the predictor data
# preProcess <- c("center", "scale")


# Algorithm parameters
tgrid <- data.frame(
  nrounds = sample(1:1000, size = tuneLength, replace = TRUE),
  max_depth = sample(1:10, replace = TRUE, size = tuneLength),
  eta = runif(tuneLength, min = .001, max = .6),
  gamma = runif(tuneLength, min = 0, max = 10),
  colsample_bytree = runif(tuneLength, min = .3, max = .7),
  min_child_weight = sample(0:20, size = tuneLength, replace = TRUE),
  subsample = runif(tuneLength, min = .25, max = 1)
)


TrC_boot632 <- trainControl(
  method = "boot632"                    # Resampling method 
  , search = "grid"                     # Pickup parameter in user-defined parameters
  , number = number                     # Number of resampling iterations
  , summaryFunction = defaultSummary    # A function to compute performance metrics across resamples
  , savePredictions = "all"
  , returnResamp = "all"
  , allowParallel = TRUE
)

xgbt.out <- 
  train(x = x.Calib.DATA
        , y = y.Calib.DATA
        , trControl = TrC_boot632
        , tuneGrid = tgrid              # Data frame of random parameters defined above
        , method = "xgbTree"            # Name of the algorithm
        , metric = "RMSE"               # Name of the metric to find the best model
        , maximize = FALSE
        , preProcess = preProcess 
  )

predict(xgbt.out, x.Valid.DATA)         # Prediction on validation subset


