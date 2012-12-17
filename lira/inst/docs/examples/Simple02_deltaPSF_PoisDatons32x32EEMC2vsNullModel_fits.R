library(lira)
require(FITSio)

obsfile = "exampledata/PoisDatonsEEMC2_32x32testE.090120c.fits"
obs <- readFITS(obsfile)
obsmat <- matrix(data=obs$imDat, nrow=obs$axDat$len[1], ncol=obs$axDat$len[2] )

bkgdfile = "exampledata/NullModelEEMC2_32x32testE.090120c.fits"
bkgd <- readFITS(bkgdfile)
bkgdmat <- matrix(data=bkgd$imDat, nrow=bkgd$axDat$len[1], ncol=bkgd$axDat$len[2] )

### Now doing analysis runs:
###

strtfile = "exampledata/start32x32_1.00.fits"
strt <- readFITS(strtfile)
strtmat <- matrix(data=strt$imDat, nrow=strt$axDat$len[1], ncol=strt$axDat$len[2] )

img <- lira(
  obs.matrix = obsmat,
  bkg.matrix = bkgdmat,
  start.matrix= strtmat,
  out.file = "RunOutputs/PoisDatons32x32EEMC2vsNullModel_Strt1.00_viaFits.out",
  param.file="RunOutputs/PoisDatons32x32EEMC2vsNullModel_Strt1.00_viaFits.param",
  mcmc=TRUE, 
  max.iter=2000, thin=5,
  burn=0,
  alpha.init=c(3,4,5,6,7))

