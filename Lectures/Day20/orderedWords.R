if(FALSE) {
    z = readRDS("words.rds")
    source("orderedWords.R")
    tm1 = system.time(x <- mkCol1(z))
    tm2 = system.time(y <- mkCol2(z))
    stopifnot(identical(x, y))
}


mkCol1 =
    #
    # One call to paste, but swap the pairse where z[,1] >= z[,2]
    #
function(z)
{
    # Make a new copy of z so we can swap some of the pairs row-wise
    tmp = z[, c("a", "b")]
    w = z$a >= z$b
    
    tmp2 = tmp$a[w]
    tmp$a[w] = tmp$b[w]
    tmp$b[w] = tmp2

    z$c = paste(tmp$a,  tmp$b, sep = "_")
    z
}


mkCol2 =
    #
    # 2 calls to paste()
    #
function(z)
{
    w = z$a < z$b
    z$c = "" 
    z$c[w] = paste(z$a[w], z$b[w], sep = "_")
    z$c[!w] = paste(z$b[!w], z$a[!w], sep = "_")   
    z
}


mkCol3 =
    # non-vectorized version
function(z)
{
    z$c = apply(z, 1, function(x) paste(x[order(x)], collapse = "_"))
    z
}

mkCol4 =
    # also non-vectorized
function(z)
{
    tmp = apply(z, 1, function(x) x[order(x)])
    z$c = sprintf("%s_%s", tmp[1,], tmp[2,])
    z
}


mkCol5 = slow =
function(z)
{
   ans = character(nrow(z))
   for(i in 1:nrow(z))  {
       ans[i] = if(z[i, 1] < z[i, 2]) 
                     paste0(z[i,1], "_", z[i,2])
                else
                     paste0(z[i,2], "_", z[i,1])
   }
   ans
}
