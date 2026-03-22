INSERT INTO movie_title (MOVIE_ID, LANGUAGE_ID, TITLE)
SELECT ID,
       'ru' as LANGUAGE_ID,
       TITLE
FROM movie;
