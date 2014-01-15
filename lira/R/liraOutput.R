require(lira)
require(FITSio)

liraOutput<-function(obsFile,startFile=FALSE,mapFile=F, bkgFile=FALSE,psfFile=FALSE,fit.bkg.scale=T,outDir='/data/reu/kmckeough/KM_lira/outputs/',maxIter,alpha.init,thin=0,burn=0){

#INPUTS:
	#obsFile   - string;a 2^n x 2^n matrix which you would like to
		   #analyze; put this file in the current directory
	#startFile --initial values for residuals
	#mapFile   -string; exposure map
	#bkgFile   -null model
	#psfFile   -psf
	#outDir	   - output directory specific to machine
	#maxIter   - lira() input; the maximum number of iterations
	#alpha.init- set smoothing parameters (higher=more smoothing)
	#WARNING: Other inputs specific to lira must be coded into script below

#OUTPUTS:
	#.out
	#.param
	#.pdf

#Extract data and formmat to array/matrix

#Read in FITS files
	obs <- readFITS(obsFile)
	obsmat <- matrix(data=obs$imDat,nrow=obs$axDat$len[1],
	ncol=obs$axDat$len[2])
		
	if(startFile!= F){
		   strt <- readFITS(startFile)
		   strtmat <- matrix(data=strt$imDat,
		   nrow=strt$axDat$len[1],
		   ncol=strt$axDat$len[2])
		   }else{
		   strtmat<-matrix(1, nrow(obsmat),
		   ncol(obsmat))}
	if(mapFile!= F){
		   map <- readFITS(mapFile)
		   mapmat<- matrix(data=map$imDat,
		   nrow=map$axDat$len[1],
		   ncol=strt$axDat$len[2])
		   }else{
		   mapmat<-matrix(1, nrow(obsmat),
		   ncol(obsmat))}
	if(bkgFile != F){
		   bkgd <- readFITS(bkgFile)
		   bkgdmat <- matrix(data=bkgd$imDat,
		   nrow=bkgd$axDat$len[1],
		   ncol=bkgd$axDat$len[2])
		   }else{
		   bkgdmat<-matrix(0, nrow(obsmat),
		   ncol(obsmat))}
	if(psfFile != F){
		   psf <- readFITS(psfFile)
		   psfmat <- matrix(data=psf$imDat,
		   nrow=psf$axDat$len[1],
		   ncol=psf$axDat$len[2])
		   #psfmat <- matrix(data=psf$imDat,
		   #nrow=psf$axDat$len[1])
		   }else{
		   psfmat<-matrix(1, 1, 1)}
#Create output file names		   		 
	basename<-strsplit(obsFile,split='\\.')[[1]]
	outsave<-paste(outDir,basename[1],'.out',sep='')
	paramsave<-paste(outDir,basename[1],'.param',sep='')
	pdfsave<-paste(outDir,basename[1],'.pdf',sep='')
	
#Run lira (see lira documentation for help)
	img<-lira(obs.matrix=obsmat, start.matrix=strtmat,map.matrix=mapmat,
	  bkg.matrix=bkgdmat, psf.matrix=psfmat, out.file=outsave,
	  fit.bkg.scale=fit.bkg.scale,thin=thin,burn=burn,
	  param.file=paramsave,max.iter=maxIter, alpha.init=alpha.init)

#Write PDF ofimages
	pdf(pdfsave, width=12,height=4.25)
	  par(mfrow=c(1,3))
	  image(obsmat, xaxt="n", yaxt="n", main="Observed Data")
	  image(psfmat, xaxt="n", yaxt="n", main="Null/Best-Fit/Background Model")
	  image(img$final, xaxt="n", yaxt="n", main="Mean MultiScale of Data/Model MisMatch")
	dev.off()
	
	return(img)

}
