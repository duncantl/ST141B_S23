readTableData =
function(txt, columnStarts)
{
    widths = diff(columnStarts)
    con = textConnection(txt)
    ans = read.fwf(con, widths = widths)

    w = sapply(ans, is.character)
    ans[w] = lapply(ans[w], trimws)

    ans
}










readTable =
    #
    # Expects the header line
    #  readTable(tt[-1])
    #
function(txt, header = txt[1], columnStarts = findColumnStarts(header))
{
    ans = readTableData(txt[-1], columnStarts)
    vars = read.fwf(textConnection(header), widths = diff(columnStarts))
    names(ans) = trimws(vars)
    ans
}

findColumnStarts =
function(h)    
{
    chars = strsplit(h, "")[[1]]
    i = which(chars %in% LETTERS)
    w = which(chars %in% letters)
    st = chars[w - 1] == " "
    sort(c(i, w[st], nchar(h)))
}
