
import numpy as n
import pyfits

# These are regions dividing the image into 4 quadrants:
regions = []
regions.append( [( 0,15),( 0,15)] )
regions.append( [( 0,15),(16,32)] )
regions.append( [(16,32),(16,32)] )
regions.append( [(16,32),( 0,15)] )

#These are regions containing an "E" -- or none!
regions = []
regions.append( [( 1, 7),( 2,11)] )  # Diffuse E
regions.append( [( 1, 7),(18,27)] )  # None
regions.append( [(17,23),(18,27)] )  # Point source E
regions.append( [(17,23),( 2,11)] )  # None

#These are single pixels of the "E"s -- or none!
regions = []
regions.append( [( 1, 2),( 2,3)] )  # Diffuse E
regions.append( [( 1, 2),(18,19)] )  # None
regions.append( [(17,18),(18,19)] )  # Point source E
regions.append( [(17,18),( 2,3)] )  # None

wrkdir = 'intermediatefiles/'

infiles = ( \
        'PoisDatons32x32EEMC2_NoBckgrnd_1_2.chop.MSratios_Lvl0.fits', \
        'PoisDatons32x32EEMC2_NoBckgrnd_1_2.chop.MSratios_Lvl1.fits', \
        'PoisDatons32x32EEMC2_NoBckgrnd_1_2.chop.MSratios_Lvl2.fits', \
         )

##-----------------------------

for ifil in infiles:
    this_lvl = pyfits.open(wrkdir+ifil)
    this_nsamples = this_lvl[0].data.shape[0]
    for k  in range(len(regions)):
        new_ar = this_lvl[0].data[0:this_nsamples, \
                 regions[k][0][0]:regions[k][0][1] , \
                 regions[k][1][0]:regions[k][1][1] ]
        new_fil_name = ifil[0:-4]+'PixOfReg'+str(k)+'.fits'
        new_HDU =pyfits.PrimaryHDU(data=n.asarray(new_ar).flatten())
        new_HDU.writeto(new_fil_name)
    #end-for
#    new_ar = this_lvl[0].data[0:, \
#               0:15, 0:15].flatten()
#    new_fil_name = ifil+'Reg'+str(0)
#    new_HDU =pyfits.PrimaryHDU(data=n.asarray(new_ar))
#    new_HDU.writeto(new_fil_name)
#    new_ar = this_lvl[0].data[0:, \
#               0:15, 16:32].flatten()
#    new_fil_name = ifil+'Reg'+str(1)
#    new_HDU =pyfits.PrimaryHDU(data=n.asarray(new_ar))
#    new_HDU.writeto(new_fil_name)
#    new_ar = this_lvl[0].data[0:, \
#               16:32, 0:15].flatten()
#    new_fil_name = ifil+'Reg'+str(2)
#    new_HDU =pyfits.PrimaryHDU(data=n.asarray(new_ar))
#    new_HDU.writeto(new_fil_name)
#    new_ar = this_lvl[0].data[0:, \
#               16:32,16:32].flatten()
#    new_fil_name = ifil+'Reg'+str(3)
#    new_HDU =pyfits.PrimaryHDU(data=n.asarray(new_ar))
#    new_HDU.writeto(new_fil_name)

#end-for-ifil
