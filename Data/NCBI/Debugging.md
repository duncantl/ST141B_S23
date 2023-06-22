# Debugging

Start with funs3.R which is an adaptation of funs2.R to try to read
the 2 lines of the header.

```
source("funs3.R")
tbls = readNCBITables("NCBIQuery.txt")
```

```
Error in trimws(vars) : object 'vars' not found
In addition: Warning message:
In readTableData(dataLines, columnStarts) : NAs introduced by coercion
```

So both an error and a warning.
Don't ignore warnings!  Explore them and either fix them or rule them out as false positives.


First thing is to set
```
options(error = recover)
```
This will throw us into the debugger to explore the "call stack" when an error occurs.
I set this in my .Rprofile  so it is always on. 
If I don't want to debug, I have that option and can just exit the debugger.

With this set, we run the command again and now enter the debugger
```
tbls = readNCBITables("NCBIQuery.txt")
```

```
Error in is.factor(x) : object 'vars' not found
In addition: Warning message:
In readTableData(dataLines, columnStarts) : NAs introduced by coercion

Enter a frame number, or 0 to exit   

 1: readNCBITables("NCBIQuery.txt")
 2: funs3.R#54: mapply(readNCBITable, starts, ends, MoreArgs = list(l
 3: (function (start, end, lines) 
{
    txt = lines[(start + 3):(end -
 4: funs3.R#62: readTable(txt)
 5: funs3.R#43: trimws(vars)
 6: mysub(paste0(whitespace, "+$"), mysub(paste0("^", whitespace, "+"
 7: sub(re, "", x, perl = TRUE)
 8: is.factor(x)
 9: mysub(paste0("^", whitespace, "+"), x)
10: sub(re, "", x, perl = TRUE)
11: is.factor(x)
```

Read the error message.
It says 'vars' not found.
Slightly confusing where this actually occurred. This is because of R's **lazy evaluation**.

We see in item 5 `trimws(vars)`.
So jump to item 4 which generated that call to `trimws(vars)`.
This is the function `readTable()`.

Sure enough, we changed the code and now have
```
    headers = lapply(txt[1:2], function(line)
        read.fwf(textConnection(line), widths = diff(columnStarts)))

    names(ans) = trimws(vars)
```
So we are referring to vars but now have the variable named headers. 
This comes from funs2.R.  We need to finish off 
creating vars by combining the values from the two elements of headers.

So this was just an "unfinished code" problem.


What about the warning.
```
In readTableData(dataLines, columnStarts) : NAs introduced by coercion
```
Given the change I made, that might be related to the cover variable, i.e. the 7th variable
since we don't have column names at this point.

I am going to escalate warnings to errors so we can explore this warning as an error
```
options(warn = 2)
```
Now we re-run the command
```
tbls = readNCBITables("NCBIQuery.txt")
```

```
Error in readTableData(dataLines, columnStarts) : 
  (converted from warning) NAs introduced by coercion

Enter a frame number, or 0 to exit   

1: readNCBITables("NCBIQuery.txt")
2: funs3.R#54: mapply(readNCBITable, starts, ends, MoreArgs = list(l
3: (function (start, end, lines) 
{
    txt = lines[(start + 3):(end -
4: funs3.R#62: readTable(txt)
5: funs3.R#38: readTableData(dataLines, columnStarts)
6: funs3.R#19: .signalSimpleWarning("NAs introduced by coercion", ba
7: withRestarts({
    .Internal(.signalCondition(simpleWarning(msg, c
8: withOneRestart(expr, restarts[[1]])
9: doWithOneRestart(return(expr), restart)

Selection: 
```

Let's jump to item 5 by entering 5 at the prompt.

We list the variables in this **call frame**
```
ls()
```
```
[1] "ans"          "columnStarts" "con"          "txt"         
[5] "w"            "widths"      
```
We can also see the body of the function with
```
body()
```
```
{
    widths = diff(columnStarts)
    con = textConnection(txt)
    ans = read.fwf(con, widths = widths)
    w = sapply(ans, is.character)
    ans[w] = lapply(ans[w], trimws)
    ans[[7]] = as.numeric(substring(ans[[7]], 1, nchar(ans[[7]]) - 
        1))
    ans
}
```
Let's examine the 7th element of `ans`:

