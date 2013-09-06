# Example of using rebin_img() with Chandra data

obsids = (10307,10308)

for obsid in obsids:
    print 'obsid', obsid
    os.chdir(str(obsid))
    dmstat("acis_evt2.fits[sky=region(src.reg)][cols sky]")
    vals = [float(x) for x in dmstat.out_mean.split(',')]
    xval=vals[0]
    yval=vals[1]
    os.chdir('..')
    rebin_img(infile="evt2.fits[energy=500:7000]",outfile="img_128x128_0.5.fits",
              binsize=0.5, nsize=127, xcen=xval,ycen=yval)
    os.chdir('../..')
    
    

