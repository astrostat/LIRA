library(lira)

dataimage <- array(
   scan("exampledata/PoisDatonsEEMC2_32x32testE.090120c.txt"),
   c(32,32))
bkgdimage <- array(
    scan("exampledata/NullModelEEMC2_32x32testE.090120c.txt"),
    c(32,32))
startimage  <- array(
  scan("exampledata/start32x32_1.00.txt"),
  c(32,32))

img <- lira(
  obs.matrix = dataimage,
  bkg.matrix = bkgdimage,
  start.matrix= startimage,
  out.file = "RunOutputs/PoisDatons32x32EEMC2vsNullModel.out",
  param.file="RunOutputs/PoisDatons32x32EEMC2vsNullModel.param",
  mcmc=TRUE, 
  max.iter=550, thin=5,
  burn=50,
  alpha.init=c(3,4,5,6,7))

pdf("RunOutputs/PoisDatonsEEMC2_32x32testEvsNullModel_images.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
initial.image <- array(
  scan("exampledata/PoisDatonsEEMC2_32x32testE.090120c.txt"), 
  c(32,32))
model.image <- array(
  scan("exampledata/NullModelEEMC2_32x32testE.090120c.txt"),
  c(32,32))
image(initial.image, xaxt="n", yaxt="n", main="Observed Data")
image(model.image, xaxt="n", yaxt="n", main="Null Model")
image(img$final, xaxt="n", yaxt="n", main="Final")
dev.off()
