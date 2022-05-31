libs <- c("caret")
lapply(libs, library, character.only = TRUE)
Sys.setenv(TZ = "GMT")


load("/Users/pascaloettli/Lecture/GIT/Lecture-on-AI/Machine Learning/Data_for_caret.RData")


tuneLength <- 10  # Number of times the parameters are randomly selected
number <- 500      # Number of resampling iterations

preProcess <- "range"  # Pre-processing of the predictor data
# preProcess <- c("center", "scale")


# Algorithm parameters
sigmas <- kernlab::sigest(as.matrix(x.Calib.DATA), na.action = na.omit, scaled = TRUE)
rng <- extendrange(log(sigmas), f = .75)
tgrid <- data.frame(
  sigma = exp(runif(tuneLength, min = rng[1], max = rng[2]))
  , C = 2^runif(tuneLength, min = -5, max = 10)
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

svmr.out <- 
  train(x = x.Calib.DATA
        , y = y.Calib.DATA
        , trControl = TrC_boot632
        , tuneGrid = tgrid              # Data frame of random parameters defined above
        , method = "svmRadial"          # Name of the algorithm
        , metric = "RMSE"               # Name of the metric to find the best model
        , maximize = FALSE
        , preProcess = preProcess       
  )

predict(svmr.out, x.Valid.DATA)         # Prediction on validation subset

