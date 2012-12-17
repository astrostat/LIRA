import numpy as n
import pyfits

class basic_struct:
    def __init__(self,Values=[],Units=[],Meaning=[]):
        #
        # 0. Check inputs

        self.values = Values
        self.units = []
        self.meaning = []
    #

#
#end.

#------------------------------------------------------------------------------#
class MCMCSamples(basic_struct):
    def __init__(self,InputsList=[]):
    #
        self = basic_struct(InputsList[0],InputsList[1],InputsList[2])
    #
#
#end.

#------------------------------------------------------------------------------#
    def ScanTxtMatrix(self,InTxtFileName,naxis_3tuple):
        #
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
        self.values = image
#        print self.data
        image_in.close()
#etc

#
#end.

#------------------------------------------------------------------------------#
    def MatrixModeNMoments(self,CleanImage,ModeIterNum,MatchedExposrImageHDU,OutFitsFileName):
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

        self.values = self.data
#
#   End.

#------------------------------------------------------------------------------#
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

#------------------------------------------------------------------------------#
    def visualize_nk_multiscales(self, InMCMCImageHDU, InMCMCParams,\
       OutCtsMovieFitsFileStem, OutRatMovieFitsFileStem, \
       want_levels=[0,-1] ):
    
# Trying to reproduce what the aggregate scales look like.
# Possible algoithms:
# Mean of raw counts given images and cycle-spin, for each level?
# Mean of mother/daughter count ratios, given images and cycle-spin?
#  --> This is, after all, what the model is: the ratios at each scale.
#  --> This is the "orthogonal" basis piece.
# Mean of raw counts, given mother counts??
#  --> This is a little closer to what the data look like, though.

## From the C-Code:
#
#  /*************** Copy src.data into ms_ag ************/
#  dim = src->nrow;
#  for(i=0; i < dim; i++) 
#    for(j=0; j < dim; j++)
#      ms->ag[0][i][j] = src->data[(i+spin_row)%dim][(j+spin_col)%dim];
#        
#  /*************** Compute aggregations  **********/
#  dim = src->nrow;
#  for(level=0; level < ms->power; level++){ 
#    dim /= 2.0;                      /* Loop over  Aggregation Levels*/
#    for(i=0; i < dim; i++){
#      for(j=0; j < dim; j++){
#          sum = 0;
#        for(k=0; k<2; k++)
#            for(l=0; l<2; l++)
#              sum += ms->ag[level][2*i+k][2*j+l];
#          ms->ag[level+1][i][j]=sum;
#      } /* loop over columns of ms.ag[level] */
#    } /* loop over rows of ms.ag[level] */
#  } /* loop over aggregation level */
#
#--------------------------------------------------------------------#
#
#  logprior = (ms->ttlcnt_pr - 1) * log(ms->ag[ms->power][0][0]) -
#    ms->ttlcnt_exp * ms->ag[ms->power][0][0];
#  dim=1;        /*Starts at lowest dim, one big "pixel" */
#
#  ms->ag[ms->power][0][0] = log(ms->ag[ms->power][0][0]); /* Puts it in log form for ease */

#  for(level = ms->power; level > 0; level--){ /* Steps through each level, starting with parent */
#    for(i=0; i< dim; i++)
#      for(j=0; j<dim; j++)
#        for(k=0; k<2; k++)
#          for(l=0; l<2; l++){
#            logprior +=(ms->al[level-1] ) * log(ms->ag[level-1][2*i+k][2*j+l]); /* Per Jason Kramer 13 Mar 2009 */
#            ms->ag[level-1][2*i+k][2*j+l] = 
#              log(ms->ag[level-1][2*i+k][2*j+l]) + ms->ag[level][i][j];
#          } /* loop over l */
#    dim *= 2;       /* Increases number of daughters by 2 in each direction */
#  } /* loop over aggregation level */
#
#  /******************* Store new image in src.img *******************/
#  dim = src->nrow;
#  for(i=0; i< dim; i++)
#    for(j=0; j<dim; j++)
#      src->img[(i+spin_row)%dim][(j+spin_col)%dim] = exp( ms->ag[0][i][j] );
#      
#---------------------------------------------------------------------------#

