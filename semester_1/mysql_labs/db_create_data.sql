# INSERT INTO имя_таблицы [(имя_столбца [, ...])]
# VALUES (выражение [, ...]) [, ...]

-- 1) Добавление языков
INSERT INTO language (ID, NAME)
VALUES ('ru', 'Русский'),
	   ('en', 'Английский'),
	   ('kz', 'Казахский');

-- 2) Добавление ролей
INSERT INTO role (NAME)
VALUES ('Актёр'),
	   ('Режиссёр'),
	   ('Каскадёр');

ALTER TABLE movie
	MODIFY RELEASE_YEAR SMALLINT NOT NULL CHECK (RELEASE_YEAR >= 1888);
-- 3) Добавление фильмов
INSERT INTO movie (RELEASE_YEAR, LENGTH, MIN_AGE, RATING)
VALUES (1900, 500, 21, 8.5),
	   (1990, 200, 0, 3.5);

-- 4) Добавление людей (без отчества)
INSERT INTO person (FIRST_NAME, MIDDLE_NAME)
VALUES ('Дима', 'Валуев'),
	   ('Миша', 'Горбачёв');

-- 5) Добавление заголовков фильмов
INSERT INTO movie_title (LANGUAGE_ID, MOVIE_ID, TITLE)
VALUES ('ru', 1, 'Герои'),
	   ('en', 1, 'Heroes'),
	   ('ru', 2, 'Творцы');

# INSERT INTO имя_таблицы [(имя_столбца [, ...])] SELECT …

-- 1) Создание и заполнение таблицы популярных фильмов
CREATE TABLE popular_movies
(
	movie_id     INT PRIMARY KEY,
	title_ru     VARCHAR(500),
	release_year SMALLINT,
	rating       DECIMAL(3, 1)
);

INSERT INTO popular_movies (movie_id, title_ru, release_year, rating)
SELECT m.id, mt.TITLE, m.RELEASE_YEAR, m.RATING
FROM movie m
		 JOIN movie_title mt ON m.ID = mt.MOVIE_ID
WHERE RATING >= 8
  AND mt.LANGUAGE_ID = 'ru';

-- 2) Создание и заполнение таблицы многоязычных фильмов
CREATE TABLE multilingual_movies
(
	movie_id     INT PRIMARY KEY,
	title_ru     VARCHAR(500),
	title_en     VARCHAR(500),
	release_year SMALLINT
);

INSERT INTO multilingual_movies (movie_id, title_ru, title_en, release_year)
SELECT m.ID, mt1.TITLE, mt2.TITLE, m.RELEASE_YEAR
FROM movie m
		 JOIN movie_title mt1 ON m.ID = mt1.MOVIE_ID and mt1.LANGUAGE_ID = 'ru'
		 JOIN movie_title mt2 ON m.ID = mt2.MOVIE_ID and mt2.LANGUAGE_ID = 'en';

-- 3) Создание и заполнение таблицы годовой статистики
CREATE TABLE year_statistics
(
	year               SMALLINT PRIMARY KEY,
	movies_count       INT,
	avg_length         DECIMAL(6, 1),
	avg_rating         DECIMAL(3, 1),
	title_ru_top_movie VARCHAR(500)
);

INSERT INTO year_statistics (year, movies_count, avg_length, avg_rating, title_ru_top_movie)
SELECT m.RELEASE_YEAR as year,
	   COUNT(DISTINCT m.ID),
	   ROUND(AVG(m.LENGTH)),
	   ROUND(AVG(m.RATING), 1),
	   (SELECT mt.TITLE
		FROM movie m
		JOIN movie_title mt ON m.ID = mt.MOVIE_ID and mt.LANGUAGE_ID = 'ru'
		WHERE m.RELEASE_YEAR = year
		ORDER BY m.RATING DESC
		LIMIT 1)
FROM movie m
GROUP BY m.RELEASE_YEAR;


-- 4) Создание и заполнение таблицы фильмов и их русских названий
CREATE TABLE movie_title_ru
(
	movie_id INT PRIMARY KEY,
	title_ru VARCHAR(500)
);

INSERT INTO movie_title_ru (movie_id, title_ru)
SELECT m.ID, mt.TITLE
       FROM movie m
JOIN movie_title mt ON m.ID = mt.MOVIE_ID and mt.LANGUAGE_ID = 'ru';

-- 5) Создание и заполнение таблицы фильмов и их английских названий
CREATE TABLE movie_title_en
(
	movie_id INT PRIMARY KEY,
	title_en VARCHAR(500)
);

INSERT INTO movie_title_en (movie_id, title_en)
SELECT m.ID, mt.TITLE
FROM movie m
		 JOIN movie_title mt ON m.ID = mt.MOVIE_ID and mt.LANGUAGE_ID = 'en';


# UPDATE имя_таблицы
# SET имя_столбца = выражение |
# 				 (имя_столбца [, ...]) = (выражение [, ...]) |
# 				 (имя_столбца [, ...]) = (вложенный_SELECT) [, ...]
#                [WHERE условие]
# Не забудьте вернуть данные от AI!

