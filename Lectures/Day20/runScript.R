source("myFuns.R")

if(!file.exists('tm1.rds')) {
    tm1 = sapply(words, function(x) system.time(fun1(x)))
    saveRDS(tm1, "tm1.rds")
} else
    tm1 = readRDS("tm1.rds")


    tm1 = sapply(words, function(x) system.time(fun1(x)))
    saveRDS(tm1, "tm1.rds")

tm2 = sapply(words, function(x) system.time(fun2(x)))

tmv = sapply(words, function(x) system.time(funv(x)))
