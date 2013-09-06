;+
;procedure	liraimages
;	LIRA produces two output files, one a list of parameter values
;	from all iterations (the .param file), and another a full
;	posterior draw of the multiscale component as an image at each
;	iteration (the .out file).  These are read in using RD_LIRAOUT(),
;	and this procedure looks at the outputs for up to 7 different
;	runs, makes a number of useful summary plots, and writes out FITS
;	files with proper WCS information (lifted from the relevant input
;	data file).
;
;syntax
;	liraimages,lstr0,lstr1,lstr2,lstr3,lstr4,lstr5,lstr6,lstr7,
;	lstr8,lstr9,lstr10,lstr11,lstr12,lstr13,lstr14,$
;	lstr15,lstr16,lstr17,lstr18,lstr19,lstr20,lstr21,$
;	lstr22,lstr23,lstr24,lstr25,lstr26,lstr27,lstr28,$
;	outroot=outroot,idxfrom=idxfrom
;
;parameters
;	lstr0	[INPUT; required] output from RD_LIRAOUT()
;	lstr1	[INPUT; optional] LIRA outputs from another run, for comparison
;	...
;	lstr28	[INPUT; optional] LIRA outputs from another run, for comparison
;
;keywords
;	outroot	[INPUT] root name for outputs
;		* default is 'liraout'
;		* creates the following output files in $cwd --
;		  OUTROOT_##_avgmscomp.fits : image of the multiscale component
;			intensities, averaged over the iterations
;		  OUTROOT_##_snr.fits : image of the S/N
;		  (not implemented yet) OUTROOT_##_iterimg.fits : images from
;			all iterations
;		  OUTROOT_##_data : ps or jpg of the data image
;		  OUTROOT_##_data_base : ps or jpg of the data image with
;			contours from the baseline
;		  OUTROOT_##_avgmscomp : ps or jpg of the average multiscale
;			component
;		  OUTROOT_##_snr : ps or jpg of the S/N map
;	idxfrom	[INPUT] only look at iterations IDXFROM:*
;		* ignored if undefined, 0, or >number of iterations
;		* if scalar, same value is applied to all input LSTR
;		* if vector, values are attached to LSTRs until one or the
;		  other runs out
;		  -- if IDXFROM runs out first, last value is applied to all
;		     remaining
;		* if -ve, say -N, picks last N available iterations
;		  
;restrictions
;	- input must have been read in using RD_LIRAOUT()
;	- uses Coyote Library routines
;	  CGDISPLAY, CGLOADCT, CGIMAGE, CGCONLEVELS, CGCONTOUR
;	  and associated subroutines.  You can get these routines from
;	  http://www.idlcoyote.com/documents/programs.php#COYOTE_LIBRARY_DOWNLOAD
;	- uses the FITS I/O routines from IDL-Astro.  You can get them from
;	  http://idlastro.gsfc.nasa.gov
;
;history
;	vinay kashyap (2013jul)
;	added keyword IDXFROM, allowed more LSTRs to be input (up to 28)
;	  (VK; 2013aug)
;-

pro plot_contour_over_image,image,contour,$
	nlevels=nlevels,xtitle=xtitle,ytitle=ytitle,title=title,$
	windowid=windowid,Tlocation=Tlocation,$
	inlog=inlog

np=n_params()
if np eq 0 then begin
  print,'Usage: plot_contour_over_image,image,contour,$'
  print,'       nlevels=nlevels,xtitle=xtitle,ytitle=ytitle,title=title,$'
  print,'       windowID=windowID,Tlocation=Tlocation
  print,'  uses Coyote library to plot contour lines over an image and adds a color bar'
  return
endif
if np eq 1 then contour=image
if n_elements(contour) eq 0 then contour=image

zimg=image

if not keyword_set(nlevels) then nlevels=10
if not keyword_set(xtitle) then xtitle='X'
if not keyword_set(ytitle) then ytitle='Y'
if not keyword_set(title) then title='DATA'
if not keyword_set(Tlocation) then Tlocation='Top'
if not keyword_set(windowID) then windowID=0

cbTitle='Value'

cminValue=floor(min(contour)) & cmaxValue=ceil(max(contour))
iminValue=floor(min(zimg)) & imaxValue=ceil(max(zimg))
if keyword_set(inlog) then begin
  if iminvalue ge 0 then begin
    o0=where(zimg gt 0,mo0)
    if mo0 gt 0 then begin
      tmpmin=min(zimg[o0])
      tmpimg=alog10(zimg>tmpmin)
      iminValue=floor(min(tmpimg)) & imaxValue=ceil(max(tmpimg))
      zimg=tmpimg
      cbtitle='log(Value)'
    endif
  endif
endif
print,'		contour range:',cminValue,cMaxvalue
print,'		image range:',iminValue,iMaxvalue

position  =[0.125,0.125,0.9,0.800]
cbposition=[0.125,0.125,0.9,0.895]

