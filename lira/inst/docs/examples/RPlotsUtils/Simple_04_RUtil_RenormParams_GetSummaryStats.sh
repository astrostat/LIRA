r --vanilla --no-restore <<EOF

#######
####### R Routines to calculate a simple Euclidean-ish
####### 'distance' between the Null and Data results.
#######   1. The initial distance is defined via the
#######   *medians* of the null vs the data params.
#######   2. For each par sample, the distance between the
#######   initial null median and the param sample in question is
#######   then *divided by the sqrt(variance w.r.t. null median)*.
#######   3. The difference between each null and data median,
#######   divided by the null_std defined above, quantifies
#######   which distances are largest.  These are the ones from
#######   which to choose to make your Summary Statistic.
#######   4.  Typically, it is best to transform params first to
#######   a function that makes the (null) distribution look
#######   kind-of Gaussian (or at least roughly symmetric).
#######   That may be log(bkg-scale) and sqrt(MSCounts) or
#######   log10(bkg-scale) and log10(MSCounts), or ...

############ Set up universal params: ################################

numburnin = 25
ndim = 128

num_chopped_columns = 5
num_sumstats = 3
num_sort_indexes = 4

## This is a nuisance, to have to hard-code it.
## Unfortunately, in 'script' mode, I don't seem
## to be able to pick up attributes, e.g. ParNul0$logPost
numsamples_per_nulfile = 1025

numgoodsamples_per_nulfile = numsamples_per_nulfile - numburnin

numnulfiles = 10

numgoodsamples_per_allnulfiles = ( numnulfiles * numgoodsamples_per_nulfile )

############ Null First: ##############################################

################ Read in data files:
infileParNul0 = '../RunOutputs/Simple_04_PoisNull00_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.obs_viaFits.par'

ParNul0 <- read.table(infileParNul0, header = TRUE, sep = "", quote = "\"'",
            na.strings = "NA", colClasses = NA, nrows = -1,
            skip = 27, check.names = TRUE,
           comment.char = "#",
            allowEscapes = FALSE, flush = FALSE,
            encoding = "unknown")


infileParNul1 = '../RunOutputs/Simple_04_PoisNull01_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.02.0_viaFits.par'

ParNul1 <- read.table(infileParNul1, header = TRUE, sep = "", quote = "\"'",
            na.strings = "NA", colClasses = NA, nrows = -1,
            skip = 27, check.names = TRUE,
           comment.char = "#",
            allowEscapes = FALSE, flush = FALSE,
            encoding = "unknown")


####
infileParNul2 = '../RunOutputs/Simple_04_PoisNull02_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.0.02_viaFits.par'

ParNul2 <- read.table(infileParNul2, header = TRUE, sep = "", quote = "\"'",
            na.strings = "NA", colClasses = NA, nrows = -1,
            skip = 27, check.names = TRUE,
           comment.char = "#",
            allowEscapes = FALSE, flush = FALSE,
            encoding = "unknown")


infileParNul3 = '../RunOutputs/Simple_04_PoisNull03_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.obs_viaFits.par'

ParNul3 <- read.table(infileParNul3, header = TRUE, sep = "", quote = "\"'",
            na.strings = "NA", colClasses = NA, nrows = -1,
            skip = 27, check.names = TRUE,
           comment.char = "#",
            allowEscapes = FALSE, flush = FALSE,
            encoding = "unknown")


infileParNul4 = '../RunOutputs/Simple_04_PoisNull04_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.02.0_viaFits.par'

ParNul4 <- read.table(infileParNul4, header = TRUE, sep = "", quote = "\"'",
            na.strings = "NA", colClasses = NA, nrows = -1,
            skip = 27, check.names = TRUE,
           comment.char = "#",
            allowEscapes = FALSE, flush = FALSE,
            encoding = "unknown")


infileParNul5 = '../RunOutputs/Simple_04_PoisNull05_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.0.02_viaFits.par'

ParNul5 <- read.table(infileParNul5, header = TRUE, sep = "", quote = "\"'",
            na.strings = "NA", colClasses = NA, nrows = -1,
            skip = 27, check.names = TRUE,
           comment.char = "#",
            allowEscapes = FALSE, flush = FALSE,
            encoding = "unknown")


