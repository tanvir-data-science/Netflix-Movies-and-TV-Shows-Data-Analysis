DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    movie_types  VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    movie_description  VARCHAR(550)
);


SELECT * FROM netflix;

SELECT COUNT(*) as total FROM netflix;

SELECT DISTINCT movie_types FROM netflix;

-- 15 Business Problems & Solutions

-- 1. Count the number of Movies vs TV Shows

 SELECT 
 movie_types,
 COUNT(*) AS total_content
 FROM netflix
 GROUP BY movie_types;

-- 2. Find the most common rating for movies and TV shows

SELECT 
	movie_types,
	rating
from(
	select
		movie_types,
		rating,
		count(*),
		rank() over(partition by movie_types order by count(*) DESC) as ranking
	from netflix
	group by movie_types, rating
	) as t1
WHERE ranking = 1;

3. List all movies released in a specific year (e.g., 2020)

select * from netflix
where
	movie_types = 'Movie'
	and
	release_year = 2020;

4. Find the top 5 countries with the most content on Netflix

select 
	unnest(string_to_array(country, ',')) as new_country,
	count(show_id) as total_content
from netflix
group by country
order by total_content desc
limit 5;

-- 5. Identify the longest movie

SELECT 
    *
FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;

-- 6. Find content added in the last 5 years

SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select *
from netflix
where director Ilike '%Rajiv Chilaka%';

	/*SELECT *
	FROM (
	    SELECT 
	        *,
	        UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
	    FROM netflix
	) AS t
	WHERE director_name = 'Rajiv Chilaka'; */

-- 8. List All TV Shows with More Than 5 Seasons

select *
from netflix
where movie_types = 'TV Show'
and split_part(duration, ' ', 1):: numeric > 5

-- 9. Count the Number of Content Items in Each Genre

select 
unnest(string_to_array(listed_in, ',')) as genre,
count(show_id) as total_content
from netflix
group by genre;

-- 10.Find the each year of content released in India on netflix.

SELECT 
    EXTRACT(YEAR FROM 
        CASE 
            -- Format: 'DD-Mon-YY' (e.g., '22-Jul-21')
            WHEN date_added ~ '^[0-9]{1,2}-[A-Za-z]{3}-[0-9]{2}$' 
            THEN to_date(date_added, 'DD-Mon-YY')

            -- Format: 'Month DD, YYYY' (e.g., 'June 1, 2017')
            WHEN date_added ~ '^[A-Za-z]+ [0-9]{1,2}, [0-9]{4}$' 
            THEN to_date(date_added, 'Month DD, YYYY')

            ELSE NULL  -- Handles unexpected formats
        END
    ) AS extracted_year,
	count(*)
FROM netflix
WHERE country = 'India'
GROUP BY 1;

-- 11. List All Movies that are Documentaries

select * 
from netflix
where listed_in Ilike '%Documentaries%';

-- 12. Find All Content Without a Director

select * from netflix
where director is null;

-- 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

select * from netflix
where casts like '%Salman Khan%'
and
release_year > extract(year from current_date)-10;

-- 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

select 
unnest(string_to_array(casts, ',')) as actors,
count(*)
from netflix
where country = 'India'
group by actors
order by count desc
limit 10;

-- 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords. 
--Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. 
--Count the number of items in each category.

with new_table
as
(select 
movie_description, 
    case 
	when movie_description ilike '%kill%' or
	movie_description ilike '%violence%' then 'bad film'
	else 'good film'
	end category
from netflix
)
select category,
count (*) as total_content
from new_table
group by category;



