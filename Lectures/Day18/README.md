
+ Different content types returned from github.com/search
   based on the request header fields, i.e., cookie

+ Minimal request returns HTML
```{r}
j = getURLContent("https://github.com/search?q=R%20URL%20decode&type=repositories",
                  followlocation = TRUE, verbose = TRUE)
attributes(j)
```				  


+ Add cookie
```
gh.cookie = readLines("cookie2", n = 1)
j = getURLContent("https://github.com/search?q=R%20URL%20decode&type=repositories",
                  followlocation = TRUE, verbose = TRUE, cookie = gh.cookie)
attributes(j)
```

  + Claims to be text/plain, but is JSON
  + Mimicing Web browser, set our Accept request header to application/json,
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



## try/tryCatch

