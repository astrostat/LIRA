"""
@brief Series of skymap functions for GALPROP to sim EGRET datons
@author A. Connors
"""
# @file simpler_skymap_datons.py
#
#
#from numarray import * ## Changed to numpy Aug 2007
from numpy import *
import pyfits
###import random

class flux_skymap_of_galprop:
    def __init__(self, galprop_hdulist, want_e_band):
#
#       1/ Initialize data format, based on input galprop format:
#
        naxis1 = old_naxis1 = galprop_hdulist[0].header['NAXIS1']
        old_crval1 = galprop_hdulist[0].header['CRVAL1']
        cdelt1 = old_cdelt1 = galprop_hdulist[0].header['CDELT1']
        new_crval1 = old_crval1 -(old_naxis1/2)*old_cdelt1

        naxis2 = old_naxis2 = galprop_hdulist[0].header['NAXIS2']
        crval2 = old_crval2 = galprop_hdulist[0].header['CRVAL2']
        cdelt2 = old_cdelt2 = galprop_hdulist[0].header['CDELT2']

        old_naxis3 = galprop_hdulist[0].header['NAXIS3']
        old_crval3 = galprop_hdulist[0].header['CRVAL3']
        old_cdelt3 = galprop_hdulist[0].header['CDELT3']

        naxis = 3
        naxis3 = 1
        cdelt3 = 1.
        crval3 = 1.

        data0 = zeros((naxis3,naxis2,naxis1),dtype=float )
#        self = pyfits.PrimaryHDU(data0)	### PROBLEM WITH PASSING HDU FORMAT - KLUGE BELOW:
        self.data = data0
#        print 'Initializing flux_skymap_of_galprop as fits:',self.header, self.data
        self.header = galprop_hdulist[0].header
        print 'Reading in flux_skymap_of_galprop header:',self.header

#
#       2/ Transform from galprop units (i.e. *E_MeV^2) to intensity
#          Also switch to new galactic latitude start-place:
#          want -180 ==> +180 range, not 0 ==> 360 range.
#
#       2.1/ Find energies of bin edges and middle, from log10 energies:
        e_mev_bin = []
        HalfFact = 10**(old_cdelt3/2.00000000000)

        for i in range(old_naxis3):
            e_mev_mid = 10**( old_crval3 + (i*old_cdelt3) )
            e_mev_hi  = e_mev_mid*HalfFact
            e_mev_lo  = e_mev_mid/HalfFact
            e_mev_bin.append( [e_mev_lo,e_mev_mid,e_mev_hi] )
#       End of "for" loop

#       2.2/ Now integrate over all galprop energy bins within
#            energy band of interest:

        print 'Debug: naxis1, naxis2, old,new naxis3:', naxis1, naxis2, old_naxis3, naxis3
        print ' old:', galprop_hdulist[0].data
        print ' whatsup - new:',  self.data
        for i in range(old_naxis3):
#            print '*** i,e:',i, e_mev_bin[i][0], e_mev_bin[i][1], e_mev_bin[i][2]
            if(e_mev_bin[i][0] < want_e_band[0] and want_e_band[0] < e_mev_bin[i][2]):
                del_e_mev = (e_mev_bin[i][2]-want_e_band[0])
                if( del_e_mev < 0. ):
                    print ' del_e_mev Error: i,e:',i, e_mev_bin[i][0], e_mev_bin[i][1], e_mev_bin[i][2]
                    del_e_mev = 0.
                e_mid_binsq = e_mev_bin[i][1]*e_mev_bin[i][1]
                if( e_mev_bin[i][1] < 0. ):
                    print ' e_mev_bin Error: i,e:',i, e_mev_bin[i][0], e_mev_bin[i][1], e_mev_bin[i][2]
                    e_mev_bin[i][1] = 0.5
                for l in range(naxis1):
                    if(l >= naxis1/2):                   # Ooops for now 180=magicnumber=naxis1/2
                         new_l = l - naxis1/2
                    else:
                         new_l = l + naxis1/2
#                    print 'l, nl:',l,new_l,
                    for b in range(naxis2):
#                        print 'i: ',i,' l, new_l', l, new_l, ' b:',b,
#                        print 'self.data[0][b][new_l]:',self.data[0][b][new_l],
#                        print 'gp.data[0][i][b][l]:',galprop_hdulist[0].data[0][i][b][l]
                        if( galprop_hdulist[0].data[0][i][b][l] < 0. ):
#                            print ' galpropr Error: i,l,b,galprop:',i,l,b,galprop_hdulist[0].data[0][i][b][l]
                            pass
                        else:
                            self.data[0][b][new_l] = self.data[0][b][new_l] + del_e_mev*galprop_hdulist[0].data[0][i][b][l]/e_mid_binsq
#
            elif( want_e_band[0] <= e_mev_bin[i][0] and  e_mev_bin[i][2] <= want_e_band[1] ):
                del_e_mev =  (e_mev_bin[i][2]-e_mev_bin[i][0])
                e_mid_binsq = e_mev_bin[i][1]*e_mev_bin[i][1]
                for l in range(naxis1):
                    if(l >= naxis1/2):
                         new_l = l - naxis1/2
                    else:
                         new_l = l + naxis1/2
                    for b in range(naxis2):
                        if( galprop_hdulist[0].data[0][i][b][l] < 0. ):
#                            print ' galpropr Error: i,l,b,galprop:',i,l,b,galprop_hdulist[0].data[0][i][b][l]
                            pass
                        else:
                            self.data[0][b][new_l] = self.data[0][b][new_l] + del_e_mev*galprop_hdulist[0].data[0][i][b][l]/e_mid_binsq
#
            elif(e_mev_bin[i][0] < want_e_band[1] and want_e_band[1] < e_mev_bin[i][2]):
                del_e_mev = (want_e_band[1]-e_mev_bin[i][1])
                if( del_e_mev < 0. ):
                    print ' del_e_mev Error: i,e:',i, e_mev_bin[i][0], e_mev_bin[i][1], e_mev_bin[i][2]
                    del_e_mev = 0.
                e_mid_binsq = e_mev_bin[i][1]*e_mev_bin[i][1]
                if( e_mev_bin[i][1] < 0. ):
                    print ' e_mev_bin Error: i,e:',i, e_mev_bin[i][0], e_mev_bin[i][1], e_mev_bin[i][2]
                    e_mev_bin[i][1] = 0.5
                for l in range(naxis1):
                    if(l >= naxis1/2):
                         new_l = l - naxis1/2
                    else:
                         new_l = l + naxis1/2
                    for b in range(naxis2):
                        if( galprop_hdulist[0].data[0][i][b][l] < 0. ):
#                            print ' galpropr Error: i,l,b,galprop:',i,l,b,galprop_hdulist[0].data[0][i][b][l]
                            pass
                        else:
                            self.data[0][b][new_l] = self.data[0][b][new_l] + del_e_mev*galprop_hdulist[0].data[0][i][b][l]/e_mid_binsq
#           end if-else-loop

#      end loop over energy bins

#
#     3/ And finally, trying to update/clean out just the output header:
#
        self.header.__delitem__('NAXIS4')
        self.header.__delitem__('CRVAL4')
        self.header.__delitem__('CDELT4')

        self.header.update('NAXIS', 3)
        self.header.update('NAXIS3', 1)
        
        self.header.update( 'CRVAL1' , new_crval1)
        
        self.header.update( 'CRVAL3', 1.)
        self.header.update( 'CDELT3',1.)

#
#      --------    --------    --------   --------    #
#
    def increment_flux_by_next(self, next_galprop_hdulist, want_e_band):
