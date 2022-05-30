libs <- c("caret", "catboost")
lapply(libs, library, character.only = TRUE)
Sys.setenv(TZ = "GMT")


load("/Users/pascaloettli/Lecture/GIT/Lecture-on-AI/Machine Learning/Data_for_caret.RData")


tuneLength <- 10  # Number of times the parameters are randomly selected
number <- 50      # Number of resampling iterations

preProcess <- "range"  # Pre-processing of the predictor data
# preProcess <- c("center", "scale")


# Algorithm parameters
tgrid <- data.frame(
  depth = sample.int(tuneLength, tuneLength, replace = TRUE)
  , learning_rate = runif(tuneLength, min = 1e-6, max = 1)
  , iterations = rep(100, tuneLength)
  , l2_leaf_reg = sample(c(1e-1, 1e-3, 1e-6), tuneLength, replace = TRUE)
  , rsm = sample(c(1., 0.9, 0.8, 0.7), tuneLength, replace = TRUE)
  , border_count = sample(c(255), tuneLength, replace = TRUE)
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

catboost.out <- 
  train(x = x.Calib.DATA
        , y = y.Calib.DATA
        , trControl = TrC_boot632
        , tuneGrid = tgrid              # Data frame of random parameters defined above
        , method = catboost.caret       # Name of the algorithm
        , metric = "RMSE"               # Name of the metric to find the best model
        , maximize = FALSE
        , preProcess = preProcess       
  )

predict(catboost.out, x.Valid.DATA)

