#
# Required CIAO 4.5/contrib package
#
from ciao_contrib.runtool import *
import os

# rebin_img function to make an image with the center pixel at the region centroid
# infile - input psf event file from SAOtrace
# outfile - output file, binned psf image 
# binsize - binning of the image
# nsize - size of the image in image pixels
# xcenter, ycenter - initial centroid

    
def rebin_img(infile="evt2.fits", outfile="test.fits",
              binsize=0.25, nsize=64, xcen=4060.0, ycen=4090.0):
    

    for i in range(5):
        filename = "{}[sky=circle({},{},10)][cols sky]".format(infile,xcen, ycen)
        dmstat(filename, verbose=0)
        vals = [float(x) for x in dmstat.out_mean.split(',')]
        xcen=vals[0]
        ycen=vals[1]
        #print vals

    # calculate the size
    N = nsize
    B = binsize
    xcen3 = vals[0]
    ycen3 = vals[1]
    xmin = xcen3 - (N*B+B/2)*0.5
    xmax = xcen3 + (N*B+B/2)*0.5
    ymin = ycen3 - (N*B+B/2)*0.5
    ymax = ycen3 + (N*B+B/2)*0.5

    newfile = "{}[bin x={}:{}:{},y={}:{}:{}][opt type=i4]".format(infile, xmin, xmax, B, ymin, ymax, B)

    dmcopy(newfile, outfile, clobber=True)

### Use Example:
    
#obsids = (10307,10308)
#
#for obsid in obsids:
#    print 'obsid', obsid
#    os.chdir(str(obsid))
#    dmstat("acis_evt2.fits[sky=region(src.reg)][cols sky]")
#    vals = [float(x) for x in dmstat.out_mean.split(',')]
#    xval=vals[0]
#    yval=vals[1]
#    os.chdir('..')
#    rebin_img(infile="evt2.fits[energy=500:7000]",outfile="img_128x128_0.5.fits",
#              binsize=0.5, nsize=127, xcen=xval,ycen=yval)
#    os.chdir('../..')
    
    