#
#       1/ For this method, self is already assumed initialized to hdu format
#
        naxis1 = self.header['NAXIS1']
        crval1 = self.header['CRVAL1']
        cdelt1 = self.header['CDELT1']

        naxis2 = self.header['NAXIS2']
        crval2 = self.header['CRVAL2']
        cdelt2 = self.header['CDELT2']

        naxis3 = self.header['NAXIS3']
        crval3 = self.header['CRVAL3']
        cdelt3 = self.header['CDELT3']

        old_naxis1 = next_galprop_hdulist[0].header['NAXIS1']
        old_crval1 = next_galprop_hdulist[0].header['CRVAL1']
        old_cdelt1 = next_galprop_hdulist[0].header['CDELT1']

        old_naxis2 = next_galprop_hdulist[0].header['NAXIS2']
        old_crval2 = next_galprop_hdulist[0].header['CRVAL2']
        old_cdelt2 = next_galprop_hdulist[0].header['CDELT2']

        old_naxis3 = next_galprop_hdulist[0].header['NAXIS3']
        old_crval3 = next_galprop_hdulist[0].header['CRVAL3']
        old_cdelt3 = next_galprop_hdulist[0].header['CDELT3']

#
#       1.1/ Do both have same naxis, cdelt? 
#        epsilon = 1.e-5
        if naxis1 != old_naxis1:
            print 'Error: Array Dims mis-match:  data naxis1 ',naxis1,' is not equal to next_galprop naxis1:', old_naxis1
            return
        if naxis2 != old_naxis2:
            print 'Error: Array Dims mis-match:  data naxis2 ',naxis2,' is not equal to next_galprop naxis2:', old_naxis2
            return

#        if abs(cdelt1 -  old_cdelt1) > epsilon:
#            print 'Error: Array Dims mis-match:  data cdelt1 ',cdelt1,' is not equal to next_galprop cdelt1:', old_cdelt1
#            return
#        if abs(cdelt2 - old_cdelt2) > epsilon:
#            print 'Error: Array Dims mis-match:  data cdelt2 ',cdelt2,' is not equal to next_galprop cdelt2:', old_cdelt2
#            return

#        if abs(crval1 -  old_crval1) > epsilon:
#            print 'Error: Array Dims mis-match:  data crval1 ',crval1,' is not equal to next_galprop crval1:', old_crval1
#            return
#        if abs(crval2 - old_crval2) > epsilon:
#            print 'Error: Array Dims mis-match:  data crval2 ',crval2,' is not equal to next_galprop crval2:', old_crval2
#            return

#
#       2/ Transform next from next_galprop units (i.e. *E_MeV^2) to intensity
#          Also switch to new galactic latitude start-place:
#          want -naxis1/2 ==> +naxis1/2 range, not 0 ==> 360 range.
#
#       2.1/ Find energies of bin edges and middle, from log10 energies:
        e_mev_bin = []
        HalfFact = 10**(old_cdelt3/2.00000000000)

        for i in range(old_naxis3):
            e_mev_mid = 10**( old_crval3 + (i*old_cdelt3) )
            e_mev_hi  = e_mev_mid*HalfFact
            e_mev_lo  = e_mev_mid/HalfFact
            e_mev_bin.append( [e_mev_lo,e_mev_mid,e_mev_hi] )
#       End of "for" loop

#       2.2/ Now integrate over all next_galprop energy bins within
#            energy band of interest:

        print 'Debug: naxis1, naxis2, old,new naxis3:', naxis1, naxis2, old_naxis3, naxis3
        print 'old,new:', next_galprop_hdulist[0].data.shape, self.data.shape
        for i in range(old_naxis3):
#            print '*** i,e:',i, e_mev_bin[i][0], e_mev_bin[i][1], e_mev_bin[i][2]
            if(e_mev_bin[i][0] < want_e_band[0] and want_e_band[0] < e_mev_bin[i][2]):
                del_e_mev = (e_mev_bin[i][2]-want_e_band[0])
                if( del_e_mev < 0. ):
                    print ' del_e_mev Error: i,e:',i, e_mev_bin[i][0], e_mev_bin[i][1], e_mev_bin[i][2]
                    del_e_mev = 0.
                e_mid_binsq = e_mev_bin[i][1]*e_mev_bin[i][1]
                if( e_mev_bin[i][1] < 0. ):
                    print ' e_mev_bin Error: i,e:',i, e_mev_bin[i][0], e_mev_bin[i][1], e_mev_bin[i][2]
                    e_mev_bin[i][1] = 0.5
                for l in range(naxis1):
                    if(l >= naxis1/2):                   # Ooops for now 180=magicnumber=naxis1/2
                         new_l = l - naxis1/2
                    else:
                         new_l = l + naxis1/2
#                    print 'l, nl:',l,new_l,
                    for b in range(naxis2):
#                        print 'i: ',i,' l, new_l', l, new_l, ' b:',b,
#                        print 'self.data[0][b][new_l]:',self.data[0][b][new_l],
#                        print 'gp.data[0][i][b][l]:',next_galprop_hdulist[0].data[0][i][b][l]
                        if( next_galprop_hdulist[0].data[0][i][b][l] < 0. ):
#                            print ' galpropr Error: i,l,b,galprop:',i,l,b,next_galprop_hdulist[0].data[0][i][b][l]
                            pass
                        else:
                            self.data[0][b][new_l] = self.data[0][b][new_l] + del_e_mev*next_galprop_hdulist[0].data[0][i][b][l]/e_mid_binsq
#
            elif( want_e_band[0] <= e_mev_bin[i][0] and  e_mev_bin[i][2] <= want_e_band[1] ):
                del_e_mev =  (e_mev_bin[i][2]-e_mev_bin[i][0])
                e_mid_binsq = e_mev_bin[i][1]*e_mev_bin[i][1]
                for l in range(naxis1):
                    if(l >= naxis1/2):
                         new_l = l - naxis1/2
                    else:
                         new_l = l + naxis1/2
                    for b in range(naxis2):
                        if( next_galprop_hdulist[0].data[0][i][b][l] < 0. ):
#                            print ' galpropr Error: i,l,b,galprop:',i,l,b,next_galprop_hdulist[0].data[0][i][b][l]
                            pass
                        else:
                            self.data[0][b][new_l] = self.data[0][b][new_l] + next_galprop_hdulist[0].data[0][i][b][l]/e_mid_binsq
#
            elif(e_mev_bin[i][0] < want_e_band[1] and want_e_band[1] < e_mev_bin[i][2]):
                del_e_mev = (want_e_band[1]-e_mev_bin[i][1])
                if( del_e_mev < 0. ):
                    print ' del_e_mev Error: i,e:',i, e_mev_bin[i][0], e_mev_bin[i][1], e_mev_bin[i][2]
                    del_e_mev = 0.
                e_mid_binsq = e_mev_bin[i][1]*e_mev_bin[i][1]
                if( e_mev_bin[i][1] < 0. ):
                    print ' e_mev_bin Error: i,e:',i, e_mev_bin[i][0], e_mev_bin[i][1], e_mev_bin[i][2]
                    e_mev_bin[i][1] = 0.5
                for l in range(naxis1):
                    if(l >= naxis1/2):
                         new_l = l - naxis1/2
                    else:
                         new_l = l + naxis1/2
                    for b in range(naxis2):
                        if( next_galprop_hdulist[0].data[0][i][b][l] < 0. ):
#                            print ' galpropr Error: i,l,b,galprop:',i,l,b,next_galprop_hdulist[0].data[0][i][b][l]
                            pass
                        else:
                            self.data[0][b][new_l] = self.data[0][b][new_l] + del_e_mev*next_galprop_hdulist[0].data[0][i][b][l]/e_mid_binsq
