'''
@brief Reads in text image files; writes out moments in fits form.
@author A. Connors
'''
# @file get_multi_txt_matrix.py
#
# This script is explicitly for reading in "output.txt" format files
# and writing them out in fits form compatible with
# CHASC imaging software.
#

#from numarray import * ## Changed to numpy Aug 2007
from numpy import *
import pyfits

class ScanTxtMatrix:
    def __init__(self,InTxtFileName,naxis_3tuple):
        print 'Reading ',InTxtFileName,' with shape:', naxis_3tuple
        naxis3,naxis2,naxis1 = naxis_3tuple
        print naxis3,naxis2,naxis1
        image = zeros((naxis3,naxis2,naxis1),dtype=float)
##        self.data = image
        image_in = open(InTxtFileName,'r')
        print 'Status of file open: \n', image_in, '\nEnd File Status\n\n'
        ping = -1
        for this_line in image_in :
            ping = ping + 1
            numimage = int(ping/naxis2)
            if ( numimage >= naxis3 ):
                print 'Warning -- Ending -- get-multi-txt-rmatrix out of bounds.'
                print 'image.shape is:', image.shape
                print 'But numimage, ping are:', numimage, ping,
                print ' with naxis2. naxis3: ', naxis2, naxis3
                self.data = image[0:numimage-1]
                image_in.close()
                return
            lon = ping - int(numimage*naxis2)
#            print numimage, lon, ping, ':' , this_line
            if this_line == '' :
                print '\n this_line:',thisl_ine,' is blank at numimage, lont: ',numimage, lon, '\n'
                self.data = image
                image_in.close()
                return
            ## There is probably a much cleaner way to slice this_line
            # using a built-in python method.
            ## But for now, it is expliclty sliced, assuming the entries
            ## are separated by blanks.
            latbegin = 0
            latend = latbegin + 1
            for lat in range(naxis1):
                while ( (latbegin < len(this_line)) and (this_line[latbegin] == ' ') ):
                    latbegin = latbegin + 1
                    latend = latbegin + 1
                while ((latend < len(this_line)) and (this_line[latend] != ' ')):
                    latend = latend + 1
                    #print 'lon, lat: ',lon, lat, 'latbegin, end: ', latbegin, latend
                yo = this_line[latbegin:latend]
                if(yo != ''):
                    try:
                        image[numimage][lon][lat] = float(yo)
                    except:
                        print 'Exception - get-multi-txt-rmatrix out of bounds.'
                        print 'image.shape is:', image.shape
                        print 'But numimage, lon, lat are:', numimage, lon, lat
                        self.data = image[0:numimage-1]
                        image_in.close()
                        return
                else:
                    print '\n yo-string:',yo,' is blank at numimage, lon,lat: ',numimage, lon, lat, '\n'
                    self.data = image[0:numimage-1]
                    #self.data = image
                    image_in.close()
                    return
#
                latbegin = latend
                latend = latbegin + 1
                if (latend > len(this_line) -1):
                    latend = len(this_line) -1

#                print numimage,lon, image[numimage][lon]


        print 'At end of ScnTxt: image shape is: ', image.shape
        print image

        self.data = image
#        print self.data
        image_in.close()
#etc

