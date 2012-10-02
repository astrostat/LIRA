library(lira)
require(FITSio)

obsfile = "Faint_128x128testE_exampledata/PoisDAtons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a.fits"
obs <- readFITS(obsfile)
obsmat <- matrix(data=obs$imDat, nrow=obs$axDat$len[1], ncol=obs$axDat$len[2] )

#psffile = "Unity.fits"
#psf <- readFITS(psffile)
##psfmat <- matrix(data=psf$imDat, nrow=psf$axDat$len[1], ncol=psf$axDat$len[2] )
#psfmat <- matrix(data=psf$imDat, nrow=psf$axDat$len[1] )

bkgdfile = "Faint_128x128testE_exampledata/NullModel_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a.fits"
bkgd <- readFITS(bkgdfile)
bkgdmat <- matrix(data=bkgd$imDat, nrow=bkgd$axDat$len[1], ncol=bkgd$axDat$len[2] )

#strtfile = "exampledata/start32x32_1.00.fits"
#strt <- readFITS(strtfile)
#strtmat <- matrix(data=strt$imDat, nrow=strt$axDat$len[1], ncol=strt$axDat$len[2] )

### First run to look at burn-in, autocorrealtion:

### Strt=obs:

img <- lira(
  obs.matrix = obsmat,
  bkg.matrix = bkgdmat,
  start.matrix= obsmat,
  out.file = "RunOutputs/Simple_02_PoisDAtons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter10000_thin5_Strt.obs_viaFits.out",
  param.file="RunOutputs/Simple_02_PoisDAtons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter10000_thin5_Strt.obs_viaFits.par",
  mcmc=TRUE, fit.bkg.scale = TRUE,
  max.iter=10000, thin=5,
  burn=0,
  alpha.init=c(0.3,0.4,0.5,0.6,0.7,0.8,0.9))

pdf("RunOutputs/PoisDAtons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter10000_thin5_Strt.obs_viaFits_images.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obsmat, xaxt="n", yaxt="n", main="Observed Data")
##image(psfdmat, xaxt="n", yaxt="n", main="Null/Best-Fit/Background Model")
image(img$final, xaxt="n", yaxt="n", main="Mean MultiScale of Data/Model MisMatch")
dev.off()


### Strt=2.00 (way high)

img <- lira(
  obs.matrix = obsmat,
  bkg.matrix = bkgdmat,
  start.matrix= matrix(2.00, nrow=obs$axDat$len[1], ncol=obs$axDat$len[2] ),
  out.file = "RunOutputs/Simple_02_PoisDAtons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter10000_thin5_Strt.02.0_viaFits.out",
  param.file="RunOutputs/Simple_02_PoisDAtons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter10000_thin5_Strt.02.0_viaFits.par",
  mcmc=TRUE, fit.bkg.scale = TRUE,
  max.iter=10000, thin=5,
  burn=0,
  alpha.init=c(0.03,0.04,0.05,0.06,0.07,0.08,0.09))

pdf("RunOutputs/PoisDAtons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter10000_thin5_Strt.02.0_viaFits_images.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obsmat, xaxt="n", yaxt="n", main="Observed Data")
##image(psfdmat, xaxt="n", yaxt="n", main="Null/Best-Fit/Background Model")
image(img$final, xaxt="n", yaxt="n", main="Mean MultiScale of Data/Model MisMatch")
dev.off()


### Strt 0.02 (way low ...)

img <- lira(
  obs.matrix = obsmat,
  bkg.matrix = bkgdmat,
  start.matrix= matrix(0.02, nrow=obs$axDat$len[1], ncol=obs$axDat$len[2] ),
  out.file = "RunOutputs/Simple_02_PoisDAtons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter10000_thin5_Strt.0.02_viaFits.out",
  param.file="RunOutputs/Simple_02_PoisDAtons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter10000_thin5_Strt.0.02_viaFits.par",
  mcmc=TRUE, fit.bkg.scale = TRUE,
  max.iter=10000, thin=5,
  burn=0,
  alpha.init=c(0.003,0.004,0.005,0.006,0.007,0.008,0.009))

pdf("RunOutputs/PoisDAtons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter10000_thin5_Strt.0.02_viaFits_images.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obsmat, xaxt="n", yaxt="n", main="Observed Data")
##image(psfdmat, xaxt="n", yaxt="n", main="Null/Best-Fit/Background Model")
image(img$final, xaxt="n", yaxt="n", main="Mean MultiScale of Data/Model MisMatch")
dev.off()


######################################