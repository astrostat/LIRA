
r --vanilla <<EOF >  sample_run_Rplot_Param_scatterplots.20121027a.log
##
#####    Making and png files of the specified data
##

##
## In this example, assuming size=128 = 2^7, so 7 scale params.

infileImgDat2 = '../RunOutputs/Simple_04_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter60000_thin20_Strt.0.02_viaFits.par'
infileImgDat1 = '../RunOutputs/Simple_04_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter60000_thin20_Strt.02.0_viaFits.par'
infileImgDat0 = '../RunOutputs/Simple_04_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter60000_thin20_Strt.obs_viaFits.par'

## In reading in, skip=40 assumes:                                  ####
## 28 header lines, 1 labels line, 10 [ie 100 iters] for burn-in:   ####

ImgDat1 <- read.table(infileImgDat1, header = TRUE, sep = "", quote = "\"'",
           na.strings = "NA", colClasses = NA, nrows = -1,
           skip = 40, check.names = TRUE,
           comment.char = "#",
           allowEscapes = FALSE, flush = FALSE,
           encoding = "unknown")

ImgDat0 <- read.table(infileImgDat0, header = TRUE, sep = "", quote = "\"'",
           na.strings = "NA", colClasses = NA, nrows = -1,
           skip = 40, check.names = TRUE,
           comment.char = "#",
           allowEscapes = FALSE, flush = FALSE,
           encoding = "unknown")

ImgDat2 <- read.table(infileImgDat2, header = TRUE, sep = "", quote = "\"'",
           na.strings = "NA", colClasses = NA, nrows = -1,
           skip = 40, check.names = TRUE,
           comment.char = "#",
           allowEscapes = FALSE, flush = FALSE,
           encoding = "unknown")

#### Putting the results on data into arrays:

I0LogProb <- ImgDat0[[3]]
I0SpinRow <- ImgDat0[[4]]
I0SpinCol <- ImgDat0[[5]]
I0Hyp0 <- ImgDat0[[6]]
I0Hyp1 <- ImgDat0[[7]]
I0Hyp2 <- ImgDat0[[8]]
I0Hyp3 <- ImgDat0[[9]]
I0Hyp4 <- ImgDat0[[10]]
I0Hyp5 <- ImgDat0[[11]]
I0Hyp6 <- ImgDat0[[12]]
I0ExpMSCnts <- ImgDat0[[13]]
I0BkgPrefactor <- ImgDat0[[14]]

I1LogProb <- ImgDat1[[3]]
I1SpinRow <- ImgDat1[[4]]
I1SpinCol <- ImgDat1[[5]]
I1Hyp0 <- ImgDat1[[6]]
I1Hyp1 <- ImgDat1[[7]]
I1Hyp2 <- ImgDat1[[8]]
I1Hyp3 <- ImgDat1[[9]]
I1Hyp4 <- ImgDat1[[10]]
I1Hyp5 <- ImgDat1[[11]]
I1Hyp6 <- ImgDat1[[12]]
I1ExpMSCnts <- ImgDat1[[13]]
I1BkgPrefactor <- ImgDat1[[14]]

I2LogProb <- ImgDat2[[3]]
I2SpinRow <- ImgDat2[[4]]
I2SpinCol <- ImgDat2[[5]]
I2Hyp0 <- ImgDat2[[6]]
I2Hyp1 <- ImgDat2[[7]]
I2Hyp2 <- ImgDat2[[8]]
I2Hyp3 <- ImgDat2[[9]]
I2Hyp4 <- ImgDat2[[10]]
I2Hyp5 <- ImgDat2[[11]]
I2Hyp6 <- ImgDat2[[12]]
I2ExpMSCnts <- ImgDat2[[13]]
I2BkgPrefactor <- ImgDat2[[14]]

#### Reading in results on Simulated Null Datons:

