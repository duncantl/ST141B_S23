# Self-joining Posts to itself to match tuples for 
#   Question  with Answers for that question

# Need to use date/time functions to convert t1 and t2 to date-time values
# before we can take difference
SELECT  Q.Id, A.Id, Q.PostTypeId, A.PostTypeId, A.CreationDate AS t2, Q.CreationDate AS t1, t2 - t1
FROM Posts AS A, Posts AS Q
WHERE Q.Id = A.ParentId
  AND  Q.Id = 606726;

SELECT  Q.Id, A.Id, Q.PostTypeId, A.PostTypeId, A.CreationDate AS t2, Q.CreationDate AS t1 
FROM Posts AS A, Posts AS Q
WHERE Q.Id = A.ParentId
  AND  Q.Id = 606726;



SELECT  Q.Id, A.Id, Q.PostTypeId, A.PostTypeId, A.CreationDate AS t2, Q.CreationDate AS t1, A.OwnerUserId, u.DisplayName, u.Reputation
FROM Posts AS A, Posts AS Q, Users AS u
WHERE Q.Id = A.ParentId
  AND A.OwnerUserId  = u.Id
  AND  Q.Id = 606726;


COUNT (DISTINCT U.Id)
