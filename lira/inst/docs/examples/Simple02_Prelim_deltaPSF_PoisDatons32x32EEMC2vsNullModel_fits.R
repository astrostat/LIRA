library(lira)
require(FITSio)

obsfile = "exampledata/PoisDatonsEEMC2_32x32testE.090120c.fits"
obs <- readFITS(obsfile)
obsmat <- matrix(data=obs$imDat, nrow=obs$axDat$len[1], ncol=obs$axDat$len[2] )

bkgdfile = "exampledata/NullModelEEMC2_32x32testE.090120c.fits"
bkgd <- readFITS(bkgdfile)
bkgdmat <- matrix(data=bkgd$imDat, nrow=bkgd$axDat$len[1], ncol=bkgd$axDat$len[2] )

strtfile = "exampledata/start32x32_1.00.fits"
strt <- readFITS(strtfile)
strtmat <- matrix(data=strt$imDat, nrow=strt$axDat$len[1], ncol=strt$axDat$len[2] )

### First run to look at burn-in, autocorrealtion:
###

img <- lira(
  obs.matrix = obsmat,
  bkg.matrix = bkgdmat,
  start.matrix= strtmat,
  out.file = "outputs/Prelim_PoisDatons32x32EEMC2vsNullModel_Strt1.00_viaFits.out",
  param.file="outputs/Prelim_PoisDatons32x32EEMC2vsNullModel_Strt1.00_viaFits.param",
  mcmc=TRUE, 
  max.iter=300, thin=1,
  burn=0,
  alpha.init=c(3,4,5,6,7))

pdf("outputs/Prelim_PoisDatonsEEMC2_32x32testEvsNullModel_Strt1.00_viaFits_images.pdf", width=12, height=4.25)
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
  out.file = "outputs/Prelim_PoisDatons32x32EEMC2vsNullModel_Strt0.01_viaFits.out",
  param.file="outputs/Prelim_PoisDatons32x32EEMC2vsNullModel_Strt0.01_viaFits.param",
  mcmc=TRUE, 
  max.iter=300, thin=1,
  burn=0,
  alpha.init=c(3,4,5,6,7))

pdf("outputs/Prelim_PoisDatonsEEMC2_32x32testEvsNullModel_Strt0.01_viaFits_images.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obsmat, xaxt="n", yaxt="n", main="Observed Data")
image(bkgdmat, xaxt="n", yaxt="n", main="Background/BestFit/Null Model")
image(img$final, xaxt="n", yaxt="n", main="Mean MultiScale of Data/Null Mis-Match")
dev.off()
