# sim_image - function to make simulated null 2D images, based on the
# assumed model - gauss + constant
#
# It requires CIAO4.5/ciao_contrib script package and Sherpa
#
# INPUT: indirs directories with the data files (could be more than one)
#        infile - image file
#        psffile  - corresponding psf file
#        mcmciter - number of iteration in MCMC sampler, default = 5000
#        num - number of simulated null images, default = 50
#        mcmciter/num must be at least 100 
#
# OUTPUT: outnull - filename for the null model
#                  (image not convoled with the PSF)
#         .save - save file from Sherpa session
#                 (use restore to access later)
#         output simulated images called =  sim_null_#.fits

from ciao_contrib.runtool import *
from sherpa.astro.ui import *
import os

def sim_image(infile='img_64x64_0.5.fits', \
              psffile='psf_center_33x33.fits', \
              outnull = 'null_q1_c1.fits', \
              indirs= (10308, 10309), \
              mcmciter= 5000, num = 50):

    set_stat("cstat")
    set_method('simplex')

    for obsid in indirs:
        set_stat("cstat")
        set_method('simplex')
        print 'obsid', obsid
        os.chdir(str(obsid))
        load_image(infile)
        load_psf("mypsf", psffile)
        set_psf(mypsf)
        set_model(gauss2d.q1+const2d.c0)
        guess(q1)
        fit()
        results = get_fit_results()
        save(str(obsid)+'.save', clobber=True)
        save_source(outnull, clobber=True)
        covar()
        normgauss1d.g1
        g1.pos=q1.fwhm
        g1.fwhm = get_covar_results().parmaxes[0]
        set_prior(q1.fwhm,g1)
        set_sampler_opt('defaultprior', False)
        set_sampler_opt('priorshape', [True, False, False, False, False])
        set_sampler_opt('originalscale', [True, True, True, True, True])
        stats, accept, params = get_draws(1,niter=mcmciter)
        for i in range(num):
            print i
            set_par(q1.fwhm,params[0][(i+1)*100])
            fake()
            save_data("sim_null_{}.fits".format(i), clobber=True)
        clean()
        os.chdir('../..')



