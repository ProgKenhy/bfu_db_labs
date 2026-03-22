-- 1) Уникальные режиссеры (с DISTINCT)
SELECT DISTINCT p.FIRST_NAME as имя,
				p.LAST_NAME  as фамилия
FROM movie m
		 INNER JOIN movie_crew mc ON m.ID = mc.MOVIE_ID
		 INNER JOIN person p ON mc.PERSON_ID = p.ID
		 INNER JOIN role r ON mc.ROLE_ID = r.ID
WHERE r.NAME = 'Режиссер'
  AND m.RATING > 8.0;

-- 2) Все режиссеры (без DISTINCT)
SELECT p.FIRST_NAME as имя,
	   p.LAST_NAME  as фамилия
FROM movie m
		 INNER JOIN movie_crew mc ON m.ID = mc.MOVIE_ID
		 INNER JOIN person p ON mc.PERSON_ID = p.ID
		 INNER JOIN role r ON mc.ROLE_ID = r.ID
WHERE r.NAME = 'Режиссер'
  AND m.RATING > 8.0;

-- 3) Статистика по актерам: количество фильмов и средний рейтинг
SELECT p.FIRST_NAME            as имя,
	   p.LAST_NAME             as фамилия,
	   COUNT(m.ID)             as количество_фильмов,
	   ROUND(AVG(m.RATING), 2) as средний_рейтинг
FROM person p
		 LEFT JOIN movie_crew mc ON p.ID = mc.PERSON_ID
		 LEFT JOIN role r ON mc.ROLE_ID = r.ID
		 LEFT JOIN movie m ON mc.MOVIE_ID = m.ID
WHERE r.NAME = 'Актер'
GROUP BY p.ID, p.FIRST_NAME, p.LAST_NAME
HAVING COUNT(m.ID) > 1
ORDER BY количество_фильмов DESC;

-- 4) Все жанры и их фильмы с обработкой названий
SELECT g.NAME                        as жанр,
	   UPPER(LEFT(mt.TITLE, 1))      as первая_буква,
	   LOWER(SUBSTRING(mt.TITLE, 2)) as остальное_название,
	   LENGTH(mt.TITLE)              as длина_названия
FROM movie_genre mg
		 RIGHT JOIN genre g ON mg.GENRE_ID = g.ID
		 LEFT JOIN movie_title mt ON mg.MOVIE_ID = mt.MOVIE_ID
WHERE mt.LANGUAGE_ID = 'ru'
  AND LENGTH(mt.TITLE) > 5
ORDER BY g.NAME;

-- 5) Фильмы с вычислениями рейтинга
SELECT mt.TITLE            as название,
	   m.RATING            as рейтинг,
	   ROUND(m.RATING, 0)  as округленный_рейтинг,
	   POWER(m.RATING, 2)  as рейтинг_в_квадрате,
	   ABS(m.RATING - 8.0) as разница_от_восьми
FROM movie m
		 INNER JOIN movie_title mt ON m.ID = mt.MOVIE_ID
		 INNER JOIN movie_genre mg ON m.ID = mg.MOVIE_ID
		 INNER JOIN genre g ON mg.GENRE_ID = g.ID
WHERE mt.LANGUAGE_ID = 'ru'
  AND m.RATING IS NOT NULL
  AND g.NAME = 'Драма'
ORDER BY m.RATING DESC;

-- 6) Статистика по годам: фильмы и участники
SELECT m.RELEASE_YEAR               as год,
	   COUNT(DISTINCT m.ID)         as фильмы,
	   COUNT(DISTINCT mc.PERSON_ID) as участники,
	   MAX(m.RATING)                as лучший_рейтинг
FROM movie m
		 INNER JOIN movie_crew mc ON m.ID = mc.MOVIE_ID
		 INNER JOIN person p ON mc.PERSON_ID = p.ID
WHERE m.RELEASE_YEAR BETWEEN 2000 AND 2020
GROUP BY m.RELEASE_YEAR
ORDER BY год DESC;

-- 7) Фильмы и их возраст с разными типами JOIN
SELECT DISTINCT mt.TITLE                                                       as название,
	   m.RELEASE_YEAR                                                 as год_выпуска,
	   (YEAR(NOW()) - m.RELEASE_YEAR)                                 as возраст_лет,
	   CONCAT('Вышел ', (YEAR(NOW()) - m.RELEASE_YEAR), ' лет назад') as описание
FROM movie m
		 LEFT JOIN movie_title mt ON m.ID = mt.MOVIE_ID AND mt.LANGUAGE_ID = 'ru'
		 RIGHT JOIN movie_genre mg ON m.ID = mg.MOVIE_ID
WHERE (YEAR(NOW()) - m.RELEASE_YEAR) > 25
ORDER BY возраст_лет DESC;

-- 8) Топ фильмов с обработкой названий
SELECT REPLACE(mt.TITLE, ' ', ' - ') as название_с_дефисами,
	   REVERSE(mt.TITLE)             as перевернутое_название,
	   m.RATING                      as рейтинг
FROM movie m
		 INNER JOIN movie_title mt ON m.ID = mt.MOVIE_ID
		 INNER JOIN movie_genre mg ON m.ID = mg.MOVIE_ID
		 INNER JOIN genre g ON mg.GENRE_ID = g.ID
WHERE mt.LANGUAGE_ID = 'ru'
  AND m.RATING IS NOT NULL
  AND g.NAME IN ('Фантастика', 'Боевик')
ORDER BY m.RATING DESC
LIMIT 10;

-- 9) Уникальные актеры, снимавшиеся у топ-режиссеров
SELECT DISTINCT pa.FIRST_NAME as имя_актера,
				pa.LAST_NAME  as фамилия_актера,
				pr.FIRST_NAME as имя_режиссера,
				pr.LAST_NAME  as фамилия_режиссера
FROM movie_crew mca
		 INNER JOIN role ra ON mca.ROLE_ID = ra.ID
		 INNER JOIN person pa ON mca.PERSON_ID = pa.ID
		 INNER JOIN movie m ON mca.MOVIE_ID = m.ID
		 INNER JOIN movie_crew mcr ON m.ID = mcr.MOVIE_ID
		 INNER JOIN role rr ON mcr.ROLE_ID = rr.ID
		 INNER JOIN person pr ON mcr.PERSON_ID = pr.ID
WHERE ra.NAME = 'Актер'
  AND rr.NAME = 'Режиссер'
  AND m.RATING > 8.7
  AND pa.ID != pr.ID;

-- 10) Фильмы со статистикой
SELECT mt.TITLE                                         as название,
	   COUNT(DISTINCT mc2.PERSON_ID)                    as количество_участников,
	   ROUND(AVG(m.RATING), 2)                          as средний_рейтинг,
	   CONCAT(LEFT(p.FIRST_NAME, 1), '. ', p.LAST_NAME) as режиссер
FROM movie m
		 JOIN movie_title mt ON m.ID = mt.MOVIE_ID
		 JOIN movie_crew mc2 ON m.ID = mc2.MOVIE_ID
		 JOIN movie_crew mc ON m.ID = mc.MOVIE_ID
		 JOIN person p ON mc.PERSON_ID = p.ID
		 JOIN role r ON mc.ROLE_ID = r.ID
WHERE mt.LANGUAGE_ID = 'ru'
  AND r.NAME = 'Режиссер'
  AND m.RELEASE_YEAR > 2005
  AND LENGTH(mt.TITLE) > 5
GROUP BY m.ID, mt.TITLE, p.FIRST_NAME, p.LAST_NAME
ORDER BY средний_рейтинг DESC, количество_участников DESC;