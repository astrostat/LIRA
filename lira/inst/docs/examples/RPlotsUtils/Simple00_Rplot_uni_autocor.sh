
r --vanilla <<EOF >  sample_Rplot_uni_autocor.100714a.log
##
#####    Making and pdf files of the specified data
##


infileAutoCorPar = 'PoisDatons32x32EEMC2_NoBckgrnd.autocor'


AutoCorPar <- read.table(infileAutoCorPar, header = TRUE, sep = "", quote = "\"'",
           na.strings = "NA", colClasses = NA, nrows = -1,
           skip = 0, check.names = TRUE,
           comment.char = "#",
           allowEscapes = FALSE, flush = FALSE,
           encoding = "unknown")

AutocorIter <- AutoCorPar[[1]]
AutocorLogProb <- AutoCorPar[[2]]
AutocorProbStep <- AutoCorPar[[3]]
AutocorSpinRow <- AutoCorPar[[4]]
AutocorSpinCol <- AutoCorPar[[5]]
AutocorHyp0 <- AutoCorPar[[6]]
AutocorHyp1 <- AutoCorPar[[7]]
AutocorHyp2 <- AutoCorPar[[8]]
AutocorHyp3 <- AutoCorPar[[9]]
AutocorHyp4 <- AutoCorPar[[10]]
AutocorExpMSCnts <- AutoCorPar[[11]]


atitle = infileAutoCorPar
xrangeAutocor <- numeric(2)
xrangeAutocor[1] = 0.
xrangeAutocor[2] = 50.



## Each trace or 'time-series' (statistics jargon) plot
##

## For some reason python numpy correlate gets inf and nana for this
## so, skipping:
#pdf("Simple00AutocorLogProb.pdf", height=4.3, width=4.3 )
#
#log10euler = log10(exp(1.000000000000))
#
#plot((AutocorLogProb*log10euler),type="o",
#xlab='Iteration Number',
#ylab='Autocor of Log10 Post Prob',
#xlim=xrangeAutocor,
#pch='.',
#cex.main=1.0,cex.lab=1.4)
#
#dev.off()

## Next File:
##

png("Simple00AutocorSpinCol.png", height=320, width=320, units="px" )

plot(AutocorSpinCol,type="o",
xlab='Iteration Number',
ylab='Autocor of Cycle-Spin Column',
xlim=xrangeAutocor,
pch='.',
main=atitle,
cex.main=1.0,cex.lab=1.4)


dev.off()

## Next File:
##

png("Simple00AutocorSpinRow.png", height=320, width=320, units="px" )

plot(AutocorSpinRow,type="o",
xlab='Iteration Number',
ylab='Autocor of Cycle-Spin Row',
xlim=xrangeAutocor,
pch='.',
main=atitle,
cex.main=1.0,cex.lab=1.4)


dev.off()

## Next File:
##

png("Simple00AutocorHyp0.png", height=320, width=320, units="px" )

plot(AutocorHyp0,type="o",
xlab='Iteration Number',
ylab='Autocor of Hyper-Param 0',
xlim=xrangeAutocor,
pch='.',
main=atitle,
cex.main=1.0,cex.lab=1.4)


dev.off()

## Next File:
##

png("Simple00AutocorHyp1.png", height=320, width=320, units="px" )

plot(AutocorHyp1,type="o",
xlab='Iteration Number',
ylab='Autocor of Hyper-Param 1',
xlim=xrangeAutocor,
pch='.',
main=atitle,
cex.main=1.0,cex.lab=1.4)


dev.off()

## Next File:
##

png("Simple00AutocorHyp2.png", height=320, width=320, units="px" )

plot(AutocorHyp2,type="o",
xlab='Iteration Number',
ylab='Autocor of Hyper-Param 2',
xlim=xrangeAutocor,
pch='.',
main=atitle,
cex.main=1.0,cex.lab=1.4)


dev.off()

## Next File:
##

png("Simple00AutocorHyp3.png", height=320, width=320, units="px" )


plot(AutocorHyp3,type="o",
xlab='Iteration Number',
ylab='Autocor of Hyper-Param 3',
xlim=xrangeAutocor,
pch='.',
main=atitle,
cex.main=1.0,cex.lab=1.4)


dev.off()

## Next File:
##

png("Simple00AutocorHyp4.png", height=320, width=320, units="px" )

plot(AutocorHyp4,type="o",
xlab='Iteration Number',
ylab='Autocor of Hyper-Param 4',
xlim=xrangeAutocor,
pch='.',
main=atitle,
cex.main=1.0,cex.lab=1.4)

dev.off()

## Next File:
##

png("Simple00AutocorMSCnts.png", height=320, width=320, units="px" )

plot(AutocorExpMSCnts,type="o",
xlab='Iteration Number',
ylab='AutoCor of MS Counts',
xlim=xrangeAutocor,
pch='.',
main=atitle,
cex.main=1.0,cex.lab=1.4)

dev.off()