#           end if-else-loop

#      end loop over energy bins

#
#     3/ And finally, trying to update the output header:
#

#
#      --------    --------    --------   --------    #
#
    def muliply_bin_by_solid_angle(self,NiceTempFileOfSomeSort):

        DegToRad = pi/180.
#
#       1/ For this method, self is already assumed initialized to hdu format
#
        naxis1 = self.header['NAXIS1']
        crval1 = self.header['CRVAL1']
        cdelt1 = self.header['CDELT1']

        naxis2 = self.header['NAXIS2']
        crval2 = self.header['CRVAL2']
        cdelt2 = self.header['CDELT2']

        naxis3 = self.header['NAXIS3']
        crval3 = self.header['CRVAL3']
        cdelt3 = self.header['CDELT3']
#

#
#       2/ Transform from intensity per solid angle to intensity per bin
#
#       2.1/ Find latitude of bin edges and middle, from naxis 2 entries
        for gal_lat_index in range(naxis2):
#            gal_mid_latitude.append(float(gal_lat_index)*cdelt2 + crval2)
            gal_mid_latitude = float(gal_lat_index)*cdelt2 + crval2

#       2.2/ Now get that DeltaSolid Angle_{ij}
#            = \int_{b_i}^{b_{i+1}} \int_{l_j}^{l_{j+1}} dl db cos b
            sine_lo_latitude = sin(DegToRad*gal_mid_latitude - (cdelt2/2.))
            sine_hi_latitude = sin(DegToRad*gal_mid_latitude + (cdelt2/2.))
#            ** NOTICE that for now it assumes there is NO dependence on Longitude ***
            Delta_solid_angle = (sine_hi_latitude - sine_lo_latitude)*cdelt1*DegToRad

#       2.3/ Now use this to transform units from intensity/sterradian to intensity/bin:
            for gal_lon_index in range(naxis1):
                self.data[0][gal_lat_index][gal_lon_index] = self.data[0][gal_lat_index][gal_lon_index]*Delta_solid_angle

#       End of "for" loop

#
#      --------    --------    --------   --------    #

#------------------------------------------------------------------------------------------
#
class simpler_sum_rebin:
    def __init__(self, bigskymap_hdu, want_rebinfact,which3rdbin):
#
#       1/ Initialize data format, based on input bigskymap format:
#
#       1.1/ Initialize header:

#       1.1.1/ Transform Old Axis Descriptions Into New:
#     Warning!  Doesn't always transform "cdelt" and "crval" properly!! **
        old_naxis1 = bigskymap_hdu.header['NAXIS1']
        naxis1 = old_naxis1/want_rebinfact[0]
#        old_cdelt1 = bigskymap_hdu.header['CDELT1']
#        cdelt1 = old_cdelt1*want_rebinfact[0]
#        old_crval1 = bigskymap_hdu.header['CRVAL1']
#        crval1 = old_crval1 + (want_rebinfact[0]*old_cdelt1/2.0000)	# Use bin median (middle) as new crval

        old_naxis2 = bigskymap_hdu.header['NAXIS2']
        naxis2 = old_naxis2/want_rebinfact[1]
#        old_cdelt2 = bigskymap_hdu.header['CDELT2']
#        cdelt2 = old_cdelt2*want_rebinfact[1]
#        old_crval2 = bigskymap_hdu.header['CRVAL2']
#        crval2 = old_crval2 + (want_rebinfact[1]*old_cdelt2/2.0000)	# Use bin median (middle) as new crval

#        naxis3 = old_naxis3 = bigskymap_hdu.header['NAXIS3']
#        crval3 = old_crval3 = bigskymap_hdu.header['CRVAL3']
#        cdelt3 = old_cdelt3 = bigskymap_hdu.header['CDELT3']
        naxis3 = 1
        old_naxis3 = 1

        ## CHECK if this is a rank 3 (usual GRO) or rank 2 (usual X-ray) dataset!
        ##
        bigrank = len( bigskymap_hdu.data.shape)
        if   ( bigrank == 3 ) :
            data0 = zeros((naxis3,naxis2,naxis1),dtype=float )
        elif ( bigrank == 2 ) :
            data0 = zeros((naxis2,naxis1),dtype=float )
        else:
            print '\nFatal Error: wrong type of rank for input bigskymap_hdu.'
            print ' Need rank of 2 or 3, but shape was: ', bigskymap_hdu.data.shape
            raise TypeError

#        self = pyfits.PrimaryHDU(data0)	### PROBLEM WITH PASSING HDU FORMAT - KLUGE BELOW:
        self.data = data0
        self.header = bigskymap_hdu.header

#
#       2/ Transform data from bigskymap units (flux) by summing bins

        print 'Debug: naxis1, naxis2, old,new naxis3:', naxis1, naxis2, old_naxis3, naxis3
        print 'old,new:', bigskymap_hdu.data.shape, self.data.shape
        for l in range(old_naxis1):
            new_l = l/want_rebinfact[0]
            for b in range(old_naxis2):
                new_b = b/want_rebinfact[1]
#                print 'i: ',i,' l, new_l', l, new_l, ' b:',b, new_b
                if ( bigrank == 3) :
    #                print 'self.data[0][new_b][new_l]:',self.data[0][new_b][new_l],
    #                print 'gp.data[which3rdbin][i][b][l]:',bigskymap_hdu.data[which3rdbin][i][b][l]
                    self.data[0][new_b][new_l] = self.data[0][new_b][new_l] + bigskymap_hdu.data[which3rdbin][b][l]
                elif ( bigrank == 2) :
    #                print 'self.data[new_b][new_l]:',self.data[new_b][new_l],
    #                print 'gp.data[which3rdbin[b][l]:',bigskymap_hdu.data[i][b][l]
                    self.data[new_b][new_l] = self.data[new_b][new_l] + bigskymap_hdu.data[b][l]
#
#      end loops over all image bins

#
#     3/ And finally, trying to update/clean out just the output header:
#
        self.header.update('NAXIS1', naxis1)
#        self.header.update('CRVAL1', crval1)
#        self.header.update('CDELT1', cdelt1)

        self.header.update('NAXIS2', naxis2)
#        self.header.update('CRVAL2', crval2)
#        self.header.update('CDELT2', cdelt2)

#
#------------------------------------------------------------------------------------------
#
class simpler_average_rebin:
    def __init__(self, bigskymap_hdu,want_rebinfact,which_3rdbin):
#
#       1/ Initialize data format, based on input bigskymap format:
#
#       1.1/ Initialize header:

#       1.1.1/ Transform Old Axis Descriptions Into New:
#     Warning!  Doesn't always transform "cdelt" and "crval" properly!! **
        old_naxis1 = bigskymap_hdu.header['NAXIS1']
        naxis1 = old_naxis1/want_rebinfact[0]
#        old_cdelt1 = bigskymap_hdu.header['CDELT1']
#        cdelt1 = old_cdelt1*want_rebinfact[0]
#        old_crval1 = bigskymap_hdu.header['CRVAL1']
#        crval1 = old_crval1 + (want_rebinfact[0]*old_cdelt1/2.0000)	# Use bin median (middle) as new crval

        old_naxis2 = bigskymap_hdu.header['NAXIS2']
        naxis2 = old_naxis2/want_rebinfact[1]
#        old_cdelt2 = bigskymap_hdu.header['CDELT2']
#        cdelt2 = old_cdelt2*want_rebinfact[1]
#        old_crval2 = bigskymap_hdu.header['CRVAL2']
#        crval2 = old_crval2 + (want_rebinfact[1]*old_cdelt2/2.0000)	# Use bin median (middle) as new crval

        naxis3 = 1
        crval3 = 1.
        cdelt3 = 1.

