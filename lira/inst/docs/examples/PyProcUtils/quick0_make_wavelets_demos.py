#--------Initialize packages: ------------------------------
from numpy import *
import scipy as s
import pyfits

#-------Define what we're doing:----------------------------

def Quick0MexicanHatAtom( xcovariate ):

    # This simple popular wavelet 'mother' is the 2nd derivative of a Gaussian.
    # Notice that this is ONLY the basic shape; to geth the full wavelets, you
    # need translation/shifting: xcovariate= (t-u)/s; normprime = norm*sqrt(scale)
    
    # Also, we are assuming that full-range for MH is -4.,4.
    # So we need to re-scale this.

    if len(xcovariate) <= 0 :
        return 0.
    else:
        xprime = xcovariate

    exponent = xprime*xprime
    if len(xcovariate) == 1 :
        # This is the formula for the 2nd derivative. If there is only one bin, use this:
        D2derivs = 1. - exponent
        return  D2derivs*exp(-exponent/2.)
    else:
        # Use the 1st deriv to integrate over the bin:
        Del = (xprime[-1] - xprime[0])/float(len(xcovariate))
        x0, x1 = xcovariate-Del/2., xcovariate+Del/2.
        exp0, exp1 = -x0*x0/2., -x1*x1/2.
        D1deriv0, D1deriv1 = -x0, -x1
        result = -D1deriv1*exp(exp1) + D1deriv0*exp(exp0)   # Inelegant!!!
        return result/Del

#-------Define what we're doing:----------------------------

def Quick00MexicanHatAtom( xcovariate ):

    # This simple popular wavelet 'mother' is the 2nd derivative of a Gaussian.
    # Notice that this is ONLY the basic shape; to geth the full wavelets, you
    # need translation/shifting: xcovariate= (t-u)/s; normprime = norm*sqrt(scale)
    
    # Also, we are assuming that full-range for MH is -4.,4.
    # So we need to re-scale this.

    if len(xcovariate) <= 0 :
        return 0.
    else:
        xprime = xcovariate

    exponent = xprime*xprime
    if len(xcovariate) >= 1 :
        # This is the formula for the 2nd derivative. If there is only one bin, use this:
        D2derivs = 1. - exponent
        result = D2derivs*exp(-exponent/2.)
        return  result

#-------Define what we're doing:----------------------------

def Quick0MexicanHat( tcovariate, scale=1., shift = 0.):
    sys_small = 1.e-72

    if abs(scale) > sys_small :		# Check for zeros
        xcovariate = (tcovariate - shift)/scale # Not Sure This is OK!!!!
        result = Quick0MexicanHatAtom(xcovariate)/sqrt(scale)
        return result
    else:
        return zeros(tcovariate.shape)

#-------Define what we're doing:----------------------------

def Quick0MultiresMexicanHat(realcovariate):

    # Handy constant:
    powersof2_tuple = \
    (1, 2, 4, 8, 16, 32, 64, 128, 256,  512,  1024, \
     2048, 4096, 8192, 16384, 32768, 65536, 131072, \
     262144, 524288, 1048576)
    ln_2 = log(2.)

    # Get spacing -- real input, and next power-of-two:
    len_real = len(realcovariate)

    # Error checking:
    if len_real == 0:
        print 'Quick0MultiresMexicanHat Fatal Input Error.'
        print '  Input covariate must have length > 0, but was given: ', realcovariate
        raise TypeError

    if len_real > 1048576 :
        JJ = int(log(len_real)/ln_2)
    else:
        JJ = 0
        for j in range( len(powersof2_tuple) ):
            if JJ == 0 and len_real <= powersof2_tuple[j] :
                JJ = j + 1
        #end for
    #end-if

    # Now work through the different scales:
    # For the Multi-Res, we will use JJ scales.
    # So the output will be an array of size JJ X len_real:
    result = zeros((JJ,len_real))
    # re-scale realcov to match multi-res format:
    center = (realcovariate[-1] + realcovariate[0])/2.
    length = (realcovariate[-1] - realcovariate[0])
    rescl_cov = ( realcovariate - center ) / length
    rescl_cov = rescl_cov  # Special for Mexican Hat
    

    # Now do each scale, from the finest to the broadest:
    for jlevel in range(0, JJ ):
        jth_resol_len = powersof2_tuple[jlevel]
        num_vecs = int(len_real/jth_resol_len)
        realscale = float( powersof2_tuple[JJ-jlevel] )
        #print '\n DEBUG: jlevel: ',jlevel,' resol_len:',jth_resol_len,' num_vecs: ', num_vecs
        # Fill up this row:
        for k in range(num_vecs) :
            tempcov = rescl_cov[ k*jth_resol_len : (k+1)*jth_resol_len ]
            realshift = (tempcov[0] + tempcov[-1])/2.
            #CHECK realvalue = Quick0MexicanHatAtom( tempcov)
            #realvalue = Quick0MexicanHat( tempcov, shift=realshift, scale=(1./realscale))/sqrt(realscale)
            realvalue = Quick0MexicanHat( rescl_cov, shift=realshift, scale=(1./realscale))/sqrt(realscale)
            #result[jlevel][k*jth_resol_len:(k+1)*jth_resol_len] = realvalue
            result[jlevel] += realvalue
            #print 'Cov: ',k*' ',tempcov
            #print 'Val: ',k*' ',realvalue
            #print result[jlevel]
        #end-for-each-k-shift
    #end-for-each-jlevel

    return result

