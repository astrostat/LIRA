"""
@brief runs simpler Series of modules to sim gamma-ray datons from GALPROP
@author A. Connors
"""
# @file run_simpler_skymap_datons.py
#

#from numarray import * ## Changed to numpy Aug 2007
##from numpy import * ## Not explcitly needed
import pyfits
###import random
from simpler_skymap_datons import *

# Tempoorary kluge, in casethis is needed later:
NiceTempFileOfSomeSort = 'Nothin'

#
# Beginning 1st module:
# 1/ Start accumulating flux model components:
### NEEDS WORK IN PROPERLY RETURNING A PAIR OF SKYMAPS ###
### Looks like for -32 format, one needs to "touch" each data- and header peice
### in order for it to be reliably read in.
###
class SkymapModelFluxHDU:
    def __init__(self,GalpropFileList,WantEBand,WantFlxRebin,EBandString,OutModelFluxFitsFile):

#
#     1.1/ Accumulate model flux values from files:
#
#       1.1.1/ Initialize:
        for in_gp_file in GalpropFileList:
            in_gp_hdulst = pyfits.open(in_gp_file)
            if in_gp_file == GalpropFileList[0]:
                model_flux_hdu = flux_skymap_of_galprop(in_gp_hdulst,WantEBand)
#              "Touching" the data to make sure it is read in properly:
                print 'Sample of data at [[0][1]:' , model_flux_hdu.data[0][1]
                print model_flux_hdu.header
                in_gp_hdulst.close()
                EBandString = ' Eband: '+str(WantEBand[0]/1000.)+'-'+str(WantEBand[1]/1000.)+' GeV'
                history_string = 'Model:'+in_gp_file+EBandString
                model_flux_hdu.header.add_history('='+history_string)
#
#       1.1.2/ Next Model Compponent:
            else:
                model_flux_hdu.increment_flux_by_next(in_gp_hdulst,WantEBand)
#              "Touching" the data to make sure it is read in properly:
                print 'Sample of data at [[0][1]:' , model_flux_hdu.data[0][1]
                in_gp_hdulst.close()
                EBandString = ' Eband: '+str(WantEBand[0]/1000.)+'-'+str(WantEBand[1]/1000.)+' GeV'
                history_string = 'Model:'+in_gp_file+EBandString
                model_flux_hdu.header.add_history('='+history_string)

#           END loopover all input-GALPROP-files

#       1.1.3/ Add ExtraGalactic Cosmic Diffuse GRB: ** ALSO NOT IN THERE YET **
#       model_flux_hdu.data = model_flux_hdu.data + EDGRB
#       can get these from e.g. galplotdef_49_700405 (or whatever matches...)
#       For now complete kluge: hard-copying them in:
    #    ** From galplotdef_49_700405, here are isotropic EGRET results:
    #    
    #    ** The ones from the eponymous paper are the 1st, from ...500190...
    #    ** The other values were shown not tofit as well, using data slices **
    #    ** EGRET ranges covered include:
    #    ** 0.030 - 0.050     0.050 - 0.070  0.070 - 0.100  0.100 - 0.150  0.150 - 0.300  0.300 - 0.500 0.500 - 1.000 GeV
    #    ***  1.68e-5,            1.06e-5,      6.66e-6,       4.48e-6,       3.92e-6,      1.20e-6,         7.6e-7
    #    ** 1.000 - 2.000  2.000 - 4.000  4.000 - 10.000  10.000 - 20.000  20.000 - 50.000  50.000 - 120.000
    #    ***  3.20e-7,        2.4e-7,        1.17e-7,      3.4e-8,           1.1e-8,            0.0
    #    
    #    ** UNITS: cm^-2 sr^-1 s^-1
    #    
    #    SO the >1 GeV SUM is: 7.2e-7 cm^-2 sr^-1 s^-1 
    #    BUT we want "GALPROP" units, which is times GALPROPRFACTOR=0.8 or so??? OR NO?? See OR/AWS??
        EGRETgt1GeVIsoDifFlux = 7.2e-7
        print 'EGRETgt1GeVIsoDifFlux', EGRETgt1GeVIsoDifFlux
        GALPROPFACTOR = 0.1	# Right now this is not used, but left to float (see GALPLOT, OR/AWS comments)