infileParNul6 = '../RunOutputs/Simple_04_PoisNull06_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.obs_viaFits.par'

ParNul6 <- read.table(infileParNul6, header = TRUE, sep = "", quote = "\"'",
            na.strings = "NA", colClasses = NA, nrows = -1,
            skip = 27, check.names = TRUE,
           comment.char = "#",
            allowEscapes = FALSE, flush = FALSE,
            encoding = "unknown")


infileParNul7 = '../RunOutputs/Simple_04_PoisNull07_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.02.0_viaFits.par'

ParNul7 <- read.table(infileParNul7, header = TRUE, sep = "", quote = "\"'",
            na.strings = "NA", colClasses = NA, nrows = -1,
            skip = 27, check.names = TRUE,
           comment.char = "#",
            allowEscapes = FALSE, flush = FALSE,
            encoding = "unknown")


infileParNul8 = '../RunOutputs/Simple_04_PoisNull08_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.0.02_viaFits.par'

ParNul8 <- read.table(infileParNul8, header = TRUE, sep = "", quote = "\"'",
            na.strings = "NA", colClasses = NA, nrows = -1,
            skip = 27, check.names = TRUE,
           comment.char = "#",
            allowEscapes = FALSE, flush = FALSE,
            encoding = "unknown")


infileParNul9 = '../RunOutputs/Simple_04_PoisNull09_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.02.0_viaFits.par'

ParNul9 <- read.table(infileParNul9, header = TRUE, sep = "", quote = "\"'",
            na.strings = "NA", colClasses = NA, nrows = -1,
            skip = 27, check.names = TRUE,
           comment.char = "#",
            allowEscapes = FALSE, flush = FALSE,
            encoding = "unknown")


## for checking:

length(ParNul0$logPost)

print( summary(ParNul0) )

numincols = length(ParNul0)
numincols

##########

nulmat <- matrix(data=NA,nrow=numgoodsamples_per_allnulfiles,ncol=numincols)

#### first two files:

for (j in 1:numgoodsamples_per_nulfile){
    for (i in 1:numincols) {
        nulmat[j,i] = ParNul0[(j+numburnin),i]
    }
}

for (j in 1:numgoodsamples_per_nulfile){
    for (i in 1:numincols) {
        nulmat[(numgoodsamples_per_nulfile+j),i] = ParNul1[(j+numburnin),i]
    }
}

#### Now the rest:

for (j in 1:numgoodsamples_per_nulfile){
    for (i in 1:numincols) {
        nulmat[((2*numgoodsamples_per_nulfile)+j),i] = ParNul2[(j+numburnin),i]
    }
}

for (j in 1:numgoodsamples_per_nulfile){
    for (i in 1:numincols) {
        nulmat[((3*numgoodsamples_per_nulfile)+j),i] = ParNul3[(j+numburnin),i]
    }
}

for (j in 1:numgoodsamples_per_nulfile){
    for (i in 1:numincols) {
        nulmat[((4*numgoodsamples_per_nulfile)+j),i] = ParNul4[(j+numburnin),i]
    }
}

for (j in 1:numgoodsamples_per_nulfile){
    for (i in 1:numincols) {
        nulmat[((5*numgoodsamples_per_nulfile)+j),i] = ParNul5[(j+numburnin),i]
    }
}

for (j in 1:numgoodsamples_per_nulfile){
    for (i in 1:numincols) {
        nulmat[((6*numgoodsamples_per_nulfile)+j),i] = ParNul6[(j+numburnin),i]
    }
}

for (j in 1:numgoodsamples_per_nulfile){
    for (i in 1:numincols) {
        nulmat[((7*numgoodsamples_per_nulfile)+j),i] = ParNul7[(j+numburnin),i]
    }
}

for (j in 1:numgoodsamples_per_nulfile){
    for (i in 1:numincols) {
        nulmat[((8*numgoodsamples_per_nulfile)+j),i] = ParNul8[(j+numburnin),i]
    }
}