cgdisplay,600,650,Title=title,wid=windowID

cgloadct,33,CLIP=[30,255]

cgimage,zimg,stretch=1,minvalue=iminvalue,maxvalue=imaxvalue,/axes,xtitle=xtitle,ytitle=ytitle,position=position,/keep_aspect

contourLevels=cgconlevels(contour,NLevels=nlevels,minvalue=cminvalue)

cgcontour,contour,Levels=contourLevels,/OnImage,color='charcoal'

cgcolorbar,Position=cbposition,Range=[iMinValue,iMaxValue],Title=cbtitle,Tlocation=Tlocation,/Fit

return
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro liraimages,lirastr,$
	lstr1,lstr2,lstr3,lstr4,lstr5,lstr6,lstr7,$
	lstr8,lstr9,lstr10,lstr11,lstr12,lstr13,lstr14,$
	lstr15,lstr16,lstr17,lstr18,lstr19,lstr20,lstr21,$
	lstr22,lstr23,lstr24,lstr25,lstr26,lstr27,lstr28,$
	outroot=outroot,idxfrom=idxfrom

;	usage
ok='ok' & np=n_params() & nl=n_elements(lirastr) & nlt=n_tags(lirastr)
if np eq 0 then ok='insufficient parameters' else $
 if nl eq 0 then ok='LSTR0 is not defined -- see rd_liraout()' else $
  if nlt eq 0 then ok='LSTR0 must be a structure'
if ok ne 'ok' then begin
  print,'Usage: liraimages,lstr0,$
  print,'       lstr1,lstr2,lstr3,lstr4,lstr5,lstr6,lstr7,$
  print,'       lstr8,lstr9,lstr10,lstr11,lstr12,lstr13,lstr14,$
  print,'       lstr15,lstr16,lstr17,lstr18,lstr19,lstr20,lstr21,$
  print,'       lstr22,lstr23,lstr24,lstr25,lstr26,lstr27,lstr28,$
  print,'       outroot=outroot,idxfrom=idxfrom'
  print,'  make some useful images from LIRA outputs'
  if np ne 0 then message,ok,/informational
  return
endif

;	initialize
peasecolr & loadct,12 & peasecolr

;	keywords
;OUTROOT
root='liraout' & szr=size(outroot)
if keyword_set(outroot) and $
 szr[0] lt 1 and $
  szr[n_elements(szr)-2] eq 7 then root=strtrim(outroot[0],2)
;IDXFROM
iter0=lonarr(np) & nif=n_elements(idxfrom)
if nif gt 0 then iter0[*]=idxfrom[nif-1L]
if nif gt 0 then iter0[0L:(np<nif)-1L]=idxfrom[0L:(nif<np)-1L]

ltags=tag_names(lirastr) & ntags=n_elements(ltags)

numstr=np & numiter=lonarr(np)
for i=1L,numstr-1L do begin
  ss=strtrim(i,2)
  jnk=execute("lstrX=lstr"+ss)
  numX=n_tags(lstrX)
  if numX gt 0 then ltagsX=tag_names(lstrX) else ltagsX=''
  jnk=execute("num"+ss+"=numX & ltags"+ss+"=ltagsX")
endfor

;	first make traces
npars=ntags-10 & pmulti=!p.multi & !p.multi=[0,3,npars/3]
if !d.name eq 'X' then window,0,xsize=1024,ysize=900,title='TRACES'
if !d.name eq 'PS' then device,file=root+'_traces.ps',landscape=1
for i=0L,ntags-1L do begin
  if ltags[i] ne 'DATA' $
    and ltags[i] ne 'BASELINE' $
    and ltags[i] ne 'PSF' $
    and ltags[i] ne 'ITERATION' $
    and ltags[i] ne 'ITERIMG' $
    and ltags[i] ne 'INPUTS' $
    and ltags[i] ne 'AVGIMG' $
    and ltags[i] ne 'SDEVIMG' $
    and ltags[i] ne 'SNRMAP' $
    and ltags[i] ne 'HEADER' then begin
    ;yy=lirastr.(i) & yrange=median(yy)+10*stddev(yy,/nan)*[-1,1]
    plot,lirastr.(i),title=ltags[i],charsize=1.4,thick=2
    for j=1L,numstr-1L do begin
      ss=strtrim(j,2) & jnk=execute("numX=num"+ss+" & ltagsX=ltags"+ss+" & lstrX=lstr"+ss)
      if numX gt 0 then begin
        ok=where(ltagsX eq ltags[i],mok)
        if mok gt 0 then oplot,lstrX.(ok[0]),col=j+1
      endif
    endfor
    oplot,lirastr.(i),col=1
  endif
endfor
!p.multi=pmulti
if !d.name eq 'X' then write_jpeg,root+'_traces.jpg',tvrd(/true),/true
if !d.name eq 'PS' then device,/close

