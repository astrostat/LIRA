
wrkdir = '../exampledata/'
#filestem = '_128x128testE_conv_Gauss2d_Sig_1.5_17x17.101107a'
#ExpectToPoissTupleList = [
#    (wrkdir+'FullTrueModel'+filestem+'.fits',wrkdir+'PoisDatons'+filestem+'.fits'),
#  ]

filestem = '_128x128testE_conv_Gauss2d_Sig_1.5_17x17.101107a'
ExpectToPoissTupleList = [
    (wrkdir+'NullModel'+filestem+'.fits',wrkdir+'SimPois00'+filestem+'.fits'),
    (wrkdir+'NullModel'+filestem+'.fits',wrkdir+'SimPois01'+filestem+'.fits'),
    (wrkdir+'NullModel'+filestem+'.fits',wrkdir+'SimPois02'+filestem+'.fits'),
    (wrkdir+'NullModel'+filestem+'.fits',wrkdir+'SimPois03'+filestem+'.fits'),
    (wrkdir+'NullModel'+filestem+'.fits',wrkdir+'SimPois04'+filestem+'.fits'),
    (wrkdir+'NullModel'+filestem+'.fits',wrkdir+'SimPois05'+filestem+'.fits'),
  ]

#------------------------------------------------------------------#
#from numarray import * ## Changed to numpy Aug 2007
from numpy import *
import pyfits
#import random
import numpy
from run_simpler_skymap_datons import *
from simpler_skymap_datons import *

for this_expecteddata_tuple in ExpectToPoissTupleList:
    this_modeldata_fitsfile, this_OutPoisDatonsFitsFile = this_expecteddata_tuple
    this_modeldata_HDU = pyfits.open(this_modeldata_fitsfile)
#   "Touch" header and data to make sure they are read in:
    if( len(this_modeldata_HDU[0].data.shape) == 3 ) :
        print 'Input expected data cnts at 012:', this_modeldata_HDU[0].data[0][1][2]
    elif( len(this_modeldata_HDU[0].data.shape) == 2 ) :
        print 'Input expected data cnts at 012:', this_modeldata_HDU[0].data[1][2]
    print 'Input expected data cnts header:', this_modeldata_HDU[0].header
#
# 4/ Get some Poisson counts! what fun!!
#
    this_poisdatons_HDU = PoisDatonsHDU(this_modeldata_HDU[0],this_OutPoisDatonsFitsFile)
