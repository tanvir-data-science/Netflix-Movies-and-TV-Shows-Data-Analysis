# Netflix SQL Data Analysis 📊🎬

<img src="https://github.com/tanvirfau/netflix_sql_project/blob/main/netflix_logo.jpg" alt="Netflix Logo" width="1200" height="400">
<img src="https://"https://github.com/tanvirfau/Netflix-Audience-Data-Analysis-Using-SQL/blob/main/Netflix%20Movies%20and%20TV%20Shows%20Dashboard.png" alt="Netflix Logo" width="1200" height="400">


<P>In this project, I analyzed Netflix's vast content database using SQL, solving 15 key business problems related to content distribution, viewer preferences, and platform trends. By leveraging SQL queries, I extracted valuable insights to understand how Netflix structures its content.</P>

# 📊 Business Problems & SQL Solutions

### 1️⃣ Count the number of Movies vs TV Shows
```sql
SELECT 
    movie_types,
    COUNT(*) AS total_content
FROM netflix
GROUP BY movie_types;
```
### 2️⃣ Find the most common rating for Movies and TV Shows
```sql
SELECT 
    movie_types,
    rating
FROM (
    SELECT
        movie_types,
        rating,
        COUNT(*) AS count,
        RANK() OVER (PARTITION BY movie_types ORDER BY COUNT(*) DESC) AS ranking
    FROM netflix
    GROUP BY movie_types, rating
) AS t1
WHERE ranking = 1;
```
### 3️⃣ List all movies released in a specific year (e.g., 2020)
```sql
SELECT * 
FROM netflix
WHERE movie_types = 'Movie'
AND release_year = 2020;
```
### 4️⃣ Find the top 5 countries with the most content on Netflix
```sql
SELECT 
    UNNEST(string_to_array(country, ',')) AS new_country,
    COUNT(show_id) AS total_content
FROM netflix
GROUP BY new_country
ORDER BY total_content DESC
LIMIT 5;
```
### 5️⃣ Identify the longest movie on Netflix
```sql
SELECT * 
FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC
LIMIT 1;
```
###6️⃣ Find content added in the last 5 years
```sql
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```
### 7️⃣ Find all the Movies/TV Shows by director 'Rajiv Chilaka'
```sql
SELECT *
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';
```
## 🔍 Key Insights & Findings:

✔ Movies vs TV Shows: Analyzed the distribution of content formats.

✔ Most Common Ratings: Identified popular content classifications.

✔ Top 5 Content-Rich Countries: Explored Netflix’s global presence.

✔ Longest Movie: Found the film with the highest runtime.

✔ Recent Additions: Tracked content added in the last 5 years.

✔ Popular Directors & Actors: Filtered works of Rajiv Chilaka & Salman Khan.

✔ Genre Distribution: Categorized content based on themes.

✔ Content Trends in India: Ranked years with the highest average content release.

✔ Violence & Keyword-Based Categorization: Classified content as Good or Bad based on descriptions.

## 📌 Business Recommendations:


## To optimize user engagement, Netflix can:

📢 Prioritize content production in top-performing regions.

🎯 Enhance recommendations by tracking content trends over time.

🛑 Monitor potentially sensitive content classifications.

This project demonstrates the power of SQL in data-driven decision-making for streaming platforms. 🚀

📌 [Check out the detailed queries and findings in the repository!](https://github.com/tanvirfau/netflix_sql_project):

