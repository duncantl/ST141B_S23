+ Which league won more "World Series"

```
SELECT COUNT(*), lgIDwinner 
FROM SeriesPost 
WHERE round = 'WS'  
GROUP BY lgIDwinner;
```


What if we wanted the number wins for AL in one column and NL in another column in a single tuple

```sql
SELECT COUNT(lgIDwinner = 'AL') AS AmericanLeague, COUNT(lgIDwinner  = 'NL') AS NationalLeague
FROM SeriesPost 
WHERE round = 'WS' 
  AND lgIDwinner IN ('AL', 'NL')
GROUP BY lgIDwinner
```
```
63 63
52 52
```
Not what we want.
We have a tuple for each value of lgIDwinner.
And the count is the number of tuples in each group.

We want the SUM of a logical condition, e.g., `lgIDwinner = 'AL'`

```sql
SELECT SUM(lgIDwinner = 'AL') AS AmericanLeague, SUM(lgIDwinner  = 'NL') AS NationalLeague
FROM SeriesPost 
WHERE round = 'WS' 
  AND lgIDwinner IN ('AL', 'NL')
```
There is no GROUP BY.

---------------

+ How many ties were there in the playoffs?
  + in the world series.

```sql
SELECT COUNT(*), lgIDwinner 
FROM SeriesPost 
WHERE round = 'WS' AND ties > 0;
```

+ How many times did World Series (the 7 game series) end in a tie?

```sql
SELECT *
FROM SeriesPost 
WHERE round = 'WS' AND wins = losses;
```


<!--

+ What was the longest run of the AL winning the World Series (i.e., and the NL not winning)
-->
