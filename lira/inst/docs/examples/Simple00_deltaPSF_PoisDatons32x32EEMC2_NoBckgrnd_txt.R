require(lira)
require(FITSio)

dataimage <- array(
   scan("exampledata/PoisDatonsEEMC2_32x32testE.090120c.txt"),
   c(32,32))

startimage  <- array(
  scan("exampledata/start32x32_1.00.txt"),
  c(32,32))

img <- lira(
  obs.matrix = dataimage,
  start.matrix= startimage,
  out.file = "RunOutputs/PoisDatons32x32EEMC2_NoBckgrnd.out",
  param.file="RunOutputs/PoisDatons32x32EEMC2_NoBckgrnd.param",
  mcmc=TRUE, , fit.bkg.scale = FALSE,
  max.iter=1000, thin=1,
  burn=0,
  alpha.init=c(3,4,5,6,7))

pdf("RunOutputs/PoisDatonsEEMC2_32x32testE_NoBckgrnd_images.pdf", width=8, height=4.25)
par(mfrow=c(1,2))
initial.image <- array(
  scan("exampledata/PoisDatonsEEMC2_32x32testE.090120c.txt"), 
  c(32,32))

image(initial.image, xaxt="n", yaxt="n", main="Observed Data")
image(img$final, xaxt="n", yaxt="n", main="Final")
dev.off()
