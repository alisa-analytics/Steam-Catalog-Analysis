# Steam Catalog Analysis

This project explores the [**Steam game catalog**](https://github.com/NewbieIndieGameDev/steam-insights) using **MySQL** and **SQL** to analyze game genres, categories, and tags. The goal is to identify which types of games are most and least popular among developers, and which ones generate the highest and lowest revenue.

---

## Project Overview

The Steam platform hosts thousands of games across a wide variety of genres and categories.  
By analyzing [this dataset](https://github.com/NewbieIndieGameDev/steam-insights), the project aims to answer key questions:

- Which **genres, categories, and tags** are most frequently used by developers?  
- Which of them are **associated with the highest revenue**?  
- Which ones are **less profitable or unpopular**?

---

## Tools and Technologies

- **MySQL** — for database management and queries  
- **SQL** — for data extraction, aggregation, and insight generation
- **ChatGPT** — for query optimization and code assistance

---

## 🔍 Methodology

1. **Data Preparation**
   - Imported and structured Steam catalog data in MySQL  
   - Cleaned and normalized tables for games, genres, categories, reviews, and tags  

2. **Data Analysis**
   - Counted the frequency of each genre, category, and tag  
   - Calculated average and total revenue per genre, category, and tag  
   - Identified top-performing and underperforming segments  

---

## 💡 Example SQL Queries

```sql
-- Estimated revenues by genre 
SELECT g.genre,
		COUNT(DISTINCT g.app_id) AS games_count,
		SUM(r.estimated_revenue) AS total_revenue_eur,
        FORMAT(SUM(r.estimated_revenue), 0) AS revenue_pretty,
        ROUND(SUM(r.estimated_revenue) / COUNT(DISTINCT g.app_id), 2) AS avg_revenue_per_game
FROM games_cleaning r
JOIN genres g ON r.app_id = g.app_id
GROUP BY g.genre
ORDER BY total_revenue_eur DESC;

-- Estimated revenues by category 
SELECT c.category,
		COUNT(DISTINCT c.app_id) AS games_count,
		SUM(r.estimated_revenue) AS total_revenue_eur,
        FORMAT(SUM(r.estimated_revenue), 0) AS revenue_pretty,
        ROUND(SUM(r.estimated_revenue) / COUNT(DISTINCT c.app_id), 2) AS avg_revenue_per_game
FROM games_cleaning r
JOIN categories c ON r.app_id = c.app_id
GROUP BY c.category
ORDER BY total_revenue_eur DESC;