#       1.2/ Initialze Data

        bigrank = len( bigskymap_hdu.data.shape)
        if   ( bigrank == 3 ) :
            data0 = zeros((naxis3,naxis2,naxis1),dtype=float )
        elif ( bigrank == 2 ) :
            data0 = zeros((naxis2,naxis1),dtype=float )
        else:
            print '\nFatal Error: wrong type of rank for input bigskymap_hdu.'
            print ' Need rank of 2 or 3, but shape was: ', bigskymap_hdu.data.shape
            raise TypeError

#       1.3/ Turn it into fits "PrimaryHDU" format!
#        self = pyfits.PrimaryHDU(data0)	### PROBLEM WITH PASSING HDU FORMAT - KLUGE BELOW:
        self.data = data0

#       1.4/ Put in correct initial header:
        self.header = bigskymap_hdu.header

#
#       2/ Transform data from bigskymap units (flux) by summing bins

        print 'Debug: naxis1, naxis2, new naxis3:', naxis1, naxis2,  naxis3
        print 'old,new:', bigskymap_hdu.data.shape, self.data.shape
        newsize = 1.000000*(want_rebinfact[0]*want_rebinfact[1])
        i = which_3rdbin
        for l in range(old_naxis1):
            new_l = l/want_rebinfact[0]
            for b in range(old_naxis2):
                new_b = b/want_rebinfact[1]
#                print 'i: ',i,' l, new_l', l, new_l, ' b:',b, new_b
                if ( bigrank == 3) :
    #                print 'self.data[0][new_b][new_l]:',self.data[0][new_b][new_l],
    #                print 'gp.data[which3rdbin][i][b][l]:',bigskymap_hdu.data[i][b][l]
                    self.data[0][new_b][new_l] = self.data[0][new_b][new_l] + (bigskymap_hdu.data[which_3rdbin][b][l]/newsize)
                elif ( bigrank == 2) :
    #                print 'self.data[new_b][new_l]:',self.data[new_b][new_l],
    #                print 'gp.data[b][l]:',bigskymap_hdu.data[b][l]
                    self.data[new_b][new_l] = self.data[new_b][new_l] + (bigskymap_hdu.data[b][l]/newsize)
#
#      end loops over all image bins

#
#     3/ And finally, trying to update/clean out just the output header:
#
        self.header.update('NAXIS1', naxis1)
#        self.header.update('CRVAL1', crval1)
#        self.header.update('CDELT1', cdelt1)

        self.header.update('NAXIS2', naxis2)
#        self.header.update('CRVAL2', crval2)
#       self.header.update('CDELT2', cdelt2)

#        self.header.update('NAXIS3', naxis3)

#
#------------------------------------------------------------------------------------------
#
class simpler_outer_products:
    def __init__(self, modelflux_hdu, exposr_rebinned_hdu):
#
#       1/ Initialize data format, based on input modelflux format:
#       1.1.0/ Get Axis Descriptions:
        naxis1 = modelflux_hdu.header['NAXIS1']
#        cdelt1 = modelflux_hdu.header['CDELT1']
#        crval1 = modelflux_hdu.header['CRVAL1']

        naxis2 = modelflux_hdu.header['NAXIS2']
#        cdelt2 = modelflux_hdu.header['CDELT2']
#        crval2 = modelflux_hdu.header['CRVAL2']

        exp_naxis1 = exposr_rebinned_hdu.header['NAXIS1']
#        exp_cdelt1 = exposr_rebinned_hdu.header['CDELT1']
#        exp_crval1 = modelflux_hdu.header['CRVAL1']

        exp_naxis2 = exposr_rebinned_hdu.header['NAXIS2']
#        exp_cdelt2 = exposr_rebinned_hdu.header['CDELT2']
#        exp_crval2 = exposr_rebinned_hdu.header['CRVAL2']

        naxis3 = 1
#        crval3 = 1.
#        cdelt3 = 1.

#
#       1.1/ Do both have same naxis, cdelt? ASSUMED SO FOR NOW
        epsilon = 1.e-5
        if naxis1 != exp_naxis1:
            print 'Error: Array Dims mis-match:  data naxis1 ',naxis1,' is not equal to exposure naxis1:', exp_naxis1
            return
        if naxis2 != exp_naxis2:
            print 'Error: Array Dims mis-match:  data naxis2 ',naxis2,' is not equal to exposure naxis2:', exp_naxis2
            return

#        if abs(cdelt1 -  exp_cdelt1) > epsilon:
#            print 'Error: Array Dims mis-match:  data cdelt1 ',cdelt1,' is not equal to exposure cdelt1:', exp_cdelt1
#            return
#        if abs(cdelt2 - exp_cdelt2) > epsilon:
#            print 'Error: Array Dims mis-match:  data cdelt2 ',cdelt2,' is not equal to exposure cdelt2:', exp_cdelt2
#            return

#        if abs(crval1 -  exp_crval1) > epsilon:
#            print 'Error: Array Dims mis-match:  data crval1 ',crval1,' is not equal to exposure crval1:', exp_crval1
#            return
#        if abs(crval2 - exp_crval2) > epsilon:
#            print 'Error: Array Dims mis-match:  data crval2 ',crval2,' is not equal to exposure crval2:', exp_crval2
#            return

#
#       1.2/ Initialize output data-model:
        data0 = zeros((naxis3,naxis2,naxis1),dtype=float )
        self.data = data0

#
#       1.3/ Put in fits "PrimaryHDU" format!
#        self = pyfits.PrimaryHDU(data0)	### PROBLEM WITH PASSING HDU FORMAT - KLUGE BELOW:

#
#       1.4/ Initialize output header:
        self.header = modelflux_hdu.header


#
#       2/ Transform data from modelflux units (flux) to model_data by outer-product:

        print 'Debug: naxis1, naxis2, new naxis3:', naxis1, naxis2,  naxis3
        print 'old,new:', modelflux_hdu.data.shape, self.data.shape
        print 'middle of old, new:',modelflux_hdu.data[0][naxis2/2][naxis1/2],
        print exposr_rebinned_hdu.data[0][naxis2/2][naxis1/2]
        print self.data[0][naxis2/2][naxis1/2]
        loprintlim, hiprintlim = (naxis2/2-10), (naxis2/2+10)

        for l in range(naxis1):
            for b in range(naxis2):
                exposure = exposr_rebinned_hdu.data[0][b][l]
                self.data[0][b][l] = modelflux_hdu.data[0][b][l]*exposure
                #if ( loprintlim < b  and b < hiprintlim):
                #    print 'l, b:', l,b
                #    print ' modelflux, exposure:',modelflux_hdu.data[0][b][l],exposure
                #    print ' self: ',self.data[0][b][l]
                ####                self.data[0][b][l] = modelflux.data[0][b][l]
#
#      end loops over all image bins

#
#     3/ And finally, trying to update/clean out just the output header:
#
###        self.header.add_history('Exposure*FluxModel*IntTime')
#
#------------------------------------------------------------------------------------------
#
class simpler_twosum:
    def __init__(self, one_hdu, two_hdu):
#
#       1/ Initialize data format, based on input modelflux format:
#       1.1.0/ Get Axis Descriptions:
        one_naxis1 = one_hdu.header['NAXIS1']
#        one_cdelt1 = one_hdu.header['CDELT1']
#        one_crval1 = one_hdu.header['CRVAL1']

        one_naxis2 = one_hdu.header['NAXIS2']
#        one_cdelt2 = one_hdu.header['CDELT2']
#        one_crval2 = one_hdu.header['CRVAL2']

        two_naxis1 = two_hdu.header['NAXIS1']
