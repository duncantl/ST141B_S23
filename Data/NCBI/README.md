# Files

+ [README.md](README.md)
   + A strategy for reading tables nested in the NCBIQuery.txt file.
   
+ [test.R](test.R)
    + code to user our functions and check they work.
+ [funs0.R](funs0.R)
   + start of functions from 
+ [funs1.R](funs1.R)
   + refinement of funs0.R
   
+ [funs2.R](funs2.R)
    + pretty good version that reads all the tables in the NCBI file
	   + converts the cover variable from x% to a numeric vector of percentage values
+ [funs3.R](funs3.R)
   + attempt to make the functions read both header lines to get the full variable names, i.e.,
     "Scientific Name" and "Common Name" rather than just "Name" and "Name"
   + this has problems we need to debug

+ [Debugging.md](Debugging.md)
   + process of debugging funs3.R to get to funs4.R
   
+ [funs4.R](funs4.R)

# Strategy for Problem Solving
## Interactively Developing the Code to Read a Table

Read the tables in the NCBI query results

2 steps
+ Find each table within the document
+ Read the contents of the table


Read entire document as character vector of lines

```
ll = readLines("NCBIQuery.txt")
```

Find the 'Query #'

```r
starts0 = which(substring(ll, 1, 7) == "Query #")
starts = grep("Query #", ll)
```

```r
ends0 = which(substring(ll, 1, 10) == "Alignments")
ends = grep("Alignments", ll)
```


First table
```
rows = starts[1]:ends[1]
tt = ll[ rows  ]
```


Examine result
+ Query #, blank line and 'Sequences producing significant alignments'
+ Trailing blank lines and Alignments:

    
```	
rows = (starts[1]+3):(ends[1] - 1)
tt = ll[ rows  ] 
```

Remove blank lines
```
tt = tt[ tt != '' ]
``` 



Let's separate the header lines from the data lines for the moment
and focus on the data part.
```
h = tt[2]
d = tt[-(1:2)]
```


This is fixed width format. We can use read.fwf().
We need 
+ a file or a connection containing the contents to read
+ the widths of the columns, i.e., the differences between the start and end of each column.

```
colStarts = c(1, 67, 83, 99, 110, 117, 123, 129, 135, 142, 153)
```

We also need the end of the line 
```
colStarts = c(colStarts, nchar(h))
```

What are the widths

```
widths = diff(colStarts)
```

```
con = textConnection(d)
tbl = read.fwf(con, widths = widths)
```

```
class(tbl)
dim(tbl)
sapply(tbl, class)
```


```
head(tbl)
```


## Column names
To get the names.
Since none of the column names contain spaces, we could split the header line by space
and clean up the words
```
h = strsplit(tt[2], " ")[[1]]
h[ h != "" ]
```

```
names(tbl) = h
```


However, how can we be more general to handle cases with spaces in the column names?

We can read the first line as a fixed-width-format (FWF) file with
one row and no header
```
h2 = read.fwf(textConnection(tt[2]), widths = diff(colStarts))
h3 = as.character(h2)
```
Need to remove the trailing white space:
```
h4 = trimws(h3)
```


## Putting Code into Functions

We want to make a function to read the table as we have a second one in this file
and many more from different query results.


See funs0.R, funs1.R, funs2.R.



# Computing the Column Starting Points

If we don't have regular expressions/pattern matching
+ manually
+ finding capital letters
  + then dealing with "cover"
+ Using both header lines

```
chars = strsplit(h, "")[[1]]
```

```
i = which(chars %in% LETTERS)
```

```
w = which(chars %in% letters)
st = chars[w - 1] == " "
w[st]
```

```
colStarts2 = sort(c(i, w[st]))
```

```
colStarts2 = c(colStarts2, nchar(h))
```

```
all(colStarts ==  colStarts2)
cbind(colStarts, colStarts2)
```