# SO Inputs are: MCMC images; and matching cycle-spin coords.
#
# THEN for each MCMC image:
#    store in aggregate form (with cycle-spin)
#    CALCULATE sums and ratios
#    Re-store to new source-aggregate-files
#    --> Print out EACH level (within specified range) ???
#        Store in Humongous Fits file -- or multiple FITS files
#        (the later will make nicer movies...)
## Taken out -- do below in separate module.
#    --> Keep track of MEAN at ALL levels
#        (higher moments as well??)
#
#

    #  Initializing other possible inputs:
    
    #    0) INPUT: FITS-style data, cycle-spin vectors:
    
        OldHeader = InMCMCImageHDU.header
        print 'Reading in MCMC Sample Imgae data with shape: ', InMCMCImageHDU.data.shape
    
        naxis1 = InMCMCImageHDU.header['naxis1']
        naxis2 = InMCMCImageHDU.header['naxis2']
        dim = naxis1
        if dim != naxis2 :
            print '\n'
            print 'Aggregate_Scales FATAL Input Error.  Need square images, but naxis 1=',dim,
            print ' naxis2 = ',InMCMCImageHDU.header['naxis2']
            print
            print
            raise TypeError
    
    # ln(2^a) = a*ln(2). SO a = ln(naxis0)/ln(2)
        powerof2 = int(n.log(naxis1)/n.log(float(2)))
        if float(powerof2) != n.log(naxis1)/n.log(float(2)) :
            print '\n'
            print 'Aggregate_Scales FATAL Input Error.  Need image dimensions a square power of 2,'
            print ' but naxis 1=',dim,' and naxis2 = ',InMCMCImageHDU.header['naxis2']
            print ' So calculated power of 2 of ', n.log(naxis1)/n.log(float(2)),' is not an integer.'
            print
            print
            raise TypeError
    
        if     (want_levels[1] < want_levels[0] ):
            want_levels[0], want_levels[1] = 0, powerof2+1
        else:
            want_levels[0] = max( want_levels[0], 0 )
            want_levels[1] = min( want_levels[0], powerof2+1 )
        #end-if
    
        naxis3 = InMCMCImageHDU.header['naxis3']
        # ranges must match - sometimes a glitch in file-writing. So use minumim:
        num_useful_images = min(naxis3,len(InMCMCParams[0]))
    
    #    1) For this level for each image:
        print ' InMCMCParams[0:1][image_in]: ', \
                InMCMCParams
    
        this_ms_ag = n.zeros((powerof2+1,naxis2,naxis1))
        this_ms_av = n.zeros((powerof2+1,naxis2,naxis1))
        this_ratio = n.ones((powerof2+1,naxis2,naxis1))
        avcountlst, avratiolst = [], []
        sgcountlst, sgratiolst = [], []
        this_block_sz = 1
        for now_do_level in range(want_levels[0],want_levels[1]) :
        #
            if ( now_do_level > 0 ):
                this_block_sz = this_block_sz*2
            else:
                this_block_sz = 1
            #end-if
            a_this_blocks = float(this_block_sz*this_block_sz)  #Blocks Area
            #
            this_cts_filename = OutCtsMovieFitsFileStem+'_Lvl'+str(now_do_level)+'.fits'
            this_rat_filename = OutRatMovieFitsFileStem+'_Lvl'+str(now_do_level-1)+'.fits'
            OutMCMCImagCount = n.zeros((num_useful_images,naxis2,naxis1))
            OutMCMCImagRatio = n.ones((num_useful_images,naxis2,naxis1))
            #
            for image_in in range(num_useful_images): # Begin Loop over all sample images/movie frames
                print '\n* image_in: ', image_in,' InMCMCParams[0:1][image_in]: ', \
                    InMCMCParams[0][image_in], InMCMCParams[1][image_in]
                this_spin_row, this_spin_col = InMCMCParams[0][image_in], InMCMCParams[1][image_in]
    
    #        2) CYCLE-SPIN this image:
                # Following the C-code:
                for j in range(dim):
                    for i in range(dim):
                        this_ms_ag[0][j,i] = InMCMCImageHDU.\
                        data[image_in][n.mod(j+this_spin_col,dim),n.mod(i+this_spin_row,dim)]
                    #end-for-i
                #end-for-j
                this_ms_av[0] = this_ms_ag[0]
    
    #        3) Compute aggregations: (Now done via numpy instead of translation from "c").
             
                #
                for j in range(0,dim,this_block_sz):
                    for i in range(0,dim,this_block_sz):
                        try:
                            this_sum = this_ms_ag[0] \
                                [j:j+this_block_sz, \
                                 i:i+this_block_sz].sum()
                        except:
                            print 'At level=',now_do_level,' indices: i j:', i,j,' block sz:',this_block_sz,' new j, i bounds:', 
                            print j,j+this_block_sz,
                            print i,i+this_block_sz
                            print 'OUT OF BOUNDS!!!'
                            raise IndexError
                        if ( now_do_level > 0 ):
                            # store in aggregate array:
                            this_ms_ag[now_do_level] \
                                [j:j+this_block_sz, \
                                 i:i+this_block_sz] = \
                                this_sum
                            # compute ratio given previous levels:
                            if ( this_sum > 0. ):
                                #
                                this_ratio[now_do_level-1]  \
                                    [j:j+this_block_sz, \
                                     i:i+this_block_sz] = \
                                    this_ms_ag[now_do_level-1] \
                                    [j:j+this_block_sz, \
                                     i:i+this_block_sz] \
                                  / this_ms_ag[now_do_level] \
                                    [j:j+this_block_sz, \
                                     i:i+this_block_sz]
                            else:
                                #
                                this_ratio[now_do_level-1]  \
                                    [j:j+this_block_sz, \
                                     i:i+this_block_sz] = 0.
                            #end-if
                        #end-if
    ##              } /*end loop over columns of ms.ag[level] */
    ##          } /* end loop over rows of ms.ag[level] */
    #
    #           Now for visualizaton spread the average into the number of pixels it came from:
                this_ms_av[now_do_level] = this_ms_ag[now_do_level]/a_this_blocks
    
            #  4) Store in new ratios/aggregate_ms images AND Calculate means:
    #  /        ******************* Store new image in src.img *******************/
    #           dim = src->nrow;
    #           for(i=0; i< dim; i++)
    #              for(j=0; j<dim; j++)
    #                src->img[(i+spin_row)%dim][(j+spin_col)%dim] = exp( ms->ag[0][i][j] );
    #              
    
                for j in range(0,dim):
                    for i in range(0,dim):
    ##                  src->img[(i+spin_row)%dim][(j+spin_col)%dim] = exp( ms->ag[0][i][j] );
                        OutMCMCImagCount[image_in] \
                        [ n.mod( (j+this_spin_col),dim) , n.mod( (i+this_spin_row),dim) ] = \
                        this_ms_av[now_do_level][j,i]
                        if ( now_do_level > 0 ):
                            OutMCMCImagRatio[image_in] \
                            [ n.mod( (j+this_spin_col),dim) ,  n.mod( (i+this_spin_row),dim) ] = \
                            this_ratio[now_do_level-1][j,i]
                        #end-if
                    #end-for-i
                #end-for-j
    
            #end-for-image_in
    
    #       5) Write out each image, as requested:
    #       IE UPDATE the various level data to the appropriate FITS files!
            OutMCMCImagCountHDU = pyfits.PrimaryHDU(header=OldHeader,data=OutMCMCImagCount)
            OutMCMCImagCountHDU.writeto(this_cts_filename)
            meancts = n.asarray(OutMCMCImagCount.mean(axis=0) )
            diffcts = n.asarray(OutMCMCImagCount - meancts)
            varicts = n.asarray(diffcts*diffcts).mean(axis=0)
            avcountlst.append( meancts )
            sgcountlst.append( n.sqrt(varicts) )
    
            if( now_do_level > 0 ):
                OutMCMCImagRatioHDU = pyfits.PrimaryHDU(header=OldHeader,data=OutMCMCImagRatio)
                OutMCMCImagRatioHDU.writeto(this_rat_filename)
                meanrat = n.asarray(OutMCMCImagRatio.mean(axis=0) )
                diffrat = n.asarray(OutMCMCImagRatio - meanrat)
                varirat = n.asarray(diffrat*diffrat).mean(axis=0)
                avratiolst.append( meanrat )
                sgratiolst.append( n.sqrt(varirat) )
            #end-if
    
    #   end-for-level

        self.nk_scales_counts = OutMCMCImagCount
        self.nk_scales_ratios = OutMCMCImagRatio
        self.nk_scales_counts_mean = n.asarray(avcountlst)
        self.nk_scales_counts_sigm = n.asarray(sgcountlst)
        self.nk_scales_ratios_mean = n.asarray(avratiolst)
        self.nk_scales_ratios_sigm = n.asarray(sgratiolst)

