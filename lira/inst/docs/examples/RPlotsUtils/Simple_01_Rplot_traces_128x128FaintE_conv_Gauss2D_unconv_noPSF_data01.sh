
r --vanilla <<EOF >  sample_run_Rplot_Param_traces.100714b.log
##
#####    Making and pdf files of the specified data
##


infileImgDat1 = '../Routputs/Simple_01_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter2000_thin1_Strt.0.02_viaFits.par'

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
I1BkgScale <- ImgDat1[[14]]


infileImgDat2 = '../Routputs/Simple_01_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter2000_thin1_Strt.02.0_viaFits.par'

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
I2BkgScale <- ImgDat2[[14]]


infileImgDat3 = '../Routputs/Simple_01_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter2000_thin1_Strt.obs_viaFits.par'

ImgDat3 <- read.table(infileImgDat3, header = TRUE, sep = "", quote = "\"'",
           na.strings = "NA", colClasses = NA, nrows = -1,
           skip = 0, check.names = TRUE,
           comment.char = "#",
           allowEscapes = FALSE, flush = FALSE,
           encoding = "unknown")

I3Iter <- ImgDat3[[1]]
I3LogProb <- ImgDat3[[2]]
I3ProbStep <- ImgDat3[[3]]
I3SpinRow <- ImgDat3[[4]]
I3SpinCol <- ImgDat3[[5]]
I3Hyp0 <- ImgDat3[[6]]
I3Hyp1 <- ImgDat3[[7]]
I3Hyp2 <- ImgDat3[[8]]
I3Hyp3 <- ImgDat3[[9]]
I3Hyp4 <- ImgDat3[[10]]
I3Hyp5 <- ImgDat3[[11]]
I3Hyp6 <- ImgDat3[[12]]
I3ExpMSCnts <- ImgDat3[[13]]
I3BkgScale <- ImgDat3[[14]]


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
rangeLog10Prob[1] = -12000.
rangeLog10Prob[2] =  -8000.

iterrange <- numeric(2)
iterrange[1] = 0
iterrange[2] = 350

## Each trace or 'time-series' (statistics jargon) plot
## 

## Next File: NOTICE THIS ONE IS OVER-PLOTTED:# 

png("Img_01_LogProbTimeTrace_1_2_3.png", height=320, width=320, units="px" )

log10euler = log10(exp(1.000000000000))

plot((I1LogProb*log10euler),type="o",
xlim=iterrange,
xlab='Iteration Number',
ylab=' Log10 Post Prob',
ylim=rangeLog10Prob,
pch='.',col="orange",
cex.main=1.4,cex.lab=1.4)
lines((I2LogProb*log10euler),col="purple")
lines((I3LogProb*log10euler),col="green")

dev.off()

## Next File:
##

png("Img_01_Hyp0TimeTrace_1_2_3.png", height=320, width=320, units="px" )

plot(I1Hyp0,type="o",
xlim=iterrange,
ylim=yrangeImg,
xlab='Iteration Number',
ylab='Smoothing Hyper-Param 0',
pch='.',col="orange",
cex.main=1.4,cex.lab=1.4)
lines(I2Hyp0,col="purple")
lines(I3Hyp0,col="green")


dev.off()


## Next File:
##

png("Img_01_Hyp1TimeTrace_1_2_3.png", height=320, width=320, units="px" )

plot(I1Hyp1,type="o",
xlim=iterrange,
ylim=yrangeImg,
xlab='Iteration Number',
ylab='Smoothing Hyper-Param 0',
pch='.',col="orange",
cex.main=1.4,cex.lab=1.4)
lines(I2Hyp1,col="purple")
lines(I3Hyp1,col="green")


dev.off()


## Next File:
##

png("Img_01_Hyp2TimeTrace_1_2_3.png", height=320, width=320, units="px" )

plot(I1Hyp2,type="o",
xlim=iterrange,
xlab='Iteration Number',
ylab='Smoothing Hyper-Param 0',
pch='.',col="orange",
cex.main=1.4,cex.lab=1.4)
lines(I2Hyp2,col="purple")
lines(I3Hyp2,col="green")


dev.off()


## Next File:
##

png("Img_01_Hyp3TimeTrace_1_2_3.png", height=320, width=320, units="px" )

plot(I1Hyp3,type="o",
xlim=iterrange,
ylim=yrangeImg,
xlab='Iteration Number',
ylab='Smoothing Hyper-Param 0',
pch='.',col="orange",
cex.main=1.4,cex.lab=1.4)
lines(I2Hyp3,col="purple")
lines(I3Hyp3,col="green")


dev.off()


## Next File:
##

png("Img_01_Hyp4TimeTrace_1_2_3.png", height=320, width=320, units="px" )

plot(I1Hyp4,type="o",
xlim=iterrange,
ylim=yrangeImg,
xlab='Iteration Number',
ylab='Smoothing Hyper-Param 0',
pch='.',col="orange",
cex.main=1.4,cex.lab=1.4)
lines(I2Hyp4,col="purple")
lines(I3Hyp4,col="green")


dev.off()


## Next File:
##

png("Img_01_Hyp5TimeTrace_1_2_3.png", height=320, width=320, units="px" )

plot(I1Hyp5,type="o",
xlim=iterrange,
ylim=yrangeImg,
xlab='Iteration Number',
ylab='Smoothing Hyper-Param 0',
pch='.',col="orange",
cex.main=1.4,cex.lab=1.4)
lines(I2Hyp5,col="purple")
lines(I3Hyp5,col="green")


dev.off()


##

png("Img_01_MSCntsTimeTrace_1_2_3.png", height=320, width=320, units="px" )

plot(log10(I1ExpMSCnts),type="o",
xlim=iterrange,
xlab='Iteration Number',
ylab='Log10(Expected MS Counts)',
main='Data (.)',
pch='.',col="orange",
cex.main=1.4,cex.lab=1.4)
lines(log10(I2ExpMSCnts),col="purple")
lines(log10(I3ExpMSCnts),col="green")
dev.off()

##

png("Img_01_BkgScaleTimeTrace_1_2_3.png", height=320, width=320, units="px" )

plot(log10(I1BkgScale),type="o",
xlim=iterrange,
xlab='Iteration Number',
ylab='Log10(BkgScale)',
main='Data (.)',
pch='.',col="orange",
cex.main=1.4,cex.lab=1.4)
lines(log10(I2BkgScale),col="purple")
lines(log10(I3BkgScale),col="green")
dev.off()
