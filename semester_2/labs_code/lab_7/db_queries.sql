-- 1. Поиск сущности по ID (фильм по id)
create or replace procedure cinema.get_movie_by_id(p_id INT)
language plpgsql
as $$
begin
    raise notice 'Finding movie by ID';

    perform *
    from cinema.movie m
    join cinema.movie_title mt on mt.movie_id = m.id 
    where m.id = p_id;
end;
$$;

-- Вызов
CALL cinema.get_movie_by_id(1);

-- 2. Поиск по части названия
create or replace procedure cinema.find_movies_by_title(p_text TEXT)
language plpgsql
as $$
begin
	raise notice 'Find by name';
	
	perform 1
	from cinema.movie m
	join cinema.movie_title mt on mt.movie_id = m.id
	where mt.title ilike '%' || p_text || '%';
	
	if not found then
		raise exception 'Movie with name % does not exist', p_text;
	end if;
end;
$$;

-- вызов
call cinema.find_movies_by_title('Avatar');

-- 3. Добавление фильма с проверкой
create or replace procedure cinema.add_movie(
	p_year smallint,
	p_length int,
	p_min_age int,
	p_rating numeric
)
language plpgsql
as $$
begin
	if p_length <= 0 then
		raise exception 'Duration must be > 0';
	end if;
	
	insert into cinema.movie(release_year, length, min_age, rating)
	values (p_year, p_length, p_min_age, p_rating);
	
	raise notice 'movie added';
end;
$$;

-- вызов
CALL cinema.add_movie(2024::smallint, 120, 16, 8.2);

-- 4. Добавление жанра с проверкой
create or replace procedure cinema.add_genre(p_name TEXT)
language plpgsql
as $$
begin
	if exists (select 1 from cinema.genre where name = p_name) then
		raise notice 'Genre already exists';
	else
		insert into cinema.genre(name) values (p_name);
		raise notice 'Genre added';
	end if;
end;
$$;

-- call
call cinema.add_genre('Фантастический боевик');


-- 5. Обновление рейтинга фильма
create or replace procedure cinema.update_movie_rating(
	p_id int,
	p_rating numeric
)
language plpgsql
as $$
begin
	update cinema.movie
	set rating = p_rating
	where id = p_id;

	raise notice 'Rating updated';
end;
$$;

-- call
call cinema.update_movie_rating(1, 9.0);

-- 6. Массовое обновление (Повышает рейтинг всех слабых фильмов)
create or replace procedure cinema.boost_movies(p_limit numeric)
language plpgsql
as $$
begin
		update cinema.movie
		set rating = rating + 0.3
		where rating < p_limit;

		raise notice 'Mass update completed';
end;
$$;

-- call 
call cinema.boost_movies(7.5);

-- 7. Постраничный вывод фильмов
create or replace procedure cinema.movies_pagination(
	p_page int,
	p_size int,
	INOUT cur REFCURSOR
)
language plpgsql
as $$
begin
	open cur for
	select id, release_year, rating
	from cinema.movie
	order by id
	limit p_size
	offset (p_page - 1) * p_size;
end;
$$;

-- call
begin;
call cinema.movies_pagination(2, 5, 'c'::refcursor);
fetch all from c;
commit;

DROP PROCEDURE cinema.movies_pagination(int, int);
rollback;

-- 8. Поиск с сортировкой
CREATE OR REPLACE PROCEDURE cinema.search_movies(
    p_text TEXT,
    p_sort TEXT,
    p_order TEXT,
    INOUT cur REFCURSOR
)
LANGUAGE plpgsql
AS $$
DECLARE
    sql TEXT;
BEGIN
    -- Валидация
    IF upper(p_order) NOT IN ('ASC', 'DESC') THEN
        p_order := 'ASC';
    END IF;
    
    IF p_sort NOT IN ('id', 'title', 'rating') THEN
        p_sort := 'id';
    END IF;
    
    sql := format(
        'SELECT m.id, mt.title, m.rating
         FROM cinema.movie m
         JOIN cinema.movie_title mt ON mt.movie_id = m.id
         WHERE mt.title ILIKE %L
         ORDER BY %I %s',
        '%' || p_text || '%',
        p_sort,
        upper(p_order)
    );
    
    OPEN cur SCROLL FOR EXECUTE sql;
END;
$$;

-- Вызов процедуры
BEGIN;
CALL cinema.search_movies('криминал', 'rating', 'DESC', 'movie_cursor');
FETCH ALL FROM movie_cursor;
COMMIT;

-- Удалить старую версию процедуры
DROP PROCEDURE IF EXISTS cinema.search_movies(TEXT, TEXT, TEXT);
rollback;

-- 9. Усложненные операции вставки (INSERT для language)
create or replace procedure cinema.add_language(
	p_id varchar,
	p_name varchar
)
language plpgsql
as $$
begin

	insert into cinema.language(id, name)
	values (p_id, p_name)

	on conflict (id)
	do update set
		name = excluded.name;

	raise notice 'Язык добавлен или обновлен';

end;
$$;

-- call
call cinema.add_language('ru', 'Русский');
