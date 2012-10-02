library(lira)
require(FITSio)

#psffile = "Unity.fits"
#psf <- readFITS(psffile)
##psfmat <- matrix(data=psf$imDat, nrow=psf$axDat$len[1], ncol=psf$axDat$len[2] )
psffile = "Faint_128x128testE_exampledata/PSFMatGauss2d_Sig_1.5_17x17.101107a.fits"
psf <- readFITS(psffile)
psfmat <- matrix(data=psf$imDat, nrow=psf$axDat$len[1], ncol=psf$axDat$len[2] )

bkgdfile = "Faint_128x128testE_exampledata/NullModel_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a.fits"
bkgd <- readFITS(bkgdfile)
bkgdmat <- matrix(data=bkgd$imDat, nrow=bkgd$axDat$len[1], ncol=bkgd$axDat$len[2] )

#strtfile = "exampledata/start32x32_1.00.fits"
#strt <- readFITS(strtfile)
#strtmat <- matrix(data=strt$imDat, nrow=strt$axDat$len[1], ncol=strt$axDat$len[2] )

### Second runs to look at full McMC

#########################################################################################
### Strt=obs:

obs0file = "Faint_128x128testE_exampledata/PoisNull00_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a.fits"
obs0 <- readFITS(obs0file)
obs0mat <- matrix(data=obs0$imDat, nrow=obs0$axDat$len[1], ncol=obs0$axDat$len[2] )

#pdf("RunOutputs/PoisNull00_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.obs_viaFits_before.pdf", width=12, height=4.25)
#par(mfrow=c(1,3))
#image(obs0mat, xaxt="n", yaxt="n", main="BEFORE - Observed Data")
#image(bkgdmat, xaxt="n", yaxt="n", main="BEFORE - Null/Best-Fit/Background Model")
##image(img$final, xaxt="n", yaxt="n", main="BEFORE - Mean MultiScale of Data/Model MisMatch")
#dev.off()

img <- lira(
  obs.matrix = obs0mat,
  bkg.matrix = bkgdmat,
  psf.matrix = psfmat,
  start.matrix= obs0mat,
  out.file = "RunOutputs/Simple_04_PoisNull00_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.obs_viaFits.out",
  param.file="RunOutputs/Simple_04_PoisNull00_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.obs_viaFits.par",
  mcmc=TRUE, fit.bkg.scale = TRUE,
  max.iter=20500, thin=20,
  burn=0,
  alpha.init=c(0.3,0.4,0.5,0.6,0.7,0.8,0.9))

