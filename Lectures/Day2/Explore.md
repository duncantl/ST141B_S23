Downloaded the file itcont.txt as a zip file.

What format does it have?

Too big to open in a text editor.

Use shell command to look at the top.
Or in R
readLines("itcont.txt", n = 10)

```
 [1] "C00434563|N|Q3|P2024|202210149532339641|15E|IND|STEPHENSON, L. A.|TULSA|OK|741371906|NOT EMPLOYED|NOT EMPLOYED|09162022|25|C00401224|1931901|1639092||* EARMARKED CONTRIBUTION: SEE BELOW|4110420221605041955"                           
 [2] "C00434563|N|Q3|P2024|202210149532339663|15E|IND|MERRIAM, CAROLINE|WASHINGTON|DC|200073343|RAMSAY MERRIAM FUND|FOUNDATION PRESIDENT|09162022|10|C00401224|1931891|1639092||* EARMARKED CONTRIBUTION: SEE BELOW|4110420221605042023"       
```

+ Separator appears to be |
+ no column names


```
d = read.table("itcont.txt", sep = "|", header = FALSE)
```
```
Error in scan(file = file, what = what, sep = sep, quote = quote, dec = dec,  : 
  line 127 did not have 21 elements
```

Let's explore
```
f = "itcont.txt"
ll = readLines(f, n = 128)  
ll[127]
```
```
[1] "C00740597|N|Q3|P|202210159533294077|15|IND|GEORGE, RACHEL|ATLANTA|GA|303274646|THE AARON'S COMPANY, INC.|ATTORNEY|09162022|500||7735726|1641974|||4102720221592492379"
```

```
els = strsplit(ll[127], "|")[[1]]
length(els)
```
What ????

```
els = strsplit(ll[127], "|", fixed = TRUE)[[1]]
length(els)
```

So it does have 21 elements.

What should we do next?

-------------

Let's see if it really is line 127.
Let's read up to 126 and see if that worls.



```
d = read.table("itcont.txt", sep = "|", header = FALSE, nrow = 126)
dim(d)
```

That works.
So this does appear to be line 127.

We could also read the lines, exclude line 127 and  pass these to read.table

```
ll = readLines(f, n = 130)[-127]
d = read.table(textConnection(ll), sep = "|", header = FALSE)
dim(d)
```
That works too.


So what is it about line 127 ?
+ The empty cells?
+ sequence of consecutive empty cells

Helps to look at other lines
```r
ll[125:129]
```
```
[1] "C00740597|N|Q3|P|202210159533293868|15E|IND|OSBORNE, POLLY|LOS ANGELES|CA|900642011|NOT EMPLOYED|NOT EMPLOYED|09162022|33|C00401224|7773913|1641974||* EARMARKED CONTRIBUTION: SEE BELOW|4102720221592491752"
[2] "C00740597|N|Q3|P|202210159533293656|15|IND|SEYMORE, ALEKSANDER|MENLO PARK|CA|940256266|LEARN TO WIN|EXECUTIVE|09162022|250||7735800|1641974|||4102720221592491116"                                           
[3] "C00740597|N|Q3|P|202210159533294215|15|IND|SMITH, SARAH|MENLO PARK|CA|940255865|SARAH SMITH FUND|INVESTOR|09162022|1000||7735728|1641974|||4102720221592492792"                                              
[4] "C00740597|N|Q3|P|202210159533294137|15E|IND|STEPHAN, ALLAN H.|SEATTLE|WA|981092212|SOOVU|CEO|09162022|2000|C00401224|7773907|1641974||* EARMARKED CONTRIBUTION: SEE BELOW|4102720221592492559"               
[5] "C00740597|N|Q3|P|202210159533293742|15|IND|HODGES, BILL|JACKSONVILLE|FL|322057962|NOT EMPLOYED|RETIRED|09162022|250||7735731|1641974|||4102720221592491374"                                                  
```
These have empty cells and and consecutive empty cells.


--------------

The issue is the ' in the "THE AARON'S COMPANY, INC."
This is the start of a string.  read.table() is looking for the end of that across multiple lines.

Where does it end?
Let's read 10,000 lines of the file and look for a ' past line 127.

ll = readLines(f, n = 10000)
i = grep("'", ll)

The first ' occurs on 127.
The second is on line 227.

read.table

els = strsplit(ll[i[1:2]], "|", fixed = TRUE)


[[1]]
 [1] "C00740597"                 "N"                        
 [3] "Q3"                        "P"                        
 [5] "202210159533294077"        "15"                       
 [7] "IND"                       "GEORGE, RACHEL"           
 [9] "ATLANTA"                   "GA"                       
