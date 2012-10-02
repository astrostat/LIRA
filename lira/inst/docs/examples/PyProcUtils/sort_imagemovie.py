'''
@brief Reads in MCMC "movie" sample of image files; writes out sorted (pixels in intensity order) in fits form.
@author A. Connors
'''
# @file sort_imagemovie.py
#
# This script is explicitly for:
# reading MC "movies" of images in fits format and sorting pixels in intensity order;
# Finding an extra simple version of confidence bands (i.e. [.10, .90] or [.9545, .6723, .5, .3287, .0455]);
#      and writing out 'images' for each confidence band
# and writing them out in fits form compatible with
# CHASC imaging software.
#

from numpy import *
import pyfits

class SortMovieMatrix:
    def __init__(self,InFitsMovieFileName,NumBurnIn):
#
# 0. Initialize:
        print 'Reading ',InFitsMovieFileName,' with burn-in number:', NumBurnIn
#
# 0.1   Read in fits movie matrix:
        image_inHDULst = pyfits.open(InFitsMovieFileName)
        print 'Header: \n', image_inHDULst[0].header
        naxis3,naxis2,naxis1 = image_inHDULst[0].data.shape
        print naxis3,naxis2,naxis1
        InImage = zeros((naxis3-NumBurnIn,naxis2,naxis1))

#
# 1. Try sorting each pixel by intensity:
        InImage[:][:][:] = image_inHDULst[0].data[NumBurnIn:][:][:]
        SortImage = sort(InImage,axis=0)

        self.data = SortImage
        self.old_header = image_inHDULst[0].header
#        print SortImage
#        print self.data
        image_inHDULst.close()
#etc

class OverlySimpleImageConfBands:
    def __init__(self,SortImageHDU,OutFitsFileName,IntensConfidences=[.10 , .50, .90]):
        numconfbands = len(IntensConfidences)
        naxis3,naxis2,naxis1 = SortImageHDU.data.shape
        print 'Shape of input Sorted MC Movie Images: ',SortImageHDU.data.shape
        self.data    = zeros((numconfbands,naxis2,naxis1))
        TotImages = float(naxis3)

        ll = -1
        howmany = []
        for confvalue in IntensConfidences:
            ll = ll + 1
            print' For ll=',ll,' and confvalue=',confvalue,' Totimages*confvalue is:',TotImages*confvalue
            howmany.append(0.)
            for thisindex in range(naxis3):
                if( abs( confvalue - 0.5 ) < 1.e-6 ):
                    print 'At average piece:'
                    try:
                        self.data[ll] = SortImageHDU.data.mean(axis=0)
                    except:
                        print ' ImageMovie Exception! at: ', ll, UnsortedMovieImageHDU.data
                    print ' \n'
                elif( confvalue < 0.5 ):
                    if( thisindex <= TotImages*confvalue ):
                        self.data[ll] += SortImageHDU.data[thisindex]
                        howmany[ll]   += 1.
                elif( confvalue > 0.5 ):
                    if( thisindex >= TotImages*confvalue ):
                        self.data[ll] += SortImageHDU.data[thisindex]
                        howmany[ll]   += 1.
                # end if
        for lll in range( len(IntensConfidences) ):
            if( howmany[lll] > 0. ):
                self.data[lll] = self.data[lll]/howmany[lll]
        # end for

        image_HDU = pyfits.PrimaryHDU(self.data)
        image_HDU.header.update('NAXIS3',numconfbands,comment='Confidences: '+str(IntensConfidences))

        image_HDU.writeto(OutFitsFileName)
#
#   End.

class SecondSimpleImageConfBands:
    def __init__(self,UnsortedMovieImageHDU,OutFitsFileName,IntensConfidences=[.10, .50 , .90]):
#
# 1/ Initialize handy variables, including ExpectedMSTotalCnts:
#
        numconfbands = len(IntensConfidences)		# Output is confidence bands, plus mean in the middle if conf=0.5
        naxis3,naxis2,naxis1 = UnsortedMovieImageHDU.data.shape
        print 'Shape of input Sorted MC Movie Images: ',UnsortedMovieImageHDU.data.shape
        self.data    = zeros((numconfbands,naxis2,naxis1))
        TotImages = float(naxis3)
        ExpectedMSTotalCnts = []
        for imag in range(naxis3):
            sumit = 0.
            for ll in range(naxis2):
                sumit += sum( UnsortedMovieImageHDU.data[imag][ll][:] )
            print 'imag,sumit: ', imag, ' , ', sumit, '\n'
            ExpectedMSTotalCnts.append(sumit)

