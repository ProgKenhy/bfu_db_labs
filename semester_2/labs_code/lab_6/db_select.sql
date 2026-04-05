-- 1. Фильмы на русском
create view russian_movies as
select
	m.id,
	mt.title,
	m.release_year,
	m.rating,
	m.length 
from cinema.movie m
join cinema.movie_title mt on m.id = mt.movie_id
where mt.language_id = 'ru';

-- 2. Фильмы после 2010
create view modern_movies as
select *
from russian_movies
where release_year > 2010;

-- 3. Фильмы + жанры
create view movies_with_genres as
select
	m.id,
	mt.title,
	g.name as genre, 
	m.rating
from cinema.movie m
join cinema.movie_title mt on m.id = mt.movie_id
join cinema.movie_genre mg on m.id = mg.movie_id
join cinema.genre g on g.id = mg.genre_id
where mt.language_id = 'ru';

-- 4. Количество фильмов по жанрам
create view genre_movie_count as 
select
	g.name as genre,
	count(*) as movie_count
from cinema.genre g
join cinema.movie_genre mg on g.id = mg.genre_id
group by g.name;

-- Использование представлений
select * from genre_movie_count order by movie_count desc;

-- 5. Средний рейтинг по годам
create view avg_rating_by_year as
select
	release_year,
	avg(rating) as avg_rating
from cinema.movie
group by release_year;

-- 6. Топ фильмы (рейтинг > 8)
create view top_movies as
select
	m.id,
	mt.title,
	m.rating
from cinema.movie m
join cinema.movie_title mt on m.id = mt.movie_id
where mt.language_id = 'ru' and m.rating > 8;

-- Изменение представления
create or replace view top_movies as
select
	m.id,
	mt.title,
	m.rating
from cinema.movie m
join cinema.movie_title mt on m.id = mt.movie_id
where mt.language_id = 'ru' and m.rating > 7.5;

-- Использование представлений
select * from top_movies;

-- 7. Длинные фильмы на русском
create view long_movies as
select *
from russian_movies
where length > 180;

-- 8. Kороткие фильмы на русском
create view short_movies as
select *
from russian_movies
where length < 160;

-- Удаление представления
drop view short_movies;

-- 9. Представление с CHECK OPTION (обновляемое)
create view high_rating_movies as
select
	m.id,
	m.rating
from cinema.movie m
where m.rating >= 7
with check option;

-- Пример обновляемого VIEW
update high_rating_movies
set rating = 8.5
where id = 1;

select * from high_rating_movies
where id = 1;

-- 10. Фильмы + отклонение от среднего
create view rating_diff as
select
	m.id,
	m.release_year,
	m.rating,
	m.rating - avg(m.rating) over (partition by m.release_year) as diff
from cinema.movie m;





