for (j in 1:numgoodsamples_per_nulfile){
    for (i in 1:numincols) {
        nulmat[((9*numgoodsamples_per_nulfile)+j),i] = ParNul9[(j+numburnin),i]
    }
}


####### Printing our for checking:

#nulmat

summary(nulmat)

## Transform:

for (j in 1:numgoodsamples_per_allnulfiles) {
    j
    nulmat[j, numincols]    = log10(nulmat[j,numincols])
    nulmat[j, numincols]
    nulmat[j,(numincols-1)] = sqrt (nulmat[j,(numincols-1)])
    nulmat[j,(numincols-1)]
}

summary(nulmat)

## Get median and std:

nul_median <- numeric(numincols)
nul_std    <- numeric(numincols)

for (i in 1:numincols) {
    nul_median[i]    = median(nulmat[(1:numgoodsamples_per_allnulfiles),i])
}

nul_median

for (i in 1:numincols) {
    nul_std[i]    = sqrt( mean(
    (nulmat[(1:numgoodsamples_per_allnulfiles),i]-nul_median[i])*
    (nulmat[(1:numgoodsamples_per_allnulfiles),i]-nul_median[i])
    ) )
}

nul_std


########################################################################
################# Now Data: ############################################

## This is a nuisance, to have to hard-code it.
## Unfortunately, in 'script' mode, I don't seem
## to be able to pick up attributes, e.g. ParDat0$logPost
numsamples_per_datfile = 3000

numgoodsamples_per_datfile = numsamples_per_datfile - numburnin

numdatfiles = 3

numgoodsamples_per_alldatfiles = ( numdatfiles * numgoodsamples_per_datfile )
numgoodsamples_per_alldatfiles

############ Now Data: ##############################################

################ Read in data files:
infileParDat0 = '../RunOutputs/Simple_04_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter60000_thin20_Strt.obs_viaFits.par'

ParDat0 <- read.table(infileParDat0, header = TRUE, sep = "", quote = "\"'",
            na.strings = "NA", colClasses = NA, nrows = -1,
            skip = 27, check.names = TRUE,
           comment.char = "#",
            allowEscapes = FALSE, flush = FALSE,
            encoding = "unknown")


infileParDat1 = '../RunOutputs/Simple_04_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter60000_thin20_Strt.0.02_viaFits.par'


ParDat1 <- read.table(infileParDat1, header = TRUE, sep = "", quote = "\"'",
            na.strings = "NA", colClasses = NA, nrows = -1,
            skip = 27, check.names = TRUE,
           comment.char = "#",
            allowEscapes = FALSE, flush = FALSE,
            encoding = "unknown")


infileParDat2 = '../RunOutputs/Simple_04_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter60000_thin20_Strt.02.0_viaFits.par'

ParDat2 <- read.table(infileParDat2, header = TRUE, sep = "", quote = "\"'",
            na.strings = "NA", colClasses = NA, nrows = -1,
            skip = 27, check.names = TRUE,
           comment.char = "#",
            allowEscapes = FALSE, flush = FALSE,
            encoding = "unknown")


## for checking:

#length(Imgdat0$logPost)

print( summary(ParDat0) )

# Should be exactly the same as null:
#numincols = length(ParDat0)
#numincols

##########

datmat <- matrix(data=NA,nrow=numgoodsamples_per_alldatfiles,ncol=numincols)

#### first three files:

for (j in 1:numgoodsamples_per_datfile){
    for (i in 1:numincols) {
        datmat[j,i] = ParDat0[(j+numburnin),i]
    }
}

for (j in 1:numgoodsamples_per_datfile){
    for (i in 1:numincols) {
        datmat[(numgoodsamples_per_datfile+j),i] = ParDat1[(j+numburnin),i]
    }
}

for (j in 1:numgoodsamples_per_datfile){
    for (i in 1:numincols) {
        datmat[((2*numgoodsamples_per_datfile)+j),i] = ParDat2[(j+numburnin),i]
    }
}

####### Printing our for checking:

#datmat