###        GALPROPTIMEINT = 1500. Not sure why this is in some GALPROP files!
    # FOR DEBUGGING:
        PreEDIFCGRB_HDU = pyfits.PrimaryHDU(data=model_flux_hdu.data,header=model_flux_hdu.header)
        PreEDIFCGRB_HDU.writeto('DBGPreEDIFCGRB_070129.fits')
        model_flux_hdu.data = model_flux_hdu.data + EGRETgt1GeVIsoDifFlux*GALPROPFACTOR
        PostEDIFCGRB_HDU = pyfits.PrimaryHDU(data=model_flux_hdu.data,header=model_flux_hdu.header)
        PostEDIFCGRB_HDU.writeto('DBGPostEDIFCGRB_070129.fits')


#       1.1.4/ For NON-DECONVOLVE option, Convolve these with PSF ** Not in there yet **
#
### Jan 29 2007 Oy! If I read AWS's files correctly?
###             Do exposure files take care of solid angle? SO try without!!
###          Instead temporarily: simple correction for solid angle:
##        model_flux_hdu.muliply_bin_by_solid_angle(NiceTempFileOfSomeSort)
##        history_string = 'Multiplied by Solid Angle so units=Intensity/bin'
##        model_flux_hdu.header.add_history('='+history_string)

#       1.1.5/ Add point sources: ** Not in there yet **
#          Don't forget to convolve with PSF for non-deconvolve option!

#       1.1.6/ And write this intermediate file-set out as a full HDU-list!
#

#     1.2/ Rebin to desired pixel sizes (sum model flux per bin):

        WhichExp3rdBin = 0 	# Not necessary for GALPROP files, but call sequence requires it:
        model_flux_rebinned_hdu = simpler_sum_rebin(model_flux_hdu,WantFlxRebin,WhichExp3rdBin)
#       "Touching" the data to make sure it is read in properly:
        print 'Sample of rebinned data at [[0][1]:' , model_flux_rebinned_hdu.data[0][1]
        print 'Sample of rebinned header:' , model_flux_rebinned_hdu.header
        model_flux_rebinned_HDU = pyfits.PrimaryHDU(data=model_flux_rebinned_hdu.data,header=model_flux_rebinned_hdu.header)
        history_string = 'Rebinned by:'+str(WantFlxRebin)
        model_flux_hdu.header.add_history('='+history_string)
        model_flux_rebinned_HDU.writeto(OutModelFluxFitsFile[0])

#     1.3/ Pad them to square power of two:

        model_flux_padded_hdu = simpler_zero_pad_to_square_power2(model_flux_rebinned_HDU)
        print 'Sample of padded data at [[0][1]:' , model_flux_padded_hdu.data[0][1]
        print 'Sample of padded header:' , model_flux_padded_hdu.header
        model_flux_padded_HDU = pyfits.PrimaryHDU(data=model_flux_padded_hdu.data,header=model_flux_padded_hdu.header)

        model_flux_padded_HDU.writeto(OutModelFluxFitsFile[1])

#     1.4 And return as a two-member list of HDUs:
### NEEDS WORK IN PROPERLY RETURNING A PAIR OF SKYMAPS ###
        self = pyfits.HDUList([model_flux_rebinned_HDU,model_flux_padded_HDU])

# -------------------------------------------------------------------------------------

#
# 2/ Now input the exposure: Rebin to desired bin/pixel sizes:
#
class MatchedExposureMap:
    def __init__(self,ExposrFile,EBandString,WantExpRebin,WhichExp3rdBin,IntTime,OutExpAreaTimeFitsFile,ExposrHistory):
        
        exposr_hdulst = pyfits.open(ExposrFile)
        exposr_hdu = exposr_hdulst[0]
    