#       Next check what ExpectedMSCnts values correspond to each conf band:
        SortedExpectedMSCnts = sort(ExpectedMSTotalCnts)
        CountsConf = []
        for ll in range(numconfbands):
            lin = ll
            lout = ll
            thisindex = int(IntensConfidences[lin]*TotImages)
            CountsConf.append(SortedExpectedMSCnts[thisindex])
            confvalue = IntensConfidences[lin]
            print ' For ll,lin=',ll,lin,' and confvalue=',confvalue,' Totimages*confvalue is:',TotImages*confvalue
            print ' Corresponds to counts: ', CountsConf[lin]
#       end for
        for ll in range(numconfbands):
            lin = ll
            lout = ll
            confvalue = IntensConfidences[lin]
            if (abs( confvalue - 0.5 ) < 1.e-6):
                print 'At average piece:, lin,lout is ', lin, lout
                try:
                    self.data[lout] = UnsortedMovieImageHDU.data.mean(axis=0)
                except:
                    print ' ImageMovie Exception! at: ', lout, UnsortedMovieImageHDU.data
                print ' \n'
            elif( confvalue < 0.5 ):
                print 'At lower limit:, lin,lout is ', lin, lout
                howmany = 0.
                for thisindex in range(naxis3):
                    if ( SortedExpectedMSCnts[thisindex] <= CountsConf[lin] ):
                        self.data[lout] += UnsortedMovieImageHDU.data[thisindex]
                        howmany += 1.
                # Renormalize:
                self.data[lout] = self.data[lout]/howmany
            elif( confvalue > 0.5 ):
                print 'At upper limit:, lin,lout is ', lin, lout
                howmany = 0.
                for thisindex in range(naxis3):
                    if ( SortedExpectedMSCnts[thisindex] >= CountsConf[lin] ):
                        self.data[lout] += UnsortedMovieImageHDU.data[thisindex]
                        howmany += 1.
                # Renormalize:
                self.data[lout] = self.data[lout]/howmany
            print ' \n \n'
    # Now renormalize:

        image_HDU = pyfits.PrimaryHDU(self.data)
        image_HDU.header.update('NAXIS3',numconfbands,comment='Confidences: '+str(IntensConfidences))

        image_HDU.writeto(OutFitsFileName)
        self.header = image_HDU.header
#
#   End.
#----------------------------------------------------------------------------------------------------#
class ThirdSimpleImageConfBands:
    def __init__(self,UnsortedMovieImageHDU,Exp2DData, \
        OutFitsFileName,IntensConfidences=[.10, .50 , .90],InExpHDUheader=None):
#
# 1/ Initialize handy variables, including ExpectedMSTotalCnts:
#

	# Output is confidence bands, plus mean in the middle if conf=0.5
        # AND it will be both in counts (1st 3) and intensities (2nd 3)
        numconfbands = len(IntensConfidences)
        naxis3,naxis2,naxis1 = UnsortedMovieImageHDU.data.shape
        print 'Shape of input Sorted MC Movie Images: ',UnsortedMovieImageHDU.data.shape
        self.data    = zeros((2*numconfbands,naxis2,naxis1))
        TotImages = float(naxis3)
        ExpectedMSTotalCnts = []
        for imag in range(naxis3):
            sumit = 0.
            for ll in range(naxis2):
                sumit += sum( UnsortedMovieImageHDU.data[imag][ll][:] )
#            print 'imag,sumit: ', imag, ' , ', sumit, '\n'
            ExpectedMSTotalCnts.append(sumit)

#       Next check what ExpectedMSCnts values correspond to each conf band:
        SortedExpectedMSCnts = sort(ExpectedMSTotalCnts)
        CountsConf = []
        for ll in range(numconfbands):
            lin = ll
            lout = ll
            thisindex = int(IntensConfidences[lin]*TotImages)
            CountsConf.append(SortedExpectedMSCnts[thisindex])
            confvalue = IntensConfidences[lin]
            print ' For ll,lin=',ll,lin,' and confvalue=',confvalue,' Totimages*confvalue is:',TotImages*confvalue
            print ' Corresponds to counts: ', CountsConf[lin]
