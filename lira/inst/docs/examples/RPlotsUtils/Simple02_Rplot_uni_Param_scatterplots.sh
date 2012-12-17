
r --vanilla <<EOF >>  sample_run_Rplot_Param_scatterplots.100616b.log
##
#####    Making and pdf files of the specified data
##

##
## In this example, assuming size=32 = 2^5, so 5 scale params.

infileImgDat0 = '../outputs/PoisDatons32x32EEMC2vsNullModel_Strt0.01_viaFits.param'
infileImgDat1 = '../outputs/PoisDatons32x32EEMC2vsNullModel_Strt1.00_viaFits.param'


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

#### Putting the results on data into arrays:

I0LogProb <- ImgDat0[[3]]
I0SpinRow <- ImgDat0[[4]]
I0SpinCol <- ImgDat0[[5]]
I0Hyp0 <- ImgDat0[[6]]
I0Hyp1 <- ImgDat0[[7]]
I0Hyp2 <- ImgDat0[[8]]
I0Hyp3 <- ImgDat0[[9]]
I0Hyp4 <- ImgDat0[[10]]
I0ExpMSCnts <- ImgDat0[[11]]
I0BkgPrefactor <- ImgDat0[[12]]

I1LogProb <- ImgDat1[[3]]
I1SpinRow <- ImgDat1[[4]]
I1SpinCol <- ImgDat1[[5]]
I1Hyp0 <- ImgDat1[[6]]
I1Hyp1 <- ImgDat1[[7]]
I1Hyp2 <- ImgDat1[[8]]
I1Hyp3 <- ImgDat1[[9]]
I1Hyp4 <- ImgDat1[[10]]
I1ExpMSCnts <- ImgDat1[[11]]
I1BkgPrefactor <- ImgDat1[[12]]



#### Reading in results on Simulated Null Datons:

infileImgNul0 = '../outputs/PoisNulDat032x32EEMC2vsNullModel_Strt1.00_viaFits.param'
infileImgNul1 = '../outputs/PoisNulDat132x32EEMC2vsNullModel_Strt0.01_viaFits.param'
infileImgNul2 = '../outputs/PoisNulDat232x32EEMC2vsNullModel_Strt1.00_viaFits.param'
infileImgNul3 = '../outputs/PoisNulDat332x32EEMC2vsNullModel_Strt0.01_viaFits.param'
infileImgNul4 = '../outputs/PoisNulDat432x32EEMC2vsNullModel_Strt1.00_viaFits.param'
infileImgNul5 = '../outputs/PoisNulDat532x32EEMC2vsNullModel_Strt0.01_viaFits.param'



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
N0ExpMSCnts <- ImgNul0[[11]]
N0BkgPrefactor <- ImgNul0[[12]]

N1LogProb <- ImgNul1[[3]]
N1SpinRow <- ImgNul1[[4]]
N1SpinCol <- ImgNul1[[5]]
N1Hyp0 <- ImgNul1[[6]]
N1Hyp1 <- ImgNul1[[7]]
N1Hyp2 <- ImgNul1[[8]]
N1Hyp3 <- ImgNul1[[9]]
N1Hyp4 <- ImgNul1[[10]]
N1ExpMSCnts <- ImgNul1[[11]]
N1BkgPrefactor <- ImgNul1[[12]]

N2LogProb <- ImgNul2[[3]]
N2SpinRow <- ImgNul2[[4]]
N2SpinCol <- ImgNul2[[5]]
N2Hyp0 <- ImgNul2[[6]]
N2Hyp1 <- ImgNul2[[7]]
N2Hyp2 <- ImgNul2[[8]]
N2Hyp3 <- ImgNul2[[9]]
N2Hyp4 <- ImgNul2[[10]]
N2ExpMSCnts <- ImgNul2[[11]]
N2BkgPrefactor <- ImgNul2[[12]]

N3LogProb <- ImgNul3[[3]]
N3SpinRow <- ImgNul3[[4]]
N3SpinCol <- ImgNul3[[5]]
N3Hyp0 <- ImgNul3[[6]]
N3Hyp1 <- ImgNul3[[7]]
N3Hyp2 <- ImgNul3[[8]]
N3Hyp3 <- ImgNul3[[9]]
N3Hyp4 <- ImgNul3[[10]]
N3ExpMSCnts <- ImgNul3[[11]]
N3BkgPrefactor <- ImgNul3[[12]]

N4LogProb <- ImgNul4[[3]]
N4SpinRow <- ImgNul4[[4]]
N4SpinCol <- ImgNul4[[5]]
N4Hyp0 <- ImgNul4[[6]]
N4Hyp1 <- ImgNul4[[7]]
N4Hyp2 <- ImgNul4[[8]]
N4Hyp3 <- ImgNul4[[9]]
N4Hyp4 <- ImgNul4[[10]]
N4ExpMSCnts <- ImgNul4[[11]]
N4BkgPrefactor <- ImgNul4[[12]]

N5LogProb <- ImgNul5[[3]]
N5SpinRow <- ImgNul5[[4]]
N5SpinCol <- ImgNul5[[5]]
N5Hyp0 <- ImgNul5[[6]]
N5Hyp1 <- ImgNul5[[7]]
N5Hyp2 <- ImgNul5[[8]]
N5Hyp3 <- ImgNul5[[9]]
N5Hyp4 <- ImgNul5[[10]]
N5ExpMSCnts <- ImgNul5[[11]]
N5BkgPrefactor <- ImgNul5[[12]]



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

## Each pdf plot:
##

