library(lira)
require(FITSio)

########### Now do the same for "Null" datons --
## That is, for 1/2 dozen or so Poisson realizations
## of the Null or baseline model.
## Here we do just two, but it should be several at least:
##

obsfile = "exampledata/SimPois00_128x128testE_conv_Gauss2d_Sig_1.5_17x17.101107a.fits"
obs <- readFITS(obsfile)
obsmat <- matrix(data=obs$imDat, nrow=obs$axDat$len[1], ncol=obs$axDat$len[2] )

psffile = "exampledata/PSFMatGauss2d_Sig_1.5_17x17.101107a.fits"
psf <- readFITS(psffile)
psfmat <- matrix(data=psf$imDat, nrow=psf$axDat$len[1], ncol=psf$axDat$len[2] )

bkgdfile = "exampledata/NullModel_128x128testE_conv_Gauss2d_Sig_1.5_17x17.101107a.fits"
bkgd <- readFITS(bkgdfile)
bkgdmat <- matrix(data=bkgd$imDat, nrow=bkgd$axDat$len[1], ncol=bkgd$axDat$len[2] )

strtfile = "exampledata/start32x32_1.00.fits"
strt <- readFITS(strtfile)
strtmat <- matrix(data=strt$imDat, nrow=strt$axDat$len[1], ncol=strt$axDat$len[2] )

img <- lira(
  obs.matrix = obsmat,
  bkg.matrix = bkgdmat,
  psf.matrix = psfmat,
  start.matrix= matrix( 1.0, nrow=obs$axDat$len[1], ncol=obs$axDat$len[2] ),
  out.file = "RunOutputs/Simple04_Gauss2dSig1.5_17x17PSF_SimPois00_128x128testEvsNullModel.out",
  param.file="RunOutputs/Simple04_Gauss2dSig1.5_17x17PSF_SimPois00_128x128testEvsNullModel.param",
  mcmc=TRUE, 
  max.iter=16000, thin=10,
  burn=0,
  alpha.init=c(3,4,5,6,7,8,9))

