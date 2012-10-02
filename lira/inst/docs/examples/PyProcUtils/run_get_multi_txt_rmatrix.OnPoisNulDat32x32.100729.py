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

wrkdir = '/AstroCode/MultiScaleImaging_2009/R-package/tests/'
indir0 = '../exampledata/'
indir1 = '../outputs/'
outdir = 'intermediatefiles/'

## For the simple02 Null Datons Cases:
filestemI1,filestemI2 = 'PoisNulDat', '32x32EEMC2vsNullModel_Strt'
filestemO = filestemI1+'0to5'+filestemI2+'_0_1'
numoutiters=140 # I.E. 700 iertations, every 5 written out
numburnin=40

infile_list = [
   (
    [
     (indir1+filestemI1+'0'+filestemI2+'1.00_viaFits'+'.out',numoutiters),
     (indir1+filestemI1+'1'+filestemI2+'0.01_viaFits'+'.out',numoutiters),
     (indir1+filestemI1+'2'+filestemI2+'1.00_viaFits'+'.out',numoutiters),
     (indir1+filestemI1+'3'+filestemI2+'0.01_viaFits'+'.out',numoutiters),
     (indir1+filestemI1+'4'+filestemI2+'1.00_viaFits'+'.out',numoutiters),
     (indir1+filestemI1+'5'+filestemI2+'0.01_viaFits'+'.out',numoutiters),
    ],
     outdir+filestemO+'.allmovies.fits',
     outdir+filestemO+'.moments.fits',
     indir0+'FlatUnityExposure32sq.fits',
     outdir+filestemO+'.chopmovies.fits'
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
    
    print 'Total number of samples for AllMovies data: ',BigAllIters
    BigAllMoviesData = zeros( (BigAllIters,InMatrixWidth1,InMatrixWidth2),dtype=float)
    allmoviepointer  = 0
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
        BigAllMoviesData [ allmoviepointer: allmoviepointer+niter] = tst.data[0:niter]
##      Not sure what I think of tis feature:
        if BigAllIters > niter :
            allmoviepointer  += niter
            BigAllMoviesData[ allmoviepointer: allmoviepointer+1] = blankarray[0]
            allmoviepointer  += 1
##
        cleandata = tst.data[numburnin:niter]
        liter = niter-numburnin
        BigChopMoviesData[chopmoviepointer:chopmoviepointer+liter] = cleandata[0:liter]
        chopmoviepointer +=liter

    print 'End of nametuple[0] loop'

    tst1_HDU = pyfits.PrimaryHDU(data=BigAllMoviesData)
    transfer_imageWCS_to_newheader(OldHDU,tst1_HDU)
    tst1_HDU.writeto(nametuple[1])
    print 'Allmovie Fits data final shape: ', tst1_HDU.header, '\n',  tst1_HDU.data.shape
    print 'Allmovie Fits file written  \n \n'

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
