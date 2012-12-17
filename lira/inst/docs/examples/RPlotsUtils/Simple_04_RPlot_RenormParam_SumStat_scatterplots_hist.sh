
r --vanilla <<EOF >  sample_run_Rplot_Renorm_Param_scatterplots.log
##
#####    Making and png files of the specified data
##

##
## In this example, assuming size=32 = 2^7, so 7 scale params.

infileImgDat1 = 'test1_dat_renorm.par'


## In reading in, skip=40 assumes:                                  ####
## 28 header lines, 1 labels line, 10 [ie 100 iters] for burn-in:   ####

ImgDat1 <- read.table(infileImgDat1, header = TRUE, sep = "", quote = "\"'",
           na.strings = "NA", colClasses = NA, nrows = -1,
           skip = 0, check.names = TRUE,
           comment.char = "#",
           allowEscapes = FALSE, flush = FALSE,
           encoding = "unknown")

summary(ImgDat1)

#### Putting the results on data into arrays:

I1Hyp0 <- ImgDat1[[1]]
I1Hyp1 <- ImgDat1[[2]]
I1Hyp2 <- ImgDat1[[3]]
I1Hyp3 <- ImgDat1[[4]]
I1Hyp4 <- ImgDat1[[5]]
I1Hyp5 <- ImgDat1[[6]]
I1Hyp6 <- ImgDat1[[7]]
I1ExpMSCnts <- ImgDat1[[8]]
I1BkgPrefactor <- ImgDat1[[9]]
I1SumStatHyp <-  ImgDat1[[10]]
I1SumStatMSB <-  ImgDat1[[11]]
I1SumStatTot <-  ImgDat1[[12]]




#### Reading in results on Simulated Null Datons:

infileImgNul0 = 'test1_nul_renorm.par'

ImgNul0 <- read.table(infileImgNul0, header = TRUE, sep = "", quote = "\"'",
           na.strings = "NA", colClasses = NA, nrows = -1,
           skip = 40, check.names = TRUE,
           comment.char = "#",
           allowEscapes = FALSE, flush = FALSE,
           encoding = "unknown")

summary(ImgNul0)

########## And arrays from results vs Null Datons: #########

N0Hyp0 <- ImgNul0[[1]]
N0Hyp1 <- ImgNul0[[2]]
N0Hyp2 <- ImgNul0[[3]]
N0Hyp3 <- ImgNul0[[4]]
N0Hyp4 <- ImgNul0[[5]]
N0Hyp5 <- ImgNul0[[6]]
N0Hyp6 <- ImgNul0[[7]]
N0ExpMSCnts <- ImgNul0[[8]]
N0BkgPrefactor <- ImgNul0[[9]]
N0SumStatHyp <-  ImgNul0[[10]]
N0SumStatMSB <-  ImgNul0[[11]]
N0SumStatTot <-  ImgNul0[[12]]


############# Plotting both:

xrangeImg <- numeric(2)
yrangeImg <- numeric(2)
xrangeImg[1] = -5.
xrangeImg[2] =  5.
yrangeImg[1] = -5.
yrangeImg[2] =  5.

sumstathyprange <- numeric(2)
sumstathyprange[1] = -4.
sumstathyprange[2] =  9.

#rangeLog10MSCnts <- numeric(2)
#rangeLog10MSCnts[1] = -2.0
#rangeLog10MSCnts[2] = 2.5

rangeSqrtMSCnts <- numeric(2)
rangeSqrtMSCnts[1] = -5.
rangeSqrtMSCnts[2] =  14.

rangeLog10BkgPrefactor <- numeric(2)
rangeLog10BkgPrefactor[1] = -6.
rangeLog10BkgPrefactor[2] =  6.

## Each png plot:
##

png("Img04Hyp0Hyp1_scatter_all04files.png", height=320, width=320, units="px" )


plot(N0Hyp0,N0Hyp1,
xlab='ReNormed Smoothing Hyper-Param 0',
ylab='ReNormed Smoothing Hyper-Param 1',
xlim=xrangeImg, ylim=yrangeImg,
pch='.', col='magenta',
main='Null(pink) vs Data(dark blue)',
cex=0.15,cex.main=1.4,cex.lab=1.4)
points(I1Hyp0,I1Hyp1,pch=20,col='dark blue',cex=0.25)
dev.off()

## Next File:
##

png("Img04Hyp2Hyp3_scatter_all04files.png", height=320, width=320, units="px" )


plot(N0Hyp2,N0Hyp3,
xlab='ReNormed Smoothing Hyper-Param 2',
ylab='ReNormed Smoothing Hyper-Param 3',
xlim=xrangeImg, ylim=yrangeImg,
pch='.', col='magenta',
main='Null(pink) vs Data(dark blue)',
cex=0.15,cex.main=1.4,cex.lab=1.4)
points(I1Hyp2,I1Hyp3,pch=20,col='dark blue',cex=0.25)
dev.off()

