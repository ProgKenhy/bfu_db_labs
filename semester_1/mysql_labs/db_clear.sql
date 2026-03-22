-- Начало транзакции
START TRANSACTION;

-- Удаляем данные в правильном порядке (сначала дочерние таблицы)

-- 1. Удаляем из таблиц с внешними ключами (связующие таблицы)
DELETE FROM movie_crew;
DELETE FROM movie_genre;
DELETE FROM movie_title;

-- 2. Удаляем из основных таблиц
DELETE FROM movie;
DELETE FROM person;
DELETE FROM role;
DELETE FROM genre;
DELETE FROM language;

-- Сбрасываем автоинкременты
ALTER TABLE movie AUTO_INCREMENT = 1;
ALTER TABLE person AUTO_INCREMENT = 1;
ALTER TABLE role AUTO_INCREMENT = 1;
ALTER TABLE genre AUTO_INCREMENT = 1;

-- Завершаем транзакцию
COMMIT;