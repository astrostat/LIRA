library(lira)
require(FITSio)

obsfile = "Faint_128x128testE_exampledata/PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a.fits"
obs <- readFITS(obsfile)
obsmat <- matrix(data=obs$imDat, nrow=obs$axDat$len[1], ncol=obs$axDat$len[2] )

psffile = "Faint_128x128testE_exampledata/PSFMatGauss2d_Sig_1.5_17x17.101107a.fits"
psf <- readFITS(psffile)
psfmat <- matrix(data=psf$imDat, nrow=psf$axDat$len[1], ncol=psf$axDat$len[2] )
#psfmat <- matrix(data=psf$imDat, nrow=psf$axDat$len[1] )

bkgdfile = "Faint_128x128testE_exampledata/NullModel_128x128FaintE.20120608a.fits"
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
  psf.matrix = psfmat,
  start.matrix= obsmat,
  out.file = "RunOutputs/Simple_04_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter60000_thin20_Strt.obs_viaFits.out",
  param.file="RunOutputs/Simple_04_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter60000_thin20_Strt.obs_viaFits.par",
  mcmc=TRUE, fit.bkg.scale = TRUE,
  max.iter=60000, thin=20,
  burn=0,
  alpha.init=c(0.3,0.4,0.5,0.6,0.7,0.8,0.9))

pdf("RunOutputs/PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter60000_thin20_Strt.obs_viaFits_images.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obsmat, xaxt="n", yaxt="n", main="Observed Data")
##image(psfdmat, xaxt="n", yaxt="n", main="Null/Best-Fit/Background Model")
image(img$final, xaxt="n", yaxt="n", main="Mean MultiScale of Data/Model MisMatch")
dev.off()


### Strt=2.00 (way high)

img <- lira(
  obs.matrix = obsmat,
  bkg.matrix = bkgdmat,
  psf.matrix = psfmat,
  start.matrix= matrix(2.00, nrow=obs$axDat$len[1], ncol=obs$axDat$len[2] ),
  out.file = "RunOutputs/Simple_04_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter60000_thin20_Strt.02.0_viaFits.out",
  param.file="RunOutputs/Simple_04_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter60000_thin20_Strt.02.0_viaFits.par",
  mcmc=TRUE, fit.bkg.scale = TRUE,
  max.iter=60000, thin=20,
  burn=0,
  alpha.init=c(9.5,9.0,8.5,8.0,7.5,7.0,6.5))

pdf("RunOutputs/PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter60000_thin20_Strt.02.0_viaFits_images.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obsmat, xaxt="n", yaxt="n", main="Observed Data")
##image(psfdmat, xaxt="n", yaxt="n", main="Null/Best-Fit/Background Model")
image(img$final, xaxt="n", yaxt="n", main="Mean MultiScale of Data/Model MisMatch")
dev.off()


### Strt 0.02 (way low ...)

img <- lira(
  obs.matrix = obsmat,
  bkg.matrix = bkgdmat,
  psf.matrix = psfmat,
  start.matrix= matrix(0.02, nrow=obs$axDat$len[1], ncol=obs$axDat$len[2] ),
  out.file = "RunOutputs/Simple_04_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter60000_thin20_Strt.0.02_viaFits.out",
  param.file="RunOutputs/Simple_04_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter60000_thin20_Strt.0.02_viaFits.par",
  mcmc=TRUE, fit.bkg.scale = TRUE,
  max.iter=60000, thin=20,
  burn=0,
  alpha.init=c(6.0,7.0,8.0,9.0,6.5,7.5,8.5))

pdf("RunOutputs/PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter60000_thin20_Strt.0.02_viaFits_images.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obsmat, xaxt="n", yaxt="n", main="Observed Data")
##image(psfdmat, xaxt="n", yaxt="n", main="Null/Best-Fit/Background Model")
image(img$final, xaxt="n", yaxt="n", main="Mean MultiScale of Data/Model MisMatch")
dev.off()


######################################