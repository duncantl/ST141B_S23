# Read the web log data with a complex regular expression but with little additional work.
# Contrast with readTableApproach() using read.table() and  cleaning up the result.

rx = '^(?P<ip>[0-9.]+) - (?P<who>-|[a-z0-9]+) \\[(?P<time>[^]]+)\\] "(?P<operation>[A-Z]+) (?P<path>[^ ]+) HTTP/(?P<httpVersion>1\\.[01])" (?P<status>[0-9]+) (?P<bytes>-|[0-9]+) "(?P<referer>[^"]*)" "(?P<useragent>[^"]+)"'

caps = getCaptures(rx, ll, row.names = NULL)

caps[c("status", "bytes")] = lapply(caps[c("status", "bytes")], as.integer)