#       end for
        for ll in range(numconfbands):
            lin = ll
            lout = ll
            confvalue = IntensConfidences[lin]
            if (abs( confvalue - 0.5 ) < 1.e-6):
                print 'At average piece:, lin,lout is ', lin, lout
                try:
                    self.data[lout] = UnsortedMovieImageHDU.data.mean(axis=0)
                except:
                    print ' ImageMovie Exception! at: ', lout, UnsortedMovieImageHDU.data
                print ' \n'
            elif( confvalue < 0.5 ):
                print 'At lower limit:, lin,lout is ', lin, lout
                howmany = 0.
                for thisindex in range(naxis3):
                    if ( SortedExpectedMSCnts[thisindex] <= CountsConf[lin] ):
                        self.data[lout] += UnsortedMovieImageHDU.data[thisindex]
                        howmany += 1.
                # Renormalize:
                self.data[lout] = self.data[lout]/howmany
            elif( confvalue > 0.5 ):
                print 'At upper limit:, lin,lout is ', lin, lout
                howmany = 0.
                for thisindex in range(naxis3):
                    if ( SortedExpectedMSCnts[thisindex] >= CountsConf[lin] ):
                        self.data[lout] += UnsortedMovieImageHDU.data[thisindex]
                        howmany += 1.
                # Renormalize:
                self.data[lout] = self.data[lout]/howmany
            print ' \n \n'
    # Now renormalize:

    # Now add in the 3 intensities:
        for indx in range(numconfbands) :
           self.data[indx+numconfbands] = nan_to_num(self.data[indx]/Exp2DData)

        image_HDU = pyfits.PrimaryHDU(self.data)
        image_HDU.header.update('NAXIS3',numconfbands,comment='Confidences: '+str(IntensConfidences)+'Cnts; Intens')
        ## updating WCS:
        if InExpHDUheader != None :
            try:
                image_HDU.header.update('CTYPE1',InExpHDUheader['CTYPE1'])
            except:
                print 'Transfer_imageWCS_to_newheader error. CTYPE1 not in old header.'
            try:
                image_HDU.header.update('CRPIX1',InExpHDUheader['CRPIX1'])
            except:
                print 'Transfer_imageWCS_to_newheader error. CRPIX1 not in old header.'
            try:
                image_HDU.header.update('CRVAL1',InExpHDUheader['CRVAL1'])
            except:
                print 'Transfer_imageWCS_to_newheader error. CRVAL1 not in old header.'
            try:
                image_HDU.header.update('CDELT1',InExpHDUheader['CDELT1'])
            except:
                print 'Transfer_imageWCS_to_newheader error. CDELT1 not in old header.'
            try:
                image_HDU.header.update('CUNIT1',InExpHDUheader['CUNIT1'])
            except:
                print 'Transfer_imageWCS_to_newheader error. CUNIT1 not in old header.'
        
            try:
                image_HDU.header.update('CTYPE2',InExpHDUheader['CTYPE2'])
            except:
                print 'Transfer_imageWCS_to_newheader error. CTYPE2 not in old header.'
            try:
                image_HDU.header.update('CRPIX2',InExpHDUheader['CRPIX2'])
            except:
                print 'Transfer_imageWCS_to_newheader error. CRPIX2 not in old header.'
            try:
                image_HDU.header.update('CRVAL2',InExpHDUheader['CRVAL2'])
            except:
                print 'Transfer_imageWCS_to_newheader error. CRVAL2 not in old header.'
            try:
                image_HDU.header.update('CDELT2',InExpHDUheader['CDELT2'])
            except:
                print 'Transfer_imageWCS_to_newheader error. CDELT2 not in old header.'
            try:
                image_HDU.header.update('CUNIT2',InExpHDUheader['CUNIT2'])
            except:
                print 'Transfer_imageWCS_to_newheader error. CUNIT2 not in old header.'
        
            try:
                image_HDU.header.update('CROTA2',InExpHDUheader['CROTA2'])
            except:
                print 'Transfer_imageWCS_to_newheader error. CROTA2 not in old header.'
        #end-if header exists

        image_HDU.writeto(OutFitsFileName)
        self.header = image_HDU.header
