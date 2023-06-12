
# Writing functions.


## DRY - Don't Repeat Yourself.
+ same code in 2 places - move it to a function and call that function from both places.
+ Easier to debug, maintain, extend, read, understand
+ Easier to keep things straight in your mind
   + Give the code a name indicating its purpose
+ Allows to replace with a different implementation of the same thing
  with no changes to the code that calls the function.
    + Ideal, but sometimes have to add arguments, etc.

## Adaptable and Extensible

An important goal is to be able to augment a function without breaking what it currently does but make it (optionally) 
+ do additional things, 
+ behave differently, 
+ change result appropriately
+ make it more efficient.




## Short/Small Functions

+ Function that does one thing
   + not several things.
+ Easier to debug
+ Easier to test
+ Easier to replace
+ Easier to read, understand and maintain
+ More chance it can be reused in other contexts
  + in same project or different project.
  
  
## Top down or bottom up.




e = new.env(); source("soFuns.R", e); source("soQAFuns.R", e)
e2 = as.list(e)
len = sapply(e2, function(x) length(body(x) ))



## General




+ Lifting code to parameters and default values
+ Avoid repeating code
  + Move the same code to 

+ example.R
```
    for (i in 1:ncol(data_2)) {
      data_2[, i] = as.numeric(data_2[, i])
    }
```
```
data_2[] = lapply(data_2, as.numeric)
```
Versus
```
data_2 = lapply(data_2, as.numeric)
```


```
  for (i in 1:nrow(data_2)) {
    day <- strsplit(data_2[i, 2], split = ":")
    day <- unlist(day)
    day_1 = day[1]
    day_2 = day[2]
    data_2[i, "Max Time"] = as.POSIXct(sprintf("2023-%i-%s %s:00", i, day_1, day_2))
  }
  for (i in 1:nrow(data_2)) {
    day <- strsplit(data_2[i, 4], split = ":")
    day <- unlist(day)
    day_1 = day[1]
    day_2 = day[2]
    data_2[i, "Minimum Time"] = as.POSIXct(sprintf("2023-%i-%s %s:00", i, day_1, day_2))
  }
```

+ 2 loops over the same indices
+ Vectorize the strsplit()



+ example2.R - repeated code


Check for global variables
codetools
CodeAnalysis

+ Solar data tables.

+ Look at student submissions for HW1 or 2 code and see how to refactor it.
  + Leena's or Sarah's or Ben's, Sirvash, Robert

+ URLdecode
   + preallocate
   + use strsplit(), map and re-combine
       + vectorized

+ Write RFirefoxData functions

+ Look at SO questions about debugging.
  + not obvious very good source.

<!--
+ Write functions to download PhotoRoster
Can't use as shows student data.
-->

# Debugging 

+ Fish function in github.com/fishsciences/telemetry  - tag_tales.R
+ Psychology DSI function
+ Formula with weights.


+ Debugging non-exported functions

+ debug package ???


+ options(error = recover)
+ debug(funName)
+ browser()/recover() in code
+ trace()




