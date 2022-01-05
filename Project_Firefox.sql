**** TEST 1****
SELECT DISTINCT *
FROM (SELECT * FROM events
WHERE event_code BETWEEN 1 AND 5 OR event_code BETWEEN 8 AND 11 OR event_code BETWEEN 24 AND 27)
AS T1
LEFT JOIN
(SELECT *
FROM survey
WHERE q1 IS NOT NULL OR q6 IS NOT NULL OR q7 IS NOT NULL OR q8 IS NOT NULL OR q9 IS NOT NULL OR q11 IS NOT NULL OR q12 IS NOT NULL)
AS T2
ON T1.user_id = T2.user_id;

****TEST 2****
SELECT DISTINCT *
FROM (SELECT * FROM events
WHERE event_code BETWEEN 1 AND 5 OR event_code BETWEEN 8 AND 11 OR event_code BETWEEN 24 AND 27)
AS T1
FULL JOIN
(SELECT DISTINCT user_id, q1, q6, q7, q8, q9, q11, q12 FROM survey)
AS T2
ON T1.user_id = T2.user_id;

****TEST 3****
SELECT DISTINCT *
FROM (SELECT * FROM events
WHERE event_code BETWEEN 1 AND 5 OR event_code BETWEEN 8 AND 11 OR event_code BETWEEN 24 AND 27)
AS T1
LEFT JOIN
(SELECT DISTINCT user_id, q1, q6, q7, q8, q9, q11, q12 FROM survey WHERE CAST(q1 AS numeric) BETWEEN 5 AND 6)
AS T2
ON T1.user_id = T2.user_id;
      
****Test 4****
SELECT DISTINCT *
FROM (SELECT * FROM events
WHERE event_code BETWEEN 1 AND 5 OR event_code BETWEEN 8 AND 11 OR event_code BETWEEN 24 AND 27)
AS T1
INNER JOIN
(SELECT DISTINCT user_id, q1 AS num_q1, q6, q7, q8, q9, q11, q12 FROM survey WHERE CAST(q1 AS numeric) BETWEEN 3 AND 6)
AS T2
ON T1.user_id = T2.user_id;

****TEST 5****
SELECT DISTINCT *
FROM (SELECT * FROM events
WHERE event_code BETWEEN 1 AND 5 OR event_code BETWEEN 8 AND 11 OR event_code BETWEEN 24 AND 27)
AS T1
INNER JOIN
(SELECT DISTINCT user_id, q1 AS num_q1, q6, q7, q8, q9, q11, q12 FROM survey WHERE CAST(q1 AS numeric) BETWEEN 3 AND 6)
AS T2
ON T1.user_id = T2.user_id
INNER JOIN
(SELECT id, fx_version, number_extensions FROM users)
AS T3
ON T1.user_id = T3.id;

**QUERY**
select user_id, to_timestamp(timestamp::numeric/1000)
FROM events
ORDER BY timestamp DESC
LIMIT 500;

****TEST 6****

SELECT DISTINCT *
FROM (SELECT *, to_timestamp(timestamp::numeric/1000) FROM events
WHERE event_code BETWEEN 1 AND 5 OR event_code BETWEEN 8 AND 11 OR event_code BETWEEN 24 AND 27)
AS T1
INNER JOIN
(SELECT DISTINCT user_id, q1 AS num_q1, q6, q7, q8, q9, q11, q12 FROM survey WHERE CAST(q1 AS numeric) BETWEEN 3 AND 6)
AS T2
ON T1.user_id = T2.user_id
INNER JOIN
(SELECT id, fx_version, number_extensions FROM users)
AS T3
ON T1.user_id = T3.id;

**QUERY**
SELECT
timestamp as raw,
to_timestamp(timestamp/1000) as converted_to_timestamp,
EXTRACT(year from to_timestamp(timestamp/1000) ) as year_extracted
FROM events
LIMIT 5;

***EVENT ESTIMATE QUERY***
SELECT count(*) AS ct   
     , min(user_id)  AS min_id
     , max(user_id)  AS max_id
     , max(user_id) - min(user_id) AS id_span
FROM events;


***RANDOM USERS ACTIVITY***
SELECT *, timestamp as raw,
to_timestamp(timestamp/1000) as converted_to_timestamp,
EXTRACT(millisecond from to_timestamp(timestamp/1000) ) as millisecond_extracted
FROM events
WHERE user_id = 135;

SELECT *, timestamp as raw,
to_timestamp(timestamp/1000) as converted_to_timestamp,
EXTRACT(millisecond from to_timestamp(timestamp/1000) ) as millisecond_extracted
FROM events
WHERE user_id = 25508;

SELECT *, timestamp as raw,
to_timestamp(timestamp/1000) as converted_to_timestamp,
EXTRACT(millisecond from to_timestamp(timestamp/1000) ) as millisecond_extracted
FROM events
WHERE user_id = 13290;


****TEST 7****
SELECT *
FROM (SELECT DISTINCT *, timestamp as raw,
to_timestamp(timestamp/1000) as converted_to_timestamp,
EXTRACT(year from to_timestamp(timestamp/1000) ) as year_extracted
FROM events
WHERE event_code BETWEEN 1 AND 5 OR event_code BETWEEN 8 AND 11 OR event_code BETWEEN 24 AND 27)
as T1
INNER JOIN
(SELECT user_id, q1 AS q1_num, q6, q7, q8,
	SUBSTRING(q9,1,1) as q9_1st_choice,
	SUBSTRING(q9,3,1) as q9_2nd_choice,
	SUBSTRING(q9,5,1) as q9_3rd_choice, 
	SUBSTRING(q11,1,1) as q11_1st_choice,
	SUBSTRING(q11,3,1) as q11_2nd_choice,
	SUBSTRING(q11,5,1) as q11_3rd_choice,
	SUBSTRING(q12,1,1) as q12_1st_choice,
	SUBSTRING(q12,3,1) as q12_2nd_choice,
	SUBSTRING(q12,5,1) as q12_3rd_choice
FROM survey 
WHERE CAST(q1 as numeric) BETWEEN 3 AND 6)
as T2
ON T1.user_id = T2.user_id
INNER JOIN
(SELECT id, fx_version, number_extensions FROM users)
as T3
ON T1.user_id = T3.id
ORDER BY RANDOM()
LIMIT 5000;