#        two_cdelt1 = two_hdu.header['CDELT1']
#        two_crval1 = two_hdu.header['CRVAL1']

        two_naxis2 = two_hdu.header['NAXIS2']
#        two_cdelt2 = two_hdu.header['CDELT2']
#        two_crval2 = two_hdu.header['CRVAL2']

        one_naxis3 = 1
        two_naxis3 = 1
#        crval3 = 1.
#        cdelt3 = 1.

#
#       1.1/ Do both have same naxis, cdelt? ASSUMED SO FOR NOW
        epsilon = 1.e-5
        if one_naxis1 != two_naxis1:
            print 'Error: Array Dims mis-match:  data naxis1 ',one_naxis1,' is not equal to exposure naxis1:', two_naxis1
            return
        if one_naxis2 != two_naxis2:
            print 'Error: Array Dims mis-match:  data naxis2 ',one_naxis2,' is not equal to exposure naxis2:', two_naxis2
            return

#        if abs(cdelt1 -  two_cdelt1) > epsilon:
#            print 'Error: Array Dims mis-match:  data cdelt1 ',one_cdelt1,' is not equal to exposure cdelt1:', two_cdelt1
#            return
#        if abs(cdelt2 - two_cdelt2) > epsilon:
#            print 'Error: Array Dims mis-match:  data cdelt2 ',one_cdelt2,' is not equal to exposure cdelt2:', two_cdelt2
#            return

#        if abs(crval1 -  two_crval1) > epsilon:
#            print 'Error: Array Dims mis-match:  data crval1 ',one_crval1,' is not equal to exposure crval1:', two_crval1
#            return
#        if abs(crval2 - two_crval2) > epsilon:
#            print 'Error: Array Dims mis-match:  data crval2 ',one_crval2,' is not equal to exposure crval2:', two_crval2
#            return

#
#       1.2/ Initialize output data-model:
        bigrank = len( one_hdu.data.shape)
        if   ( bigrank == 3 ) :
            data0 = zeros((naxis3,naxis2,naxis1),dtype=float )
        elif ( bigrank == 2 ) :
            data0 = zeros((naxis2,naxis1),dtype=float )
        else:
            print '\nFatal Error: wrong type of rank for input bigskymap_hdu.'
            print ' Need rank of 2 or 3, but shape was: ', bigskymap_hdu.data.shape
            raise TypeError

        self.data = data0

#
#       1.3/ Put in fits "PrimaryHDU" format!
#        self = pyfits.PrimaryHDU(data0)	### PROBLEM WITH PASSING HDU FORMAT - KLUGE BELOW:

#
#       1.4/ Initialize output header:
        self.header = one_hdu.header
        print 'TwoSums check: input self header:', self.header


#
#       2/ Transform data 

        print 'one_naxis1, one_naxis2, one_naxis3:', one_naxis1, one_naxis2,  one_naxis3
        print 'old,new:', one_hdu.data.shape, self.data.shape
        if ( bigrank == 3 ) :
            print 'middle of old, new:',one_hdu.data[0][one_naxis2/2][one_naxis1/2],
            print two_hdu.data[0][one_naxis2/2][one_naxis1/2]
            print self.data[0][one_naxis2/2][one_naxis1/2]
        elif ( bigrank == 2 ) :
            print 'middle of old, new:',one_hdu.data[one_naxis2/2][one_naxis1/2],
            print two_hdu.data[one_naxis2/2][one_naxis1/2]
            print self.data[one_naxis2/2][one_naxis1/2]
        loprintlim, hiprintlim = (one_naxis2/2-10), (one_naxis2/2+10)

        for l in range(one_naxis1):
            for b in range(one_naxis2):
                if ( bigrank == 3 ) :
                    two = two_hdu.data[0][b][l]
                    self.data[0][b][l] = one_hdu.data[0][b][l] + two
                    #if ( loprintlim < b  and b < hiprintlim):
                    #    print 'l, b:', l,b
                    #    print ' modelflux, exposure:',one_hdu.data[0][b][l],exposure
                    #    print ' self: ',self.data[0][b][l]
                    ####                self.data[0][b][l] = modelflux.data[0][b][l]
                elif ( bigrank == 2 ) :
                    two = two_hdu.data[b][l]
                    self.data[b][l] = one_hdu.data[b][l] + two
                    #if ( loprintlim < b  and b < hiprintlim):
                    #    print 'l, b:', l,b
                    #    print ' modelflux, exposure:',one_hdu.data[b][l],exposure
                    #    print ' self: ',self.data[b][l]
                    ####                self.data[b][l] = modelflux.data[b][l]
#
#      end loops over all image bins

#
#     3/ And finally, trying to update/clean out just the output header:
#
###        self.header.add_history('Exposure*FluxModel*IntTime')
#
#------------------------------------------------------------------------------------------
#
class simpler_poisson_datons:
    def __init__(self, modeldata_hdu):
#
#       1/ Initialize data format, based on input modeldata format:
#       1.0/ Do both have same naxis, cdelt? ASSUMED SO FOR NOW

#       1.1/ Transform Old Axis Descriptions Into New:
        naxis1 = modeldata_hdu.header['NAXIS1']
#        cdelt1 = modeldata_hdu.header['CDELT1']
#        crval1 = modeldata_hdu.header['CRVAL1']

        naxis2 = modeldata_hdu.header['NAXIS2']
#        cdelt2 = modeldata_hdu.header['CDELT2']
#        crval2 = modeldata_hdu.header['CRVAL2']

        naxis3 = 1
#        crval3 = 1.
#        cdelt3 = 1.

#
#       1.2/ Initialize data
        data0 = zeros(modeldata_hdu.data.shape,dtype=float )
#
#       1.3/ Fits format: Primary HDU!
#        self = pyfits.PrimaryHDU(data0)	### PROBLEM WITH PASSING HDU FORMAT - KLUGE BELOW:
        self.data = data0
#
#       1.4/ Initialize header:
        self.header = modeldata_hdu.header

#
#       2/ Transform data from modeldata units (flux) to model_data by outer-product:

        print 'Debug: naxis1, naxis2, new naxis3:', naxis1, naxis2,  naxis3
        print 'old,new:', modeldata_hdu.data.shape, self.data.shape

        for l in range(naxis1):
            for b in range(naxis2):
#                print ' l', l, ' b:',b
                  if( len(modeldata_hdu.data.shape) == 3) :
#                    print 'self.data[0][b][l]:',self.data[0][b][l],
#                    print 'modeldata_hdu.data[0][b][l]:',modeldata_hdu.data[0][b][l]
                     mu = modeldata_hdu.data[0][b][l]
                     if mu > 0:
                         self.data[0][b][l] = random.poisson(mu)
                     else:
                         self.data[0][b][l] = 0.
                  if( len(modeldata_hdu.data.shape) == 2) :
#                    print 'self.data[0][b][l]:',self.data[b][l],
#                    print 'modeldata_hdu.data[b][l]:',modeldata_hdu.data[b][l]
                     mu = modeldata_hdu.data[b][l]
                     if mu > 0:
                         self.data[b][l] = random.poisson(mu)
                     else:
                         self.data[b][l] = 0.
#
#      end loops over all image bins

#
#     3/ And finally, trying to update/clean out just the output header:
#
####        self.header.add_history('GammaVariate of DataModel')
#
#------------------------------------------------------------------------------------------
#
class simpler_sphereskymap_pad_to_square_power2:
    def __init__(self, modeldata_hdu):
#
        PowersOf2 = [1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768]
#       **Needs exception for data bigger than len[]!!