infileImgNul0 = '../RunOutputs/Simple_04_PoisNull00_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.obs_viaFits.par'
infileImgNul1 = '../RunOutputs/Simple_04_PoisNull01_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.02.0_viaFits.par'
infileImgNul2 = '../RunOutputs/Simple_04_PoisNull02_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.0.02_viaFits.par'
infileImgNul3 = '../RunOutputs/Simple_04_PoisNull03_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.obs_viaFits.par'
infileImgNul4 = '../RunOutputs/Simple_04_PoisNull04_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.02.0_viaFits.par'
infileImgNul5 = '../RunOutputs/Simple_04_PoisNull05_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.0.02_viaFits.par'
infileImgNul6 = '../RunOutputs/Simple_04_PoisNull05_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.0.02_viaFits.par'
infileImgNul7 = '../RunOutputs/Simple_04_PoisNull07_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.02.0_viaFits.par'
infileImgNul8 = '../RunOutputs/Simple_04_PoisNull08_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.0.02_viaFits.par'
infileImgNul9 = '../RunOutputs/Simple_04_PoisNull09_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.02.0_viaFits.par'



ImgNul0 <- read.table(infileImgNul0, header = TRUE, sep = "", quote = "\"'",
           na.strings = "NA", colClasses = NA, nrows = -1,
           skip = 40, check.names = TRUE,
           comment.char = "#",
           allowEscapes = FALSE, flush = FALSE,
           encoding = "unknown")

ImgNul1 <- read.table(infileImgNul1, header = TRUE, sep = "", quote = "\"'",
           na.strings = "NA", colClasses = NA, nrows = -1,
           skip = 40, check.names = TRUE,
           comment.char = "#",
           allowEscapes = FALSE, flush = FALSE,
           encoding = "unknown")

ImgNul2 <- read.table(infileImgNul2, header = TRUE, sep = "", quote = "\"'",
           na.strings = "NA", colClasses = NA, nrows = -1,
           skip = 40, check.names = TRUE,
           comment.char = "#",
           allowEscapes = FALSE, flush = FALSE,
           encoding = "unknown")

ImgNul3 <- read.table(infileImgNul3, header = TRUE, sep = "", quote = "\"'",
           na.strings = "NA", colClasses = NA, nrows = -1,
           skip = 40, check.names = TRUE,
           comment.char = "#",
           allowEscapes = FALSE, flush = FALSE,
           encoding = "unknown")

ImgNul4 <- read.table(infileImgNul4, header = TRUE, sep = "", quote = "\"'",
           na.strings = "NA", colClasses = NA, nrows = -1,
           skip = 40, check.names = TRUE,
           comment.char = "#",
           allowEscapes = FALSE, flush = FALSE,
           encoding = "unknown")

ImgNul5 <- read.table(infileImgNul5, header = TRUE, sep = "", quote = "\"'",
           na.strings = "NA", colClasses = NA, nrows = -1,
           skip = 40, check.names = TRUE,
           comment.char = "#",
           allowEscapes = FALSE, flush = FALSE,
           encoding = "unknown")

ImgNul6 <- read.table(infileImgNul6, header = TRUE, sep = "", quote = "\"'",
           na.strings = "NA", colClasses = NA, nrows = -1,
           skip = 40, check.names = TRUE,
           comment.char = "#",
           allowEscapes = FALSE, flush = FALSE,
           encoding = "unknown")

ImgNul7 <- read.table(infileImgNul7, header = TRUE, sep = "", quote = "\"'",
           na.strings = "NA", colClasses = NA, nrows = -1,
           skip = 40, check.names = TRUE,
           comment.char = "#",
           allowEscapes = FALSE, flush = FALSE,
           encoding = "unknown")

ImgNul8 <- read.table(infileImgNul8, header = TRUE, sep = "", quote = "\"'",
           na.strings = "NA", colClasses = NA, nrows = -1,
           skip = 40, check.names = TRUE,
           comment.char = "#",
           allowEscapes = FALSE, flush = FALSE,
           encoding = "unknown")

ImgNul9 <- read.table(infileImgNul9, header = TRUE, sep = "", quote = "\"'",
           na.strings = "NA", colClasses = NA, nrows = -1,
           skip = 40, check.names = TRUE,
           comment.char = "#",
           allowEscapes = FALSE, flush = FALSE,
           encoding = "unknown")

########## And arrays from results vs Null Datons: #########

N0LogProb <- ImgNul0[[3]]
N0SpinRow <- ImgNul0[[4]]
N0SpinCol <- ImgNul0[[5]]
N0Hyp0 <- ImgNul0[[6]]
N0Hyp1 <- ImgNul0[[7]]
N0Hyp2 <- ImgNul0[[8]]
N0Hyp3 <- ImgNul0[[9]]
N0Hyp4 <- ImgNul0[[10]]
N0Hyp5 <- ImgNul0[[11]]
N0Hyp6 <- ImgNul0[[12]]
N0ExpMSCnts <- ImgNul0[[13]]
N0BkgPrefactor <- ImgNul0[[14]]

