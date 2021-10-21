#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>
#include <R.h>
#include <Rmath.h>


#define verbose 3          /* interger 0 to 10, higher more output to screen */
#define convg_em 1e-6      /* convergence criterion for EM */
#define convg_nr 1e-8      /* convergence criterion for Newton-Raphson */
#define convg_bisect 1e-8  /* convergence criterion for Bisection Optimizer */
#define MH_sd_inflate 2.0  /* an inflation factor for sd of MH jumping rule */
#define MH_iter 10         /* number of MH proposals per iteration */
#define NR_END 1
#define FREE_ARG char*
#define PAR_NOT_SET -42

/***************************************************************/
/************************* DATA STRUCTURES *********************/
/***************************************************************/


struct psfType{
  double **mat;       /* the point spread function */
  double **inv;       /* the matrix of inv probablities */
  int L;              /* the no of steps left allowed in psf */
  int R;              /* the no of steps right allowed in psf */
  int U;              /* the no of steps up allowed in psf */
  int D;              /* the no of steps down allowed in psf */
  int nrow;           /* the no of rows in psf */
  int ncol;           /* the no of columns in psf */
  FILE *file;         /* the psf file */
};

struct expmapType{
  double **map;       /* the exposure map -- re-normed by max_val [AVC Oct 2009]*/
  double **pr_det;    /* the probability cnt does not spill off detector */
  double **prod;      /* the product of map and pr_det */
  int ncol;           /* number of columns in exposure map */
  int nrow;           /* number of rows in exposure map */
  double max_val;     /* max value of input exposure map; for normalizing [AVC Oct 2009] */
  FILE *file;         /* the exposure map file */
};

struct cntType{
  double **data;      /* the counts */
  double **img;       /* the image (expected counts) */
  int ncol;           /* number of columns in data */
  int nrow;           /* number of rows in data */
  FILE *file;         /* the data or image file */
  int outmap_index;   /* the index varialbe for R output stream of image map */
  char *name;         /* name of the structure */
};

struct llikeType{
  double cur;         /* the current log likelihood of the iteration */
  double pre;         /* the previous log likelihood of the iteration */
};

struct msType{
  int  power;          /* log_2 of cnt.nrow */
  int spin;            /* 1 for cycle spinning, 0 for no cycle spinning */
  int fit_al;          /* 1 to fit alpha, 0 to fix alpha at start values */
  double *al;          /* the vector of multiscale smoothing parameters */ 
  double *al_init;     /* starting values for vector of smoothing parameters */
  double ***ag;        /* the multiscale aggregations */
  double ttlcnt_pr;    /* the prior on the total cnt in exposure = ttlcnt_exp */
  double ttlcnt_exp;   /* the prior exposure in units of the actual exposure */
                       /* the above propr params are the shape and scale of */
                       /* the gamma prior, with expectation = ..._pr / ..._exp */
  double al_kap1;      /* these define the prior on alpha:                        */
  double al_kap2;      /* p(alpha) = (alpha ^ kap1) * exp( -kap2 * alpha ^ kap3 ) */
  double al_kap3;      /*                                                         */
};

struct mrfType{
  int is_hi_res;       /* 1 if there is high res data, 0 if there is not */
  double **mean;       /* mean under markov random field */
  double **prec;       /* relative precision under markov random field, prec = 1 var */
  double **hi_res;     /* the log-scale matrix of high resolution data */
  double ****wts;      /* the hyper-matrix of neighbor weights */
  double mn_wt;        /* the mean of all the weights in wts */
  int n_wts;           /* the number of weights in wts */ 
  double scl_prec;     /* the scale for mrf_prec = 1 / var */
  double max_wt;       /* the maximum weight, weights are adjusted to be < max_wt */
  FILE *file;          /* the high resoultion data file */
  FILE *out;           /* the computed precision file */
};

struct scalemodelType{
  double scale;        /* the scale parameter */
  double scale_pr;     /* the prior on the total cnt in exposure = ttlcnt_exp */
  double scale_exp;    /* the prior exposure in units of the actual exposure */
};

struct controlType{
  // FILE *file;          /* the input file of control variables */
  FILE *debug;         /* a file to dump temporary output into */
  int iter;            /* the main iteration number */
  int max_iter;        /* the max number of iter for EM / number of Gibbs draws */
  int burn;            /* the number of burn-in draws to ignore when computing the posterior mean image */
  int save_iters;      /* 1 to print iters of src.img to R stream  & out file */
  int save_thin;       /* if save_iters, print every (save_thin)th to R & out file */
  int pipe_to_R;       /* one to pipe output to R, zero to only send to out file */
  int model;           /* control variable for choice of model (ie, prior) */
                       /*        0 for ml, 1 for ms, 2 for mrf */
  int em;              /* control variable: 1 for EM, 0 for MCMC */
  int wrap;            /* control variable, 1 to wrap col and row, 0 to spill cnts
                          of detector */
  int ml;              /* control variable: 1 for maximum likelihood, 0 otherwise */
  int ms;              /* control variable: 1 for multi scale, 0 otherwise */
  int mrf;             /* control variable: 1 for Markov Rand Field, 0 otherwise */
  int fit_bkg_scl;     /* 1 to fit a scale parameter to the background model */
};


typedef struct psfType psfType;
typedef struct expmapType expmapType;
typedef struct cntType cntType;
typedef struct llikeType llikeType;
typedef struct msType msType;
typedef struct mrfType mrfType;
typedef struct scalemodelType scalemodelType;
typedef struct controlType controlType;

/***************************************************************/
/******************  FUNCTION DECLARATIONS *********************/
/***************************************************************/

void c_error(char error_text[]);
void print_mat(char label_text[], double **mat, int nrow, int ncol);
void fprint_mat(FILE *outfile, double **mat, int nrow, int ncol);
void write_img_to_Routput(double *outmap, cntType *cnt);
int wrap(int i, int max);
double **matrix(long nrl, long nrh, long ncl, long nch);
void free_matrix(double **m, long nrl, long nrh, long ncl, long nch);
void allocate_memory(psfType *psf, expmapType *expmap, cntType *obs, 
				   cntType *deblur, cntType *src, cntType *bkg, 
				   msType *ms, mrfType *mrf, scalemodelType 
           *bkg_scale, controlType *cont);
void initialize_control(controlType *cont, expmapType *expmap, psfType *psf,
           msType *ms, int *max_iter, int *burn, int *save_iters, int *save_thin, int *nrow, 
           int *ncol, int *nrow_psf, int *ncol_psf, int *em, int *fit_bkg_scl, 
           double *alpha_init, int *alpha_init_len, double *ms_ttlcnt_pr, 
           double *ms_ttlcnt_exp, double *ms_al_kap2,double *ms_al_kap1,double *ms_al_kap3);
void read_psf(psfType *psf);
void read_bkg(cntType *bkg);
void read_data_or_image(int image, cntType *cnt);
void read_hires(cntType *cnt, mrfType *mrf);
void read_expmap(expmapType *expmap);
void set_psf_from_R(double *psf_vector, psfType *psf);
void set_obs_from_R(double *cnt_vector, cntType *obs);
void set_image_from_R(double *img_vector, cntType *img);
void set_expmap_from_R(double *map_vector, expmapType *expmap);
void compute_expmap(psfType *psf, expmapType *expmap,controlType *cont);
double comp_ms_prior(cntType *src, msType *ms);
double comp_mrf_prior(cntType *src, mrfType *mrf, controlType *cont);
void redistribute_Counts(psfType *psf, cntType *obs, cntType *deblur, 
			 controlType *cont, llikeType *llike);
void redistribute_counts_multinomial_calcs(int i, int j, psfType *psf, cntType *obs, 
					   cntType *deblur, controlType *cont);
int check_monotone_convg(FILE *param_file, llikeType *llike, msType *ms, controlType *cont);
void add_cnts_2_adjust_4_exposure(expmapType *expmap,cntType *cnts,controlType *cont);
void remove_bkg_from_data(cntType *deblur, cntType *src, cntType *bkg,
			  scalemodelType *bkg_scale, controlType *cont);
void update_image_mrf(expmapType *expmap, cntType *src, mrfType *mrf, 
		      controlType *cont);
double update_image_ms(FILE *param_file, expmapType *expmap, cntType *src, msType *ms, 
		       controlType *cont);
void update_alpha_ms(FILE *param_file, msType *ms, controlType *cont);
double update_alpha_ms_MH(double prop_mean, msType *ms, int level, int dim);
double lpost_alpha(double alpha, msType *ms, int level, int dim);
double dlpost_alpha(double alpha, msType *ms, int level, int dim);
double ddlpost_alpha(double alpha, msType *ms, int level, int dim);
double lpost_lalpha(double alpha, msType *ms, int level, int dim);
double dlpost_lalpha(double alpha, msType *ms, int level, int dim);
double ddlpost_lalpha(double alpha, msType *ms, int level, int dim);
void update_image_ml(expmapType *expmap, cntType *src, controlType *cont);
/* Per Jason Kramer 13 Mar 2009 */
void update_scale_model(scalemodelType *scalemodel, expmapType *expmap, cntType *src,
			controlType *cont);
void update_deblur_image(expmapType *expmap, cntType *deblur, cntType *src, 
			 cntType *bkg, scalemodelType *bkg_scale);
void print_param_file_header(FILE *param_file, controlType *cont,
  expmapType *expmap, msType *ms);
void image_analysis_ascii(double *outmap, double *post_mean,
    char **cnt_filename, 
    char **src_filename, char **psf_filename,
    char **map_filename, char **bkg_filename,
    char **out_filename, char **param_filename,
    int *max_iter,
    int *burn,
    int *save_iters,
    int *save_thin, 
    int *nrow, 
    int *ncol, 
    int *nrow_psf, 
    int *ncol_psf,
    int *em, 
    int *fit_bkg_scl,
    double *alpha_init,
    int *alpha_init_len,
    double *ms_ttlcnt_pr,
    double *ms_ttlcnt_exp,
    double *ms_al_kap2,
    double *ms_al_kap1,
    double *ms_al_kap3);
void image_analysis_R(double *outmap,
    double *post_mean,
    double *cnt_vector,
    double *src_vector, 
    double *psf_vector, 
    double *map_vector, 
    double *bkg_vector,
    char **out_filename,
    char **param_filename,
    int *max_iter,
    int *burn,
    int *save_iters,
    int *save_thin,
    int *nrow,
    int *ncol,
    int *nrow_psf,
    int *ncol_psf,
    int *em,
    int *fit_bkg_scl,
    double *alpha_init,
    int *alpha_init_len,
    double *ms_ttlcnt_pr,
    double *ms_ttlcnt_exp,
    double *ms_al_kap2,
    double *ms_al_kap1,
    double *ms_al_kap3);
void bayes_image_analysis(double *outmap,
    double *post_mean,
    char *out_file_nm, 
    char *param_file_nm,
    controlType *cont, 
    psfType *psf,
    expmapType *expmap,
    cntType *obs,
    cntType *deblur, 
    cntType *src,
    cntType *bkg,
    mrfType *mrf,
    msType *ms,
    llikeType *llike,
    scalemodelType *bkg_scale);

/***************************************************************/
/*********************** ERROR FUNCTION    *********************/
/***************************************************************/

void c_error(char error_text[]){   /* Print an Error Message */
  error("%s", error_text);
}


/***************************************************************/
/***************   PRINT MATRIX TO STD OUTPUT  *****************/
/***************************************************************/

