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


