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


class ParamListTxt:
    def __init__(self,InTxtFileName,paramlen):
        print 'Reading ',InTxtFileName,' with length:', paramlen

        ## Read in text file of sample images:
        paramlist_fil = open(InTxtFileName,'r')
        paramlist_in = paramlist_fil.read()
        print 'Status of file open: \n'#, paramlist_in, '\nEnd File Status\n\n'

        ## Split the text file into lines:
        paramlist_lines = paramlist_in.split('\n')
        num_tot_lines = len(paramlist_lines)

        ## Separate header, comments, title, and values:
        paramlist_header = [ ]
        paramlist_charlist = [ ]
        paramlist_comments = [ ]
        R_headerchar = '#'
        R_commentchar = '#'
        R_titlechar = [' ',' ', '  ', '   ','     ',]
        num_params = 0
        end_of_header, title_found = False, False

        for iline in range(num_tot_lines):
            if not end_of_header:
                if paramlist_lines[iline][0] == R_headerchar :
                    paramlist_header.append(paramlist_lines[iline])
                    print 'HEADER: ',iline, paramlist_header[iline]
                elif not title_found:
                    paramlist_titles = paramlist_lines[iline].split()
                    num_params = len(paramlist_titles)
                    print 'TITLES:  ', paramlist_titles
                    num_header_lines = iline
                    title_found = True
                    end_of_header = True
            else:
                continue

        ## Now Check on the length:
        num_samples = num_tot_lines - num_header_lines -1
        if num_samples < paramlen :
            print 'Warning: input/file mismatch. Expected ', paramlen,' sample paramlists,',
            print ' but got ', num_samples
            print ' Using minimum of the two.'
            num_paramlists = min(num_samples,paramlen)
        elif num_samples > paramlen :
            print 'Warning: input/file mismatch. Expected ', paramlen,' sample paramlists,',
            print ' but got ', num_samples
            print ' Using minimum of the two.'
            num_paramlists = min(num_samples,paramlen)
        else:
            num_paramlists=paramlen

        ## Split the lines into individual entries.
        ## Check: are any too short/long??
        for iline in range(num_header_lines+1,num_paramlists+num_header_lines+1):
            if paramlist_lines[iline][0] == R_commentchar :
                paramlist_comments.append(paramlist_lines[iline])
            else:
                paramlist_char = paramlist_lines[iline].split()
#                 paramlist_charlist.append(paramlist_char)

            if len(paramlist_char) != num_params :
                print 'Fatal Error: input/file mismatch. Expected line length ', num_params,',',
                print ' but got length of ', len(paramlist_char),' , for line:'
                print paramlist_char
                raise TypeError
            else:
                paramlist_charlist.append(paramlist_char)
                #print 'DEBUG: Appending paramlist_char:\n', paramlist_char

        ## Now turn it into a float array:
        paramchar  = asarray(paramlist_charlist)
        paramfloat = (paramchar.astype(float)).transpose()
        paramlist  = nan_to_num( asarray(paramfloat) )

        print 'At end of ScnTxt: paramlist shape is: ', paramlist.shape
        print paramlist_titles
        # For debug:
        for ll in range(len(paramlist)):
            print paramlist[ll]
        print '\n\n\n'
        self.values = paramlist
        self.meanings = paramlist_titles
        self.header = paramlist_header
#        print self.values, paramlist.header, paramlist.meanings
        paramlist_fil.close()
#etc

    # Method for finding the lags:
    def do_autocor(self,burnin=1,maxlag=-1):

        # index = 0 is usually the iteration number
        # index=1 usually gives you the LogPostProb
        # index=2 usually step-size
        # iteration 0 is chopped off to avoid nan etc.

        # Getting the length with n=0:
        lenx = len(self.values[0])
        x= (self.values[0][burnin:lenx] - self.values[0][burnin:lenx].mean())
        result = correlate(x, x, mode='full')

        if maxlag <= 0 :
            endlag = result.size/2
        else :
            endlag = maxlag

        # Filling in correlations for all variables:
        print '\n\ndo_autocor: Note that algorithm subtracts the mean first,',
        print 'for ease of finding correlation length. It does not divide by std.\n'
        for jj in range(len(self.meanings)):
            x = (self.values[jj][burnin:]  - self.values[jj][burnin:].mean())
            result = correlate(x, x, mode='full')
            try:
                self.autocor.append( result[result.size/2:endlag+result.size/2] )
            except:
                self.autocor =      [ result[result.size/2:endlag+result.size/2], ]


#############################################################################
class ScanTxtMatrix:
    def __init__(self,InTxtFileName,naxis_3tuple):
        print 'Reading ',InTxtFileName,' with shape:', naxis_3tuple
        naxis3,naxis2,naxis1 = naxis_3tuple
        print naxis3,naxis2,naxis1
##        image = zeros((naxis3,naxis2,naxis1),dtype=float)
##        self.data = image

        ## Read in text file of sample images:
        image_fil = open(InTxtFileName,'r')
        print 'Status of file open: \n', image_fil, '\nEnd File Status\n\n'

        ## Split the text file into lines:
        image_in = image_fil.read()
        image_lines = image_in.split('\n')
        
        ## First Check on the dimensions:
        num_lines = len(image_lines)
        num_samples_in = num_lines/naxis2
        if num_samples_in < naxis3 :
            print 'Warning: input/file mismatch. Expected ', naxis3,' sample images,',
            print ' but got ', num_samples_in
            print ' Using minimum of the two.'
            num_images = min(num_samples_in,naxis3)
        elif num_samples_in > naxis3 :
            print 'Warning: input/file mismatch. Expected ', naxis3,' sample images,',
            print ' but got ', num_samples_in
            print ' Using minimum of the two.'
            num_images = min(num_samples_in,naxis3)
        else:
            num_images=naxis3
            
        ## Split the lines into individual entries.
        image_charlistlist = [ ]
        image_floatlist = []
        ## Check: are any too short/long??
        for iimage in range(num_images):
            image_charlist = [ ]
            for iline in range(naxis2):
                image_char = image_lines[iimage*naxis2+iline].split()
                if len(image_char) != naxis1 :
                    print 'Fatal Error: input/file mismatch. Expected line length ', naxis1,',',
                    print ' but got length of ', len(image_char),' , for line:'
                    print image_char
                    raise TypeError
                else:
                    image_charlist.append(image_char)
            image_charlistlist.append(image_charlist)
            ## Now turn it into a list of float arrays:
            image_floatlist.append(asarray(image_charlist).astype(float))
            image_fil.close()

#        ## Now turn it into a float array:
#        image = asarray(image_charlistlist).astype(float)

        print 'At end of ScnTxt: image_floatlist shape is: ', len(image_floatlist), image_floatlist[0].shape
#        print image_floatlist

        self.data = image_floatlist
#        self.data = image
#        print self.data
        image_fil.close()
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