summary(datmat)

## Transform:

for (j in 1:numgoodsamples_per_alldatfiles) {
    j
    datmat[j, numincols]    = log10(datmat[j,numincols])
    datmat[j, numincols]
    datmat[j,(numincols-1)] = sqrt (datmat[j,(numincols-1)])
    datmat[j,(numincols-1)]
}

summary(datmat)

## Get median and std:

dat_median <- numeric(numincols)
dat_std    <- numeric(numincols)

for (i in 1:numincols) {
    dat_median[i]    = median(datmat[(1:numgoodsamples_per_alldatfiles),i])
}

dat_median

for (i in 1:numincols) {
    dat_std[i]    = sqrt( mean(
    (datmat[(1:numgoodsamples_per_alldatfiles),i]-dat_median[i])*
    (datmat[(1:numgoodsamples_per_alldatfiles),i]-dat_median[i])
    ) )
}

dat_std

########################################################################
##################### Now Compare: #####################################

dif_datnul_median <- numeric(numincols)

difdatnul_median = dat_median - nul_median

difdatnul_median

for (i in 1:numincols) {
    difdatnul_median[i] = difdatnul_median[i]/nul_std[i]
}

difdatnul_median

##DIFFERENT RENORM!!
dif2datnul_median <- difdatnul_median
for (i in 1:numincols) {
    dif2datnul_median[i] = difdatnul_median[i]*(nul_std[i]/sqrt(nul_std[i]*nul_std[i]+dat_std[i]*dat_std[i]))
}

dif2datnul_median

######################################################
############ Making the Stat Summary vectors #########

len_vec = 0
for (i in (num_chopped_columns+1):numincols){
    len_vec = len_vec + difdatnul_median[i]*difdatnul_median[i]
}
len_vec = sqrt(len_vec)

print(len_vec)

StatSumTot_vec <- numeric(numincols-num_chopped_columns)
for (i in (num_chopped_columns+1):numincols){
    StatSumTot_vec[i-num_chopped_columns] = difdatnul_median[i]/len_vec
}
StatSumTot_vec


len_vec = 0.
StatSumHyp_vec <- numeric(numincols-num_chopped_columns)
for (i in (num_chopped_columns+1):numincols){
    if ( i <= (numincols-2) )
    { StatSumHyp_vec[i-num_chopped_columns] = difdatnul_median[i]
    len_vec = len_vec + difdatnul_median[i]*difdatnul_median[i] }
    else { StatSumHyp_vec[i-num_chopped_columns] = 0. }
}
len_vec = sqrt(len_vec)
StatSumHyp_vec = StatSumHyp_vec/len_vec
StatSumHyp_vec


len_vec = 0.
StatSumMSB_vec <- numeric(numincols-num_chopped_columns)
for (i in (num_chopped_columns+1):numincols){
    if ( i >= (numincols-1) )
    { StatSumMSB_vec[i-num_chopped_columns] = difdatnul_median[i]
    len_vec = len_vec + difdatnul_median[i]*difdatnul_median[i] }
    else { StatSumMSB_vec[i-num_chopped_columns] = 0. }
}
len_vec = sqrt(len_vec)
StatSumMSB_vec = StatSumMSB_vec/len_vec
StatSumMSB_vec

#######################################################################
######## Re-norming the input tables based on medians, stds: ##########
######## And -- adding three SumStat columns ... ######################

numoutcols = numincols - num_chopped_columns + num_sumstats + num_sort_indexes
numoutcols

############### DOING NULLS FIRST:

numoutrows = numgoodsamples_per_allnulfiles
numoutrows

renorm_nulmat <- matrix(data=NA,nrow=numoutrows,ncol=numoutcols)

renorm_nulmat[1:numoutrows,1:numoutcols] = 0.

