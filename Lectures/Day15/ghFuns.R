library(XML)
library(RCurl)

ghSearch =
function(ghSearchQuery, max = -1, verbose = TRUE)
{
    acceptHeader = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8"
    p1 = getForm("https://github.com/search",
                q = ghSearchQuery, type= "repositories",
                .opts = list(followlocation = TRUE,
                             verbose = verbose,
                             httpheader = c(Accept = acceptHeader)))
    

    doc = htmlParse(p1)
    ans = getPageResults(doc)

    while((max < 0 || length(ans) < max) &&
            length(nxtURL <- getNextURL(doc))) {
        Sys.sleep(1)
        page = getURLContent(nxtURL,
                             verbose = verbose,
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
    #
    # √ repos link
    # √ description
    # √ tags
    # √ number of stars
    # √ programming language
    # √ date
    #
function(x)
{
    stars = xpathSApply(x, ".//a[contains(@href, '/stargazers')]", xmlValue, trim = TRUE)
    if(length(stars) == 0)
        stars = NA

    repos = getNodeSet(x, ".//a[contains(@data-hydro-click, 'https://github.com/')]/@href ")[[1]]
    
    list(tags = xpathSApply(x, ".//a[starts-with(@title, 'Topic:')]", xmlValue, trim = TRUE),
         language = xpathSApply(x, ".//span[@itemprop = 'programmingLanguage']", xmlValue),
         date = getNodeSet(x, ".//relative-time/@datetime")[[1]],
         stars = mkNumber(stars),
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


mkNumber =
    # convert to an integer, handling values such as
    #  18.1k
    #  18k
function(x)
{
    fac = ""

    if(grepl("[mk]$", x, ignore.case = TRUE)) {
        fac = tolower(substring(x, nchar(x)))
        x = substring(x, 1, nchar(x) - 1)
    }

    val = as.numeric(x)

    if(fac != "") {
        scale = c(k = 1000, m = 1e6)
        val = val * scale[fac]
    }

    val
}
