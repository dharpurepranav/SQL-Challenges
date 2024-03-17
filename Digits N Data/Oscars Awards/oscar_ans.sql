-- Find the producer names along with the count of movies they have produced that won an award?
SELECT m.producer, COUNT(DISTINCT w.movie_title) AS award_winning_movies_count
FROM Winners w
JOIN Movies m ON w.movie_title = m.title
GROUP BY m.producer;

-- Find the names of all movies along with the count of nominations they received and arrange in descending order?
SELECT m.title, COUNT(n.movie_title) AS nominations_count
FROM movies m
JOIN nominees n ON m.title = n.movie_title
GROUP BY n.movie_title
ORDER BY nominations_count DESC;

-- Find the names of all producers who have produced movies that were both nominated and won an award?
SELECT DISTINCT m.producer
FROM Movies m
JOIN Winners w ON m.title = w.movie_title
JOIN Nominees n ON m.title = n.movie_title
WHERE w.movie_title IN (SELECT DISTINCT movie_title FROM Nominees);

-- Which category Cillian Murphy and Robert Downey Jr. won the award ?
SELECT winner_name, category
FROM winners
WHERE winner_name IN ('Cillian Murphy', 'Robert Downey Jr.');

-- Retrieve the count of winners for each category from the Winners table?
SELECT category, COUNT(*) AS winners_count
FROM winners
GROUP BY category;