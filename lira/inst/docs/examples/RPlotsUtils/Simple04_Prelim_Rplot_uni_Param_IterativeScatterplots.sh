
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

#--------------------------------------------------------------------------------------#
# And now the tedious process of making successive plots for more and more iterations:
#

#########################################################################
## Each png plot:
##

## Iteration 1: ########################################################

png("Img04Prelim_Iter001_LogProbTimeTrace_small.png", height=240, width=240, units="px" )

plot(I0Iter[1:1],(I0LogProb[1:1]*log10euler),type="o",
xlab='Iteration',
ylab=' Log10 Post Prob',
ylim=rangeLog10Prob,
pch='+',col="blue",
cex.main=1.4,cex.lab=1.4)
#lines(I1Iter[1:1],(I1LogProb[1:1]*log10euler),col="black",pch='+')
points(I1Iter[1:1],(I1LogProb[1:1]*log10euler),col="black",pch='+')

dev.off()


## Next File:
##

png("Img04Prelim_Iter001_Hyp0Hyp1Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp0[1:1],I1Hyp1[1:1],type="o",
xlab='Tuning Hyper-Param 0',
ylab='Tuning Hyper-Param 1',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
points(I0Hyp0[1:1],I0Hyp1[1:1],pch='+',col='black')
#lines(I0Hyp0[1:1],I0Hyp1[1:1],pch='+',col='black')
dev.off()

## Next File:
##

png("Img04Prelim_Iter001_Hyp2Hyp3Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp2[1:1],I1Hyp3[1:1],type="o",
xlab='Tuning Hyper-Param 2',
ylab='Tuning Hyper-Param 3',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
points(I0Hyp2[1:1],I0Hyp3[1:1],pch='+',col='black')
#lines(I0Hyp2[1:1],I0Hyp3[1:1],pch='+',col='black')
dev.off()

## Next File:
##

png("Img04Prelim_Iter001_Hyp5Hyp6Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp5[1:1],I1Hyp6[1:1],type="o",
xlab='Tuning Hyper-Param 5',
ylab='Tuning Hyper-Param 6',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
points(I0Hyp5[1:1],I0Hyp6[1:1],pch='+',col='black')
#lines(I0Hyp5[1:1],I0Hyp6[1:1],pch='+',col='black')
dev.off()

## Next File:
##

png("Img04Prelim_Iter001_Hyp4Hyp5Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp4[1:1],I1Hyp5[1:1],type="o",
xlab='Tuning Hyper-Param 4',
ylab='Tuning Hyper-Param 5',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
points(I0Hyp4[1:1],I0Hyp5[1:1],pch='+',col='black')
#lines(I0Hyp4[1:1],I0Hyp5[1:1],pch='+',col='black')
dev.off()

## Next File:
##

png("Img04Prelim_Iter001_ExpMSCntsBkgPrefactorScatter_1_2_small.png", height=240, width=240, units="px" )


plot(sqrt(I1ExpMSCnts[1:1]), log10(I1BkgPrefactor[1:1]),type="o",
xlab='Sqrt(Expected MS Counts)',
ylab='Log10(Bkg Pre-Factor)',
pch='+', col='blue',
#main='Data (+)',
xlim=rangeSqrtMSCnts,
ylim=rangeLog10BkgPrefactor,
cex.main=1.4,cex.lab=1.4)
points(sqrt(I0ExpMSCnts[1:1]),log10(I0BkgPrefactor[1:1]),pch='+',col='black')
#lines(sqrt(I0ExpMSCnts[1:1]),log10(I0BkgPrefactor[1:1]),pch='+',col='black')
dev.off()

## Iteration 2: ########################################################

png("Img04Prelim_Iter002_LogProbTimeTrace_small.png", height=240, width=240, units="px" )

plot(I0Iter[1:2],(I0LogProb[1:2]*log10euler),type="o",
xlab='Iteration',
ylab=' Log10 Post Prob',
ylim=rangeLog10Prob,
pch='+',col="blue",
cex.main=1.4,cex.lab=1.4)
lines(I1Iter[1:2],(I1LogProb[1:2]*log10euler),col="black",pch='+')

dev.off()


## Next File:
##

png("Img04Prelim_Iter002_Hyp0Hyp1Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp0[1:2],I1Hyp1[1:2],type="o",
xlab='Tuning Hyper-Param 0',
ylab='Tuning Hyper-Param 1',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp0[1:2],I0Hyp1[1:2],pch='+',col='black')
lines(I0Hyp0[1:2],I0Hyp1[1:2],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter002_Hyp2Hyp3Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp2[1:2],I1Hyp3[1:2],type="o",
xlab='Tuning Hyper-Param 2',
ylab='Tuning Hyper-Param 3',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp2[1:2],I0Hyp3[1:2],pch='+',col='black')
lines(I0Hyp2[1:2],I0Hyp3[1:2],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter002_Hyp5Hyp6Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp5[1:2],I1Hyp6[1:2],type="o",
xlab='Tuning Hyper-Param 5',
ylab='Tuning Hyper-Param 6',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp5[1:2],I0Hyp6[1:2],pch='+',col='black')
lines(I0Hyp5[1:2],I0Hyp6[1:2],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter002_Hyp4Hyp5Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp4[1:2],I1Hyp5[1:2],type="o",
xlab='Tuning Hyper-Param 4',
ylab='Tuning Hyper-Param 5',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp4[1:2],I0Hyp5[1:2],pch='+',col='black')
lines(I0Hyp4[1:2],I0Hyp5[1:2],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter002_ExpMSCntsBkgPrefactorScatter_1_2_small.png", height=240, width=240, units="px" )


plot(sqrt(I1ExpMSCnts[1:2]), log10(I1BkgPrefactor[1:2]),type="o",
xlab='Sqrt(Expected MS Counts)',
ylab='Log10(Bkg Pre-Factor)',
pch='+', col='blue',
#main='Data (+)',
xlim=rangeSqrtMSCnts,
ylim=rangeLog10BkgPrefactor,
cex.main=1.4,cex.lab=1.4)
#points(sqrt(I0ExpMSCnts[1:2]),log10(I0BkgPrefactor[1:2]),pch='+',col='black')
lines(sqrt(I0ExpMSCnts[1:2]),log10(I0BkgPrefactor[1:2]),pch='+',col='black',type="o")
dev.off()

## Iteration 3: ########################################################

png("Img04Prelim_Iter003_LogProbTimeTrace_small.png", height=240, width=240, units="px" )

plot(I0Iter[1:3],(I0LogProb[1:3]*log10euler),type="o",
xlab='Iteration',
ylab=' Log10 Post Prob',
ylim=rangeLog10Prob,
pch='.',col="blue",
cex.main=1.4,cex.lab=1.4)
lines(I1Iter[1:3],(I1LogProb[1:3]*log10euler),col="black")

dev.off()


## Next File:
##

png("Img04Prelim_Iter003_Hyp0Hyp1Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp0[1:3],I1Hyp1[1:3],type="o",
xlab='Tuning Hyper-Param 0',
ylab='Tuning Hyper-Param 1',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp0[1:3],I0Hyp1[1:3],pch='+',col='black')
lines(I0Hyp0[1:3],I0Hyp1[1:3],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter003_Hyp2Hyp3Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp2[1:3],I1Hyp3[1:3],type="o",
xlab='Tuning Hyper-Param 2',
ylab='Tuning Hyper-Param 3',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp2[1:3],I0Hyp3[1:3],pch='+',col='black')
lines(I0Hyp2[1:3],I0Hyp3[1:3],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter003_Hyp5Hyp6Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp5[1:3],I1Hyp6[1:3],type="o",
xlab='Tuning Hyper-Param 5',
ylab='Tuning Hyper-Param 6',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp5[1:3],I0Hyp6[1:3],pch='+',col='black')
lines(I0Hyp5[1:3],I0Hyp6[1:3],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter003_Hyp4Hyp5Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp4[1:3],I1Hyp5[1:3],type="o",
xlab='Tuning Hyper-Param 4',
ylab='Tuning Hyper-Param 5',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp4[1:3],I0Hyp5[1:3],pch='+',col='black')
lines(I0Hyp4[1:3],I0Hyp5[1:3],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter003_ExpMSCntsBkgPrefactorScatter_1_2_small.png", height=240, width=240, units="px" )


plot(sqrt(I1ExpMSCnts[1:3]), log10(I1BkgPrefactor[1:3]),type="o",
xlab='Sqrt(Expected MS Counts)',
ylab='Log10(Bkg Pre-Factor)',
pch='+', col='blue',
#main='Data (+)',
xlim=rangeSqrtMSCnts,
ylim=rangeLog10BkgPrefactor,
cex.main=1.4,cex.lab=1.4)
#points(sqrt(I0ExpMSCnts[1:3]),log10(I0BkgPrefactor[1:3]),pch='+',col='black')
lines(sqrt(I0ExpMSCnts[1:3]),log10(I0BkgPrefactor[1:3]),pch='+',col='black',type="o")
dev.off()

## Iteration 4: ########################################################

png("Img04Prelim_Iter004_LogProbTimeTrace_small.png", height=240, width=240, units="px" )

plot(I0Iter[1:4],(I0LogProb[1:4]*log10euler),type="o",
xlab='Iteration',
ylab=' Log10 Post Prob',
ylim=rangeLog10Prob,
pch='.',col="blue",
cex.main=1.4,cex.lab=1.4)
lines(I1Iter[1:4],(I1LogProb[1:4]*log10euler),col="black")

dev.off()


## Next File:
##

png("Img04Prelim_Iter004_Hyp0Hyp1Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp0[1:4],I1Hyp1[1:4],type="o",
xlab='Tuning Hyper-Param 0',
ylab='Tuning Hyper-Param 1',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp0[1:4],I0Hyp1[1:4],pch='+',col='black')
lines(I0Hyp0[1:4],I0Hyp1[1:4],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter004_Hyp2Hyp3Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp2[1:4],I1Hyp3[1:4],type="o",
xlab='Tuning Hyper-Param 2',
ylab='Tuning Hyper-Param 3',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp2[1:4],I0Hyp3[1:4],pch='+',col='black')
lines(I0Hyp2[1:4],I0Hyp3[1:4],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter004_Hyp5Hyp6Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp5[1:4],I1Hyp6[1:4],type="o",
xlab='Tuning Hyper-Param 5',
ylab='Tuning Hyper-Param 6',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp5[1:4],I0Hyp6[1:4],pch='+',col='black')
lines(I0Hyp5[1:4],I0Hyp6[1:4],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter004_Hyp4Hyp5Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp4[1:4],I1Hyp5[1:4],type="o",
xlab='Tuning Hyper-Param 4',
ylab='Tuning Hyper-Param 5',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp4[1:4],I0Hyp5[1:4],pch='+',col='black')
lines(I0Hyp4[1:4],I0Hyp5[1:4],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter004_ExpMSCntsBkgPrefactorScatter_1_2_small.png", height=240, width=240, units="px" )


plot(sqrt(I1ExpMSCnts[1:4]), log10(I1BkgPrefactor[1:4]),type="o",
xlab='Sqrt(Expected MS Counts)',
ylab='Log10(Bkg Pre-Factor)',
pch='+', col='blue',
#main='Data (+)',
xlim=rangeSqrtMSCnts,
ylim=rangeLog10BkgPrefactor,
cex.main=1.4,cex.lab=1.4)
#points(sqrt(I0ExpMSCnts[1:4]),log10(I0BkgPrefactor[1:4]),pch='+',col='black')
lines(sqrt(I0ExpMSCnts[1:4]),log10(I0BkgPrefactor[1:4]),pch='+',col='black',type="o")
dev.off()

## Iteration 5: ########################################################

png("Img04Prelim_Iter005_LogProbTimeTrace_small.png", height=240, width=240, units="px" )

plot(I0Iter[1:5],(I0LogProb[1:5]*log10euler),type="o",
xlab='Iteration',
ylab=' Log10 Post Prob',
ylim=rangeLog10Prob,
pch='.',col="blue",
cex.main=1.4,cex.lab=1.4)
lines(I1Iter[1:5],(I1LogProb[1:5]*log10euler),col="black")

dev.off()


## Next File:
##

png("Img04Prelim_Iter005_Hyp0Hyp1Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp0[1:5],I1Hyp1[1:5],type="o",
xlab='Tuning Hyper-Param 0',
ylab='Tuning Hyper-Param 1',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp0[1:5],I0Hyp1[1:5],pch='+',col='black')
lines(I0Hyp0[1:5],I0Hyp1[1:5],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter005_Hyp2Hyp3Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp2[1:5],I1Hyp3[1:5],type="o",
xlab='Tuning Hyper-Param 2',
ylab='Tuning Hyper-Param 3',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp2[1:5],I0Hyp3[1:5],pch='+',col='black')
lines(I0Hyp2[1:5],I0Hyp3[1:5],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter005_Hyp5Hyp6Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp5[1:5],I1Hyp6[1:5],type="o",
xlab='Tuning Hyper-Param 5',
ylab='Tuning Hyper-Param 6',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp5[1:5],I0Hyp6[1:5],pch='+',col='black')
lines(I0Hyp5[1:5],I0Hyp6[1:5],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter005_Hyp4Hyp5Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp4[1:5],I1Hyp5[1:5],type="o",
xlab='Tuning Hyper-Param 4',
ylab='Tuning Hyper-Param 5',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp4[1:5],I0Hyp5[1:5],pch='+',col='black')
lines(I0Hyp4[1:5],I0Hyp5[1:5],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter005_ExpMSCntsBkgPrefactorScatter_1_2_small.png", height=240, width=240, units="px" )


plot(sqrt(I1ExpMSCnts[1:5]), log10(I1BkgPrefactor[1:5]),type="o",
xlab='Sqrt(Expected MS Counts)',
ylab='Log10(Bkg Pre-Factor)',
pch='+', col='blue',
#main='Data (+)',
xlim=rangeSqrtMSCnts,
ylim=rangeLog10BkgPrefactor,
cex.main=1.4,cex.lab=1.4)
#points(sqrt(I0ExpMSCnts[1:5]),log10(I0BkgPrefactor[1:5]),pch='+',col='black')
lines(sqrt(I0ExpMSCnts[1:5]),log10(I0BkgPrefactor[1:5]),pch='+',col='black',type="o")
dev.off()

## Iteration 6: ########################################################

png("Img04Prelim_Iter006_LogProbTimeTrace_small.png", height=240, width=240, units="px" )

plot(I0Iter[1:6],(I0LogProb[1:6]*log10euler),type="o",
xlab='Iteration',
ylab=' Log10 Post Prob',
ylim=rangeLog10Prob,
pch='.',col="blue",
cex.main=1.4,cex.lab=1.4)
lines(I1Iter[1:6],(I1LogProb[1:6]*log10euler),col="black")

dev.off()


## Next File:
##

png("Img04Prelim_Iter006_Hyp0Hyp1Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp0[1:6],I1Hyp1[1:6],type="o",
xlab='Tuning Hyper-Param 0',
ylab='Tuning Hyper-Param 1',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp0[1:6],I0Hyp1[1:6],pch='+',col='black')
lines(I0Hyp0[1:6],I0Hyp1[1:6],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter006_Hyp2Hyp3Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp2[1:6],I1Hyp3[1:6],type="o",
xlab='Tuning Hyper-Param 2',
ylab='Tuning Hyper-Param 3',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp2[1:6],I0Hyp3[1:6],pch='+',col='black')
lines(I0Hyp2[1:6],I0Hyp3[1:6],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter006_Hyp5Hyp6Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp5[1:6],I1Hyp6[1:6],type="o",
xlab='Tuning Hyper-Param 5',
ylab='Tuning Hyper-Param 6',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp5[1:6],I0Hyp6[1:6],pch='+',col='black')
lines(I0Hyp5[1:6],I0Hyp6[1:6],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter006_Hyp4Hyp5Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp4[1:6],I1Hyp5[1:6],type="o",
xlab='Tuning Hyper-Param 4',
ylab='Tuning Hyper-Param 5',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp4[1:6],I0Hyp5[1:6],pch='+',col='black')
lines(I0Hyp4[1:6],I0Hyp5[1:6],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter006_ExpMSCntsBkgPrefactorScatter_1_2_small.png", height=240, width=240, units="px" )


plot(sqrt(I1ExpMSCnts[1:6]), log10(I1BkgPrefactor[1:6]),type="o",
xlab='Sqrt(Expected MS Counts)',
ylab='Log10(Bkg Pre-Factor)',
pch='+', col='blue',
#main='Data (+)',
xlim=rangeSqrtMSCnts,
ylim=rangeLog10BkgPrefactor,
cex.main=1.4,cex.lab=1.4)
#points(sqrt(I0ExpMSCnts[1:6]),log10(I0BkgPrefactor[1:6]),pch='+',col='black')
lines(sqrt(I0ExpMSCnts[1:6]),log10(I0BkgPrefactor[1:6]),pch='+',col='black',type="o")
dev.off()

## Iteration 7: ########################################################

png("Img04Prelim_Iter007_LogProbTimeTrace_small.png", height=240, width=240, units="px" )

plot(I0Iter[1:7],(I0LogProb[1:7]*log10euler),type="o",
xlab='Iteration',
ylab=' Log10 Post Prob',
ylim=rangeLog10Prob,
pch='.',col="blue",
cex.main=1.4,cex.lab=1.4)
lines(I1Iter[1:7],(I1LogProb[1:7]*log10euler),col="black")

dev.off()


## Next File:
##

png("Img04Prelim_Iter007_Hyp0Hyp1Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp0[1:7],I1Hyp1[1:7],type="o",
xlab='Tuning Hyper-Param 0',
ylab='Tuning Hyper-Param 1',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp0[1:7],I0Hyp1[1:7],pch='+',col='black')
lines(I0Hyp0[1:7],I0Hyp1[1:7],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter007_Hyp2Hyp3Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp2[1:7],I1Hyp3[1:7],type="o",
xlab='Tuning Hyper-Param 2',
ylab='Tuning Hyper-Param 3',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp2[1:7],I0Hyp3[1:7],pch='+',col='black')
lines(I0Hyp2[1:7],I0Hyp3[1:7],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter007_Hyp5Hyp6Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp5[1:7],I1Hyp6[1:7],type="o",
xlab='Tuning Hyper-Param 5',
ylab='Tuning Hyper-Param 6',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp5[1:7],I0Hyp6[1:7],pch='+',col='black')
lines(I0Hyp5[1:7],I0Hyp6[1:7],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter007_Hyp4Hyp5Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp4[1:7],I1Hyp5[1:7],type="o",
xlab='Tuning Hyper-Param 4',
ylab='Tuning Hyper-Param 5',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp4[1:7],I0Hyp5[1:7],pch='+',col='black')
lines(I0Hyp4[1:7],I0Hyp5[1:7],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter007_ExpMSCntsBkgPrefactorScatter_1_2_small.png", height=240, width=240, units="px" )


plot(sqrt(I1ExpMSCnts[1:7]), log10(I1BkgPrefactor[1:7]),type="o",
xlab='Sqrt(Expected MS Counts)',
ylab='Log10(Bkg Pre-Factor)',
pch='+', col='blue',
#main='Data (+)',
xlim=rangeSqrtMSCnts,
ylim=rangeLog10BkgPrefactor,
cex.main=1.4,cex.lab=1.4)
#points(sqrt(I0ExpMSCnts[1:7]),log10(I0BkgPrefactor[1:7]),pch='+',col='black')
lines(sqrt(I0ExpMSCnts[1:7]),log10(I0BkgPrefactor[1:7]),pch='+',col='black',type="o")
dev.off()

## Iteration 8: ########################################################

png("Img04Prelim_Iter008_LogProbTimeTrace_small.png", height=240, width=240, units="px" )

plot(I0Iter[1:8],(I0LogProb[1:8]*log10euler),type="o",
xlab='Iteration',
ylab=' Log10 Post Prob',
ylim=rangeLog10Prob,
pch='.',col="blue",
cex.main=1.4,cex.lab=1.4)
lines(I1Iter[1:8],(I1LogProb[1:8]*log10euler),col="black")

dev.off()


## Next File:
##

png("Img04Prelim_Iter008_Hyp0Hyp1Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp0[1:8],I1Hyp1[1:8],type="o",
xlab='Tuning Hyper-Param 0',
ylab='Tuning Hyper-Param 1',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp0[1:8],I0Hyp1[1:8],pch='+',col='black')
lines(I0Hyp0[1:8],I0Hyp1[1:8],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter008_Hyp2Hyp3Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp2[1:8],I1Hyp3[1:8],type="o",
xlab='Tuning Hyper-Param 2',
ylab='Tuning Hyper-Param 3',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp2[1:8],I0Hyp3[1:8],pch='+',col='black')
lines(I0Hyp2[1:8],I0Hyp3[1:8],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter008_Hyp5Hyp6Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp5[1:8],I1Hyp6[1:8],type="o",
xlab='Tuning Hyper-Param 5',
ylab='Tuning Hyper-Param 6',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp5[1:8],I0Hyp6[1:8],pch='+',col='black')
lines(I0Hyp5[1:8],I0Hyp6[1:8],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter008_Hyp4Hyp5Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp4[1:8],I1Hyp5[1:8],type="o",
xlab='Tuning Hyper-Param 4',
ylab='Tuning Hyper-Param 5',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp4[1:8],I0Hyp5[1:8],pch='+',col='black')
lines(I0Hyp4[1:8],I0Hyp5[1:8],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter008_ExpMSCntsBkgPrefactorScatter_1_2_small.png", height=240, width=240, units="px" )


plot(sqrt(I1ExpMSCnts[1:8]), log10(I1BkgPrefactor[1:8]),type="o",
xlab='Sqrt(Expected MS Counts)',
ylab='Log10(Bkg Pre-Factor)',
pch='+', col='blue',
#main='Data (+)',
xlim=rangeSqrtMSCnts,
ylim=rangeLog10BkgPrefactor,
cex.main=1.4,cex.lab=1.4)
#points(sqrt(I0ExpMSCnts[1:8]),log10(I0BkgPrefactor[1:8]),pch='+',col='black')
lines(sqrt(I0ExpMSCnts[1:8]),log10(I0BkgPrefactor[1:8]),pch='+',col='black',type="o")
dev.off()

## Iteration 9: ########################################################

png("Img04Prelim_Iter009_LogProbTimeTrace_small.png", height=240, width=240, units="px" )

plot(I0Iter[1:9],(I0LogProb[1:9]*log10euler),type="o",
xlab='Iteration',
ylab=' Log10 Post Prob',
ylim=rangeLog10Prob,
pch='.',col="blue",
cex.main=1.4,cex.lab=1.4)
lines(I1Iter[1:9],(I1LogProb[1:9]*log10euler),col="black")

dev.off()


## Next File:
##

png("Img04Prelim_Iter009_Hyp0Hyp1Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp0[1:9],I1Hyp1[1:9],type="o",
xlab='Tuning Hyper-Param 0',
ylab='Tuning Hyper-Param 1',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp0[1:9],I0Hyp1[1:9],pch='+',col='black')
lines(I0Hyp0[1:9],I0Hyp1[1:9],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter009_Hyp2Hyp3Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp2[1:9],I1Hyp3[1:9],type="o",
xlab='Tuning Hyper-Param 2',
ylab='Tuning Hyper-Param 3',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp2[1:9],I0Hyp3[1:9],pch='+',col='black')
lines(I0Hyp2[1:9],I0Hyp3[1:9],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter009_Hyp5Hyp6Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp5[1:9],I1Hyp6[1:9],type="o",
xlab='Tuning Hyper-Param 5',
ylab='Tuning Hyper-Param 6',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp5[1:9],I0Hyp6[1:9],pch='+',col='black')
lines(I0Hyp5[1:9],I0Hyp6[1:9],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter009_Hyp4Hyp5Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp4[1:9],I1Hyp5[1:9],type="o",
xlab='Tuning Hyper-Param 4',
ylab='Tuning Hyper-Param 5',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp4[1:9],I0Hyp5[1:9],pch='+',col='black')
lines(I0Hyp4[1:9],I0Hyp5[1:9],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter009_ExpMSCntsBkgPrefactorScatter_1_2_small.png", height=240, width=240, units="px" )


plot(sqrt(I1ExpMSCnts[1:9]), log10(I1BkgPrefactor[1:9]),type="o",
xlab='Sqrt(Expected MS Counts)',
ylab='Log10(Bkg Pre-Factor)',
pch='+', col='blue',
#main='Data (+)',
xlim=rangeSqrtMSCnts,
ylim=rangeLog10BkgPrefactor,
cex.main=1.4,cex.lab=1.4)
#points(sqrt(I0ExpMSCnts[1:9]),log10(I0BkgPrefactor[1:9]),pch='+',col='black')
lines(sqrt(I0ExpMSCnts[1:9]),log10(I0BkgPrefactor[1:9]),pch='+',col='black',type="o")
dev.off()

## Iteration 10: ########################################################

png("Img04Prelim_Iter010_LogProbTimeTrace_small.png", height=240, width=240, units="px" )

plot(I0Iter[1:10],(I0LogProb[1:10]*log10euler),type="o",
xlab='Iteration',
ylab=' Log10 Post Prob',
ylim=rangeLog10Prob,
pch='.',col="blue",
cex.main=1.4,cex.lab=1.4)
lines(I1Iter[1:10],(I1LogProb[1:10]*log10euler),col="black")

dev.off()


## Next File:
##

png("Img04Prelim_Iter010_Hyp0Hyp1Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp0[1:10],I1Hyp1[1:10],type="o",
xlab='Tuning Hyper-Param 0',
ylab='Tuning Hyper-Param 1',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp0[1:10],I0Hyp1[1:10],pch='+',col='black')
lines(I0Hyp0[1:10],I0Hyp1[1:10],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter010_Hyp2Hyp3Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp2[1:10],I1Hyp3[1:10],type="o",
xlab='Tuning Hyper-Param 2',
ylab='Tuning Hyper-Param 3',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp2[1:10],I0Hyp3[1:10],pch='+',col='black')
lines(I0Hyp2[1:10],I0Hyp3[1:10],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter010_Hyp5Hyp6Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp5[1:10],I1Hyp6[1:10],type="o",
xlab='Tuning Hyper-Param 5',
ylab='Tuning Hyper-Param 6',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp5[1:10],I0Hyp6[1:10],pch='+',col='black')
lines(I0Hyp5[1:10],I0Hyp6[1:10],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter010_Hyp4Hyp5Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp4[1:10],I1Hyp5[1:10],type="o",
xlab='Tuning Hyper-Param 4',
ylab='Tuning Hyper-Param 5',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp4[1:10],I0Hyp5[1:10],pch='+',col='black')
lines(I0Hyp4[1:10],I0Hyp5[1:10],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter010_ExpMSCntsBkgPrefactorScatter_1_2_small.png", height=240, width=240, units="px" )


plot(sqrt(I1ExpMSCnts[1:10]), log10(I1BkgPrefactor[1:10]),type="o",
xlab='Sqrt(Expected MS Counts)',
ylab='Log10(Bkg Pre-Factor)',
pch='+', col='blue',
#main='Data (+)',
xlim=rangeSqrtMSCnts,
ylim=rangeLog10BkgPrefactor,
cex.main=1.4,cex.lab=1.4)
#points(sqrt(I0ExpMSCnts[1:10]),log10(I0BkgPrefactor[1:10]),pch='+',col='black')
lines(sqrt(I0ExpMSCnts[1:10]),log10(I0BkgPrefactor[1:10]),pch='+',col='black',type="o")
dev.off()

#------------------------------------------------------------------------------#

## Iteration 20: ########################################################

png("Img04Prelim_Iter020_LogProbTimeTrace_small.png", height=240, width=240, units="px" )

plot(I0Iter[1:20],(I0LogProb[1:20]*log10euler),type="o",
xlab='Iteration',
ylab=' Log10 Post Prob',
ylim=rangeLog10Prob,
pch='+',col="blue",
cex.main=1.4,cex.lab=1.4)
lines(I1Iter[1:20],(I1LogProb[1:20]*log10euler),pch='+',col="black")

dev.off()


## Next File:
##

png("Img04Prelim_Iter020_Hyp0Hyp1Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp0[1:20],I1Hyp1[1:20],type="o",
xlab='Tuning Hyper-Param 0',
ylab='Tuning Hyper-Param 1',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp0[1:20],I0Hyp1[1:20],pch='+',col='black')
lines(I0Hyp0[1:20],I0Hyp1[1:20],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter020_Hyp2Hyp3Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp2[1:20],I1Hyp3[1:20],type="o",
xlab='Tuning Hyper-Param 2',
ylab='Tuning Hyper-Param 3',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp2[1:20],I0Hyp3[1:20],pch='+',col='black')
lines(I0Hyp2[1:20],I0Hyp3[1:20],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter020_Hyp5Hyp6Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp5[1:20],I1Hyp6[1:20],type="o",
xlab='Tuning Hyper-Param 5',
ylab='Tuning Hyper-Param 6',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp5[1:20],I0Hyp6[1:20],pch='+',col='black')
lines(I0Hyp5[1:20],I0Hyp6[1:20],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter020_Hyp4Hyp5Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp4[1:20],I1Hyp5[1:20],type="o",
xlab='Tuning Hyper-Param 4',
ylab='Tuning Hyper-Param 5',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp4[1:20],I0Hyp5[1:20],pch='+',col='black')
lines(I0Hyp4[1:20],I0Hyp5[1:20],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter020_ExpMSCntsBkgPrefactorScatter_1_2_small.png", height=240, width=240, units="px" )


plot(sqrt(I1ExpMSCnts[1:20]), log10(I1BkgPrefactor[1:20]),type="o",
xlab='Sqrt(Expected MS Counts)',
ylab='Log10(Bkg Pre-Factor)',
pch='+', col='blue',
#main='Data (+)',
xlim=rangeSqrtMSCnts,
ylim=rangeLog10BkgPrefactor,
cex.main=1.4,cex.lab=1.4)
#points(sqrt(I0ExpMSCnts[1:20]),log10(I0BkgPrefactor[1:20]),pch='+',col='black')
lines(sqrt(I0ExpMSCnts[1:20]),log10(I0BkgPrefactor[1:20]),pch='+',col='black',type="o")
dev.off()

## Iteration 25: ########################################################

png("Img04Prelim_Iter025_LogProbTimeTrace_small.png", height=240, width=240, units="px" )

plot(I0Iter[1:25],(I0LogProb[1:25]*log10euler),type="o",
xlab='Iteration',
ylab=' Log10 Post Prob',
ylim=rangeLog10Prob,
pch='+',col="blue",
cex.main=1.4,cex.lab=1.4)
lines(I1Iter[1:25],(I1LogProb[1:25]*log10euler),pch='+',col="black")

dev.off()


## Next File:
##

png("Img04Prelim_Iter025_Hyp0Hyp1Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp0[1:25],I1Hyp1[1:25],type="o",
xlab='Tuning Hyper-Param 0',
ylab='Tuning Hyper-Param 1',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp0[1:25],I0Hyp1[1:25],pch='+',col='black')
lines(I0Hyp0[1:25],I0Hyp1[1:25],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter025_Hyp2Hyp3Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp2[1:25],I1Hyp3[1:25],type="o",
xlab='Tuning Hyper-Param 2',
ylab='Tuning Hyper-Param 3',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp2[1:25],I0Hyp3[1:25],pch='+',col='black')
lines(I0Hyp2[1:25],I0Hyp3[1:25],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter025_Hyp5Hyp6Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp5[1:25],I1Hyp6[1:25],type="o",
xlab='Tuning Hyper-Param 5',
ylab='Tuning Hyper-Param 6',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp5[1:25],I0Hyp6[1:25],pch='+',col='black')
lines(I0Hyp5[1:25],I0Hyp6[1:25],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter025_Hyp4Hyp5Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp4[1:25],I1Hyp5[1:25],type="o",
xlab='Tuning Hyper-Param 5',
ylab='Tuning Hyper-Param 6',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp4[1:25],I0Hyp5[1:25],pch='+',col='black')
lines(I0Hyp4[1:25],I0Hyp5[1:25],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter025_ExpMSCntsBkgPrefactorScatter_1_2_small.png", height=240, width=240, units="px" )


plot(sqrt(I1ExpMSCnts[1:25]), log10(I1BkgPrefactor[1:25]),type="o",
xlab='Sqrt(Expected MS Counts)',
ylab='Log10(Bkg Pre-Factor)',
pch='+', col='blue',
#main='Data (+)',
xlim=rangeSqrtMSCnts,
ylim=rangeLog10BkgPrefactor,
cex.main=1.4,cex.lab=1.4)
#points(sqrt(I0ExpMSCnts[1:25]),log10(I0BkgPrefactor[1:25]),pch='+',col='black')
lines(sqrt(I0ExpMSCnts[1:25]),log10(I0BkgPrefactor[1:25]),pch='+',col='black',type="o")
dev.off()

## Iteration 30: ########################################################

png("Img04Prelim_Iter030_LogProbTimeTrace_small.png", height=240, width=240, units="px" )

plot(I0Iter[1:30],(I0LogProb[1:30]*log10euler),type="o",
xlab='Iteration',
ylab=' Log10 Post Prob',
ylim=rangeLog10Prob,
pch='.',col="blue",
cex.main=1.4,cex.lab=1.4)
lines(I1Iter[1:30],(I1LogProb[1:30]*log10euler),col="black")

dev.off()


## Next File:
##

png("Img04Prelim_Iter030_Hyp0Hyp1Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp0[1:30],I1Hyp1[1:30],type="o",
xlab='Tuning Hyper-Param 0',
ylab='Tuning Hyper-Param 1',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp0[1:30],I0Hyp1[1:30],pch='+',col='black')
lines(I0Hyp0[1:30],I0Hyp1[1:30],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter030_Hyp2Hyp3Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp2[1:30],I1Hyp3[1:30],type="o",
xlab='Tuning Hyper-Param 2',
ylab='Tuning Hyper-Param 3',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp2[1:30],I0Hyp3[1:30],pch='+',col='black')
lines(I0Hyp2[1:30],I0Hyp3[1:30],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter030_Hyp5Hyp6Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp5[1:30],I1Hyp6[1:30],type="o",
xlab='Tuning Hyper-Param 5',
ylab='Tuning Hyper-Param 6',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp5[1:30],I0Hyp6[1:30],pch='+',col='black')
lines(I0Hyp5[1:30],I0Hyp6[1:30],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter030_Hyp4Hyp5Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp4[1:30],I1Hyp5[1:30],type="o",
xlab='Tuning Hyper-Param 4',
ylab='Tuning Hyper-Param 5',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp4[1:30],I0Hyp5[1:30],pch='+',col='black')
lines(I0Hyp4[1:30],I0Hyp5[1:30],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter030_ExpMSCntsBkgPrefactorScatter_1_2_small.png", height=240, width=240, units="px" )


plot(sqrt(I1ExpMSCnts[1:30]), log10(I1BkgPrefactor[1:30]),type="o",
xlab='Sqrt(Expected MS Counts)',
ylab='Log10(Bkg Pre-Factor)',
pch='+', col='blue',
#main='Data (+)',
xlim=rangeSqrtMSCnts,
ylim=rangeLog10BkgPrefactor,
cex.main=1.4,cex.lab=1.4)
#points(sqrt(I0ExpMSCnts[1:30]),log10(I0BkgPrefactor[1:30]),pch='+',col='black')
lines(sqrt(I0ExpMSCnts[1:30]),log10(I0BkgPrefactor[1:30]),pch='+',col='black',type="o")
dev.off()

## Iteration 40: ########################################################

png("Img04Prelim_Iter040_LogProbTimeTrace_small.png", height=240, width=240, units="px" )

plot(I0Iter[1:40],(I0LogProb[1:40]*log10euler),type="o",
xlab='Iteration',
ylab=' Log10 Post Prob',
ylim=rangeLog10Prob,
pch='.',col="blue",
cex.main=1.4,cex.lab=1.4)
lines(I1Iter[1:40],(I1LogProb[1:40]*log10euler),col="black")

dev.off()


## Next File:
##

png("Img04Prelim_Iter040_Hyp0Hyp1Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp0[1:40],I1Hyp1[1:40],type="o",
xlab='Tuning Hyper-Param 0',
ylab='Tuning Hyper-Param 1',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp0[1:40],I0Hyp1[1:40],pch='+',col='black')
lines(I0Hyp0[1:40],I0Hyp1[1:40],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter040_Hyp2Hyp3Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp2[1:40],I1Hyp3[1:40],type="o",
xlab='Tuning Hyper-Param 2',
ylab='Tuning Hyper-Param 3',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp2[1:40],I0Hyp3[1:40],pch='+',col='black')
lines(I0Hyp2[1:40],I0Hyp3[1:40],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter040_Hyp5Hyp6Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp5[1:40],I1Hyp6[1:40],type="o",
xlab='Tuning Hyper-Param 5',
ylab='Tuning Hyper-Param 6',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp5[1:40],I0Hyp6[1:40],pch='+',col='black')
lines(I0Hyp5[1:40],I0Hyp6[1:40],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter040_Hyp4Hyp5Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp4[1:40],I1Hyp5[1:40],type="o",
xlab='Tuning Hyper-Param 4',
ylab='Tuning Hyper-Param 5',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp4[1:40],I0Hyp5[1:40],pch='+',col='black')
lines(I0Hyp4[1:40],I0Hyp5[1:40],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter040_ExpMSCntsBkgPrefactorScatter_1_2_small.png", height=240, width=240, units="px" )


plot(sqrt(I1ExpMSCnts[1:40]), log10(I1BkgPrefactor[1:40]),type="o",
xlab='Sqrt(Expected MS Counts)',
ylab='Log10(Bkg Pre-Factor)',
pch='+', col='blue',
#main='Data (+)',
xlim=rangeSqrtMSCnts,
ylim=rangeLog10BkgPrefactor,
cex.main=1.4,cex.lab=1.4)
#points(sqrt(I0ExpMSCnts[1:40]),log10(I0BkgPrefactor[1:40]),pch='+',col='black')
lines(sqrt(I0ExpMSCnts[1:40]),log10(I0BkgPrefactor[1:40]),pch='+',col='black',type="o")
dev.off()

## Iteration 50: ########################################################

png("Img04Prelim_Iter050_LogProbTimeTrace_small.png", height=240, width=240, units="px" )

plot(I0Iter[1:50],(I0LogProb[1:50]*log10euler),type="o",
xlab='Iteration',
ylab=' Log10 Post Prob',
ylim=rangeLog10Prob,
pch='.',col="blue",
cex.main=1.4,cex.lab=1.4)
lines(I1Iter[1:50],(I1LogProb[1:50]*log10euler),col="black")

dev.off()


## Next File:
##

png("Img04Prelim_Iter050_Hyp0Hyp1Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp0[1:50],I1Hyp1[1:50],type="o",
xlab='Tuning Hyper-Param 0',
ylab='Tuning Hyper-Param 1',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp0[1:50],I0Hyp1[1:50],pch='+',col='black')
lines(I0Hyp0[1:50],I0Hyp1[1:50],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter050_Hyp2Hyp3Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp2[1:50],I1Hyp3[1:50],type="o",
xlab='Tuning Hyper-Param 2',
ylab='Tuning Hyper-Param 3',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp2[1:50],I0Hyp3[1:50],pch='+',col='black')
lines(I0Hyp2[1:50],I0Hyp3[1:50],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter050_Hyp5Hyp6Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp5[1:50],I1Hyp6[1:50],type="o",
xlab='Tuning Hyper-Param 5',
ylab='Tuning Hyper-Param 6',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp5[1:50],I0Hyp6[1:50],pch='+',col='black')
lines(I0Hyp5[1:50],I0Hyp6[1:50],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter050_Hyp4Hyp5Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp4[1:50],I1Hyp5[1:50],type="o",
xlab='Tuning Hyper-Param 4',
ylab='Tuning Hyper-Param 5',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp4[1:50],I0Hyp5[1:50],pch='+',col='black')
lines(I0Hyp4[1:50],I0Hyp5[1:50],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter050_ExpMSCntsBkgPrefactorScatter_1_2_small.png", height=240, width=240, units="px" )


plot(sqrt(I1ExpMSCnts[1:50]), log10(I1BkgPrefactor[1:50]),type="o",
xlab='Sqrt(Expected MS Counts)',
ylab='Log10(Bkg Pre-Factor)',
pch='+', col='blue',
#main='Data (+)',
xlim=rangeSqrtMSCnts,
ylim=rangeLog10BkgPrefactor,
cex.main=1.4,cex.lab=1.4)
#points(sqrt(I0ExpMSCnts[1:50]),log10(I0BkgPrefactor[1:50]),pch='+',col='black')
lines(sqrt(I0ExpMSCnts[1:50]),log10(I0BkgPrefactor[1:50]),pch='+',col='black',type="o")
dev.off()

## Iteration 60: ########################################################

png("Img04Prelim_Iter060_LogProbTimeTrace_small.png", height=240, width=240, units="px" )

plot(I0Iter[1:60],(I0LogProb[1:60]*log10euler),type="o",
xlab='Iteration',
ylab=' Log10 Post Prob',
ylim=rangeLog10Prob,
pch='.',col="blue",
cex.main=1.4,cex.lab=1.4)
lines(I1Iter[1:60],(I1LogProb[1:60]*log10euler),col="black")

dev.off()


## Next File:
##

png("Img04Prelim_Iter060_Hyp0Hyp1Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp0[1:60],I1Hyp1[1:60],type="o",
xlab='Tuning Hyper-Param 0',
ylab='Tuning Hyper-Param 1',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp0[1:60],I0Hyp1[1:60],pch='+',col='black')
lines(I0Hyp0[1:60],I0Hyp1[1:60],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter060_Hyp2Hyp3Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp2[1:60],I1Hyp3[1:60],type="o",
xlab='Tuning Hyper-Param 2',
ylab='Tuning Hyper-Param 3',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp2[1:60],I0Hyp3[1:60],pch='+',col='black')
lines(I0Hyp2[1:60],I0Hyp3[1:60],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter060_Hyp5yp6Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp5[1:60],I1Hyp6[1:60],type="o",
xlab='Tuning Hyper-Param 5',
ylab='Tuning Hyper-Param 6',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp5[1:60],I0Hy65[1:60],pch='+',col='black')
lines(I0Hyp5[1:60],I0Hyp6[1:60],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter060_Hyp5yp6Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp4[1:60],I1Hyp5[1:60],type="o",
xlab='Tuning Hyper-Param 4',
ylab='Tuning Hyper-Param 5',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp4[1:60],I0Hyp5[1:60],pch='+',col='black')
lines(I0Hyp4[1:60],I0Hyp5[1:60],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter060_ExpMSCntsBkgPrefactorScatter_1_2_small.png", height=240, width=240, units="px" )


plot(sqrt(I1ExpMSCnts[1:60]), log10(I1BkgPrefactor[1:60]),type="o",
xlab='Sqrt(Expected MS Counts)',
ylab='Log10(Bkg Pre-Factor)',
pch='+', col='blue',
#main='Data (+)',
xlim=rangeSqrtMSCnts,
ylim=rangeLog10BkgPrefactor,
cex.main=1.4,cex.lab=1.4)
#points(sqrt(I0ExpMSCnts[1:60]),log10(I0BkgPrefactor[1:60]),pch='+',col='black')
lines(sqrt(I0ExpMSCnts[1:60]),log10(I0BkgPrefactor[1:60]),pch='+',col='black',type="o")
dev.off()

## Iteration 70: ########################################################

png("Img04Prelim_Iter070_LogProbTimeTrace_small.png", height=240, width=240, units="px" )

plot(I0Iter[1:70],(I0LogProb[1:70]*log10euler),type="o",
xlab='Iteration',
ylab=' Log10 Post Prob',
ylim=rangeLog10Prob,
pch='.',col="blue",
cex.main=1.4,cex.lab=1.4)
lines(I1Iter[1:70],(I1LogProb[1:70]*log10euler),col="black")

dev.off()


## Next File:
##

png("Img04Prelim_Iter070_Hyp0Hyp1Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp0[1:70],I1Hyp1[1:70],type="o",
xlab='Tuning Hyper-Param 0',
ylab='Tuning Hyper-Param 1',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp0[1:70],I0Hyp1[1:70],pch='+',col='black')
lines(I0Hyp0[1:70],I0Hyp1[1:70],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter070_Hyp2Hyp3Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp2[1:70],I1Hyp3[1:70],type="o",
xlab='Tuning Hyper-Param 2',
ylab='Tuning Hyper-Param 3',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp2[1:70],I0Hyp3[1:70],pch='+',col='black')
lines(I0Hyp2[1:70],I0Hyp3[1:70],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter070_Hyp5Hyp6Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp5[1:70],I1Hyp6[1:70],type="o",
xlab='Tuning Hyper-Param 5',
ylab='Tuning Hyper-Param 6',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp5[1:70],I0Hyp6[1:70],pch='+',col='black')
lines(I0Hyp5[1:70],I0Hyp6[1:70],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter070_Hyp4Hyp5Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp4[1:70],I1Hyp5[1:70],type="o",
xlab='Tuning Hyper-Param 4',
ylab='Tuning Hyper-Param 5',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp4[1:70],I0Hyp5[1:70],pch='+',col='black')
lines(I0Hyp4[1:70],I0Hyp5[1:70],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter070_ExpMSCntsBkgPrefactorScatter_1_2_small.png", height=240, width=240, units="px" )


plot(sqrt(I1ExpMSCnts[1:70]), log10(I1BkgPrefactor[1:70]),type="o",
xlab='Sqrt(Expected MS Counts)',
ylab='Log10(Bkg Pre-Factor)',
pch='+', col='blue',
#main='Data (+)',
xlim=rangeSqrtMSCnts,
ylim=rangeLog10BkgPrefactor,
cex.main=1.4,cex.lab=1.4)
#points(sqrt(I0ExpMSCnts[1:70]),log10(I0BkgPrefactor[1:70]),pch='+',col='black')
lines(sqrt(I0ExpMSCnts[1:70]),log10(I0BkgPrefactor[1:70]),pch='+',col='black',type="o")
dev.off()

## Iteration 80: ########################################################

png("Img04Prelim_Iter080_LogProbTimeTrace_small.png", height=240, width=240, units="px" )

plot(I0Iter[1:80],(I0LogProb[1:80]*log10euler),type="o",
xlab='Iteration',
ylab=' Log10 Post Prob',
ylim=rangeLog10Prob,
pch='.',col="blue",
cex.main=1.4,cex.lab=1.4)
lines(I1Iter[1:80],(I1LogProb[1:80]*log10euler),col="black")

dev.off()


## Next File:
##

png("Img04Prelim_Iter080_Hyp0Hyp1Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp0[1:80],I1Hyp1[1:80],type="o",
xlab='Tuning Hyper-Param 0',
ylab='Tuning Hyper-Param 1',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp0[1:80],I0Hyp1[1:80],pch='+',col='black')
lines(I0Hyp0[1:80],I0Hyp1[1:80],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter080_Hyp2Hyp3Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp2[1:80],I1Hyp3[1:80],type="o",
xlab='Tuning Hyper-Param 2',
ylab='Tuning Hyper-Param 3',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp2[1:80],I0Hyp3[1:80],pch='+',col='black')
lines(I0Hyp2[1:80],I0Hyp3[1:80],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter080_Hyp5Hyp6Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp5[1:80],I1Hyp6[1:80],type="o",
xlab='Tuning Hyper-Param 5',
ylab='Tuning Hyper-Param 6',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp5[1:80],I0Hyp6[1:80],pch='+',col='black')
lines(I0Hyp5[1:80],I0Hyp6[1:80],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter080_Hyp4Hyp5Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp4[1:80],I1Hyp5[1:80],type="o",
xlab='Tuning Hyper-Param 4',
ylab='Tuning Hyper-Param 5',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp4[1:80],I0Hyp5[1:80],pch='+',col='black')
lines(I0Hyp4[1:80],I0Hyp5[1:80],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter080_ExpMSCntsBkgPrefactorScatter_1_2_small.png", height=240, width=240, units="px" )


plot(sqrt(I1ExpMSCnts[1:80]), log10(I1BkgPrefactor[1:80]),type="o",
xlab='Sqrt(Expected MS Counts)',
ylab='Log10(Bkg Pre-Factor)',
pch='+', col='blue',
#main='Data (+)',
xlim=rangeSqrtMSCnts,
ylim=rangeLog10BkgPrefactor,
cex.main=1.4,cex.lab=1.4)
#points(sqrt(I0ExpMSCnts[1:80]),log10(I0BkgPrefactor[1:80]),pch='+',col='black')
lines(sqrt(I0ExpMSCnts[1:80]),log10(I0BkgPrefactor[1:80]),pch='+',col='black',type="o")
dev.off()

## Iteration 90: ########################################################

png("Img04Prelim_Iter090_LogProbTimeTrace_small.png", height=240, width=240, units="px" )

plot(I0Iter[1:90],(I0LogProb[1:90]*log10euler),type="o",
xlab='Iteration',
ylab=' Log10 Post Prob',
ylim=rangeLog10Prob,
pch='.',col="blue",
cex.main=1.4,cex.lab=1.4)
lines(I1Iter[1:90],(I1LogProb[1:90]*log10euler),col="black")

dev.off()


## Next File:
##

png("Img04Prelim_Iter090_Hyp0Hyp1Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp0[1:90],I1Hyp1[1:90],type="o",
xlab='Tuning Hyper-Param 0',
ylab='Tuning Hyper-Param 1',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp0[1:90],I0Hyp1[1:90],pch='+',col='black')
lines(I0Hyp0[1:90],I0Hyp1[1:90],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter090_Hyp2Hyp3Scatter_1_2_small.png", height=240, width=240, units="px" )

plot(I1Hyp2[1:90],I1Hyp3[1:90],type="o",
xlab='Tuning Hyper-Param 2',
ylab='Tuning Hyper-Param 3',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp2[1:90],I0Hyp3[1:90],pch='+',col='black')
lines(I0Hyp2[1:90],I0Hyp3[1:90],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter090_Hyp5Hyp6Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp5[1:90],I1Hyp6[1:90],type="o",
xlab='Tuning Hyper-Param 5',
ylab='Tuning Hyper-Param 6',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp5[1:90],I0Hyp6[1:90],pch='+',col='black')
lines(I0Hyp5[1:90],I0Hyp6[1:90],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter090_Hyp4Hyp5Scatter_1_2_small.png", height=240, width=240, units="px" )


plot(I1Hyp4[1:90],I1Hyp5[1:90],type="o",
xlab='Tuning Hyper-Param 4',
ylab='Tuning Hyper-Param 5',
xlim=xrangeImg, ylim=yrangeImg,
pch='+', col='blue',
#main='Data (+)',
cex.main=1.4,cex.lab=1.4)
#points(I0Hyp4[1:90],I0Hyp5[1:90],pch='+',col='black')
lines(I0Hyp4[1:90],I0Hyp5[1:90],pch='+',col='black',type="o")
dev.off()

## Next File:
##

png("Img04Prelim_Iter090_ExpMSCntsBkgPrefactorScatter_1_2_small.png", height=240, width=240, units="px" )


plot(sqrt(I1ExpMSCnts[1:90]), log10(I1BkgPrefactor[1:90]),type="o",
xlab='Sqrt(Expected MS Counts)',
ylab='Log10(Bkg Pre-Factor)',
pch='+', col='blue',
#main='Data (+)',
xlim=rangeSqrtMSCnts,
ylim=rangeLog10BkgPrefactor,
cex.main=1.4,cex.lab=1.4)
#points(sqrt(I0ExpMSCnts[1:90]),log10(I0BkgPrefactor[1:90]),pch='+',col='black')
lines(sqrt(I0ExpMSCnts[1:90]),log10(I0BkgPrefactor[1:90]),pch='+',col='black',type="o")
dev.off()

## Iteration 100: ########################################################

png("Img04Prelim_Iter100_LogProbTimeTrace_small.png", height=240, width=240, units="px" )

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

png("Img04Prelim_Iter100_Hyp0Hyp1Scatter_1_2_small.png", height=240, width=240, units="px" )

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

png("Img04Prelim_Iter100_Hyp2Hyp3Scatter_1_2_small.png", height=240, width=240, units="px" )

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

png("Img04Prelim_Iter100_Hyp5Hyp6Scatter_1_2_small.png", height=240, width=240, units="px" )


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

png("Img04Prelim_Iter100_Hyp4Hyp5Scatter_1_2_small.png", height=240, width=240, units="px" )


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

png("Img04Prelim_Iter100_ExpMSCntsBkgPrefactorScatter_1_2_small.png", height=240, width=240, units="px" )


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

png("Img04Prelim_Iter125_LogProbTimeTrace_small.png", height=240, width=240, units="px" )

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

png("Img04Prelim_Iter125_Hyp0Hyp1Scatter_1_2_small.png", height=240, width=240, units="px" )

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

png("Img04Prelim_Iter125_Hyp2Hyp3Scatter_1_2_small.png", height=240, width=240, units="px" )

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

png("Img04Prelim_Iter125_Hyp5Hyp6Scatter_1_2_small.png", height=240, width=240, units="px" )


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

png("Img04Prelim_Iter125_Hyp4Hyp5Scatter_1_2_small.png", height=240, width=240, units="px" )


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

png("Img04Prelim_Iter125_ExpMSCntsBkgPrefactorScatter_1_2_small.png", height=240, width=240, units="px" )


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


