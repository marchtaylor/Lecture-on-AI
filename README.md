# Associated scripts and data
You will find scripts and data to perform simple machine learning and deep learning. 

## Machine Learning
<ins>Clustering</ins>: For the period 1980-2009, daily OLR (Liebmann and Smith 1996) filtered with a 20-100-day Lanczos 
bandpass 
filter (Duchon 1979, CLIVAR MJO Workgroup 2009), over the tropical region (0 – 360, 17.5°S – 22.5°N). Anomalies are averaged every 5 days from January to December (73 pentads) x 30 years. As a result, a matrix consisting of 2190 pentads of data and 2448 grid points.

<ins>Regression</ins>: Predictors are the sea-surface temperature anomalies in January. Predictand is the surface air 
temperature 
anomalies in January in the Kantō Region (Japan), split into training (27 years x 70) and validation (10 years x 70) subsets. 
Final selection after feature selection is 10 predictors. Model are trained with the the final selection of predictors.

### Clustering
__folr.passband.pentad.mean.Rdata__: Filtered OLR anomalies

__kmeans.OLR.R__: _k_-means on OLR

__SOM.OLR.R__: Self-Organizing Map on OLR

__ne_110m_land_GCM.*__: Land polygons including major islands form Natural Earth

### Regression
__Data_for_caret.RData__: Predictors and predictand

__bartMachine.R__: Bayesian regression

__catboost.R__: Tree boosting regression

__mlp.R__: Multi-layer perceptron (artificial neural network)

__nnet.R__: Single-layer perceptron (artificial neural network)

__rf.R__: Random forest

__svml.R__: Support vector machine (linear kernel)

__svmr.R__: Support vector machine (radial kernel)

__xgbl.R__: Extreme gradient boosting (linear)

__xgbt.R__: Extreme gradient boosting (tree-based)


## Deep Learning
For the period 1855-2019, monthly 5°x5° SST anomalies (ERSST v5, Huang et al. 2017), in the Indian Ocean region (30°E – 135°E, 67.5°S – 27.5°N),

Dataset split into:
* Training subset: 1620 months = samples
* Validation subset: 174 months
* Test subset: 174 months

Lag -1, -2 and -3 months = channels

Each image is 22x20 in resolution


### DMI Prediction
__IO.SST_ERSST.v5.-1.RData__: SST anomalies with 1 month lag

__IO.SST_ERSST.v5.-3.RData__: SST anomalies with 3 months lag

__IO.SST_ERSST.v5.-7.RData__: SST anomalies with 7 months lag

__C10C10D08-lr_0.0001.hdf5__: CNN model with 10 filters of the first convolutional layer, 10 filters for the second 
convolutional filter and 8 nodes in the densely connected layer

__CxxCxxDzz.R__: CNN model to reproduce Liu et al. (2021)

__GradCAM.R__: Visual explanation of CNN with Grad-CAM (Selvaraju et al. 2020)


# Software
## R
Download: https://cloud.r-project.org/

Manuals: https://cloud.r-project.org/manuals.html

## catboost
Installation instructions: https://catboost.ai/en/docs/concepts/r-installation

## keras
Installation instructions: https://cran.r-project.org/web/packages/keras/vignettes/index.html

# Bibliography


## Dataset

Duchon, C. E., 1979: Lanczos Filtering in One and Two Dimensions. J. Appl. Meteor., 18, 1016–1022, 
https://doi.org/10.1175/1520-0450(1979)018<1016:LFIOAT>2.0.CO;2.

Huang, B., and Coauthors, 2017: Extended Reconstructed Sea Surface Temperature, Version 5 (ERSSTv5): Upgrades, 
Validations, and Intercomparisons. Journal of Climate, 30, 8179–8205, https://doi.org/10.1175/JCLI-D-16-0836.1.

Liebmann, B., and C. A. Smith, 1996: Description of a Complete (Interpolated) Outgoing Longwave Radiation Dataset. Bull. 
Amer. Meteor. Soc., 77, 1275–1277.

Waliser, D., and Coauthors, 2009: MJO Simulation Diagnostics. J. Clim., 22, 3006–3030, 
https://doi.org/10.1175/2008JCLI2731.1.

Wheeler, M. C., and H. H. Hendon, 2004: An all-season real-time multivariate MJO index: development of an index for 
monitoring and prediction. Mon. Wea. Rev., 132, 1917–1932, 
https://doi.org/10.1175/1520-0493(2004)132<1917:AARMMI>2.0.CO;2.



