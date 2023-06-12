hasMultipleMessages =
function(file, text = readLines(file))
{
    i = grep("^From ", text)
    i[1] == 1 && length(i) > 1 && all( text[ i[-1] - 1] == "")
}



readMessages =
function(file, text = readLines(file),
         containsMultipleEmails = hasMultipleMessages(text = text))
{
    if(containsMultipleEmails) {
        msgs = splitMessages(text)
        lapply(msgs, processEmailMessage)
    } else
        processEmailMessage(text)
}


splitMessages =
    # WRONG
function(text)
{
	w = grepl("^From ", text)
	# check previous line is blank
	w2 = c(TRUE, text[ which(w)[ -1] - 1 ] == "")
	
	split(text, cumsum(w & w2))
}

splitMessages2 =
    # Version 2
function(text)
{
    w = grepl("^From ", text)
    w[ which(w)[-1] ] = text[which(w)[-1]  - 1] == ""
    split(text, cumsum(w))    
}


processEmailMessage =
function(lines)
{
    hb = splitMessage(lines)
    h = readHeader(hb$header)
    boundary = getAttachmentBoundaryString(h)
    tmp = splitBody(hb$body, boundary)


    list(header = h,
         body = tmp$body,
         attachments = tmp$attachments)
}


splitMessage =
function(lines)
{
    div = which(lines == "")[1]
    if(is.na(div))
        stop("no blank line")
 
    list(header = lines[1:(div-1)],
         body = lines[ (div+1):length(lines) ])
}




readHeader =
function(msg)
{
    read.dcf(textConnection(msg$header), all = TRUE)
}
