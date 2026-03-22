-- 1. GROUP BY - количество фильмов по годам
SELECT m.release_year, COUNT(*) AS movie_count
FROM cinema.movie m
GROUP BY m.release_year;

-- 2. GROUP BY - средний рейтинг по годам
SELECT m.release_year, AVG(m.rating) AS avg_rating
FROM cinema.movie m
GROUP BY m.release_year;

-- 3. GROUP BY - максимальная длительность фильма по годам
SELECT m.release_year, MAX(m.length) AS max_length
FROM cinema.movie m
GROUP BY m.release_year;

-- 4. GROUP BY + WHERE - фильмы после 2010
SELECT m.release_year, COUNT(*) AS movie_count
FROM cinema.movie m
WHERE m.release_year > 2010
GROUP BY m.release_year;

-- 5. GROUP BY + WHERE - средний рейтинг фильмов 18+
SELECT m.min_age, AVG(m.rating) as avg_rating
FROM cinema.movie m
WHERE m.min_age >= 18
GROUP BY m.min_age;

-- 6. GROUP BY + ORDER BY - сортировка по количеству фильмов
SELECT m.release_year, COUNT(*) as movie_count
FROM cinema.movie m
GROUP BY m.release_year
ORDER BY movie_count DESC;

-- 7. GROUP BY + ORDER BY - средняя длительность по годам
SELECT m.release_year, AVG(m.length) as avg_length
FROM cinema.movie m
GROUP BY m.release_year
ORDER BY avg_length DESC;

-- 8. GROUP BY + HAVING - годы с более чем 1 фильмом
SELECT m.release_year, COUNT(*) as movie_count
FROM cinema.movie m
GROUP BY m.release_year
HAVING COUNT(*) > 1;

-- 9. GROUP BY + HAVING - высокий средний рейтинг (>8.7)
SELECT m.release_year, AVG(m.rating) as avg_rating
FROM cinema.movie m
GROUP BY m.release_year
HAVING AVG(m.rating) > 8.7;

-- 10. GROUP BY + JOIN + HAVING + ORDER BY - количество фильмов по жанрам, где фильмов более 1
SELECT g.name, COUNT(*) as movie_count
FROM cinema.genre g
JOIN cinema.movie_genre mg ON g.id == mg.genre_id
GROUP BY g.name
HAVING COUNT(*) > 0
ORDER BY movie_count DESC;