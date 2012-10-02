from numpy import *
import pyfits

def quick0_gauss2d(xarray,yarray,Center=[0.,0.],Sig=1.) :

    # Quick 2d Gaussian PSF centered at center, wdth=Sig
    # Normed to unity.

    # Right now this is  point-estimate.
    # Eventualy it should be an average over the bins.

    result = zeros( [yarray.shape[1],xarray.shape[0] ] )
    Sig2 = Sig*Sig

    xprime = xarray - Center[1]
    yprime = yarray - Center[0]
    r2array = zeros(result.shape)
    for j in range( yprime.shape[1] ) :
        for i in range( xprime.shape[0] ) :
            r2array[j][i] = xprime[j][i]*xprime[j][i] + \
                            yprime[j][i]*yprime[j][i]
            #print j, i, ' x, y: ', xprime[j][i],yprime[j][i],
            #print ' r2: ', r2array[j][i]
    exponent = -r2array/2./Sig2
    norm = 1./(2.*pi*Sig*Sig)

    result = exp(exponent)*norm

    return result
