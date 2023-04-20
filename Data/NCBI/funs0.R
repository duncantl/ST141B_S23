readTableData =
function(txt, columnStarts)
{
    # assumes the columnStarts contains the length of the line to allow computing
    # the width of the final column.
    widths = diff(columnStarts)
    con = textConnection(txt)
    read.fwf(con, widths = widths)
}


readTable =
    #
    # Expects only the second header line and the data lines, i.e.,
    # the first header line to be removed/absent by the caller
    #  readTable(tt[-1])
    #
function(txt, header = txt[1], columnStarts = findColumnStarts(header))
{
    ans = readTableData(txt[-1], columnStarts)
    # XXX need to compute diff(columnStarts)
    vars = read.fwf(textConnection(header), columnStarts)
    names(ans) = vars
    ans
}

findColumnStarts =
function(h)    
{
    chars = strsplit(h, "")[[1]]
    i = which(chars %in% LETTERS)
    w = which(chars %in% letters)
    st = chars[w - 1] == " "
    # ) in wrong place
    sort(c(i, w[st]), nchar(h))
}