#       1/ Initialize data format, based on input modeldata format:
#

#       1.1/ Transform Old Axis Descriptions Into New:
        naxis1 = modeldata_hdu.header['NAXIS1']
        naxis2 = modeldata_hdu.header['NAXIS2']

        naxis3 = 1
        crval3 = 1.
        cdelt3 = 1.

        naxis_big = max(naxis1,naxis2)
        for i2 in PowersOf2:
            if i2/2 <= naxis_big < i2 :
                print naxis_big, i2
                naxissq = i2

#       1.2/ Initialize data  ---- with new "naxs1"="naxis2"=naxissq:
        data0 = zeros((naxis3,naxissq,naxissq),dtype=float)

#       1.3/ Put into Fits format: Primary HDU!
#        self = pyfits.PrimaryHDU(data0)	### PROBLEM WITH PASSING HDU FORMAT - KLUGE BELOW:
        self.data = data0

#       1.4/ Initialize header:
        self.header = modeldata_hdu.header


        print 'Original naxis1, naxis2=',naxis1,naxis2,' to be padded to new square naxissq:',  naxissq
#
#       2/ Transform data from modeldata units (flux) to model_data by outer-product:
#
#       2.1/ Find the new padding amounts on Gal-l minus; gal-l plus; gal-b bottom(-); gal-b top(+):
        delpad_l_m = (naxissq - naxis1)/2
        delpad_l_p = naxissq - naxis1 - delpad_l_m
        delpad_b_m = (naxissq - naxis2)/2
        delpad_b_p = naxissq - naxis2 - delpad_b_m
        print 'new padding on Gal-l minus,plus:',delpad_l_m, delpad_l_p,
        print ' Gal-b minus, plus:',delpad_b_m, delpad_b_p,
        print 'old,new:', modeldata_hdu.data.shape, self.data.shape

#       2.2/ Fill in the middle "square" with the original skymap:
        for l in range(naxis1):
            new_l = l + delpad_l_m
            for b in range(naxis2):
                new_b = b + delpad_b_m
#                print ' l, new_l', l, ' b, new_b:',b, new_b
#                print 'self.data[0][new_b][new_l]:',self.data[0][new_b][new_l],
#                print 'modeldata_hdu.data[0][b][l]:',modeldata_hdu.data[0][b][l]
                self.data[0][new_b][new_l] = modeldata_hdu.data[0][b][l]

#       2.3/ Fill in the horizontal (i.e. Gal-l) part 1st, as it has simpler "cycling" rule:
#       2.3.1/ Fill in the "minus" side of Gal-l:
        for new_l in range(delpad_l_m):
            old_l = naxis1 - delpad_l_m + new_l
            for b in range(naxis2):
                new_b = b + delpad_b_m
#                print ' old_l, new_l', old_l, ' b, new_b:',b, new_b
#                print 'self.data[0][new_b][new_l]:',self.data[0][new_b][new_l],
#                print 'modeldata_hdu.data[0][b][old_l]:',modeldata_hdu.data[0][b][old_l]
                self.data[0][new_b][new_l] = modeldata_hdu.data[0][b][old_l]

#       2.3.2/ Fill in the "plus" side of Gal-l:
        for del_l in range(delpad_l_p):
            new_l = del_l + naxis1 + delpad_l_m 
            old_l = del_l
            for b in range(naxis2):
                new_b = b + delpad_b_m
#                print ' old_l, new_l', old_l, new_l,' b, new_b:',b, new_b
#                print 'self.data[0][new_b][new_l]:',self.data[0][new_b][new_l],
#                print 'modeldata_hdu.data[0][b][old_l]:',modeldata_hdu.data[0][b][old_l]
                self.data[0][new_b][new_l] = modeldata_hdu.data[0][b][old_l]

#       2.4/ Fill in the Vertical (i.e. Gal-b) part 2nd, as it has more complex "cycling" rule:
#
#           |                       /---------\
#           |                     /      /---\     \                    |
#    a18 | a11  a12  a13  a14  a15  a16  a17  a18 | a11
#    a28 | a21  a22  a23  a24  a25  a26  a27  a28 | a21
#    a38 | a31  a32  a33  a34  a35  a36  a37  a38 | a31
#    a48 | a41  a42  a43  a44  a45  a46  a47  a48 | a41
#           |                    \    \---/    /                         |
#           |                      \---------/                            |
#
#       2.4.1/ Fill in the "minus" side of Gal-b:
        for old_l in range(naxissq):
            new_l = naxissq - old_l - 1
            for new_b in range(delpad_b_m):
                old_b = 2*delpad_b_m - new_b - 1
#                print ' new_l', new_l ' old_b, new_b:', old_b, new_b
#                print 'self.data[0][new_b][new_l]:',self.data[0][new_b][new_l]
                self.data[0][new_b][new_l] = self.data[0][old_b][old_l]

#
#       2.4.2/ Fill in the "plus" side of Gal-b:
        for old_l in range(naxissq):
            new_l = naxissq - old_l - 1
            for del_b in range(delpad_b_p):
                new_b = delpad_b_m + naxis2 + del_b
                old_b = delpad_b_m + naxis2 - 1 - del_b
#                print ' new_l', new_l ' old_b, new_b:', old_b, new_b
#                print 'self.data[0][new_b][new_l]:',self.data[0][new_b][new_l]
                self.data[0][new_b][new_l] = self.data[0][old_b][old_l]

#      end loops over all image bins

#
#     3/ And finally, trying to update/clean out just the output header:
#
        self.header.update('NAXIS1', naxissq)
        self.header.update('NAXIS2', naxissq)

####        self.header.add_history('Sphere-projection skymap padded to square power of 2')
#
#------------------------------------------------------------------------------------------
#
class simpler_zerozero_pad_to_square_power2:
    def __init__(self, modeldata_hdu):
#
        PowersOf2 = [1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768]
#       **Needs exception for data bigger than len[]!!

#       1/ Initialize data format, based on input modeldata format:
#

#       1.1/ Transform Old Axis Descriptions Into New:
        naxis1 = modeldata_hdu.header['NAXIS1']
        naxis2 = modeldata_hdu.header['NAXIS2']

        naxis3 = 1
        crval3 = 1.
        cdelt3 = 1.

        naxis_big = max(naxis1,naxis2)
        for i2 in PowersOf2:
            if i2/2 <= naxis_big < i2 :
                print naxis_big, i2
                naxissq = i2

#       1.2/ Initialize data  ---- with new "naxs1"="naxis2"=naxissq:
        data0 = zeros((naxis3,naxissq,naxissq),dtype=float)

#       1.3/ Put into Fits format: Primary HDU!
#        self = pyfits.PrimaryHDU(data0)	### PROBLEM WITH PASSING HDU FORMAT - KLUGE BELOW:
        self.data = data0

#       1.4/ Initialize header:
        self.header = modeldata_hdu.header


        print 'Original naxis1, naxis2=',naxis1,naxis2,' to be padded to new square naxissq:',  naxissq
#
#       2/ Transform data from modeldata units (flux) to model_data by outer-product:
#
#       2.1/ Find the new padding amounts on Gal-l minus; gal-l plus; gal-b bottom(-); gal-b top(+):
        delpad_l_m = (naxissq - naxis1)/2
        delpad_l_p = naxissq - naxis1 - delpad_l_m
        delpad_b_m = (naxissq - naxis2)/2
        delpad_b_p = naxissq - naxis2 - delpad_b_m
        print 'new padding on Gal-l minus,plus:',delpad_l_m, delpad_l_p,
        print ' Gal-b minus, plus:',delpad_b_m, delpad_b_p,
        print 'old,new:', modeldata_hdu.data.shape, self.data.shape

