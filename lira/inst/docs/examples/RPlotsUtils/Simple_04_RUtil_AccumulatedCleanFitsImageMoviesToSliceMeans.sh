## TEST for putting out means of slices of  large numbers of img samples.
## It doesn't work for over 4000 to 5000 total samples in Python,
## because of a hard-coded memory limit of some kind.
## 
##
#########################################################################

r --vanilla --no-restore <<EOF > Simple_04_RUtil_AccumulatedCleanFitsImageMoviesToSliceMeans.logtst1

require(FITSio)

#######
####### Note that all these file-specification are currently put in BY HAND
#######

infile  = "../PostProcessedFiles/Simple_04_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter60000_thin20_0to2.cleanmovie.fits"
outfile = "../PostProcessedFiles/Simple_04_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter60000_thin20_0to2.slices_tst.fits"


##
inaxis <- numeric(3)
## These 3 could actually come from readFITS...
inaxis[1] = 128     # image x-axis
inaxis[2] = 128     # image y-axis
inaxis[3] = 8925    # number of sample images per file
##### For temporary debugging:
##### inaxis[3] = 4500     #
 inaxis[3] = 1500     #
##### inaxis[3] = 300      #

numdatfiles = length(infile)
print(numdatfiles)


## Still inputs by hand:
numslices = 20
numperslice = inaxis[3] %/% numslices
numinlastslice = inaxis[3] - ( (numslices-1)*numperslice )
print("numslices; numperslice; numinlastslice:"); print(numslices); print(numperslice); print(numinlastslice)




outmomentsaxis <- numeric(3)
outmomentsaxis[1] = 128     # image x-axis
outmomentsaxis[2] = 128     # image y-axis
outmomentsaxis[3] = numslices*2

tmparr <- array(data=0., dim=outmomentsaxis)
print("Making moments array:"); print(dim(tmparr))

#### Normally this would be read in from a fits file,
#### header and all  But for now its a unity matrix:
####
unitexp <- array(data=1., dim=outmomentsaxis[1:2])

#######################################################################
# Read in fits file for accumulated McMC runs, burnin chopped off.
# This will put a frame around an array, in list-format.
#

datsamplefits <- readFITS(infile)
print("After reading fits file, dims are:"); print(dim(datsamplefits[[1]]))
#########################################################
# Now, strip the excess "frame" from it by casting into
# matrix format:

datsamplearr <- as.array(datsamplefits[[1]],dim=inaxis)
print("Coercing a data array from the fits form:"); print(dim(datsamplearr))

## 
##
print("outmomentsaxis[3], inaxis[3]:"); print(outmomentsaxis[3]); print(inaxis[3])


##
## shrinking [hopefully!] amount of storage neded:
datsamplefits <- character(2)
datsamplefits[1]="FILE";  datsamplefits[2]="CLOSED"


########################################################################
########################################################################
##### 3. Get file with matching re-normed pars; SumStats; & sort indexes

##### 3.1 open file read as table ######################################

##### 3.2 fill index vectors with appropriate Sorted SumStat Indexes ###






########################################################################
########################################################################
##### 4.  Now get out the simple means: ################################



##### 4.1 Get mean for all but the last slice:
for (lslice in 1:(numslices-1)){
    for (kl in 1:numperslice){
        ks = kl + ( (lslice-1)*numperslice )
        for (jy in 1:outmomentsaxis[2]) {
            for (ix in 1:outmomentsaxis[1]) {
                tmparr[ix,jy,lslice] = tmparr[ix,jy,lslice] + (datsamplearr[ix,jy, ks ])
            }
        }
    }
tmparr[1:inaxis[1],1:inaxis[2],lslice] = tmparr[1:inaxis[1],1:inaxis[2],lslice]/numperslice
}

##### 4.2 Now get mean for the last slice:
for (kl in 1:numinlastslice){
    ks = kl + ( (numslices-1)*numperslice )
    for (jy in 1:outmomentsaxis[2]) {
        for (ix in 1:outmomentsaxis[1]) {
            tmparr[ix,jy,numslices] = tmparr[ix,jy,numslices] + (datsamplearr[ix,jy, ks ])
        }
    }
}
tmparr[1:inaxis[1],1:inaxis[2],numslices] = tmparr[1:inaxis[1],1:inaxis[2],numslices]/numinlastslice


################################################################################
#### 6. Now the 'divide by' layers:
for (ls in 1:numslices){
    ll = ls + numslices
    for (jy in 1:outmomentsaxis[2]) {
        for (ix in 1:outmomentsaxis[1]) {
            tmparr[ix,jy,ll] = tmparr[ix,jy,ls]/unitexp[ix,jy]
            tmparr[ix,jy,ll] = tmparr[ix,jy,ls]/unitexp[ix,jy]
        }
    }
}
print("After divide-by layers loop: dim(tmparr)="); print(dim(tmparr))


#### 7. Finally, write them out as a fits file...

print("End of all loops -- dim of tmparr:"); print(dim(tmparr) )

print("outfile:"); print(outfile)

writeFITSim(tmparr,file=outfile)

