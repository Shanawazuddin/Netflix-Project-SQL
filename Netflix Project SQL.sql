CREATE DATABASE NETFLIX;


USE NETFLIX;


CREATE TABLE NETFLIX (
show_id	VARCHAR(50) not null primary key,
type VARCHAR(50) not null,
title VARCHAR(150) not null,
director VARCHAR(250) not null,
cast VARCHAR(750) not null,
country VARCHAR(150) not null,	
date_added	VARCHAR(150) not null,
release_year year not null,
rating VARCHAR(150) not null,
duration VARCHAR(150) not null,	
listed_in VARCHAR(150) not null,
description VARCHAR(200) not null
);



select * from netflix.netflix;


-- Count the number of Movies vs TV Shows

SELECT 
    type, COUNT(*) AS total_count
FROM
    netflix
GROUP BY type;


-- Find the most common rating for movies and TV shows

SELECT TYPE, RATING FROM
(SELECT 
    TYPE, RATING, COUNT(*) AS COUNT, 
    RANK() OVER(PARTITION BY TYPE ORDER BY COUNT(*) DESC) AS RANKING
FROM
    netflix
GROUP BY TYPE , RATING) AS T1
WHERE RANKING = 1;



-- List all movies released in a specific year (e.g., 2020)

SELECT 
    *
FROM
    NETFLIX
WHERE
    TYPE = 'MOVIE' AND RELEASE_YEAR = 2020;



-- Find the top 5 countries with the most content on Netflix

SELECT country, COUNT(DISTINCT SHOW_ID) AS show_count
FROM (
    SELECT 
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(COUNTRY, ',', n.n), ',', -1)) AS country,
        SHOW_ID
    FROM netflix
    JOIN (SELECT 1 AS n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) n
    ON CHAR_LENGTH(COUNTRY) - CHAR_LENGTH(REPLACE(COUNTRY, ',', '')) >= n.n - 1
) AS countries
GROUP BY country
ORDER BY show_count DESC
LIMIT 5;


-- Identify the longest movie

SELECT TITLE, DURATION
FROM netflix
WHERE type = 'Movie'
ORDER BY CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) DESC;



-- Find content added in the last 5 years

SELECT 
    *
FROM
    netflix
WHERE
    date_added >= CURDATE() - INTERVAL 5 YEAR;
    
    


-- Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT 
    *
FROM
    netflix
WHERE
    FIND_IN_SET('Rajiv Chilaka', director) > 0;



-- List All TV Shows with More Than 5 Seasons

SELECT 
    *
FROM
    netflix
WHERE
    type = 'TV Show'
        AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS SIGNED) > 5;
        
        
        
-- Count the Number of Content Items in Each Genre

SELECT 
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', n.n), ',', -1)) AS genre,
    COUNT(*) AS total_content
FROM netflix
JOIN (SELECT 1 AS n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION 
      SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) AS n
  ON CHAR_LENGTH(listed_in) - CHAR_LENGTH(REPLACE(listed_in, ',', '')) >= n.n - 1
GROUP BY genre
ORDER BY total_content DESC;




-- Find each year and the average numbers of content release in India on netflix.

SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id) / 
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India') * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;



-- List All Movies that are Documentaries

SELECT 
    *
FROM
    netflix
WHERE
    listed_in LIKE '%Documentaries';



-- Find All Content Without a Director

SELECT 
    *
FROM
    netflix
WHERE
    director IS NULL;
    
    
    
-- Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

SELECT 
    *
FROM
    netflix
WHERE
    cast LIKE '%Salman Khan%'
        AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
        
        
-- Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

SELECT 
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(cast, ',', n.n), ',', -1)) AS actor,
    COUNT(*) AS total_appearances
FROM netflix
JOIN (SELECT 1 AS n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION
      SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) AS n
  ON CHAR_LENGTH(cast) - CHAR_LENGTH(REPLACE(cast, ',', '')) >= n.n - 1
WHERE country = 'India'
GROUP BY actor
ORDER BY total_appearances DESC
LIMIT 10;



-- Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;
