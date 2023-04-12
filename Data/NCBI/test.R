source("funs2.R")
tbls = readNCBITables("NCBIQuery.txt")
length(tbls)

sapply(tbls, class)

sapply(tbls, dim)

sapply(tbls, names)

identical(tbls[[1]], tbls[[2]])


