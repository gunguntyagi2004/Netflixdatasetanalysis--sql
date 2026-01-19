-- 1. Count the number of Movies vs TV Shows

select type, count(*) as count from netflix_db.netflix_titles
group by type ;

--  Find the most common rating for movies and TV shows

SELECT t1.type, t1.rating, t1.rating_count
FROM (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count,
        RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS rnk
    FROM netflix_db.netflix_titles
    WHERE type IN ('Movie', 'TV Show')
      AND rating IS NOT NULL
    GROUP BY type, rating
) t1
WHERE rnk = 1;

-- 3. List all movies released in a specific year (e.g., 2020)

--  select * from netflix_db.netflix_titles
--  where release_year="2020";
--  
--  -- 4. Find the top 5 countries with the most content on Netflix
--  
--  
--  -- select trim(jt.country) as country , count(*) as content_count
-- --  from netflix_db.netflix_titles as nt
-- --  join json_table(
-- --  CONCAT('["', REPLACE(nt.country, ', ', '","'), '"]'),
-- --     '$[*]' COLUMNS(country VARCHAR(100) PATH '$'))  jt
-- --  where nt.country is not null
-- --  group by country 
-- --  order by count(*) desc
-- --  limit 5;
-- --  
-- 5. Identify the longest movie

select  type,duration from 
netflix_db.netflix_titles 
where type ="Movie"
order by  cast(substring_index(duration,'min',1)  as unsigned) desc
limit 1;


 -- 6. Find content added in the last 10 years
SELECT *
FROM netflix_db.netflix_titles
WHERE date_added is not null
 and STR_TO_DATE(trim(date_added), '%M %d, %Y') >= CURDATE() - INTERVAL 10 YEAR;

--  Find all the movies/TV shows by director 'Rajiv Chilaka'

 SELECT *
FROM netflix_db.netflix_titles
WHERE director IS NOT NULL
  AND FIND_IN_SET('Rajiv Chilaka', director) > 0;


-- 8. List all TV shows with more than 5 seasons

select type , duration from 
netflix_db.netflix_titles
where type="TV Show"
 and duration is not null
and cast(substring_index(duration,'Season',1) as unsigned) >5;

-- 9. Count the number of content items in each genre

select jt.listed_in , count(*) from 
netflix_db.netflix_titles as nt
join json_table(
concat('["',replace(nt.listed_in,',','","'),'"]'),
'$[*]' columns(listed_in varchar(1000) path '$')
) as jt
group by jt.listed_in ;

-- 10. Find each year and the average numbers of content release by India on netflix. 
-- return top 5 year with highest avg content release


select release_year ,
count(*) as avg_content_release from
netflix_db.netflix_titles
where country is not null
and find_in_set("India",country) > 0
group by release_year
ORDER BY avg_content_release DESC
LIMIT 5;

-- 11. List all movies that are documentaries

select *
from 
netflix_db.netflix_titles
where listed_in like "%Documentaries%";

-- 12. Find all content without a director
select * from 
netflix_db.netflix_titles
where director is null
or trim(director)='' ;


-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
select count(*) from 
netflix_db.netflix_titles
where casts is not null
and find_in_set('Salman Khan',casts)>0
and   cast(release_year as unsigned)>= year(CURDATE()) - 10 ;

--  14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
select trim(jt.casts) as actor,
count(*) from
netflix_db.netflix_titles as nt
join json_table(
 concat('["',replace(nt.casts,',','","'),'"]'),
 '$[*]' columns (casts varchar(100) path '$')
) as jt 
where type="Movie"
and find_in_set("India",nt.country)>0
group by actor
order by count(*) desc
limit 10;

-- Question 15:
-- Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.
-- */


select 
case 
when lower(description) like "%kill%"
  or lower(description) like "%violence%"
  then "bad"
  else "good"
end as category_content,
count(*) as total_entries
from netflix_db.netflix_titles
where description is not null
group by category_content;