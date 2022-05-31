options(java.parameters = "-Xmx20g")
libs <- c("caret", "bartMachine")
lapply(libs, library, character.only = TRUE)
Sys.setenv(TZ = "GMT")


load("/Users/pascaloettli/Lecture/GIT/Lecture-on-AI/Machine Learning/Data_for_caret.RData")


tuneLength <- 10  # Number of times the parameters are randomly selected
number <- 50      # Number of resampling iterations

preProcess <- "range"  # Pre-processing of the predictor data
# preProcess <- c("center", "scale")


# Algorithm parameters
tgrid <- data.frame(
  num_trees = sample(10:100, replace = TRUE, size = tuneLength)
  , k = runif(tuneLength, min = 0, max = 5)
  , alpha = runif(tuneLength, min = .9, max = 1)
  , beta = runif(tuneLength, min = 0, max = 4)
  , nu = runif(tuneLength, min = 0, max = 5)
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

bart.out <- 
  train(x = x.Calib.DATA
        , y = y.Calib.DATA
        , trControl = TrC_boot632
        , tuneGrid = tgrid              # Data frame of random parameters defined above
        , method = "bartMachine"        # Name of the algorithm
        , metric = "RMSE"               # Name of the metric to find the best model
        , maximize = FALSE
        , preProcess = preProcess       
        , mem_cache_for_speed = FALSE   
        , serialize = TRUE
        , verbose = FALSE
  )

predict(bart.out, x.Valid.DATA)         # Prediction on validation subset


