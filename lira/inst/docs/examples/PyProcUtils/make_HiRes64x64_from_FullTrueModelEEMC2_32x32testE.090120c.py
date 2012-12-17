from numpy import *
import pyfits

#---------------------------------------------------------------------------
#---------------------------------------------------------
#Current positions for E-point sources:

OldPointSourcesCoords = (
(18,28),        (20,28),        (22,28),       (24,28), \
 \
(18,25), \
                     (20,23),        (22,23), \
(18,22), \
 \
(18,19),        (20,19),        (22,19),       (24,19), )



#---------------------------------------------------------
#Current Positions for E Diffuse:

OldDiffBins = (
 (2,12), (3,12), (4,12), (5,12), (6,12), (7,12), (8,12), \
 (2,11), \
 (2,10), \
 (2, 9), \
 (2, 8), \
 (2, 7), (3, 7), (4, 7), (5, 7), (6, 7), (7, 7), (8, 7), \
 (2, 6), \
 (2, 5), \
 (2, 4), \
 (2, 3), (3, 3), (4, 3), (5, 3), (6, 3), (7, 3), (8, 3), )

#---------------------------------------------------------------------------
#---------------------------------------------------------------------------
#---------------------------------------------------------------------------
def make_HiRes_from_FullTrueModelE(oldpointsources,olddiffbins) :
    #
    #Now, for all of them, want to expand the bins by a factor a 4 in X and Y.
    #
    #The point-sources stay 10 pts in each bin; all single bins.
    #The Diffuse ones should be 4X wider, I think.
    #
    #SO at the top, 18 --> 18*4, etc. BUT that's in DS9 units
    #   which start at 1. python starts at 0:
    #
    #At the bottom, it will go to a range 5-8 e.g. 3*N_d+1 -- 4*N_d in DS9 Units!!
    #  SO expected counts/bin of 10. --> expected counts per bin' of +(9./16.)
    #
    #Rough py might look like:

    # 1) Background is now 1 ct/bin --> (1./16.) cts/bin
    HiResModel = ones((128,128))*1./16.

    # 2) Stars are point-sources -- just as bright per bin as before
    new_star_coords = asarray([0,0])
    for each_star_coords in oldpointsources:
        new_star_coords[0] = (each_star_coords[0] - 1)*4 + 1
        new_star_coords[1] = (each_star_coords[1] - 1)*4 + 1
        HiResModel[new_star_coords[1],new_star_coords[0]] += 9.

    # 3) Diffuse counts have to be spread out over 16 bins.
    #    Used to have 9 exces cts/bin.  Now will be 9 cts/16 bins.

    new_diff_limits = asarray([ [0,0],[0,0] ])
    for old_diff_coords in olddiffbins:
        new_diff_limits[0][0] =  (old_diff_coords[0] - 1)*4
        new_diff_limits[0][1] =  (old_diff_coords[1] - 1)*4
        new_diff_limits[1][0] =  (old_diff_coords[0])*4
        new_diff_limits[1][1] =  (old_diff_coords[1])*4
        # Fill in this square:
        for j in range(new_diff_limits[0][1],new_diff_limits[1][1]) :
            for i in range(new_diff_limits[0][0],new_diff_limits[1][0]) :
                HiResModel[j][i] += 9./16.
            #end-for-i
        #end-for-j
    #end-for-old_diff_coords

    ##HiResModel = done!!
    return HiResModel
#-------------------------------------------------------------------------------#
def make_HiResNullDiff_from_FullTrueModelE(olddiffbins) :
    #
    #

    # 1) Background is now 1 ct/bin --> (1./16.) cts/bin
    HiResModel = ones((128,128))*1./16.

    # 3) For this Null model, it's DIFFUSE COUNTS ONLY.
    #    Diffuse counts have to be spread out over 16 bins.
    #    Used to have 9 exces cts/bin.  Now will be 9 cts/16 bins.

    new_diff_limits = asarray([ [0,0],[0,0] ])
    for old_diff_coords in olddiffbins:
        new_diff_limits[0][0] =  (old_diff_coords[0] - 1)*4
        new_diff_limits[0][1] =  (old_diff_coords[1] - 1)*4
        new_diff_limits[1][0] =  (old_diff_coords[0])*4
        new_diff_limits[1][1] =  (old_diff_coords[1])*4
        # Fill in this square:
        for j in range(new_diff_limits[0][1],new_diff_limits[1][1]) :
            for i in range(new_diff_limits[0][0],new_diff_limits[1][0]) :
                HiResModel[j][i] += 9./16.
            #end-for-i
        #end-for-j
    #end-for-old_diff_coords

    ##HiResModel = done!!
    return HiResModel
#-------------------------------------------------------------------------------#
