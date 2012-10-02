import numpy as n
import pyfits

def visualize_multiscales_in_samples(InMCMCImageHDULst, InMCMCParams,\
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

#    0) READ IN FITS, cycle-spin vectors:

    OldHeader = InMCMCImageHDULst[0].header
    print 'Reading in MCMC Sample Imgae data with shape: ', InMCMCImageHDULst[0].data.shape

    naxis1 = InMCMCImageHDULst[0].header['naxis1']
    naxis2 = InMCMCImageHDULst[0].header['naxis2']
    dim = naxis1
    if dim != naxis2 :
        print '\n'
        print 'Aggregate_Scales FATAL Input Error.  Need square images, but naxis 1=',dim,
        print ' naxis2 = ',InMCMCImageHDULst[0].header['naxis2']
        print
        print
        raise TypeError

# ln(2^a) = a*ln(2). SO a = ln(naxis0)/ln(2)
    powerof2 = int(n.log(naxis1)/n.log(float(2)))
    if float(powerof2) != n.log(naxis1)/n.log(float(2)) :
        print '\n'
        print 'Aggregate_Scales FATAL Input Error.  Need image dimensions a square power of 2,'
        print ' but naxis 1=',dim,' and naxis2 = ',InMCMCImageHDULst[0].header['naxis2']
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

    naxis3 = InMCMCImageHDULst[0].header['naxis3']
    # ranges must match - sometimes a glitch in file-writing. So use minumim:
    num_useful_images = min(naxis3,len(InMCMCParams[0]))

#    1) For this level for each image:
    print ' InMCMCParams[0:1][image_in]: ', \
            InMCMCParams

    this_ms_ag = n.zeros((powerof2+1,naxis2,naxis1))
    this_ms_av = n.zeros((powerof2+1,naxis2,naxis1))
    this_ratio = n.ones((powerof2+1,naxis2,naxis1))
    avcountlst, avratiolst = [], []
    this_block_sz = 1
    for now_do_level in range(want_levels[0],want_levels[1]) :
    #
        if ( now_do_level > 0 ):
            this_block_sz = this_block_sz*2
        else:
            this_block_sz = 1
        #end-if
        a_this_blocks = float(this_block_sz*this_block_sz)  #Blocks Area
        print '\nFor dim, now_do_level=',dim,now_do_level,
        print ' block size, block area: ',this_block_sz, a_this_blocks
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
                    this_ms_ag[0][j,i] = InMCMCImageHDULst[0].\
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
                        print 'At level=',now_do_level,'indices: i j:', i,j,' block sz: ',this_block_sz,' new j, i bounds:', 
                        print j,j+this_block_sz,
                        print i,i+this_block_sz,
                        print '  SUM: ', this_sum
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
                            print '+++>At SUM>0. case for this_sum=',this_sum,
                            print 'this_ms_ag[now_do_level-1] shape, value:\n ', \
                                this_ms_ag[now_do_level-1] \
                                [j:j+this_block_sz, \
                                 i:i+this_block_sz].shape, \
                                this_ms_ag[now_do_level-1] \
                                [j:j+this_block_sz, \
                                 i:i+this_block_sz] 
                            print 'this_ms_ag[now_do_level] shape, value:\n', \
                                this_ms_ag[now_do_level] \
                                [j:j+this_block_sz, \
                                 i:i+this_block_sz].shape, \
                                this_ms_ag[now_do_level] \
                                [j:j+this_block_sz, \
                                 i:i+this_block_sz]
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
                            print '--->At SUM=0. case for this_sum=',this_sum,
                            print 'this_ms_ag[now_do_level-1]:\n ', \
                                this_ms_ag[now_do_level-1] \
                                [j:j+this_block_sz, \
                                 i:i+this_block_sz] 
                            print 'this_ms_ag[now_do_level] ', \
                                this_ms_ag[now_do_level] \
                                [j:j+this_block_sz, \
                                 i:i+this_block_sz]
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
####        avcountlst.append[ n.asarray(OutMCMCImagCount.mean(axis=0) ) ]

        if( now_do_level > 0 ):
            OutMCMCImagRatioHDU = pyfits.PrimaryHDU(header=OldHeader,data=OutMCMCImagRatio)
            OutMCMCImagRatioHDU.writeto(this_rat_filename)
####            avratiolst.append[ n.asarray( OutMCMCImagRatio.mean(axis=0) ) ]
        #end-if

#   end-for-level

    return [n.asarray(avcountlst), n.asarray(avcountlst) ]
