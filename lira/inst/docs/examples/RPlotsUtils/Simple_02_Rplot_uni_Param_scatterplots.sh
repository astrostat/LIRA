
r --vanilla <<EOF >>  sample_run_Rplot_Param_scatterplots.100616b.log
##
#####    Making and png files of the specified data
##

##
## In this example, assuming size=32 = 2^7, so 7 scale params.

infileImgDat1 = '../Routputs/Simple_01_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter2000_thin1_Strt.0.02_viaFits.par'
infileImgDat2 = '../Routputs/Simple_01_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter2000_thin1_Strt.02.0_viaFits.par'
infileImgDat0 = '../Routputs/Simple_01_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter2000_thin1_Strt.obs_viaFits.par'


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

infileImgNul0 = '../Routputs/Simple_02d_PoisNull00_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter900_thin5_Strt.obs_viaFits.par'
infileImgNul1 = '../Routputs/Simple_02d_PoisNull01_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter900_thin5_Strt.02.0_viaFits.par'
infileImgNul2 = '../Routputs/Simple_02d_PoisNull02_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter900_thin5_Strt.0.02_viaFits.par'
infileImgNul3 = '../Routputs/Simple_02d_PoisNull03_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter900_thin5_Strt.obs_viaFits.par'
infileImgNul4 = '../Routputs/Simple_02d_PoisNull04_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter900_thin5_Strt.02.0_viaFits.par'
infileImgNul5 = '../Routputs/Simple_02d_PoisNull05_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter900_thin5_Strt.0.02_viaFits.par'
infileImgNul6 = '../Routputs/Simple_02d_PoisNull06_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter900_thin5_Strt.obs_viaFits.par'
infileImgNul7 = '../Routputs/Simple_02d_PoisNull07_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter900_thin5_Strt.02.0_viaFits.par'
infileImgNul8 = '../Routputs/Simple_02d_PoisNull08_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter900_thin5_Strt.0.02_viaFits.par'
infileImgNul9 = '../Routputs/Simple_02d_PoisNull09_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter900_thin5_Strt.02.0_viaFits.par'


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



############# Plotting both:

xrangeImg <- numeric(2)
yrangeImg <- numeric(2)
xrangeImg[1] = 0.
xrangeImg[2] = 0.22
yrangeImg[1] = 0.
yrangeImg[2] = 0.22


rangeLog10MSCnts <- numeric(2)
rangeLog10MSCnts[1] = -2.0
rangeLog10MSCnts[2] = 2.5

rangeSqrtMSCnts <- numeric(2)
rangeSqrtMSCnts[1] = 0.0
rangeSqrtMSCnts[2] = 12.

rangeSqrtSqrtMSCnts <- numeric(2)
rangeSqrtSqrtMSCnts[1] = 0.0
rangeSqrtSqrtMSCnts[2] = 4.

rangeLog10BkgPrefactor <- numeric(2)
rangeLog10BkgPrefactor[1] = -0.05
rangeLog10BkgPrefactor[2] = 0.075

## Each png plot:
##

png("Img02Hyp0Hyp1Scatter_1_2.png", height=320, width=320, units="px" )


plot(I1Hyp0[40:400],I1Hyp1[40:400],
xlab='Smoothing Hyper-Param 0',
ylab='Smoothing Hyper-Param 1',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
main='Data (+), Null (.)',
cex=0.25,cex.main=1.4,cex.lab=1.4)
points(I0Hyp0[40:400],I0Hyp1[40:400],pch='+',col='black',cex=0.25)
points(I2Hyp0[40:400],I2Hyp1[40:400],pch='+',col='darkblue',cex=0.25)
points(N0Hyp0[40:180],N0Hyp1[40:180],pch=20,col='yellow',cex=0.25)
points(N1Hyp0[40:180],N1Hyp1[40:180],pch=20,col='orange',cex=0.25)
points(N2Hyp0[40:180],N2Hyp1[40:180],pch=20,col='green',cex=0.25)
points(N3Hyp0[40:180],N3Hyp1[40:180],pch=20,col='purple',cex=0.25)
points(N4Hyp0[40:180],N4Hyp1[40:180],pch=20,col='red',cex=0.25)
points(N5Hyp0[40:180],N5Hyp1[40:180],pch=20,col='magenta',cex=0.25)
dev.off()

