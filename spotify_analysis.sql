--EDA
SELECT COUNT(*) FROM public.spotify;

SELECT COUNT(DISTINCT artist) FROM spotify;

SELECT COUNT(DISTINCT album) FROM spotify;

SELECT DISTINCT album_type FROM spotify;

SELECT MAX(duration_min) FROM spotify;
SELECT MIN(duration_min) FROM spotify;

SELECT * FROM spotify
WHERE duration_min = 0;
DELETE FROM spotify
WHERE duration_min = 0;


SELECT DISTINCT channel FROM spotify;
SELECT DISTINCT most_played_on FROM spotify;

--DATA ANALYSIS EASY CATEGORY

/* Retrieve all the tracks that have more than 1 billion streams
List all albums along with their respective artists
Get the total number of comments for tracks where licensed == true
Find all tracks that belong to the album type single
Count the total number of tracks by each artist */  
 --Q1

SELECT* FROM spotify
	WHERE stream > 1000000000;

--Q2
SELECT 
	DISTINCT album,artist
FROM spotify
ORDER BY 1	;

--Q3
SELECT 
     SUM(comments) as total_comments
FROM spotify
WHERE licensed = 'true';

--Q4
SELECT * FROM spotify
	WHERE album_type = 'single';

--Q5
SELECT 
	artist,
	COUNT (*) as total_no_songs
FROM spotify
GROUP BY artist;

-----------------
/*
Calculate average danceability of tracks in each album
Find the top 5 tracks with the highest energy values
List all tracks along with their views and likes where official_video = TRUE
For each album,calculate the total views of all associated tracks
Retrieve the track names that have been streamed on Spotify more than YouTube
*/

--Q6
SELECT album,
       avg(danceability) as avg_danceability
FROM spotify
GROUP BY 1
ORDER BY 2 DESC;

--Q7
SELECT 
     track,
     MAX (energy)
FROM spotify
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--Q8
SELECT 
      track,
      SUM(views) as total_views,
	  SUM(likes) as total_likes
FROM spotify
 WHERE official_video = 'true'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--Q9
SELECT 
	album,
	track,
	SUM(views)
FROM spotify
GROUP BY 1,2
ORDER BY 3;

--Q10
SELECT * FROM
(SELECT 
	  track,
	COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END)) as streamed_on_youtube,
	COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END)) as streamed_on_spotify
FROM spotify
GROUP BY 1
)as t1
WHERE 
	streamed_on_spotify > streamed_on_youtube
    AND 
    streamed_on_youtube > 0

/*
Find the Top 3 most-viewed tracks for each artist using window function
Write a query to find tracks where the liveness score is above the average
Use a WITH clause to calculate the difference between the highest and the lowest energy values for tracks in each
Find tracks where the energu-to-liveness ratio is greater than 1.2
Calculate the cumulative sum of likes for tracks ordered by the number of views,using window functions.
*/
 --Q11
WITH ranking_artist
AS
(SELECT
	  artist,
	  track,
      SUM(views) as total_views,
	  DENSE_RANK () OVER(PARTITION BY artist ORDER BY SUM(views) DESC) as rank
FROM spotify
GROUP BY 1,2
ORDER BY 1,3 DESC
)
SELECT* FROM ranking_artist
WHERE rank <= 3;

--Q12
SELECT 
	track,
	artist,
	liveness
	FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify)

--Q13
WITH cte
AS
(SELECT
	 album,
     MAX(energy) as highest_energy,
     MIN(energy) as lowest_energy
FROM spotify
GROUP BY 1
)
SELECT
     album,
     highest_energy - lowest_energy as energy_diff
FROM cte
ORDER BY 2 DESC;