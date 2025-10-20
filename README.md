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

## Methodology

1. **Data Preparation**
   - Imported and structured Steam catalog data in MySQL  
   - Cleaned and normalized tables for games, genres, categories, reviews, and tags  

2. **Data Analysis**
   - Counted the frequency of each genre, category, and tag  
   - Calculated average and total revenue per genre, category, and tag  
   - Identified top-performing and underperforming segments  

---

## Project Details

- **Duration:** 2 weeks  
- **Data collected:** October 2024
- **Data Source:** https://github.com/NewbieIndieGameDev/steam-insights

---

## Example SQL Query

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
```

---

## 📈 Results

### Genres

**Most popular genres among developers:**  
Indie, Action, Adventure, Casual  

**Least popular genres:**  
360 Video, Documentary, Episodic, Short  

**Genres with the highest total revenue:**  
Action  

**Genres with the lowest total revenue:**  
360 Video, Documentary, Episodic, Short, Sexual Content, Violent  

**Genres with the highest average revenue per game:**  
Massively Multiplayer, RPG, Action  

**Genres with the lowest average revenue per game:**  
Movie, 360 Video, Documentary, Episodic, Short, Sexual Content, Violent  

---

### Categories

**Most popular category among developers:**  
Single-player  

**Least popular categories:**  
Massively Multiplayer, Mods, SteamVR Collectibles  

**Categories with the highest total revenue:**  
Co-op, Remote Play, Single-player  

**Categories with the lowest total revenue:**  
Mods, Massively Multiplayer, SteamVR Collectibles, Steam Turn Notifications  

**Categories with the highest average revenue per game:**  
Massively Multiplayer, Valve Anti-Cheat Enabled, HDR Available  

**Categories with the lowest average revenue per game:**  
Mods, VR Only, Tracked Controller Support, Single-player  

---

### Tags

**Most popular tags among developers:**  
Singleplayer, Indie, Action  

**Least popular tags:**  
Reboot, Snooker, Steam Machine, Feature Film  

**Tags with the highest total revenue:**  
Singleplayer, Action, Multiplayer  

**Tags with the lowest total revenue:**  
8-bit Music, Feature Film, Steam Machine  

**Tags with the highest average revenue per game:**  
Extraction Shooter, TrackIR, Games Workshop, Dungeons & Dragons, Epic  

**Tags with the lowest average revenue per game:**  
8-bit Music, Mahjong, Free to Play, Spelling  

---

### Summary

- **Action and RPG** genres dominate both in popularity and revenue.  
- **Single-player** remains the most common and profitable category.  
- **Indie** games are widespread but show high variability in revenue.  
- Niche genres like *Documentary* and *360 Video* show limited popularity and financial success.  

