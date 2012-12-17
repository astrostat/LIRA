from numpy import *
import pyfits
from short_get_multi_txt_rmatrix import *

#-----------------------------------------------------------------------#

indir = '../outputs/'

fillist = [
    ('Simple04_Gauss2dSig1.5_17x17PSF_SimPois00_128x128testEvsNullModel.out',1600),
    ('Simple04_Gauss2dSig1.5_17x17PSF_SimPois01_128x128testEvsNullModel.out',1600),
    ('Simple04_Gauss2dSig1.5_17x17PSF_SimPois02_128x128testEvsNullModel.out',1600),
    ('Simple04_Gauss2dSig1.5_17x17PSF_SimPois03_128x128testEvsNullModel.out',1600),
    ('Simple04_Gauss2dSig1.5_17x17PSF_SimPois04_128x128testEvsNullModel.out',1600),
    ('Simple04_Gauss2dSig1.5_17x17PSF_SimPois05_128x128testEvsNullModel.out',1600),
    ]
#numiters=(1600,1600,1600,1600,1600,1600)
burnin=10
imagedim = (128,128)
outfil = 'Simple04_Gauss2dSig1.5_17x17PSF_SimPois0to8_128x128testEvsNullModel.moment0.fits'
outfil0 = 'Simple04_Gauss2dSig1.5_17x17PSF_SimPois0to3_128x128testEvsNullModel.chopmovies.fits'
outfil1 = 'Simple04_Gauss2dSig1.5_17x17PSF_SimPois3to5_128x128testEvsNullModel.chopmovies.fits'

#----interesting data: ---------------------#
#
#fillist = [
#    ('Simple04_Gauss2d1.5_PoisDatons128x128testEvsNull_Strt0.01_viaFits.out',1000),
#    ('Simple04_Gauss2d1.5_PoisDatons128x128testEvsNull_Strt0.04_viaFits.out',1500),
#    ('Simple04_Gauss2d1.5_PoisDatons128x128testEvsNull_Strt0.05_viaFits.out',1400),
#    ('Simple04_Gauss2d1.5_PoisDatons128x128testEvsNull_Strt0.40_viaFits.out',1500),
#    ('Simple04_Gauss2d1.5_PoisDatons128x128testEvsNull_Strt0.50_viaFits.out',1000),
#    ('Simple04_Gauss2d1.5_PoisDatons128x128testEvsNull_Strt00obs_viaFits.out',1500),
#    ('Simple04_Gauss2d1.5_PoisDatons128x128testEvsNull_Strt1.00_viaFits.out',1000),
#    ('Simple04_Gauss2d1.5_PoisDatons128x128testEvsNull_Strt1obs_viaFits.out',1500),
#    ('Simple04_Gauss2d1.5_PoisDatons128x128testEvsNull_Strt2obs_viaFits.out',1500),
# ]
#burnin=10
#imagedim = (128,128)
#outfil = 'Simple04_Gauss2d1.5_PoisDatons128x128testEvsNull_0to8.moments0to1.fits'
#outfil0 = 'Simple04_Gauss2d1.5_PoisDatons128x128testEvsNull_about0to2.chopmovies.fits'
#outfil1 = 'Simple04_Gauss2d1.5_PoisDatons128x128testEvsNull_about3to5.chopmovies.fits'
#outfil2 = 'Simple04_Gauss2d1.5_PoisDatons128x128testEvsNull_about6to8.chopmovies.fits'

#---testing suite: ###############
#
#fillist = [
#  ('PoisNulDat532x32EEMC2vsNullModel_Strt0.01_viaFits.out',140),
#  ('PoisNulDat432x32EEMC2vsNullModel_Strt1.00_viaFits.out',140),
#  ('PoisNulDat332x32EEMC2vsNullModel_Strt0.01_viaFits.out',140),
#  ('PoisNulDat232x32EEMC2vsNullModel_Strt1.00_viaFits.out',140),
#  ('PoisNulDat132x32EEMC2vsNullModel_Strt0.01_viaFits.out',140),
#  ('PoisNulDat032x32EEMC2vsNullModel_Strt1.00_viaFits.out',140),
# ]
#
##numiters=(140,140,140,140,140,140)
#burnin=20
#imagedim = (32,32)
#outfil = 'Simple02_PoisNulDat0to5_32x32vsNulModel.moments1.fits'
#outfil1 = 'Simple02_PoisNulDat0to5_32x32vsNulModel.chopmovies1.fits'

#-----------------------------------------------------------------------#
#

chopmovlist = []
####!tempmean = zeros(imagedim)

for (filnam,thisnumiters) in fillist:
    print 'Now reading in: ',filnam
    tempdatlist = ScanTxtMatrix(indir+filnam,(thisnumiters,imagedim[0],imagedim[1]) )
    for i in range(burnin,thisnumiters):
        chopmovlist.append(tempdatlist.data[i])
        #
        # Now while still in LIST format, make mean and higher moments.
####!        tempmean +=tempdatlist.data[i]
    #end-for

numtotsamples = len( chopmovlist )
####!tempmean = tempmean/float(numtotsamples)

#
# Now the variance and sigma:

####!tempsigm = zeros(imagedim)
####!for i in range(numtotsamples):
####!    tempsigm += (chopmovlist[i]-tempmean)*(chopmovlist[i]-tempmean)
####!tempsigm = sqrt( tempsigm/float(numtotsamples) )

#
# Now the skew and kurtosis:

####!tempskew = zeros(imagedim)
####!tempkurt = zeros(imagedim)
####!for i in range(numtotsamples):
####!    tempdel = (chopmovlist[i]-tempmean)/tempsigm
####!    tempskew += tempdel*tempdel*tempdel
####!    tempkurt += tempskew*tempdel
####!tempskew = tempskew/float(numtotsamples)
####!tempkurt = tempkurt/float(numtotsamples)


####!chopmoments = asarray([tempmean, tempsigm, tempskew, tempkurt, tempmean/tempsigm])

####!chopmeanHDU = pyfits.PrimaryHDU(data=chopmoments)

####!chopmeanHDU.writeto(outfil)

#------------------------------------------------------------------------------#
## NOTE that for images of size 128x128, I can't do a 10000 long 'movie'. :
# Python(5271,0xa079e500) malloc: *** mmap(size=1250426880) failed (error code=12)
# *** error: can't allocate region
# *** set a breakpoint in malloc_error_break to debug
# Traceback (most recent call last):
#   File "howto_short_get_movies_from_rmatrix.py", line 33, in <module>
#    chopdat = asarray(chopmovlist)
#   File "/Library/Frameworks/Python.framework/Versions/2.6/lib/python2.6/site-packages/numpy/core/numeric.py", line 284, in asarray
#    return array(a, dtype, copy=False, order=order)
# MemoryError
#
## SO the maximum that it looks like I can do is:
##  [0:5000] ??? Sometimes???

#------------------------------------------------#
#chopdat = asarray(chopmovlist[0:3936])
#chopdat = asarray(chopmovlist[0:4770])
#
#chopHDU = pyfits.PrimaryHDU(data=chopdat)
#
#chopHDU.writeto(outfil0)

#-------------------------------------------------------------#
#chopdat = asarray(chopmovlist[3937:7873])
chopdat = asarray(chopmovlist[4771:9540])

chopHDU = pyfits.PrimaryHDU(data=chopdat)

chopHDU.writeto(outfil1)

#------------#------------------------------------------------#
#chopdat = asarray(chopmovlist[7874:11810])

#chopHDU = pyfits.PrimaryHDU(data=chopdat)

#chopHDU.writeto(outfil2)

#----------------------------------------------------
