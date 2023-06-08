mkWord0 =
    # Single word.
    # So have to call it N or 2xN times.
function()
{
    wordLen = sample(3:8, 1)
    chars = sample(c(letters, 0:9), wordLen, replace = TRUE)
    paste(chars, collapse = "")
}

mkWord = mkString = mkString3 =
    # Makes all n words
function(n)    
{
    wordLen = sample(3:8, n, replace = TRUE)
    chars = sample(c(letters, 0:9), sum(wordLen), replace = TRUE)
    tapply(chars, rep(1:n, wordLen), paste, collapse = "")
}

mkString2 =
function(n)
{
    chars = c(letters, 0:9)
    replicate(n,  paste(sample(chars, sample(3:8, 1), replace = TRUE), collapse = ""))
}


if(FALSE) {
    N = 18e6
    N = 1e6
    # z = data.frame(a = mkString(N), b = mkString(N))
    system.time(z <- data.frame(a = mkString(N), b = mkString(N)))

    # 15.75 seconds
    
    system.time({
        tmp = mkString(2*N)
        z = data.frame(a = tmp[1:N], b = tmp[(N+1):(2*N) ])
    })
    # 18.558 seconds

    
    system.time({
        z = as.data.frame(matrix(mkString(2*N), N, 2, dimnames = list(NULL, c("a", "b"))))
    })    

    # 17.262 seconds.


}
