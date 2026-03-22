-- 1. Нумерация фильмов по году
SELECT
	mt.title,
	m.release_year,
	ROW_NUMBER() OVER (
        PARTITION BY m.release_year
        ORDER BY m.rating DESC
	) AS row_num 
FROM cinema.movie m 
JOIN cinema.movie_title mt ON m.id = mt.movie_id 
WHERE mt.language_id = 'ru'
and m.release_year > 2011;

-- 2. Фильмы + средняя длительность по году (с сортировкой)
SELECT 
    mt.title,
    m.length,
    AVG(m.length) OVER (PARTITION BY m.release_year) AS avg_length_year
FROM cinema.movie m 
JOIN cinema.movie_title mt ON m.id = mt.movie_id 
WHERE mt.language_id = 'ru' AND m.release_year > 2011
ORDER BY avg_length_year;

-- 3. Жанры + количество фильмов в жанре
SELECT 
    g.name AS genre,
    mt.title,
    COUNT(*) OVER (PARTITION BY g.id) AS movies_in_genre
FROM cinema.genre g 
JOIN cinema.movie_genre mg ON g.id = mg.genre_id
JOIN cinema.movie m ON m.id = mg.movie_id 
JOIN cinema.movie_title mt ON m.id = mt.movie_id 
WHERE mt.language_id = 'id'
ORDER BY movies_in_genre DESC;

-- 4. Фильмы + средний/мин/макс рейтинг по году
SELECT 
    mt.title,
    m.release_year,
    m.rating,
    AVG(m.rating) OVER (PARTITION BY m.release_year) AS avg_rating_year,
    MIN(m.rating) OVER (PARTITION BY m.release_year) AS min_rating_year,
    MAX(m.rating) OVER (PARTITION BY m.release_year) AS max_rating_year,
    AVG(m.rating) OVER (PARTITION BY m.release_year) - m.rating AS diff_from_avg
FROM cinema.movie m
JOIN cinema.movie_title mt ON mt.movie_id = m.id
WHERE mt.language_id = 'ru'
ORDER BY avg_rating_year;

-- 5. Рейтинг фильма + ранг внутри года
SELECT
    mt.title,
    m.release_year,
    m.rating,
    RANK() OVER (
        PARTITION BY m.release_year
        ORDER BY m.rating DESC
    ) AS rank_in_year
FROM cinema.movie m 
JOIN cinema.movie_title mt ON m.id = mt.movie_id 
WHERE mt.language_id = 'ru' and m.release_year > 2011;


-- 6. Длительность + накопительная сумма
SELECT 
    mt.title,
    m.length,

    SUM(m.length) OVER (
        ORDER BY m.length
    ) AS cumulative_length

FROM cinema.movie m 
JOIN cinema.movie_title mt ON m.id = mt.movie_id 
WHERE mt.language_id = 'ru';


-- 7. Разница между фильмом и предыдущим по рейтингу
SELECT 
    mt.title,
    m.rating,
    LAG(m.rating) OVER (ORDER BY m.rating) AS prev_rating,
    m.rating - LAG(m.rating) OVER (ORDER BY m.rating) AS diff 
FROM cinema.movie m 
JOIN cinema.movie_title mt ON m.id = mt.movie_id 
WHERE mt.language_id = 'ru';

-- 8. Фильмы + средний рейтинг по жанру
SELECT 
    g.name,
    mt.title,
    m.rating,
    AVG(m.rating) OVER (PARTITION BY g.id) AS avg_rating_genre
FROM cinema.genre g 
JOIN cinema.movie_genre mg ON g.id = mg.genre_id 
JOIN cinema.movie m ON m.id = mg.movie_id
JOIN cinema.movie_title mt ON m.id = mt.movie_id
WHERE mt.language_id = 'ru'
ORDER BY avg_rating_genre DESC;

-- 9. Топ фильмов по рейтингу
SELECT 
    mt.title,
    m.rating,
    ROW_NUMBER() OVER (
        ORDER BY m.rating DESC
    ) AS position  
FROM cinema.movie m
JOIN cinema.movie_title mt ON m.id = mt.movie_id 
WHERE mt.language_id = 'ru';

-- 10. Скользящее среднее рейтинга (среднее среди соседей)
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