void print_mat(char label_text[], double **mat, int nrow, int ncol){   
  int i, j;                                /* indexing variables */ 

  Rprintf("%s:\n",label_text);
  for(i=0; i < nrow; i++){ 
    for(j=0; j < ncol; j++)
      Rprintf(" %10g", mat[i][j]);
    Rprintf("\n");
  } /* row loop */

} /* print_mat */


/***************************************************************/
/*****************   PRINT MATRIX TO FILE  *********************/
/***************************************************************/

void fprint_mat(FILE *outfile, double **mat, int nrow, int ncol){   
  int i, j;                                /* indexing variables */ 

  for(i=0; i < nrow; i++){ 
    for(j=0; j < ncol; j++)
      fprintf(outfile, "%f  ", (float)mat[i][j]);
    fprintf(outfile, "\n");
  } /* row loop */

} /* fprint_mat */


/***************************************************************/
/**********   WRITE IMAGE TO MAP R OUTPUT STREAM     ***********/
/***************************************************************/


void write_img_to_Routput(double *outmap, cntType *cnt){
  int i, j;                                /* indexing variables */ 

  for(i=0; i < cnt->nrow; i++)
    for(j=0; j< cnt->ncol; j++) 
      outmap[cnt->outmap_index++] = cnt->img[i][j]; 


} /* write_img_to_Routput */


/***************************************************************/
/************** INDEX WRAPPER FOR MATRIX   *********************/
/***************************************************************/

int wrap(int i,          /* the index */
	 int max         /* the max of the index */   
	 ){
  while(i < 0) i += max;
  return(i % max);           /* modular division */
} /* wrap */

/***************************************************************/
/*********  ALLOCATE AND FREE MEMORY FOR MATRICIES *************/
/***************************************************************/


double **matrix(long nrl, long nrh, long ncl, long nch)
/* allocate a double matrix with subscript range m[nrl..nrh][ncl..nch] */
{
   long i, nrow=nrh-nrl+1,ncol=nch-ncl+1;
   double **m;

   /* allocate pointers to rows */
   m=(double **) malloc((size_t)((nrow+NR_END)*sizeof(double*)));
   if (!m) c_error("allocation failure 1 in matrix()");
   m += NR_END;
   m -= nrl;

   /* allocate rows and set pointers to them */
   m[nrl]=(double *) S_alloc(nrow * ncol + NR_END, sizeof(double));
   if (!m[nrl]) c_error("allocation failure 2 in matrix()");
   m[nrl] += NR_END;
   m[nrl] -= ncl;

   for(i=nrl+1;i<=nrh;i++) m[i]=m[i-1]+ncol;

   /* return pointer to array of pointers to rows */
   return m;
}

void free_matrix(double **m, long nrl, long nrh, long ncl, long nch){
/* free a double matrix allocated by matrix() */

  free((FREE_ARG) (m[nrl]+ncl-NR_END));
  free((FREE_ARG) (m+nrl-NR_END));
}


 
  /***************************************************************/
  /*************   INITIALIZE CONTROL STRUCTURE     **************/
  /***************************************************************/
  
void initialize_control(controlType *cont, expmapType *expmap, psfType *psf,
          msType *ms, int *max_iter, int *burn, int *save_iters, int *save_thin, int *nrow, 
          int *ncol, int *nrow_psf, int *ncol_psf, int *em, int *fit_bkg_scl, 
          double *alpha_init, int *alpha_init_len, double *ms_ttlcnt_pr, 
          double *ms_ttlcnt_exp, double *ms_al_kap2,double *ms_al_kap1,double *ms_al_kap3) 
{
  float ftemp;      /* temp float for file reading */
  int i,j;          /* index variables */

  cont->max_iter     = *max_iter;
  cont->burn         = *burn;
  cont->save_iters   = *save_iters;
  cont->save_thin    = *save_thin;
  expmap->nrow       = *nrow;
  expmap->ncol       = *ncol;
  psf->nrow          = *nrow_psf;
  psf->ncol          = *ncol_psf;
  // cont->model        = *model;
  /* (NS 3Aug09) Hard coding model to multi-scale prior, as discussed at Irvine CBAS mtg July09 */
  cont->model        = 1;
  cont->em           = *em;
  cont->fit_bkg_scl  = *fit_bkg_scl;

  /* (NS 3Aug09) Removing MRF option for R package */
  // if (mrf_scl_prec != NULL) {
  //   mrf.scl_prec = *mrf_scl_prec;
  // }
  
  if (cont->model == 1) {
    /* Allocate memory and initialize starting values for multiscale
     * smoothing parameters, if they have been entered */ 
    if(alpha_init != NULL && alpha_init_len != NULL) {
      ms->al_init = (double *) S_alloc((long) *alpha_init_len, sizeof(double));
      if(!ms->al_init) c_error("Memory Allocation Error for ms.al");
      
      for(i = 0; i < *alpha_init_len; i++) {
        ms->al_init[i] = alpha_init[i];
      }
    }
    /* set other multiscale prior parameters */
    if (ms_ttlcnt_pr != NULL) {
      ms->ttlcnt_pr = *ms_ttlcnt_pr;
    }
    if (ms_ttlcnt_exp != NULL) {
      ms->ttlcnt_exp = *ms_ttlcnt_exp;
    }
    if (ms_al_kap2 != NULL) {
      ms->al_kap2 = *ms_al_kap2;
    }

    ms->al_kap1=PAR_NOT_SET;
    if (ms_al_kap1 != NULL){
      ms->al_kap1 = *ms_al_kap1;
    }

    ms->al_kap3=PAR_NOT_SET;
    if(ms_al_kap3 != NULL){
      ms->al_kap3 = *ms_al_kap3;
    }
  }
  
  // if (cont->model == 2) {
  //   // if we're using the MRF prior
  //   if (!( mrf->file=fopen( mrf_file_nm, "r"))) 
  //     c_error("Could not open the MRF HIGH RES file");
  //   if (!( mrf->out =fopen(prec_file_nm, "w"))) 
  //     c_error("Could not open the MRF PREC OUTPUT file");
  // }
  

  /***********  CONTROL INITIALIZATION  ALLOCATION   ***************/

  if (cont->em)
    Rprintf("\nCode will run in mode-finding mode.\n");
  else Rprintf("\nCode will run in posterior sampling mode.\n");
  cont->ml = 0;  
  cont->ms = 0;  
  cont->mrf = 0; 
  cont->wrap = 1; 
  cont->pipe_to_R = 0;
  if(cont->fit_bkg_scl) Rprintf("\nA scale parameter will be fit to the bkg model.\n");


  if (cont->em) 
    Rprintf("\nThe maximum number of EM iterations is %d.\n", cont->max_iter);
  else{ /* if gibbs */
    Rprintf("\nThe total number of Gibbs draws is %d,", cont->max_iter);
    Rprintf(" every %dth draws will be saved.\n", cont->save_thin);
  } /* if gibbs */

  /********************* READ IN MODEL CHOICE ***********************/

  if(cont->model == 0){
    cont->ml = 1;
    Rprintf("\nThe model will be fit via Maximum Likelihood.\n");
  } /* cont->model == 0 */
  else if(cont->model == 1){
    cont->ms = 1;
    Rprintf("\nThe model will be fit using the Multi Scale Prior.\n");
  } /* cont->model == 0 */
  else if(cont->model == 2){
    cont->mrf = 1;
    Rprintf("\nThe model will be fit using the Markov Random Field Prior.\n");
  } /* cont->model == 0 */
  else c_error("Model Choice in Input file is not valid");

  if(cont->wrap == 0 && cont->mrf) 
	  Rprintf("\n Without wrapping, the MRF shrinks boundaries toward zero.");
} /* initialize_control */




  /***************************************************************/
  /*************   ALLOCATE MEMORY     ***************************/
  /***************************************************************/
 
void allocate_memory(psfType *psf, expmapType *expmap, cntType *obs, 
				   cntType *deblur, cntType *src, cntType *bkg, 
				   msType *ms, mrfType *mrf, scalemodelType 
				   *bkg_scale, controlType *cont)
{
  int ag_dim;       /* the dimension of the current MS aggrigation */
  float ftemp;      /* temp float for file reading */
  int i,j;          /* index variables */
  
  
  psf->L = (int) floor(psf->ncol / 2);
  psf->R = psf->ncol - psf->L - 1;
  psf->U = (int) floor(psf->nrow / 2);
  psf->D = psf->nrow - psf->U - 1;
  psf->mat = (double **) matrix(0, psf->nrow-1, 0, psf->ncol-1);
  psf->inv = (double **) matrix(0, psf->nrow-1, 0, psf->ncol-1);
  
  /*********** EXPOSURE MAP INITIALIZATION AND MEMORY ALLOCATION  ******/

  Rprintf("\nThe data matrix is %d by %d.\n",  expmap->nrow, expmap->ncol);
  expmap->map    = (double **) matrix(0, expmap->nrow-1, 0, expmap->ncol-1);
  expmap->pr_det = (double **) matrix(0, expmap->nrow-1, 0, expmap->ncol-1);
  expmap->prod   = (double **) matrix(0, expmap->nrow-1, 0, expmap->ncol-1);


  /******* OBSERVED CNT INITIALIZATION AND MEMORY ALLOCATION   *******/

  obs->ncol = expmap->ncol;
  obs->nrow = expmap->nrow;
  obs->data = (double **) matrix(0, obs->nrow-1, 0, obs->ncol-1);
  obs->img  = (double **) matrix(0, obs->nrow-1, 0, obs->ncol-1);
  obs->outmap_index = 0;
  obs->name = "Obs";

  /****** DEBLURRED CNT INITIALIZATION AND MEMORY ALLOCATION   *******/

  deblur->ncol = expmap->ncol;
  deblur->nrow = expmap->nrow;
  deblur->data = (double **) matrix(0, deblur->nrow-1, 0, deblur->ncol-1);
  deblur->img = (double **) matrix(0, deblur->nrow-1, 0, deblur->ncol-1);
  deblur->outmap_index = 0;
  deblur->name = "Deblur";

  /********* SRC CNT INITIALIZATION AND MEMORY ALLOCATION   ********/

  src->ncol = expmap->ncol;
  src->nrow = expmap->nrow;
  src->data = (double **) matrix(0, src->nrow-1, 0, src->ncol-1);
  src->img  = (double **) matrix(0, src->nrow-1, 0, src->ncol-1);
  src->outmap_index = 0;
  src->name = "Source";

  /********* BKG CNT INITIALIZATION AND MEMORY ALLOCATION   ********/

  bkg->ncol = expmap->ncol;
  bkg->nrow = expmap->nrow;
  bkg->data = (double **) matrix(0, bkg->nrow-1, 0, bkg->ncol-1);
  bkg->img  = (double **) matrix(0, bkg->nrow-1, 0, bkg->ncol-1);
  bkg->outmap_index = 0;
  bkg->name = "Bkgd";

  /*********** MRF INITIALIZATION AND MEMORY ALLOCATION   **********/

  if(cont->mrf){ 
    Rprintf("\n The Markov Random Field Precision is: %g.\n", mrf->scl_prec);
	
    mrf->is_hi_res = 1;
    if( mrf->is_hi_res) 
      Rprintf("\nHigh Resolution Data will be used to set MRF correlations.\n\n");
    mrf->max_wt = 10000;
	
	/**************** mrf memory allocation ********************/
    mrf->mean = (double **) matrix(0, src->nrow-1, 0, src->ncol-1);
    mrf->prec = (double **) matrix(0, src->nrow-1, 0, src->ncol-1);
    mrf->hi_res = (double **) matrix(0, src->nrow-1, 0, src->ncol-1);
    mrf->wts = (double ****) S_alloc((long) src->nrow, sizeof(double ***));
    for(i=0; i < src->nrow; i++){
      mrf->wts[i] = (double ***) S_alloc((long) src->ncol, sizeof(double **));
      for(j=0; j < src->ncol; j++)
        mrf->wts[i][j] = (double **) matrix(0, 2, 0, 2);
    } /* i loop over rows */
    
  } /* cont->mrf */
  

  /*********** MS INITIALIZATION AND MEMORY ALLOCATION   **********/

  if(cont->ms==1){

    ms->spin = 1;   /* initialize cycle spinning  */

    if(src->ncol != src->nrow)
      c_error("For multiscale model, the number of rows and columns must be equal");

    /*************** compute ms power *******************/
    for(ms->power = 1; ms->power > 0; ms->power++){ 
      if( pow(2.0, (double)ms->power) == src->nrow) 
        break;
      if( pow(2.0, (double)ms->power) > src->nrow)
        c_error("For multiscale model number of rows & columns must be a power of 2");
    } /*loop over ms.power */

    Rprintf("\nThe data file should contain a  2^%d by 2^%d matrix of counts.\n", 
	   ms->power, ms->power);


    /************* ms memory allocation ****************/
    ms->al = (double *) S_alloc((long) ms->power, sizeof(double));
    if(!ms->al) c_error("Memory Allocation Error for ms.al");
    
    ms->ag = (double ***) S_alloc((long) ms->power, sizeof(double **));
    if(!ms->ag) c_error("Memory Allocation Error for ms.ag");
    
    ag_dim = src->nrow;
    for(i=0; i<= ms->power; i++){
      ms->ag[i] = (double **) matrix(0, ag_dim-1, 0, ag_dim-1);
      if(ag_dim >= 2.0) 
        ag_dim /= 2.0;
      else 
        break;
    }

    /*************  read in ms parameters  ****************/
    
    Rprintf("\nStarting Values for the smoothing parameter (alpha):\n");
    for(i=0; i < ms->power; i++){   /***** read start values of ms_al *****/
      ms->al[i] = ms->al_init[i];
      Rprintf("Aggregation Level: %2d,   alpha: %g", i, ms->al[i]);
      if(i==0) Rprintf(" (Full Data)\n");
      else if(i == ms->power-1) Rprintf("  (In the 2x2 table)\n");
      else Rprintf("\n");
    } /* loop over ms.al */
    
    Rprintf("\nThe prior distribution on the total count from the multiscale component is\n");
    Rprintf("Gamma(%f, %f).\n", ms->ttlcnt_pr, ms->ttlcnt_exp);

    ms->fit_al = 1;                 /**** fit or fix alpha ****/
    ms->al_kap1 = ms->al_kap1 == PAR_NOT_SET ? 0.0 : ms->al_kap1;              /**** the prior for alpha ****/
    ms->al_kap3 = ms->al_kap3 == PAR_NOT_SET ? 3.0 : ms->al_kap3;
    Rprintf("\nThe hyper-prior smoothing parameter (kappa 2) is %g.\n\n",
	   ms->al_kap2);

  } /* if cont->ms == 1 */

  /*********** BACKGROUND SCALE INTITIALIZATION **********/

  bkg_scale->scale = 1.0;           /**** starting value ****/
  bkg_scale->scale_pr = 0.001;      /**** prior value ****/
  bkg_scale->scale_exp = 0.0;       /**** prior value ****/

  
} /* allocate_memory */
 