## Next File:
##

png("Img04Hyp4Hyp5_scatter_all04files.png", height=320, width=320, units="px" )


plot(N0Hyp4,N0Hyp5,
xlab='ReNormed Smoothing Hyper-Param 4',
ylab='ReNormed Smoothing Hyper-Param 5',
xlim=xrangeImg, ylim=yrangeImg,
pch='.', col='magenta',
main='Null(pink) vs Data(dark blue)',
cex=0.15,cex.main=1.4,cex.lab=1.4)
points(I1Hyp4,I1Hyp5,pch=20,col='dark blue',cex=0.25)
dev.off()

## Next File:
##

png("Img04Hyp5Hyp6_scatter_all04files.png", height=320, width=320, units="px" )


plot(N0Hyp5,N0Hyp6,
xlab='ReNormed Smoothing Hyper-Param 5',
ylab='ReNormed Smoothing Hyper-Param 6',
xlim=xrangeImg, ylim=yrangeImg,
pch='.', col='magenta',
main='Null(pink) vs Data(dark blue)',
cex=0.15,cex.main=1.4,cex.lab=1.4)
points(I1Hyp5,I1Hyp6,pch=20,col='dark blue',cex=0.25)
dev.off()

## Next File:
##

png("Img04ExpMSCntsBkgPrefactor_scatter_all04files.png", height=320, width=320, units="px" )


plot(N0ExpMSCnts,N0BkgPrefactor,
xlab='ReNormed Sqrt(Expected MS Counts)',
ylab='ReNormed Log10(Bkg Pre-Factor)',
xlim=rangeSqrtMSCnts,
#xlim.rangeLogmagentaCnts,
ylim=rangeLog10BkgPrefactor,
pch='.', col='magenta',
main='Null(pink) vs Data(dark blue)',
cex.main=1.4,cex.lab=1.4,cex=0.15)
points(I1ExpMSCnts,I1BkgPrefactor,pch=20,col='dark blue',cex=0.25)
dev.off()

######### ######### ##########

## Next File:
##


png("Img04StatSumMSBvsHyp_scatter_all04files.png", height=320, width=320, units="px" )


plot(N0SumStatMSB, N0SumStatHyp,
xlab='Summary Stat: MSCts, BkgScale',
ylab='Summary Stat: Smoothing Hyp-Params',
xlim=rangeSqrtMSCnts,
ylim=sumstathyprange,
pch='.', col='magenta',
main='Null(pink) vs Data(dark blue)',
cex.main=1.4,cex.lab=1.4,cex=0.15)
points(I1SumStatMSB, I1SumStatHyp,pch=20,col='dark blue',cex=0.25)
dev.off()



## Next File: HISTOGRAM
##

png("Img04StatSumTot_hist_all04files.png", height=320, width=320, units="px" )

print(I1SumStatTot)

summary(I1SumStatTot)

hist(I1SumStatTot,
xlab='Total Summary Stat',
ylab='Prob Density',
main='Null(pink) vs Data(dark blue)',
plot=TRUE, breaks=20,
freq=FALSE, col='dark blue',border='dark blue',
xlim=rangeSqrtMSCnts,
cex.main=1.4,cex.lab=1.4,cex=0.25)
hist(N0SumStatTot,
plot=TRUE, breaks=20,
freq=FALSE, col='magenta',border='magenta',add=TRUE )
dev.off()

## Next File:
##

png("Img04StatSumMSB_hist_all04files.png", height=320, width=320, units="px" )

print(I1SumStatMSB)

summary(I1SumStatMSB)

hist(I1SumStatMSB,
xlab='MSCounts + PreFactor Summary Stat',
ylab='Prob Density',
main='Null(pink) vs Data(dark blue)',
plot=TRUE, breaks=20,
freq=FALSE, col='dark blue',border='dark blue',
xlim=rangeSqrtMSCnts,
cex.main=1.4,cex.lab=1.4,cex=0.25)
hist(N0SumStatMSB,
plot=TRUE, breaks=20,
freq=FALSE, col='magenta',border='magenta',add=TRUE )
dev.off()

## Next File: HISTOGRAM
##

png("Img04StatSumHyp_hist_all04files.png", height=320, width=320, units="px" )

print(I1SumStatHyp)

summary(I1SumStatHyp)

hist(I1SumStatHyp,
xlab='HyperPar Summary Stat',
ylab='Prob Density',
main='Null(pink) vs Data(dark blue)',
plot=TRUE, breaks=20,
freq=FALSE, col='dark blue',border='dark blue',
xlim=rangeSqrtMSCnts,
cex.main=1.4,cex.lab=1.4,cex=0.25)
hist(N0SumStatHyp,
plot=TRUE, breaks=20,
freq=FALSE, col='magenta',border='magenta',add=TRUE )
dev.off()