[11] "303274646"                 "THE AARON'S COMPANY, INC."
[13] "ATTORNEY"                  "09162022"                 
[15] "500"                       ""                         
[17] "7735726"                   "1641974"                  
[19] ""                          ""                         
[21] "4102720221592492379"      

[[2]]
 [1] "C00492157"                           
 [2] "A"                                   
 [3] "Q3"                                  
 [4] "P"                                   
 [5] "202212089550417125"                  
 [6] "15"                                  
 [7] "IND"                                 
 [8] "BOWIE, JOHN"                         
 [9] "ATLANTA"                             
[10] "GA"                                  
[11] "303283584"                           
[12] "INSPIRE BRANDS, INC."                
[13] "BRAND CHIEF OPERATING OFFICER ARBY'S"
[14] "09162022"                            
[15] "100"                                 
[16] ""                                    
[17] "A816CA895A3C5444296E"                
[18] "1670787"                             
[19] ""                                    
[20] ""                                    
[21] "4011420231698210863"                 


On line 127, the ' occurs in column 12
On line 128, the ' occurs in column 13

So read.table reads 12 columns on line 127 ending at the 13 column on line 128.
That leaves columns 14 through 21 to complete line 127 and that gives 20 entries.


Let's see what happens if we use fill = TRUE

d = read.table(f, sep = "|", nrow = 127, header = FALSE, fill = TRUE)

d[127, ]

This shows an NA in the last/21st cell.  
The 20th value is "4011420231698210863" which is the 21st cell of line 128.


And the 12th value is 19205 characters containing many | characters.
This the contents of the remainder of line 127 up to the 13th cell in line 227.

If the ' had occurred in the 13th column of line 127, there would not have been
an error as consuming all the lines between 127 and 227 would have given  a single record
with 21 elements. So we have to be careful even when there is no error.

---------


What are the arguments/parameters we can specify to read.table()?

See the help file or 

names(formals(read.table))
 [1] "file"             "header"           "sep"             
 [4] "quote"            "dec"              "numerals"        
 [7] "row.names"        "col.names"        "as.is"           
[10] "tryLogical"       "na.strings"       "colClasses"      
[13] "nrows"            "skip"             "check.names"     
[16] "fill"             "strip.white"      "blank.lines.skip"
[19] "comment.char"     "allowEscapes"     "flush"           
[22] "stringsAsFactors" "fileEncoding"     "encoding"        
[25] "text"             "skipNul"         


The default value of quote is "\\"'"
Let's set this to '"' or the empty string


d = read.table(f, sep = "|", nrow = 227, header = FALSE,  quote = '')
d[127,]
d[227,]


We should check other values.


--------------------------

So now we can read the whole file.


d = read.table(f, sep = "|", header = FALSE,  quote = '')

