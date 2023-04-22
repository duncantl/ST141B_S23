if(FALSE) {

    Rprof("getCaptures0.prof"); parts = getCaptures(rx2, ll, row.names = NULL); Rprof(NULL)
    Rprof("getCaptures1.prof"); parts = getCaptures(rx2, ll, asDataFrame = FALSE); Rprof(NULL)
    Rprof("getCaptures2.prof"); parts = getCaptures(rx2, ll, asDataFrame = FALSE, SIMPLIFY = TRUE); Rprof(NULL)
    Rprof("getCaptures2.5.prof"); tm2.5 = system.time({parts = as.data.frame(t(getCaptures(rx2, ll, asDataFrame = FALSE, SIMPLIFY = TRUE))) }); Rprof(NULL)    

    # With changes below to
    #  SIMPLIFY = asDataFrame
    #   mapply  MoreArgs = list(asDataFrame = FALSE) always
    # as.data.frame(t(ans))
    Rprof("getCaptures3.prof"); tm3 = system.time({parts = getCaptures(rx2, ll, row.names = NULL)}); Rprof(NULL)

    #  v2.5 is 5.82 and v3 is 7.36
    # Now basically the same and should be as doing the same thing - as.data.frame(t())
    # Issue may have been gc() or byte-compiling after 1st call.

    #
    # profiling shows make.names taking 42.22%  for getCaptures3.prof
    # debug(make.names)
    # where
    # 
    #
# where 1: make.names(value, unique = TRUE)
# where 2: `.rowNamesDF<-`(`*tmp*`, make.names = make.names, value = row.names)
# where 3: as.data.frame.matrix(t(ans))
# where 4 at getCaptures.R#26: as.data.frame(t(ans))
# where 5 at #1: getCaptures(rx2, ll, row.names = NULL)
# where 6: system.time({
#     parts = getCaptures(rx2, ll, row.names = NULL)
# })

    # So in as.data.frame.matrix
    # Change to
    #    as.data.frame(t(ans), row.names = row.names, make.names = FALSE) 

    Rprof("getCaptures4.prof"); tm4 = system.time({parts = getCaptures(rx2, ll, row.names = NULL)}); Rprof(NULL)

    # Fix the row.names in as.data.frame to be row.names = row.names
    #
    # Getting to as.data.frame() as NULL but in as.data.frame.matrix() it is x
    #  Byte-compiler????
    # Mismatching of argument names? No, moved them around now.
}


getCaptures =
function(pat, x, matches = gregexpr(pat, x, perl = TRUE, ...), asDataFrame = TRUE, row.names = x,
         dropNoName = TRUE,
         ..., SIMPLIFY = asDataFrame # Was FALSE
         )
{

    if(length(matches) == 0)
        return(list())

    if(is.null(attr(matches[[1]], "capture.start")))
        stop("no capture group information. Does the regular expression contain capture groups?")
    
    ans = mapply(getCapture, x, matches,
                 MoreArgs =  list(asDataFrame = FALSE), # asDataFrame = asDataFrame),
                 SIMPLIFY = SIMPLIFY)

    if(asDataFrame) {
        #        ans = do.call(rbind, ans)  # , deparse.level = 0L, make.row.names = FALSE)
        #        ans = as.data.frame(t(ans), row.names = seq_along(x), make.names = FALSE)   # row.names       seq_along(x)
        #        ans = as.data.frame.matrix(t(ans), row.names = row.names, make.names = FALSE)   # row.names       seq_along(x)

        ans = as.data.frame.matrix(t(ans), row.names = seq_along(x), make.names = FALSE)   # row.names       seq_along(x)        
        rownames(ans) = row.names
        vars = attr(matches[[1]], "capture.names")
        if(length(vars) && !all(vars == "")) {
            names(ans) = vars
            if(any(w <- (vars == "")))
                ans = ans[!w]
        }
        
        ans
    } else
        ans
}

getCapture =
function(str, m, asDataFrame = FALSE)
{
    st = attr(m, "capture.start")

    w = st != -1
    ans = rep(NA, length(st))
    
    ans[w] =  substring(str, st[w], st[w] + attr(m, "capture.length")[w] - 1L)
       
    if(asDataFrame)
        structure(as.data.frame(as.list(ans), stringsAsFactors = FALSE, make.names = FALSE, row.names = NULL),
#        structure(as.list(ans), class = "data.frame",
                   names = attr(m, "capture.names"))
    else
        ans
}