#--------------------------------------------------------------------------------------------------#

#-------On to Haar wavelet:------------------------------------------------------------------------#

def Quick0HaarAtom( xcovariate ):

    # This simple popular wavelet 'mother' is a boxy up-and-down on -1/2,1/2.
    # Notice that this is ONLY the basic shape; to get the full wavelets, you
    # need translation/shifting: xcovariate= (t-u)/s; normprime = norm*sqrt(scale)
    
    # Also, we are assuming that full-range for Haar is -1/2,1/2.
    HaarLim = (-0.5, 0., 0.5 )
    if len(xcovariate) <= 0 :
        result = asarray([0.,])
        return result
    else:
        xprime = xcovariate


    if len(xcovariate) == 1 :
        # This is the formula for the point estimat. If there is only one bin, use this:
        if ( Haarlim[0] <= xprime ) and (xprime < HaarLim[1] ) :
            result = asarray([-1.,])
        elif ( HaarLim[1] <= xprime ) and (xprime < HaarLim[2] ) :
            result = asarray([1.,])
        else:
            result = asarray([0.,])
        return result
    else:
        result = zeros(xcovariate.shape)
        ## Really should average over the bin:
        Del = (xprime[-1] - xprime[0])/float(len(xprime))
        #
        ## Now loop through all bins, doing the necessary 10 cases:
        for k in range( len(xprime) ) :
            #
            x0, x1 = xprime[k]-Del/2., xprime[k]+Del/2.
            #
            # Case A: bin is wholly below lower limit:
            if ( x1 <= HaarLim[0] ) :
                result[k] = 0.
                #print 'Case A: ', k, xprime[k], result[k] 
                #
            # Case B: bin partly below lower limit and all below midpoint:
            elif ( x0 <= HaarLim[0] ) and ( x1 <= HaarLim[1] ):
                fraction0 = (x1-HaarLim[0])/Del
                result[k] = -1.*fraction0
                #print 'Case B: ', k, xprime[k], fraction0, result[k] 
                #
            # Case C: bin partly below lower limit and above mid, and all below upper limit
            elif ( x0 <= HaarLim[0] ) and ( HaarLim[2] <= x1) and ( x1 <= HaarLim[2] ):
                fraction0 = (HaarLim[1] - x0)/Del
                fraction1 = (x1 - HaarLim[1])/Del
                result[k] = -1.*fraction0 + 1.*fraction1
                #print 'Case C: ', k, xprime[k], fraction0, fraction1, result[k] 
                #
            # Case D: bin partly below lower limit and above upper limit
            elif ( x0 <= HaarLim[0] ) and ( HaarLim[2] <= x1 ):
                result[k] = 0.
                #print 'Case D: ', k, xprime[k], result[k] 
                #
            # Case E: bin wholly above lower limit and wholly below midpoint:
            elif ( HaarLim[0] <  x0 ) and ( x1 <= HaarLim[1] ):
                result[k] = -1.
                #print 'Case E: ', k, xprime[k], result[k] 
                #
            # Case F: bin wholly above lower limit and partly below/above midpoint and all below upper lim:
            elif ( HaarLim[0] <  x0 ) and ( x0 <= HaarLim[1]) and (  HaarLim[1] < x1 ) and (x1 <= HaarLim[2]) :
                fraction0 = (HaarLim[1]-x0)/Del
                fraction1 = (x1-HaarLim[1])/Del
                result[k] = -1.*fraction0 + 1.*fraction1
                #print 'Case F: ', k, xprime[k], fraction0, fraction1, result[k] 
                #
            # Case G: bin wholly above lower limit and below midpoint and partly above upper lim:
            elif ( HaarLim[0] <  x0 ) and ( x0 <= HaarLim[1] ) and (  HaarLim[2] <= x1 ) :
                fraction0 = (HaarLim[1]-x0)/Del
                fraction1 = 1.
                result[k] = -1.*fraction0 + 1.*fraction1
                #print 'Case G: ', k, xprime[k], fraction0, fraction1, result[k] 
                #
            # Case H: bin wholly above mid-point and wholly below upper lim:
            elif ( HaarLim[1] <  x0 ) and (  x1 <= HaarLim[2] ) :
                result[k] = +1.
                #print 'Case G: ', k, xprime[k], result[k] 
                #
            # Case I: bin wholly above mid-point and partly below upper lim:
            elif ( HaarLim[1] <  x0 ) and ( x0 <= HaarLim[2]) and (  HaarLim[2] < x1 ) :
                fraction1 = ( HaarLim[2]-x0 )/Del
                result[k] = 1.*fraction1
                #print 'Case I: ', k, xprime[k], fraction1, result[k] 
                #
            # Case J: bin is wholly above upper limit:
            elif (  HaarLim[2] <= x0 ) :
                result[k] = 0.
                #print 'Case J: ', k, xprime[k], result[k] 
                #
            ##end-if-then-else
        ##end-for-loop

        return result

