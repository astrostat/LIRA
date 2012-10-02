from get_multi_txt_rmatrix import *

infile = '../outputs/Simple04_Prelim_Gauss2d1.5_PoisDatons128x128testEvsNull_Strt0.01_viaFits.param'
outfile= '../postprocessing/Simple04_Prelim_Gauss2d1.5_PoisDatons128x128testEvsNull_Strt0.01_viaFits.autocor'
numiters=300
numburnin=100

tstparams = ParamListTxt(infile,numiters)

tstparams.do_autocor(burnin=numburnin)

tstfile = open(outfile,'w')

# Write the meanings as titles:
outstr0 = ''
for kk in range(len(tstparams.meanings)):
    outstr0 += tstparams.meanings[kk]+'  '
outstr0 += '\n'
tstfile.write(outstr0)

# Now write the vales:
for jj in range( min( numiters-numburnin-2, len(tstparams.autocor[0]) ) ):
	outstr1 = ''
	for ii in range(len(tstparams.meanings)):
		#outstr1 += str( (tstparams.autocor[ii][jj]/tstparams.autocor[ii][0]) )+'  '
		outstr1 += str( (tstparams.autocor[ii][jj]) )+'  '
	outstr1 +='\n'
	tstfile.write(outstr1)

#Close:
tstfile.close()