;	make images and contours of data, baseline, average, and snrmap
;	(makes heavy use of Coyote graphics)
for j=0,numstr-1 do begin	;{for each of lstrX
  if j eq 0 then lstrX=lirastr else jnk=execute("lstrX=lstr"+strtrim(j,2))

  print,'Working on structure #'+strtrim(j,2)
  print,'data: '+lstrX.INPUTS.DATAFILE
  print,'base: '+lstrX.INPUTS.BASEFILE
  print,'iter: '+lstrX.INPUTS.ITERIMGFILE

  iterimg=lstrX.ITERIMG
  szi=size(iterimg) & nx=szi[1] & ny=szi[2] & niter=szi[3]
  miter=iter0[j]
  if iter0[j] lt 0 then miter=(niter+iter0[j]) > 0
  if iter0[j] gt niter then miter=0
  ;avgimg=total(iterimg,3,/nan)/float(niter)
  avgimg=total(iterimg[*,*,miter:*],3,/nan)/float(niter-miter)
  sdimg=0.*avgimg & snrimg=sdimg

  ;for ix=0L,nx-1L do for iy=0L,ny-1L do $
  ;	sdimg[ix,iy]=stddev(iterimg[ix,iy,*],/nan)

  if not keyword_set(nosnr) then begin
  ;for ix=0L,nx-1L do for iy=0L,ny-1L do $
  ;	sdimg[ix,iy]=stddev(iterimg[ix,iy,miter:*],/nan)
  ;o0=where(sdimg gt 0,mo0) & if mo0 gt 0 then sdmin=min(sdimg[o0]) else sdmin=0.
  ;snrimg=avgimg/(sdimg>sdmin)
  endif

  ;	FITS image of average
  mwrfits,avgimg,root+'_'+string(j,'(i2.2)')+'_avgmscomp.fits',lstrX.HEADER,/create

  ;	FITS image of snr
  if total(snrimg) gt 0 then mwrfits,snrimg,root+'_'+string(j,'(i2.2)')+'_snr.fits',lstrX.HEADER,/create

  ;;	FITS output file of multiscale iterations
  ;SKIP THIS FOR NOW!
  ;mwrfits,lstrX.DATA,root+'_iterimg.fits',lstrX.HEADER,/create
  ;for k=0L,niter-1L do mwrfits,reform(iterimg[*,*,k]),root+'_'+string(j,'(i2.2)')+'_iterimg.fits',lstrX.HEADER,create=0

  ;	data image with contours
  print,'	'+root+'_'+string(j,'(i2.2)')+'_data'
  if !d.name eq 'PS' then PS_Start,root+'_'+string(j,'(i2.2)')+'_data.ps'
  image=lstrX.DATA
  plot_contour_over_image,lstrX.DATA,windowID=1
  if !d.name eq 'X' then write_jpeg,root+'_'+string(j,'(i2.2)')+'_data.jpg',tvrd(/true),/true
  if !d.name eq 'PS' then PS_End

  ;	data image with baseline contours
  print,'	'+root+'_'+string(j,'(i2.2)')+'_data_base'
  if !d.name eq 'PS' then PS_Start,root+'_'+string(j,'(i2.2)')+'_data_base.ps'
  plot_contour_over_image,lstrX.DATA,lstrX.BASELINE,title='DATA+BASELINE',windowID=2,/inlog
  if !d.name eq 'X' then write_jpeg,root+'_'+string(j,'(i2.2)')+'_data_base.jpg',tvrd(/true),/true
  if !d.name eq 'PS' then PS_End

  ;	average multiscale image with contours
  print,'	'+root+'_'+string(j,'(i2.2)')+'_avgmscomp'
  if !d.name eq 'PS' then PS_Start,root+'_'+string(j,'(i2.2)')+'_avgmscomp.ps'
  plot_contour_over_image,avgimg,title='AvgMScomp',windowID=3,/inlog
  if !d.name eq 'X' then write_jpeg,root+'_'+string(j,'(i2.2)')+'_avgmscomp.jpg',tvrd(/true),/true
  if !d.name eq 'PS' then PS_End

  ;	snr image with contours
  if not keyword_set(nosnr) then begin
    print,'	'+root+'_'+string(j,'(i2.2)')+'_snr'
    if !d.name eq 'PS' then PS_Start,root+'_'+string(j,'(i2.2)')+'_snr.ps'
    plot_contour_over_image,lstrX.SNRMAP,title='SNR',windowID=4
    if !d.name eq 'X' then write_jpeg,root+'_'+string(j,'(i2.2)')+'_snr.jpg',tvrd(/true),/true
    if !d.name eq 'PS' then PS_End
  endif

  print,'Done with input #'+strtrim(j,2) & c1=''
  if j lt numstr-1L then read,c1,form='(a1)',$
    prompt='Go to next one? [ctrl-C and <ret> to stop, <ret> to continue> '

endfor				;J=0,NUMSTR-1}

return
end