N1LogProb <- ImgNul1[[3]]
N1SpinRow <- ImgNul1[[4]]
N1SpinCol <- ImgNul1[[5]]
N1Hyp0 <- ImgNul1[[6]]
N1Hyp1 <- ImgNul1[[7]]
N1Hyp2 <- ImgNul1[[8]]
N1Hyp3 <- ImgNul1[[9]]
N1Hyp4 <- ImgNul1[[10]]
N1Hyp5 <- ImgNul1[[11]]
N1Hyp6 <- ImgNul1[[12]]
N1ExpMSCnts <- ImgNul1[[13]]
N1BkgPrefactor <- ImgNul1[[14]]

N2LogProb <- ImgNul2[[3]]
N2SpinRow <- ImgNul2[[4]]
N2SpinCol <- ImgNul2[[5]]
N2Hyp0 <- ImgNul2[[6]]
N2Hyp1 <- ImgNul2[[7]]
N2Hyp2 <- ImgNul2[[8]]
N2Hyp3 <- ImgNul2[[9]]
N2Hyp4 <- ImgNul2[[10]]
N2Hyp5 <- ImgNul2[[11]]
N2Hyp6 <- ImgNul2[[12]]
N2ExpMSCnts <- ImgNul2[[13]]
N2BkgPrefactor <- ImgNul2[[14]]

N3LogProb <- ImgNul3[[3]]
N3SpinRow <- ImgNul3[[4]]
N3SpinCol <- ImgNul3[[5]]
N3Hyp0 <- ImgNul3[[6]]
N3Hyp1 <- ImgNul3[[7]]
N3Hyp2 <- ImgNul3[[8]]
N3Hyp3 <- ImgNul3[[9]]
N3Hyp4 <- ImgNul3[[10]]
N3Hyp5 <- ImgNul3[[11]]
N3Hyp6 <- ImgNul3[[12]]
N3ExpMSCnts <- ImgNul3[[13]]
N3BkgPrefactor <- ImgNul3[[14]]

N4LogProb <- ImgNul4[[3]]
N4SpinRow <- ImgNul4[[4]]
N4SpinCol <- ImgNul4[[5]]
N4Hyp0 <- ImgNul4[[6]]
N4Hyp1 <- ImgNul4[[7]]
N4Hyp2 <- ImgNul4[[8]]
N4Hyp3 <- ImgNul4[[9]]
N4Hyp4 <- ImgNul4[[10]]
N4Hyp5 <- ImgNul4[[11]]
N4Hyp6 <- ImgNul4[[12]]
N4ExpMSCnts <- ImgNul4[[13]]
N4BkgPrefactor <- ImgNul4[[14]]

N5LogProb <- ImgNul5[[3]]
N5SpinRow <- ImgNul5[[4]]
N5SpinCol <- ImgNul5[[5]]
N5Hyp0 <- ImgNul5[[6]]
N5Hyp1 <- ImgNul5[[7]]
N5Hyp2 <- ImgNul5[[8]]
N5Hyp3 <- ImgNul5[[9]]
N5Hyp4 <- ImgNul5[[10]]
N5Hyp5 <- ImgNul5[[11]]
N5Hyp6 <- ImgNul5[[12]]
N5ExpMSCnts <- ImgNul5[[13]]
N5BkgPrefactor <- ImgNul5[[14]]

N6LogProb <- ImgNul6[[3]]
N6SpinRow <- ImgNul6[[4]]
N6SpinCol <- ImgNul6[[5]]
N6Hyp0 <- ImgNul6[[6]]
N6Hyp1 <- ImgNul6[[7]]
N6Hyp2 <- ImgNul6[[8]]
N6Hyp3 <- ImgNul6[[9]]
N6Hyp4 <- ImgNul6[[10]]
N6Hyp5 <- ImgNul6[[11]]
N6Hyp6 <- ImgNul6[[12]]
N6ExpMSCnts <- ImgNul6[[13]]
N6BkgPrefactor <- ImgNul6[[14]]

