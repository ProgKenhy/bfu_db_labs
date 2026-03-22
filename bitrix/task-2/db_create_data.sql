INSERT INTO language (ID, NAME)
VALUES ('ru', 'Русский'),
       ('en', 'English');

INSERT INTO person (NAME)
VALUES ('Кристофер Нолан'),
       ('Стивен Спилберг'),
       ('Квентин Тарантино'),
       ('Джеймс Кэмерон'),
       ('Роберт Родригес'),
       ('Леонардо ДиКаприо'),
       ('Мэттью Макконахи'),
       ('Энн Хэтэуэй'),
       ('Том Хэнкс'),
       ('Сэмюэл Л. Джексон'),
       ('Сигурни Уивер'),
       ('Кэтрин Кеннеди'),
       ('Джерри Брукхаймер');

INSERT INTO movie (RELEASE_YEAR, LENGTH, MIN_AGE, RATING)
VALUES (2010, 148, 16, 8.8),
       (2014, 169, 12, 8.6),
       (1994, 154, 18, 8.9),
       (1998, 170, 12, 7.9),
       (2005, 126, 16, 7.2),
       (1993, 195, 12, 8.8);

INSERT INTO movie_title (LANGUAGE_ID, MOVIE_ID, TITLE)
VALUES ('ru', 1, 'Начало'),
       ('en', 1, 'Inception'),
       ('ru', 2, 'Интерстеллар'),
       ('en', 2, 'Interstellar'),
       ('ru', 3, 'Криминальное чтиво'),
       ('en', 3, 'Pulp Fiction'),
       ('ru', 4, 'Перекресток'),
       ('en', 4, 'Crossroads'),
       ('ru', 5, 'Перекресток'),
       ('en', 5, 'Perckrestok'),
       ('ru', 6, 'Парк юрского периода'),
       ('en', 6, 'Jurassic Park');

INSERT INTO role (NAME)
VALUES ('actor'),
       ('director'),
       ('producer'),
       ('writer'),
       ('composer');

INSERT INTO movie_person_role (MOVIE_ID, PERSON_ID, ROLE_ID)
VALUES (1, 1, 2),
       (1, 6, 1),
       (1, 1, 3),
       (2, 1, 2),
       (2, 7, 1),
       (2, 8, 1),
       (3, 3, 2),
       (3, 10, 1),
       (3, 3, 1),
       (4, 4, 2),
       (4, 5, 3),
       (5, 13, 3),
       (6, 2, 2),
       (6, 2, 3),
       (6, 12, 3);

INSERT INTO actor_character_name (MOVIE_PERSON_ROLE_ID, CHARACTER_NAME)
VALUES (2, 'Дом Кобб'),
       (5, 'Джозеф Купер'),
       (6, 'Амелия Бренд'),
       (8, 'Джулс Виннфилд'),
       (9, 'Джимми Диммик'),
       (5, 'Джозеф Купер в будущем');

INSERT INTO movie (RELEASE_YEAR, LENGTH, MIN_AGE, RATING)
VALUES (2018, 120, 16, 7.1),
       (2020, 115, 12, 6.8);

INSERT INTO movie_title (LANGUAGE_ID, MOVIE_ID, TITLE)
VALUES ('ru', 7, 'Тень'),
       ('en', 7, 'Shadow'),
       ('ru', 8, 'Тень'),
       ('en', 8, 'The Shadow');

INSERT INTO movie_person_role (MOVIE_ID, PERSON_ID, ROLE_ID)
VALUES (7, 6, 1),
       (7, 6, 3),
       (8, 8, 1);