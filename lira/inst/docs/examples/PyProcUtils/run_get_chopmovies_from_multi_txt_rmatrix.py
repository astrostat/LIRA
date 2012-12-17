'''
@brief Runs routines that read in text image files; writes out "movie" file + moments in fits form.
@author A. Connors
'''
# @file run_get_multi_txt_matrix.py
#
# This script is explicitly for reading in "output.txt" format files
# and writing them out in fits form compatible with
# CHASC imaging software.
#
import pyfits
from numpy import *
from get_multi_txt_rmatrix import *

#----------------------New method requires a fits exposure file, number of iterations/inputfile--------------------------------------------#

#
# Example of putting in multiple MCMC runs:

wrkdir = '/Code/AstroCode/MultiScaleImaging_2009/R-package/tests/'
indir0 = '../exampledata/'
indir1 = '../outputs/'
outdir = 'intermediatefiles/'

## For the simple00 no background case:
#filestemI = 'PoisDatons32x32EEMC2_NoBckgrnd'
#filestemO = 'PoisDatons32x32EEMC2_NoBckgrnd_1_2_tst'
#numoutiters = 1000
#numburnin = 20   #   For each input file, Assume 1st 1-200 iterations [i.e. 20-40 lines at thin=5 to 10] of 'output.txt' get tossed; converges later


## For the simple02 vs null, preliminary, case:
#filestemI = 'Prelim_PoisDatons32x32EEMC2vsNullModel_Strt'
#filestemO = 'Prelim_PoisDatons32x32EEMC2vsNullModel_Strt_0_1'
#numoutiters = 300
#numburnin= 150

## For the simple02 vs null, longer runs:
filestemI = 'PoisDatons32x32EEMC2vsNullModel_Strt'
filestemO = 'PoisDatons32x32EEMC2vsNullModel_Strt_0_1'
numoutiters=400
numburnin=40

## For the simple03 with PSFs, trial prelim runs:
filestemI = 'Simple04_Prelim_Gauss2d1.5_PoisDatons128x128testEvsNull_Strt'
filestemO0 = 'Simple04_Prelim_Gauss2d1.5_PoisDatons128x128testE_StrtvsNull_0_1'
filestemO0 = 'Simple04_Prelim_Gauss2d1.5_PoisDatons128x128testE_StrtvsNull_0_1'
numoutiters=300
numburnin=100

infile_list = [
   (
    [
     (indir1+filestemI+'1.00_viaFits'+'.out',numoutiters),
     (indir1+filestemI+'0.01_viaFits'+'.out',numoutiters),
    ],
     outdir+filestemO+'.allmovies.fits',
     outdir+filestemO+'.moments.fits',
     indir0+'FlatUnityExposure128sq.fits',
     outdir+filestemO+'.chopmovies.fits'
     ),
    ]

## For the simple04 with PSFs, actual runs:
filestemI = 'Simple04_Gauss2d1.5_PoisDatons128x128testEvsNull_Strt'
filestemO  ='Simple04_Gauss2d1.5_PoisDatons128x128testE_StrtvsNull_0to2'
filestemO1 ='Simple04_Gauss2d1.5_PoisDatons128x128testE_StrtvsNull_0to2'
filestemO2 ='Simple04_Gauss2d1.5_PoisDatons128x128testE_StrtvsNull_3to4'
filestemNI= 'Simple04_Gauss2dSig1.5_17x17PSF_SimPois0'
filestemNO ='Simple04_Gauss2dSig1.5_17x17PSF_SimPois0to5'
filestemNO0='Simple04_Gauss2dSig1.5_17x17PSF_SimPois0to1'
filestemNO1='Simple04_Gauss2dSig1.5_17x17PSF_SimPois2to3'
filestemNO2='Simple04_Gauss2dSig1.5_17x17PSF_SimPois4to5'
nullend = '_128x128testEvsNullModel'
numoutiters0=1000
numoutiters4=1400
numoutiters5=1500
numoutiters6=1600
# These files are thinned at thin=10, so skipping only 10
numburnin=10

infile_list = [
   (
    [
     (indir1+filestemNI+'0'+nullend+'.out',numoutiters6), \
     (indir1+filestemNI+'1'+nullend+'.out',numoutiters6), \
     (indir1+filestemNI+'2'+nullend+'.out',numoutiters6), \
     (indir1+filestemNI+'3'+nullend+'.out',numoutiters6), \
     (indir1+filestemNI+'4'+nullend+'.out',numoutiters6), \
     (indir1+filestemNI+'5'+nullend+'.out',numoutiters6), \
    ],
     outdir+filestemNO +'.allmovies.fits', \
     outdir+filestemNO +'.moments.fits', \
     indir0+'FlatUnityExposure128sq.fits', \
     outdir+filestemNO +'.chopmovies.fits' \
     ),
   (
    [
     (indir1+filestemI+'Strt0.01_viaFits'+'.out',numoutiters0), \
     (indir1+filestemI+'Strt0.50_viaFits'+'.out',numoutiters0), \
     (indir1+filestemI+'Strt1.00_viaFits'+'.out',numoutiters0), \
     (indir1+filestemI+'Strt0.05_viaFits'+'.out',numoutiters4), \
     (indir1+filestemI+'Strt1obs_viaFits'+'.out',numoutiters4), \
    ],
     outdir+filestemO +'.allmovies.fits', \
     outdir+filestemO +'.moments.fits', \
     indir0+'FlatUnityExposure128sq.fits', \
     outdir+filestemO +'.chopmovies.fits' \
     ),
    ]