```
ans[[7]]
```
```
  [1] "pomis m" "pomis p" "pomis p" "pomis a" "pomis a" "pomis a"
  [7] "pomis g" "pomis g" "pomis g" "pomis g" "pomis g" "pomis h"
 [13] "pomis g" "pomis m" "pomis m" "pomis m" "pomis m" "pomis m"
 [19] "pomis m" "pomis m" "pomis m" "pomis m" "pomis m" "pomis m"
 [25] "pomis m" "pomis m" "pomis g" "pomis g" "pomis m" "pomis c"
 [31] "pomis c" "pomis c" "moxis n" "moxis n" "pomis m" "pomis g"
 [37] "cropter" "cropter" "cropter" "cropter" "cropter" "cropter"
 [43] "cropter" "moxis n" "moxis n" "moxis n" "moxis n" "pomis m"
 [49] "pomis c" "cropter" "soprist" "soprist" "stacemb" "pomis m"
 [55] "ctarius" "phaestu" "lakicht" "cropter" "stacemb" "lakicht"
 [61] "lakicht" "phaloph" "ynchope" "stacemb" "ynchope" "rapon t"
 [67] "rapon t" "rapon t" "rapon t" "rapon t" "rapon t" "rapon t"
 [73] "rapon t" "rapon t" "rapon t" "rapon t" "soprist" "ynchope"
 [79] "assoma"  "assoma"  "assoma"  "stacemb" "phaloph" "phaloph"
 [85] "phaloph" "uris ma" "stacemb" "ynchope" "ynchope" "stacemb"
 [91] "stacemb" "stacemb" "ynchope" "heostom" "heostom" "heostom"
 [97] "ynchope" "iopothe" "heostom" "heostom"
```

This is not what we expected. We have a problem.


Since I wrote this code, this was enough to make me realize what the problem was.
Of course, it is not obvious.  But let's look at `columnStarts`:
```
columnStarts
```
```
67  83 110 117 123 131 135 142 169
```
We note
+ there are only 9 values
+ the first doesn't start at 1

Our problem is that we are passing the two lines of the header of the table
and computing the column from the first line of these headers. So these are the wrong values.

In readNCBITable, we can explicitly compute the column starts
and pass them to `readTable()` with
```
 readTable(txt, columnStarts = findColumnStarts(txt[2]))
```

Let's see how this works.
```
source()  # what file did you make the changes to
tbls = readNCBITables("NCBIQuery.txt")
```
This doesn't generate the warning but stops with the error because of the use of vars.

Let's explictly stop in readTableData() to check the 7th column is what we expect.  It seems to be, but
let's make certain.

```
debug(readTableData)
tbls = readNCBITables("NCBIQuery.txt")
```
We step through the commands in the body of the readTableData() function with `n`
and we get to 
the line
```
ans[[7]] = as.numeric(substring(ans[[7]], 1, nchar(ans[[7]]) - 1))
```
Let's examine `ans[[7]]`:
```
  [1] "100%" "100%" "100%" "100%" "100%" "100%" "100%" "100%" "100%"
 [10] "100%" "100%" "98%"  "100%" "97%"  "97%"  "97%"  "97%"  "97%" 
 [19] "97%"  "97%"  "97%"  "97%"  "97%"  "97%"  "97%"  "97%"  "97%" 
 [28] "97%"  "97%"  "97%"  "97%"  "97%"  "98%"  "98%"  "98%"  "91%" 
 [37] "98%"  "98%"  "98%"  "98%"  "98%"  "98%"  "98%"  "98%"  "98%" 
 [46] "98%"  "98%"  "88%"  "88%"  "98%"  "100%" "100%" "99%"  "75%" 
 [55] "100%" "100%" "100%" "89%"  "96%"  "100%" "98%"  "99%"  "100%"
 [64] "99%"  "100%" "100%" "100%" "100%" "100%" "100%" "100%" "100%"
 [73] "100%" "100%" "100%" "100%" "100%" "100%" "96%"  "96%"  "96%" 
 [82] "99%"  "99%"  "99%"  "99%"  "97%"  "99%"  "100%" "100%" "99%" 
 [91] "99%"  "99%"  "100%" "97%"  "97%"  "97%"  "100%" "100%" "97%" 
[100] "97%" 
```
So we have what we want and we seem to have fixed that problem.

Now let's deal with the `vars` issue.


We can continue the computations and we get the error about `vars`.
Let's jump to the call to `readTable()` - item 4

```r
body()
```
```r
{
    dataLines = txt[-(1:2)]
    ans = readTableData(dataLines, columnStarts)
    headers = lapply(txt[1:2], function(line) read.fwf(textConnection(line), 
        widths = diff(columnStarts)))
    names(ans) = trimws(vars)
    ans
}
```

Let's examine the value of headers:
```
headers
```
```
[[1]]
  V1               V2               V3 V4      V5     V6     V7
1 NA Scientific       Common           NA Max     Total  Query 
      V8      V9         V10 V11
1   E    Per.    Acc.         NA

[[2]]
                                                                  V1
1 Description                                                       
                V2               V3          V4      V5     V6     V7
1 Name             Name             Taxid       Score   Score  cover 
      V8      V9         V10              V11
1 Value  Ident   Len         Accession       

```
This is a little hard to see. Let's convert them to character vectors:
```
lapply(headers, as.character)
```
```
[[1]]
 [1] "NA"               "Scientific      " "Common          "
 [4] "NA"               "Max    "          "Total "          
 [7] "Query "           "  E   "           "Per.   "         
[10] "Acc.       "      "NA"              

[[2]]
 [1] "Description                                                       "
 [2] "Name            "                                                  
 [3] "Name            "                                                  
 [4] "Taxid      "                                                       
 [5] "Score  "                                                           
 [6] "Score "                                                            
 [7] "cover "                                                            
 [8] "Value "                                                            
 [9] "Ident  "                                                           
[10] "Len        "                                                       
[11] "Accession       "                                                  
```
These look sensible.