for (j in 1:numoutrows){
    for (i in (num_chopped_columns+1):numincols){
####    First, for nul, put in 'renormed' versions of all parameters:
####    (i.e subtract nul median, divide by nul std)
####    Fill first columns with re-normed params:
        renorm_nulmat[j, i-num_chopped_columns] = ( (nulmat[j,i]-nul_median[i])/nul_std[i] )
####    Now to get Stat Summaries, do a DOT-PRODUCT with Stat Unit Vecs:
####    SO needs to be done row-by-row:
#       Just the Stat-Summary of the Hyper-prior params:
        renorm_nulmat[j, (numincols-num_chopped_columns +1) ] = renorm_nulmat[j, (numincols-num_chopped_columns +1) ] + 
            StatSumHyp_vec[i-num_chopped_columns]*renorm_nulmat[j, (i-num_chopped_columns)]
#       Just the Stat-Summary of the bkScale and MSCounts:
        renorm_nulmat[j, (numincols-num_chopped_columns +2) ] = renorm_nulmat[j, (numincols-num_chopped_columns +2) ] + 
            StatSumMSB_vec[i-num_chopped_columns]*renorm_nulmat[j, (i-num_chopped_columns)]
#       Total StatSum for all parameters
        temp_dotprod = StatSumTot_vec[i-num_chopped_columns]*renorm_nulmat[j,(i-num_chopped_columns)]
        renorm_nulmat[j, (numincols-num_chopped_columns +num_sumstats) ] = renorm_nulmat[j, (numincols-num_chopped_columns +num_sumstats) ] +
            temp_dotprod
    }
}
print("At End of Loop: length, summary of renorm_nulmat:")
print( length(renorm_nulmat) )
print( summary(renorm_nulmat) )

############### DOING DATA SECOND:

numoutrows = numgoodsamples_per_alldatfiles
numoutrows

renorm_datmat <- matrix(data=NA,nrow=numoutrows,ncol=numoutcols)

renorm_datmat[1:numoutrows,1:numoutcols] = 0.

for (j in 1:numoutrows){
    for (i in (num_chopped_columns+1):numincols){

####    First, for dat, put in 'renormed' versions of all parameters:
####    (i.e subtract nul median, divide by nul std)
####    Fill first columns with re-normed params:
        renorm_datmat[j, i-num_chopped_columns] = ( (datmat[j,i]-nul_median[i])/nul_std[i] )

####    Now to get Stat Summaries, do a DOT-PRODUCT with Stat Unit Vecs:
####    SO needs to be done row-by-row:
#       Just the Stat-Summary of the Hyper-prior params:
        renorm_datmat[j, (numincols-num_chopped_columns +1) ] = renorm_datmat[j, (numincols-num_chopped_columns +1) ] + 
            StatSumHyp_vec[i-num_chopped_columns]*renorm_datmat[j, (i-num_chopped_columns)]
#       Just the Stat-Summary of the bkScale and MSCounts:
        renorm_datmat[j, (numincols-num_chopped_columns +2) ] = renorm_datmat[j, (numincols-num_chopped_columns +2) ] + 
            StatSumMSB_vec[i-num_chopped_columns]*renorm_datmat[j, (i-num_chopped_columns)]
#       Total StatSum for all parameters
        temp_dotprod = StatSumTot_vec[i-num_chopped_columns]*renorm_datmat[j,(i-num_chopped_columns)]
        renorm_datmat[j, (numincols-num_chopped_columns +num_sumstats) ] = renorm_datmat[j, (numincols-num_chopped_columns +num_sumstats) ] +
            temp_dotprod
    }
}
print("At End of Loop: length, summary of renorm_datmat:")
print( length(renorm_datmat) )
print( summary(renorm_datmat) )



#######################################################################
######## Find the sorted indexes for SumStats ad MSCts ################

tmpmat <- matrix(data = 0., nrow = numoutrows, ncol = num_sort_indexes)

#######################################################################
### Null first:

for (jrow in 1:numoutrows){
    for ( i in ( ( numoutcols-(2*num_sort_indexes)+1 ):( numoutcols-num_sort_indexes ) ) ){
        ii = (i-numoutcols+(2*num_sort_indexes))
        tmpmat[jrow, ii ] = renorm_nulmat[jrow,i]
    }
}


sortindx_all <- matrix(data=0, nrow = numoutrows, ncol = num_sort_indexes)