N7LogProb <- ImgNul7[[3]]
N7SpinRow <- ImgNul7[[4]]
N7SpinCol <- ImgNul7[[5]]
N7Hyp0 <- ImgNul7[[6]]
N7Hyp1 <- ImgNul7[[7]]
N7Hyp2 <- ImgNul7[[8]]
N7Hyp3 <- ImgNul7[[9]]
N7Hyp4 <- ImgNul7[[10]]
N7Hyp5 <- ImgNul7[[11]]
N7Hyp6 <- ImgNul7[[12]]
N7ExpMSCnts <- ImgNul7[[13]]
N7BkgPrefactor <- ImgNul7[[14]]

N8LogProb <- ImgNul8[[3]]
N8SpinRow <- ImgNul8[[4]]
N8SpinCol <- ImgNul8[[5]]
N8Hyp0 <- ImgNul8[[6]]
N8Hyp1 <- ImgNul8[[7]]
N8Hyp2 <- ImgNul8[[8]]
N8Hyp3 <- ImgNul8[[9]]
N8Hyp4 <- ImgNul8[[10]]
N8Hyp5 <- ImgNul8[[11]]
N8Hyp6 <- ImgNul8[[12]]
N8ExpMSCnts <- ImgNul8[[13]]
N8BkgPrefactor <- ImgNul8[[14]]

N5LogProb <- ImgNul9[[3]]
N9SpinRow <- ImgNul9[[4]]
N9SpinCol <- ImgNul9[[5]]
N9Hyp0 <- ImgNul9[[6]]
N9Hyp1 <- ImgNul9[[7]]
N9Hyp2 <- ImgNul9[[8]]
N9Hyp3 <- ImgNul9[[9]]
N9Hyp4 <- ImgNul9[[10]]
N9Hyp5 <- ImgNul9[[11]]
N9Hyp6 <- ImgNul9[[12]]
N9ExpMSCnts <- ImgNul9[[13]]
N9BkgPrefactor <- ImgNul9[[14]]


############# Plotting both:

xrangeImg <- numeric(2)
yrangeImg <- numeric(2)
xrangeImg[1] = 0.
xrangeImg[2] = 0.22
yrangeImg[1] = 0.
yrangeImg[2] = 0.22


rangeLog10MSCnts <- numeric(2)
rangeLog10MSCnts[1] = -1.0
rangeLog10MSCnts[2] = 2.5

rangeSqrtMSCnts <- numeric(2)
rangeSqrtMSCnts[1] = 0.0
rangeSqrtMSCnts[2] = 14.

rangeSqrtSqrtMSCnts <- numeric(2)
rangeSqrtSqrtMSCnts[1] = 0.0
rangeSqrtSqrtMSCnts[2] = 4.

rangeLog10BkgPrefactor <- numeric(2)
rangeLog10BkgPrefactor[1] = -0.05
rangeLog10BkgPrefactor[2] = 0.05

## Each png plot:
##

png("Img04Hyp0Hyp1Scatter_FaintE_all.png", height=320, width=320, units="px" )


plot(I1Hyp0,I1Hyp1,
xlab='Smoothing Hyper-Param 0',
ylab='Smoothing Hyper-Param 1',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
main='Data (+), Null (.)',
cex=0.25,cex.main=1.4,cex.lab=1.4)
points(I0Hyp0,I0Hyp1,pch='+',col='black',cex=0.25)
points(I2Hyp0,I2Hyp1,pch='+',col='darkblue',cex=0.25)
points(N0Hyp0,N0Hyp1,pch=20,col='yellow',cex=0.25)
points(N1Hyp0,N1Hyp1,pch=20,col='orange',cex=0.25)
points(N2Hyp0,N2Hyp1,pch=20,col='green',cex=0.25)
points(N3Hyp0,N3Hyp1,pch=20,col='purple',cex=0.25)
points(N4Hyp0,N4Hyp1,pch=20,col='red',cex=0.25)
points(N5Hyp0,N5Hyp1,pch=20,col='magenta',cex=0.25)
points(N6Hyp0,N6Hyp1,pch=20,col='pink',cex=0.25)
points(N7Hyp0,N7Hyp1,pch=20,col='red',cex=0.25)
points(N8Hyp0,N8Hyp1,pch=20,col='pink',cex=0.25)
points(N9Hyp0,N9Hyp1,pch=20,col='pink',cex=0.25)
dev.off()

## Next File:
##

png("Img04Hyp2Hyp3Scatter_FaintE_all.png", height=320, width=320, units="px" )


