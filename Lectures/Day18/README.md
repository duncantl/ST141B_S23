
+ Different content types returned from github.com/search
   based on the request header fields, i.e., cookie

+ Minimal request returns HTML
```{r}
j = getURLContent("https://github.com/search?q=R%20URL%20decode&type=repositories",
                  followlocation = TRUE, verbose = TRUE)
attributes(j)
```				  


+ Add cookie to the HTTP request
   + Copied from the Web browser
```
gh.cookie = readLines("cookie2", n = 1)
j = getURLContent("https://github.com/search?q=R%20URL%20decode&type=repositories",
                  followlocation = TRUE, verbose = TRUE, cookie = gh.cookie)
attributes(j)
substring(j, 1, 100)
```

  + Claims to be text/plain, but is JSON
  + Mimicking Web browser, set our Accept request header to application/json,
    then Web server declares result to be application/json.
	
+ Process with fromJSON() using any of the RJSONIO, jsonlite, rjson packages
```
library(RJSONIO)
d = fromJSON(j)

class(d)
length(d)
names(d)
sapply(d, class)
sapply(d, length)

names(d$payload)
```


```r
d$payload$page
d$payload$page_count
d$payload$result_count
```


```r
d$payload$results[[1]]
```
```
$id
[1] "69953146"

$archived
[1] FALSE

$color
[1] "#555555"

$followers
[1] 11

$has_funding_file
[1] FALSE

$hl_name
[1] "mllg/base64<em>url</em>"

$hl_trunc_description
[1] "Fast and <em>url</em>-safe base64 encoder and <em>decoder</em> for <em>R</em>"

$language
[1] "C"

$mirror
[1] FALSE

$owned_by_organization
[1] FALSE

$public
[1] TRUE

$repo
$repo$repository
$repo$repository$id
[1] 69953146

$repo$repository$name
[1] "base64url"

$repo$repository$owner_id
[1] 1260920

$repo$repository$owner_login
[1] "mllg"

$repo$repository$updated_at
[1] "2020-01-11T00:16:31.650Z"

$repo$repository$has_issues
[1] TRUE



$sponsorable
[1] FALSE

$topics
[1] "cran"      "r"         "base64"    "base32"    "base64url"

$type
[1] "Public"

$help_wanted_issues_count
[1] 0

$good_first_issue_issues_count
[1] 0

$starred_by_current_user
[1] FALSE
```


+ Next page
  + From browser, add p=2
```
j2 = getForm("https://github.com/search", q = "R URL decode", type = "repositories", p = 2,
             .opts = list(followlocation = TRUE, verbose = TRUE, cookie = gh.cookie,
			              httpheader = c(Accept = "application/json")))
```



+ ghSearch() - new version w/o XPath


## try/tryCatch




## More JSON

+ USGS Water Dashboard 
  + [https://dashboard.waterdata.usgs.gov/app/nwd/en/?aoi=default](https://dashboard.waterdata.usgs.gov/app/nwd/en/?aoi=default)

+ Examine HTTP requests
  + Several return HTML
  + 2 return JSON 
     + 1 for geographical information about USA state/territory
	 + 1 with station-level data

+ URL for the JSON request
```
https://dashboard.waterdata.usgs.gov/service/cwis/1.0/odata/CurrentConditions?$top=15000&$filter=(AccessLevelCode eq 'P') and (1 eq 1 and true) and (SiteTypeCode in ('ST','ST-CA','ST-DCH','ST-TS')) and (ParameterCode in ('30208','30209','50042','50050','50051','72137','72138','72139','72177','72243','74072','81395','99060','99061','00056','00058','00059','00060','00061'))&$select=AgencyCode,SiteNumber,SiteName,SiteTypeCode,Latitude,Longitude,CurrentConditionID,ParameterCode,TimeLocal,TimeZoneCode,Value,ValueFlagCode,RateOfChangeUnitPerHour,StatisticStatusCode,FloodStageStatusCode&$orderby=SiteNumber,AgencyCode,ParameterCode,TimeLocal desc&caller=National Water Dashboard default
```
     

+ Make request in R
  + Need to escape the spaces, ( and ), ', etc.
  + getFormParams() or URLencode() with some string manipulation
```r
library(RCurl)
params = getFormParams(u0)
tt = getForm("https://dashboard.waterdata.usgs.gov/service/cwis/1.0/odata/CurrentConditions",
            .params = params)
attributes(tt)
```

+ Convert JSON to R data structure
```r
library(RJSONIO)
d = fromJSON(tt)
```

+ Examine result(s)
```r
class(d)
names(d)
length(d)
sapply(d, length)

table(sapply(d$value, class))
table(sapply(d$value, length))

names(d$value[[1]])

table(unlist(lapply(d$value, names)))
```


+ Convert each element of `d$value` to a data.frame and rbind()
  + Errors as some values are NULL
     + Convert NULL values to NA
```
tmp = lapply(d$value, function(x) {
    w = sapply(x, is.null)
    x[w] = NA
    as.data.frame(x)
})

d2 = do.call(rbind, tmp)
```



## HTTP POST Requests
### Piazza

+ Send request to URL
  + Additional information customizing request
  + Not in the `?name=value&name=value` part of a GET request
  + Data in the body of the request 
  
+ Why POST?
   + Send very large amount of data
      + upload image, PDF, zip/tar files
      + GET is limited to 2,048 characters
   + Don't have to fuss with encoding




## Web-based Data Visualization

+ Gapminder - https://www.gapminder.org/tools/#$chart-type=bubbles&url=v1
+ d3Map.html - same as d3Unemployment but with explanation of low-level details.

+ https://www.stat.ucdavis.edu/~duncan/VizEg/AnimatedCOVIDMap/animatedMap.html
