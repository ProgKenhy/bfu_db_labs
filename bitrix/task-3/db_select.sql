# 1. Вывести список фильмов, в которых снимались одновременно Арнольд Шварценеггер* и Линда Хэмилтон*.
#   Формат: ID фильма, Название на русском языке, Имя режиссёра.
select mt.movie_ID, mt.TITLE, d.NAME
from movie_title mt
         join movie m on m.ID = mt.MOVIE_ID
         join director d on d.ID = m.DIRECTOR_ID
where mt.LANGUAGE_ID = 'ru'
  and m.ID in (select MOVIE_ID
               from movie_actor
               where ACTOR_ID = 1)
  and m.ID in (select MOVIE_ID
               from movie_actor
               where ACTOR_ID = 3);


# 2. Вывести список названий фильмов на английском языке с "откатом" на русский, в случае если название на английском не задано.
#    Формат: ID фильма, Название.
SELECT m.ID,
       COALESCE(mt_en.TITLE, mt_ru.TITLE) as TITLE
FROM movie m
         LEFT JOIN movie_title mt_en ON m.ID = mt_en.MOVIE_ID AND mt_en.LANGUAGE_ID = 'en'
         LEFT JOIN movie_title mt_ru ON m.ID = mt_ru.MOVIE_ID AND mt_ru.LANGUAGE_ID = 'ru'
ORDER BY m.ID;


# 3. Вывести самый длительный фильм Джеймса Кэмерона*.
#  Формат: ID фильма, Название на русском языке, Длительность.
# (Бонус – без использования подзапросов)
select m.ID, mt.TITLE, m.LENGTH
from movie m
         join movie_title mt on m.ID = mt.MOVIE_ID and mt.LANGUAGE_ID = 'ru'
where m.DIRECTOR_ID = 1
order by m.LENGTH desc
limit 1;


# 4. ** Вывести список фильмов с названием, сокращённым до 10 символов. Если название короче 10 символов – оставляем как есть. Если длиннее – сокращаем до 10 символов и добавляем многоточие.
#  Формат: ID фильма, сокращённое название
select m.id,
       if(char_length(mt.TITLE) > 10,
          concat(substring(mt.title, 1, 10), '...'),
          mt.TITLE) as SHORT_TITLE
from movie m
         join movie_title mt on m.ID = mt.MOVIE_ID and mt.LANGUAGE_ID = 'ru'


# 5. Вывести количество фильмов, в которых снимался каждый актёр.
#    Формат: Имя актёра, Количество фильмов актёра.
select a.NAME, count(MOVIE_ID) as MOVIE_NUMBER
from actor a
         left join movie_actor ma on ma.ACTOR_ID = a.ID
group by a.ID;

# 6. Вывести жанры, в которых никогда не снимался Арнольд Шварценеггер*.
#   Формат: ID жанра, название
select g.ID, g.NAME
from genre g
where not exists(select 1
                 from movie_genre mg
                          join movie_actor ma on ma.MOVIE_ID = mg.MOVIE_ID
                 where ma.ACTOR_ID = 1
                   and g.id = mg.GENRE_ID);


# 7. Вывести список фильмов, у которых больше 3-х жанров.
#   Формат: ID фильма, название на русском языке
select mt.MOVIE_ID, mt.TITLE
from movie_genre mg
         join movie_title mt on mg.MOVIE_ID = mt.MOVIE_ID and mt.LANGUAGE_ID = 'ru'
group by mt.MOVIE_ID, mt.TITLE
having count(mg.GENRE_ID) > 3;

# 8. Вывести самый популярный жанр для каждого актёра.
#   Формат вывода: Имя актёра, Жанр, в котором у актёра больше всего фильмов.
with actor_genre_stats as (select ma.ACTOR_ID,
                                  mg.GENRE_ID,
                                  rank() over (partition by ma.ACTOR_ID order by count(*) desc) as RANK_GENRES_SUM
                           from movie_actor ma
                                    join movie_genre mg on mg.MOVIE_ID = ma.MOVIE_ID
                           group by ma.ACTOR_ID, mg.GENRE_ID)
select a.NAME, ags.GENRE_ID
from actor_genre_stats ags
         join actor a on ags.ACTOR_ID = a.ID
where RANK_GENRES_SUM = 1;

# Если необходимо выводить только один жанр, то вместо RANK используйте ROW_NUMBER
# и доп сортировку по mg.GENRE_ID при необходимости

# Альтернативный запрос, но без использования CTE и RANK и с выводом названия жанров. Также добавил побольше алиасов и комментариев для лучшей читаемости.
select
	a.name as actor_name,
	g.name as most_popular_genre
from actor a
		 join (
	# находим максимальное количество фильмов по жанрам для каждого актёра
	select
		ma.actor_id,
		mg.genre_id,
		count(*) as movie_count
	from movie_actor ma
			 join movie_genre mg on mg.movie_id = ma.movie_id
	group by ma.actor_id, mg.genre_id
) genre_counts on genre_counts.actor_id = a.id
		 join genre g on genre_counts.genre_id = g.id
where genre_counts.movie_count = (
	# находим максимальное количество фильмов в жанре для данного актёра
	select max(sub_count.movie_count)
	from (
			 select count(*) as movie_count
			 from movie_actor ma2
					  join movie_genre mg2 on mg2.movie_id = ma2.movie_id
			 where ma2.actor_id = a.id
			 group by mg2.genre_id
		 ) sub_count
)
# убираем дубли, если несколько жанров с одинаковым максимумом (берем первый по id)
  and genre_counts.genre_id = (
	select min(genre_counts2.genre_id)
	from (
			 select
				 ma3.actor_id,
				 mg3.genre_id,
				 count(*) as movie_count
			 from movie_actor ma3
					  join movie_genre mg3 on mg3.movie_id = ma3.movie_id
			 where ma3.actor_id = a.id
			 group by ma3.actor_id, mg3.genre_id
		 ) genre_counts2
	where genre_counts2.movie_count = genre_counts.movie_count
);







