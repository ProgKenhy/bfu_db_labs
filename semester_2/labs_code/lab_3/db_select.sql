-- 1. Классификация фильмов по длительности
SELECT mt.title, m.length,
CASE 
    WHEN m.length <= 100 THEN 'Short'
    WHEN m.length <= 180 THEN 'Medium'
    ELSE 'Long'
END AS duration_type
FROM cinema.movie m
JOIN cinema.movie_title mt ON m.id = mt.movie_id
WHERE mt.language_id = 'ru'
ORDER BY mt.title;

-- 2. Классификация по рейтингу
SELECT mt.title, m.rating,
CASE 
    WHEN m.rating >= 8.5 THEN 'Great'
    WHEN m.rating >= 7 THEN 'Well'
    ELSE 'Average/Bad'
END AS rating_category
FROM cinema.movie m
JOIN cinema.movie_title mt ON m.id = mt.movie_id
WHERE mt.language_id = 'ru';

-- 3. Возрастное ограничение (детский / взрослый)
SELECT mt.title, m.min_age,
CASE
    WHEN m.min_age < 12 THEN 'Child'
    WHEN m.min_age < 18 THEN 'Adolescent'
    ELSE 'Adult'
END AS audience
FROM cinema.movie m 
JOIN cinema.movie_title mt ON m.id = mt.movie_id
WHERE mt.language_id = 'ru';

-- 4. Есть ли рейтинг
SELECT mt.title,
CASE
    WHEN m.rating IS NULL THEN 'No rating'
    ELSE 'With rating'
END AS rating_status
FROM cinema.movie m 
JOIN cinema.movie_title mt ON m.id = mt.movie_id
WHERE mt.language_id = 'ru';

-- 5. Фильмы до и после 2000 года
SELECT mt.title, m.release_year,
CASE
    WHEN m.release_year < 2000 THEN 'Old movie'
    ELSE 'Modern movie'
END AS era
FROM cinema.movie m
JOIN cinema.movie_title mt ON m.id = mt.movie_id
WHERE mt.language_id = 'ru';

-- 6. Фильтруем только длинные фильмы через CASE
SELECT mt.title, m.length
FROM cinema.movie m
JOIN cinema.movie_title mt ON m.id = mt.movie_id
WHERE mt.language_id = 'ru'
AND (
    CASE
        WHEN m.length > 120 THEN TRUE
        ELSE FALSE
    END
);

-- 7. CASE + GROUP BY (категории длительности)
SELECT
CASE
    WHEN m.length <= 100 THEN 'Short'
    WHEN m.length <= 180 THEN 'Medium'
    ELSE 'Long'
END AS category,
COUNT(*) AS movie_count
FROM cinema.movie m
GROUP BY category;

-- 8. Популярные годы выхода фильмов (>1)
SELECT
m.release_year,
COUNT(*) AS movie_count,
CASE 
    WHEN COUNT(*) > 1 THEN 'Popular year'
    ELSE 'Few movies'
END AS status 
FROM cinema.movie m 
GROUP BY m.release_year 
HAVING COUNT(*) > 0;

-- 9. CASE + ORDER BY (сортировка по рейтингу)
SELECT mt.title, m.rating
CASE
    WHEN m.rating >= 8 THEN 1
    WHEN m.rating >= 6 THEN 2
    ELSE 3
END AS sort_key
FROM cinema.movie m 
JOIN cinema.movie_title mt ON m.id = mt.movie_id
WHERE mt.language_id = 'ru'
ORDER BY sort_key;

-- 10. CASE + JOIN (есть ли режиссёр)
SELECT mt.title,
CASE
    WHEN EXISTS (
        SELECT 1
        FROM cinema.movie_crew mc 
        WHERE mc.movie_id = m.id AND mc.role_id = 1
    ) THEN 'There is a director'
    ELSE 'No director there'
END AS director_status
FROM cinema.movie m 
JOIN cinema.movie_title mt ON m.id = mt.movie_id
WHERE mt.language_id = 'ru';