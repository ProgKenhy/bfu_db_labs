ALTER TABLE movie_person_role
	# Частые фильтрации: WHERE MOVIE_ID = ? AND ROLE_ID = ?
	ADD INDEX idx_mpr_movie_role (MOVIE_ID, ROLE_ID, PERSON_ID),
	# Частые фильтрации: WHERE PERSON_ID = ? AND ROLE_ID = ?
	ADD INDEX idx_mpr_person_role (PERSON_ID, ROLE_ID, MOVIE_ID),
	# Индекс для быстрых проверок существования записи по сочетанию (MOVIE_ID, PERSON_ID)
	ADD INDEX idx_mpr_movie_person (MOVIE_ID, PERSON_ID);

# Частые кейсы: WHERE LANGUAGE_ID = 'ru' AND TITLE = '...'
ALTER TABLE movie_title
	ADD INDEX idx_mt_lang_title (LANGUAGE_ID, TITLE(200)),
	# Для поиска по TITLE (например поиск дублей без указания языка) - индекс по TITLE
	ADD INDEX idx_mt_title (TITLE(200));

# JOIN по MOVIE_PERSON_ROLE_ID (вместе с CHARACTER_NAME - покрывающий индекс)
ALTER TABLE actor_character_name
	ADD INDEX idx_acn_mpr_name (MOVIE_PERSON_ROLE_ID, CHARACTER_NAME);

# Частые фильтры/сортировки: по году, рейтингу
ALTER TABLE movie
	ADD INDEX idx_movie_release_year (RELEASE_YEAR),
	ADD INDEX idx_movie_rating (RATING);

ALTER TABLE person
	ADD INDEX idx_person_name (NAME(200)); # для быстрых LIKE / точных сравнений
# Для поиска по роли по имени: уникальность/быстрый поиск
ALTER TABLE role
	ADD UNIQUE INDEX uq_role_name (NAME);

# Примечание: PRIMARY / UNIQUE уже индексируют ключи, поэтому не создаём такие индексы повторно.
