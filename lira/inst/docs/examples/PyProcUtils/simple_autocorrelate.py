def autocorr(x,maxlag=-1):
    result = numpy.correlate(x, x, mode='full')
    if maxlag < 0:
        endlag = len(result.size/2)
    else :
        endlag = maxlag
    return result[result.size/2:endlag]
