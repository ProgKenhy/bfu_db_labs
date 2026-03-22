-- 1. Рейтинг фильмов внутри года
SELECT
    mt.title,
    m.release_year,
    m.rating,
    RANK() OVER (PARTITION BY m.release_year ORDER BY m.rating DESC) AS rank,
    DENSE_RANK() OVER (PARTITION BY m.release_year ORDER BY m.rating DESC) AS dense_rank,
    ROW_NUMBER() OVER (PARTITION BY m.release_year ORDER BY m.rating DESC) as row_number 
FROM cinema.movie m 
JOIN cinema.movie_title mt ON m.id = mt.movie_id 
WHERE mt.language_id = 'ru' AND m.release_year > 2011;

-- 2. Общий рейтинг всех фильмов
SELECT
    mt.title,
    m.rating,
    RANK() OVER (ORDER BY m.rating DESC) AS rank_all,
    DENSE_RANK() OVER (ORDER BY m.rating DESC) AS dense_rank_all,
    ROW_NUMBER() OVER (ORDER BY m.rating DESC) AS row_number_all
FROM cinema.movie m
JOIN cinema.movie_title mt ON m.id = mt.movie_id 
WHERE mt.language_id = 'ru';

-- 3. Рейтинг по жанрам
SELECT 
     g.name AS genre,
     mt.title,
     m.rating,
     RANK() OVER (PARTITION BY g.id ORDER BY m.rating DESC) AS rank_in_genre
FROM cinema.genre g
JOIN cinema.movie_genre mg ON mg.genre_id = g.id 
JOIN cinema.movie m ON mg.movie_id = m.id 
JOIN cinema.movie_title mt ON mt.movie_id = m.id
WHERE mt.language_id = 'ru';

-- 4. Рейтинг актёров по количеству фильмов
SELECT 
    p.first_name,
    p.last_name,
    COUNT(*) AS movie_count,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS rank_actors
FROM cinema.person p 
JOIN cinema.movie_crew mc ON p.id = mc.person_id
WHERE mc.role_id = 2
GROUP BY p.id;

-- 5. Нумерация фильмов внутри жанра
SELECT 
    g.name,
    mt.title,
    ROW_NUMBER() OVER (
        PARTITION BY g.id 
        ORDER BY mt.title
    ) AS num_in_genre
FROM cinema.genre g
JOIN cinema.movie_genre mg ON g.id = mg.genre_id 
JOIN cinema.movie m ON m.id = mg.movie_id 
JOIN cinema.movie_title mt ON m.id = mt.movie_id 
WHERE mt.language_id = 'ru';

-- 6. Самый популярный год (ранг по количеству фильмов)
SELECT 
    m.release_year,
    COUNT(*) as movie_count,
    DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) as year_rank
FROM cinema.movie m
GROUP BY m.release_year;

-- 7. Рейтинг фильмов по длительности
SELECT
    mt.title,
    m.length,
    RANK() OVER (ORDER BY m.length DESC) AS duration_rank
FROM cinema.movie m 
JOIN cinema.movie_title mt ON mt.movie_id = m.id 
WHERE mt.language_id = 'ru';

-- 8. Рейтинг фильмов внутри возрастной категории
SELECT 
    mt.title,
    m.min_age,
    DENSE_RANK() OVER (PARTITION BY m.min_age 
    ORDER BY m.rating DESC) as rank_in_age_group
FROM cinema.movie m 
JOIN cinema.movie_title mt ON mt.movie_id = m.id
WHERE mt.language_id = 'ru';

-- 9. Топ фильмов (первые 3)
SELECT *
FROM (
    SELECT
        mt.title,
        m.rating,
        ROW_NUMBER() OVER (ORDER BY m.rating DESC) AS rn
    FROM cinema.movie m 
    JOIN cinema.movie_title mt ON m.id = mt.movie_id 
    WHERE mt.language_id = 'ru'
) sub
WHERE rn <= 3;

-- 10. Топ-3 фильма в каждом году по рейтингу
SELECT *
FROM (
    SELECT
        mt.title,
        m.rating,
        m.release_year as year,
        ROW_NUMBER() OVER (partition by m.release_year 
        ORDER BY m.rating DESC) AS row_num 
    FROM cinema.movie m
    JOIN cinema.movie_title mt ON m.id = mt.movie_id
    where mt.language_id = 'ru' and m.release_year > 2011
) sub
WHERE row_num <= 3 
ORDER BY year;