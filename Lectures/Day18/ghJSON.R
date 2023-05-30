ghSearch =
function(query, cookie, maxPages = -1, verbose = FALSE)
{
    pageNum = 1L
    ans = list()
    while(TRUE) {
       j = getForm("https://github.com/search", q = query, type = "repositories", p = pageNum,
                   .opts = list(followlocation = TRUE, verbose = verbose, cookie = cookie,
                                httpheader = c(Accept = "application/json")))

#browser()       
       tmp = fromJSON(j)

       ans = c(ans, tmp$payload$results)

       if(maxPages > -1 && tmp$payload$page >= maxPages)
           break
       
       if(tmp$payload$page == tmp$payload$page_count)
           break

       pageNum = tmp$payload$page + 1L
       message("moving to page ", pageNum)
    }

    ans
}
