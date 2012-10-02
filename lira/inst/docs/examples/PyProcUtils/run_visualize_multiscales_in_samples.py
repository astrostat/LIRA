import numpy as n
import pyfits

from get_R_table_Superseded_by_get_multi_txt import *
from ProbDensity_MCMCSamples_struct import *

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#
# Inputs:
#

indir0 = 'intermediatefiles/'

## These both have the burn-in chopped off.
## The param file has the 1st burn-in of BOTH runs commented out;
## while the chopmovies file has it already chopped off.

## These are the simple00 NoBckgrnd files:
#parfil = 'PoisDatons32x32EEMC2_NoBckgrnd_1_2.param'
#movfil = 'PoisDatons32x32EEMC2_NoBckgrnd_1_2_tst.chopmovies.fits'

## These are the simple02 simulated null datons
#parfil = 'PoisNulDat0to532x32EEMC2vsNullModel_Strt_0_1.param'
#movfil = 'PoisNulDat0to532x32EEMC2vsNullModel_Strt_0_1.chopmovies.fits'

## These are the simple02 runs with real data:
parfil = 'PoisDatons32x32EEMC2vsNullModel_Strt_0_1.param'
movfil = 'PoisDatons32x32EEMC2vsNullModel_Strt_0_1.chopmovies.fits'

#------------------------------------------------------------------------------#
#
# Outputs:
#

#outfilstem_rat = 'PoisDatons32x32EEMC2_NoBckgrnd_1_2.chop.MSratios'
#outfilstem_rat = 'PoisDatons32x32EEMC2_NoBckgrnd_1_2.chop.MSratios'

#outfilstem_rat = 'PoisNulDat0to532x32EEMC2vsNullModel_Strt_0_1.chop.MSratios'
#outfilstem_cts = 'PoisNulDat0to532x32EEMC2vsNullModel_Strt_0_1.chop.MScounts'

outfilstem_rat = 'PoisDatons32x32EEMC2vsNullModel_Strt_0_1.chop.MSratios'
outfilstem_cts = 'PoisDatons32x32EEMC2vsNullModel_Strt_0_1.chop.MScounts'

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#
# Getting parameter file:
#

RParamTableList = get_R_table(indir0+parfil)

[RParamHeader, RParamTable] = RParamTableList
nrows = len(RParamTable)
print 'RParamTable.shape: ',RParamTable.shape
#print 'RParamTable[0:nrows,3]: ', RParamTable[0:nrows,3]
#print 'RParamTable[0:nrows,4]: ', RParamTable[0:nrows,4]

InMCMCSpinParms = [RParamTable[0:nrows,3], RParamTable[0:nrows,4] ]

#------------------------------------------------------------------------------#
#
# Getting movie file into HDULst:
#

InMovieHDULst = pyfits.open(indir0+movfil)

#------------------------------------------------------------------------------#
#
# Calling the visualize multiple scales tool:
#

ThisMCMCSampleMovie = MCMCSamples( \
      InputsList=[InMovieHDULst[0].data,['cts per bin',],['MCMC Sample Image',]])


## July 20 2010: Some Problem with Ratios calculation!
##
See_Scales = ThisMCMCSampleMovie.visualize_nk_multiscales(InMovieHDULst[0], \
             InMCMCSpinParms, indir0+outfilstem_cts, indir0+outfilstem_rat )

AvCountsData = ThisMCMCSampleMovie.nk_scales_counts_mean
SgCountsData = ThisMCMCSampleMovie.nk_scales_counts_sigm
#AvRatiosData = ThisMCMCSampleMovie.nk_scales_ratios_mean
#SgRatiosData = ThisMCMCSampleMovie.nk_scales_ratios_sigm

AvCountsHDU = pyfits.PrimaryHDU(data=AvCountsData)
SgCountsHDU = pyfits.PrimaryHDU(data=SgCountsData)
#AvRatiosHDU = pyfits.PrimaryHDU(data=AvRatiosData)
#SgRatiosHDU = pyfits.PrimaryHDU(data=SgRatiosData)

AvCountsHDU.writeto(indir0+outfilstem_cts+'_Mean.fits')
SgCountsHDU.writeto(indir0+outfilstem_cts+'_Sigm.fits')
#AvRatiosHDU.writeto(indir0+outfilstem_rat+'_Mean.fits')
#SgRatiosHDU.writeto(indir0+outfilstem_rat+'_Sigm.fits')
