## TEST for accumulating/concatenating large numbers of img samples.
## It doesn't work for over 4000 to 5000 total samples in Python,
## because of a hard-coded memory limit of some kind.
## 
##  When 4  moments took 18 hrs, decided to shorten & speed up:
##  It's still a real memory hog. But it takes only about
##  5 1/3 hrs (at 4 Gb RAM) now.
#########################################################################

r --vanilla --no-restore <<EOF > Simple_04_RUtil_AccumulatedCleanFitsImageMoviesToMoments.8925.logtimRtst4

require(FITSio)

#######
####### Note that all these file-specification are currently put in BY HAND
#######

infile  = "../PostProcessedFiles/Simple_04_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter60000_thin20_0to2.cleanmovie.fits"
outfile = "../PostProcessedFiles/Simple_04_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter60000_thin20_0to2.4moments_tst.fits"


##
inaxis <- numeric(3)
## These 3 could actually come from readFITS...
inaxis[1] = 128     # image x-axis
inaxis[2] = 128     # image y-axis
inaxis[3] = 8925    # number of sample images per file
##### For temporary debugging:
##### inaxis[3] = 4500     #
#### inaxis[3] = 1500     #
##### inaxis[3] = 300      #

numdatfiles = length(infile)
print(numdatfiles)

outmomentsaxis <- numeric(3)
outmomentsaxis[1] = 128     # image x-axis
outmomentsaxis[2] = 128     # image y-axis
outmomentsaxis[3] = 7    # Mean; std; skew; kurtosis; mean/std; mean/exposure; std/exposure

numtotpixels= outmomentsaxis[1]*outmomentsaxis[2]


tmparr <- array(data=0., dim=outmomentsaxis)
print("Making moments array:"); print(dim(tmparr))

#### Normally this would be ead in from a fits file,
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
########################################################################
######## Now write out the simple moments: #############################

### delarr <- array(data=0.,dim=inaxis) ## This taken out, hoping to save memory


##### 1. Get mean:  
## try to see if R function
## "tmparr[1:inaxis[1],1:inaxis[2],1] = apply(datsamplearr,c(1,2),mean)"
## is faster!! ++++ AC 5 Jul 2012 Seems to be same time. +++++++++++
tmparr[1:inaxis[1],1:inaxis[2],1] = apply(datsamplearr,c(1,2),mean)

##for (ks in 1:inaxis[3]){
##    for (jy in 1:outmomentsaxis[2]) {
##        for (ix in 1:outmomentsaxis[1]) {
##            tmparr[ix,jy,1] = tmparr[ix,jy,1] + (datsamplearr[ix,jy, ks ])
##        }
##    }
##}
##tmparr[1:inaxis[1],1:inaxis[2],1] = tmparr[1:inaxis[1],1:inaxis[2],1]/inaxis[3]
print("After mean: dim(tmparr)="); print(dim(tmparr))

##### 2. Get delta:
for (ks in 1:inaxis[3]){
    for (jy in 1:outmomentsaxis[2]) {
        for (ix in 1:outmomentsaxis[1]) {
            datsamplearr[ix,jy,ks] = (datsamplearr[ix,jy, ks ] - tmparr[ix,jy,1])
        }
    }
}
print("After accumulation: dim(datsamplearr)="); print(dim(datsamplearr))


#### 3. Get sigma -- also handy for kurtosis:
##tmparr[1:inaxis[1],1:inaxis[2],2] = apply( (datsamplearr*datsamplearr) ,c(1,2),mean)
for (ks in 1:inaxis[3]){
    for (jy in 1:outmomentsaxis[2]) {
        for (ix in 1:outmomentsaxis[1]) {
            this_del = datsamplearr[ix,jy, ks ]
            this_var = this_del*this_del
            if(this_var < 0.){print("VAR error at i,j,k:"); print(this_var); print(ix); print(jy); print(ks); print(this_del); print(this_var)}
            tmparr[ix,jy,2] = tmparr[ix,jy,2] + this_var
            tmparr[ix,jy,3] = tmparr[ix,jy,3] + ( this_var*this_del )
            tmparr[ix,jy,4] = tmparr[ix,jy,4] + ( this_var*this_var )
        }
    }
}
tmparr[1:inaxis[1],1:inaxis[2],2] = tmparr[1:inaxis[1],1:inaxis[2],2]/inaxis[3]
tmparr[1:inaxis[1],1:inaxis[2],3] = tmparr[1:inaxis[1],1:inaxis[2],3]/inaxis[3]
tmparr[1:inaxis[1],1:inaxis[2],4] = tmparr[1:inaxis[1],1:inaxis[2],4]/inaxis[3]

tmparr[1:inaxis[1],1:inaxis[2],3] = tmparr[1:inaxis[1],1i:inaxis[2],3]/tmparr[1:inaxis[1],1:inaxis[2],2]
tmparr[1:inaxis[1],1:inaxis[2],4] = tmparr[1:inaxis[1],1i:inaxis[2],4]/tmparr[1:inaxis[1],1:inaxis[2],2]/tmparr[1:inaxis[1],1:inaxis[2],2]

print("After variance loop: dim(tmparr)="); print(dim(tmparr))
tmparr[1:inaxis[1],1:inaxis[2],2] = sqrt(tmparr[1:inaxis[1],1:inaxis[2],2])
tmparr[1:inaxis[1],1:inaxis[2],3] = tmparr[1:inaxis[1],1i:inaxis[2],3]/tmparr[1:inaxis[1],1:inaxis[2],2]

#print("After sqrt: dim(tmparr), tmparr[1:10,1:10,2]="); print(dim(tmparr)); print(tmparr[1:10,1:10,2])


#### 4. Now the 'divide by' layers:
for (jy in 1:outmomentsaxis[2]) {
    for (ix in 1:outmomentsaxis[1]) {
        tmparr[ix,jy,5] = tmparr[ix,jy,1]/tmparr[ix,jy,2]
        tmparr[ix,jy,6] = tmparr[ix,jy,1]/unitexp[ix,jy]
        tmparr[ix,jy,7] = tmparr[ix,jy,2]/unitexp[ix,jy]
    }
}
print("After divide-by layers loop: dim(tmparr)="); print(dim(tmparr))


#### 7. Finally, write them out as a fits file...

print("End of all loops -- dim of tmparr:"); print(dim(tmparr) )

print("outfile:"); print(outfile)

writeFITSim(tmparr,file=outfile)

