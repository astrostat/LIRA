library(lira)
require(FITSio)

obsfile = "exampledata/PoisDatons_128x128testE_conv_Gauss2d_Sig_1.5_17x17.101107a.fits"
obs <- readFITS(obsfile)
obsmat <- matrix(data=obs$imDat, nrow=obs$axDat$len[1], ncol=obs$axDat$len[2] )

psffile = "exampledata/PSFMatGauss2d_Sig_1.5_17x17.101107a.fits"
psf <- readFITS(psffile)
psfmat <- matrix(data=psf$imDat, nrow=psf$axDat$len[1], ncol=psf$axDat$len[2] )

#bkgdfile = "exampledata/NullModelEEMC2_32x32testE.090120c.fits"
#bkgd <- readFITS(bkgdfile)
#bkgdmat <- matrix(data=bkgd$imDat, nrow=bkgd$axDat$len[1], ncol=bkgd$axDat$len[2] )

#strtfile = "exampledata/start32x32_1.00.fits"
#strt <- readFITS(strtfile)
#strtmat <- matrix(data=strt$imDat, nrow=strt$axDat$len[1], ncol=strt$axDat$len[2] )

### First run to look at burn-in, autocorrealtion:
###

img <- lira(
  obs.matrix = obsmat,
  psf.matrix=psfmat,
  start.matrix= matrix(1.00, nrow=obs$axDat$len[1], ncol=obs$axDat$len[2] ),
  out.file = "RunOutputs/Simple03_Prelim_Gauss2d1.5_PoisDatons128x128testE_Strt1.00_viaFits.out",
  param.file="RunOutputs/Simple03_Prelim_Gauss2d1.5_PoisDatons128x128testE_Strt1.00_viaFits.param",
  mcmc=TRUE, fit.bkg.scale = FALSE,
  max.iter=300, thin=1,
  burn=0,
  alpha.init=c(3,4,5,6,7,8,9))

pdf("RunOutputs/Simple03_Prelim_Gauss2d1.5_PoisDatons128x128testE_Strt1.00_viaFits_images.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obsmat, xaxt="n", yaxt="n", main="Observed Data")
image(psfmat, xaxt="n", yaxt="n", main="PSF")
image(img$final, xaxt="n", yaxt="n", main="Mean MultiScale of Restoration")
dev.off()


#strtfile = "exampledata/start32x32_0.01.fits"
#strt <- readFITS(strtfile)
#strtmat <- matrix(data=strt$imDat, nrow=strt$axDat$len[1], ncol=strt$axDat$len[2] )

img <- lira(
  obs.matrix = obsmat,
  psf.matrix=psfmat,
  start.matrix= matrix(0.01, nrow=obs$axDat$len[1], ncol=obs$axDat$len[2] ),
  out.file = "RunOutputs/Simple03_Prelim_Gauss2d1.5_PoisDatons128x128testE_Strt0.01_viaFits.out",
  param.file="RunOutputs/Simple03_Prelim_Gauss2d1.5_PoisDatons128x128testE_Strt0.01_viaFits.param",
  mcmc=TRUE, fit.bkg.scale = FALSE,
  max.iter=300, thin=1,
  burn=0,
  alpha.init=c(3,4,5,6,7,8,9))

pdf("RunOutputs/Simple03_Prelim_Gauss2d1.5_PoisDatons128x128testE_Strt0.01_viaFits_images.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obsmat, xaxt="n", yaxt="n", main="Observed Data")
image(psfdmat, xaxt="n", yaxt="n", main="PSF")
image(img$final, xaxt="n", yaxt="n", main="Mean MultiScale of Restoration")
dev.off()