Another way to find this problem is to not modify 
readNCBITable() to pass columnStarts in the call to readTable().
We can then look at headers by adding a call to `browser()`
just after we calculate headers.
Before we do this, we have to stop converting a warning to an error
```
options(warn = 1)
tbls = readNCBITables("NCBIQuery.txt")
```
When we stop, we can examine `headers` (not `header`)
```
[[1]]
  V1 V2 V3 V4 V5   V6      V7                          V8
1 NA NA NA NA NA   Sc ientifi c      Common              

[[2]]
                V1 V2 V3 V4 V5   V6      V7
1 Description      NA NA NA NA   Na me     
                           V8
1        Name            Taxi

```

Again, converting these to character vectors, helps us see the values
```
[[1]]
[1] "NA"                          "NA"                         
[3] "NA"                          "NA"                         
[5] "NA"                          "  Sc"                       
[7] "ientifi"                     "c      Common              "

[[2]]
[1] "Description     "            "NA"                         
[3] "NA"                          "NA"                         
[5] "NA"                          "  Na"                       
[7] "me     "                     "       Name            Taxi"
```
This is not what we expect and is a mess.

Now, let's revert readNCITable() to pass columnStarts in the call to readTable().
Again, we'll use browser() to stop in readTable() after we compute `headers`
and then examine it.

```
lapply(headers, as.character)
```
```
[[1]]
 [1] "NA"               "Scientific      " "Common          "
 [4] "NA"               "Max    "          "Total "          
 [7] "Query "           "  E   "           "Per.   "         
[10] "Acc.       "      "NA"              

[[2]]
 [1] "Description                                                       "
 [2] "Name            "                                                  
 [3] "Name            "                                                  
 [4] "Taxid      "                                                       
 [5] "Score  "                                                           
 [6] "Score "                                                            
 [7] "cover "                                                            
 [8] "Value "                                                            
 [9] "Ident  "                                                           
[10] "Len        "                                                       
[11] "Accession       "                                                  
```

These now seem to be approximately correct.

It appears that we have "NA" for values in the first row of the header when there is no text.

We want to combine the values from the first row with those in the second row.
Let's convert these "NA" to "" and then we can combine

```
tmp = lapply(headers, as.character)
w = tmp[[1]] == "NA"
tmp[[1]][w] = ""
h = paste(tmp[[1]], tmp[[2]], sep = " ")
```
When there is no value in the first row, we have an extra space in the name. So we can use trimws()
to clean these up.
```
h = trimws(h)
```

So we change the code in readTable() to 
```
    tmp = lapply(headers, as.character)
    w = tmp[[1]] == "NA"
    tmp[[1]][w] = ""
    vars = paste(tmp[[1]], tmp[[2]], sep = " ")
    names(ans) = trimws(vars)
```

We re-`source()` our functions and run
```
source("funs4.R")
tbls = readNCBITables("NCBIQuery.txt")
```
There are no errors or warnings. 
Did this give us the correct results.
We need to check the column names, but also the values to see if we messed these up.

```
names(tbls[[1]])
```
```
 [1] "Description"           "Scientific       Name"
 [3] "Common           Name" "Taxid"                
 [5] "Max     Score"         "Total  Score"         
 [7] "Query  cover"          "E    Value"           
 [9] "Per.    Ident"         "Acc.        Len"      
[11] "Accession"            
```
We have too many spaces in the columns that have words across two lines of the headers.

We can fix these after creating them with regular expressions.
However, we can also fix them as/before we create them.

Before we paste the values together, we can call trimws() on the elements of `headers`.
Instead of 
```
    tmp = lapply(headers, as.character)
```
in readTable(), we can use
```
  tmp = lapply(headers, function(x) trimws(as.character(x)))
```
Now we have
```
source("funs4.R")
tbls = readNCBITables("NCBIQuery.txt")
names(tbls[[1]])
```
```
 [1] "Description"     "Scientific Name" "Common Name"    
 [4] "Taxid"           "Max Score"       "Total Score"    
 [7] "Query cover"     "E Value"         "Per. Ident"     
[10] "Acc. Len"        "Accession"      
```
We seem to have fixed the problem.


We now need to re-run our unit-tests on the content of the data.frame's
to verify the results are still correct.