class MatrixModeNMoments:
    def __init__(self,CleanImage,ModeIterNum,MatchedExposrImageHDU,OutFitsFileName):
        MatchedExposrImageData = MatchedExposrImageHDU.data
        nmoments = 7
        naxis3,naxis2,naxis1 = CleanImage.shape
        print 'CleanImage.shape: ', CleanImage.shape
        self.data    = zeros((nmoments,naxis2,naxis1),dtype=float)
        self.data[1] = self.data[1] + 1.0e-7
        ##
        ## For saving storage space, we are doing this one tedious image at a time...##
        ##
        print '\n trying average:'
        for iter in range(naxis3):
            self.data[0] = self.data[0]+ CleanImage[iter]
        self.data[0] = self.data[0]/float(naxis3)
        for iter in range(naxis3):
            dif     = CleanImage[iter] - self.data[0]
            self.data[1] = self.data[1] + dif*dif
            self.data[2] = self.data[2] + dif*dif*dif
            self.data[3] = self.data[3] + dif*dif*dif*dif
        #end for
        print 'self.data[0][naxis2/2][naxis1/2]: ',self.data[0][naxis2/2][naxis1/2]

        self.data[1] = sqrt( self.data[1] )/float(naxis3)
        print 'self.data[1][naxis2/2][naxis1/2]: ',self.data[1][naxis2/2][naxis1/2]

        self.data[2] = self.data[2]/float(naxis3)/self.data[1]/self.data[1]/self.data[1] 
        print 'self.data[2][naxis2/2][naxis1/2]: ',self.data[2][naxis2/2][naxis1/2]

        self.data[3] = self.data[3]/float(naxis3)/self.data[1]/self.data[1]/self.data[1]/self.data[1]
        print 'self.data[3][naxis2/2][naxis1/2]: ',self.data[3][naxis2/2][naxis1/2]

        self.data[4] = self.data[0]/self.data[1]
        print 'self.data[4][naxis2/2][naxis1/2]: ',self.data[4][naxis2/2][naxis1/2]

        self.data[5] = self.data[0]/MatchedExposrImageData
        print 'self.data[5][naxis2/2][naxis1/2]: ',self.data[5][naxis2/2][naxis1/2]

        self.data[6] = self.data[1]/MatchedExposrImageData
        print 'self.data[6][naxis2/2][naxis1/2]: ',self.data[6][naxis2/2][naxis1/2]
    
        image_HDU = pyfits.PrimaryHDU(self.data)
        transfer_imageWCS_to_newheader(MatchedExposrImageHDU,image_HDU)
        image_HDU.header.update('NAXIS3',nmoments,comment='Mean,Sigma,Skew,Kurt,Mean/Sig,Mean/Expos,Sig/Expos')
    
        image_HDU.writeto(OutFitsFileName)
#
#   End.

