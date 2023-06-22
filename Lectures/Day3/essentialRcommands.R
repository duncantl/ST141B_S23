# Essential lines of code from Rsession_Day3
# We'll turn them into functions.

dir = "../../Data/NCBI"
ll = readLines(file.path(dir, "NCBIQuery.txt"))

starts = which(substring(ll, 1, 7) == "Query #")
ends = which(substring(ll, 1, nchar("Alignments:")) == "Alignments:")

tt = ll [ (starts[1]+3):(ends[1]-1) ]
tt = tt[ tt != "" ]

colStarts = c(1, 67, 83, 99, 110, 117, 123, 129, 135, 142, 153)
widths = diff(c(colStarts, nchar(tt[1])))

dataLines = tt[-(1:2)]
con = textConnection(dataLines)
ans = read.fwf(con, widths)


h = read.fwf(textConnection(tt[2]), widths)
names(ans) = trimws(as.character(h))




###############

ans = c()
for(i in 1:length(x)) {
    tmp =  doSomething(x[i])
    ans[i] = tmp
}

ans = sapply(x, doSomething)