## Machine Learning

Alpaydin, E., 2021: Machine learning. Revised and updated edition. The MIT Press, 255 pp.

Azure Machine Learning Team, 2021: Machine Learning Algorithm Cheat Sheet for Azure Machine Learning designer. Available at 
https://download.microsoft.com/download/3/5/b/35bb997f-a8c7-485d-8c56-19444dafd757/azure-machine-learning-algorithm-cheat-sheet-july-2021.pdf 

### <i>k</i>-means
#### Algorithm

Hartigan, J. A., and M. A. Wong, 1979: Algorithm AS 136: A k-means clustering algorithm. J. R. Stat. Soc. Ser. C Appl. 
Stat., 28, 100–108, https://doi.org/10.2307/2346830.

Forgy, E. W., 1965a: Cluster analysis of multivariate data: Efficiency versus interpretability of classification. WNAR 
Meetings, Riverside, California.

——, 1965b: Cluster analysis of multivariate data: Efficiency versus interpretability of classification (Abstract). 
Biometrics, 21, 768–769.

Lloyd, S. P., 1982: Least squares quantization in PCM. IEEE Trans. Inf. Theory, 28, 129–137, 
https://doi.org/10.1109/TIT.1982.1056489.

MacQueen, J., 1967: Some methods for classification and analysis of multivariate observations. Proceedings of the Fifth 
Berkeley Symposium on Mathematical Statistics and Probability, 1: Statistics, 281–297.

Morissette, L., and S. Chartier, 2013: The k-means clustering technique: General considerations and implementation in 
Mathematica. TQMP, 9, 15–24, https://doi.org/10.20982/tqmp.09.1.p015.

Steinhaus, H., 1956: Sur la division des corps matériels en parties. Bulletin de l’Académie Polonaise des Sciences, IV, 
801–804.


#### Application

Carvalho, M. J., P. Melo-Gonçalves, J. C. Teixeira, and A. Rocha, 2016: Regionalization of Europe based on a K-Means 
Cluster Analysis of the climate change of temperatures and precipitation. Phys. Chem. Earth Parts A/B/C, 94, 22–28, 
https://doi.org/10.1016/j.pce.2016.05.001.

Fauchereau, N., B. Pohl, C. J. C. Reason, M. Rouault, and Y. Richard, 2009: Recurrent daily OLR patterns in the Southern 
Africa/Southwest Indian Ocean region, implications for South African rainfall and teleconnections. Clim. Dyn., 32, 
575–591, https://doi.org/10.1007/s00382-008-0426-2.





### Self Organizing Map
#### Algorithm

Amari, S., 1980: Topographic organization of nerve fields. Bulletin of Mathematical Biology, 42, 339–364, 
https://doi.org/10.1016/S0092-8240(80)80055-3.

Kohonen, T., 1982: Self-organized formation of topologically correct feature maps. Biol. Cybern., 43, 59–69, 
https://doi.org/10.1007/BF00337288.

von der Malsburg, C., 1973: Self-organization of orientation sensitive cells in the striate cortex. Kybernetik, 14, 
85–100, https://doi.org/10.1007/BF00288907.

Sammon, J. W., 1969: A Nonlinear Mapping for Data Structure Analysis. IEEE T. Comput., C–18, 401–409, 
https://doi.org/10.1109/T-C.1969.222678.


#### Application

Chattopadhyay, R., A. Vintzileos, and C. Zhang, 2013: A description of the Madden–Julian oscillation based on a 
self-organizing map. J. Clim., 26, 1716–1732, https://doi.org/10.1175/JCLI-D-12-00123.1.

Leloup, J., Z. Lachkar, J.-P. Boulanger, and S. Thiria, 2007: Detecting decadal changes in ENSO using neural networks. 
Clim. Dyn., 28, 147–162, https://doi.org/10.1007/s00382-006-0173-1.

——, M. Lengaigne, and J.-P. Boulanger, 2008: Twentieth century ENSO characteristics in the IPCC database. Clim. Dyn., 30, 
277–291, https://doi.org/10.1007/s00382-007-0284-3.

Liu, Y., R. H. Weisberg, and C. N. K. Mooers, 2006: Performance evaluation of the self-organizing map for feature 
extraction. J. Geophys. Res., 111, C05018_1-C05018_14, https://doi.org/10.1029/2005JC003117.