/***************************************************************/
/********* READ PSF FROM FILE, NORMALIZE, AND PRINT  ************/
/***************************************************************/

void read_psf(psfType *psf){
  /* Read and Normalize the PSF */
  if (psf->file) {
    float ftemp;       /* float used to read from file */
    float sum;         /* sum used to nomralize */
    int i, j;          /* counting variables */

    for(i=0, sum=0; i < psf->nrow; i++){ 
      for(j=0; j < psf->ncol; j++){
        fscanf(psf->file, "%f", &ftemp);
        psf->mat[i][j] = (double)ftemp;
        sum += psf->mat[i][j];
      } /* column loop */
    } /* row loop */

    /*****  RENORMALIZE AND PRINT PSF *******/
    for(i=0; i < psf->nrow; i++) 
      for(j=0; j < psf->ncol; j++)
        psf->mat[i][j] /= sum;
    if(verbose > 3) print_mat("PSF", psf->mat, psf->nrow, psf->ncol);
  }
  else {
    // just use the default value 1
    psf->mat[0][0] = 1.0;
  }
} /* read psf */

/******************************************************************/
/******  READ BACKGROUND FROM FILE, OR SET DEFAULT VALUES      ****/
/******************************************************************/

void read_bkg(cntType *bkg) {
  if (bkg->file) {
    /* a background file was specified, so read in the values */
    read_data_or_image(1, &bkg[0]);
  }
  else {
    /* no background file, so use default 0 counts */
    int i, j;
    for (i=0; i < bkg->nrow; i++)
      for (j=0; j < bkg->ncol; j++)
        bkg->img[i][j] = 0.0;
  
    if(verbose > 3){
      Rprintf("%s ", bkg->name);
      print_mat("Image", bkg->img, bkg->nrow, bkg->ncol);
    }
  }
}

/******************************************************************/
/******  READ COUNTS FROM FILE, SET STARTING VALUES, AND PRINT ****/
/******************************************************************/

void read_data_or_image(int image, /* 1 to read in an image, 0 to read in data */
			cntType *cnt){

  float ftemp;       /* float used to read from file */
  int i, j;          /* counting variables */
  
  for(i=0; i < cnt->nrow; i++){ 
    for(j=0; j < cnt->ncol; j++){
      fscanf(cnt->file, "%f", &ftemp);
      if(ftemp < 0){
        REprintf("Error in reading element %d of %s.\n", 1 + i*cnt->ncol + j, cnt->name);
        c_error("Negative Value Detected");
      }
      if(image) cnt->img[i][j]  = (double)ftemp;
      else      cnt->data[i][j] = (double)ftemp;
    } /* column loop */
  } /* row loop */

  if(verbose > 3){
      Rprintf("%s ", cnt->name);
      if(image) print_mat("Image", cnt->img, cnt->nrow, cnt->ncol);
      else      print_mat("Data",  cnt->data, cnt->nrow, cnt->ncol);
  }/* verbose */
}


/*********************************************************************/
/******  READ MRF HIGH RES DATA, COMPUTE WTS & PRECISION MATRIX  *****/
/*********************************************************************/

void read_hires(cntType *cnt, mrfType *mrf){

  float ftemp;       /* float used to read from file */
  double nbr;        /* the current neighbor */
  int i, j, k, l;    /* counting varialbes */
  
  if(mrf->is_hi_res){
    
    /********   Read High Resolution Data ********/
    for(i=0; i < cnt->nrow; i++){ 
      for(j=0; j < cnt->ncol; j++){
        fscanf(mrf->file, "%f", &ftemp);
        if(ftemp <= 0){
          REprintf("Error in reading element (%d, %d) of MRF HIGH RESOLUTION DATA.\n", i, j);
          c_error("Non-Positive Value Detected");
        } /* if ftemp < 0 */
        mrf->hi_res[i][j]  = log((double)ftemp);
      } /* column loop */
    } /* row loop */
    
    /********   Compute Weights and Precision ********/
    mrf->mn_wt = 0;
    mrf->n_wts = 0;
    for(i=0; i < cnt->nrow; i++){ 
      for(j=0; j < cnt->ncol; j++){
        mrf->prec[i][j]=0.0;
        for (k=0; k<=2; k++){
          for (l=0; l<=2; l++){
            nbr = mrf->hi_res[wrap(i+k-1, cnt->nrow)][wrap(j+l-1, cnt->ncol)];
            mrf->wts[i][j][k][l] = (mrf->hi_res[i][j] - nbr) * (mrf->hi_res[i][j] - nbr);
            mrf->wts[i][j][k][l] = mrf->scl_prec   /* max_wt keeps wts from infty! */ 
              / ( mrf->wts[i][j][k][l] + 1/mrf->max_wt);
            mrf->mn_wt += mrf->wts[i][j][k][l];
            mrf->n_wts += 1;
            if (k*l != 1) mrf->prec[i][j] += mrf->wts[i][j][k][l];
          } /* l loop over nbr columns */
        } /* k loop over nbr rows */
      } /* j column loop */
    } /* i row loop */
    Rprintf("\nMean of Weights: %g\n\n", mrf->mn_wt / mrf->n_wts);
    
  } /* if(is_high_res) */
  
  else{  /* if no high resolution data */
    mrf->mn_wt = 0;
    mrf->n_wts = 0;
    for(i=0; i < cnt->nrow; i++){ 
      for(j=0; j < cnt->ncol; j++){
        mrf->prec[i][j]=0.0;
        for (k=0; k<=2; k++){
	        for (l=0; l<=2; l++){
            mrf->wts[i][j][k][l] = mrf->scl_prec / 8;
	          if (k*l != 1) mrf->prec[i][j] += mrf->wts[i][j][k][l];
	          if(i==1 && j==1) printf("%5d %5d %14g  %14g\n", k, l, mrf->prec[i][j], mrf->wts[i][j][k][l]);
            mrf->mn_wt += mrf->wts[i][j][k][l];
            mrf->n_wts += 1;
	        } /* l loop over nbr columns */
        } /* k loop over nbr rows */
      } /* j column loop */
    } /* i row loop */
    Rprintf("\nMean of Weights: %g\n\n", mrf->mn_wt / mrf->n_wts);
  } /* if no high resolution data */
  
  fprint_mat(mrf->out, mrf->prec, cnt->nrow, cnt->ncol);   
  
  if(verbose > 3){
    print_mat("MRF Precision", mrf->prec, cnt->nrow, cnt->ncol);
  }/* verbose */
}


/***************************************************************/
/*********     READ EXPOSURE MAP                      **********/
/***************************************************************/


void read_expmap(expmapType *expmap){
  float ftemp;       /* float used to read from file */
  double max;        /* max used to nomralize */
  int i, j;    /* counting variables */

  if (expmap->file) {
    /* If a file has been specified, read the values in */
    for(i=0, max=0; i < expmap->nrow; i++){ 
      for(j=0; j < expmap->ncol; j++){
        fscanf(expmap->file, "%f", &ftemp);
        expmap->map[i][j] = (double)ftemp; 
        if( expmap->map[i][j] > max) max = expmap->map[i][j];
      } /* column loop */
    } /* row loop */

    /*****  RENORMALIZE AND PRINT EXPOSURE MAP *******/
    /* (NS) "normalize" just means maximum = 1, not total = 1 */
    for(i=0; i < expmap->nrow; i++){ 
      for(j=0; j < expmap->ncol; j++){
        expmap->map[i][j] /= max;
      }
    }
    expmap->max_val = max; /* [added AVC Oct 2009] */
  }
  else {
    /* If no file was specified, use uniform exposure as default */
    for (i=0; i < expmap->nrow; i++){
      for (j=0; j < expmap->ncol; j++){
        expmap->map[i][j] = 1.0;
      }
    }
    expmap->max_val = 1.0; /* [added AVC Oct 2009] */
  }

  if(verbose > 3) 
    print_mat("Exposure Map", expmap->map, expmap->nrow, expmap->ncol);
} /* read_expmap */