-- 1) Установить минимальный возраст фильма равным максимальному возрасту (min_age) другого фильма с таким же жанром
UPDATE movie m
SET MIN_AGE = (
	SELECT max_age
	FROM (
			 SELECT MAX(m2.MIN_AGE) AS max_age
			 FROM movie_genre mg1
					  JOIN movie_genre mg2 ON mg1.GENRE_ID = mg2.GENRE_ID
					  JOIN movie m2 ON m2.ID = mg2.MOVIE_ID
			 WHERE mg1.MOVIE_ID = m.ID
		 ) AS t
)
WHERE EXISTS (
	SELECT 1
	FROM movie_genre mg
			 JOIN genre g ON g.ID = mg.GENRE_ID
	WHERE mg.MOVIE_ID = m.ID
);

-- 2) Установить LENGTH фильма равным среднему LENGTH всех фильмов того же жанра
UPDATE movie m
SET LENGTH = (
	SELECT avg_len
	FROM (
			 SELECT AVG(m2.LENGTH) AS avg_len
			 FROM movie_genre mg1
					  JOIN movie_genre mg2 ON mg1.GENRE_ID = mg2.GENRE_ID
					  JOIN movie m2 ON m2.ID = mg2.MOVIE_ID
			 WHERE mg1.MOVIE_ID = m.ID
			   AND m2.ID != m.ID
		 ) AS t
)
WHERE EXISTS (
	SELECT 1
	FROM movie_genre mg
	WHERE mg.MOVIE_ID = m.ID
);

-- 3) Установить RATING фильма равным среднему RATING всех фильмов того же режиссёра
UPDATE movie m
SET RATING = (
	SELECT avg_rating
	FROM (
			 SELECT AVG(m2.RATING) AS avg_rating
			 FROM movie_crew mc1
					  JOIN movie_crew mc2 ON mc1.PERSON_ID = mc2.PERSON_ID
					  JOIN role r ON r.ID = mc1.ROLE_ID
					  JOIN movie m2 ON m2.ID = mc2.MOVIE_ID
			 WHERE r.NAME = 'Режиссер'
			   AND mc1.MOVIE_ID = m.ID
		 ) AS t
)
WHERE EXISTS (
	SELECT 1
	FROM movie_crew mc
			 JOIN role r ON r.ID = mc.ROLE_ID
	WHERE mc.MOVIE_ID = m.ID
	  AND r.NAME = 'Режиссер'
);

-- 4) Установить TITLE фильма на русском равным названию жанра
UPDATE movie_title mt
SET TITLE = (
	SELECT genre_name
	FROM (
			 SELECT g.NAME AS genre_name
			 FROM movie_genre mg
					  JOIN genre g ON g.ID = mg.GENRE_ID
			 WHERE mg.MOVIE_ID = mt.MOVIE_ID
			 LIMIT 1
		 ) AS t
)
WHERE mt.LANGUAGE_ID = 'RU'
  AND EXISTS (
	SELECT 1
	FROM movie_genre mg
	WHERE mg.MOVIE_ID = mt.MOVIE_ID
);

-- 5) Установить MIN_AGE фильма равным количеству актёров, снявшихся в фильме
UPDATE movie m
SET MIN_AGE = (
	SELECT actor_cnt
	FROM (
			 SELECT COUNT(*) AS actor_cnt
			 FROM movie_crew mc
					  JOIN role r ON r.ID = mc.ROLE_ID
					  JOIN person p ON p.ID = mc.PERSON_ID
			 WHERE r.NAME = 'Актер'
			   AND mc.MOVIE_ID = m.ID
		 ) AS t
)
WHERE EXISTS (
	SELECT 1
	FROM movie_crew mc
			 JOIN role r ON r.ID = mc.ROLE_ID
	WHERE mc.MOVIE_ID = m.ID
	  AND r.NAME = 'Актер'
);


# DELETE FROM имя_таблицы
# 	[USING элемент_FROM [, ...]]
# [WHERE условие]

-- 1) Удалить из popular_movies фильмы, id которых нет в movie
DELETE pm
FROM popular_movies pm
		 LEFT JOIN movie m ON pm.movie_id = m.ID
WHERE m.ID IS NULL;

-- 2) Удалить фильмы без русского названия
DELETE m
FROM movie m
		 LEFT JOIN movie_title mt ON mt.MOVIE_ID=m.ID and mt.LANGUAGE_ID = 'ru'
WHERE mt.MOVIE_ID IS NULL;

-- 3) Удалить фильмы с рейтингом менее 8.5
DELETE m
FROM movie m
WHERE RATING < 8.5;

-- 4) Удалить фильмы до 2003 года
DELETE m
FROM movie m
WHERE RELEASE_YEAR < 2003;

-- 5) Удалить Стивена Спилберга из таблицы person
DELETE p
FROM person p
WHERE FIRST_NAME = 'Стивен' and LAST_NAME = 'Спилберг';
