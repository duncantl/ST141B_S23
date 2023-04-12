readTableData =
    #
    # Given the lines containing just the data part of a table in the file
    # and the column starting positions, read the data into a data.frame.
    #
function(txt, columnStarts)
{
    widths = diff(columnStarts)
    con = textConnection(txt)
    ans = read.fwf(con, widths = widths)

    w = sapply(ans, is.character)
    ans[w] = lapply(ans[w], trimws)

    # Convert the 7th column - cover from x% to numbers.
    # The % is the last character so get the substring up to the
    # next to last character and then covert the result.
    # Could also use gsub("%", "", ans[[7]])
    ans[[7]] = as.numeric(substring(ans[[7]], 1, nchar(ans[[7]]) - 1))

    ans
}



readTable =
    #
    # high-level function to read the NCBI table.
    # Assumes
    #
    # Expects the header line
    #  readTable(tt[-1])
    #
function(txt, header = txt[1], columnStarts = findColumnStarts(header))
{
    # read the data part
    dataLines = txt[-(1:2)]
    ans = readTableData(dataLines, columnStarts)
    # get the column names from the first line.
    headers = lapply(txt[1:2], function(line)
        read.fwf(textConnection(line), widths = diff(columnStarts)))

    # tmp = lapply(headers, as.character)
    tmp = lapply(headers, function(x) trimws(as.character(x)))
    w = tmp[[1]] == "NA"
    tmp[[1]][w] = ""
    vars = paste(tmp[[1]], tmp[[2]], sep = " ")
    names(ans) = trimws(vars)
    ans
}

# One more top-level function to read all the tables in the NCBI file

readNCBITables =
function(file, lines = readLines(file))
{
    starts = grep("Query #", lines)
    ends = grep("Alignments:", lines)
    mapply(readNCBITable, starts, ends, MoreArgs = list(lines = lines), SIMPLIFY = FALSE)
}

readNCBITable =
function(start, end, lines)
{
    txt = lines[(start + 3):(end - 1)]
    txt = txt[ txt != "" ]
    readTable(txt, columnStarts = findColumnStarts(txt[2]))
}



findColumnStarts =
    # Compute the starting point of each column
    # using the start of each word in the line h
    # Split the text into characters and find
    # the locations of the capital letters which start
    # each word except "cover"
    # So then find any lower case letters that are preceded by a " ", a space
    #
    # Also put the end of the last column so we have the start and end
    # of each column with which we can compute the widths.
function(h)    
{
    chars = strsplit(h, "")[[1]]
    i = which(chars %in% LETTERS)
    w = which(chars %in% letters)
    st = chars[w - 1] == " "
    sort(c(i, w[st], nchar(h)))
}