plot(I1Hyp2,I1Hyp3,
xlab='Smoothing Hyper-Param 2',
ylab='Smoothing Hyper-Param 3',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
main='Data (+), Null (.)',
cex=0.25,cex.main=1.4,cex.lab=1.4)
points(I0Hyp2,I0Hyp3,pch='+',col='black',cex=0.25)
points(I2Hyp2,I2Hyp3,pch='+',col='darkblue',cex=0.25)
points(N0Hyp2,N0Hyp3,pch=20,col='yellow',cex=0.25)
points(N1Hyp2,N1Hyp3,pch=20,col='orange',cex=0.25)
points(N1Hyp2,N1Hyp3,pch=20,col='green',cex=0.25)
points(N3Hyp2,N3Hyp3,pch=20,col='purple',cex=0.25)
points(N4Hyp2,N4Hyp3,pch=20,col='red',cex=0.25)
points(N5Hyp2,N5Hyp3,pch=20,col='magenta',cex=0.25)
points(N6Hyp2,N6Hyp3,pch=20,col='magenta',cex=0.25)
points(N7Hyp2,N7Hyp3,pch=20,col='magenta',cex=0.25)
points(N8Hyp2,N8Hyp3,pch=20,col='magenta',cex=0.25)
points(N9Hyp2,N9Hyp3,pch=20,col='magenta',cex=0.25)
dev.off()

## Next File:
##

png("Img04Hyp4Hyp5Scatter_FaintE_all.png", height=320, width=320, units="px" )


plot(I1Hyp4,I1Hyp5,
xlab='Smoothing Hyper-Param 4',
ylab='Smoothing Hyper-Param 5',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
main='Data (+), Null (.)',
cex=0.25,cex.main=1.4,cex.lab=1.4)
points(I0Hyp4,I0Hyp5,pch='+',col='black',cex=0.25)
points(I2Hyp4,I2Hyp5,pch='+',col='darkblue',cex=0.25)
points(N0Hyp4,N0Hyp5,pch=20,col='yellow',cex=0.25)
points(N1Hyp4,N1Hyp5,pch=20,col='orange',cex=0.25)
points(N1Hyp4,N1Hyp5,pch=20,col='green',cex=0.25)
points(N3Hyp4,N3Hyp5,pch=20,col='purple',cex=0.25)
points(N4Hyp4,N4Hyp5,pch=20,col='red',cex=0.25)
points(N5Hyp4,N5Hyp5,pch=20,col='magenta',cex=0.25)
points(N6Hyp4,N6Hyp5,pch=20,col='magenta',cex=0.25)
points(N7Hyp4,N7Hyp5,pch=20,col='magenta',cex=0.25)
points(N8Hyp4,N8Hyp5,pch=20,col='magenta',cex=0.25)
points(N9Hyp4,N9Hyp5,pch=20,col='magenta',cex=0.25)
dev.off()

## Next File:
##

png("Img04Hyp5Hyp6Scatter_FaintE_all.png", height=320, width=320, units="px" )


plot(I1Hyp5,I1Hyp6,
xlab='Smoothing Hyper-Param 5',
ylab='Smoothing Hyper-Param 6',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
main='Data (+), Null (.)',
cex=0.25,cex.main=1.4,cex.lab=1.4)
points(I0Hyp5,I0Hyp6,pch='+',col='black',cex=0.25)
points(I2Hyp5,I2Hyp6,pch='+',col='darkblue',cex=0.25)
points(N0Hyp5,N0Hyp6,pch=20,col='yellow',cex=0.25)
points(N1Hyp5,N1Hyp6,pch=20,col='orange',cex=0.25)
points(N1Hyp5,N1Hyp6,pch=20,col='green',cex=0.25)
points(N3Hyp5,N3Hyp6,pch=20,col='purple',cex=0.25)
points(N4Hyp5,N4Hyp6,pch=20,col='red',cex=0.25)
points(N5Hyp5,N5Hyp6,pch=20,col='magenta',cex=0.25)
points(N6Hyp5,N6Hyp6,pch=20,col='magenta',cex=0.25)
points(N7Hyp5,N7Hyp6,pch=20,col='magenta',cex=0.25)
points(N8Hyp5,N8Hyp6,pch=20,col='magenta',cex=0.25)
points(N9Hyp5,N9Hyp6,pch=20,col='magenta',cex=0.25)
dev.off()