/* Read and Normalize the PSF from R vector psf_vector */
void set_psf_from_R(double *psf_vector, psfType *psf)
{
  double sum = 0.0; /* for normalizing */
  int i, j;
  
  for (i = 0; i < psf->nrow; i++) {
    for (j = 0; j < psf->ncol; j++) {
      /* There is no bounds checking. R must check bounds! */
      psf->mat[i][j] = psf_vector[i * psf->ncol + j];
      sum += psf->mat[i][j];
    }
  }
  
  /*****  RENORMALIZE AND PRINT PSF *******/
  for(i = 0; i < psf->nrow; i++) 
    for(j = 0; j < psf->ncol; j++)
      psf->mat[i][j] /= sum;
  if(verbose > 3) print_mat("PSF", psf->mat, psf->nrow, psf->ncol);
}

/* Read the observed data from R vector cnt_vector */
void set_obs_from_R(double *cnt_vector, cntType *obs)
{
  int i, j;          /* counting variables */
  
  for(i = 0; i < obs->nrow; i++){ 
    for(j = 0; j < obs->ncol; j++){
      /* There is no bounds checking. R must check bounds! */
      if(cnt_vector[i * obs->ncol + j] < 0){
        REprintf("Error in reading element %d of %s.\n", 1 + i + j * obs->nrow, obs->name);
        c_error("Negative Value Detected");
      }
      obs->data[i][j] = cnt_vector[i * obs->ncol + j];
    }
  }

  if(verbose > 3){
      Rprintf("%s ", obs->name);
      print_mat("Data",  obs->data, obs->nrow, obs->ncol);
  }/* verbose */ 
}

/* Read an image from R vector img_vector */
void set_image_from_R(double *img_vector, cntType *img)
{
  int i, j;          /* counting varialbes */
  
  for(i = 0; i < img->nrow; i++){ 
    for(j = 0; j < img->ncol; j++){
      /* There is no bounds checking. R must check bounds! */
      if(img_vector[i * img->ncol + j] < 0){
        REprintf("Error in reading element %d of %s.\n", 1 + i + j * img->nrow, img->name);
        c_error("Negative Value Detected");
      }
      img->img[i][j] = img_vector[i * img->ncol + j];
    }
  }

  if(verbose > 3){
      Rprintf("%s ", img->name);
      print_mat("Image",  img->img, img->nrow, img->ncol);
  }/* verbose */
  
}

/* Read the exposure map from R vector map_vector */
void set_expmap_from_R(double *map_vector, expmapType *expmap)
{
  double max = 0.0;        /* max used to normalize */
  int i, j;          /* counting variables */

  for(i = 0; i < expmap->nrow; i++){
    for(j = 0; j < expmap->ncol; j++){
      /* There is no bounds checking. R must check bounds! */
      expmap->map[i][j] = map_vector[i * expmap->ncol + j];
      if( expmap->map[i][j] > max) 
        max = expmap->map[i][j];
    }
  }

  /*****  RENORMALIZE AND PRINT EXPOSURE MAP *******/
  /* (NS) "normalize" just means maximum = 1, not total = 1 */
  for(i = 0; i < expmap->nrow; i++) 
    for(j= 0; j < expmap->ncol; j++)
      expmap->map[i][j] /= max;
      
  expmap->max_val = max; /* [added AVC Oct 2009] */

  if(verbose > 3) 
    print_mat("Exposure Map", expmap->map, expmap->nrow, expmap->ncol);
}




/***************************************************************/
/********** UPDATE EXPOSURE MAP WITH                  **********/
/*********  PROB OF COUNTS NOT SPILLING OFF DETECTOR  **********/
/***************************************************************/

void compute_expmap(psfType *psf, expmapType *expmap, controlType *cont)
{
  int i, j, k, l;    /* counting variables */
  
  /***** COMPUTE PROB THAT CNTS DO NOT SPILL OFF THE DETECTOR ****/
  for(i=0; i < expmap->nrow; i++){
    for(j=0; j < expmap->ncol; j++){

      if(cont->wrap)  /* if wrap, all det probs are one */
        expmap->pr_det[i][j] = 1.0;

      else{             /* if not wrap */
	      expmap->pr_det[i][j] = 0.0;
	    for(k=0; k < psf->nrow; k++){ 
	      for(l=0; l < psf->ncol; l++){  /* if ! spilled */
	        if( (0 <= i + k - psf->U) && (i + k - psf->U < expmap->ncol) &&
		          (0 <= j + l - psf->L) && (j + l - psf->L < expmap->nrow)) {
	          expmap->pr_det[i][j] += psf->mat[k][l];
          } /* if ! spilled */
        } /* l loop over psf cols */
      } /* k loop over psf rows */
      if(expmap->pr_det[i][j] == 0.0){
        REprintf("Pixel: (%d, %d)\n", i, j);
	      c_error("Photons originating in above pixel cannot be detected") ;
      } /* error */
    } /* else if not wrap */
	
    expmap->prod[i][j] =             /* the product of map and pr_det */
      exp( log(expmap->pr_det[i][j]) + log(expmap->map[i][j]));

    } /* j column loop */
  } /* i row loop */

  if(verbose > 3) 
    print_mat("Prob of Detection", expmap->pr_det, expmap->nrow, expmap->ncol);
} /* compute_expmap */


/***************************************************************/
/*********  COMPUTE MULTISCALE LOG PRIOR PROBABILITY     *******/
/******** (USED TO COMPUTE PRIOR PROB OF STARTING VALUE) *******/
/***************************************************************/


double comp_ms_prior(cntType *src, msType *ms){

  int level;            /* current level of aggrigation */
  int dim;              /* dimension of the current level of aggrigation */
  double sum;           /* sum of Poisson intensities in 2x2 set of pixels */
  double logprior = 0;  /* the log prior value */
  int i, j, k, l;       /* counting variables */

  /*************** COPY IMAGE INTO ms.ag ************/

  dim = src->nrow;
  for(i=0; i < dim; i++) 
    for(j=0; j < dim; j++)
      ms->ag[0][i][j] = src->img[i][j];
			
  /***** COMPUTE AGGRIGATIONS, PROPORTIONS, AND LOG PRIOR *********/
  for(level=0; level < ms->power; level++){ 
    dim /= 2.0;                      /* Loop over  Aggregation Levels*/
    for(i=0; i < dim; i++){
      for(j=0; j < dim; j++){
        sum = 0.0;
        for(k=0; k<2; k++){
	        for(l=0; l<2; l++){
            sum += ms->ag[level][2*i+k][2*j+l];
          }
        }
        for(k=0; k<2; k++){
          for(l=0; l<2; l++){
            ms->ag[level][2*i+k][2*j+l] = ms->ag[level][2*i+k][2*j+l] / sum;
            logprior += 
              (ms->al[level] - 1) * log(ms->ag[level][2*i+k][2*j+l]);
          } /* l loop */
        }
        ms->ag[level+1][i][j] = sum;
      } /* loop over columns of ms->ag[level] */
    } /* loop over rows of ms->ag[level] */
	
  } /* loop over aggregation level */

  /********** ADD LOG PRIOR FOR EXPECTED OVERALL COUNT *********/
  logprior += (ms->ttlcnt_pr - 1) * log(ms->ag[ms->power][0][0]) -
    ms->ttlcnt_exp * ms->ag[ms->power][0][0];
  return(logprior);

} /* compute ms prior */



/***************************************************************/
/****  COMPUTE MARKOV RANDOM FIELD LOG PRIOR PROBABILITY    ****/
/***************************************************************/

double comp_mrf_prior(cntType *src, mrfType *mrf, controlType *cont){

  double sum;           /* sum of Poisson intensities in 2x2 set of pixels */
  double logprior = 0;  /* the log prior value */
  int i, j, k, l;       /* counting variables */


  /* MRF PRIOR: We use a prior with mean of the pixel log intensity
     equal to the weighted average of the eight neighboring cells. For pixels
     on the boundary or in a corner, neighbors are wrapped around. (But
     zero wts can be used to prevent wraping.)  

*/

  for(i=0; i < src->nrow; i++){
    for(j=0;  j <src->ncol; j++){
      for(k=-1; k < 2; k++){
        for(l=-1; l < 2; l++){
          /****************** an adjacent neighbor *****************/
          if( (i+k >= 0)  && (i+k < src->nrow) &&  
              (j+l >= 0)  && (j+l < src->ncol) &&
              (k*k + l*l > 0) ){  
                logprior -= ( log(src->img[i][j]) * log(src->img[i+k][j+l])  
                  * mrf->wts[i][j][k+1][l+1] );
              }/* if an adjacent neighbor */
          /****************** a  wrapped neighbor *****************/
	        else if(k*k + l*l > 0 && cont->wrap){
            logprior -= 
              (log(src->img[i][j]) * 
	            log(src->img[wrap(i+k, src->nrow)][wrap(j+l, src->ncol)]) *
		          mrf->wts[i][j][k+1][l+1] );
          } /* a wrapped neighbor */
        } /* l loop */
      } /* k loop */
      logprior += log(src->img[i][j]) * log(src->img[i][j]) * mrf->prec[i][j];
    }/*j loop over src->img */
  }/*i loop over src->nrow */
  logprior = -0.5 * logprior;
  
  return(logprior);

} /* compute mrf prior */



/***************************************************************/
/******* COMPUTE INV PSF USING BAYES THEOREM ALLOWING   ********/
/*******      COUNTS TO SPILL OFF THE DETECTOR          ********/
/*******         OR WRAP AROUND THE DETECTOR            ********/
/*********                  AND                         ********/
/*********       REDISTRIBUTE obs.data to deblur.data   ********/
/***************************************************************/


void redistribute_Counts(psfType *psf, cntType *obs, cntType *deblur, 
			 controlType *cont, llikeType *llike){


  float sum;            /* sum used to nomralize psf.inv*/  
  int i, j, k, l;             /* counting varialbes for psf coordinates*/


  /************* INITIALIZE deblur.data *************/
  for(i=0; i<deblur->nrow; i++)  
    for(j=0; j<deblur->ncol; j++) 
      deblur->data[i][j] = 0.0; 

    for(i=0; i<obs->nrow; i++){  /* LOOP OVER THE OBSERVED DATA CELLS */
      for(j=0; j<obs->ncol; j++){

        /******** USE BAYES THM TO COMPUTE INV PDF *********/  
	      sum = 0;           /* to normalize psf->inv */
	      for(k=0; k < psf->nrow; k++){  /* COMPUTE THE INV PROB PSF */
	        for(l=0; l < psf->ncol; l++){
	          if( (0 <= i - psf->D + k) && (i - psf->D + k < obs->nrow) &&
		            (0 <= j - psf->R + l) && (j - psf->R + l < obs->ncol)){
	            /******** if  not too close to the edge *********/
	            psf->inv[k][l] =              /* Bayes Theorem on staroids. */
		            deblur->img[i - psf->D + k][j - psf->R + l] * 
		            psf->mat[psf->nrow - k - 1][psf->ncol - l - 1];
	            sum += 
		            deblur->img[i - psf->D + k][j - psf->R + l] * 
                psf->mat[psf->nrow - k - 1][psf->ncol - l - 1];
            } /* if not too close to the edge */
	          /********** if too close to the edge **************/
            else{ 
              if(cont->wrap){
                psf->inv[k][l] =              /* Bayes Theorem on staroids. */
                  deblur->img[wrap(i - psf->D + k, obs->nrow)]
                               [wrap(j - psf->R + l, obs->ncol)] * 
                  psf->mat[psf->nrow - k - 1][psf->ncol - l - 1];
                sum += 
                  deblur->img[wrap(i - psf->D + k, obs->nrow)]
                               [wrap(j - psf->R + l, obs->ncol)] *
                  psf->mat[psf->nrow - k - 1][psf->ncol - l - 1];
              } /* if wrap */
              else 
                psf->inv[k][l] = 0; /* no wrapping */
            } /* too close to the edge */
          } /* l loop over psf cols */
        } /* k loop over psf rows */
  
        // fprintf(cont->debug, "%f\n",sum);
        if(sum == 0 && obs->data[i][j] > 0){
          REprintf("Pixel: (%d, %d)\n", i, j);
          c_error(" The psf does not allow data in above pixel");
        }
  
        /************* UPDATE LOG LIKELIHOOD *********/
        if(obs->data[i][j] > 0) llike->cur += obs->data[i][j] * log(sum);
        llike->cur -= sum;
        
        /******* NORMALIZE THE INV PROB PSF **************/

        for(k=0; k < psf->nrow; k++)    
          for(l=0; l < psf->ncol; l++)
            psf->inv[k][l] /= sum; 

        /**********  PRINT THE INV PROB PSF ************/	
	      if(verbose > 9){
          Rprintf("Current Observed Pixel (%d,%d)\n", i, j);
          print_mat("Inv PSF ", psf->inv, psf->nrow, psf->ncol);
        }
	
        /***** MULTINOMIAL SAMPLING OR EXPECTATION *******/	
        redistribute_counts_multinomial_calcs(i, j, psf, obs, deblur, cont);

      } /* j loop over cnt.data cols */
    } /* i loop over cnt.data rows */

    /************ PRINT THE REDISTRIBUTED COUNTS ********/
    if(verbose > 5)
      print_mat("Redistributed Counts", deblur->data, 
        deblur->nrow, deblur->ncol); 

} /* redistribute_counts */


