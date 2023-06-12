# STA141B UC Davis
## Spring 2023 
## Instructor:Duncan Temple Lang


## Day 1 (4/4)

+ Slides - [Full Pages](Lectures/Day1/Day1_fullpage.pdf), [4-per page](Lectures/Day1/Day1.pdf)

+ Federal Election Commission (FEC) data
   + [https://www.fec.gov/data/browse-data/?tab=bulk-data](https://www.fec.gov/data/browse-data/?tab=bulk-data).
   + "Contributions by individuals" panel
   + zip file
   + itcont.txt
   + [Data/FEC/itcont100K.txt](Data/FEC/itcont100K.txt)  - smaller version - 100,000 lines 

+ 

## Day 2 (4/6)
+ [Exploring reading the FEC Data](Lectures/Day2/Explore.md)
+ [R Session]((Lectures/Day2/Rsession2)


## Day 3 (4/11)
+ [R Session](Lectures/Day3/Rsession_Day3)
+ Code in [Data/NCBI](Data/NCBI)
+ [Strategy](Data/NCBI/README.md)
+ Different versions of functions
   + test.R - run the functions
   + funs0.R, funs1.R, funs2.R
   + funs3.R - problems/bugs
   + funs4.R - improvements on funs3.R
+ [Debugging funs3.R](Data/NCBI/Debugging.md)


## Day 4 (4/13)

+ [Day 4 R Session](Lectures/Day4/Rsession_4)

+ [bob.R](Lectures/Day4/bob.R)
  + The functions we wrote.
  + Also see funs3.R and funs4.R from Day3 (above)

## Day 5 (4/18)

+ [Day 5 R Session](Lectures/Day5/Ression5)
  + See [Debugging funs3.R](Data/NCBI/Debugging.md) for the narrative of this debugging session.


## Day 6 (4/20)

+ [slides on regular expressions](Lectures/Day6/slides.html)
+ [R session Day 6](Lectures/Day6/Rsession6)
   + [R commands from session Day 6](Lectures/Day6/Rcommands)

## Day 7 (4/25)

+ [Recap of Regular Expression Language](Lectures/Day7/Reminder.md)
+ [Case studies](Lectures/Day7/regularExpressionExamples.md)
+ [Web log case study](Data/Weblogs/strategy.pdf)
+ [getCaptures() function](Data/Weblogs/getCaptures.R)


## Day 8 (Thu 4/27)

+ [Day 8 R Session](Lectures/Day8/Rsession8)
   + reading the web logs
     + using read.table() and fixing the results
	 + start of reading via regular expressions and capture groups as described in 
       the [Web log case study](Data/Weblogs/strategy.pdf).

+ [code for read.table() and cleanup approach ](Data/Weblogs/readTableApproach.R)
+ [code for regular expression & getCaptures() approach ](Data/Weblogs/regexApproach.R)


## Day 9 (Tue 5/2)

+ [Day 9 R Session](Lectures/Day9/Rsession9)
   + reading the web logs
      + regular expressions and capture groups
	  + Variation of the approach in [Web log case study](Data/Weblogs/strategy.pdf).
	    + specifically, getting the GET, file path and HTTP version  at the same time as all of the
          other columns/capture groups.
   + [Some code to get the data as data.frame and cleanup the variables](Lectures/Day9/Start)


## Day 10 (Thu 5/4)
+ [Day 10 Databases and SQL](Lectures/Day10/SQLiteSession)
  + [slides on relational databases, SQL](Lectures/Day10/dbms.html)
  
  
## Day 11 (Tue 5/9)
+ [slides 1](Lectures/Day10/dbms.html)  
+ [slides 2](Lectures/Day10/dbms2.html)    
+ [FANG example database](Lectures/Day10/fang.sqlite)      
+ [Day 11 Databases and SQL](Lectures/Day11/Session11)  

## Day 12 (Thu 5/11)
+ [Joins on Tables](Lectures/Day10/joins.html)  
+ [baseball database](https://ucdavis.app.box.com/folder/206515800849?s=ftwawz3ai28er9ds9zfka1rktwl9eylm)
+ [Baseball Case Studies](Lectures/Day10/baseball.html)  
+ [Day 12 SQL Session](Lectures/Day12/SQL_Session12)  

## Day 13 (Tue 5/16)
+ [Day 13 SQL Session](Lectures/Day13/Day13SQLSession)  
+ [SQL Code for Self Join](Lectures/Day13/SelfJoingPosts.sql)
+ [Example of Self Join to Compute Time/Year Difference](Lectures/Day13/SelfJoin_TimeDuration.md)
+ [Example of using SUM() to count the number of tuples in a particular category/logical condition](Lectures/Day13/CountingNumberInDifferentCategories_SingleTupleAnswer.md)
+ [Exploring, Debugging SQL and Joins](Lectures/Day13/HallOfFame_Colleges.md)


## Day 14 (Thu 5/18)
+ [Web Scraping Introduction slides](Lectures/Day14/slides.html)
+ [R Session](Lectures/Day14/RSession_HTMLTable)
    + Reading HTML Table - [Wikipedia's USA state populations](https://en.wikipedia.org/wiki/List_of_U.S._states_and_territories_by_population)


## Day 15 (Thu 5/23)

github.com/search via HTML

+ [R Session](Lectures/Day15/Day15RSession)
+ [Firefox Developer Tools](https://firefox-source-docs.mozilla.org/devtools-user/network_monitor/request_details/index.html)
+ [Initial code to scrape github.com/search](Lectures/Day15/ghFuns.R)
+ [Brief notes on XPath](Lectures/Day15/XPath.html)


## Day 16 (Thu 5/25)

github.com/search via HTML

+ [R Session](Lectures/Day16/Day16RSession)
+ [Functions to scrape github.com/search](Lectures/Day15/ghFuns.R)
   + general approach code scraping search results and processing pages of results
   + ` results = ghSearch("R URL decode")`
+ [XPath Axes](https://www.w3schools.com/xml/xpath_axes.asp)



## github.com/search

+ [Description of ghFuns.R and the steps involved](Lectures/Day15/GithubSearch.md)

## Day 17 Tue 5/30

+ [Notes and code from class](Lectures/Day17/README.md)
+ [JSON version of github searc ghFuns.R](Lectures/Day17/ghJSON.R)
+ [R Session](Lectures/Day17/RSession)

## Day 18 Thu 6/1

+ Call graphs for StackOverflow functions
  + [Search page results only](Lectures/Day18/SOCallGraphSearchResults.png)
  + [Question/Answer pages only](Lectures/Day18/SOCallGraphQA.png)

+ Writing functions 
  + [General guidelines and principles](Lectures/Day18/README.md)
  + email messages
    + [outline of implementations](Lectures/Day18/email.md)
    + [R functions](Lectures/Day18/email.R)
    + Data/examples
       + [Individual email with body and attachment](Lectures/Day18/Example of email with attachment.eml)
   	   + [Multiple emails in single file, no attachments](Lectures/Day18/2023-May.txt)


# Day 19 Tue 6/6

+ [slides](Lectures/Day19/Outline.html)
+ R essentials
   + Vectors and lists
   + apply() functions
   + subsetting
   + preallocation/not concatenating
+ Run times for URLdecode implementations
  + [run time for utils::URLdecode() - quadratic function.](utilsURLDecodeCompTimeFit2.png)
  + [Extrapolation to 600K](utilsURLdecodeCompTimeFitExtrapolation.png)
  + [run times for original, preallocated and vectorized versions](Runtimes2.png)
  + [run times for preallocated and vectorized versions only](Runtimes3.png) for more detail.
  + Note, these were run on a slow, debugging version of R (compiled was not optimized.)
+ Avoding redundant computations
  + [riverdist package](https://github.com/mbtyers/riverdist) and the whoconnected() function.
  + See [slides](Lectures/Day19/Outline.html)
+ Start of riverdist package and removemicrosegs() function
   and removing for(jj ...)  for(jjj ...) nested loops.
    + See [slides](Lectures/Day19/Outline.html)
    + and [slides](Lectures/Day20/slides.html)	

# Day 20 Thu 6/8
+ riverdist package and removemicrosegs() function
   + remove for(jj ...)  for(jjj ...) nested loops.
+ [slides on vectorization](Lectures/Day20/slides.html)
+ [Example of combining pairs of words](Lectures/Day20/orderedWords.R) in data.frame based on 
  alphabetical order
    + [sample words in RDS files](Lectures/Day20/words.rds)
+ [Vectorized creation of sample words](Lectures/Day20/)
+ Organizing Markdown 
   + example of doing timing computations in a [script](Lectures/Day20/runScript.R)
     and saving the timing results to  file and
	 then reading these in the Rmarkdown document
	 in order to plot them, etc.
   + and having the functions in a separate file, e.g., URLdecodeFuns.R 
     and using `source()` in the Rmarkdown  to read and define the functins.
   + the [Rmarkdown example](Lectures/Day20/markdown.Rmd)
