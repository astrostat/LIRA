
r --vanilla <<EOF >>  sample_run_Rplot_Param_scatterplots.100616b.log
##
#####    Making and png files of the specified data
##

##
## In this example, assuming size=32 = 2^7, so 7 scale params.

infileImgDat0 = '../outputs/Simple04_Gauss2d1.5_PoisDatons128x128testEvsNull_Strt0.01_viaFits.param'

## In reading in, skip=40 assumes:                                  ####
## 28 header lines, 1 labels line, burn-in taken care of by comment char=#:   ####

ImgDat0 <- read.table(infileImgDat0, header = TRUE, sep = "", quote = "\"'",
           na.strings = "NA", colClasses = NA, nrows = -1,
           skip = 0, check.names = TRUE,
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

#### Reading in results on Simulated Null Datons:

infileImgNul0 = '../outputs/Simple04_Gauss2dSig1.5_17x17PSF_SimPois0to5_128x128testEvsNullModel.param'


ImgNul0 <- read.table(infileImgNul0, header = TRUE, sep = "", quote = "\"'",
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

##############################################################


##############################################################
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

## Next File:
##

png("Img04ExpMSCnts_HistScatter_AllDatvsNull_small.png", height=240, width=240, units="px" )


hist(sqrt(I0ExpMSCnts),
xlab='Sqrt(Expected MS Counts)',
ylab='Prob Density',
main='Data(dark blue), Null(pink) ',
plot=TRUE, breaks=20,
freq=FALSE, col='darkblue',border='darkblue',
xlim=rangeSqrtMSCnts,
cex.main=1.4,cex.lab=1.4)
hist(sqrt(N0ExpMSCnts),
plot=TRUE, breaks=100,
freq=FALSE, col='magenta',border='magenta',add=TRUE )
dev.off()

