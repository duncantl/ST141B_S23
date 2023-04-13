readNCBITables =
function(file)
{
    ll = readLines(file)
    starts = which(substring(ll, 1, 7) == "Query #")
    ends = which(substring(ll, 1, nchar("Alignments:")) == "Alignments:")    
    mapply(readTableBetween, starts, ends, MoreArgs = list(ll), SIMPLIFY = FALSE)
}



readTableBetween =
    #
    # This must return a data.frame.
    #
function(startIndex, endIndex, lines = ll)
{
    tt =  lines[ (startIndex +3): (endIndex - 1) ]
    tt = tt[ tt != "" ]

    widths = diff(c(colStarts, nchar(tt[1])))
    ans = readTableData(tt, widths = widths)
    h = read.fwf(textConnection(tt[2]), widths )
    names(ans) = trimws(as.character(h))
    ans
}

readTableData = 
function(tt, colStarts = c(1, 67, 83, 99, 110, 117, 123, 129, 135, 142, 153), widths = diff(colStarts))
{

#    widths = diff(c(colStarts, nchar(tt[1])))

    dataLines = tt[-(1:2)]
    con = textConnection(dataLines)
    # invisible(read.fwf(con, widths))
    read.fwf(con, widths)    
}