/***************************************************************/
/*****  MULTINOMIAL CALCULATIONS FOR COUNT REDISTRIBUTION  *****/
/*****           SAMPLING FOR MCMC SAMPLERS,               *****/
/*****          EXPECTATIONS FOR EM ALGORITHMS             *****/
/*****                        AND                          *****/
/*****            STORE RESULTS IN  deblur.data            *****/
/***************************************************************/


void redistribute_counts_multinomial_calcs(
	      int i, int j,           /* row and col of current cell in cnt.data  */
	      psfType *psf, cntType *obs, cntType *deblur, controlType *cont){

  double count = obs->data[i][j];  /* the obs count in current cell (i,j) */
  double p_tot=1.0;                  /* total remaining probability */ 
  double p_cur;                      /* conditional prob for current cell */
  double sample;                     /* temporay storage for sampled cell count */
  int k, l;                          /* looping varialbes */

  /********** THE CORE MULTINOMIAL CALCULATIONS *********/
  for(k = 0; k < psf->nrow; k++){
    for(l = 0; l < psf->ncol; l++){
      if(cont->em)          /* if EM, compute expectation, STORE IN psf.inv */
        psf->inv[k][l] *= count;
      else{                  /* if MCMC, sample, STORE IN psf.inv */
        if( (count > 0.0) && psf->inv[k][l] ){
          p_cur = psf->inv[k][l] / p_tot;  /* conditional prob of this cell */
          sample = ((p_cur < 1.) ? rbinom(count,  p_cur) : count);
          count -= sample;
        }
        else 
          sample = 0;
        p_tot -= psf->inv[k][l]; /* i.e. = sum(prob in remaining cells) */
        psf->inv[k][l]= sample;  /* store sample in psf.inv */
      } /* MCMC multinomail sample */

    } /* l loop over cols of psf */
  } /* k loop over rows of psf */

   /*******  PRINT THE CURRENT REDISTRIBUTED COUNTS *******/	
	if(verbose > 9){
	  Rprintf("Current Observed Pixel (%d,%d) (Count is %5d.)\n", i, j,
		 (int) obs->data[i][j]);
	  print_mat("Redistributed Counts from Current Pixel ", 
		    psf->inv, psf->nrow, psf->ncol);
	}

  /****************************************************/
  /******     STORE REDISTRIBUTED COUNTS          *****/
  /****** RECALL REDISTRIBUTED COUNTS ARE STORED  *****/
  /******             IN psf.inv                  *****/
  /****************************************************/ 
  for(k=0; k < psf->nrow; k++)  
    for(l=0; l < psf->ncol; l++)
      /******** if  not too close to the edge *********/
      if((0 <= i - psf->D + k) && (i - psf->D + k < obs->nrow) &&
	       (0 <= j - psf->R + l) && (j - psf->R + l < obs->ncol)){
        deblur->data[i - psf->D + k][j - psf->R + l] +=  psf->inv[k][l];
      } /* if !2 close to edge */
      /********** if too close to the edge **************/
      else if(cont->wrap){
        deblur->data[wrap(i - psf->D + k, obs->nrow)]
                      [wrap(j - psf->R + l, obs->ncol)] += psf->inv[k][l];
      } /* if (cont.wrap) */

} /* redistribute_counts_multinomial_sampler */



/***************************************************************/
/*********      CHECK FOR (MONOTONE) CONVERGENCE       *********/
/***************************************************************/

int check_monotone_convg(FILE *param_file, llikeType *llike, msType *ms, 
      controlType *cont)
{
  int convg = 0;        /* 1 if converged */

  if(verbose > 0 && (cont->iter % cont->save_thin == 0)){
    // Rprintf("Current Log-Posterior: %10g", llike->cur);
    fprintf(param_file, "%10g ", llike->cur);
    if(cont->iter > 1) {
      // Rprintf("   Step Size: %14.10g", llike->cur - llike->pre);
      fprintf(param_file, "%14.10g ", llike->cur - llike->pre);
    }
    else {
      fprintf(param_file, "%14.10g ", 0.0);      
    }
  }
  if(cont->em){                           /* if MCMC no convg criterion */
    if( cont->iter > 1){
      if( !(cont->ms && ms->spin) &&    /* no multiscale cycle spinning */
          !(cont->ms && ms->fit_al) &&  /* no multiscale fitting alpha */
	        (llike->cur < llike->pre)) 
	      c_error("The loglikelihood is decreasing!"); 
      if( (llike->cur - llike->pre < convg_em) && (llike->cur - llike->pre > 0) ) 
        convg = 1; 
    } /* if beyond interation 1 */
  } /* if em */
  if(verbose > 0) 
    // Rprintf("\n");
  llike->pre = llike->cur;

  return(convg);
} /* check_monotone_convg */


/***************************************************************/
/************  ADD CNT TO ACCOUNT FOR EXPOSURE MAP  ************/
/***************************************************************/

void add_cnts_2_adjust_4_exposure(expmapType *expmap, cntType *cnts,
				  controlType *cont){

  double exp_missing_cnt;  /* the expected number of missing cnts */
  int i, j;                /* index variables */

  for(i=0; i<cnts->nrow; i++){
    for(j=0; j<cnts->ncol; j++){
      exp_missing_cnt = (1 - expmap->prod[i][j]) * cnts->img[i][j];
      if(!cont->em) 
        exp_missing_cnt = rpois(exp_missing_cnt);
      cnts->data[i][j] = cnts->data[i][j] + exp_missing_cnt;
    } /* loop over columns */
  } /* loop over rows */

} /* add counts to adust for exposure maps*/



/***************************************************************/
/***************  SEPERATE SRC AND BACKGROUND CNTS  ************/
/***************************************************************/


void remove_bkg_from_data(cntType *deblur, cntType *src, cntType *bkg,
			  scalemodelType *bkg_scale, controlType *cont){

  double prob_src;      /* the cond prob of source counts */
  int i, j;             /* index variables */

  for(i=0; i<src->nrow; i++){
    for(j=0; j<src->ncol; j++){

      prob_src = src->img[i][j] / 
        ( src->img[i][j] + bkg_scale->scale * bkg->img[i][j] ); 

      if(prob_src < 1){  /* there is background */
        if(cont->em)   /* EM */
	        src->data[i][j] = deblur->data[i][j] * prob_src;
        else             /* Gibbs */
          src->data[i][j] = rbinom(deblur->data[i][j], prob_src);

        bkg->data[i][j] = deblur->data[i][j] - src->data[i][j];
      } /* if there is background */
      else{              /* gibbs */
        src->data[i][j] = deblur->data[i][j];
        bkg->data[i][j] = 0.0;
      } /* no background */

    } /* loop over columns */
  } /* loop over rows */

}/*remove background from data */



/***************************************************************/
/****    UPDATE IMAGE USING MARKOV RANDOM FIELD PRIOR     ******/
/***************************************************************/


void update_image_mrf(expmapType *expmap, cntType *src, mrfType *mrf, 
		      controlType *cont){
  
  double nr_lam;        /* newton raphson LOCAL poisson parameter */
  double nr_lglam;      /* newton raphson LOCAL log of poisson parameter */
  double nr_step;       /* newton raphson LOCAL proposal for lglam */
  int i, j, k, l;       /* counting variables */
  
  for(i=0; i < src->nrow; i++){  
    for(j=0; j < src->ncol; j++){
      mrf->mean[i][j] = 0;
      for(k=-1; k<2; k++){  	  /* COMPUTE THE MRF MEAN FOR PIXEL (i, j) */
        for(l=-1; l<2; l++){
	        /****************** an adjacent neighbor *****************/
	        if( (i+k >= 0)  && (i+k < src->nrow) &&  
	            (j+l >= 0)  && (j+l < src->ncol) &&
	            (k*k + l*l > 0) ){  
	          mrf->mean[i][j] += log(src->img[i+k][j+l]) * mrf->wts[i][j][k+1][l+1];
	        }/* if an adjacent neighbor */
	        else  if(k*k + l*l > 0 && cont->wrap){
	          mrf->mean[i][j] += 
	            log(src->img[wrap(i+k, src->nrow)][wrap(j+l, src->ncol)]) *
	            mrf->wts[i][j][k+1][l+1];
	        } /* a wrapped neighbor */
        }
      }
      mrf->mean[i][j] /= mrf->prec[i][j];
      
      /* NEWTON-RAPHSON TO COMPUTE THE CONDITIONAL MODE */	   
      nr_lam = src->img[i][j];    /* starting value */
      nr_lglam  = log(nr_lam);
      k=0;
      while(1==1){ /* nr iteration */
        k++;
        nr_step = src->data[i][j] + expmap->prod[i][j] * nr_lam * (nr_lglam - 1) 
  	      + mrf->prec[i][j] * mrf->mean[i][j]; 
  	    nr_step /= (expmap->prod[i][j] * nr_lam +  mrf->prec[i][j]);
  	    if( (nr_lam - exp(nr_step)) < convg_nr &&     /* convergence check */
  	        (exp(nr_step) - nr_lam) < convg_nr)
  	      break;
        nr_lglam = nr_step;
  	    nr_lam = exp(nr_lglam);
      } /* nr iteration */
      src->img[i][j] = exp(nr_step);
      
    }/*j loop over src.img */
  } /* i loop */
  
  if(cont->em==0) 
    error("No code for MCMC fitting with MRF prior!!");
  
} /*update_image_mrf */



/***************************************************************/
/*********    UPDATE IMAGE USING MULTI-SCALE PRIOR     *********/
/*********   ALSO RETURNS THE LOG PRIOR OF NEW IMAGE   *********/
/***************************************************************/

