\name{lira-package}
\alias{lira-package}
\docType{package}
\title{
Low-Count Image Reconstruction and Analysis
}
\description{
  This package is designed for multi-scale non-parametric image analysis for use in high-energy astrophysics. The code implements an MCMC sampler that simultaneously fits the image and the necessary tuning/smoothing parameters in the model. The model-based approach allows for quantification of the standard error of the fitted image and can be used to evaluate the goodness-of-fit of a proposed model.}
\details{
\tabular{ll}{
Package: \tab lira\cr
Type: \tab Package\cr
Version: \tab 0.1\cr
Date: \tab 2009-08-17\cr
License: \tab GPL (>= 2)\cr
LazyLoad: \tab yes\cr
}

The function \code{lira} analyzes images using an MCMC sampler extending the EMC2 technique. Details of the EMC2 technique are given Esch et al. (2004).
}
\author{
Alanna Connors, Nathan Stein, David van Dyk

Maintainer: Nathan Stein <nmstein@fas.harvard.edu>
}
\references{
Esch, D. N., Connors, A., Karovska, M., and van Dyk, D. A. (2004). An Image Reconstruction Technique with Error Estimates.  The Astrophysical Journal, 610, 1213-1227.

Connors, A. and van Dyk, D. A. (2007). How To Win With Non-Gaussian Data: Poisson Goodness-of-Fit. In  Statistical Challenges in Modern Astronomy IV (Editors: G. J. Babu and E. D. Feigelson), Astronomical Society of the Pacific, San Francisco, Vol. CS371, 101-117.

van Dyk, D. A., Connors, A., Esch, D. N., Freeman, P., Kang, H., Karovska, M., and Kashyap, V. (2006). Deconvolution in High Energy Astrophysics: Science, Instrumentation, and Methods (with discussion).  Bayesian Analysis,  1, 189-236.

\url{http://hea-www.harvard.edu/AstroStat/EMC2/}
}
\keyword{ package }
\seealso{
\code{\link[lira]{lira}}, \code{\link[liraFromAscii]{liraFromAscii}}
}
\examples{
require(lira)
data(PoissonEImages)
# display simulated observation
image(PoissonE.obs)
# analyze the simulated data using a null model for the background
lira.null <- lira(obs.matrix=PoissonE.obs, bkg.matrix=PoissonE.null, 
                  mcmc=TRUE, max.iter=500, burn=50, 
                  alpha.init=c(3,4,5,6,7))
# clean up
unlink("LIRA.out")
unlink("LIRA.param")
}
