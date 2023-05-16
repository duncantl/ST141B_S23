
### Which Schools have produced the most number of players in the hall of fame.

+ Map HallOfFame to SchoolsPlayers to Schools.
+ Do we need Master table?

```sql
SELECT h.yearid, h.category, s.schoolName, schoolCity, schoolState 
FROM HallOfFame AS h, 
	 SchoolsPlayers as sp,
	 Schools AS s
WHERE 
      h.playerID = sp.playerID
  AND sp.schoolID = s.schoolID 
LIMIT 20;  
```

Need to see the playerID

```sql
SELECT h.playerID, h.yearid, h.category, s.schoolName, schoolCity, schoolState 
FROM HallOfFame AS h, 
	 SchoolsPlayers as sp,
	 Schools AS s
WHERE 
      h.playerID = sp.playerID
  AND sp.schoolID = s.schoolID 
LIMIT 20;  
```
We have repeats, e.g., for ansonca01

```sql
SELECT * FROM HallOfFame WHERE playerID = 'ansonca01';
```

Note the inducted = Y/N.
We need the Y.


+ Add h.inducted = 'Y'

```sql
SELECT h.playerID, h.yearid, h.category, s.schoolName, schoolCity, schoolState 
FROM HallOfFame AS h, 
	 SchoolsPlayers as sp,
	 Schools AS s
WHERE 
      h.inducted = 'Y'
  AND h.playerID = sp.playerID
  AND sp.schoolID = s.schoolID 
LIMIT 20;  
```

Check there is only one tuple for each playerID

```sql
SELECT COUNT(*) AS num, h.playerID, h.yearid, h.category, s.schoolName, schoolCity, schoolState 
FROM HallOfFame AS h, 
	 SchoolsPlayers as sp,
	 Schools AS s
WHERE 
      h.inducted = 'Y'
  AND h.playerID = sp.playerID
  AND sp.schoolID = s.schoolID 
GROUP BY h.playerID
HAVING num > 1;
```

So there is one with 2 tuples.
```
2    ansonca01  1939    Player    University of Iowa  Iowa City   IA         
```

Let's see the entire cartesian product of tuples for this one playerID

```sql
SELECT h.playerID, h.yearid, h.category, s.schoolName, schoolCity, schoolState 
FROM HallOfFame AS h, 
	 SchoolsPlayers as sp,
	 Schools AS s
WHERE 
      h.inducted = 'Y'
  AND h.playerID = sp.playerID
  AND sp.schoolID = s.schoolID 
  AND h.playerID = 'ansonca01';
```
```
playerID   yearid  category  schoolName                schoolCity  schoolState
---------  ------  --------  ------------------------  ----------  -----------
ansonca01  1939    Player    University of Iowa        Iowa City   IA         
ansonca01  1939    Player    University of Notre Dame  South Bend  IN
```
This person was in two schools/universities.


How many people had more than one school
```sql
SELECT COUNT(schoolID) AS num, playerID
FROM SchoolsPlayers
GROUP BY schoolID
HAVING num > 1;
```
+ There are 520 such people.
   + But not all are in the Hall of Fame.    
   + CHECK!


We'll leave these two tuples and count the person towards both schools.
It appears the year is the same for both so would be hard to separate.
However, this is the wrong year - it is the Hall of Fame year. We need to look at yearMin, yearMax
in SchoolsPlayers.

(ASIDE:  How would we find the last school a person attended ?

<!--
SELECT *,  MAX(a.yearMax) - a.yearMax
FROM SchoolsPlayers AS a
GROUP BY playerID;
-->
)



Want the player first and last name.
Note that the team the person played for may not be unique as they may have played for many teams.

(ASIDE:  How do we find the most recent team?)


```sql
SELECT h.playerID, h.yearid, h.category, s.schoolName, schoolCity, schoolState, m.nameFirst, m.nameLast 
FROM HallOfFame AS h, 
	 SchoolsPlayers as sp,
	 Schools AS s,
	 Master AS m
WHERE 
      h.inducted = 'Y'
  AND h.playerID = sp.playerID
  AND sp.schoolID = s.schoolID 
  AND m.playerID = h.playerID;
```

Check this seems correct.
+ ansonca01 has 2 tuples
+ no other play has more than 1 tuple.



Now we can count the number of players for each school
```sql
SELECT COUNT(s.schoolID) AS num, h.playerID, h.yearid, h.category, s.schoolName, schoolCity, schoolState, m.nameFirst, m.nameLast 
FROM HallOfFame AS h, 
	 SchoolsPlayers as sp,
	 Schools AS s,
	 Master AS m
WHERE 
      h.inducted = 'Y'
  AND h.playerID = sp.playerID
  AND sp.schoolID = s.schoolID 
  AND m.playerID = h.playerID
GROUP BY s.schoolID
ORDER BY num DESC;
```

We should take out the name of the player, etc.
that are not relevant to the school count:
```sql
SELECT COUNT(s.schoolID) AS num, s.schoolName, schoolCity, schoolState
FROM HallOfFame AS h, 
	 SchoolsPlayers as sp,
	 Schools AS s,
	 Master AS m
WHERE 
      h.inducted = 'Y'
  AND h.playerID = sp.playerID
  AND sp.schoolID = s.schoolID 
  AND m.playerID = h.playerID
GROUP BY s.schoolID
ORDER BY num DESC;
```

+ Why so few - only 55
```sql
SELECT SUM(num) FROM (
  subquery above
)
```

+ Remove the Master table as no longer needed.

```
SELECT COUNT(s.schoolID) AS num, s.schoolName, schoolCity, schoolState
FROM HallOfFame AS h, 
	 SchoolsPlayers as sp,
	 Schools AS s
WHERE 
      h.inducted = 'Y'
  AND h.playerID = sp.playerID
  AND sp.schoolID = s.schoolID 
GROUP BY s.schoolID
ORDER BY num DESC;
```


+ How many people in the HallOfFame
```sql
SELECT COUNT(*) 
FROM HallOfFame
WHERE inducted = 'Y';
```
   + 306

+ Connect these to the school, but with a LEFT JOIN to keep those that
  do not have a corresponding school.
```
SELECT *
FROM HallOfFame AS h
LEFT JOIN SchoolsPlayers  AS s
 ON h.playerID = s.playerID
WHERE h.inducted =  'Y';
```

+ Look at only a few columns of interest to avoid the visual clutter

```sql
SELECT h.playerID, h.yearid, s.schoolID, s.yearMax
FROM HallOfFame AS h
LEFT JOIN SchoolsPlayers  AS s
 ON h.playerID = s.playerID
WHERE h.inducted =  'Y'
ORDER BY s.schoolID;
```

+ Count how many have NULL for the schoolID
```
SELECT COUNT(*)
FROM HallOfFame AS h
LEFT JOIN SchoolsPlayers  AS s
 ON h.playerID = s.playerID
WHERE h.inducted =  'Y' AND s.schoolID IS NULL;
```

+ 252