double update_image_ms(FILE *param_file, expmapType *expmap, cntType *src, 
      msType *ms, controlType *cont){

  int level;            /* current level of aggrigation */
  int dim;              /* dimension of the current level of aggrigation */
  double sum;           /* sum of Poisson intensities in 2x2 set of pixels */
  double logprior = 0;  /* the log prior value */
  int spin_row = 0  ;   /* the number of cells we spin down */ 
  int spin_col = 0;     /* the number of cells we spin right */
  int i, j, k, l;       /* counting variables */

  /*************** Initialize Spinning ************/
  if(ms->spin){
    spin_row = (int) (src->nrow * runif(0,1));
    spin_col = (int) (src->nrow * runif(0,1));
  }
  if (verbose > 2 && (cont->iter % cont->save_thin == 0)) {
    // Rprintf("Cycle spinning location (row, col): (%d, %d)\n", spin_row, spin_col);
    fprintf(param_file, "%d %d ", spin_row, spin_col);
  }

  /*************** Copy src.data into ms_ag ************/
  dim = src->nrow;
  for(i=0; i < dim; i++) 
    for(j=0; j < dim; j++)
      ms->ag[0][i][j] = src->data[(i+spin_row)%dim][(j+spin_col)%dim];
		
  /*************** Compute aggrigations  **********/
  dim = src->nrow;
  for(level=0; level < ms->power; level++){ 
    dim /= 2.0;                      /* Loop over  Aggregation Levels*/
    for(i=0; i < dim; i++){
      for(j=0; j < dim; j++){
	      sum = 0;
        for(k=0; k<2; k++)
	        for(l=0; l<2; l++)
	          sum += ms->ag[level][2*i+k][2*j+l];
	      ms->ag[level+1][i][j]=sum;
      } /* loop over columns of ms.ag[level] */
    } /* loop over rows of ms.ag[level] */
  } /* loop over aggregation level */

  /************* update alpha ******************/
  if(ms->fit_al) update_alpha_ms(param_file, ms, cont);  

  /************ Compute  Proportions **********/
  dim = src->nrow;
  for(level=0; level < ms->power; level++){ 
    dim /= 2.0;                      /* Loop over  Aggregation Levels*/
    for(i=0; i < dim; i++){
      for(j=0; j < dim; j++){
	      sum = 0.0;
	      while(sum == 0.0){  /* guard against extreme case of all gamma samples == 0.0 */
 	        for(k=0; k<2; k++)
	          for(l=0; l<2; l++){
 	            if(cont->em)   /* if EM compute mode */
	              ms->ag[level][2*i+k][2*j+l] = 
		              ms->ag[level][2*i+k][2*j+l] + ms->al[level];
	            else            /* if MCMC sample */
	              ms->ag[level][2*i+k][2*j+l] = 
		              rgamma(ms->ag[level][2*i+k][2*j+l] + ms->al[level], 1.0);
	            sum += ms->ag[level][2*i+k][2*j+l];
            } /* l,k loop over 2x2 tbl */
        } /* while sum == 0.0 */
        for(k=0; k<2; k++) /* renormalize */
          for(l=0; l<2; l++)
            ms->ag[level][2*i+k][2*j+l] /= sum; 

      } /* loop over columns of ms.ag[level] */
    } /* loop over rows of ms.ag[level] */
  } /* loop over aggregation level */

  /*************** update the expected total count ****************/


  if(cont->em)   /* if EM compute mode */
    ms->ag[ms->power][0][0] = (ms->ag[ms->power][0][0] + ms->ttlcnt_pr -1) /
                                  (1 + ms->ttlcnt_exp);
  else            /* if MCMC sample */
    ms->ag[ms->power][0][0] =
      rgamma( ms->ag[ms->power][0][0] + ms->ttlcnt_pr, 1/(1 + ms->ttlcnt_exp));


  if(verbose > 2 && (cont->iter % cont->save_thin == 0)) {
    // Rprintf("Expected Total MS Cnt: %g\n", ms->ag[ms->power][0][0]);
    fprintf(param_file, "%g ", ms->ag[ms->power][0][0]);
  }

  /**************** COMPUTE THE (LOG SCALE) IMAGE ****************/
  /*********************** AND THE LOG PRIOR *********************/
      
  logprior = (ms->ttlcnt_pr - 1) * log(ms->ag[ms->power][0][0]) -
    ms->ttlcnt_exp * ms->ag[ms->power][0][0];
  dim=1;
  ms->ag[ms->power][0][0] = log(ms->ag[ms->power][0][0]);
  for(level = ms->power; level > 0; level--){ 
    for(i=0; i< dim; i++)
      for(j=0; j<dim; j++)
        for(k=0; k<2; k++)
          for(l=0; l<2; l++){
            logprior +=(ms->al[level-1] ) * log(ms->ag[level-1][2*i+k][2*j+l]); /* Per Jason Kramer 13 Mar 2009 */
            ms->ag[level-1][2*i+k][2*j+l] = 
              log(ms->ag[level-1][2*i+k][2*j+l]) + ms->ag[level][i][j];
          } /* loop over l */
    dim *= 2;
  } /* loop over aggregation level */

  /******************* Store new image in src.img *******************/
  dim = src->nrow;
  for(i=0; i< dim; i++)
    for(j=0; j<dim; j++)
      src->img[(i+spin_row)%dim][(j+spin_col)%dim] = exp( ms->ag[0][i][j] );
	  
  return(logprior);

} /* update_image_ms */


/***************************************************************/
/************      UPDATE THE HYPER-PARAM ALPHA       **********/
/************        IN THE MULTI SCALE MODEL         **********/
/***************************************************************/

void update_alpha_ms(FILE *param_file, msType *ms, controlType *cont){

  /********* We use the method of bisection for optimization ************/

  int level;           /* the current level of aggrigation */ 
  int dim;             /* the dimension of the next level of aggrigation */
  double lower;        /* (lower, upper) is an interval containing */   
  double middle;       /* the optimal value. */
  double upper;        /* middle is the mid point of the interval */
  double dl_lower;     /* dlogpost (dlpost_lalpha) evaluated at lower */
  double dl_middle;    /* dlogpost (dlpost_lalpha) evaluated at middle */
  double dl_upper;     /* dlogpost (dlpost_lalpha) evaluated at upper */
  int i=0;

  // if(verbose > 2) Rprintf("Smoothing Hyper-parameters:");
  dim = pow(2, ms->power);
  for(level = 0; level < ms->power; level++){ 
    dim /= 2;                      /* loop over level of aggrigation */
    if(verbose > 9) Rprintf("update alpha: %5d %5d %5d \n", ms->power, dim, level);

    /************ initialize lower and upper ***********/
    lower = 1.0;
    while(dlpost_lalpha(lower, ms, level, dim) < 0) lower = lower / 2.0;

    dl_lower = dlpost_lalpha(lower, ms, level, dim);
    upper = lower * 2.0;
    while(dlpost_lalpha(upper, ms, level, dim)  > 0) upper = 2.0 * upper;
    dl_upper = dlpost_lalpha(upper, ms, level, dim);
    
    while( (upper - lower) > convg_bisect){
      middle = (lower + upper) / 2.0;
      dl_middle = dlpost_lalpha(middle, ms, level, dim);
      if(verbose > 10)
        Rprintf("%5d %14g %14g %14g %14g %14g %14g\n", i++, lower, middle, upper,
	        dl_lower, dl_middle, dl_upper);
      if(dl_middle > 0){  /* if middle is below optimal, set lower = middle */
        lower = middle;
        dl_lower = dl_middle;
      }
      else{                /* if middle is above optimal, set upper = middle */
        upper = middle;
        dl_upper = dl_middle;
      }
    } /* bisection while loop */

    if(cont->em)    /*******   EM update  *******/
      ms->al[level] = (upper + lower) / 2.0; 
    else              /**** MCMC update via MH ****/
      ms->al[level] = update_alpha_ms_MH((upper + lower) / 2.0, ms, level, dim);

    if(verbose > 2 && (cont->iter % cont->save_thin == 0)) {
      // Rprintf(" %f ", ms->al[level]);
      fprintf(param_file, "%f ", ms->al[level]);
    }
  } /* loop over level of aggrigation */
  // if(verbose > 2) Rprintf("\n");
  /* ms->al[0] = 1; printf("Set high resolution param to one for Becca!\n");  
  /*  ms->al[1] = 0.0; printf("Set high resolution param to one for Becca!\n"); */

} /* update_alpha_ms */


/***************************************************************/
/************      METROPOLIS-HASTINGS FOR MCMC       **********/
/************      UPDATE THE HYPER-PARAM ALPHA       **********/
/************        IN THE MULTI SCALE MODEL         **********/
/***************************************************************/

double update_alpha_ms_MH(double prop_mean,  /* the mean of the proposal dist'n */
			  msType *ms,
			  int level,         /* the current level of aggrigation */ 
			  int dim            /* the dimension of the next level 
						of aggrigation */
			  ){

  double proposal;   /* the proposed update for alpha */
  double current;    /* the current value of alpha */
  double prop_sd;    /* the std dev of the proposal dist'n */
  double lg_prop_mn; /* the log of the mean of the proposal dist'n */	
  double log_ratio;  /* the log of the acceptance ratio */
  int i;             /* index variable */


  lg_prop_mn = log(prop_mean);
  /**** the current value of alpha ****/
  current = ms->al[level];

  /******** compute proposal std deviation ********/
  prop_sd = - ddlpost_lalpha(prop_mean, ms, level, dim);
  if ( (prop_mean * sqrt(prop_sd) ) < 1e-10) 
    c_error("Infinite MH proposal variance in update_alpha_ms_MH");
  else prop_sd = MH_sd_inflate / sqrt(prop_sd);

  for(i = 0; i < MH_iter; i++){
    proposal = rlnorm(lg_prop_mn, prop_sd);   /* log normal proposal dist'n */
    log_ratio = 
      lpost_lalpha(proposal, ms, level, dim)
      - lpost_lalpha(current, ms, level, dim)
      + dlnorm(current, lg_prop_mn, prop_sd, 1) 
      - dlnorm(proposal, lg_prop_mn, prop_sd, 1);
    if(runif(0, 1) < exp(log_ratio)) current = proposal;
    /* printf("%5d %14g %14g %14g %14g \n", i, prop_mean, prop_sd,proposal, current); */
  } /* i loop over MH iters */
  return(current);

} /* update_alpha_ms_MH */


/***************************************************************/
/********* COMPUTE THE MARGINAL LOG POSTERIOR OF ALPHA   *******/
/*********       FOR THE MULTI SCALE MODEL               *******/
/***************************************************************/

double lpost_alpha(double alpha, /* evaluate at alpha */
		   msType *ms, 
		   int level,    /* the current level of aggrigation */ 
		   int dim       /* the dimension of the next level of aggrigation */
		   ){
  
  double logpost = 0.0;
  int i, j, k, l;          

  logpost = dim*dim * ( lgammafn( 4.0 * alpha) - 4.0 * lgammafn(alpha) );
  for(i=0; i < dim; i++){
    for(j=0; j < dim; j++){
      for(k=0; k<2; k++)
        for(l=0; l<2; l++)
          logpost += lgammafn( ms->ag[level][2*i+k][2*j+l] + alpha );
      logpost -= lgammafn( ms->ag[level+1][i][j] + 4.0 * alpha );
    } /* loop over columns of ms.ag[level] */
  } /* loop over rows of ms.ag[level] */

  /****************  ADD THE LOG PRIOR *************/
    logpost -= ( -ms->al_kap1 * log(ms->al_kap2)  -  ms->al_kap1 * log(alpha) 
	        + ms->al_kap2 * pow( alpha, ms->al_kap3 ) );

  return(logpost);

} /* lpost_alpha */


/***************************************************************/
/*********      COMPUTE THE DIRIVATIVE OF THE            *******/
/*********     MARGINAL LOG POSTERIOR OF ALPHA           *******/
/*********       FOR THE MULTI SCALE MODEL               *******/
/***************************************************************/


