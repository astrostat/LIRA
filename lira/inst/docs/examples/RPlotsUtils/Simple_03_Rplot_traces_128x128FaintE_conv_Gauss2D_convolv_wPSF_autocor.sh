
r --vanilla <<EOF >  sample_Rplot_uni_autocor.100714a.log
##
#####    Making and pdf files of the specified data
##


infileAutoCor1Par = '../PostProcessedFiles/Simple_03e_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter1500_thin1_Strt.obs_viaFits.autocor'
infileAutoCor2Par = '../PostProcessedFiles/Simple_03e_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter1500_thin1_Strt.0.02_viaFits.autocor'
infileAutoCor3Par = '../PostProcessedFiles/Simple_03e_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter1500_thin1_Strt.02.0_viaFits.autocor'


AutoCor1Par <- read.table(infileAutoCor1Par, header = TRUE, sep = "", quote = "\"'",
           na.strings = "NA", colClasses = NA, nrows = -1,
           skip = 0, check.names = TRUE,
           comment.char = "#",
           allowEscapes = FALSE, flush = FALSE,
           encoding = "unknown")


AutoCor2Par <- read.table(infileAutoCor2Par, header = TRUE, sep = "", quote = "\"'",
           na.strings = "NA", colClasses = NA, nrows = -1,
           skip = 0, check.names = TRUE,
           comment.char = "#",
           allowEscapes = FALSE, flush = FALSE,
           encoding = "unknown")

AutoCor3Par <- read.table(infileAutoCor3Par, header = TRUE, sep = "", quote = "\"'",
           na.strings = "NA", colClasses = NA, nrows = -1,
           skip = 0, check.names = TRUE,
           comment.char = "#",
           allowEscapes = FALSE, flush = FALSE,
           encoding = "unknown")

Autocor1Iter <- AutoCor1Par[[1]]
Autocor1LogProb <- AutoCor1Par[[2]]
Autocor1ProbStep <- AutoCor1Par[[3]]
Autocor1SpinRow <- AutoCor1Par[[4]]
Autocor1SpinCol <- AutoCor1Par[[5]]
Autocor1Hyp0 <- AutoCor1Par[[6]]
Autocor1Hyp1 <- AutoCor1Par[[7]]
Autocor1Hyp2 <- AutoCor1Par[[8]]
Autocor1Hyp3 <- AutoCor1Par[[9]]
Autocor1Hyp4 <- AutoCor1Par[[10]]
Autocor1ExpMSCnts <- AutoCor1Par[[11]]
Autocor1BkgPrefactor <- AutoCor1Par[[12]]

Autocor2Iter <- AutoCor2Par[[1]]
Autocor2LogProb <- AutoCor2Par[[2]]
Autocor2ProbStep <- AutoCor2Par[[3]]
Autocor2SpinRow <- AutoCor2Par[[4]]
Autocor2SpinCol <- AutoCor2Par[[5]]
Autocor2Hyp0 <- AutoCor2Par[[6]]
Autocor2Hyp1 <- AutoCor2Par[[7]]
Autocor2Hyp2 <- AutoCor2Par[[8]]
Autocor2Hyp3 <- AutoCor2Par[[9]]
Autocor2Hyp4 <- AutoCor2Par[[10]]
Autocor2ExpMSCnts <- AutoCor2Par[[11]]
Autocor2BkgPrefactor <- AutoCor2Par[[12]]


Autocor3Iter <- AutoCor3Par[[1]]
Autocor3LogProb <- AutoCor3Par[[2]]
Autocor3ProbStep <- AutoCor3Par[[3]]
Autocor3SpinRow <- AutoCor3Par[[4]]
Autocor3SpinCol <- AutoCor3Par[[5]]
Autocor3Hyp0 <- AutoCor3Par[[6]]
Autocor3Hyp1 <- AutoCor3Par[[7]]
Autocor3Hyp2 <- AutoCor3Par[[8]]
Autocor3Hyp3 <- AutoCor3Par[[9]]
Autocor3Hyp4 <- AutoCor3Par[[10]]
Autocor3ExpMSCnts <- AutoCor3Par[[11]]
Autocor3BkgPrefactor <- AutoCor3Par[[12]]


atitle = infileAutoCor1Par
xrangeAutocor1 <- numeric(2)
xrangeAutocor1[1] = 0.
xrangeAutocor1[2] = 100.



## Each trace or 'time-series' (statistics jargon) plot
##

## For some reason python numpy correlate gets inf and nana for this
## so, skipping:
#pdf("Simple_03e_PrelimAutocor_0_1_2_LogProb.pdf", height=4.3, width=4.3 )
#
#log10euler = log10(exp(1.000000000000))
#
#plot((Autocor1LogProb*log10euler),type="o",
#xlab='Iteration Number',
#ylab='Autocor of Log10 Post Prob',
#xlim=xrangeAutocor1,
#pch='.',col='purple',
#cex.main=1.0,cex.lab=1.4)
#lines((Autocor2LogProb*log10euler),col='green')
#
#dev.off()

