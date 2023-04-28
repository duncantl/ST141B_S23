d = read.table("eeyore.log", sep = " ", header = FALSE)
names(d) = c("IP", "login1", "login2", "date1", "date2", "OperationPathVersion", "status", "bytes", "referral", "WebBrowser")

d[,4] = paste(d[,4], d[,5])
d$datetime = strptime(d[,4], "[%d/%b/%Y:%H:%M:%S -0800]")
table(is.na(d$datetime))


# one way of getting the HTTP version
httpVersion = as.numeric(gsub(".* HTTP/", "", d[,6]))

# but have to get the operation (e.g. GET) and the file path 
# So do these with capture groups or strsplit and cleanup.

#
els = strsplit(d[,6], " ")
tmp = do.call(rbind, els)
# matrix so convert to a data.frame
tmp = as.data.frame(tmp)

# Put names on this and clean up the HTTP/1.0 or 1.1 column to get version
names(tmp) = c("operation", "path", "httpVersion")
tmp$httpVersion = gsub("HTTP/", "", tmp$httpVersion)


# Alternatively, we can replace the 5 lines above with the following 2
rx = "^(?P<operation>[A-Z]+) (?P<path>[^ ]+) HTTP/(?P<httpVersion>1\\.[01])"
tmp2 = getCaptures(rx, d[,6], row.names = NULL)


# Combine these 3 columns with those in d and then discard the columns
# we don't need that read.table() created.
d = cbind(d, tmp2)
d = d[ !( names(d) %in% c("date1", "date2", "login1", "OperationPathVersion") ) ]




#head(tmp2)
#table(tmp$operation)






