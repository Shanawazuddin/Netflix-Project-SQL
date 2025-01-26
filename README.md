# Netflix Content Analysis Using SQL

![Netflix Logo](https://github.com/user-attachments/assets/a1601c51-35b4-411e-a27f-94a3ff605b46)

## 🎯 Project Overview

This project explores Netflix's extensive content library using **SQL** to uncover patterns, trends, and insights. By querying the data, we analyze genres, ratings, country-specific contributions, and more, enabling deeper insights into Netflix’s content strategy.

---

## 🚀 Objectives
- Compare Movies and TV Shows.
- Analyze content distribution by country.
- Identify common ratings and genres.
- Investigate director contributions and actor appearances.
- Highlight content trends over the years.
- Categorize content using descriptive keywords.

---

## 🛠️ Tools & Technologies
- **Database**: MySQL
- **Language**: SQL
- **Dataset**: Netflix content dataset

---

## 📊 Key Insights
- **Content Distribution**: Netflix hosts more movies than TV shows.
- **Country Contribution**: The United States and India are top content producers.
- **Trending Genres**: Documentaries and international titles are highly popular.
- **Actor Contribution**: Salman Khan leads in appearances in Indian movies.
- **Recent Additions**: A significant amount of content has been added in the last five years.
- **Thematic Analysis**: Content with keywords like "violence" or "kill" can be categorized as "Bad" themes.

---

## 📋 SQL Scripts & Analysis

### 1. **Database & Table Creation**
```sql
CREATE DATABASE NETFLIX;

USE NETFLIX;

CREATE TABLE NETFLIX (
    show_id VARCHAR(50) NOT NULL PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    title VARCHAR(150) NOT NULL,
    director VARCHAR(250) NOT NULL,
    cast VARCHAR(750) NOT NULL,
    country VARCHAR(150) NOT NULL,
    date_added VARCHAR(150) NOT NULL,
    release_year YEAR NOT NULL,
    rating VARCHAR(150) NOT NULL,
    duration VARCHAR(150) NOT NULL,
    listed_in VARCHAR(150) NOT NULL,
    description VARCHAR(200) NOT NULL
);
```

---

### 2. **Basic Queries**
- **Display All Content:**
  ```sql
  SELECT * FROM netflix;
  ```

- **Count Movies vs TV Shows:**
  ```sql
  SELECT type, COUNT(*) AS total_count
  FROM netflix
  GROUP BY type;
  ```

---

### 3. **Insights on Ratings**
- **Most Common Ratings:**
  ```sql
  SELECT TYPE, RATING
  FROM (
      SELECT TYPE, RATING, COUNT(*) AS COUNT, 
             RANK() OVER (PARTITION BY TYPE ORDER BY COUNT(*) DESC) AS RANKING
      FROM netflix
      GROUP BY TYPE, RATING
  ) AS T1
  WHERE RANKING = 1;
  ```

---

### 4. **Country-Based Content Analysis**
- **Top 5 Countries with Most Content:**
  ```sql
  SELECT country, COUNT(DISTINCT show_id) AS show_count
  FROM (
      SELECT 
          TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(country, ',', n.n), ',', -1)) AS country,
          show_id
      FROM netflix
      JOIN (
          SELECT 1 AS n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
      ) n ON CHAR_LENGTH(country) - CHAR_LENGTH(REPLACE(country, ',', '')) >= n.n - 1
  ) AS countries
  GROUP BY country
  ORDER BY show_count DESC
  LIMIT 5;
  ```

---

### 5. **Content Trends**
- **Longest Movie on Netflix:**
  ```sql
  SELECT title, duration
  FROM netflix
  WHERE type = 'Movie'
  ORDER BY CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) DESC;
  ```

- **Content Added in the Last 5 Years:**
  ```sql
  SELECT *
  FROM netflix
  WHERE date_added >= CURDATE() - INTERVAL 5 YEAR;
  ```

---

### 6. **Director and Actor Insights**
- **Content by Director "Rajiv Chilaka":**
  ```sql
  SELECT *
  FROM netflix
  WHERE FIND_IN_SET('Rajiv Chilaka', director) > 0;
  ```

- **Top 10 Actors in Indian Movies:**
  ```sql
  SELECT 
      TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(cast, ',', n.n), ',', -1)) AS actor,
      COUNT(*) AS total_appearances
  FROM netflix
  JOIN (
      SELECT 1 AS n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
  ) n ON CHAR_LENGTH(cast) - CHAR_LENGTH(REPLACE(cast, ',', '')) >= n.n - 1
  WHERE country = 'India'
  GROUP BY actor
  ORDER BY total_appearances DESC
  LIMIT 10;
  ```

---

### 7. **Genre Analysis**
- **Content Count by Genre:**
  ```sql
  SELECT 
      TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', n.n), ',', -1)) AS genre,
      COUNT(*) AS total_content
  FROM netflix
  JOIN (
      SELECT 1 AS n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
  ) n ON CHAR_LENGTH(listed_in) - CHAR_LENGTH(REPLACE(listed_in, ',', '')) >= n.n - 1
  GROUP BY genre
  ORDER BY total_content DESC;
  ```

---

### 8. **Categorizing Content**
- **Content Categorization by Theme:**
  ```sql
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
  ```

---

## 📈 Insights Visualization

Here are some example visualizations (in Power BI or other tools):
- **Content Distribution:** Pie chart showing movies vs TV shows.
- **Top Countries:** Bar graph of countries with most Netflix content.
- **Genre Popularity:** Bar graph of content count by genre.
- **Thematic Analysis:** Pie chart categorizing content into "Good" and "Bad."

---

## 🏆 Conclusion

Through SQL queries, this project reveals how Netflix designs its content strategy. From understanding the dominance of movies to spotting trends in genres and actor contributions, SQL helps us uncover meaningful patterns.