#       2.2/ Fill in the middle "square" with the original skymap:
        for l in range(naxis1):
            new_l = l + delpad_l_m
            for b in range(naxis2):
                new_b = b + delpad_b_m
#                print ' l, new_l', l, ' b, new_b:',b, new_b
#                print 'self.data[0][new_b][new_l]:',self.data[0][new_b][new_l],
#                print 'modeldata_hdu.data[0][b][l]:',modeldata_hdu.data[0][b][l]
                self.data[0][new_b][new_l] = modeldata_hdu.data[0][b][l]

#       2.3/ Fill in the horizontal (i.e. Gal-l) part 1st, as it has simpler "cycling" rule:
#       2.3.1/ Fill in the "minus" side of Gal-l:
        for new_l in range(delpad_l_m):
            old_l = naxis1 - delpad_l_m + new_l
            for b in range(naxis2):
                new_b = b + delpad_b_m
#                print ' old_l, new_l', old_l, ' b, new_b:',b, new_b
#                print 'self.data[0][new_b][new_l]:',self.data[0][new_b][new_l],
#                print 'modeldata_hdu.data[0][b][old_l]:',modeldata_hdu.data[0][b][old_l]
                self.data[0][new_b][new_l] = modeldata_hdu.data[0][b][old_l]

#       2.3.2/ Fill in the "plus" side of Gal-l:
        for del_l in range(delpad_l_p):
            new_l = del_l + naxis1 + delpad_l_m 
            old_l = del_l
            for b in range(naxis2):
                new_b = b + delpad_b_m
#                print ' old_l, new_l', old_l, new_l,' b, new_b:',b, new_b
#                print 'self.data[0][new_b][new_l]:',self.data[0][new_b][new_l],
#                print 'modeldata_hdu.data[0][b][old_l]:',modeldata_hdu.data[0][b][old_l]
                self.data[0][new_b][new_l] = modeldata_hdu.data[0][b][old_l]

#       2.4/ Fill in the Vertical (i.e. Gal-b) part with zeros or min, for when cycling isn't useful
#
#       2.4.1/ Fill in the "minus" side of Gal-b:
        for old_l in range(naxissq):
            new_l = naxissq - old_l - 1
            for new_b in range(delpad_b_m):
                old_b = 2*delpad_b_m - new_b - 1
#                print ' new_l', new_l ' old_b, new_b:', old_b, new_b
#                print 'self.data[0][new_b][new_l]:',self.data[0][new_b][new_l]
                self.data[0][new_b][new_l] = 1.e-26

#
#       2.4.2/ Fill in the "plus" side of Gal-b:
        for old_l in range(naxissq):
            new_l = naxissq - old_l - 1
            for del_b in range(delpad_b_p):
                new_b = delpad_b_m + naxis2 + del_b
                old_b = delpad_b_m + naxis2 - 1 - del_b
#                print ' new_l', new_l ' old_b, new_b:', old_b, new_b
#                print 'self.data[0][new_b][new_l]:',self.data[0][new_b][new_l]
                self.data[0][new_b][new_l] = 1.e-26

#      end loops over all image bins

#
#     3/ And finally, trying to update/clean out just the output header:
#
        self.header.update('NAXIS1', naxissq)
        self.header.update('NAXIS2', naxissq)

####        self.header.add_history('Sphere-projection skymap padded to square power of 2')
#
#------------------------------------------------------------------------------------------
#
class simpler_zero_pad_to_square_power2:
    def __init__(self, modeldata_hdu):
#
        PowersOf2 = [1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768]
#       **Needs exception for data bigger than len[]!!

#       1/ Initialize data format, based on input modeldata format:
#

#       1.1/ Transform Old Axis Descriptions Into New:
        naxis1 = modeldata_hdu.header['NAXIS1']
        naxis2 = modeldata_hdu.header['NAXIS2']

        naxis3 = 1
        crval3 = 1.
        cdelt3 = 1.

        naxis_big = max(naxis1,naxis2)
        for i2 in PowersOf2:
            if i2/2 <= naxis_big < i2 :
                print naxis_big, i2
                naxissq = i2

#       1.2/ Initialize data  ---- with new "naxs1"="naxis2"=naxissq:
        data0 = zeros((naxis3,naxissq,naxissq),dtype=float)

#       1.3/ Put into Fits format: Primary HDU!
#        self = pyfits.PrimaryHDU(data0)	### PROBLEM WITH PASSING HDU FORMAT - KLUGE BELOW:
        self.data = data0

#       1.4/ Initialize header:
        self.header = modeldata_hdu.header


        print 'Original naxis1, naxis2=',naxis1,naxis2,' to be padded to new square naxissq:',  naxissq
#
#       2/ Transform data from modeldata units (flux) to model_data by outer-product:
#
#       2.1/ Find the new padding amounts on Gal-l minus; gal-l plus; gal-b bottom(-); gal-b top(+):
        delpad_l_m = (naxissq - naxis1)/2
        delpad_l_p = naxissq - naxis1 - delpad_l_m
        delpad_b_m = (naxissq - naxis2)/2
        delpad_b_p = naxissq - naxis2 - delpad_b_m
        print 'new padding on Gal-l minus,plus:',delpad_l_m, delpad_l_p,
        print ' Gal-b minus, plus:',delpad_b_m, delpad_b_p,
        print 'old,new:', modeldata_hdu.data.shape, self.data.shape

#       2.2/ Fill in the middle "square" with the original skymap:
        for l in range(naxis1):
            new_l = l + delpad_l_m
            for b in range(naxis2):
                new_b = b + delpad_b_m
#                print ' l, new_l', l, ' b, new_b:',b, new_b
#                print 'self.data[0][new_b][new_l]:',self.data[0][new_b][new_l],
#                print 'modeldata_hdu.data[0][b][l]:',modeldata_hdu.data[0][b][l]
                self.data[0][new_b][new_l] = modeldata_hdu.data[0][b][l]

#       2.3/ Fill in the horizontal (i.e. Gal-l) part 1st, as it has simpler "cycling" rule:
#       2.3.1/ Fill in the "minus" side of Gal-l:
        for new_l in range(delpad_l_m):
            old_l = naxis1 - delpad_l_m + new_l
            for b in range(naxis2):
                new_b = b + delpad_b_m
#                print ' old_l, new_l', old_l, ' b, new_b:',b, new_b
#                print 'self.data[0][new_b][new_l]:',self.data[0][new_b][new_l],
#                print 'modeldata_hdu.data[0][b][old_l]:',modeldata_hdu.data[0][b][old_l]
                self.data[0][new_b][new_l] = modeldata_hdu.data[0][b][old_l]

#       2.3.2/ Fill in the "plus" side of Gal-l:
        for del_l in range(delpad_l_p):
            new_l = del_l + naxis1 + delpad_l_m 
            old_l = del_l
            for b in range(naxis2):
                new_b = b + delpad_b_m
#                print ' old_l, new_l', old_l, new_l,' b, new_b:',b, new_b
#                print 'self.data[0][new_b][new_l]:',self.data[0][new_b][new_l],
#                print 'modeldata_hdu.data[0][b][old_l]:',modeldata_hdu.data[0][b][old_l]
                self.data[0][new_b][new_l] = modeldata_hdu.data[0][b][old_l]

#       2.4/ Fill in the Vertical (i.e. Gal-b) part with zeros or min, for when cycling isn't useful
#
#       2.4.1/ Fill in the "minus" side of Gal-b:
        for old_l in range(naxissq):
            new_l = naxissq - old_l - 1
            for new_b in range(delpad_b_m):
                old_b = 2*delpad_b_m - new_b - 1
