-- 1. Средний рейтинг по году
SELECT
    mt.title,
    m.release_year,
    m.rating,
    AVG(m.rating) OVER (PARTITION BY m.release_year) AS avg_rating_year
FROM cinema.movie m
JOIN cinema.movie_title mt ON m.id = mt.movie_id
WHERE mt.language_id = 'ru' AND m.release_year > 2011;

-- 2. Минимальный и максимальный рейтинг по году
SELECT
    mt.title,
    m.release_year,
    m.rating,
    MIN(m.rating) OVER (PARTITION BY m.release_year) AS min_rating,
    MAX(m.rating) OVER (PARTITION BY m.release_year) AS max_rating
FROM cinema.movie m
JOIN cinema.movie_title mt ON m.id = mt.movie_id
WHERE mt.language_id = 'ru';

-- 3. Количество фильмов в каждом году
SELECT
    mt.title,
    m.release_year,
    COUNT(*) OVER (PARTITION BY m.release_year) AS movies_in_year
FROM cinema.movie m
JOIN cinema.movie_title mt ON m.id = mt.movie_id
WHERE mt.language_id = 'ru';

-- 4. Средняя длительность по году
SELECT
    mt.title,
    m.length,
    AVG(m.length) OVER (PARTITION BY m.release_year) AS avg_length_year
FROM cinema.movie m
JOIN cinema.movie_title mt ON m.id = mt.movie_id
WHERE mt.language_id = 'ru'
ORDER BY avg_length_year;

-- 5. Суммарная длительность всех фильмов (накопительная)
SELECT
    mt.title,
    m.length,
    SUM(m.length) OVER (ORDER BY m.length) AS cumulative_length
FROM cinema.movie m
JOIN cinema.movie_title mt ON m.id = mt.movie_id
WHERE mt.language_id = 'ru';

-- 6. Количество фильмов в жанре
SELECT
    g.name AS genre,
    mt.title,
    COUNT(*) OVER (PARTITION BY g.id) AS movies_in_genre
FROM cinema.genre g
JOIN cinema.movie_genre mg ON g.id = mg.genre_id
JOIN cinema.movie m ON m.id = mg.movie_id
JOIN cinema.movie_title mt ON m.id = mt.movie_id
WHERE mt.language_id = 'ru';


-- 7. Средний рейтинг по жанру
SELECT
    g.name AS genre,
    mt.title,
    m.rating,
    AVG(m.rating) OVER (PARTITION BY g.id) AS avg_rating_genre
FROM cinema.genre g
JOIN cinema.movie_genre mg ON g.id = mg.genre_id
JOIN cinema.movie m ON m.id = mg.movie_id
JOIN cinema.movie_title mt ON m.id = mt.movie_id
WHERE mt.language_id = 'ru'
ORDER BY avg_rating_genre DESC;

-- 8. Разница рейтинга фильма и среднего по году
SELECT
    mt.title,
    m.release_year,
    m.rating,
    AVG(m.rating) OVER (PARTITION BY m.release_year) AS avg_rating,
    m.rating - AVG(m.rating) OVER (PARTITION BY m.release_year) AS diff
FROM cinema.movie m
JOIN cinema.movie_title mt ON m.id = mt.movie_id
WHERE mt.language_id = 'ru';

-- 9. Средний рейтинг по всем фильмам (для каждой строки)
SELECT
    mt.title,
    m.rating,
    AVG(m.rating) OVER () AS global_avg_rating
FROM cinema.movie m
JOIN cinema.movie_title mt ON m.id = mt.movie_id
WHERE mt.language_id = 'ru';

-- 10. Скользящее среднее рейтинга
SELECT
    mt.title,
    m.rating,
    AVG(m.rating) OVER (
        ORDER BY m.rating
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ) AS moving_avg
FROM cinema.movie m
JOIN cinema.movie_title mt ON m.id = mt.movie_id
WHERE mt.language_id = 'ru';