Error in scan(file = file, what = what, sep = sep, quote = quote, dec = dec,  : 
  line 15580 did not have 21 elements


ll = readLines(f, n = 15582)
ll[15580]

[1] "C00633404|N|Q3|P|202210149532307881|15E|IND|SAKHO, ABDOULAYE|BRONX|NY|104664376|COMMODORE|LABORER LOCAL #79 NEW YORK CITY|09162022|15|C00401224|13563893|1638779||* EARMARKED CONTRIBUTION: SEE BELOW|4110820221616496427"


What's the problem with this line


----------------------

names(formals(read.table))

 [1] "file"             "header"           "sep"             
 [4] "quote"            "dec"              "numerals"        
 [7] "row.names"        "col.names"        "as.is"           
[10] "tryLogical"       "na.strings"       "colClasses"      
[13] "nrows"            "skip"             "check.names"     
[16] "fill"             "strip.white"      "blank.lines.skip"
[19] "comment.char"     "allowEscapes"     "flush"           
[22] "stringsAsFactors" "fileEncoding"     "encoding"        
[25] "text"             "skipNul"         








-------------------------


formals(read.table)$comment.char
"#"


d = read.table(f, sep = "|", header = FALSE,  quote = '', comment.char = '')
nrow(d)

26 minutes.
9.33 minutes with read.table::fread() and it automatically corrected quoting.
Converting it to a data.frame() with the regular semantics takes 4 seconds.

Each package/function makes its own assumptions and has its own limitations.
fread() works well here.
It can't handle connections which we will need in another case study.


<!-- (Is this because the connection API is not public?) -->



----------
Remember we can still get the wrong result even if there are no errors or warnings.


Check if any unexpected problems

Want to compare the number of rows in the data.frame to the number of lines in the file.

How to compute the number of lines in the file.

length(readLines(f))

out = system2("wc", c("-l", f), stdout = TRUE)
numLines.file = as.integer(strsplit(out, " ")[[1]][1])

62,260,592



sapply(d, class)
         V1          V2          V3          V4          V5 
"character" "character" "character" "character"   "numeric" 
         V6          V7          V8          V9         V10 
"character" "character" "character" "character" "character" 
        V11         V12         V13         V14         V15 
"character" "character" "character"   "integer"   "integer" 
        V16         V17         V18         V19         V20 
"character" "character"   "integer" "character" "character" 
        V21 
  "numeric" 
  
  
sapply(d, function(x) sum(is.na(x)))
   V1    V2    V3    V4    V5    V6    V7    V8    V9   V10   V11 
    0     0     0     0     0     0     0     0    79    13     0 
  V12   V13   V14   V15   V16   V17   V18   V19   V20   V21 
16783  1957     3     0     0     0     0     0     0     0 




which(is.na(d$V9))
 [1]   390756  1964228  2397234  5628472  7136831  9921174 11186282
 [8] 11240260 11813889 13139319 14417804 14419540 14419541 17760643
[15] 19877408 21308107 21310069 21310495 23036067 29588328 29673560
[22] 29915127 30026206 30130262 30519886 30608063 30698214 30698215
[29] 30815555 31298092 32146278 32371453 33896784 34391426 34391427
[36] 34391428 34391429 34391430 34391431 34391432 34391433 36179406
[43] 36197672 36197919 36197920 37464127 38919094 39021117 39132678
[50] 39132682 39317453 43341562 47526101 48433236 49929093 49929499
[57] 49929512 49929518 49929601 49929670 49930005 49930006 49930063
[64] 49930188 49936342 49936490 49936652 49936901 49952470 52288776
[71] 52802515 53104255 53944783 54500948 56851827 58110531 58345483
[78] 58905560 59461609

ll = readLines(f, n = 400000)
ll[390756]
[1] "C00010603|N|M10|G2022|202210209541425954|15E|IND|ARMSTRONG, MARGO|NA|PA|00000|RETIRED|RETIRED|09182022|25|C00401224|58496674|1646050||* EARMARKED CONTRIBUTION:SEE BELOW|4102720221592434728"

strsplit(ll[390756], "|", fixed = TRUE)[[1]][[9]]

"NA"

So converting the string "NA" to NA.


Controlled by na.strings parameter of read.table.
Probably should be ""




-----------

Names of the columns

u = "https://www.fec.gov/files/bulk-downloads/data_dictionaries/indiv_header_file.csv"

h = read.csv(u, header = FALSE)
names(d) = h[1,]

names(d) = as.character(h[1,])



h = strsplit(readLines(u), ",")[[1]]
names(d) = h


---------

Transform the columns 


TRANSACTION_DT is a Date


head(d$TRANSACTION_DT)

[1] 9162022 9162022 9162022 9162022 9162022 9162022




table(nchar(d$TRANSACTION_DT))

Too long


tmp = as.character(d$TRANSACTION_DT[1:10000])

as.Date(tmp[1], "%m%d%Y")

NA

as.Date(paste0(0, tmp[1]), "%m%d%Y")

Okay.


Can't prepend 0 to all values if starts with 10, 11, 12.

table(nchar(tmp))
 
All values have 7 characters. Are there any with 8?

+ Any with 6, e.g., 112022 for January 1, 2022.
+ Does the day of the month always have 2 digits, even if 1 to 9?


10, 11 and 12 may be near the end??


Let's sample

tmp = as.character(sample(d$TRANSACTION_DT, 100000))

w = nchar(tmp) == 7
tmp[w] = paste0(0, tmp[w])


z  = as.Date(tmp, "%m%d%Y")
table(is.na(z))

range(z)


plot(density(z))

plot(density(as.numeric(z)))


abline(v = as.numeric(as.Date("2020/1/1", "2021/1/1", "2022/1/1")), col = "red")

Nothing appears

abline(v = as.numeric(as.Date("2020/1/1", "2021/1/1", "2022/1/1", "%Y/%d/%m")), col = "red")

Again, nothing appears


Check the values

as.numeric(as.Date("2020/1/1", "2021/1/1", "2022/1/1", "%Y/%d/%m"))

NA

Something wrong


as.numeric(as.Date(c("2020/1/1", "2021/1/1", "2022/1/1"), "%Y/%d/%m"))

Now we can omit the format string


as.numeric(as.Date(c("2020/1/1", "2021/1/1", "2022/1/1")))


Now draw the lines


abline(v = as.numeric(as.Date(c("2020/1/1", "2021/1/1", "2022/1/1"))), col = "red")

rug(z)


------


TRANSACTION_PGI

format is TypeYEAR

Type is a single character


set.seed(123456)

d3 = d[sample(nrow(d), 100000), ]