pdf("RunOutputs/PoisDatonsEEMC2_32x32testEvsNullModel_Strt1.00_viaFits_images.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obsmat, xaxt="n", yaxt="n", main="Observed Data")
image(bkgdmat, xaxt="n", yaxt="n", main="Background/BestFit/Null Model")
image(img$final, xaxt="n", yaxt="n", main="Mean MultiScale of Data/Null Mis-Match")
dev.off()


strtfile = "exampledata/start32x32_0.01.fits"
strt <- readFITS(strtfile)
strtmat <- matrix(data=strt$imDat, nrow=strt$axDat$len[1], ncol=strt$axDat$len[2] )

img <- lira(
  obs.matrix = obsmat,
  bkg.matrix = bkgdmat,
  start.matrix= strtmat,
  out.file = "RunOutputs/PoisDatons32x32EEMC2vsNullModel_Strt0.01_viaFits.out",
  param.file="RunOutputs/PoisDatons32x32EEMC2vsNullModel_Strt0.01_viaFits.param",
  mcmc=TRUE, 
  max.iter=2000, thin=5,
  burn=0,
  alpha.init=c(3,4,5,6,7))

pdf("RunOutputs/PoisDatonsEEMC2_32x32testEvsNullModel_Strt0.01_viaFits_images.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obsmat, xaxt="n", yaxt="n", main="Observed Data")
image(bkgdmat, xaxt="n", yaxt="n", main="Background/BestFit/Null Model")
image(img$final, xaxt="n", yaxt="n", main="Mean MultiScale of Data/Null Mis-Match")
dev.off()


########### Now do the same for "Null" datons --
## That is, for 1/2 dozen or so Poisson realizations
## of the Null or baseline model.
## Here we do just two, but it should be several at least:
##

obsfile = "exampledata/PoisNulDat0EEMC2_32x32testE.090120c.fits"
obs <- readFITS(obsfile)
obsmat <- matrix(data=obs$imDat, nrow=obs$axDat$len[1], ncol=obs$axDat$len[2] )

strtfile = "exampledata/start32x32_1.00.fits"
strt <- readFITS(strtfile)
strtmat <- matrix(data=strt$imDat, nrow=strt$axDat$len[1], ncol=strt$axDat$len[2] )

img <- lira(
  obs.matrix = obsmat,
  bkg.matrix = bkgdmat,
  start.matrix= strtmat,
  out.file = "RunOutputs/PoisNulDat032x32EEMC2vsNullModel_Strt1.00_viaFits.out",
  param.file="RunOutputs/PoisNulDat032x32EEMC2vsNullModel_Strt1.00_viaFits.param",
  mcmc=TRUE, 
  max.iter=700, thin=5,
  burn=0,
  alpha.init=c(3,4,5,6,7))

pdf("RunOutputs/PoisNulDat0EEMC2_32x32testEvsNullModel_Strt1.00_viaFits_images.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obsmat, xaxt="n", yaxt="n", main="Observed Data")
image(bkgdmat, xaxt="n", yaxt="n", main="Background/BestFit/Null Model")
image(img$final, xaxt="n", yaxt="n", main="Mean MultiScale of Data/Null Mis-Match")
dev.off()

obsfile = "exampledata/PoisNulDat1EEMC2_32x32testE.090120c.fits"
obs <- readFITS(obsfile)
obsmat <- matrix(data=obs$imDat, nrow=obs$axDat$len[1], ncol=obs$axDat$len[2] )

strtfile = "exampledata/start32x32_0.01.fits"
strt <- readFITS(strtfile)
strtmat <- matrix(data=strt$imDat, nrow=strt$axDat$len[1], ncol=strt$axDat$len[2] )

img <- lira(
  obs.matrix = obsmat,
  bkg.matrix = bkgdmat,
  start.matrix= strtmat,
  out.file = "RunOutputs/PoisNulDat132x32EEMC2vsNullModel_Strt0.01_viaFits.out",
  param.file="RunOutputs/PoisNulDat132x32EEMC2vsNullModel_Strt0.01_viaFits.param",
  mcmc=TRUE, 
  max.iter=700, thin=5,
  burn=0,
  alpha.init=c(3,4,5,6,7))

pdf("RunOutputs/PoisNulDat1EEMC2_32x32testEvsNullModel_Strt0.01_viaFits_images.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obsmat, xaxt="n", yaxt="n", main="Observed Data")
image(bkgdmat, xaxt="n", yaxt="n", main="Background/BestFit/Null Model")
image(img$final, xaxt="n", yaxt="n", main="Mean MultiScale of Data/Null Mis-Match")
dev.off()


obsfile = "exampledata/PoisNulDat2EEMC2_32x32testE.090120c.fits"
obs <- readFITS(obsfile)
obsmat <- matrix(data=obs$imDat, nrow=obs$axDat$len[1], ncol=obs$axDat$len[2] )

strtfile = "exampledata/start32x32_1.00.fits"
strt <- readFITS(strtfile)
strtmat <- matrix(data=strt$imDat, nrow=strt$axDat$len[1], ncol=strt$axDat$len[2] )

img <- lira(
  obs.matrix = obsmat,
  bkg.matrix = bkgdmat,
  start.matrix= strtmat,
  out.file = "RunOutputs/PoisNulDat232x32EEMC2vsNullModel_Strt1.00_viaFits.out",
  param.file="RunOutputs/PoisNulDat232x32EEMC2vsNullModel_Strt1.00_viaFits.param",
  mcmc=TRUE, 
  max.iter=700, thin=5,
  burn=0,
  alpha.init=c(3,4,5,6,7))

pdf("RunOutputs/PoisNulDat2EEMC2_32x32testEvsNullModel_Strt1.00_viaFits_images.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obsmat, xaxt="n", yaxt="n", main="Observed Data")
image(bkgdmat, xaxt="n", yaxt="n", main="Background/BestFit/Null Model")
image(img$final, xaxt="n", yaxt="n", main="Mean MultiScale of Data/Null Mis-Match")
dev.off()

obsfile = "exampledata/PoisNulDat3EEMC2_32x32testE.090120c.fits"
obs <- readFITS(obsfile)
obsmat <- matrix(data=obs$imDat, nrow=obs$axDat$len[1], ncol=obs$axDat$len[2] )

strtfile = "exampledata/start32x32_0.01.fits"
strt <- readFITS(strtfile)
strtmat <- matrix(data=strt$imDat, nrow=strt$axDat$len[1], ncol=strt$axDat$len[2] )

img <- lira(
  obs.matrix = obsmat,
  bkg.matrix = bkgdmat,
  start.matrix= strtmat,
  out.file = "RunOutputs/PoisNulDat332x32EEMC2vsNullModel_Strt0.01_viaFits.out",
  param.file="RunOutputs/PoisNulDat332x32EEMC2vsNullModel_Strt0.01_viaFits.param",
  mcmc=TRUE, 
  max.iter=700, thin=5,
  burn=0,
  alpha.init=c(3,4,5,6,7))

pdf("RunOutputs/PoisNulDat3EEMC2_32x32testEvsNullModel_Strt0.01_viaFits_images.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obsmat, xaxt="n", yaxt="n", main="Observed Data")
image(bkgdmat, xaxt="n", yaxt="n", main="Background/BestFit/Null Model")
image(img$final, xaxt="n", yaxt="n", main="Mean MultiScale of Data/Null Mis-Match")
dev.off()


obsfile = "exampledata/PoisNulDat4EEMC2_32x32testE.090120c.fits"
obs <- readFITS(obsfile)
obsmat <- matrix(data=obs$imDat, nrow=obs$axDat$len[1], ncol=obs$axDat$len[2] )

strtfile = "exampledata/start32x32_1.00.fits"
strt <- readFITS(strtfile)
strtmat <- matrix(data=strt$imDat, nrow=strt$axDat$len[1], ncol=strt$axDat$len[2] )

img <- lira(
  obs.matrix = obsmat,
  bkg.matrix = bkgdmat,
  start.matrix= strtmat,
  out.file = "RunOutputs/PoisNulDat432x32EEMC2vsNullModel_Strt1.00_viaFits.out",
  param.file="RunOutputs/PoisNulDat432x32EEMC2vsNullModel_Strt1.00_viaFits.param",
  mcmc=TRUE, 
  max.iter=700, thin=5,
  burn=0,
  alpha.init=c(3,4,5,6,7))

pdf("RunOutputs/PoisNulDat4EEMC2_32x32testEvsNullModel_Strt1.00_viaFits_images.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obsmat, xaxt="n", yaxt="n", main="Observed Data")
image(bkgdmat, xaxt="n", yaxt="n", main="Background/BestFit/Null Model")
image(img$final, xaxt="n", yaxt="n", main="Mean MultiScale of Data/Null Mis-Match")
dev.off()

obsfile = "exampledata/PoisNulDat5EEMC2_32x32testE.090120c.fits"
obs <- readFITS(obsfile)
obsmat <- matrix(data=obs$imDat, nrow=obs$axDat$len[1], ncol=obs$axDat$len[2] )

strtfile = "exampledata/start32x32_0.01.fits"
strt <- readFITS(strtfile)
strtmat <- matrix(data=strt$imDat, nrow=strt$axDat$len[1], ncol=strt$axDat$len[2] )

img <- lira(
  obs.matrix = obsmat,
  bkg.matrix = bkgdmat,
  start.matrix= strtmat,
  out.file = "RunOutputs/PoisNulDat532x32EEMC2vsNullModel_Strt0.01_viaFits.out",
  param.file="RunOutputs/PoisNulDat532x32EEMC2vsNullModel_Strt0.01_viaFits.param",
  mcmc=TRUE, 
  max.iter=700, thin=5,
  burn=0,
  alpha.init=c(3,4,5,6,7))

pdf("RunOutputs/PoisNulDat5EEMC2_32x32testEvsNullModel_Strt0.01_viaFits_images.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obsmat, xaxt="n", yaxt="n", main="Observed Data")
image(bkgdmat, xaxt="n", yaxt="n", main="Background/BestFit/Null Model")
image(img$final, xaxt="n", yaxt="n", main="Mean MultiScale of Data/Null Mis-Match")
dev.off()