pdf("RunOutputs/PoisNull00_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.obs_viaFits_after.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obs0mat, xaxt="n", yaxt="n", main="AFTER - Observed Data")
image(bkgdmat, xaxt="n", yaxt="n", main="AFTER - Null/Best-Fit/Background Model")
image(img$final, xaxt="n", yaxt="n", main="AFTER - Mean MultiScale of Data/Model MisMatch")
dev.off()


### Strt=2.00 (way high)

obs1file = "Faint_128x128testE_exampledata/PoisNull01_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a.fits"
obs1 <- readFITS(obs1file)
obs1mat <- matrix(data=obs1$imDat, nrow=obs1$axDat$len[1], ncol=obs1$axDat$len[2] )

#pdf("RunOutputs/PoisNull01_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.02.0_viaFits_before.pdf", width=12, height=4.25)
#par(mfrow=c(1,3))
#image(obs1mat, xaxt="n", yaxt="n", main="BEFORE - Observed Data")
#image(bkgdmat, xaxt="n", yaxt="n", main="BEFORE - Null/Best-Fit/Background Model")
##image(img$final, xaxt="n", yaxt="n", main="BEFORE - Mean MultiScale of Data/Model MisMatch")
#dev.off()

img <- lira(
  obs.matrix = obs1mat,
  bkg.matrix = bkgdmat,
  psf.matrix = psfmat,
  start.matrix= matrix(2.00, nrow=obs1$axDat$len[1], ncol=obs1$axDat$len[2] ),
  out.file = "RunOutputs/Simple_04_PoisNull01_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.02.0_viaFits.out",
  param.file="RunOutputs/Simple_04_PoisNull01_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.02.0_viaFits.par",
  mcmc=TRUE, fit.bkg.scale = TRUE,
  max.iter=20500, thin=20,
  burn=0,
  alpha.init=c(0.03,0.04,0.05,0.06,0.07,0.08,0.09))

pdf("RunOutputs/PoisNull01_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.02.0_viaFits_after.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obs1mat, xaxt="n", yaxt="n", main="AFTER - Observed Data")
image(bkgdmat, xaxt="n", yaxt="n", main="AFTER - Null/Best-Fit/Background Model")
image(img$final, xaxt="n", yaxt="n", main="AFTER - Mean MultiScale of Data/Model MisMatch")
dev.off()


### Strt 0.02 (way low ...)

obs2file = "Faint_128x128testE_exampledata/PoisNull02_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a.fits"
obs2 <- readFITS(obs2file)
obs2mat <- matrix(data=obs2$imDat, nrow=obs2$axDat$len[1], ncol=obs2$axDat$len[2] )

#pdf("RunOutputs/PoisNull02_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.0.02_viaFits_before.pdf", width=12, height=4.25)
#par(mfrow=c(1,3))
#image(obs2mat, xaxt="n", yaxt="n", main="BEFORE - Observed Data")
#image(bkgdmat, xaxt="n", yaxt="n", main="BEFORE - Null/Best-Fit/Background Model")
##image(img$final, xaxt="n", yaxt="n", main="BEFORE - Mean MultiScale of Data/Model MisMatch")
#dev.off()

img <- lira(
  obs.matrix = obs2mat,
  bkg.matrix = bkgdmat,
  psf.matrix = psfmat,
  start.matrix= matrix(0.02, nrow=obs2$axDat$len[1], ncol=obs2$axDat$len[2] ),
  out.file = "RunOutputs/Simple_04_PoisNull02_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.0.02_viaFits.out",
  param.file="RunOutputs/Simple_04_PoisNull02_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.0.02_viaFits.par",
  mcmc=TRUE, fit.bkg.scale = TRUE,
  max.iter=20500, thin=20,
  burn=0,
  alpha.init=c(0.003,0.004,0.005,0.006,0.007,0.008,0.009))

pdf("RunOutputs/PoisNull02_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.0.02_viaFits_after.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obs2mat, xaxt="n", yaxt="n", main="AFTER - Observed Data")
image(bkgdmat, xaxt="n", yaxt="n", main="AFTER - Null/Best-Fit/Background Model")
image(img$final, xaxt="n", yaxt="n", main="AFTER - Mean MultiScale of Data/Model MisMatch")
dev.off()

### Strt=obs:

obs3file = "Faint_128x128testE_exampledata/PoisNull03_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a.fits"
obs3 <- readFITS(obs3file)
obs3mat <- matrix(data=obs3$imDat, nrow=obs3$axDat$len[1], ncol=obs3$axDat$len[2] )

#pdf("RunOutputs/PoisNull03_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.obs_viaFits_before.pdf", width=12, height=4.25)
#par(mfrow=c(1,3))
#image(obs3mat, xaxt="n", yaxt="n", main="BEFORE - Observed Data")
#image(bkgdmat, xaxt="n", yaxt="n", main="BEFORE - Null/Best-Fit/Background Model")
##image(img$final, xaxt="n", yaxt="n", main="BEFORE - Mean MultiScale of Data/Model MisMatch")
#dev.off()

img <- lira(
  obs.matrix = obs3mat,
  bkg.matrix = bkgdmat,
  psf.matrix = psfmat,
  start.matrix= obs3mat,
  out.file = "RunOutputs/Simple_04_PoisNull03_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.obs_viaFits.out",
  param.file="RunOutputs/Simple_04_PoisNull03_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.obs_viaFits.par",
  mcmc=TRUE, fit.bkg.scale = TRUE,
  max.iter=20500, thin=20,
  burn=0,
  alpha.init=c(0.3,0.4,0.5,0.6,0.7,0.8,0.9))

pdf("RunOutputs/PoisNull03_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.obs_viaFits_after.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obs3mat, xaxt="n", yaxt="n", main="AFTER - Observed Data")
image(bkgdmat, xaxt="n", yaxt="n", main="AFTER - Null/Best-Fit/Background Model")
image(img$final, xaxt="n", yaxt="n", main="AFTER - Mean MultiScale of Data/Model MisMatch")
dev.off()


### Strt=2.00 (way high)

obs4file = "Faint_128x128testE_exampledata/PoisNull04_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a.fits"
obs4 <- readFITS(obs4file)
obs4mat <- matrix(data=obs4$imDat, nrow=obs4$axDat$len[1], ncol=obs4$axDat$len[2] )

#pdf("RunOutputs/PoisNull04_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.02.0_viaFits_before.pdf", width=12, height=4.25)
#par(mfrow=c(1,3))
#image(obs4mat, xaxt="n", yaxt="n", main="BEFORE - Observed Data")
#image(bkgdmat, xaxt="n", yaxt="n", main="BEFORE - Null/Best-Fit/Background Model")
##image(img$final, xaxt="n", yaxt="n", main="BEFORE - Mean MultiScale of Data/Model MisMatch")
#dev.off()

img <- lira(
  obs.matrix = obs4mat,
  bkg.matrix = bkgdmat,
  psf.matrix = psfmat,
  start.matrix= matrix(2.00, nrow=obs4$axDat$len[1], ncol=obs4$axDat$len[2] ),
  out.file = "RunOutputs/Simple_04_PoisNull04_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.02.0_viaFits.out",
  param.file="RunOutputs/Simple_04_PoisNull04_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.02.0_viaFits.par",
  mcmc=TRUE, fit.bkg.scale = TRUE,
  max.iter=20500, thin=20,
  burn=0,
  alpha.init=c(0.03,0.04,0.05,0.06,0.07,0.08,0.09))

pdf("RunOutputs/PoisNull04_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.02.0_viaFits_after.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obs4mat, xaxt="n", yaxt="n", main="AFTER - Observed Data")
image(bkgdmat, xaxt="n", yaxt="n", main="AFTER - Null/Best-Fit/Background Model")
image(img$final, xaxt="n", yaxt="n", main="AFTER - Mean MultiScale of Data/Model MisMatch")
dev.off()


### Strt 0.02 (way low ...)

obs5file = "Faint_128x128testE_exampledata/PoisNull05_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a.fits"
obs5 <- readFITS(obs5file)
obs5mat <- matrix(data=obs5$imDat, nrow=obs5$axDat$len[1], ncol=obs5$axDat$len[2] )

#pdf("RunOutputs/PoisNull05_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.0.02_viaFits_before.pdf", width=12, height=4.25)
#par(mfrow=c(1,3))
#image(obs5mat, xaxt="n", yaxt="n", main="BEFORE - Observed Data")
#image(bkgdmat, xaxt="n", yaxt="n", main="BEFORE - Null/Best-Fit/Background Model")
##image(img$final, xaxt="n", yaxt="n", main="BEFORE - Mean MultiScale of Data/Model MisMatch")
#dev.off()

img <- lira(
  obs.matrix = obs5mat,
  bkg.matrix = bkgdmat,
  psf.matrix = psfmat,
  start.matrix= matrix(0.02, nrow=obs5$axDat$len[1], ncol=obs5$axDat$len[2] ),
  out.file = "RunOutputs/Simple_04_PoisNull05_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.0.02_viaFits.out",
  param.file="RunOutputs/Simple_04_PoisNull05_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.0.02_viaFits.par",
  mcmc=TRUE, fit.bkg.scale = TRUE,
  max.iter=20500, thin=20,
  burn=0,
  alpha.init=c(0.003,0.004,0.005,0.006,0.007,0.008,0.009))

pdf("RunOutputs/PoisNull05_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.0.02_viaFits_after.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obs5mat, xaxt="n", yaxt="n", main="AFTER - Observed Data")
image(bkgdmat, xaxt="n", yaxt="n", main="AFTER - Null/Best-Fit/Background Model")
image(img$final, xaxt="n", yaxt="n", main="AFTER - Mean MultiScale of Data/Model MisMatch")
dev.off()

### Strt=obs:

obs6file = "Faint_128x128testE_exampledata/PoisNull06_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a.fits"
obs6 <- readFITS(obs6file)
obs6mat <- matrix(data=obs6$imDat, nrow=obs6$axDat$len[1], ncol=obs6$axDat$len[2] )

#pdf("RunOutputs/PoisNull06_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.obs_viaFits_before.pdf", width=12, height=4.25)
#par(mfrow=c(1,3))
#image(obs6mat, xaxt="n", yaxt="n", main="BEFORE - Observed Data")
#image(bkgdmat, xaxt="n", yaxt="n", main="BEFORE - Null/Best-Fit/Background Model")
##image(img$final, xaxt="n", yaxt="n", main="BEFORE - Mean MultiScale of Data/Model MisMatch")
#dev.off()

img <- lira(
  obs.matrix = obs6mat,
  bkg.matrix = bkgdmat,
  psf.matrix = psfmat,
  start.matrix= obs6mat,
  out.file = "RunOutputs/Simple_04_PoisNull06_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.obs_viaFits.out",
  param.file="RunOutputs/Simple_04_PoisNull06_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.obs_viaFits.par",
  mcmc=TRUE, fit.bkg.scale = TRUE,
  max.iter=20500, thin=20,
  burn=0,
  alpha.init=c(0.3,0.4,0.5,0.6,0.7,0.8,0.9))

pdf("RunOutputs/PoisNull06_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.obs_viaFits_after.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obs6mat, xaxt="n", yaxt="n", main="AFTER - Observed Data")
image(bkgdmat, xaxt="n", yaxt="n", main="AFTER - Null/Best-Fit/Background Model")
image(img$final, xaxt="n", yaxt="n", main="AFTER - Mean MultiScale of Data/Model MisMatch")
dev.off()


### Strt=2.00 (way high)

obs7file = "Faint_128x128testE_exampledata/PoisNull07_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a.fits"
obs7 <- readFITS(obs7file)
obs7mat <- matrix(data=obs7$imDat, nrow=obs7$axDat$len[1], ncol=obs7$axDat$len[2] )

#pdf("RunOutputs/PoisNull07_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.02.0_viaFits_before.pdf", width=12, height=4.25)
#par(mfrow=c(1,3))
#image(obs7mat, xaxt="n", yaxt="n", main="BEFORE - Observed Data")
#image(bkgdmat, xaxt="n", yaxt="n", main="BEFORE - Null/Best-Fit/Background Model")
##image(img$final, xaxt="n", yaxt="n", main="BEFORE - Mean MultiScale of Data/Model MisMatch")
#dev.off()

img <- lira(
  obs.matrix = obs7mat,
  bkg.matrix = bkgdmat,
  psf.matrix = psfmat,
  start.matrix= matrix(2.00, nrow=obs7$axDat$len[1], ncol=obs7$axDat$len[2] ),
  out.file = "RunOutputs/Simple_04_PoisNull07_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.02.0_viaFits.out",
  param.file="RunOutputs/Simple_04_PoisNull07_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.02.0_viaFits.par",
  mcmc=TRUE, fit.bkg.scale = TRUE,
  max.iter=20500, thin=20,
  burn=0,
  alpha.init=c(0.03,0.04,0.05,0.06,0.07,0.08,0.09))

pdf("RunOutputs/PoisNull07_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.02.0_viaFits_after.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obs7mat, xaxt="n", yaxt="n", main="AFTER - Observed Data")
image(bkgdmat, xaxt="n", yaxt="n", main="AFTER - Null/Best-Fit/Background Model")
image(img$final, xaxt="n", yaxt="n", main="AFTER - Mean MultiScale of Data/Model MisMatch")
dev.off()


### Strt 0.02 (way low ...)

obs8file = "Faint_128x128testE_exampledata/PoisNull08_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a.fits"
obs8 <- readFITS(obs8file)
obs8mat <- matrix(data=obs8$imDat, nrow=obs8$axDat$len[1], ncol=obs8$axDat$len[2] )

#pdf("RunOutputs/PoisNull08_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.0.02_viaFits_before.pdf", width=12, height=4.25)
#par(mfrow=c(1,3))
#image(obs8mat, xaxt="n", yaxt="n", main="BEFORE - Observed Data")
#image(bkgdmat, xaxt="n", yaxt="n", main="BEFORE - Null/Best-Fit/Background Model")
##image(img$final, xaxt="n", yaxt="n", main="BEFORE - Mean MultiScale of Data/Model MisMatch")
#dev.off()

img <- lira(
  obs.matrix = obs8mat,
  bkg.matrix = bkgdmat,
  psf.matrix = psfmat,
  start.matrix= matrix(0.02, nrow=obs8$axDat$len[1], ncol=obs8$axDat$len[2] ),
  out.file = "RunOutputs/Simple_04_PoisNull08_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.0.02_viaFits.out",
  param.file="RunOutputs/Simple_04_PoisNull08_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.0.02_viaFits.par",
  mcmc=TRUE, fit.bkg.scale = TRUE,
  max.iter=20500, thin=20,
  burn=0,
  alpha.init=c(0.003,0.004,0.005,0.006,0.007,0.008,0.009))

pdf("RunOutputs/PoisNull08_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.0.02_viaFits_after.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obs8mat, xaxt="n", yaxt="n", main="AFTER - Observed Data")
image(bkgdmat, xaxt="n", yaxt="n", main="AFTER - Null/Best-Fit/Background Model")
image(img$final, xaxt="n", yaxt="n", main="AFTER - Mean MultiScale of Data/Model MisMatch")
dev.off()

### Strt=2.00 (way high)

obs9file = "Faint_128x128testE_exampledata/PoisNull09_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a.fits"
obs9 <- readFITS(obs9file)
obs9mat <- matrix(data=obs9$imDat, nrow=obs9$axDat$len[1], ncol=obs9$axDat$len[2] )

#pdf("RunOutputs/PoisNull09_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.02.0_viaFits_before.pdf", width=12, height=4.25)
#par(mfrow=c(1,3))
#image(obs9mat, xaxt="n", yaxt="n", main="BEFORE - Observed Data")
#image(bkgdmat, xaxt="n", yaxt="n", main="BEFORE - Null/Best-Fit/Background Model")
##image(img$final, xaxt="n", yaxt="n", main="BEFORE - Mean MultiScale of Data/Model MisMatch")
#dev.off()

img <- lira(
  obs.matrix = obs9mat,
  bkg.matrix = bkgdmat,
  psf.matrix = psfmat,
  start.matrix= matrix(2.00, nrow=obs9$axDat$len[1], ncol=obs9$axDat$len[2] ),
  out.file = "RunOutputs/Simple_04_PoisNull09_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.02.0_viaFits.out",
  param.file="RunOutputs/Simple_04_PoisNull09_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.02.0_viaFits.par",
  mcmc=TRUE, fit.bkg.scale = TRUE,
  max.iter=20500, thin=20,
  burn=0,
  alpha.init=c(0.03,0.04,0.05,0.06,0.07,0.08,0.09))

pdf("RunOutputs/PoisNull09_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.02.0_viaFits_after.pdf", width=12, height=4.25)
par(mfrow=c(1,3))
image(obs9mat, xaxt="n", yaxt="n", main="AFTER - Observed Data")
image(bkgdmat, xaxt="n", yaxt="n", main="AFTER - Null/Best-Fit/Background Model")
image(img$final, xaxt="n", yaxt="n", main="AFTER - Mean MultiScale of Data/Model MisMatch")
dev.off()


######################################