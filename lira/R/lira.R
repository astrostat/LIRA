`lira` <-
function(obs.matrix = stop("obs.matrix must be specified"),
    start.matrix = matrix(1, nrow(obs.matrix), ncol(obs.matrix)), 
    psf.matrix = matrix(1, 1, 1),
    map.matrix = matrix(1, nrow(obs.matrix), ncol(obs.matrix)), 
    bkg.matrix = matrix(0, nrow(obs.matrix), ncol(obs.matrix)),
    out.file = "LIRA.out", 
    param.file = "LIRA.param",
    max.iter = stop("max.iter must be specified"),
    burn = 0,
    save.iters = TRUE,
    thin = 1,
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
            
    if (!is.matrix(obs.matrix) || !is.matrix(start.matrix) || 
        !is.matrix(psf.matrix) || !is.matrix(map.matrix) ||
        !is.matrix(bkg.matrix))
        stop("input images must be matrices")
    
    if (!identical(nrow(obs.matrix), ncol(obs.matrix)))
        stop("input images must be square")
    else if (!all.equal(nrow(obs.matrix), nrow(start.matrix), 
                        ncol(start.matrix), nrow(map.matrix), 
                        ncol(map.matrix), nrow(bkg.matrix), ncol(bkg.matrix)))
        stop("observed data, starting values, exposure map, and background matrices must all have the same dimensions")
    else if (!identical(log(nrow(obs.matrix), base=2) %% 1, 0))
        stop("dimensions of input images must be powers of 2")
    
    post.mean <- matrix(0, nrow(obs.matrix), ncol(obs.matrix))
    
    lira.out <- .C("image_analysis_R", map=double(1), post.mean=post.mean,
        as.double(obs.matrix), 
        as.double(start.matrix), as.double(psf.matrix), as.double(map.matrix), 
        as.double(bkg.matrix), out.file, param.file, as.integer(max.iter),
        as.integer(burn), as.logical(save.iters), as.integer(thin),
        as.integer(nrow(obs.matrix)), as.integer(ncol(obs.matrix)), 
        as.integer(nrow(psf.matrix)), as.integer(ncol(psf.matrix)), 
        as.logical(em), as.logical(fit.bkg.scale),
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
        em.iter <- matrix(NA, nrow(obs.matrix), ncol(obs.matrix))
        while (i < max.iter) {
            em.vector <- scan(out.file, skip=i*nrow(obs.matrix), nlines=nrow(obs.matrix))
            if (length(em.vector) > 0) {
                em.iter <- matrix(em.vector, nrow(obs.matrix), ncol(obs.matrix))
                i <- i + 1
            }
            else break
        }
        outlist <- list(final=em.iter)
    }
    
    outlist <- c(outlist, params[-1], out.file=out.file, param.file=param.file)
    outlist
}