## Next File:
##

png("Simple_03e_PrelimAutocor_0_1_2_SpinCol.png", height=320, width=320, units="px" )

plot(Autocor1SpinCol,type="o",
xlab='Iteration Number',
ylab='Autocor of Cycle-Spin Column',
xlim=xrangeAutocor1,
pch='.',,col='purple',
main=atitle,
cex.main=1.0,cex.lab=1.4)
lines(Autocor2SpinCol,col='green')
lines(Autocor3SpinCol,col='orange')

dev.off()

## Next File:
##

png("Simple_03e_PrelimAutocor_0_1_2_SpinRow.png", height=320, width=320, units="px" )

plot(Autocor1SpinRow,type="o",
xlab='Iteration Number',
ylab='Autocor of Cycle-Spin Row',
xlim=xrangeAutocor1,
pch='.',col='purple',
main=atitle,
cex.main=1.0,cex.lab=1.4)
lines(Autocor2SpinRow,col='green')
lines(Autocor3SpinRow,col='orange')


dev.off()

## Next File:
##

png("Simple_03e_PrelimAutocor_0_1_2_Hyp0.png", height=320, width=320, units="px" )

plot(Autocor1Hyp0,type="o",
xlab='Iteration Number',
ylab='Autocor1 of Hyper-Param 0',
xlim=xrangeAutocor1,
pch='.',col='purple',
main=atitle,
cex.main=1.0,cex.lab=1.4)
lines(Autocor2Hyp0,col='green')
lines(Autocor3Hyp0,col='orange')

dev.off()

## Next File:
##

png("Simple_03e_PrelimAutocor_0_1_2_Hyp1.png", height=320, width=320, units="px" )

plot(Autocor1Hyp1,type="o",
xlab='Iteration Number',
ylab='Autocor of Hyper-Param 1',
xlim=xrangeAutocor1,
pch='.',col='purple',
main=atitle,
cex.main=1.0,cex.lab=1.4)
lines(Autocor2Hyp1,col='green')
lines(Autocor3Hyp1,col='orange')

dev.off()

## Next File:
##

png("Simple_03e_PrelimAutocor_0_1_2_Hyp2.png", height=320, width=320, units="px" )

plot(Autocor1Hyp2,type="o",
xlab='Iteration Number',
ylab='Autocor of Hyper-Param 2',
xlim=xrangeAutocor1,
pch='.',col='purple',
main=atitle,
cex.main=1.0,cex.lab=1.4)
lines(Autocor2Hyp2,col='green')
lines(Autocor3Hyp2,col='orange')

dev.off()

## Next File:
##

png("Simple_03e_PrelimAutocor_0_1_2_Hyp3.png", height=320, width=320, units="px" )


plot(Autocor1Hyp3,type="o",
xlab='Iteration Number',
ylab='Autocor of Hyper-Param 3',
xlim=xrangeAutocor1,
pch='.',col='purple',
main=atitle,
cex.main=1.0,cex.lab=1.4)
lines(Autocor2Hyp3,col='green')
lines(Autocor3Hyp3,col='orange')

dev.off()

## Next File:
##

png("Simple_03e_PrelimAutocor_0_1_2_Hyp4.png", height=320, width=320, units="px" )

plot(Autocor1Hyp4,type="o",
xlab='Iteration Number',
ylab='Autocor of Hyper-Param 4',
xlim=xrangeAutocor1,
pch='.',col='purple',
main=atitle,
cex.main=1.0,cex.lab=1.4)
lines(Autocor2Hyp4,col='green')
lines(Autocor3Hyp4,col='orange')
dev.off()

## Next File:
##

png("Simple_03e_PrelimAutocor_0_1_2_MSCnts.png", height=320, width=320, units="px" )

plot(Autocor1ExpMSCnts,type="o",
xlab='Iteration Number',
ylab='AutoCor of MS Counts',
xlim=xrangeAutocor1,
pch='.',col='purple',
main=atitle,
cex.main=1.0,cex.lab=1.4)
lines(Autocor2ExpMSCnts,col='green')
lines(Autocor3ExpMSCnts,col='orange')

dev.off()

## Next File:
##

png("Simple_03e_PrelimAutocor_0_1_2_BkgPrefactor.png", height=320, width=320, units="px" )

plot(Autocor1BkgPrefactor,type="o",
xlab='Iteration Number',
ylab='AutoCor of BkgPrefactor',
xlim=xrangeAutocor1,
pch='.',col='purple',
main=atitle,
cex.main=1.0,cex.lab=1.4)
lines(Autocor2BkgPrefactor,col='green')
lines(Autocor3BkgPrefactor,col='orange')

dev.off()
