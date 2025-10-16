#Estimated revenues by genre 

SELECT g.genre,
		COUNT(DISTINCT g.app_id) AS games_count,
		SUM(r.estimated_revenue) AS total_revenue_eur,
        FORMAT(SUM(r.estimated_revenue), 0) AS revenue_pretty,
        ROUND(SUM(r.estimated_revenue) / COUNT(DISTINCT g.app_id), 2) AS avg_revenue_per_game
FROM games_cleaning r
JOIN genres g ON r.app_id = g.app_id
GROUP BY g.genre
ORDER BY total_revenue_eur DESC;

#Estimated revenues by category 

SELECT c.category,
		COUNT(DISTINCT c.app_id) AS games_count,
		SUM(r.estimated_revenue) AS total_revenue_eur,
        FORMAT(SUM(r.estimated_revenue), 0) AS revenue_pretty,
        ROUND(SUM(r.estimated_revenue) / COUNT(DISTINCT c.app_id), 2) AS avg_revenue_per_game
FROM games_cleaning r
JOIN categories c ON r.app_id = c.app_id
GROUP BY c.category
ORDER BY total_revenue_eur DESC;

#Estimated revenues by tags 

SELECT t.tag,
		COUNT(DISTINCT t.app_id) AS games_count,
		SUM(r.estimated_revenue) AS total_revenue_eur,
        FORMAT(SUM(r.estimated_revenue), 0) AS revenue_pretty,
        ROUND(SUM(r.estimated_revenue) / COUNT(DISTINCT t.app_id), 2) AS avg_revenue_per_game
FROM games_cleaning r
JOIN tags t ON r.app_id = t.app_id
GROUP BY t.tag
ORDER BY total_revenue_eur DESC;

#Results
#Genres
/*
The most popular genres among devs: Indie, Action, Adventure, Casual
The least popular genres among devs: 360 Video, Documentary, Episodic, Short
Genre with the most total revenue: Action
Genres with the least total revenue: 360 Video, Documentary, Episodic, Short, Sexual Content, Violent
Genre with the most revenue per game: Massively Multiplayer, RPG, Action
Genre with the least revenue per game: Movie, 360 Video, Documentary, Episodic, Short, Sexual Content, Violent
*/

#Categories
/*
The most popular category among devs: Single-player
The least popular categories among devs: Massively Multiplayer, Mods, SteamVR Collectibles
Categories with the most total revenue: Co-op, Remote Play, Single-player
Categories with the least total revenue: Mods, Massively Multiplayer, SteamVR Collectibles, Steam Turn Notifications
Categories with the most revenue per game: Massively Multiplayer, Valve Anti-Cheat enabled, HDR available
Categories with the least revenue per game: Mods, VR Only, Tracked Controller Support, Single-player
*/

#Tags
/*
The most popular tags among devs: Singleplayer, Indie, Action
The least popular tags among devs: Reboot, Snooker, Steam Machine, Feature Film
Tags with the most total revenue: Singleplayer, Action, Multiplayer
Tags with the least total revenue: 8-bit Music, Feature Film, Steam Machine
Tags with the most revenue per game: Extraction Shooter, TrackIR, Games Workshop, Dungeons & Dragons, Epic
Tags with the least revenue per game: 8-bit Music, Mahjong, Free to Play, Spelling
*/