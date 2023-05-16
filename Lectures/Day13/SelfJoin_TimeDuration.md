+ How long was each player's career (to date), i.e.,
  when did they start and when did they finish, or are they still playing.

We have two approaches below:
+ subquery
+ self-join

We can use the yearID in Salaries as an indicator of when an individual was considered a player,
although we have to check if they were a regular player or a manager. We'll come back to this.
For now, we'll look at  the largest value of yearID and subtract the smallest yearID for each
individual
```sql
SELECT  playerID, MIN(yearID) AS start, MAX(yearID) AS end
FROM Salaries
GROUP BY playerID
LIMIT 20;
```

Now we want to compute the difference so we add a column 
```sql
SELECT  playerID, MIN(yearID) AS start, MAX(yearID) AS end, 
        end - start + 1 AS numYears
FROM Salaries
GROUP BY playerID
LIMIT 20;
```
This gives an error saying end is not a column, presumably in Salaries.

The order of evaluation says we can't do this.

We can use our first query as a subquery and compute the difference on that
```sql
SELECT playerID, end - start + 1 AS numYears, end, start
FROM (
	   SELECT  playerID, MIN(yearID) AS start, MAX(yearID) AS end 
       FROM Salaries
       GROUP BY playerID
	   )
LIMIT 20;
```


Another, possibly better, approach is to self-join Salaries by playerID to have tuples
```
player1-year1 , player1-year1
player1-year1 , player1-year2
player1-year1 , player1-year3
  ...
player1-year2 , player1-year1
player1-year2 , player1-year2
player1-year2 , player1-year3
```
Then we can compute the differences of the yearId for the two tuples
and get the MAX() to count the number of years.

We'll go one step further and only combine tuples where the left one has a yearID greater
than the corresponding right tuple.

```sql
SELECT A.playerID, MAX(A.yearID - B.yearID)
FROM Salaries AS A, Salaries AS B
WHERE A.playerID = B.playerID 
  AND A.yearID > B.yearID
GROUP BY A.playerID
LIMIT 20;
```

This is what we did in class on Tue 5/16 with the Posts table from the Stats.stackexchange table.

