source("myFuns.R")

words = mkSampleWords()
tm1 = sapply(words, function(x) system.time(fun1(x)))
tm2 = sapply(words, function(x) system.time(fun2(x)))
tmv = sapply(words, function(x) system.time(funv(x)))


saveRDS(tm1, "tm1.rds")
saveRDS(tm2, "tm2.rds")
saveRDS(tmv, "tmv.rds")










# Create words
if(!file.exists("words.rds")) {
    words = mkSampleWords()
    saveRDS(words, "words.rds")
} else
    words = readRDS("words.rds")

tm1 = sapply(words, function(x) system.time(fun1(x)))
tm2 = sapply(words, function(x) system.time(fun2(x)))
tmv = sapply(words, function(x) system.time(funv(x)))



if(!file.exists('tm1.rds')) {
    tm1 = sapply(words, function(x) system.time(fun1(x)))
    saveRDS(tm1, "tm1.rds")
} else
    tm1 = readRDS("tm1.rds")


    tm1 = sapply(words, function(x) system.time(fun1(x)))
    saveRDS(tm1, "tm1.rds")

tm2 = sapply(words, function(x) system.time(fun2(x)))

tmv = sapply(words, function(x) system.time(funv(x)))
