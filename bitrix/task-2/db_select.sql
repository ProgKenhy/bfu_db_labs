# поиск всех актеров, снимавшихся в конкретном фильме
EXPLAIN
SELECT mpr.PERSON_ID
FROM movie_person_role mpr
WHERE mpr.MOVIE_ID = 1
  AND mpr.ROLE_ID = 1;


# выбор режиссера конкретного фильма
EXPLAIN
SELECT mpr.PERSON_ID
FROM movie_person_role mpr
WHERE mpr.MOVIE_ID = 1
  AND mpr.ROLE_ID = 2;

# получение списка фильмов, в которых играл конкретный актер
EXPLAIN
SELECT mpr.MOVIE_ID
FROM movie_person_role mpr
WHERE mpr.PERSON_ID = 6
  AND mpr.ROLE_ID = 1;


# Найти людей, которые одновременно были режиссером и продюсером какого-либо фильма
SELECT DISTINCT mpr1.PERSON_ID
FROM movie_person_role mpr1
         JOIN movie_person_role mpr2 ON mpr1.PERSON_ID = mpr2.PERSON_ID and mpr1.MOVIE_ID = mpr2.MOVIE_ID
WHERE mpr1.ROLE_ID = 2
  and mpr2.ROLE_ID = 3;


# Найти все фильмы, имеющие двойников по названию на русском языке.
EXPLAIN
SELECT mt1.MOVIE_ID, mt2.MOVIE_ID
FROM movie_title mt1
         JOIN movie_title mt2 ON mt1.TITLE = mt2.TITLE
    AND mt1.LANGUAGE_ID = 'ru'
    AND mt2.LANGUAGE_ID = 'ru'
WHERE mt1.MOVIE_ID < mt2.MOVIE_ID;
