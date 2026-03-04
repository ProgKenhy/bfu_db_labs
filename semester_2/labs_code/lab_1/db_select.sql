-- ЧАСТЬ 1 - 5 СКАЛЯРНЫХ ПОДЗАПРОСОВ

-- Фильм с максимальным рейтингом
select m.id, mt.title, m.rating
from cinema.movie m
join cinema.movie_title mt on m.id = mt.movie_id
where mt.language_id = 'ru'
and m.rating = (
	select max(rating)
	from cinema.movie
)

-- Фильмы выше среднего рейтинга
SELECT mt.title, m.rating
FROM cinema.movie m
JOIN cinema.movie_title mt ON m.id = mt.movie_id
WHERE mt.language_id = 'ru'
AND m.rating > (
    SELECT AVG(rating)
    FROM cinema.movie
);

-- Разница рейтинга фильма и среднего рейтинга
select
	mt.title,
	m.rating,
	m.rating - (
		select avg(rating)
		from cinema.movie
	) as difference_from_avg
from cinema.movie m
join cinema.movie_title mt on m.id = mt.movie_id
where mt.language_id = 'ru';

-- Режиссёр с максимальным количеством фильмов
select p.first_name, p.last_name
from cinema.person p
join cinema.movie_crew mc on p.id = mc.person_id
where mc.role_id = 1
group by p.id, p.first_name, p.last_name
having count(mc.movie_id) = (
	select max(cnt)
	from (
		select count(movie_id) as cnt
		from cinema.movie_crew
		where role_id = 1
		group by person_id
	) sub
);

-- Фильмы длиннее минимальной продолжительности
select mt.title, m.length
from cinema.movie m
join cinema.movie_title mt on m.id = mt.movie_id
where mt.language_id = 'ru'
and m.length > (
	select min(length)
	from cinema.movie
);

-- ЧАСТЬ 2 - 5 ТАБЛИЧНЫХ ПОДЗАПРОСОВ

-- Фильмы, где играл Леонардо ДиКаприо
select mt.title
from cinema.movie m
join cinema.movie_title mt on m.id = mt.movie_id
where mt.language_id = 'ru'
and mt.movie_id in (
	select mc.movie_id
	from cinema.movie_crew mc
	join cinema.person p on mc.person_id = p.id
	where p.last_name = 'ДиКаприо'
);

-- Фильмы без жанра "Драма"
select mt.title
from cinema.movie_title mt
where language_id = 'ru'
and mt.movie_id not in (
	select mg.movie_id
	from cinema.movie_genre mg
	join cinema.genre g on mg.genre_id = g.id
	where g.name = 'Драма'
);

-- Фильмы с рейтингом >= ANY рейтинга фильмов 2023+
 select mt.title
 from cinema.movie_title mt
 join cinema.movie m on mt.movie_id = m.id
 where mt.language_id = 'ru'
 and m.rating >= ANY (
 	select rating
 	from cinema.movie
 	where release_year >= 2023
 );

-- Самый длинный фильм (>= ALL)
select mt.title, m.length
from cinema.movie m
join cinema.movie_title mt on mt.movie_id = m.id
where mt.language_id = 'ru'
and m.length >= ALL (
	select length
	from cinema.movie
);

-- Фильмы, где есть режиссёр (EXISTS)
select mt.title
from cinema.movie_title mt
where mt.language_id = 'ru'
and exists (
	select 1
	from cinema.movie_crew mc
	where mc.movie_id = mt.movie_id
	and mc.role_id = 1
);

-- ЧАСТЬ 3 - 5 ЗАПРОСОВ С UNION / INTERSECT / EXCEPT

-- Фильмы 2010+ UNION фильмы с рейтингом > 8.5
select id from cinema.movie
where release_year >= 2010
union
select id from cinema.movie
where rating > 8.5;

-- UNION ALL (с возможными дубликатами)
select id from cinema.movie
where release_year < 2000
union all
select id from cinema.movie
where rating > 8.8;

-- INTERSECT - фильмы 2010+ и рейтинг > 8.5
select id from cinema.movie
where release_year >= 2010
intersect
select id from cinema.movie
where rating > 8.5;

-- Объединение агрегатов
select release_year, 'avg_rating' as metric, AVG(rating) as value
from cinema.movie
group by release_year
union
select release_year, 'avg_length' as metric, AVG(length)
from cinema.movie
group by release_year;