double dlpost_alpha(double alpha, /* evaluate at alpha */
		   msType *ms, 
		   int level,    /* the current level of aggrigation */ 
		   int dim       /* the dimension of the next level of aggrigation */
		   ){
  
  double dlogpost = 0.0;
  int i, j, k, l;          

  dlogpost = dim*dim * ( 4.0 * digamma( 4.0 * alpha) - 4.0 * digamma(alpha) );
  for(i=0; i < dim; i++){
    for(j=0; j < dim; j++){
      for(k=0; k<2; k++)
        for(l=0; l<2; l++)
          dlogpost += digamma( ms->ag[level][2*i+k][2*j+l] + alpha );
      dlogpost -= 4.0 * digamma( ms->ag[level+1][i][j] + 4.0 * alpha );
    } /* loop over columns of ms.ag[level] */
  } /* loop over rows of ms.ag[level] */

  /****************  ADD THE LOG PRIOR *************/
  dlogpost -= (  - ms->al_kap1 / alpha 
	       + ms->al_kap2 * ms->al_kap3 * pow( alpha, ms->al_kap3 - 1.0 ) );

  return(dlogpost);

} /* dlpost_alpha */


/***************************************************************/
/*********      COMPUTE THE SECOND DIRIVATIVE OF THE     *******/
/*********     MARGINAL LOG POSTERIOR OF ALPHA           *******/
/*********       FOR THE MULTI SCALE MODEL               *******/
/***************************************************************/


double ddlpost_alpha(double alpha, /* evaluate at alpha */
		   msType *ms, 
		   int level,    /* the current level of aggrigation */ 
		   int dim       /* the dimension of the next level of aggrigation */
		   ){
  
  double ddlogpost = 0.0;
  int i, j, k, l;          

  ddlogpost = dim*dim * ( 16.0 * trigamma( 4.0 * alpha) - 4.0 * trigamma(alpha) );
  for(i=0; i < dim; i++){
    for(j=0; j < dim; j++){
      for(k=0; k<2; k++)
        for(l=0; l<2; l++)
          ddlogpost += trigamma( ms->ag[level][2*i+k][2*j+l] + alpha );
      ddlogpost -= 16.0 * trigamma( ms->ag[level+1][i][j] + 4.0 * alpha );
    } /* loop over columns of ms.ag[level] */
  } /* loop over rows of ms.ag[level] */

   /****************  ADD THE LOG PRIOR *************/
  ddlogpost += ( -  ms->al_kap1 / pow(alpha, 2.0) 
	       - ms->al_kap2 * ms->al_kap3 * (ms->al_kap3 - 1.0) 
		   * pow( alpha, ms->al_kap3 - 2.0 ) );
  
  return(ddlogpost);

} /* ddlpost_alpha */


/***************************************************************/
/******* COMPUTE THE MARGINAL LOG POSTERIOR OF LOG ALPHA   *****/
/*******             (BUT EVALUATED AT ALPHA)              *****/
/*******            FOR THE MULTI SCALE MODEL              *****/
/***************************************************************/

double lpost_lalpha(double alpha, /* evaluate at alpha */
		   msType *ms, 
		   int level,    /* the current level of aggrigation */ 
		   int dim       /* the dimension of the next level of aggrigation */
		   ){

    return(lpost_alpha(alpha, ms, level, dim) + log(alpha));

  } /* lpost_lalpha */


/***************************************************************/
/*********      COMPUTE THE DIRIVATIVE OF THE            *******/
/*********    MARGINAL LOG POSTERIOR OF LOG ALPHA        *******/
/*******             (BUT EVALUATED AT ALPHA)              *****/
/*********       FOR THE MULTI SCALE MODEL               *******/
/***************************************************************/


double dlpost_lalpha(double alpha, /* evaluate at alpha */
		     msType *ms, 
		     int level,    /* the current level of aggrigation */ 
		     int dim       /* the dimension of the next level of aggrigation */
		     ){

    return(dlpost_alpha(alpha, ms, level, dim) * alpha + 1);

  } /* dlpost_lalpha */


/***************************************************************/
/*********      COMPUTE THE SECOND DIRIVATIVE OF THE     *******/
/*********      MARGINAL LOG POSTERIOR OF LOG ALPHA      *******/
/*********           (BUT EVALUATED AT ALPHA)            *******/
/*********       FOR THE MULTI SCALE MODEL               *******/
/***************************************************************/


double ddlpost_lalpha(double alpha, /* evaluate at alpha */
		    msType *ms, 
		    int level,    /* the current level of aggrigation */ 
		    int dim       /* the dimension of the next level of aggrigation */
		    ){

    return( dlpost_alpha(alpha, ms, level, dim) * alpha + 
	   ddlpost_alpha(alpha, ms, level, dim) * alpha * alpha);

  } /* ddlpost_lalpha */



/***************************************************************/
/****         UPDATE IMAGE USING MAXIMUM LIKELIHOOD       ******/
/***************************************************************/

void  update_image_ml(expmapType *expmap, cntType *src, controlType *cont){

  int i,j;         /* indexing variables */

  for(i=0; i<src->nrow; i++)
    for(j=0; j<src->ncol; j++){
      src->img[i][j] = exp( log(src->data[i][j]) - log(expmap->prod[i][j]) );
    }

  if(cont->em==0)
    error("No code for MCMC fitting with flat prior (i.e, ML)!!");

} /* update_image_ml */


/***************************************************************/
/*********         UPDATE A SCALE MODEL PARAMTER       *********/
/***************************************************************/

/* Added ExpMap Per Jason Kramer 13 Mar 2009 */
void update_scale_model(scalemodelType *scalemodel, expmapType *expmap, cntType *cnt, 
			controlType *cont){
  double total_cnt = 0.0;
  double total_exp = 0.0;
  int i, j; 

  for(i=0; i<cnt->nrow; i++){
    for(j=0; j<cnt->ncol; j++){
      total_cnt += cnt->data[i][j];
      total_exp += expmap->map[i][j]*cnt->img[i][j]; /* Per Jason Kramer's correction 13 Mar */
    } /* j loop over columns */
  } /* i loop over rows */


  if(cont->em){   /* if EM compute mode */
    scalemodel->scale = (total_cnt + scalemodel->scale_pr - 1) /
                          (total_exp + scalemodel->scale_exp);
    if(scalemodel->scale < 0) scalemodel->scale = 0.0;  
  } /* if EM */  
  else            /* if MCMC sample */
    scalemodel->scale =
      rgamma(total_cnt + scalemodel->scale_pr, 1/(total_exp + scalemodel->scale_exp));
} /* update_scale_model */

/***************************************************************/
/***************         UPDATE IMAGE IN DEBLUR     ************/
/***************************************************************/

void update_deblur_image(expmapType *expmap, cntType *deblur, cntType *src, 
			 cntType *bkg, scalemodelType *bkg_scale){

  int i, j;      /* index variables */

  for(i=0; i<deblur->nrow; i++){
    for(j=0; j<deblur->ncol; j++){
      deblur->img[i][j] = 
        (src->img[i][j] + bkg_scale->scale * bkg->img[i][j]) * expmap->map[i][j];
    } /* loop over columns */
  } /* loop over rows */

} /* update deblur image */



/***************************************************************/
/***************  PRINT PARAMETER FILE HEADER       ************/
/***************************************************************/

void print_param_file_header(FILE *param_file, controlType *cont,
        expmapType *expmap, msType *ms) 
{
  if (cont->em)
    fprintf(param_file, "#\n# Code will run in mode-finding mode.\n");
  else 
    fprintf(param_file, "#\n# Code will run in posterior sampling mode.\n");
  if(cont->fit_bkg_scl)
    fprintf(param_file, "#\n# A scale parameter will be fit to the bkg model.\n");
  if (cont->em) 
    fprintf(param_file, "#\n# The maximum number of EM iterations is %d.\n", cont->max_iter);
  else { /* if gibbs */
    fprintf(param_file, "#\n# The total number of Gibbs draws is %d,", cont->max_iter);
    fprintf(param_file, " every %dth draws will be saved.\n", cont->save_thin);
  } /* if gibbs */
  if(cont->model == 1) {
    fprintf(param_file, "#\n# The model will be fit using the Multi Scale Prior.\n");
  }
    
  fprintf(param_file, "#\n# The data matrix is %d by %d.\n",  expmap->nrow, expmap->ncol);
  fprintf(param_file, "#\n# The data file should contain a  2^%d by 2^%d matrix of counts.\n", 
    ms->power, ms->power);
  
  fprintf(param_file, "#\n# Starting Values for the smoothing parameter (alpha):\n");
  int i;
  for(i = 0; i < ms->power; i++) {
    fprintf(param_file, "# Aggregation Level: %2d,   alpha: %g", i, ms->al[i]);
    if (i == 0) fprintf(param_file, " (Full Data)\n");
    else if (i == ms->power-1) fprintf(param_file, "  (In the 2x2 table)\n");
    else fprintf(param_file, "\n");
  } /* loop over ms.al */
  
  fprintf(param_file, "#\n# The prior distribution on the total count from the multiscale component is\n");
  fprintf(param_file, "# Gamma(%f, %f).\n", ms->ttlcnt_pr, ms->ttlcnt_exp);
  fprintf(param_file, "#\n# The hyper-prior smoothing parameter (kappa 2) is %g.\n#\n",
    ms->al_kap2);

    
  /* print column names */
  if(verbose >1) 
    fprintf(param_file, "iteration ");
  if(verbose > 0){
    fprintf(param_file, "logPost ");
    fprintf(param_file, "stepSize ");
  }
  if (verbose > 2)
    fprintf(param_file, "cycleSpinRow cycleSpinCol ");
  if(verbose > 2) {
    for (i = 0; i < ms->power; i++) {
      fprintf(param_file, "smoothingParam%d ", i);
    }
  }
  if(verbose > 2)
    fprintf(param_file, "expectedMSCounts ");
  if(cont->fit_bkg_scl && verbose > 2) 
    fprintf(param_file, "bkgScale ");
  
  // fprintf(param_file, "\n");
}


/***************************************************************/
/******  MAIN INTERFACE FOR READING DATA FROM ASCII FILES  *****/
/***************************************************************/