pdf("Img02Hyp0Hyp1Scatter_1_2.pdf", onefile=F, height=4.3, width=4.3)


plot(I1Hyp0,I1Hyp1,
xlab='Smoothing Hyper-Param 0',
ylab='Smoothing Hyper-Param 1',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
main='Data (+), Null (.)',
cex.main=1.4,cex.lab=1.4)
points(I0Hyp0,I0Hyp1,pch='+',col='black')
points(N0Hyp0,N0Hyp1,pch=20,col='yellow')
points(N1Hyp0,N1Hyp1,pch=20,col='orange')
points(N2Hyp0,N2Hyp1,pch=20,col='green')
points(N3Hyp0,N3Hyp1,pch=20,col='purple')
points(N4Hyp0,N4Hyp1,pch=20,col='red')
points(N5Hyp0,N5Hyp1,pch=20,col='magenta')
dev.off()

## Next File:
##

pdf("Img02Hyp2Hyp3Scatter_1_2.pdf", onefile=F, height=4.3, width=4.3)


plot(I1Hyp2,I1Hyp3,
xlab='Smoothing Hyper-Param 2',
ylab='Smoothing Hyper-Param 3',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
main='Data (+), Null (.)',
cex.main=1.4,cex.lab=1.4)
points(I0Hyp2,I0Hyp3,pch='+',col='black')
points(N0Hyp2,N0Hyp3,pch=20,col='yellow')
points(N1Hyp2,N1Hyp3,pch=20,col='orange')
points(N1Hyp2,N1Hyp3,pch=20,col='green')
points(N3Hyp2,N3Hyp3,pch=20,col='purple')
points(N4Hyp2,N4Hyp3,pch=20,col='red')
points(N5Hyp2,N5Hyp3,pch=20,col='magenta')
dev.off()

## Next File:
##

pdf("Img02Hyp3Hyp4Scatter_1_2.pdf", onefile=F, height=4.3, width=4.3)


plot(I1Hyp3,I1Hyp4,
xlab='Smoothing Hyper-Param 3',
ylab='Smoothing Hyper-Param 4',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
main='Data (+), Null (.)',
cex.main=1.4,cex.lab=1.4)
points(I0Hyp3,I0Hyp4,pch='+',col='black')
points(N0Hyp3,N0Hyp4,pch=20,col='yellow')
points(N1Hyp3,N1Hyp4,pch=20,col='orange')
points(N1Hyp3,N1Hyp4,pch=20,col='green')
points(N3Hyp3,N3Hyp4,pch=20,col='purple')
points(N4Hyp3,N4Hyp4,pch=20,col='red')
points(N5Hyp3,N5Hyp4,pch=20,col='magenta')
dev.off()

## Next File:
##

pdf("Img02ExpMSCntsBkgPrefactorScatter_1_2.pdf", onefile=F, height=4.3, width=4.3)


plot(sqrt(I1ExpMSCnts), log10(I1BkgPrefactor),
xlab='Sqrt(Expected MS Counts)',
ylab='Log10(Bkg Pre-Factor)',
pch='+', col='blue',
main='Data (+), Null (.)',
xlim=rangeSqrtMSCnts,
ylim=rangeLog10BkgPrefactor,
cex.main=1.4,cex.lab=1.4)
points(sqrt(I0ExpMSCnts),log10(I0BkgPrefactor),pch='+',col='black')
points(sqrt(N0ExpMSCnts),log10(N0BkgPrefactor),pch=20,col='yellow')
points(sqrt(N1ExpMSCnts),log10(N1BkgPrefactor),pch=20,col='orange')
points(sqrt(N1ExpMSCnts),log10(N1BkgPrefactor),pch=20,col='green')
points(sqrt(N3ExpMSCnts),log10(N3BkgPrefactor),pch=20,col='purple')
points(sqrt(N4ExpMSCnts),log10(N4BkgPrefactor),pch=20,col='red')
points(sqrt(N5ExpMSCnts),log10(N5BkgPrefactor),pch=20,col='magenta')
#points(sqrt(sqrt(I0ExpMSCnts)),log10(I0BkgPrefactor),pch='+',col='black')
#points(sqrt(sqrt(N0ExpMSCnts)),log10(N0BkgPrefactor),pch=20,col='yellow')
#points(sqrt(sqrt(N1ExpMSCnts)),log10(N1BkgPrefactor),pch=20,col='orange')
#points(sqrt(sqrt(N1ExpMSCnts)),log10(N1BkgPrefactor),pch=20,col='green')
#points(sqrt(sqrt(N3ExpMSCnts)),log10(N3BkgPrefactor),pch=20,col='purple')
#points(sqrt(sqrt(N4ExpMSCnts)),log10(N4BkgPrefactor),pch=20,col='red')
#points(sqrt(sqrt(N5ExpMSCnts)),log10(N5BkgPrefactor),pch=20,col='magenta')
#points(log10(I0ExpMSCnts),log10(I0BkgPrefactor),pch=20,col='blue')
#points(log10(N0ExpMSCnts),log10(N0BkgPrefactor),pch=20,col='yellow')
#points(log10(N1ExpMSCnts),log10(N1BkgPrefactor),pch=20,col='orange')
#points(log10(N1ExpMSCnts),log10(N1BkgPrefactor),pch=20,col='green')
#points(log10(N3ExpMSCnts),log10(N3BkgPrefactor),pch=20,col='purple')
#points(log10(N4ExpMSCnts),log10(N4BkgPrefactor),pch=20,col='red')
#points(log10(N5ExpMSCnts),log10(N5BkgPrefactor),pch=20,col='magenta')
dev.off()