#
#end.

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
# This next series of modules is for:
# reading MC "movies" of images in fits format and sorting pixels in intensity order;
# Finding an extra simple version of confidence bands (i.e. [.10, .90] or [.9545, .6723, .5, .3287, .0455]);
#      and writing out 'images' for each confidence band
# and writing them out in fits form compatible with
# CHASC/LIRA imaging software.
#

#------------------------------------------------------------------------------#
    def SortMovieMatrix(self,InFitsMovieFileName,NumBurnIn):
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
#
#   End.

#-------------------------------------------------------------------------------#

    def ImageConfBands(self,UnsortedMovieImageHDU,Exp2DData, \
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
#------------------------------------------------------------------------------#

def get_R_table( InRTxtFileName, \
    header = True, sep=' ', nrows=-1, skip=0, comment_char = "#" ):

    ## Initialize handy variables:

    ##  Read in file into one long string:
    image_in = open(InRTxtFileName,'r')

    ##  Parse it line-by-line, following "R" format:
    lline = -1
    OutTable = []
    header_read = False
    for this_line in image_in :
        lline += 1
        if (this_line[0] != comment_char) and (lline <= nrows or nrows < 0):
            if( lline > skip ) :
                if( header and not header_read ) :
                ##  Get header and number of variables, to start, following R-form:
                    header_line = this_line
                    header_string_vec = header_line.split(sep)
                    # cleanup:
                    num_extra = header_string_vec.count('')
                    for iextra in range(num_extra):
                        header_string_vec.remove('')
                    try:
                        header_string_vec.remove('\n')
                    except:
                        continue
                    #end Cleanup
                    num_of_cols = len(header_string_vec)
                    print '\n** get_Rfile_ascii_table_params: lline:', lline
                    print '** get_Rfile_ascii_table_params: number of columns:', num_of_cols,
                    print 'from header line:\n', header_string_vec
                    print
                    header_read = True
                elif (not header and not header_read ):
                    header_string_vec = this_line.split(sep)
                    # cleanup:
                    num_extra = header_string_vec.count('')
                    for iextra in range(num_extra):
                        header_string_vec.remove('')
                    try:
                        header_string_vec.remove('\n')
                    except:
                        continue
                    #end Cleanup
                    num_of_cols = len(test_string_vec)
                    header_string_vec = num_of_cols*['',]
                    print '\n** get_Rfile_ascii_table_params: lline:', lline
                    print '\n** get_Rfile_ascii_table_params: number of columns:', num_of_cols,
                    print 'from 1st line:\n', test_string_vec
                    print
                    header_read = True
                #End-if-header
                else: # Must be real data:
                    line_nums_vec = this_line.split(sep)
                    print '\n** get_Rfile_ascii_table_params: lline:', lline,
                    # cleanup:
                    num_extra = line_nums_vec.count('')
                    for iextra in range(num_extra):
                        line_nums_vec.remove('')
                    try:
                        line_nums_vec.remove('\n')
                    except:
                        continue
                    #end Cleanup
                    #
                    print line_nums_vec
                    if( num_of_cols != len(line_nums_vec) ):
                        print 'Fatal get_Rfile_ascii_table_params error.'
                        print 'First line indicated ', num_of_cols,' columns. '
                        print 'But line indicates ',len(line_nums_vec),'\n', line_nums_vec
                        print
                        raise TypeError
                    #
                    # Turning the string list into a numbers list:
                    nums_vec = []
                    for icol in range(num_of_cols):
                    #    print '\n** get_Rfile_ascii_table_params: line_nums_vec[icol]: ',line_nums_vec[icol]
                    #    print 'Type( nums_vec) = ', type(nums_vec),' Type(line_nums_vec[icol])=',type(line_nums_vec[icol])
                        nums_vec.append( float(line_nums_vec[icol]) )
                    #
                    OutTable.append(nums_vec)
                #End-if-header-or-data
            #End-if-lline > nskip
        #end-if-not-comment  and (lline < nrows or nrows < 0)
    #end-for-this_line

    return [header_string_vec, n.asarray(OutTable) ]