for ( i in  1:num_sort_indexes ){

    tmpvec <- numeric(numoutrows)
    for (jj in 1:numoutrows){
        tmpvec[jj] = tmpmat[jj,i]
    }

    sortindx_i = sort.int(tmpvec, index.return = TRUE)
    sortindx_vec = as.vector(sortindx_i[[2]])
    for (jjj in 1:(length(sortindx_vec)) ) { sortindx_all[jjj,i] = sortindx_vec[jjj] }
    
}

######################################################################
### now add the sorted indexes sortindx_all to end of output array:

for (jrow in 1:numoutrows){
    for (icol in (numoutcols-num_sort_indexes+1):numoutcols){
        iicol = (icol-numoutcols+num_sort_indexes)
        renorm_nulmat[jrow,icol] = sortindx_all[jrow,iicol]
    }
}


######################################################################
### now add the sorted indexes sortindx_all to end of output array:

for (jrow in 1:numoutrows){
    for (icol in (numoutcols-num_sort_indexes+1):numoutcols){
        renorm_nulmat[jrow,icol] = sortindx_all[jrow,(icol-numoutcols+num_sort_indexes)]
    }
}

#######################################################################
### Now data:

for (jrow in 1:numoutrows){
    for ( i in ( ( numoutcols-(2*num_sort_indexes)+1 ):( numoutcols-num_sort_indexes ) ) ){
        ii = (i-numoutcols+(2*num_sort_indexes))
        tmpmat[jrow, ii ] = renorm_datmat[jrow,i]
    }
}


sortindx_all <- matrix(data=0, nrow = numoutrows, ncol = num_sort_indexes)

for ( i in  1:num_sort_indexes ){

    tmpvec <- numeric(numoutrows)
    for (jj in 1:numoutrows){
        tmpvec[jj] = tmpmat[jj,i]
    }

    sortindx_i = sort.int(tmpvec, index.return = TRUE)
    sortindx_vec = as.vector(sortindx_i[[2]])
    for (jjj in 1:(length(sortindx_vec)) ) { sortindx_all[jjj,i] = sortindx_vec[jjj] }
    
}

######################################################################
### now add the sorted indexes sortindx_all to end of output array:

for (jrow in 1:numoutrows){
    for (icol in (numoutcols-num_sort_indexes+1):numoutcols){
        iicol = (icol-numoutcols+num_sort_indexes)
        renorm_datmat[jrow,icol] = sortindx_all[jrow,iicol]
    }
}


#########################################################################
#######################################################################
######## Write out the Re-normed input tables: ########################
#########################################################################


colnames <- character(numoutcols)

for (i in 1:(numoutcols -num_sumstats -2) ){
    colnames[i] = "HypPar"
}
colnames[(numoutcols -num_sumstats -num_sort_indexes -1)] = "MSCounts"
colnames[(numoutcols -num_sumstats -num_sort_indexes   )] = "BkgScale"

colnames[(numoutcols -num_sort_indexes -2)] = "StatSumHyp"
colnames[(numoutcols -num_sort_indexes -1)] = "StatSumMSB"
colnames[(numoutcols -num_sort_indexes   )] = "StatSumTot"

colnames[(numoutcols -3)] = "iSortMSCts"
colnames[(numoutcols -2)] = "iSortSSMSB"
colnames[(numoutcols -1)] = "iSortSSHyp"
colnames[(numoutcols   )] = "iSortSSTot"

print(colnames)

outnulfile = '../PostProcessedFiles/Simple_04_PoisNull00to09_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120426a_iter20500_thin20_Strt.obs_viaFits.RenormSumStat.par'
write.table(renorm_nulmat,file=outnulfile,row.names=FALSE,col.names=colnames,sep="    ")

outdatfile = '../PostProcessedFiles/Simple_04_PoisDatons_128x128FaintE_conv_Gauss2d_Sig_1.5_17x17.20120427a_iter60000_thin20_Strt0to2_viaFits.RenormSumStat.par'
write.table(renorm_datmat,file=outdatfile,row.names=FALSE,col.names=colnames,sep="    ")