void image_analysis_ascii(double *outmap,
  double *post_mean,
  char **cnt_filename,
  char **src_filename, 
  char **psf_filename, 
  char **map_filename, 
  char **bkg_filename,
  char **out_filename,
  char **param_filename,
  int *max_iter,
  int *burn,
  int *save_iters,
  int *save_thin,
  int *nrow,
  int *ncol,
  int *nrow_psf,
  int *ncol_psf,
  int *em,
  int *fit_bkg_scl,
  double *alpha_init,
  int *alpha_init_len,
  double *ms_ttlcnt_pr,
  double *ms_ttlcnt_exp,
  double *ms_al_kap2,
  double *ms_al_kap1,
  double *ms_al_kap3)
{
  controlType cont;         /* the control variables */
  psfType psf;              /* The psf */
  expmapType expmap;        /* The exposure map */
  cntType obs;              /* The observed counts and model */
  cntType deblur;           /* The deblurred counts and model */
  cntType src;              /* The source counts and model (starting values) */
  cntType bkg;              /* The background counts and model */
  mrfType mrf;              /* the Markov Rand Field Prior */
  msType ms;                /* The Multiscale Prior */
  llikeType llike;          /* The log likelihood */
  scalemodelType bkg_scale; /* The Background Scale Model */

  char  *cnt_file_nm = *cnt_filename;     /* name of the counts file */
  char  *src_file_nm = *src_filename;     /* name of source file (starting value) */
  char  *psf_file_nm = *psf_filename;     /* name of the psf file */
  char  *map_file_nm = *map_filename;     /* name of the exposure file */
  char  *bkg_file_nm = *bkg_filename;     /* name of background file (starting value)*/
  // char  *mrf_file_nm = *mrf_filename;     /* name of high res datafile for MRF prior */  
  // char *prec_file_nm = *prec_filename;    /* name of precision file:outpt fr MRF prior*/
  // char  *dbg_file_nm = *dbg_filename;     /* name of the temp dump output file */
  
  int i, j;                                /* indexing variables */ 

  /***************************************************************/
  /***********************  OPEN THE FILES ***********************/
  /***************************************************************/

  if (!( obs.file=fopen( cnt_file_nm, "r")))
    c_error("Could not open the COUNT (observation) file");
  if (!( src.file=fopen( src_file_nm, "r")))
    c_error("Could not open the SOURCE (starting value) file");
  if (!(psf.file=fopen(psf_file_nm, "r"))) 
    Rprintf("\nNo PSF file specified. Using default value of 1\n");
  if (!(expmap.file=fopen(map_file_nm, "r")))
    Rprintf("\nNo exposure map file specified. Using uniform exposure as default\n");
  if (!( bkg.file=fopen( bkg_file_nm, "r")))
    Rprintf("\nNo background file specified. Using zero background\n");

  // if (!(cont.debug=fopen( dbg_file_nm, "w"))) 
  //   c_error("Could not open the DEBUG OUTPUT file");


  /******************************************************************/
  /**********       READ INPUTS AND ALLOCATE MEMORY        **********/
  /**********            READ AND NORMALIZE PSF            **********/
  /**********  READ COUNTS & SET STARTING VALUE FOR IMAGE  **********/
  /** READ EXP MAP & COMPUTE PROB COUNTS NOT SPILLING OFF DETECTOR **/
  /******************************************************************/    

  /* (NS) moved to bayes_image_analysis (MAIN ANALYSIS LOOP) */
  // GetRNGstate();    /********** Initialize R Random Seed ************/
  
  /***************************************************************/
  /***********************  Set control values *******************/
  /***************************************************************/  
  
  initialize_control(&cont, &expmap, &psf, &ms, max_iter, burn, save_iters, save_thin, 
    nrow, ncol, nrow_psf, ncol_psf, em, fit_bkg_scl, alpha_init, alpha_init_len,
    ms_ttlcnt_pr, ms_ttlcnt_exp, ms_al_kap2,ms_al_kap1,ms_al_kap3);
  allocate_memory(&psf, &expmap, &obs, &deblur, &src, &bkg,
    &ms, &mrf, &bkg_scale, &cont);
  read_psf(&psf);
  read_data_or_image(0, &obs);
  read_data_or_image(1, &src);
  read_bkg(&bkg);
  read_expmap(&expmap);

  /***************************************************************/
  /* Re-Norm bkg->img into same units as src->img [AVC Oct 2009] */
  /* probably more elegant to have it in its own little module ***/
  /* But for now it is done here: ********************************/
    for(i=0; i < expmap.nrow; i++){ 
      for(j=0; j < expmap.ncol; j++){
        bkg.img[i][j] *= expmap.max_val;
      }
    }
  /* End Renorm of bkg->img */
  /***************************************************************/

  // if(cont.mrf) read_hires(&src, &mrf);
  
  bayes_image_analysis(outmap, post_mean, *out_filename, *param_filename, &cont, &psf, 
    &expmap, &obs, &deblur, &src, &bkg, &mrf, &ms, &llike, &bkg_scale);
  
}/* main ascii interface */



/***************************************************************/
/******  MAIN INTERFACE FOR READING DATA FROM R OBJECTS   ******/
/***************************************************************/

void image_analysis_R(double *outmap, 
  double *post_mean,
  double *cnt_vector,
  double *src_vector, 
  double *psf_vector, 
  double *map_vector, 
  double *bkg_vector,
  char **out_filename,
  char **param_filename,
  int *max_iter,
  int *burn,
  int *save_iters,
  int *save_thin,
  int *nrow,
  int *ncol,
  int *nrow_psf,
  int *ncol_psf,
  int *em,
  int *fit_bkg_scl,
  double *alpha_init,
  int *alpha_init_len,
  double *ms_ttlcnt_pr,
  double *ms_ttlcnt_exp,
  double *ms_al_kap2,
  double *ms_al_kap1,
  double *ms_al_kap3)
{
  controlType cont;         /* the control variables */
  psfType psf;              /* The psf */
  expmapType expmap;        /* The exposure map */
  cntType obs;              /* The observed counts and model */
  cntType deblur;           /* The deblurred counts and model */
  cntType src;              /* The source counts and model (starting values) */
  cntType bkg;              /* The background counts and model */
  mrfType mrf;              /* the Markov Rand Field Prior */
  msType ms;                /* The Multiscale Prior */
  llikeType llike;          /* The log likelihood */
  scalemodelType bkg_scale; /* The Background Scale Model */ 

  int i, j;                                /* indexing variables */ 

  
  initialize_control(&cont, &expmap, &psf, &ms, max_iter, burn, save_iters, save_thin, 
    nrow, ncol, nrow_psf, ncol_psf, em, fit_bkg_scl, alpha_init, alpha_init_len,
    ms_ttlcnt_pr, ms_ttlcnt_exp, ms_al_kap2,ms_al_kap1,ms_al_kap3);
  allocate_memory(&psf, &expmap, &obs, &deblur, &src, &bkg,
    &ms, &mrf, &bkg_scale, &cont);
  set_psf_from_R(psf_vector, &psf);
  set_obs_from_R(cnt_vector, &obs);
  set_image_from_R(src_vector, &src);
  set_image_from_R(bkg_vector, &bkg);
  set_expmap_from_R(map_vector, &expmap);

  /***************************************************************/
  /* Re-Norm bkg->img into same units as src->img [AVC Oct 2009] */
  /* probably more elegant to have it in its own little module ***/
  /* But for now it is done here: ********************************/
    for(i=0; i < expmap.nrow; i++){ 
      for(j=0; j < expmap.ncol; j++){
        bkg.img[i][j] *= expmap.max_val;
      }
    }
  /* End Renorm of bkg->img */
  /***************************************************************/
  
  bayes_image_analysis(outmap, post_mean, *out_filename, *param_filename, &cont, &psf, &expmap, 
    &obs, &deblur, &src, &bkg, &mrf, &ms, &llike, &bkg_scale);
  
} /* main R interface */



/***************************************************************/
/****************  MAIN ANALYSIS LOOP  *************************/
/***************************************************************/


void bayes_image_analysis(double *outmap,
  double *post_mean,
  char *out_file_nm,
  char *param_file_nm,
  controlType *cont, 
  psfType *psf,
  expmapType *expmap,
  cntType *obs,
  cntType *deblur, 
  cntType *src,
  cntType *bkg,
  mrfType *mrf,
  msType *ms,
  llikeType *llike,
  scalemodelType *bkg_scale)
{
  FILE *out_file;                         /* the output file */
  if (!( out_file=fopen( out_file_nm, "w")))
    c_error("Could not open the OUTPUT file");

  FILE *param_file;                         /* the parameter output file */
  if (!( param_file=fopen( param_file_nm, "w")))
    c_error("Could not open the PARAMETER file");
  print_param_file_header(param_file, cont, expmap, ms);
    
  /********** Initialize R Random Seed ************/
  
  GetRNGstate();
    
    
  /* Compute probability of counts spilling off detector */
  compute_expmap(psf, expmap, cont);

  update_deblur_image(expmap, deblur, src, bkg, bkg_scale);

  

  /***************************************************************/
  /**********  IF MS COMPUTE LOG PRIOR OF STARTING VALUE *********/
  /***************************************************************/

  if(cont->ms) llike->cur = comp_ms_prior(src, ms);

  /***************************************************************/
  /*************************  MAIN LOOP **************************/
  /***************************************************************/

  for(cont->iter = 1; cont->iter <= cont->max_iter; cont->iter++){  
    if(verbose > 1 && (cont->iter % cont->save_thin == 0)) {
      // Rprintf("ITERATION NUMBER %d.\n", cont->iter);
      fprintf(param_file, "\n%d ", cont->iter);
    }

   /***************************************************************/
   /*********       EVALUATE THE PRIOR DISTRIBUTION     ***********/
   /***************************************************************/

    // if(!cont->ms) llike->cur = 0; 
    // if(cont->mrf) llike->cur = comp_mrf_prior(src, mrf, cont);


  /********************************************************************/
  /*********    REDISTRIBUTE obs.data to deblur.data            *******/
  /*********    SEPERATE deblur.data into src.data and bkg.data *******/
  /*********    IF NECESSARY add  cnts to src.data              *******/
  /********************************************************************/

    redistribute_Counts(psf, obs, deblur, cont, llike);
    remove_bkg_from_data(deblur, src, bkg, bkg_scale, cont);
    if(cont->ms) add_cnts_2_adjust_4_exposure(expmap, src, cont);

    
  /***************************************************************/
  /*********           CHECK MONOTONE CONVERGENCE        *********/
  /***************************************************************/

    if(check_monotone_convg(param_file, llike, ms, cont)) break;
    
  /***************************************************************/
  /*********        UPDATE SOURCE MODEL (src.img)        *********/
  /***************************************************************/

    if(cont->mrf) 
      update_image_mrf(expmap, src, mrf, cont);
    else if(cont->ms)  
      llike->cur = update_image_ms(param_file, expmap, src, ms, cont);
    else
      update_image_ml(expmap, src, cont);   /* mle */

  /***************************************************************/
  /*********          UPDATE BACKGROUND MODEL            *********/
  /***************************************************************/

    if(cont->fit_bkg_scl){
      /* ExpMap Added Per Jason Kramer 13 Mar 2009 */
      update_scale_model(bkg_scale, expmap, bkg, cont);
      if(verbose > 2 && (cont->iter % cont->save_thin == 0)) {
        fprintf(param_file, "%g ", bkg_scale->scale);
      }
    } /* if fit background scale */

  /***************************************************************/
  /*********             UPDATE deblur.img               *********/
  /***************************************************************/

    update_deblur_image(expmap, deblur, src, bkg, bkg_scale);

  /***************************************************************/
  /**** PRINT CURRENT src.img TO SCREEN AND/OR OUTPUT STREAM  ****/
  /***************************************************************/

    if(verbose > 4) print_mat("Image", src->img, src->nrow, src->ncol);
  
    /****** write current iteration of image to R output *****/
                          /*** subject to thining! ***/
    if(cont->save_iters && (cont->iter % cont->save_thin == 0)){
      if(cont->pipe_to_R) write_img_to_Routput(outmap, src);
      fprint_mat(out_file, src->img, src->nrow, src->ncol);  
    }
    
    if (cont->iter > cont->burn && !cont->em) {
      int i, j;
      int m = cont->iter - cont->burn;
      for (i = 0; i < src->nrow; i++) {
        for (j = 0; j < src->ncol; j++) {
          post_mean[i*src->ncol + j] = ((m-1) * post_mean[i*src->ncol + j] + src->img[i][j]) / (double) m;
        }
      }
    }
	
  } /* cont->iter main iteration loop */
  
  
  /***************************************************************/
  /***************   WRITE MAP/MLE ESTIMATE TO FILE **************/
  /***************************************************************/    



  /**** if iterations are not saved write final iteration of image to R output ****/
  if(!cont->save_iters){
    if(cont->pipe_to_R) write_img_to_Routput(outmap, src);
    fprint_mat(out_file, src->img, src->nrow, src->ncol);  
  }

  fclose(out_file);  
  fclose(param_file);
  // fclose(cont->debug);  
  // if (cont->mrf) fclose(mrf->out);  
  PutRNGstate();     /************ Save R Random Seed *************/
} /* main */