#
#   End.
#------------------------------------------------------------------------------#
class OneScaleAvOfMSSamples:
    def __init__(self,InMSSampleImages,InLevelKey,InCycleSpinCenters=[(),]):

    # 0. Check inputs:
        try:
            if len(InMSSampleImages.shape) == 3 :
                numsamples = InMSSampleImages.shape[0]
                imagewidth = InMSSampleImages.shape[1]
                if imagewidth != InMSSampleImages.shape[2]:
                    print 'OneScaleAvOfMsSamples Fatal Input Error.'
                    print 'InMSSampleImages.shape must be square samples, but',
                    print 'Its shape is: ', InMSSampleImages.shape
                    raise TypeError
                #end-if
                TempImage = zeros(InMSSampleImages.shape)
            else:
                print 'OneScaleAvOfMsSamples Fatal Input Error.'
                print 'InMSSampleImages.shape must be 3D, but',
                print 'Its shape is: ', InMSSampleImages.shape
                raise TypeError
            #end-if
        except:
            print 'OneScaleAvOfMsSamples Fatal Input Error.'
            print 'InMSSampleImages must be a numpy array, BUT',
            print 'Its type is: ', type(InMSSampleImages)
            raise TypeError
        #end exception

    # Check special case:
        if type(InLevelKey) == type(2):
            LevelKey = InLevelKey
            NumBlocks = 2**LevelKey
        else:
            print 'OneScaleAvOfMsSamples Fatal Input Error.'
            print 'InLevelKey must be an integer, BUT',
            print 'Its type is: ', type(InLevelKey)
            raise TypeError

    #
        if NumBlocks == imagewidth :
            self.data = InMSSampleImages
            return
        elif NumBlocks > imagewidth :
            print 'OneScaleAvOfMsSamples Fatal Input Error.'
            print 'InLevelKey impliess NumBlocks=',NumBlocks,
            print ' to be > imagewidth=',imagewidth,'.'
            print ' BUT this is not feasible. (Recall NumBlocks=2**Level).'
            raise TypeError

    # cycle-spinning coords:one per image; OR no cycle-spinning (default):
        if InCycleSpinCenters == [(),] :
            CycleSpinCenters = list(numsamples*(imagewidth/2,imagewidth/2))
        elif type(InCycleSpinCenters) == type([(1.,2.),(3.,4.),]) and \
              len(InCycleSpinCenters[0]) ==2 and \
              len(InCycleSpinCenters) == numsamples :
            CycleSpinCenters = InCycleSpinCenters
        else:
             print 'OneScaleAvOfMsSamples Fatal Input Error.'
             print 'InCycleSpinCenters must be a list of pairs of length ',numsamples
             print ' in order to match the images.  BUT its length is len(InCycleSpinCenters)!'
             print ' InCycleSpinCenters: ', InCycleSpinCenters
             raise TypeError


    # 1  Initialize blocksize, etc:
        blockwidth = imagewidth/NumBlocks

    # 2  Now fill in TempImage:
        for ks in range(numsamples):
            CycleSpinCenter = CycleSpinCenters[ks]
            #
            for jy in range(numblocks):
                ybinedges = [CycleSpinCenter[1] - blockwidth/2, \
                             CycleSpinCenter[1] +1 + blockwidth/2 ]
                ybinedges = mod(ybinedges,imagewidth)
                #
                for ix in range(numblocks):
                    xbinedges = [CycleSpinCenter[0] - blockwidth/2, \
                                 CycleSpinCenter[0] +1 + blockwidth/2 ]
                    xbinedges = mod(ybinedges,imagewidth)
                    #
                    TempImage       [ks][ybinedge[0]:ybinedge[1]] \
                                        [xbinedge[0]:xbinedge[1]] = \
                    InMSSampleImages[ks][ybinedge[0]:ybinedge[1]] \
                                        [xbinedge[0]:xbinedge[1]].mean()
                #end-for-ix
            #end-for-jy
        #end-for-ks

    # 3 Now store it in "data":
        self.data = TempImage
        return

#------------------------------------------------------------------------------#


# Now to call the above in a reasonable way: #
# Requires: Input of MCMC fits file AND "delim" file, in same thinning.
#     Presumed aleady with burn-in chopped off.
#   SO get file names; open each file; read them in. Make output file-names.
#   THEN FOR EACH LEVEL of interest -- call the above routine. Write 'em out.
#    End for all levels of interest.

