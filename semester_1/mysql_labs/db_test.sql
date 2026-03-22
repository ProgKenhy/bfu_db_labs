-- Добавление фильма с годом менее 1888 (первый фильм выпущен в 1888)
INSERT INTO movie (RELEASE_YEAR, LENGTH) VALUES (1880, 120);


-- Попытка изменить role.NAME с 'Гример' на 'Актер'(уже существует)
UPDATE role SET NAME='Актер' WHERE NAME='Гример';


-- Добавление связи с фильмом, которого нет
INSERT INTO movie_genre (MOVIE_ID, GENRE_ID) VALUES (-1, 1);

-- Попытка изменить MOVIE_ID на несуществующий в movie_crew
UPDATE movie_crew SET MOVIE_ID = -1 WHERE MOVIE_ID = 1;


-- Попытка удалить язык, который используется в movie_title
DELETE FROM language where ID = 'ru';
