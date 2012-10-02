
r --vanilla <<EOF >  Simple04_Rplot_uni_Param_traces.log
##
#####    Making and pdf files of the specified data
##


infileImgDat1 = '../outputs/Simple04_Prelim_Gauss2d1.5_PoisDatons128x128testEvsNull_Strt1.00_viaFits.param'

ImgDat1 <- read.table(infileImgDat1, header = TRUE, sep = "", quote = "\"'",
           na.strings = "NA", colClasses = NA, nrows = -1,
           skip = 0, check.names = TRUE,
           comment.char = "#",
           allowEscapes = FALSE, flush = FALSE,
           encoding = "unknown")

I1Iter <- ImgDat1[[1]]
I1LogProb <- ImgDat1[[2]]
I1ProbStep <- ImgDat1[[3]]
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


infileImgDat2 = '../outputs/Simple04_Prelim_Gauss2d1.5_PoisDatons128x128testEvsNull_Strt0.01_viaFits.param'

ImgDat2 <- read.table(infileImgDat2, header = TRUE, sep = "", quote = "\"'",
           na.strings = "NA", colClasses = NA, nrows = -1,
           skip = 0, check.names = TRUE,
           comment.char = "#",
           allowEscapes = FALSE, flush = FALSE,
           encoding = "unknown")

I2Iter <- ImgDat2[[1]]
I2LogProb <- ImgDat2[[2]]
I2ProbStep <- ImgDat2[[3]]
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


xrangeImg <- numeric(2)
yrangeImg <- numeric(2)
xrangeImg[1] = 0.
xrangeImg[2] = 0.4
yrangeImg[1] = 0.
yrangeImg[2] = 0.4


rangeLog10MSCnts <- numeric(2)
rangeLog10MSCnts[1] = 2.2
rangeLog10MSCnts[2] = 3.4

## No Background for this one:
#rangeLog10BkgScale <- numeric(2)
#rangeLog10BkgScale[1] = 0.38
#rangeLog10BkgScale[2] = 0.42

rangeLog10Prob <- numeric(2)
rangeLog10Prob[1] = -10100.
rangeLog10Prob[2] =  -8800.

## Each trace or 'time-series' (statistics jargon) plot
## 

png("Img03TrialLogProbTimeTrace.png", height=320, width=320, units="px" )

log10euler = log10(exp(1.000000000000))

plot(I1Iter,(I1LogProb*log10euler),type="o",
xlab='Iteration Number',
ylab=' Log10 Post Prob',
ylim=rangeLog10Prob,
pch='.',col="black",
cex.main=1.4,cex.lab=1.4)
lines(I2Iter,(I2LogProb*log10euler),col="blue")

dev.off()

## Next File:
##

png("Img03TrialHyp0TimeTrace.png", height=320, width=320, units="px" )

plot(I1Iter,I1Hyp0,type="o",
xlab='Iteration Number',
ylab='Smoothing Hyper-Param 0',
pch='.',col="black",
cex.main=1.4,cex.lab=1.4)
lines(I2Iter,I2Hyp0,col="blue")


dev.off()

## Next File:
##

png("Img03TrialHyp1TimeTrace.png", height=320, width=320, units="px" )

plot(I1Iter,I1Hyp1,type="o",
xlab='Iteration Number',
ylab='Smoothing Hyper-Param 1',
pch='.',col="black",
cex.main=1.4,cex.lab=1.4)
lines(I2Iter,I2Hyp1,col="blue")


dev.off()

## Next File:
##

png("Img03TrialHyp2TimeTrace.png", height=320, width=320, units="px" )

plot(I1Iter,I1Hyp2,type="o",
xlab='Iteration Number',
ylab='Smoothing Hyper-Param 2',
pch='.',col="black",
cex.main=1.4,cex.lab=1.4)
lines(I2Iter,I2Hyp2,col="blue")


dev.off()

## Next File:
##

png("Img03TrialHyp3TimeTrace.png", height=320, width=320, units="px" )


plot(I1Iter,I1Hyp3,type="o",
xlab='Iteration Number',
ylab='Smoothing Hyper-Param 3',
pch='.',col="black",
cex.main=1.4,cex.lab=1.4)
lines(I2Iter,I2Hyp3,col="blue")

dev.off()


## Next File:
##

png("Img03TrialHyp4TimeTrace.png", height=320, width=320, units="px" )

plot(I1Iter,I1Hyp4,type="o",
xlab='Iteration Number',
ylab='Smoothing Hyper-Param 4',
pch='.',col="black",
cex.main=1.4,cex.lab=1.4)
lines(I2Iter,I2Hyp4,col="blue")

dev.off()


## Next File:
##

png("Img03TrialHyp5TimeTrace.png", height=320, width=320, units="px" )

plot(I1Iter,I1Hyp5,type="o",
xlab='Iteration Number',
ylab='Smoothing Hyper-Param 5',
pch='.',col="black",
cex.main=1.4,cex.lab=1.4)
lines(I2Iter,I2Hyp5,col="blue")

dev.off()


## Next File:
##

png("Img03TrialHyp6TimeTrace.png", height=320, width=320, units="px" )

plot(I1Iter,I1Hyp6,type="o",
xlab='Iteration Number',
ylab='Smoothing Hyper-Param 6',
pch='.',col="black",
cex.main=1.4,cex.lab=1.4)
lines(I2Iter,I2Hyp6,col="blue")

dev.off()


## Next File:
##

png("Img03TrialMSCntsTimeTrace.png", height=320, width=320, units="px" )

plot(I1Iter,log10(I1ExpMSCnts),type="o",
xlab='Iteration Number',
ylab='Log10(Expected MS Counts)',
#main='Data (.)',
pch='.',col="black",
cex.main=1.4,cex.lab=1.4)
lines(I2Iter,log10(I2ExpMSCnts),col="blue")
dev.off()