def transfer_imageWCS_to_newheader(OldHDU,NowHDU):

    ## 0. Error-checking and initialization:
    old_rank, now_rank = OldHDU.data.shape, NowHDU.data.shape
    if( old_rank[-1] != now_rank[-1] or old_rank[-2] != now_rank[-2]):
        print 'Transfer_imageWCS_to_newheader Fatal Error!'
        print 'old_shape was: ', old_rank, ' BUT now_shape was: ', now_rank
        print 'Image shapes were incompatible.'
        raise TypeError

    ## updating WCS:
    try:
        NowHDU.header.update('CTYPE1',OldHDU.header['CTYPE1'])
    except:
        print 'Transfer_imageWCS_to_newheader error. CTYPE1 not in old header.'
    try:
        NowHDU.header.update('CRPIX1',OldHDU.header['CRPIX1'])
    except:
        print 'Transfer_imageWCS_to_newheader error. CRPIX1 not in old header.'
    try:
        NowHDU.header.update('CRVAL1',OldHDU.header['CRVAL1'])
    except:
        print 'Transfer_imageWCS_to_newheader error. CRVAL1 not in old header.'
    try:
        NowHDU.header.update('CDELT1',OldHDU.header['CDELT1'])
    except:
        print 'Transfer_imageWCS_to_newheader error. CDELT1 not in old header.'
    try:
        NowHDU.header.update('CUNIT1',OldHDU.header['CUNIT1'])
    except:
        print 'Transfer_imageWCS_to_newheader error. CUNIT1 not in old header.'

    try:
        NowHDU.header.update('CTYPE2',OldHDU.header['CTYPE2'])
    except:
        print 'Transfer_imageWCS_to_newheader error. CTYPE2 not in old header.'
    try:
        NowHDU.header.update('CRPIX2',OldHDU.header['CRPIX2'])
    except:
        print 'Transfer_imageWCS_to_newheader error. CRPIX2 not in old header.'
    try:
        NowHDU.header.update('CRVAL2',OldHDU.header['CRVAL2'])
    except:
        print 'Transfer_imageWCS_to_newheader error. CRVAL2 not in old header.'
    try:
        NowHDU.header.update('CDELT2',OldHDU.header['CDELT2'])
    except:
        print 'Transfer_imageWCS_to_newheader error. CDELT2 not in old header.'
    try:
        NowHDU.header.update('CUNIT2',OldHDU.header['CUNIT2'])
    except:
        print 'Transfer_imageWCS_to_newheader error. CUNIT2 not in old header.'

    try:
        NowHDU.header.update('CROTA2',OldHDU.header['CROTA2'])
    except:
        print 'Transfer_imageWCS_to_newheader error. CROTA2 not in old header.'

    ## Adding Fermi-specific keywords saying what kind of data:
    try:
        NowHDU.header.update('TELESCOP',oldHDU.header['TELESCOP'])
    except:
        print 'Transfer_imageWCS_to_newheader error. TELESCOP not in old header.'
    try:
        NowHDU.header.update('INSTRUME',oldHDU.header['INSTRUME'])
    except:
        print 'Transfer_imageWCS_to_newheader error. INSTRUME not in old header.'
    try:
        NowHDU.header.update('DATE-OBS',oldHDU.header['DATE-OBS'])
    except:
        print 'Transfer_imageWCS_to_newheader error. ATE-OOBS not in old header.'
    try:
        NowHDU.header.update('DATE-END',oldHDU.header['DATE-END'])
    except:
        print 'Transfer_imageWCS_to_newheader error. ATE-EEND not in old header.'
    try:
        NowHDU.header.update('NDSKEYS',oldHDU.header['NDSKEYS'])
    except:
        print 'Transfer_imageWCS_to_newheader error. NDSKEYS not in old header.'
    try:
        NowHDU.header.update('EQUINOX',oldHDU.header['EQUINOX'])
    except:
        print 'Transfer_imageWCS_to_newheader error. EQUINOX not in old header.'
    try:
        NowHDU.header.update('OBSERVER',oldHDU.header['OBSERVER'])
    except:
        print 'Transfer_imageWCS_to_newheader error. OBSERVER not in old header.'
    try:
        NowHDU.header.update('DSTYP1',oldHDU.header['DSTYP1'])
    except:
        print 'Transfer_imageWCS_to_newheader error. DSTYP1 not in old header.'
    try:
        NowHDU.header.update('DSUNI1',oldHDU.header['DSUNI1'])
    except:
        print 'Transfer_imageWCS_to_newheader error. DSUNI1 not in old header.'
    try:
        NowHDU.header.update('DSVAL1',oldHDU.header['DSVAL1'])
    except:
        print 'Transfer_imageWCS_to_newheader error. DSVAL1 not in old header.'
    try:
        NowHDU.header.update('DSTYP2',oldHDU.header['DSTYP2'])
    except:
        print 'Transfer_imageWCS_to_newheader error. DSTYP2 not in old header.'
    try:
        NowHDU.header.update('DSUNI2',oldHDU.header['DSUNI2'])
    except:
        print 'Transfer_imageWCS_to_newheader error. DSUNI2 not in old header.'
    try:
        NowHDU.header.update('DSVAL2',oldHDU.header['DSVAL2'])
    except:
        print 'Transfer_imageWCS_to_newheader error. DSVAL2 not in old header.'
    try:
        NowHDU.header.update('DSREF2',oldHDU.header['DSREF2'])
    except:
        print 'Transfer_imageWCS_to_newheader error. DSREF2 not in old header.'
    try:
        NowHDU.header.update('DSTYP3',oldHDU.header['DSTYP3'])
    except:
        print 'Transfer_imageWCS_to_newheader error. DSTYP3 not in old header.'
    try:
        NowHDU.header.update('DSUNI3',oldHDU.header['DSUNI3'])
    except:
        print 'Transfer_imageWCS_to_newheader error. DSUNI3 not in old header.'
    try:
        NowHDU.header.update('DSVAL3',oldHDU.header['DSVAL3'])
    except:
        print 'Transfer_imageWCS_to_newheader error. DSVAL3 not in old header.'
    try:
        NowHDU.header.update('DSTYP4',oldHDU.header['DSTYP4'])
    except:
        print 'Transfer_imageWCS_to_newheader error. DSTYP4 not in old header.'
    try:
        NowHDU.header.update('DSUNI4',oldHDU.header['DSUNI4'])
    except:
        print 'Transfer_imageWCS_to_newheader error. DSUNI4 not in old header.'
    try:
        NowHDU.header.update('DSVAL4',oldHDU.header['DSVAL4'])
    except:
        print 'Transfer_imageWCS_to_newheader error. DSVAL4 not in old header.'
    try:
        NowHDU.header.update('DSTYP5',oldHDU.header['DSTYP5'])
    except:
        print 'Transfer_imageWCS_to_newheader error. DSTYP5 not in old header.'
    try:
        NowHDU.header.update('DSUNI5',oldHDU.header['DSUNI5'])
    except:
        print 'Transfer_imageWCS_to_newheader error. DSUNI5 not in old header.'
    try:
        NowHDU.header.update('DSVAL5',oldHDU.header['DSVAL5'])
    except:
        print 'Transfer_imageWCS_to_newheader error. DSVAL5 not in old header.'

##  End.
