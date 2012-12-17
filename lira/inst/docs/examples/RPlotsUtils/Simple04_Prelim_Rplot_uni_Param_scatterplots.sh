
r --vanilla <<EOF >>  sample_run_Rplot_Param_scatterplots.100616b.log
##
#####    Making and pdf files of the specified data
##

##
## In this example, assuming size=32 = 2^5, so 5 scale params.
## Skipping 1st 200 iterations. At thn=1, this is 1st 200 lines of param.:

infileImgDat0 = '../outputs/Simple04_Prelim_Gauss2d1.5_PoisDatons128x128testEvsNull_Strt0.01_viaFits.param'
infileImgDat1 = '../outputs/Simple04_Prelim_Gauss2d1.5_PoisDatons128x128testEvsNull_Strt1.00_viaFits.param'


ImgDat1 <- read.table(infileImgDat1, header = TRUE, sep = "", quote = "\"'",
           na.strings = "NA", colClasses = NA, nrows = -1,
           skip = 200, check.names = TRUE,
           comment.char = "#",
           allowEscapes = FALSE, flush = FALSE,
           encoding = "unknown")

ImgDat0 <- read.table(infileImgDat0, header = TRUE, sep = "", quote = "\"'",
           na.strings = "NA", colClasses = NA, nrows = -1,
           skip = 200, check.names = TRUE,
           comment.char = "#",
           allowEscapes = FALSE, flush = FALSE,
           encoding = "unknown")

#### Putting the results on data into arrays:

I0Iter <- ImgDat0[[1]]
I0LogProb <- ImgDat0[[2]]
I0ProbStep <- ImgDat0[[3]]
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
I1BkgPrefactor <- ImgDat1[[14]]



############# Plotting both:

xrangeImg <- numeric(2)
yrangeImg <- numeric(2)
xrangeImg[1] = 0.
xrangeImg[2] = 0.5 #0.22
yrangeImg[1] = 0.
yrangeImg[2] = 0.5 #0.22


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

## Each pdf plot:
##

pdf("Img04PrelimHyp0Hyp1Scatter_1_2.pdf", onefile=F, height=4.3, width=4.3)


plot(I1Hyp0,I1Hyp1,
xlab='Smoothing Hyper-Param 0',
ylab='Smoothing Hyper-Param 1',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
points(I0Hyp0,I0Hyp1,pch='+',col='black')
dev.off()

## Next File:
##

pdf("Img04PrelimHyp2Hyp3Scatter_1_2.pdf", onefile=F, height=4.3, width=4.3)


plot(I1Hyp2,I1Hyp3,
xlab='Smoothing Hyper-Param 2',
ylab='Smoothing Hyper-Param 3',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
points(I0Hyp2,I0Hyp3,pch='+',col='black')
dev.off()

## Next File:
##

pdf("Img04PrelimHyp3Hyp4Scatter_1_2.pdf", onefile=F, height=4.3, width=4.3)


plot(I1Hyp4,I1Hyp5,
xlab='Smoothing Hyper-Param 4',
ylab='Smoothing Hyper-Param 5',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
points(I0Hyp4,I0Hyp5,pch='+',col='black')
dev.off()

## Next File:
##

pdf("Img04PrelimExpMSCntsBkgPrefactorScatter_1_2.pdf", onefile=F, height=4.3, width=4.3)


plot(sqrt(I1ExpMSCnts), log10(I1BkgPrefactor),
xlab='Sqrt(Expected MS Counts)',
ylab='Log10(Bkg Pre-Factor)',
pch='+', col='blue',
#main='Data (+)',
xlim=rangeSqrtMSCnts,
ylim=rangeLog10BkgPrefactor,
cex.main=1.4,cex.lab=1.4)
points(sqrt(I0ExpMSCnts),log10(I0BkgPrefactor),pch='+',col='black')
#points(sqrt(sqrt(I0ExpMSCnts)),log10(I0BkgPrefactor),pch='+',col='black')
#points(log10(I0ExpMSCnts),log10(I0BkgPrefactor),pch=20,col='black')
dev.off()
