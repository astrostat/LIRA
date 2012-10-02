require(lira)
require(FITSio)

obsfile = "exampledata/PoisDatonsEEMC2_32x32testE.090120c.fits"
obs <- readFITS(obsfile)
obsmat <- matrix(data=obs$imDat, nrow=obs$axDat$len[1], ncol=obs$axDat$len[2] )

bkgdfile = "exampledata/FlatModelEEMC2_32x32testE.090120c.fits"
bkgd <- readFITS(bkgdfile)
bkgdmat <- matrix(data=bkgd$imDat, nrow=bkgd$axDat$len[1], ncol=bkgd$axDat$len[2] )

strtfile = "exampledata/start32x32_1.00.fits"
strt <- readFITS(strtfile)
strtmat <- matrix(data=strt$imDat, nrow=strt$axDat$len[1], ncol=strt$axDat$len[2] )

img <- lira(
  obs.matrix = obsmat,
  bkg.matrix = bkgdmat,
  start.matrix= strtmat,
  out.file = "outputs/PoisDatons32x32EEMC2vsFlatModel_viaFits.out",
  param.file="outputs/PoisDatons32x32EEMC2vsFlatModel_viaFits.param",
  mcmc=TRUE, 
  max.iter=100, thin=1,
  burn=50,
  alpha.init=c(3,4,5,6,7))

pdf("outputs/PoisDatonsEEMC2_32x32testEvsFlatModel_viaFits_images.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obsmat, xaxt="n", yaxt="n", main="Observed Data")
image(bkgdmat, xaxt="n", yaxt="n", main="Background/BestFit/Null Model")
image(img$final, xaxt="n", yaxt="n", main="Mean MultiScale of Data/Null Mis-Match")
dev.off()