########################################################

#------------------------------------------------------------------------------#
### Initializing:
print '** CAUTION: CURRENTLY InMatrixWidth1 x InMatrixWidth2 ARE From Exposure File **'



imode = 12   # Placeholder.

#------------------------------------------------------------------------------#
## Silly initialization of output file, an "pyfits.append" seems not to work as advertised.
for nametuple in infile_list:
    BigAllIters = 0
    BigChopIters= 0
    for (infilename, niter) in nametuple[0]:
        BigAllIters  += niter+1
        BigChopIters +=(niter-numburnin)


    MatchedExposrHDULst = pyfits.open(nametuple[3])
    print 'Exposure Fits file successfully opened \n'
#   touch HDU to make sure all is well:
    print MatchedExposrHDULst[0].header, '\n'
    if ( len(MatchedExposrHDULst[0].data.shape) == 3):
        exp_data = MatchedExposrHDULst[0].data[0]
    elif (len(MatchedExposrHDULst[0].data.shape) ==2 ):
        exp_data = MatchedExposrHDULst[0].data
    else:
        print '\n\nFatal Error i exposure format. Requires data of rank 2 or 3.'
        print 'BUT input exposre data had shape: ',MatchedExposrHDULst[0].data.shape
        raise TypeError
    ## Now setting up to correct headers of simulated files:
    OldHDU_temp = MatchedExposrHDULst[0]
    OldHDU = pyfits.PrimaryHDU(data=exp_data)
    transfer_imageWCS_to_newheader(OldHDU_temp,OldHDU)
    
    InMatrixWidth1, InMatrixWidth2 = exp_data.shape[-2], exp_data.shape[-1]

    blankarray = zeros((1,InMatrixWidth1,InMatrixWidth2),dtype=float)  # For the "movie" file, to visually see boundary between files.
    
    print '**exp_data[0][0]:', exp_data[0][0], '\n \n'
    
#    print 'Total number of samples for AllMovies data: ',BigAllIters
#    BigAllMoviesData = zeros( (BigAllIters,InMatrixWidth1,InMatrixWidth2),dtype=float)
#    allmoviepointer  = 0
    print 'Total number of samples for ChopMovies data: ',BigChopIters
    BigChopMoviesData= zeros((BigChopIters,InMatrixWidth1,InMatrixWidth2),dtype=float)
    chopmoviepointer = 0

    print '\n \n run_get_multi_txt_rmatrix: File names:\n'##,nametuple[0], '\n \n \n',nametuple[1], '\n \n',nametuple[2], '\n \n', nametuple[3], '\n \n', nametuple[4], '\n \n \n'
    for (infilename, niter) in nametuple[0]:
        print 'Within nametuple[0] loop.  Now scanning ',niter,' samples from '
        print infilename, ' \n \n'
        this_naxis_3tuple = (niter, InMatrixWidth1, InMatrixWidth2)
        tst = ScanTxtMatrix(infilename,this_naxis_3tuple)
        print 'Data: ', tst.data.shape, '\n', tst.data, '\n\n'
##        pyfits.append(nametuple[1], tst.data)
#        BigAllMoviesData [ allmoviepointer: allmoviepointer+niter] = tst.data[0:niter]
##      Not sure what I think of tis feature:
#        if BigAllIters > niter :
#            allmoviepointer  += niter
#            BigAllMoviesData[ allmoviepointer: allmoviepointer+1] = blankarray[0]
#            allmoviepointer  += 1
##
        cleandata = tst.data[numburnin:niter]
        liter = niter-numburnin
        BigChopMoviesData[chopmoviepointer:chopmoviepointer+liter] = cleandata[0:liter]
        chopmoviepointer +=liter

    print 'End of nametuple[0] loop'

#    tst1_HDU = pyfits.PrimaryHDU(data=BigAllMoviesData)
#    transfer_imageWCS_to_newheader(OldHDU,tst1_HDU)
#    tst1_HDU.writeto(nametuple[1])
#    print 'Allmovie Fits data final shape: ', tst1_HDU.header, '\n',  tst1_HDU.data.shape
#    print 'Allmovie Fits file written  \n \n'

    tst4_HDU = pyfits.PrimaryHDU(data=BigChopMoviesData)
    transfer_imageWCS_to_newheader(OldHDU,tst4_HDU)
    tst4_HDU.writeto(nametuple[4])
    print 'Allmovie Fits data with burn-in chopped off final shape: ', tst4_HDU.header, '\n',  tst4_HDU.data
    print 'Allmovie Fits file with burn-in chopped off successfully written \n \n'

    Allcleanmoments_HDULst = pyfits.open(nametuple[4])
    print '\n Final Shape of Allcleanmoments: ', Allcleanmoments_HDULst[0].data.shape
    print '\n Final Data of Allcleanmoments: ', Allcleanmoments_HDULst[0].data, '\n'
    Allcleanmoments_HDULst.close()
    tstmoments = MatrixModeNMoments(Allcleanmoments_HDULst[0].data,imode,OldHDU,nametuple[2])

    print 'Accumulated moments file successfully written \n \n'
    
# End!!