## Next File:
##

png("Img02Hyp2Hyp3Scatter_1_2.png", height=320, width=320, units="px" )


plot(I1Hyp2[40:400],I1Hyp3[40:400],
xlab='Smoothing Hyper-Param 2',
ylab='Smoothing Hyper-Param 3',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
main='Data (+), Null (.)',
cex=0.25,cex.main=1.4,cex.lab=1.4)
points(I0Hyp2[40:400],I0Hyp3[40:400],pch='+',col='black',cex=0.25)
points(I2Hyp2[40:400],I2Hyp3[40:400],pch='+',col='darkblue',cex=0.25)
points(N0Hyp2[40:180],N0Hyp3[40:180],pch=20,col='yellow',cex=0.25)
points(N1Hyp2[40:180],N1Hyp3[40:180],pch=20,col='orange',cex=0.25)
points(N1Hyp2[40:180],N1Hyp3[40:180],pch=20,col='green',cex=0.25)
points(N3Hyp2[40:180],N3Hyp3[40:180],pch=20,col='purple',cex=0.25)
points(N4Hyp2[40:180],N4Hyp3[40:180],pch=20,col='red',cex=0.25)
points(N5Hyp2[40:180],N5Hyp3[40:180],pch=20,col='magenta',cex=0.25)
dev.off()

## Next File:
##

png("Img02Hyp4Hyp5Scatter_1_2.png", height=320, width=320, units="px" )


plot(I1Hyp4[40:400],I1Hyp5[40:400],
xlab='Smoothing Hyper-Param 4',
ylab='Smoothing Hyper-Param 5',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
main='Data (+), Null (.)',
cex=0.25,cex.main=1.4,cex.lab=1.4)
points(I0Hyp4[40:400],I0Hyp5[40:400],pch='+',col='black',cex=0.25)
points(I2Hyp4[40:400],I2Hyp5[40:400],pch='+',col='darkblue',cex=0.25)
points(N0Hyp4[40:180],N0Hyp5[40:180],pch=20,col='yellow',cex=0.25)
points(N1Hyp4[40:180],N1Hyp5[40:180],pch=20,col='orange',cex=0.25)
points(N1Hyp4[40:180],N1Hyp5[40:180],pch=20,col='green',cex=0.25)
points(N3Hyp4[40:180],N3Hyp5[40:180],pch=20,col='purple',cex=0.25)
points(N4Hyp4[40:180],N4Hyp5[40:180],pch=20,col='red',cex=0.25)
points(N5Hyp4[40:180],N5Hyp5[40:180],pch=20,col='magenta',cex=0.25)
dev.off()

## Next File:
##

png("Img02Hyp5Hyp6Scatter_1_2.png", height=320, width=320, units="px" )


plot(I1Hyp5[40:400],I1Hyp6[40:400],
xlab='Smoothing Hyper-Param 5',
ylab='Smoothing Hyper-Param 6',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
main='Data (+), Null (.)',
cex=0.25,cex.main=1.4,cex.lab=1.4)
points(I0Hyp5[40:400],I0Hyp6[40:400],pch='+',col='black',cex=0.25)
points(I2Hyp5[40:400],I2Hyp6[40:400],pch='+',col='darkblue',cex=0.25)
points(N0Hyp5[40:180],N0Hyp6[40:180],pch=20,col='yellow',cex=0.25)
points(N1Hyp5[40:180],N1Hyp6[40:180],pch=20,col='orange',cex=0.25)
points(N1Hyp5[40:180],N1Hyp6[40:180],pch=20,col='green',cex=0.25)
points(N3Hyp5[40:180],N3Hyp6[40:180],pch=20,col='purple',cex=0.25)
points(N4Hyp5[40:180],N4Hyp6[40:180],pch=20,col='red',cex=0.25)
points(N5Hyp5[40:180],N5Hyp6[40:180],pch=20,col='magenta',cex=0.25)
dev.off()

## Next File:
##

png("Img02ExpMSCntsBkgPrefactorScatter_1_2.png", height=320, width=320, units="px" )


