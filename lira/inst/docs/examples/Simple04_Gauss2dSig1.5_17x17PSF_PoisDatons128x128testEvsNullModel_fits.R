library(lira)
require(FITSio)

obsfile = "exampledata/PoisDatons_128x128testE_conv_Gauss2d_Sig_1.5_17x17.101107a.fits"
obs <- readFITS(obsfile)
obsmat <- matrix(data=obs$imDat, nrow=obs$axDat$len[1], ncol=obs$axDat$len[2] )

psffile = "exampledata/PSFMatGauss2d_Sig_1.5_17x17.101107a.fits"
psf <- readFITS(psffile)
psfmat <- matrix(data=psf$imDat, nrow=psf$axDat$len[1], ncol=psf$axDat$len[2] )

bkgdfile = "exampledata/NullModel_128x128testE_conv_Gauss2d_Sig_1.5_17x17.101107a.fits"
bkgd <- readFITS(bkgdfile)
bkgdmat <- matrix(data=bkgd$imDat, nrow=bkgd$axDat$len[1], ncol=bkgd$axDat$len[2] )

#strtfile = "exampledata/start32x32_1.00.fits"
#strt <- readFITS(strtfile)
#strtmat <- matrix(data=strt$imDat, nrow=strt$axDat$len[1], ncol=strt$axDat$len[2] )

### First run to look at burn-in, autocorrealtion:
###

img <- lira(
  obs.matrix = obsmat,
  bkg.matrix = bkgdmat,
  psf.matrix = psfmat,
  start.matrix= matrix(1.00, nrow=obs$axDat$len[1], ncol=obs$axDat$len[2] ),
  out.file = "RunOutputs/Simple04_Gauss2d1.5_PoisDatons128x128testEvsNull_Strt1.00_viaFits.out",
  param.file="RunOutputs/Simple04_Gauss2d1.5_PoisDatons128x128testEvsNull_Strt1.00_viaFits.param",
  mcmc=TRUE, fit.bkg.scale = TRUE,
  max.iter=10000, thin=10,
  burn=0,
  alpha.init=c(3,4,5,6,7,8,9))

pdf("RunOutputs/Simple04_Gauss2d1.5_PoisDatons128x128testE_Strt1.00_viaFits_images.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obsmat, xaxt="n", yaxt="n", main="Observed Data")
image(bkgdmat, xaxt="n", yaxt="n", main="Null/Best-Fit/Background Model")
image(img$final, xaxt="n", yaxt="n", main="Mean MultiScale of Data/Model MisMatch")
dev.off()


#strtfile = "exampledata/start32x32_0.01.fits"
#strt <- readFITS(strtfile)
#strtmat <- matrix(data=strt$imDat, nrow=strt$axDat$len[1], ncol=strt$axDat$len[2] )

img <- lira(
  obs.matrix = obsmat,
  bkg.matrix = bkgdmat,
  psf.matrix=psfmat,
  start.matrix= matrix(0.01, nrow=obs$axDat$len[1], ncol=obs$axDat$len[2] ),
  out.file = "RunOutputs/Simple04_Gauss2d1.5_PoisDatons128x128testEvsNull_Strt0.01_viaFits.out",
  param.file="RunOutputs/Simple04_Gauss2d1.5_PoisDatons128x128testEvsNull_Strt0.01_viaFits.param",
  mcmc=TRUE, fit.bkg.scale = TRUE,
  max.iter=10000, thin=10,
  burn=0,
  alpha.init=c(3,4,5,6,7,8,9))

pdf("RunOutputs/Simple04_Gauss2d1.5_PoisDatons128x128testE_Strt0.01_viaFits_images.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obsmat, xaxt="n", yaxt="n", main="Observed Data")
image(psfdmat, xaxt="n", yaxt="n", main="Null/Best-Fit/Background Model")
image(img$final, xaxt="n", yaxt="n", main="Mean MultiScale of Data/Model MisMatch")
dev.off()


img <- lira(
  obs.matrix = obsmat,
  bkg.matrix = bkgdmat,
  psf.matrix=psfmat,
  start.matrix= obsmat,
  out.file = "RunOutputs/Simple04_Gauss2d1.5_PoisDatons128x128testEvsNull_Strt0obs_viaFits.out",
  param.file="RunOutputs/Simple04_Gauss2d1.5_PoisDatons128x128testEvsNull_Strt0obs_viaFits.param",
  mcmc=TRUE, fit.bkg.scale = TRUE,
  max.iter=10000, thin=10,
  burn=0,
  alpha.init=c(3,4,5,6,7,8,9))

pdf("RunOutputs/Simple04_Gauss2d1.5_PoisDatons128x128testE_Strt0.01_viaFits_images.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obsmat, xaxt="n", yaxt="n", main="Observed Data")
image(psfdmat, xaxt="n", yaxt="n", main="Null/Best-Fit/Background Model")
image(img$final, xaxt="n", yaxt="n", main="Mean MultiScale of Data/Model MisMatch")
dev.off()
