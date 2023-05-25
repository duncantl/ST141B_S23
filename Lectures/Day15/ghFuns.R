ghSearch =
function(query, max = -1)
{
    acceptHeader = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8"
    p1 = getForm("https://github.com/search",
                q = query, type= "repositories",
                .opts = list(followlocation = TRUE,
                             verbose = TRUE,
                         httpheader = c(Accept = acceptHeader)))

    doc = htmlParse(p1)
    ans = getPageResults(doc)

    while((max < 0 || length(ans) < max) &&
            length(nxtURL <- getNextURL(doc))) {
        Sys.sleep(1)
        page = getURLContent(nxtURL,
                             verbose = TRUE,
                             httpheader = c(Accept = acceptHeader))

        doc = htmlParse(page)

        ans = c(ans, getPageResults(doc))
    }
    
    ans
}

getPageResults =
function(doc)
{
  xpathApply(doc, "//ul[@class = 'repo-list']/li", procResult)
}

procResult =
function(x)
{
    stars = xpathSApply(x, ".//a[contains(@href, '/stargazers')]", xmlValue, trim = TRUE)

    repos = getNodeSet(x, ".//a[contains(@data-hydro-click, 'https://github.com/')]/@href ")[[1]]
    
    list(tags = xpathSApply(x, ".//a[starts-with(@title, 'Topic:')]", xmlValue, trim = TRUE),
         language = xpathSApply(x, ".//span[@itemprop = 'programmingLanguage']", xmlValue),
         date = getNodeSet(x, ".//relative-time/@datetime")[[1]],
         stars = as.integer(stars),
         repository = repos,
         description = xpathSApply(x, ".//p[@class = 'mb-1']", xmlValue, trim = TRUE))
    
}


getNextURL =
function(doc)
{
    nxt = getNodeSet(doc, "//a[. = 'Next']")
    if(length(nxt) == 0)
        return(character())

    getRelativeURL(xmlGetAttr(nxt[[1]], "href"), "https://github.com/search")    
}
