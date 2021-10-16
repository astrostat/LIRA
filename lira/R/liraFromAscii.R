`liraFromAscii` <-
function(obs.file = stop("obs.file must be specified"),
    start.file = stop("start.file must be specified"), 
    psf.file = NULL, 
    map.file = NULL, 
    bkg.file = NULL,
    out.file = "LIRA.out",
    param.file = "LIRA.param",
    max.iter = stop("max.iter must be specified"),
    burn = 0,
    save.iters = TRUE,
    thin = 1,
    nrow = stop("nrow must be specified"),
    ncol = stop("ncol must be specified"),
    nrow.psf = 1,
    ncol.psf = 1,
    mcmc = TRUE,
    fit.bkg.scale = TRUE,
    alpha.init = stop("alpha.init must be specified"),
    ms.total.count.pr = 1,
    ms.total.count.exp = 0.05,
    ms.alpha.kap2 = 1000,
    ms.alpha.kap1 = 0.0,
    ms.alpha.kap3 = 3.0) #p(alpha) = alpha^kap1 * exp(-kap2 * alpha^kap3)
{
    em = !mcmc

    if (!identical(nrow, ncol))
      stop("input images must be square")
    else if (!identical(log(nrow, base=2) %% 1, 0))
      stop("dimensions of input images must be powers of 2")
     
    post.mean <- matrix(0, nrow, ncol)

    lira.out <- .C("image_analysis_ascii", map=double(1), post.mean=post.mean,
        obs.file, start.file, psf.file, 
        map.file, bkg.file, out.file, param.file, as.integer(max.iter), 
        as.integer(burn), as.logical(save.iters), as.integer(thin),
        as.integer(nrow), as.integer(ncol), as.integer(nrow.psf), 
        as.integer(ncol.psf), as.logical(em), as.logical(fit.bkg.scale),
        as.double(alpha.init), as.integer(length(alpha.init)),
        as.double(ms.total.count.pr), as.double(ms.total.count.exp),
        as.double(ms.alpha.kap2),as.double(ms.alpha.kap1),as.double(ms.alpha.kap3), PACKAGE="lira")

    params <- read.table(param.file, header=TRUE)

    # discard the burn-in
    if (burn > 0)
        params <- params[-(1:(burn/thin)),]

    if (mcmc) {
        outlist <- list(final=lira.out$post.mean)
    }
    else {
        i <- 1
        em.iter <- matrix(NA, nrow, ncol)
        while (i < max.iter) {
            em.vector <- scan(out.file, skip=i*nrow, nlines=nrow)
            if (length(em.vector) > 0) {
                em.iter <- matrix(em.vector, nrow, ncol)
                i <- i + 1
            }
            else break
        }
        outlist <- list(final=em.iter)
    }
    
    outlist <- c(outlist, params[-1], out.file=out.file, param.file=param.file)
    outlist
}