pdf("RunOutputs/Simple04_Gauss2dSig1.5_17x17PSF_SimPois00_128x128testEvsNullModel_images.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obsmat, xaxt="n", yaxt="n", main="Simulated Datons")
image(bkgdmat, xaxt="n", yaxt="n", main="Background/BestFit/Null Model")
image(img$final, xaxt="n", yaxt="n", main="Mean MultiScale of Data/Null Mis-Match")
dev.off()

obsfile = "exampledata/SimPois01_128x128testE_conv_Gauss2d_Sig_1.5_17x17.101107a.fits"
obs <- readFITS(obsfile)
obsmat <- matrix(data=obs$imDat, nrow=obs$axDat$len[1], ncol=obs$axDat$len[2] )

strtfile = "exampledata/start32x32_0.01.fits"
strt <- readFITS(strtfile)
strtmat <- matrix(data=strt$imDat, nrow=strt$axDat$len[1], ncol=strt$axDat$len[2] )

img <- lira(
  obs.matrix = obsmat,
  bkg.matrix = bkgdmat,
  psf.matrix = psfmat,
  start.matrix= matrix( 0.01, nrow=obs$axDat$len[1], ncol=obs$axDat$len[2] ),
  out.file = "RunOutputs/Simple04_Gauss2dSig1.5_17x17PSF_SimPois01_128x128testEvsNullModel.out",
  param.file="RunOutputs/Simple04_Gauss2dSig1.5_17x17PSF_SimPois01_128x128testEvsNullModel.param",
  mcmc=TRUE, 
  max.iter=16000, thin=10,
  burn=0,
  alpha.init=c(3,4,5,6,7,8,9))

pdf("RunOutputs/Simple04_Gauss2dSig1.5_17x17PSF_SimPois01_128x128testEvsNullModel_images.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obsmat, xaxt="n", yaxt="n", main="Simulated Datons")
image(bkgdmat, xaxt="n", yaxt="n", main="Background/BestFit/Null Model")
image(img$final, xaxt="n", yaxt="n", main="Mean MultiScale of Data/Null Mis-Match")
dev.off()


obsfile = "exampledata/SimPois02_128x128testE_conv_Gauss2d_Sig_1.5_17x17.101107a.fits"
obs <- readFITS(obsfile)
obsmat <- matrix(data=obs$imDat, nrow=obs$axDat$len[1], ncol=obs$axDat$len[2] )

strtfile = "exampledata/start32x32_1.00.fits"
strt <- readFITS(strtfile)
strtmat <- matrix(data=strt$imDat, nrow=strt$axDat$len[1], ncol=strt$axDat$len[2] )

img <- lira(
  obs.matrix = obsmat,
  bkg.matrix = bkgdmat,
  psf.matrix = psfmat,
  start.matrix= matrix( 1.0, nrow=obs$axDat$len[1], ncol=obs$axDat$len[2] ),
  out.file = "RunOutputs/Simple04_Gauss2dSig1.5_17x17PSF_SimPois02_128x128testEvsNullModel.out",
  param.file="RunOutputs/Simple04_Gauss2dSig1.5_17x17PSF_SimPois02_128x128testEvsNullModel.param",
  mcmc=TRUE, 
  max.iter=16000, thin=10,
  burn=0,
  alpha.init=c(3,4,5,6,7,8,9))

pdf("RunOutputs/Simple04_Gauss2dSig1.5_17x17PSF_SimPois02_128x128testEvsNullModel_images.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obsmat, xaxt="n", yaxt="n", main="Simulated Datons")
image(bkgdmat, xaxt="n", yaxt="n", main="Background/BestFit/Null Model")
image(img$final, xaxt="n", yaxt="n", main="Mean MultiScale of Data/Null Mis-Match")
dev.off()

obsfile = "exampledata/SimPois03_128x128testE_conv_Gauss2d_Sig_1.5_17x17.101107a.fits"
obs <- readFITS(obsfile)
obsmat <- matrix(data=obs$imDat, nrow=obs$axDat$len[1], ncol=obs$axDat$len[2] )

strtfile = "exampledata/start32x32_0.01.fits"
strt <- readFITS(strtfile)
strtmat <- matrix(data=strt$imDat, nrow=strt$axDat$len[1], ncol=strt$axDat$len[2] )

img <- lira(
  obs.matrix = obsmat,
  bkg.matrix = bkgdmat,
  psf.matrix = psfmat,
  start.matrix= matrix( 0.01, nrow=obs$axDat$len[1], ncol=obs$axDat$len[2] ),
  out.file = "RunOutputs/Simple04_Gauss2dSig1.5_17x17PSF_SimPois03_128x128testEvsNullModel.out",
  param.file="RunOutputs/Simple04_Gauss2dSig1.5_17x17PSF_SimPois03_128x128testEvsNullModel.param",
  mcmc=TRUE, 
  max.iter=16000, thin=10,
  burn=0,
  alpha.init=c(3,4,5,6,7,8,9))

pdf("RunOutputs/Simple04_Gauss2dSig1.5_17x17PSF_SimPois03_128x128testEvsNullModel_images.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obsmat, xaxt="n", yaxt="n", main="Simulated Datons")
image(bkgdmat, xaxt="n", yaxt="n", main="Background/BestFit/Null Model")
image(img$final, xaxt="n", yaxt="n", main="Mean MultiScale of Data/Null Mis-Match")
dev.off()


obsfile = "exampledata/SimPois04_128x128testE_conv_Gauss2d_Sig_1.5_17x17.101107a.fits"
obs <- readFITS(obsfile)
obsmat <- matrix(data=obs$imDat, nrow=obs$axDat$len[1], ncol=obs$axDat$len[2] )

strtfile = "exampledata/start32x32_1.00.fits"
strt <- readFITS(strtfile)
strtmat <- matrix(data=strt$imDat, nrow=strt$axDat$len[1], ncol=strt$axDat$len[2] )

img <- lira(
  obs.matrix = obsmat,
  bkg.matrix = bkgdmat,
  psf.matrix = psfmat,
  start.matrix= matrix( 1.0, nrow=obs$axDat$len[1], ncol=obs$axDat$len[2] ),
  out.file = "RunOutputs/Simple04_Gauss2dSig1.5_17x17PSF_SimPois04_128x128testEvsNullModel.out",
  param.file="RunOutputs/Simple04_Gauss2dSig1.5_17x17PSF_SimPois04_128x128testEvsNullModel.param",
  mcmc=TRUE, 
  max.iter=16000, thin=10,
  burn=0,
  alpha.init=c(3,4,5,6,7,8,9))

pdf("RunOutputs/Simple04_Gauss2dSig1.5_17x17PSF_SimPois04_128x128testEvsNullModel_images.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obsmat, xaxt="n", yaxt="n", main="Simulated Datons")
image(bkgdmat, xaxt="n", yaxt="n", main="Background/BestFit/Null Model")
image(img$final, xaxt="n", yaxt="n", main="Mean MultiScale of Data/Null Mis-Match")
dev.off()

obsfile = "exampledata/SimPois05_128x128testE_conv_Gauss2d_Sig_1.5_17x17.101107a.fits"
obs <- readFITS(obsfile)
obsmat <- matrix(data=obs$imDat, nrow=obs$axDat$len[1], ncol=obs$axDat$len[2] )

strtfile = "exampledata/start32x32_0.01.fits"
strt <- readFITS(strtfile)
strtmat <- matrix(data=strt$imDat, nrow=strt$axDat$len[1], ncol=strt$axDat$len[2] )

img <- lira(
  obs.matrix = obsmat,
  bkg.matrix = bkgdmat,
  psf.matrix = psfmat,
  start.matrix= matrix( 0.01, nrow=obs$axDat$len[1], ncol=obs$axDat$len[2] ),
  out.file = "RunOutputs/Simple04_Gauss2dSig1.5_17x17PSF_SimPois05_128x128testEvsNullModel.out",
  param.file="RunOutputs/Simple04_Gauss2dSig1.5_17x17PSF_SimPois05_128x128testEvsNullModel.param",
  mcmc=TRUE, 
  max.iter=16000, thin=10,
  burn=0,
  alpha.init=c(3,4,5,6,7,8,9))

pdf("RunOutputs/Simple04_Gauss2dSig1.5_17x17PSF_SimPois05_128x128testEvsNullModel_images.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obsmat, xaxt="n", yaxt="n", main="Simulated Datons")
image(bkgdmat, xaxt="n", yaxt="n", main="Background/BestFit/Null Model")
image(img$final, xaxt="n", yaxt="n", main="Mean MultiScale of Data/Null Mis-Match")
dev.off()