## Next File:
##

png("Img04ExpMSCntsBkgPrefFaintE_all.png", height=320, width=320, units="px" )


plot(sqrt(I1ExpMSCnts), log10(I1BkgPrefactor),
xlab='Sqrt(Expected MS Counts)',
ylab='Log10(Bkg Pre-Factor)',
pch='+', col='blue',
main='Data (+), Null (.)',
xlim=rangeSqrtMSCnts,
ylim=rangeLog10BkgPrefactor,
cex.main=1.4,cex.lab=1.4,cex=0.25)
points(sqrt(I0ExpMSCnts),log10(I0BkgPrefactor),pch='+',col='black',cex=0.25)
points(sqrt(I2ExpMSCnts),log10(I2BkgPrefactor),pch='+',col='darkblue',cex=0.25)
points(sqrt(N0ExpMSCnts),log10(N0BkgPrefactor),pch=20,col='yellow',cex=0.25)
points(sqrt(N1ExpMSCnts),log10(N1BkgPrefactor),pch=20,col='orange',cex=0.25)
points(sqrt(N1ExpMSCnts),log10(N1BkgPrefactor),pch=20,col='green',cex=0.25)
points(sqrt(N3ExpMSCnts),log10(N3BkgPrefactor),pch=20,col='purple',cex=0.25)
points(sqrt(N4ExpMSCnts),log10(N4BkgPrefactor),pch=20,col='red',cex=0.25)
points(sqrt(N5ExpMSCnts),log10(N5BkgPrefactor),pch=20,col='magenta',cex=0.25)
points(sqrt(N6ExpMSCnts),log10(N6BkgPrefactor),pch=20,col='magenta',cex=0.25)
points(sqrt(N7ExpMSCnts),log10(N7BkgPrefactor),pch=20,col='magenta',cex=0.25)
points(sqrt(N8ExpMSCnts),log10(N8BkgPrefactor),pch=20,col='magenta',cex=0.25)
points(sqrt(N9ExpMSCnts),log10(N9BkgPrefactor),pch=20,col='magenta',cex=0.25)
#points(sqrt(sqrt(I0ExpMSCnts)),log10(I0BkgPrefactor),pch='+',col='black')
#points(sqrt(sqrt(I2ExpMSCnts)),log10(I2BkgPrefactor),pch='+',col='black')
#points(sqrt(sqrt(N0ExpMSCnts)),log10(N0BkgPrefactor),pch=20,col='yellow')
#points(sqrt(sqrt(N1ExpMSCnts)),log10(N1BkgPrefactor),pch=20,col='orange')
#points(sqrt(sqrt(N1ExpMSCnts)),log10(N1BkgPrefactor),pch=20,col='green')
#points(sqrt(sqrt(N3ExpMSCnts)),log10(N3BkgPrefactor),pch=20,col='purple')
#points(sqrt(sqrt(N4ExpMSCnts)),log10(N4BkgPrefactor),pch=20,col='red')
#points(sqrt(sqrt(N5ExpMSCnts)),log10(N5BkgPrefactor),pch=20,col='magenta')
#points(sqrt(sqrt(N6ExpMSCnts)),log10(N6BkgPrefactor),pch=20,col='magenta')
#points(sqrt(sqrt(N7ExpMSCnts)),log10(N7BkgPrefactor),pch=20,col='magenta')
#points(sqrt(sqrt(N8ExpMSCnts)),log10(N8BkgPrefactor),pch=20,col='magenta')
#points(sqrt(sqrt(N9ExpMSCnts)),log10(N9BkgPrefactor),pch=20,col='magenta')
#points(log10(I0ExpMSCnts),log10(I0BkgPrefactor),pch=20,col='blue')
#points(log10(N0ExpMSCnts),log10(N0BkgPrefactor),pch=20,col='yellow')
#points(log10(N1ExpMSCnts),log10(N1BkgPrefactor),pch=20,col='orange')
#points(log10(N1ExpMSCnts),log10(N1BkgPrefactor),pch=20,col='green')
#points(log10(N3ExpMSCnts),log10(N3BkgPrefactor),pch=20,col='purple')
#points(log10(N4ExpMSCnts),log10(N4BkgPrefactor),pch=20,col='red')
#points(log10(N5ExpMSCnts),log10(N5BkgPrefactor),pch=20,col='magenta')
dev.off()

