## TEST for accumulating/concatenating large numbers of img samples.
## It doesn't work for over 4000 to 5000 total samples in Python,
## because of a hard-coded memory limit of some kind.
## 
## 
#########################################################################

r --vanilla --no-restore <<EOF > Simple_04_RUtil_FitsImageMoviesAccumulatesToOneBigFitsFil.logt1

require(FITSio)

#######
####### Note that all these file-specification are currently put in BY HAND
#######

infiles <- character(3)

infiles[1] = "../PostProcessedFiles/Simple_04_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter60000_thin20_Strt.obs_viaFits.fits"
infiles[2] = "../PostProcessedFiles/Simple_04_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter60000_thin20_Strt.0.02_viaFits.fits"
infiles[3] = "../PostProcessedFiles/Simple_04_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter60000_thin20_Strt.02.0_viaFits.fits"


outfile = "../PostProcessedFiles/Simple_04_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter60000_thin20_0to2.cleanmovie.fits"

numburnin = 25


##
inaxis <- numeric(3)
## These 3 could actually come from readFITS...
inaxis[1] = 128     # image x-axis
inaxis[2] = 128     # image y-axis
inaxis[3] = 3000    # number of sample images per file

numdatfiles = length(infiles)
print(numdatfiles)

outaxis <- numeric(3)
outaxis[1] = 128     # image x-axis
outaxis[2] = 128     # image y-axis
outaxis[3] = (inaxis[3]-numburnin)*numdatfiles    # TOTAL number of sample images

numtotpixels= outaxis[1]*outaxis[2]

##############################################################
# From here, we want a temporary array, to re-arrange things:
# 

tmparr <- array(data=0., dim=outaxis)
print("Making a BIG data array:"); print(dim(tmparr))

## Now do for each input file:
#######################################################################


for (lfil in 1:numdatfiles){
print("lfil:"); print(lfil)
#######################################################################
# Read in fits file for individual McMC runs.
# This will put a frame around an array, in list-format.
#

datsamplefits <- readFITS(infiles[lfil])
print("After reading fits file, dims are:"); print(dim(datsamplefits)); print(dim(datsamplefits[[1]]))
#########################################################
# Now, strip the excess "frame" from it by casting into
# matrix format:

datsamplearr <- as.array(datsamplefits[[1]],dim=inaxis)
print("Coercing a data array from the fits form:"); print(dim(datsamplearr))

## 
##
print("outaxis[3], inaxis[3]:"); print(outaxis[3]); print(inaxis[3])

for (ks in (numburnin+1):inaxis[3]) {
    kouts = ks - numburnin + (lfil-1)*(inaxis[3]-numburnin)
    kins  = ks ######## %% inaxis[3]  # Actually ks modulo inaxis
    ##print("ks, kouts, kins:"); print(ks); print(kouts); print(kins)
    for (jy in 1:outaxis[2]) {
        for (ix in 1:outaxis[1]) {
            tmparr[ix,jy,kouts] = datsamplearr[ix,jy, kins ]
        }
    }
}

#######################################################################
####### End of loop over all files ####################################

print("End of ks loop -- lfil, ks, kouts, kins, dim of tmparr:"); print(lfil); print(ks); print(kouts); print(kins); print( dim(tmparr) )

}

#
# Now, write it out as a fits file...

print("End of all loops -- dim of tmparr:"); print(dim(tmparr) )

print("outfile:"); print(outfile)

writeFITSim(tmparr,file=outfile)

