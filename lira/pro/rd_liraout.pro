function rd_liraout,iterimgfile=iterimgfile,paramfile=paramfile,$
	datafile=datafile,basefile=basefile,psffile=psffile,$
	datdir=datdir,outputsdir=outputsdir,$
	help=help,verbose=verbose
;+
;function	rd_liraout
;	reads in all the stuff that goes into and out of LIRA and puts them
;	all in an easily accessible structure
;
;syntax
;	lirastr=rd_liraout(iterimgfile=iterimgfile,paramfile=paramfile,$
;	datafile=datafile,basefile=basefile,psffile=psffile,$
;	datdir=datdir,outputsdir=outputsdir, /help,verbose=verbose)
;
;parameters	NONE
;
;keywords	all inputs are optional. If any of the filenames or the
;		directory names are not given, or if the names are '-' or '?',
;		DIALOG_PICKFILE() is invoked to specify the right names
;		(and it won't quit until something is chosen)
;	iterimgfile	name of file that contains the images from each
;			iteration
;	paramfile	name of file that contains the parameters at each
;			iteration
;			* ITERIMGFILE and PARAMFILE could have full pathnames.
;			  if they do, OUTPUTSDIR is ignored.
;			  if not, it is prepended.
;	datafile 	name of file that contains data that LIRA operates on
;	basefile	name of file that contains baseline model that LIRA uses
;	psffile 	name of file that contains the PSF
;			* DATAFILE, BASEFILE, and PSFFILE could have full
;			  pathnames.  if they do, DATDIR is ignored.
;			  if not, it is prepended
;	datdir  	directory that contains DATAFILE, BASEFILE, PSFFILE
;			* default is '/data/hea-intern10/lira_new/'
;	outputsdir	directory that contains ITERIMGFILE and PARAMFILE
;			* default is '/data/hea-intern10/lira_new/'
;	help     	prints calling sequence and exits
;	verbose 	controls chatter
;
;history
;	vinay kashyap (2013jul)
;-

if keyword_set(help) then begin
  print,'lirastr=rd_liraout(iterimgfile=iterimgfile,paramfile=paramfile,$
  print,'        datafile=datafile,basefile=basefile,psffile=psffile,$
  print,'        datdir=datdir,outputsdir=outputsdir, /help,verbose=verbose)'
  print,'read in all inputs and outputs of LIRA and put them into a structure'
  return,-1L
endif

;	inputs
vv=0L & if keyword_set(verbose) then vv=long(verbose[0])>1L

;if not keyword_set(datdir) then dirdat=getenv('PWD') else begin
if not keyword_set(datdir) then dirdat='/data/hea-intern10/lira_new/' else begin
  dirdat=strtrim(datdir,2)
  c1=strmid(dirdat,0,1)
  if c1 eq '' or c1 eq '-' or c1 eq '?' then dirdat=dialog_pickfile(/directory,title='Select DATDIR')
  while not keyword_set(dirdat) do begin
    message,'select a directory name and click OK to accept',/informational
    dirdat=dialog_pickfile(/directory,title='Select DATDIR')
  endwhile
endelse
if vv gt 0 then print,'DATDIR = '+dirdat

;if not keyword_set(outputsdir) then diroutputs=getenv('PWD') else begin
if not keyword_set(outputsdir) then diroutputs='data/hea-intern10/lira_new/' else begin
  diroutputs=strtrim(outputsdir,2)
  c1=strmid(diroutputs,0,1)
  if c1 eq '' or c1 eq '-' or c1 eq '?' then diroutputs=dialog_pickfile(/directory,title='Select OUTPUTSDIR')
  while not keyword_set(diroutputs) do begin
    message,'select a directory name and click OK to accept',/informational
    diroutputs=dialog_pickfile(/directory,title='Select OUTPUTSDIR')
  endwhile
endelse
if vv gt 0 then print,'OUTPUTSDIR = '+diroutputs

filiterimg=''
if keyword_set(iterimgfile) then begin
  c1=strmid(strtrim(iterimgfile[0],2),0,1)
  if c1 eq '.' or c1 eq '/' then filiterimg=strtrim(iterimgfile[0],2) else begin
    filiterimg=filepath(strtrim(iterimgfile[0],2),root_dir=diroutputs)
    if c1 eq '' or c1 eq '-' or c1 eq '?' then filiterimg=''
  endelse
endif
while not keyword_set(filiterimg) do begin
  message,'select a file name and click OK to accept',/informational
  filiterimg=dialog_pickfile(path=diroutputs,/must_exist,title='Select ITERIMGFILE')
endwhile
if vv gt 0 then print,'ITERIMGFILE = '+filiterimg

filparam=''
if keyword_set(paramfile) then begin
  c1=strmid(strtrim(paramfile[0],2),0,1)
  if c1 eq '.' or c1 eq '/' then filparam=strtrim(paramfile[0],2) else begin
    filparam=filepath(strtrim(paramfile[0],2),root_dir=diroutputs)
    if c1 eq '' or c1 eq '-' or c1 eq '?' then filparam=''
  endelse
endif
while not keyword_set(filparam) do begin
  message,'select a file name and click OK to accept',/informational
  filparam=dialog_pickfile(path=diroutputs,/must_exist,title='Select PARAMFILE')
endwhile
if vv gt 0 then print,'PARAMFILE = '+filparam

fildata=''
if keyword_set(datafile) then begin
  c1=strmid(strtrim(datafile[0],2),0,1)
  if c1 eq '.' or c1 eq '/' then fildata=strtrim(datafile[0],2) else begin
    fildata=filepath(strtrim(datafile[0],2),root_dir=dirdat)
    if c1 eq '' or c1 eq '-' or c1 eq '?' then fildata=''
  endelse
endif
while not keyword_set(fildata) do begin
  message,'select a file name and click OK to accept',/informational
  fildata=dialog_pickfile(path=diroutputs,/must_exist,title='Select DATAFILE')
endwhile
if vv gt 0 then print,'DATAFILE = '+fildata

filbase=''
if keyword_set(basefile) then begin
  c1=strmid(strtrim(basefile[0],2),0,1)
  if c1 eq '.' or c1 eq '/' then filbase=strtrim(basefile[0],2) else begin
    filbase=filepath(strtrim(basefile[0],2),root_dir=dirdat)
    if c1 eq '' or c1 eq '-' or c1 eq '?' then filbase=''
  endelse
endif
while not keyword_set(filbase) do begin
  message,'select a file name and click OK to accept',/informational
  filbase=dialog_pickfile(path=diroutputs,/must_exist,title='Select BASEFILE')
endwhile
if vv gt 0 then print,'BASEFILE = '+filbase

filpsf=''
if keyword_set(psffile) then begin
  c1=strmid(strtrim(psffile[0],2),0,1)
  if c1 eq '.' or c1 eq '/' then filpsf=strtrim(psffile[0],2) else begin
    filpsf=filepath(strtrim(psffile[0],2),root_dir=dirdat)
    if c1 eq '' or c1 eq '-' or c1 eq '?' then filpsf=''
  endelse
endif
while not keyword_set(filpsf) do begin
  message,'select a file name and click OK to accept',/informational
  filpsf=dialog_pickfile(path=diroutputs,/must_exist,title='Select PSFFILE')
endwhile
if vv gt 0 then print,'PSFFILE = '+filpsf

inpstr=create_struct('DATAFILE',fildata,'BASEFILE',filbase,'PSFFILE',filpsf,$
	'ITERIMGFILE',filiterimg,'PARAMFIL',filparam,$
	'DATADIR',dirdat,'OUTPUTSDIR',diroutputs)

if vv gt 100 then stop,'STOPing; type .CON to continue'

;	read in files that were input to LIRA
dataimg=mrdfits(fildata,0,hdat)
if not keyword_set(dataimg) then message,'DATAFILE: '+fildata+' not read'
szd=size(dataimg)
if szd[0] ne 2 then begin
  message,'DATA not read in; quitting!',/informational
  return,-1L
endif
nx=szd[1] & ny=szd[2]
if vv gt 10 then begin
  if !d.name eq 'X' then window,0,xsize=512,ysize=512,title='DATA'
  tvscl,rebin(alog10(dataimg>0.1),512,512)
endif
baseimg=mrdfits(filbase,0,hbas)
if not keyword_set(baseimg) then message,'BASEFILE: '+filbase+' not read'
if vv gt 10 then begin
  if !d.name eq 'X' then window,1,xsize=512,ysize=512,title='BASELINE'
  tvscl,rebin(alog10(baseimg>(0.001*max(baseimg))),512,512)
endif
psfimg=mrdfits(filpsf,0,hpsf)
szp=size(psfimg) & mx=szp[1] & my=szp[2]
if not keyword_set(psfimg) then message,'PSFFILE: '+filpsf+' not read'
if vv gt 10 then begin
  if !d.name eq 'X' then window,2,xsize=512,ysize=512,title='PSF'
  tvscl,rebin(alog10(psfimg>(0.001*max(psfimg))),mx*2,my*2)
endif
lirastr=create_struct('INPUTS',inpstr,$
	'DATA',dataimg,'BASELINE',baseimg,'PSF',psfimg,'HEADER',hdat)

;	read in files that were output from LIRA

;	parameter draws
spawn,'grep -v ^# '+filparam,cc
parcols=strsplit(cc[0],' ',/extract)
niter=n_elements(cc)-1L & ncols=n_elements(parcols)
var=dblarr(ncols,niter) & openr,upar,filparam,/get_lun
cc='' & c1='#'
while c1 eq '#' do begin & readf,upar,cc & c1=strmid(cc,0,1) & endwhile
readf,upar,var
close,upar & free_lun,upar
for i=0,ncols-1 do jnk=execute("lirastr=create_struct(lirastr,'"+$
	parcols[i]+"',reform(var[i,*]))")
if vv gt 5 then begin
  if !d.name eq 'X' then window,3,xsize=900,ysize=800,title='traces'
  pmulti=!p.multi & !p.multi=[0,3,ncols/3+1]
  for i=0,ncols-1 do plot,var[i,*],title=parcols[i],charsize=1.4
  !p.multi=pmulti
endif

;	images
iterimg=dblarr(nx,ny,niter)
openr,uit,filiterimg,/get_lun & readf,uit,iterimg & close,uit & free_lun,uit
if vv gt 5 then begin
  if !d.name eq 'X' then window,4,xsize=512,ysize=512,title='ITERIMG'
  avimg=total(iterimg,3)/float(niter)
  tvscl,rebin(alog10(avimg>(1e-4*max(avimg))),512,512)

  if !d.name eq 'X' then window,5,xsize=512,ysize=512,title='SNR'
  sdimg=0.*avimg
  for ix=0L,nx-1L do for iy=0L,ny-1L do $
  	sdimg[ix,iy]=stddev(iterimg[ix,iy,*],/nan)
  o0=where(sdimg gt 0,mo0) & if mo0 gt 0 then sdmin=min(sdimg[o0]) else sdmin=0.
  snrimg=avimg/(sdimg>sdmin)
  tvscl,rebin(snrimg,512,512)

endif
lirastr=create_struct(lirastr,'ITERIMG',iterimg,$
	'AVGIMG',avimg,'SDEVIMG',sdimg,'SNRMAP',snrimg)

return,lirastr
end
