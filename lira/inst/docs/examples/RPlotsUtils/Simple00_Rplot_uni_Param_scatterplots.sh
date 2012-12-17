
r --vanilla <<EOF >>  sample_run_Rplot_Param_scatterplots.100616b.log
##
#####    Making and pdf files of the specified data
##

##
## In this example, assuming size=32 = 2^5, so 5 scale params.

infileImgDat1 = '../outputs/PoisDatons32x32EEMC2_NoBckgrnd.param'
infileImgDat2 = '../outputs/PoisDatons32x32EEMC2_NoBckgrnd_2.param'


ImgDat1 <- read.table(infileImgDat1, header = TRUE, sep = "", quote = "\"'",
           na.strings = "NA", colClasses = NA, nrows = -1,
           skip = 0, check.names = TRUE,
           comment.char = "#",
           allowEscapes = FALSE, flush = FALSE,
           encoding = "unknown")

ImgDat2 <- read.table(infileImgDat2, header = TRUE, sep = "", quote = "\"'",
           na.strings = "NA", colClasses = NA, nrows = -1,
           skip = 0, check.names = TRUE,
           comment.char = "#",
           allowEscapes = FALSE, flush = FALSE,
           encoding = "unknown")


I1LogProb <- ImgDat1[[3]]
I1SpinRow <- ImgDat1[[4]]
I1SpinCol <- ImgDat1[[5]]
I1Hyp0 <- ImgDat1[[6]]
I1Hyp1 <- ImgDat1[[7]]
I1Hyp2 <- ImgDat1[[8]]
I1Hyp3 <- ImgDat1[[9]]
I1Hyp4 <- ImgDat1[[10]]
I1ExpMSCnts <- ImgDat1[[11]]
#I1BkgScale <- ImgDat1[[12]]

I2LogProb <- ImgDat2[[3]]
I2SpinRow <- ImgDat2[[4]]
I2SpinCol <- ImgDat2[[5]]
I2Hyp0 <- ImgDat2[[6]]
I2Hyp1 <- ImgDat2[[7]]
I2Hyp2 <- ImgDat2[[8]]
I2Hyp3 <- ImgDat2[[9]]
I2Hyp4 <- ImgDat2[[10]]
I2ExpMSCnts <- ImgDat2[[11]]
#I2BkgScale <- ImgDat2[[12]]


xrangeImg <- numeric(2)
yrangeImg <- numeric(2)
xrangeImg[1] = 0.
xrangeImg[2] = 0.25
yrangeImg[1] = 0.
yrangeImg[2] = 0.25


rangeLog10MSCnts <- numeric(2)
rangeLog10MSCnts[1] = 2.43
rangeLog10MSCnts[2] = 2.65

rangeLog10BkgScale <- numeric(2)
rangeLog10BkgScale[1] = 0.38
rangeLog10BkgScale[2] = 0.42

## Each pdf plot:
##

pdf("Img00Hyp0Hyp1Scatter_1_2.pdf", onefile=F, height=4.3, width=4.3)


plot(I1Hyp0,I1Hyp1,
xlab='Smoothing Hyper-Param 0',
ylab='Smoothing Hyper-Param 1',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='black',
cex.main=1.4,cex.lab=1.4)
points(I2Hyp0,I2Hyp1,pch='+',col='blue')
dev.off()

## Next File:
##

pdf("Img00Hyp2Hyp3Scatter_1_2.pdf", onefile=F, height=4.3, width=4.3)


plot(I1Hyp2,I1Hyp3,
xlab='Smoothing Hyper-Param 2',
ylab='Smoothing Hyper-Param 3',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='black',
cex.main=1.4,cex.lab=1.4)
points(I2Hyp2,I2Hyp3,pch='+',col='blue')
dev.off()

## Next File:
##

pdf("Img00Hyp3Hyp4Scatter_1_2.pdf", onefile=F, height=4.3, width=4.3)


plot(I1Hyp3,I1Hyp4,
xlab='Smoothing Hyper-Param 3',
ylab='Smoothing Hyper-Param 4',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='black',
cex.main=1.4,cex.lab=1.4)
points(I2Hyp3,I2Hyp4,pch='+',col='blue')
dev.off()

## Next File:
##

pdf("Img00ExpMSCntsHyp4Scatter_1_2.pdf", onefile=F, height=4.3, width=4.3)


plot(log10(I1ExpMSCnts),I1Hyp4, #log10(I1BkgScale),
xlab='Log10(Expected MS Counts)',
ylab='Smoothing Hyper-Param 4', #ylab='Log10(BkgScale)',
pch='+', col='black',
xlim=rangeLog10MSCnts,
cex.main=1.4,cex.lab=1.4)
points(log10(I2ExpMSCnts),I2Hyp4,pch='+',col='blue')
dev.off()