#    2.1/ The exposure is averaged: 

        exposr_rebinned_hdu = simpler_average_rebin(exposr_hdu,WantExpRebin,WhichExp3rdBin)
        print 'Sample of rebinned exposr at [[0][1]:' , exposr_rebinned_hdu.data[0][1]
        history_string = 'Exposure:'+ExposrFile+EBandString
        exposr_rebinned_hdu.header.add_history('='+history_string)
        exposr_hdulst.close()

#   2.2/ Into proper Fits Format:
        self.data = exposr_rebinned_hdu.data*IntTime
        self.header = exposr_rebinned_hdu.header
#        print self.data
#        print self.header
        temp_HDU = pyfits.PrimaryHDU(data=self.data,header=self.header)
        temp_HDU.writeto(OutExpAreaTimeFitsFile)
#        print self.data
        print self.header
#        print 'Good at end of module.'
# -------------------------------------------------------------------------------------
#
# 3/ Now find model_data = exposure*model_flux for each image bin:
#

class ExpectedDataModelHDU:
    '''
        Returns a PrimaryHDU containing model data == exp*model flux
        Also writes out fits file containing this.
    '''
    def __init__(self,FluxModelHDU,ExpAreaTimeHDU,OutModelDataFile):
#
#       1/ Initialize data format based on input FluxModel HDU:
#
#        self = FluxModelHDU
#
#       2/ Now for each input flux model, exposure*inttime combination, find outerproduct=data:
        model_data_hdu = simpler_outer_products(FluxModelHDU,ExpAreaTimeHDU)
        print 'Sample of ExpectedDataModel at [[0][1]:' , model_data_hdu.data[0][1]
        print 'Sample of ExpectedDataModel header:' , model_data_hdu.header
        history_string = 'Taken from exposure file history'
        model_data_hdu.header.add_history('='+history_string)
                
        print model_data_hdu.header
#        print model_data_hdu.data[0][90][180]

# For some reason is choking on these headers! So I will just use the defaults for now:
#     model_data_HDU = pyfits.PrimaryHDU(data=model_data_hdu.data,header=model_data_hdu.header)
        model_data_HDU = pyfits.PrimaryHDU(data=model_data_hdu.data)
        model_data_HDU.writeto(OutModelDataFile)
 
#        self = model_data_hdu
        self.data = model_data_HDU.data
        print self.data[0][1]
        self.header = model_data_HDU.header
        print self.header

# -------------------------------------------------------------------------------------
#
# 6/ Get some Poisson counts! what fun!!
#
class PoisDatonsHDU:
    '''
        Returns a  of PrimaryHDU objects containing simulated Poisson datons
        Also writes out fits files containing these.
    '''
    def __init__(self,ExpectedCntsHDU,OutPoisDatonsFitsFile):
#
#   6.0 A little error checking:

#   6.1/ Initialize self:
        self = ExpectedCntsHDU
        k = 0

#   6.2/  Put Poisson Counts into each member: 
        model_data_padded_HDU = ExpectedCntsHDU
        print 'Sample of Input ExpectedCnts at [[0][1]:' , model_data_padded_HDU.data[0][1]
        print 'Sample of rInput ExpectedCnts header:' , model_data_padded_HDU.header
        poiss_datons_padded_hdu = simpler_poisson_datons(model_data_padded_HDU)
        print 'Sample of Output Sim Cnts at [[0][1]:' , poiss_datons_padded_hdu.data[0][1]
        print 'Sample of Output Sim Cnts header:' , poiss_datons_padded_hdu.header
        poiss_datons_padded_HDU = pyfits.PrimaryHDU(data=poiss_datons_padded_hdu.data,header=poiss_datons_padded_hdu.header)

#   6.3/ Write them out:
        poiss_datons_padded_HDU.writeto(OutPoisDatonsFitsFile)
        print 'HDU of Output Sim Cnts at [[0][1]:' , poiss_datons_padded_HDU.data[0][1]
        print 'HDU of Output Sim Cnts header:' , poiss_datons_padded_HDU.header
        self = poiss_datons_padded_HDU
        print 'self of Output Sim Cnts at [[0][1]:' , self.data[0][1]
        print 'self of Output Sim Cnts header:' , self.header
#        self.data = poiss_datons_padded_HDU.data
#        self.header = poiss_datons_padded_HDU.header
