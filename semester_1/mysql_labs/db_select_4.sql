-- 1) Уникальные годы выпуска фильмов (с DISTINCT)
SELECT DISTINCT RELEASE_YEAR
FROM movie
WHERE RELEASE_YEAR > 2000
ORDER BY RELEASE_YEAR DESC;

-- 2) Все годы выпуска фильмов (без DISTINCT)
SELECT RELEASE_YEAR
FROM movie
WHERE RELEASE_YEAR > 2000
ORDER BY RELEASE_YEAR DESC;

-- 3) Статистика по фильмам: количество, средняя длина, макс/мин рейтинг
SELECT
	COUNT(*) as total_movies,
	ROUND(AVG(LENGTH)) as avg_length,
	MAX(RATING) as max_rating,
	MIN(RATING) as min_rating
FROM movie
WHERE RELEASE_YEAR BETWEEN 2000 AND 2020;

-- 4) Фильмы с русскими названиями (обработка строк)
SELECT
	UPPER(LEFT(TITLE, 1)) as first_letter,
	LOWER(SUBSTRING(TITLE, 2)) as rest_title,
	LENGTH(TITLE) as title_length
FROM movie_title
WHERE LANGUAGE_ID = 'ru'
  AND LENGTH(TITLE) > 10;

-- 5) Фильмы с округленным рейтингом и вычислениями
SELECT
	TITLE,
	RATING,
	ROUND(RATING, 0) as rounded_rating,
	POWER(RATING, 2) as rating_squared,
	ABS(RATING - 8.0) as diff_from_8
FROM movie m
		 JOIN movie_title mt ON m.ID = mt.MOVIE_ID
WHERE mt.LANGUAGE_ID = 'ru'
  AND RATING IS NOT NULL;

-- 6) Фильмы последних лет с вычислением возраста
SELECT
	TITLE,
	RELEASE_YEAR,
	(YEAR(NOW()) - RELEASE_YEAR) as age_years
FROM movie m
		 JOIN movie_title mt ON m.ID = mt.MOVIE_ID
WHERE mt.LANGUAGE_ID = 'ru'
  AND RELEASE_YEAR > 2010
ORDER BY RELEASE_YEAR DESC, RATING DESC;

-- 7) Топ-5 фильмов по рейтингу
SELECT
	TITLE,
	RATING,
	RELEASE_YEAR
FROM movie m
		 JOIN movie_title mt ON m.ID = mt.MOVIE_ID
WHERE mt.LANGUAGE_ID = 'ru'
  AND RATING IS NOT NULL
ORDER BY RATING DESC
LIMIT 5;

-- 8) Количество фильмов по годам с условиями
SELECT
	RELEASE_YEAR,
	COUNT(*) as movies_count,
	ROUND(AVG(RATING), 2) as avg_rating
FROM movie
WHERE RELEASE_YEAR >= 2000
  AND RATING IS NOT NULL
GROUP BY RELEASE_YEAR
HAVING COUNT(*) > 1
ORDER BY movies_count DESC;

-- 9) Обработка названий фильмов
SELECT
	TITLE,
	REPLACE(TITLE, ' ', '_') as title_with_underscores,
	REVERSE(TITLE) as reversed_title
FROM movie_title
WHERE LANGUAGE_ID = 'ru'
  AND TITLE LIKE '% %';


-- 10) Фильмы с разными условиями отбора
SELECT
	m.ID,
	mt.TITLE,
	m.RELEASE_YEAR,
	m.LENGTH,
	m.RATING
FROM movie m
		 JOIN movie_title mt ON m.ID = mt.MOVIE_ID
		 JOIN movie_genre mg ON m.ID = mg.MOVIE_ID
		 JOIN genre g ON mg.GENRE_ID = g.ID
WHERE mt.LANGUAGE_ID = 'ru'
  AND m.RATING >= 7.5
  AND m.LENGTH BETWEEN 90 AND 180
  AND g.NAME IN ('Драма', 'Комедия')
  AND m.RELEASE_YEAR > 2000
ORDER BY m.RATING DESC, m.RELEASE_YEAR DESC;