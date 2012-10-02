## This worksm but is V-E-R-Y S-L-O-W!!!
## Probably because of the loop that transposes the input matrix
## in order to get a right-side-up set of image.
## For this, python with numpy is faster.
#########################################################################

r --vanilla --no-restore <<EOF > Simple_04_RUtil_AsciiRoutToFitsImageMovies.log2

require(FITSio)

infiles <- character(1)

#infiles[1] = "/Code/AstroCode/MultiScaleImaging_2009/FaintDiffESimAnalysis/RunOutputs/Simple_04_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter60000_thin20_Strt.obs_viaFits.out"
#infiles[2] = "/Code/AstroCode/MultiScaleImaging_2009/FaintDiffESimAnalysis/RunOutputs/Simple_04_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter60000_thin20_Strt.0.02_viaFits.out"
infiles[1] = "/Code/AstroCode/MultiScaleImaging_2009/FaintDiffESimAnalysis/RunOutputs/Simple_04_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter60000_thin20_Strt.02.0_viaFits.out"


outfiles <- character(1)

#outfiles[1] = "/Code/AstroCode/MultiScaleImaging_2009/FaintDiffESimAnalysis/PostProcessedFiles/Simple_04_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter60000_thin20_Strt.obs_viaFits.fits"
#outfiles[2] = "/Code/AstroCode/MultiScaleImaging_2009/FaintDiffESimAnalysis/PostProcessedFiles/Simple_04_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter60000_thin20_Strt.0.02_viaFits.fits"
outfiles[1] = "/Code/AstroCode/MultiScaleImaging_2009/FaintDiffESimAnalysis/PostProcessedFiles/Simple_04_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter60000_thin20_Strt.02.0_viaFits.fits"




wantaxis <- numeric(3)
wantaxis[1] = 128     # image x-axis
wantaxis[2] = 128     # image y-axis
wantaxis[3] = 3000    # number of sample images

numdatfiles = length(infiles)
print(numdatfiles)

## Now do for each input file:
#######################################################################


for (lfil in 1: numdatfiles){

#######################################################################
# Read in ascii .out file as a table.
# This will pit a fram around a list-format.
# As well, this will at first put the data sideways:
# The x-axis will be in the y-axis position;
# and the y-axis times the number of samples
# will be in the x-position.
#

datsample <- read.table(infiles[lfil])

#########################################################
# Now, strip the excess "frame" from it by casting into
# matrix format:

datsamplemat <- as.matrix(datsample)

##############################################################
# From here, we want a temporary array, to re-arrange things:
# 

tmparr <- array(data=0., dim=wantaxis)

## TIMING CAUTION: TOOK 26 MIN for 128x128x1500 ARRAY SWITCH:
##
for (ks in 1:wantaxis[3]) {
    for (ix in 1:wantaxis[1]) {
        for (jy in 1:wantaxis[2]) {
            tmparr[ix,jy,ks] = datsample[(jy+((ks-1)*wantaxis[2])),ix]
        }
    }
}

#
# Now, write it out as a fits file...

tstoutfitsfile = outfiles[lfil]
writeFITSim(tmparr,file=tstoutfitsfile)


#######################################################################
####### End of loop over all files ####################################
}
