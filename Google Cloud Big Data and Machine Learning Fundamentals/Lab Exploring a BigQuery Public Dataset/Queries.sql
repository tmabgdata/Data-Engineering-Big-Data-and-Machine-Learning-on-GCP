/* Queries used in the lab: */


/* Query 'bigquery-public-data.usa_names.usa_1910_2013' for the name and gender of the babies in this dataset, then list the top 10 names in descending order. */

SELECT
  name, gender,
  SUM(number) AS total
FROM
  bigquery-public-data.usa_names.usa_1910_2013
GROUP BY
  name, gender
ORDER BY
  total DESC
LIMIT
  10
  
/* This query retrieves the top 5 baby names for US males in 2014. */

SELECT
 name, count
FROM
 babynames.names_2014
WHERE
 gender = 'M'
ORDER BY count DESC LIMIT 5

/* Schema definition fo the table */

-- name:string,gender:string,count:integer