#plot(log10(I1ExpMSCnts[40:400]), log10(I1BkgPrefactor[40:400]),
plot(sqrt(I1ExpMSCnts[40:400]), log10(I1BkgPrefactor[40:400]),
xlab='Log10(Expected MS Counts)',
ylab='Log10(Bkg Pre-Factor)',
xlim=rangeSqrtMSCnts,
#xlim=rangeLog10MSCnts,
ylim=rangeLog10BkgPrefactor,
pch='+', col='blue',
main='Data (+), Null (.)',
cex.main=1.4,cex.lab=1.4,cex=0.25)
points(sqrt(I0ExpMSCnts[40:400]),log10(I0BkgPrefactor[40:400]),pch='+',col='black',cex=0.25)
points(sqrt(I2ExpMSCnts[40:400]),log10(I2BkgPrefactor[40:400]),pch='+',col='darkblue',cex=0.25)
points(sqrt(N0ExpMSCnts[40:180]),log10(N0BkgPrefactor[40:180]),pch=20,col='yellow',cex=0.25)
points(sqrt(N1ExpMSCnts[40:180]),log10(N1BkgPrefactor[40:180]),pch=20,col='orange',cex=0.25)
points(sqrt(N1ExpMSCnts[40:180]),log10(N1BkgPrefactor[40:180]),pch=20,col='green',cex=0.25)
points(sqrt(N3ExpMSCnts[40:180]),log10(N3BkgPrefactor[40:180]),pch=20,col='purple',cex=0.25)
points(sqrt(N4ExpMSCnts[40:180]),log10(N4BkgPrefactor[40:180]),pch=20,col='red',cex=0.25)
points(sqrt(N5ExpMSCnts[40:180]),log10(N5BkgPrefactor[40:180]),pch=20,col='magenta',cex=0.25)
#points(sqrt(sqrt(I0ExpMSCnts[40:180])),log10(I0BkgPrefactor[40:180]),pch='+',col='black')
#points(sqrt(sqrt(I2ExpMSCnts[40:180])),log10(I2BkgPrefactor[40:180]),pch='+',col='black')
#points(sqrt(sqrt(N0ExpMSCnts[40:180])),log10(N0BkgPrefactor[40:180]),pch=20,col='yellow')
#points(sqrt(sqrt(N1ExpMSCnts[40:180])),log10(N1BkgPrefactor[40:180]),pch=20,col='orange')
#points(sqrt(sqrt(N1ExpMSCnts[40:180])),log10(N1BkgPrefactor[40:180]),pch=20,col='green')
#points(sqrt(sqrt(N3ExpMSCnts[40:180])),log10(N3BkgPrefactor[40:180]),pch=20,col='purple')
#points(sqrt(sqrt(N4ExpMSCnts[40:180])),log10(N4BkgPrefactor[40:180]),pch=20,col='red')
#points(sqrt(sqrt(N5ExpMSCnts[40:180])),log10(N5BkgPrefactor[40:180]),pch=20,col='magenta')
#points(log10(I0ExpMSCnts[40:180]),log10(I0BkgPrefactor[40:180]),pch=20,col='black',cex=0.25)
#points(log10(I2ExpMSCnts[40:180]),log10(I0BkgPrefactor[40:180]),pch=20,col='darkblue',cex=0.25)
#points(log10(N0ExpMSCnts[40:180]),log10(N0BkgPrefactor[40:180]),pch=20,col='yellow',cex=0.25)
#points(log10(N1ExpMSCnts[40:180]),log10(N1BkgPrefactor[40:180]),pch=20,col='orange',cex=0.25)
#points(log10(N1ExpMSCnts[40:180]),log10(N1BkgPrefactor[40:180]),pch=20,col='green',cex=0.25)
#points(log10(N3ExpMSCnts[40:180]),log10(N3BkgPrefactor[40:180]),pch=20,col='purple',cex=0.25)
#points(log10(N4ExpMSCnts[40:180]),log10(N4BkgPrefactor[40:180]),pch=20,col='red',cex=0.25)
#points(log10(N5ExpMSCnts[40:180]),log10(N5BkgPrefactor[40:180]),pch=20,col='magenta',cex=0.25)
dev.off()

