# Writing Functions to Read Email Messages

Write code to read a raw email message.

2 formats
+ 1 message per file
+ multiple messages in a file

We'll (try to) deal with both!

Our data are
+ SpamAssassin - 1 message per file, with attachments
+ [R-help mailing list](https://stat.ethz.ch/pipermail/r-help/2023-May.txt.gz) - multiple messages per file, no attachments.

We could have multiple messages per file AND attachments within each message.

Each message has a header and a body.
The body can be made up of 
+ text
+ attachments

Attachments are identified by 

+ a boundary string
+ a header providing metadata for the header
```
------=_NextPart_cFRm0wxfhQWISt2h0cpKwOo0AA
Content-Type: text/html;
	charset="big5"
Content-Transfer-Encoding: base64

PGEgaHJlZj1odHRwOi8vaGxjLm5vLWlwLm9yZz4NCjxpbWcgc3JjPWh0dHA6Ly9obGMubm8taXAu
b3JnL2NuZ2lmL3lpZGlhbjIuZ2lmIGFsdD1odHRwOi8vaGxjLm5vLWlwLm9yZy9jbmdpZi95aWRp
YW4yLmdpZj4NCjwvYT4NCg0KPGEgaHJlZj1odHRwczovL2JuYm4yMDAwLmRuczJnby5jb20+DQo8
aW1nIHNyYz1odHRwOi8vd3d3MzAuYnJpbmtzdGVyLmNvbS9jbnNwcmluZy9saWtlL2JpZy5naWYg
```

The boundary string separating attachments is provided in the email message's own header
```
Content-Type: multipart/related; type="multipart/alternative"; 
    boundary="----=_NextPart_cFRm0wxfhQWISt2h0cpKwOo0"
```

So we need to process the message's header to be able to find the attachments.


## The Tasks

We break the task into subtasks

+ Read the content
  + Separate the messages
+ Find the header and rest of message
+ Process the header
   + into name-value pairs
   + a character vector, a matrix, a list.
+ Get the attachment boundary string   
+ Read the body
  + Separate the body into
    + attachments
	+ whatever is left


At the end, we want  a list with elements

+ header
+ body
+ attachments

## Create top-level function to read a file and return all the process messages

+ readMessages()
   + takes a file name
   + returns a list of messages or a single message if this is a single message file.
   + allow the caller to specify whether it a single or multi message file
      + but default value is to compute this.
```
readMessages =
function(file, containsMultipleEmails = hasMultipleMessages(file))
{


}
```
Why let the caller specify the containsMultipleEmails?
+ Because they may know.
+ Also, they may be processing thousands of files and know that 
  each contains a single message or multiple messages
  and so can avoid the time determining that.


Also, the hasMultipleMessages() will have to read the file
and examine the contents.
Then readMessages() will have to read it again.
So we want to avoid this.

Also, we may get the contents of the message file directly
from the Web (via an HTTP request), so we may want to pass
the contents to readMessages() not as a file name but as 
a vector of lines.

So we'll define readMessages() as 
```
readMessages =
function(file, text = readLines(file),
         containsMultipleEmails = hasMultipleMessages(text = text))
{


}
```
+ `text` is the content of the file
+ We pass `text` to hasMultipleMessages().
  + We can still write hasMultipleMessages() to accept a file name, but also the contents of the
    file.
	

So we define hasMultipleMessages() as 
```
hasMultipleMessages =
function(file, text = readLines(file))
{

}
```

Let's implement hasMultipleMessages().

In a file that contains multiple messages, 
+ the first line is "From ....."
+ the next message has an empty line and then "From ..."

We might check for this with
```
i = grep("^From ", text)
i[1] == 1 && length(i) > 1 && all( text[ i[-1] - 1] == "")
```
We'll have to verify this code but that can be the initial version of
our hasMultipleMessages() function.


We can test this with
```
hasMultipleMessages("2023-May.txt")
hasMultipleMessages("00217.f56a722e95d0b6ea580f1b4e9e2e013a")
```
The first gives TRUE and the second FALSE which is correct
as we know the format for these.


## Splitting the messages

Now we focus on the body of the `readMessages()` function.

To handle the different formats (single/multiple),
let's split the text into messages if we have multiple messages
and pass each message to a function `processEmailMessage()`.
If there is only one message, we pass the content (`text`) to `processEmailMessage()`.


So our code four `readMessages()` can be 
```
if(containsMultipleEmails) {
   msgs = splitMessages(text)
   lapply(msgs, processEmailMessage)
} else
   processEmailMessage(text)
```
This returns either a list of message objects or a single message object.


We need to implement `splitMessages()`.
It is good that we identified the action and not the implementation and details
and did not inline the code here. This is abstraction.
And there are several ways to split the content into messages so
it is useful to have a named function to do this.
We can then provide different implementations and see which is 
"best" - easiest, fastest, most flexible, ...


### splitMessages()

```
splitMessages =
function(text)
{
	w = grepl("^From ", text)
	# check previous line is blank
	w2 = c(TRUE, text[ which(w)[ -1] - 1 ] == "")
	
	split(text, cumsum(w & w2))
}
```

When we test this with
```
text = readLines("2023-May.txt")
m = splitMessages(text)
```
we get a warning.
```
Warning message:
In w & w2 : longer object length is not a multiple of shorter object length
```

Let's check this.

We use `debug(splitMessages)`
to stop at the start of each call to `splitMessages()`
```r
debug(splitMessages)
m = splitMessages(text)
```

When we step through this and check the length of w and then w2
we see 16931 and 191.
We messed up.


`w` has a TRUE/FALSE value for each line.
`table(w)` shows 191 TRUE values
`w2` has 191 elements.
We wanted `w2` to be a logical vector the same length as w2.
That didn't happen.

So let's rethink.
Let's find which values of `w` are TRUE
and check if the element of text just before each of these
is "":
```
w[ which(w)[-1] ] = text[which(w)[-1]  - 1] == ""
```

So our function
is
```
splitMessages =
function(text)
{
    w = grepl("^From ", text)
    w[ which(w)[-1] ] = text[which(w)[-1]  - 1] == ""
    split(text, cumsum(w))    
}
```
This gives 191 messages.

How do we know if this is correct?

We have to be creative to check the results.
One way is to open the file and go to the end.
Then we can find the start of the last message, the "From "
```
From j@me@5431 @end|ng |rom hotm@||@com  Sun May 28 10:53:21 2023
From: j@me@5431 @end|ng |rom hotm@||@com (james carrigan)
Date: Sun, 28 May 2023 08:53:21 +0000
```
Now, we look at the first lines of the 191st message
`head(m[[191]])`
We see the same content.

This does not verify we have split the messages correctly.
There could be, e.g., 1000 messages and we have put them into 191 but coincidentally matched the last one
correctly.

If we go back to the Web page from which we downloaded the .gz file, 
we can look at the data in other forms, e.g., by [Date](https://stat.ethz.ch/pipermail/r-help/2023-May/date.html)
Note that this pages says 191 messages! Or at least did when I wrote this.
We should have picked a month that was already complete!


Now we move onto processing each individual message.

## Separate the Header and Rest of message

```
splitMessage =
function(lines)
{
	
}
```

We find the first blank line.
That is the end of the header.
The first line is "From " and is not officially part of the regular header which is
`name: value` pairs.

We could again use cumsum() to group before and after the first blank line,
or rather, each blank line. And that means we could find multiple parts
due to blank lines in the body.  So we'll just find the first blank line
and subset the vector of lines into the header and the body:
```
div = which(lines == "")[1]
if(is.na(div))
 stop("no blank line")
 
list(header = lines[1:(div-1)],
     body = lines[ (div+1):length(lines) ])
```

We can "test" this on our messages from `splitMessages()`
```
p = lapply(m, splitMessage)
```
No errors or warnings.

Let's check the length, and the number of elements in each and
the number of lines in the headers and then the bodies.

```
table(sapply(p, length))
```
All have 2.

```
table(sapply(p, function(x) length(x$header)))
```
```
 5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 
30 10 43 39 27 19  7  4  3  2  3  1  1  1  1 
```
This is reasonable, but actually the R-help mailing software makes headers quite short
so 19 is a lot.
Let's look at that one and see if the header is `name: value` pairs
```
i = which.max(sapply(p, function(x) length(x$header)))
p[[i]]$header
```
```
 [1] "From @pencer@gr@ve@ @end|ng |rom e||ect|vede|en@e@org  Wed May 31 21:19:52 2023"
 [2] "From: @pencer@gr@ve@ @end|ng |rom e||ect|vede|en@e@org (Spencer Graves)"        
 [3] "Date: Wed, 31 May 2023 14:19:52 -0500"                                          
 [4] "Subject: [R] plot level, velocity, acceleration with one x axis"                
 [5] "In-Reply-To: <fc519fb7315a4a1f8f4361178a5a5a86@maastrichtuniversity.nl>"        
 [6] "References: <96cad904-56fb-8db5-d909-96ddb037a31a@effectivedefense.org>"        
 [7] " <CAGgJW75z_KExV7ONJ3tNJJaeZF_6A9HH3qx5+sAFNCdw8_yTrw@mail.gmail.com>"          
 [8] " <88be9a8e-86bd-cd5f-0d4b-c871d4987bf3@effectivedefense.org>"                   
 [9] " <CAGgJW77unDi9_HCtrX76HtTNDb8sXDv09guGvVw1qJ+yBuRi5g@mail.gmail.com>"          
[10] " <CAGgJW76M8K49zrv7o1WR6mhQQVZZoOESBU1j5_QVKbb4LvVtcw@mail.gmail.com>"          
[11] " <f6334593-bcfe-3d6e-3195-59ec836fc11f@effectivedefense.org>"                   
[12] " <CAGgJW747qiznEMdBfAL_v35iwQK1EVWZ3J9JN6UcQL=F-VhESA@mail.gmail.com>"          
[13] " <c2df4c1e-319c-b7d4-7576-8233f9bcef0f@effectivedefense.org>"                   
[14] " <CAGgJW77OREAocxEiphZAtJe-xL79+AhgfzH2mn+2-sHNvUxp-g@mail.gmail.com>"          
[15] " <c2885246-ac90-233c-2f37-655f5da9afed@effectivedefense.org>"                   
[16] " <CAGgJW74Hy4qeyWsFoO+BzGjJm0cBf7UZhFz81EtAS0peTcHdnA@mail.gmail.com>"          
[17] " <6c729593-7aeb-030d-c595-e1241d6169d3@effectivedefense.org>"                   
[18] " <fc519fb7315a4a1f8f4361178a5a5a86@maastrichtuniversity.nl>"                    
[19] "Message-ID: <39decd19-d963-8324-bb2e-7d44a33eaf9c@effectivedefense.org>"        
```
This looks reasonable.

What about the body of this message
```
head(p[[i]]$body)
```
```
 [1] ""                                                                                    
 [2] ""                                                                                    
 [3] "On 5/31/23 2:12 PM, Viechtbauer, Wolfgang (NP) wrote:"                               
 [4] "> How about using the same 'mar' for all plots, but adding an outer margin?"         
 [5] "> "                                                                                  
 [6] "> DAX <- EuStockMarkets[, 'DAX']"                                                    
```
That is not part of the header and also seems reasonable.



## Process the Header into a Named Vector/Matrix/....

We define the skeleton of our function as
```
readHeader =
function(msg)
{

}
```

Our goal is to process the header of the msg, `msg$header`.

The function read.dcf() is designed to data in the format of the header,
i.e.
+ name: value lines
+ values that extend beyond one line start with spaces on the next line, e.g.,
```
x: value
  and more
```

But read.dcf() expects to read from a file not the contents already read from a file.
So we use a textConnection()

```
read.dcf(textConnection(p[[i]]$header))
```
This returns a matrix/array with  1 row and 7 columns.
The column names correspond to the different field names.

Reading the help page, we should pass all = TRUE
to keep fields with the same name, i.e., multiple occurrences within the header
of the same field name.

```
read.dcf(textConnection(p[[i]]$header), all = TRUE)
```

We may want omit the first line and add it to the result separately.



## processEmailMessage

```
processEmailMessage =
function(lines)
{
    hb = splitMessage(lines)
    boundary = getAttachmentBoundaryString(hb$header)
    tmp = splitBody(hb$body, boundary)


    list(header = hb$header,
         body = tmp$body,
         attachments = tmp$attachments)
}
```



## Get the Attachment Boundary String

```r
getAttachmentBoundaryString =
function(h)
{
   h[, "Content-Type"]
}
```