#                print ' new_l', new_l ' old_b, new_b:', old_b, new_b
#                print 'self.data[0][new_b][new_l]:',self.data[0][new_b][new_l]
                self.data[0][new_b][new_l] = 1.e-13

#
#       2.4.2/ Fill in the "plus" side of Gal-b:
        for old_l in range(naxissq):
            new_l = naxissq - old_l - 1
            for del_b in range(delpad_b_p):
                new_b = delpad_b_m + naxis2 + del_b
                old_b = delpad_b_m + naxis2 - 1 - del_b
#                print ' new_l', new_l ' old_b, new_b:', old_b, new_b
#                print 'self.data[0][new_b][new_l]:',self.data[0][new_b][new_l]
                self.data[0][new_b][new_l] = 1.e-13

#      end loops over all image bins

#
#     3/ And finally, trying to update/clean out just the output header:
#
        self.header.update('NAXIS1', naxissq)
        self.header.update('NAXIS2', naxissq)

#####        self.header.add_history('Sphere-projection skymap padded to square power of 2')
#
#------------------------------------------------------------------------------------------
#
class simpler_zero_pad_to_rectangle:
    def __init__(self, modeldata_hdu, rectangle=[128,128]):
#
#       1/ Initialize data format, based on input modeldata format:
#

#       1.1/ Transform Old Axis Descriptions Into New:
        naxis1 = modeldata_hdu.header['NAXIS1']
        naxis2 = modeldata_hdu.header['NAXIS2']

        naxis3 = 1
        crval3 = 1.
        cdelt3 = 1.

        naxis_big = (max(naxis1,rectangle[0]), max(naxis2, rectangle[1]) )
        print 'Big Rectangle Dimensions: ',  naxis_big

#       1.2/ Initialize data  ---- with new "naxs1"="naxis2"=naxissq:
        data0 = zeros((naxis3,naxis_big[1],naxis_big[0]),dtype=float)

#       1.3/ Put into Fits format: Primary HDU!
#        self = pyfits.PrimaryHDU(data0)	### PROBLEM WITH PASSING HDU FORMAT - KLUGE BELOW:
        self.data = data0

#       1.4/ Initialize header:
        self.header = modeldata_hdu.header


        print 'Original naxis1, naxis2=',naxis1,naxis2,' to be padded to new rectangle naxis_big: ',  naxis_big
#
#       2/ Transform data from modeldata units (flux) to model_data by outer-product:
#
#       2.1/ Find the new padding amounts on Gal-l minus; gal-l plus; gal-b bottom(-); gal-b top(+):
        delpad_l_m = (naxis_big[0] - naxis1)/2
        delpad_l_p = naxis_big[0] - naxis1 - delpad_l_m
        delpad_b_m = (naxis_big[1] - naxis2)/2
        delpad_b_p = naxis_big[1] - naxis2 - delpad_b_m
        print 'new padding on Gal-l minus,plus:',delpad_l_m, delpad_l_p,
        print ' Gal-b minus, plus:',delpad_b_m, delpad_b_p,
        print 'old,new:', modeldata_hdu.data.shape, self.data.shape

#       2.2/ Fill in the middle "rectangle" with the original skymap:
        for l in range(naxis1):
            new_l = l + delpad_l_m
            for b in range(naxis2):
                new_b = b + delpad_b_m
#                print ' l, new_l', l, ' b, new_b:',b, new_b
#                print 'self.data[0][new_b][new_l]:',self.data[0][new_b][new_l],
#                print 'modeldata_hdu.data[0][b][l]:',modeldata_hdu.data[0][b][l]
                self.data[0][new_b][new_l] = modeldata_hdu.data[0][b][l]

#       2.3/ Fill in the horizontal (i.e. Gal-l) part 1st, as it has simpler "cycling" rule:
#       2.3.1/ Fill in the "minus" side of Gal-l:
        for new_l in range(delpad_l_m):
            old_l = naxis1 - delpad_l_m + new_l
            for b in range(naxis2):
                new_b = b + delpad_b_m
#                print ' old_l, new_l', old_l, ' b, new_b:',b, new_b
#                print 'self.data[0][new_b][new_l]:',self.data[0][new_b][new_l],
#                print 'modeldata_hdu.data[0][b][old_l]:',modeldata_hdu.data[0][b][old_l]
                self.data[0][new_b][new_l] = modeldata_hdu.data[0][b][old_l]

#       2.3.2/ Fill in the "plus" side of Gal-l:
        for del_l in range(delpad_l_p):
            new_l = del_l + naxis1 + delpad_l_m 
            old_l = del_l
            for b in range(naxis2):
                new_b = b + delpad_b_m
#                print ' old_l, new_l', old_l, new_l,' b, new_b:',b, new_b
#                print 'self.data[0][new_b][new_l]:',self.data[0][new_b][new_l],
#                print 'modeldata_hdu.data[0][b][old_l]:',modeldata_hdu.data[0][b][old_l]
                self.data[0][new_b][new_l] = modeldata_hdu.data[0][b][old_l]

#       2.4/ Fill in the Vertical (i.e. Gal-b) part with zeros or min, for when cycling isn't useful
#
#       2.4.1/ Fill in the "minus" side of Gal-b:
        for old_l in range(naxis_big[0]):
            new_l = naxis_big[0] - old_l - 1
            for new_b in range(delpad_b_m):
                old_b = 2*delpad_b_m - new_b - 1
#                print ' new_l', new_l ' old_b, new_b:', old_b, new_b
#                print 'self.data[0][new_b][new_l]:',self.data[0][new_b][new_l]
                self.data[0][new_b][new_l] = 1.e-13

#
#       2.4.2/ Fill in the "plus" side of Gal-b:
        for old_l in range(naxis_big[1]):
            new_l = naxis_big[1] - old_l - 1
            for del_b in range(delpad_b_p):
                new_b = delpad_b_m + naxis2 + del_b
                old_b = delpad_b_m + naxis2 - 1 - del_b
#                print ' new_l', new_l ' old_b, new_b:', old_b, new_b
#                print 'self.data[0][new_b][new_l]:',self.data[0][new_b][new_l]
                self.data[0][new_b][new_l] = 1.e-13

#      end loops over all image bins

#
#     3/ And finally, trying to update/clean out just the output header:
#
        self.header.update('NAXIS1', naxis_big[0])
        self.header.update('NAXIS2', naxis_big[1])

#####        self.header.add_history('Sphere-projection skymap padded to square power of 2')
#
#------------------------------------------------------------------------------------------
#


def simpler_xy_dotproduct(xytuple0, xytuple1):
#
# Small routine to take a simple dot-product
# of two unit vectors in "x-degrees,y-degrees" form
#  NOTE I have assumed x=0,y=0 is origin

# define variables:
    dtr = pi/180.
    (xrad0,yrad0) = (xytuple0[0]*dtr,xytuple0[1]*dtr)
    (xrad1,yrad1) = (xytuple0[0]*dtr,xytuple1[1]*dtr)
    (i0hat, j0hat, k0hat) = ( cos(xrad0)*cos(yrad0), sin(yrad0), -sin(xrad0)*cos(yrad0) )
    (i1hat, j1hat, k1hat) = ( cos(xrad1)*cos(yrad1), sin(yrad1), -sin(xrad1)*cos(yrad1) )

    result = (i0hat*i1hat + j0hat*j1hat + k0hat*k1hat)
    result = result/sqrt(i0hat*i0hat + j0hat*j0hat + k0hat*k0hat)/sqrt(i1hat*i1hat + j1hat*j1hat + k1hat*k1hat)

    return result

#------------------------------------------------------------------------------------------