#-------Define what we're doing:----------------------------

def Quick00HaarAtom( xcovariate ):

    # This simple popular wavelet 'mother' is a down-and-up box.
    # Notice that this is ONLY the basic shape; to geth the full wavelets, you
    # need translation/shifting: xcovariate= (t-u)/s; normprime = norm*sqrt(scale)
    
    # Also, we are assuming that full-range for Haar -1/2,1/2
    # So we need to keep rtack of all the limits.

    HaarLim = ( -0.5, 0., 0.5 )
    
    if len(xcovariate) <= 0 :
        return 0.
    else:
        xprime = xcovariate

    result = zeros(xcovariate.shape)
    for k in range( len(xcovariate) ):
        ## Now only 4 cases since this is the 'point estimate only' version:
        if ( xprime[k] <= HaarLim[0] ):
            result[k] = 0.
            #print 'Case A: ', k, xprime[k], result[k] 
        elif ( HaarLim[0] < xprime[k] ) and ( xprime[k] <= HaarLim[1] ) :
            result[k] = -1.
            #print 'Case B: ', k, xprime[k], result[k] 
        elif ( HaarLim[1] < xprime[k] ) and (xprime[k] <= HaarLim[2] ):
            result[k] = +1.
            #print 'Case C: ', k, xprime[k], result[k] 
        elif ( HaarLim[2] < xprime[k] ):
            result[k] = 0.
            #print 'Case D: ', k, xprime[k], result[k] 

    return  result

#-------Define what we're doing:----------------------------

def Quick0Haar( tcovariate, scale=1., shift = 0.):
    sys_small = 1.e-72

    if abs(scale) > sys_small :		# Check for zeros
        xcovariate = (tcovariate - shift)/scale # Not Sure This is OK!!!!
        result = Quick0HaarAtom(xcovariate)/sqrt(scale)
        return result
    else:
        return zeros(tcovariate.shape)

#-------Define what we're doing:----------------------------

def Quick0MultiresHaar(realcovariate):

    # Handy constant:
    powersof2_tuple = \
    (1, 2, 4, 8, 16, 32, 64, 128, 256,  512,  1024, \
     2048, 4096, 8192, 16384, 32768, 65536, 131072, \
     262144, 524288, 1048576)
    ln_2 = log(2.)

    # Get spacing -- real input, and next power-of-two:
    len_real = len(realcovariate)

    # Error checking:
    if len_real == 0:
        print 'Quick0MultiresHaar Fatal Input Error.'
        print '  Input covariate must have length > 0, but was given: ', realcovariate
        raise TypeError

    if len_real > 1048576 :
        JJ = int(log(len_real)/ln_2)
    else:
        JJ = 0
        for j in range( len(powersof2_tuple) ):
            if JJ == 0 and len_real <= powersof2_tuple[j] :
                JJ = j + 1
        #end for
    #end-if

    # Now work through the different scales:
    # For the Multi-Res, we will use JJ scales.
    # So the output will be an array of size JJ X len_real:
    result = zeros((JJ+1,len_real))
    # re-scale realcov to match multi-res format:
    center = (realcovariate[-1] + realcovariate[0])/2.
    length = (realcovariate[-1] - realcovariate[0])
    rescl_cov = ( realcovariate - center ) / length
    rescl_cov = rescl_cov*0.5    #Special for Haar??    

    # Now do each scale, from the finest to the broadest:
    for jlevel in range(0, JJ+1 ):
        jth_resol_len = powersof2_tuple[jlevel]
        num_vecs = int(len_real/jth_resol_len)
        realscale = float( powersof2_tuple[JJ-jlevel] )
        #print '\n DEBUG: jlevel: ',jlevel,' resol_len:',jth_resol_len,' num_vecs: ', num_vecs
        # Fill up this row:
        for k in range(num_vecs) :
            tempcov = rescl_cov[ k*jth_resol_len : (k+1)*jth_resol_len ]
            realshift = (tempcov[0] + tempcov[-1])/2.
            #CHECK realvalue = Quick0HaarAtom( tempcov)
            #realvalue = Quick0Haar( tempcov, shift=realshift, scale=(1./realscale))/sqrt(realscale)
            realvalue = Quick0Haar( rescl_cov, shift=realshift, scale=(1./realscale))/sqrt(realscale)
            #result[jlevel][k*jth_resol_len:(k+1)*jth_resol_len] = realvalue
            result[jlevel] += realvalue
            #print 'Cov: ',k*' ',tempcov
            #print 'Val: ',k*' ',realvalue
            #print result[jlevel]
        #end-for-each-k-shift
    #end-for-each-jlevel

    return result