Morioka, Y., T. Tozuka, and T. Yamagata, 2010: Climate variability in the southern Indian Ocean as revealed by 
self-organizing maps. Clim. Dyn., 35, 1059–1072, https://doi.org/10.1007/s00382-010-0843-x.

Oettli, P., T. Tozuka, T. Izumo, F. A. Engelbrecht, and T. Yamagata, 2014: The self-organizing map, a new approach to 
apprehend the Madden–Julian Oscillation influence on the intraseasonal variability of rainfall in the southern African 
region. Clim. Dyn., 43, 1557–1573, https://doi.org/10.1007/s00382-013-1985-4.

——, M. Nonaka, and S. K. Behera, 2021: Winter Surface Air Temperature Prediction over Japan Using Artificial Neural 
Networks. Weather Forecast., 36, 1343–1356, https://doi.org/10.1175/WAF-D-20-0218.1.

Sakai, K., R. Kawamura, and Y. Iseri, 2010: ENSO-induced tropical convection variability over the Indian and western 
Pacific oceans during the northern winter as revealed by a self-organizing map. J. Geophys. Res., 115, 
https://doi.org/10.1029/2010JD014415.

Tozuka, T., J.-J. Luo, S. Masson, and T. Yamagata, 2008: Tropical Indian Ocean variability revealed by self-organizing 
maps. Clim. Dyn., 31, 333–343, https://doi.org/10.1007/s00382-007-0356-4.


### Regression
#### Tools

Kuhn, M., 2020: caret: Classification and Regression Training.

——, and H. Wickham, 2020: Tidymodels: a collection of packages for modeling and machine learning using tidyverse 
principles.

Martín Abadi, and Coauthors, 2015: TensorFlow: Large-Scale Machine Learning on Heterogeneous Systems.

Pedregosa, F., and Coauthors, 2011: Scikit-learn: Machine Learning in Python. J. Mach. Learn. Res., 12, 2825–2830.

Polley, E., E. LeDell, C. Kennedy, and M. van der Laan, 2021: SuperLearner: Super Learner Prediction.


#### Application
Oettli, P., M. Nonaka, I. Richter, H. Koshiba, Y. Tokiya, I. Hoshino, and S. K. Behera, 2022: Combining Dynamical and Statistical 
Modeling to Improve the Prediction of Surface Air Temperatures 2 Months in Advance: A Hybrid Approach. Front. Clim., 4, 
https://doi.org/10.3389/fclim.2022.862707.

Ratnam, J. V., H. A. Dijkstra, and S. K. Behera, 2020: A machine learning based prediction system for the Indian Ocean 
Dipole. Sci Rep, 10, 284, https://doi.org/10.1038/s41598-019-57162-8.




## Deep Learning

Chollet, F., 2018: Deep learning with Python. Manning Publications Co, 361 pp.

—— and others, 2015: Keras.

——, and J. J. Allaire, 2018: Deep learning with R. Manning Publications Co, 335 pp.

Goodfellow, I., Y. Bengio, and A. Courville, 2016: Deep learning. The MIT Press, 775 pp.

Kelleher, J. D., 2019: Deep learning. The MIT Press, 280 pp.

Ng, A. Y., 2004: Feature selection, <i>L</i><sub>1</sub> vs. <i>L</i><sub>2</sub> regularization, and rotational invariance. Proceedings of 
the twenty-first 
international conference on Machine learning, ICML ’04, New York, NY, USA, Association for Computing Machinery, 78.

Schmidhuber, J., 2015: Deep Learning in Neural Networks: An Overview. Neural Networks, 61, 85–117, 
https://doi.org/10.1016/j.neunet.2014.09.003.


#### Application

Ham, Y.-G., J.-H. Kim, and J.-J. Luo, 2019: Deep learning for multi-year ENSO forecasts. Nature, 1–5, 
https://doi.org/10.1038/s41586-019-1559-7.

Liu, J., Y. Tang, Y. Wu, T. Li, Q. Wang, and D. Chen, 2021: Forecasting the Indian Ocean Dipole With Deep Learning 
Techniques. Geophys Res Lett, 48, https://doi.org/10.1029/2021GL094407.

Patil, K. R., T. Doi, P. Oettli, J. V. Ratnam, and S. K. Behera, 2021: Improving long-lead predictions of ENSO using 
convolutional neural networks. CLIVAR Exchanges Special Issue: Advances in Climate Prediction Using Artificial 
Intelligence, 81, 8–11.

