readTableData =
    #
    # Given the lines containing just the data part of a table in the file
    # and the column starting positions, read the data into a data.frame.
    #
function(txt, columnStarts)
{
    # convert the column starts to column widths.
    # Assumes columnStarts contains the end of the line so we can compute
    # the width of the last column.
    widths = diff(columnStarts)

    # Read the data
    con = textConnection(txt)
    ans = read.fwf(con, widths = widths)

    # Get rid of the trailing space for the character variables/columns
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
    #
    # Now expects the first two elements of tt are the two header lines
    # giving the column/variable names
    #
function(txt, header = txt[2], columnStarts = findColumnStarts(header))
{
    # read the data part
    dataLines = txt[-(1:2)]
    ans = readTableData(dataLines, columnStarts)
    # get the column names from the first line.
    headers = lapply(txt[1:2], function(line)
        read.fwf(textConnection(line), widths = diff(columnStarts)))

    tmp = lapply(headers, function(x) trimws(as.character(x)))

    # For the first line of the header, replace "NA" with ""
    # corresponding to columns which no text in this row.
    w = tmp[[1]] == "NA"
    tmp[[1]][w] = ""

    # combine the first and second row text for each column into a column name
    vars = paste(tmp[[1]], tmp[[2]], sep = " ")


    # no longer need to trimws() here as we did in the earlier versions of this
    # function when only dealing with one row of the header.  But doesn't hurt
    # to leave trimws() call here.
    names(ans) = trimws(vars)
    ans
}

# One more top-level function to read all the tables in the NCBI file

readNCBITables =
    #
    # Read all the tables in the given file
    #
function(file, lines = readLines(file))
{
    # Find the starting and ending identifier surrounding each table. 
    starts = grep("Query #", lines)
    ends = grep("Alignments:", lines)
    mapply(readNCBITable, starts, ends, MoreArgs = list(lines = lines), SIMPLIFY = FALSE)
}

readNCBITable =
    #
    # Read a single table given the start and end line index/positions 
    # and all the lines in the file
    # 
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
