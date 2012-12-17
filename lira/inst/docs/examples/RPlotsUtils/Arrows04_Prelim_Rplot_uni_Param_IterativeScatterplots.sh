
r --vanilla <<EOF >>  sample_run_Rplot_Param_scatterplots.100616b.log
##
#####    Making and png files of the specified data
##

##
## In this example, assuming size=32 = 2^5, so 5 scale params.
## Skipping 1st 200 iterations. At thn=1, this is 1st 200 lines of param.:

infileImgDat0 = '../outputs/Simple04_Prelim_Gauss2d1.5_PoisDatons128x128testEvsNull_Strt0.01_viaFits.param'
infileImgDat1 = '../outputs/Simple04_Prelim_Gauss2d1.5_PoisDatons128x128testEvsNull_Strt1.00_viaFits.param'


ImgDat1 <- read.table(infileImgDat1, header = TRUE, sep = "", quote = "\"'",
           na.strings = "NA", colClasses = NA, nrows = -1,
           skip = 0, check.names = TRUE,
           comment.char = "#",
           allowEscapes = FALSE, flush = FALSE,
           encoding = "unknown")

ImgDat0 <- read.table(infileImgDat0, header = TRUE, sep = "", quote = "\"'",
           na.strings = "NA", colClasses = NA, nrows = -1,
           skip = 0, check.names = TRUE,
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


rangeLog10Prob <- numeric(2)
rangeLog10Prob[1] = -50100.
rangeLog10Prob[2] =  -6000.

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
rangeSqrtMSCnts[2] = 34.

rangeSqrtSqrtMSCnts <- numeric(2)
rangeSqrtSqrtMSCnts[1] = 0.0
rangeSqrtSqrtMSCnts[2] = 12.

rangeLog10BkgPrefactor <- numeric(2)
rangeLog10BkgPrefactor[1] = -1.0
rangeLog10BkgPrefactor[2] = 0.5

rangeiter <- numeric(2)
rangeiter[1] = 0.
rangeiter[2] = 100.
log10euler = log10(exp(1.000000000000))


## Arrows coordinates declared:

xarrows    <- numeric(2)
yarrows    <- numeric(2)

#--------------------------------------------------------------------------------------#
# And now the tedious process of making successive plots for more and more iterations:
#

#########################################################################
## Each png plot:
##

## Iteration 100: ########################################################

png("Arrow04Prelim_Iter100_LogProbTimeTrace_small.png", height=240, width=240, units="px" )

plot(I0Iter[1:100],(I0LogProb[1:100]*log10euler),type="o",
xlab='Iteration',
ylab=' Log10 Post Prob',
ylim=rangeLog10Prob,
pch='.',col="blue",
cex.main=1.4,cex.lab=1.4)
lines(I1Iter[1:100],(I1LogProb[1:100]*log10euler),col="black")

dev.off()


## Next File:
##

png("Arrow04Prelim_Iter100_Hyp0Hyp1Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp0[1:100],I1Hyp1[1:100],type="o",
xlab='Tuning Hyper-Param 0',
ylab='Tuning Hyper-Param 1',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp0[1:100],I0Hyp1[1:100],pch='+',col='black')
lines(I0Hyp0[1:100],I0Hyp1[1:100],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Arrow04Prelim_Iter100_Hyp2Hyp3Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp2[1:100],I1Hyp3[1:100],type="o",
xlab='Tuning Hyper-Param 2',
ylab='Tuning Hyper-Param 3',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp2[1:100],I0Hyp3[1:100],pch='+',col='black')
lines(I0Hyp2[1:100],I0Hyp3[1:100],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Arrow04Prelim_Iter100_Hyp5Hyp6Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp5[1:100],I1Hyp6[1:100],type="o",
xlab='Tuning Hyper-Param 5',
ylab='Tuning Hyper-Param 6',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp5[1:100],I0Hyp6[1:100],pch='+',col='black')
lines(I0Hyp5[1:100],I0Hyp6[1:100],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Arrow04Prelim_Iter100_Hyp4Hyp5Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp4[1:100],I1Hyp5[1:100],type="o",
xlab='Tuning Hyper-Param 4',
ylab='Tuning Hyper-Param 5',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp4[1:100],I0Hyp5[1:100],pch='+',col='black')
lines(I0Hyp4[1:100],I0Hyp5[1:100],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Arrow04Prelim_Iter100_ExpMSCntsBkgPrefactorScatter_1_2_small.png", height=240, width=240, units="px" )

xarrows[1] = rangeSqrtMSCnts[1] + 0.8*(rangeSqrtMSCnts[2]-rangeSqrtMSCnts[1])
xarrows[2] = xarrows[1]
yarrows[1] = rangeLog10BkgPrefactor[1]
yarrows[2] = rangeLog10BkgPrefactor[1] + 0.8*(rangeLog10BkgPrefactor[2]-rangeLog10BkgPrefactor[1])

plot(sqrt(I1ExpMSCnts[1:100]), log10(I1BkgPrefactor[1:100]),type="o",
xlab='Sqrt(Expected MS Counts)',
ylab='Log10(Bkg Pre-Factor)',
pch='+', col='blue',
#main='Data (+)',
xlim=rangeSqrtMSCnts,
ylim=rangeLog10BkgPrefactor,
cex.main=1.4,cex.lab=1.4)
#points(sqrt(I0ExpMSCnts[1:100]),log10(I0BkgPrefactor[1:100]),pch='+',col='black')
lines(sqrt(I0ExpMSCnts[1:100]),log10(I0BkgPrefactor[1:100]),pch='+',col='black',type="o")
dev.off()


## Iteration 125: ########################################################

png("Arrow04Prelim_Iter125_LogProbTimeTrace_small.png", height=240, width=240, units="px" )

plot(I0Iter[1:125],(I0LogProb[1:125]*log10euler),type="o",
xlab='Iteration',
ylab=' Log10 Post Prob',
ylim=rangeLog10Prob,
pch='.',col="blue",
cex.main=1.4,cex.lab=1.4)
lines(I1Iter[1:125],(I1LogProb[1:125]*log10euler),col="black")

dev.off()


## Next File:
##

png("Arrow04Prelim_Iter125_Hyp0Hyp1Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp0[1:125],I1Hyp1[1:125],type="o",
xlab='Tuning Hyper-Param 0',
ylab='Tuning Hyper-Param 1',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp0[1:125],I0Hyp1[1:125],pch='+',col='black')
lines(I0Hyp0[1:125],I0Hyp1[1:125],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Arrow04Prelim_Iter125_Hyp2Hyp3Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp2[1:125],I1Hyp3[1:125],type="o",
xlab='Tuning Hyper-Param 2',
ylab='Tuning Hyper-Param 3',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp2[1:125],I0Hyp3[1:125],pch='+',col='black')
lines(I0Hyp2[1:125],I0Hyp3[1:125],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Arrow04Prelim_Iter125_Hyp5Hyp6Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp5[1:125],I1Hyp6[1:125],type="o",
xlab='Tuning Hyper-Param 5',
ylab='Tuning Hyper-Param 6',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp5[1:125],I0H6p5[1:125],pch='+',col='black')
lines(I0Hyp5[1:125],I0Hyp6[1:125],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Arrow04Prelim_Iter125_Hyp4Hyp5Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp4[1:125],I1Hyp5[1:125],type="o",
xlab='Tuning Hyper-Param 4',
ylab='Tuning Hyper-Param 5',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp4[1:125],I0H6p5[1:125],pch='+',col='black')
lines(I0Hyp5[1:125],I0Hyp5[1:125],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Arrow04Prelim_Iter125_ExpMSCntsBkgPrefactorScatter_1_2_small.png", height=240, width=240, units="px" )


plot(sqrt(I1ExpMSCnts[1:125]), log10(I1BkgPrefactor[1:125]),type="o",
xlab='Sqrt(Expected MS Counts)',
ylab='Log10(Bkg Pre-Factor)',
pch='+', col='blue',
#main='Data (+)',
xlim=rangeSqrtMSCnts,
ylim=rangeLog10BkgPrefactor,
cexy.main=1.4,cex.lab=1.4)
#points(sqrt(I0ExpMSCnts[1:125]),log10(I0BkgPrefactor[1:125]),pch='+',col='black')
lines(sqrt(I0ExpMSCnts[1:125]),log10(I0BkgPrefactor[1:125]),pch='+',col='black',type="o")
dev.off()


