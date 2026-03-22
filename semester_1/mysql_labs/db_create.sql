CREATE TABLE language
(
	ID varchar(10) not null,
	NAME varchar(250) not null,
	PRIMARY KEY (ID)
);

CREATE TABLE movie
(
	ID int not null auto_increment,
	RELEASE_YEAR SMALLINT NOT NULL CHECK(RELEASE_YEAR >= 1888),
	LENGTH int NOT NULL CHECK(LENGTH > 0),
	MIN_AGE int CHECK(MIN_AGE >= 0 and MIN_AGE <= 150),
	RATING decimal(3, 1),
	PRIMARY KEY (ID)
);

CREATE TABLE movie_title
(
	LANGUAGE_ID char(2) not null,
	MOVIE_ID int not null,
	TITLE varchar(500) not null,

	PRIMARY KEY (MOVIE_ID, LANGUAGE_ID),
	FOREIGN KEY FK_MT_LANG(LANGUAGE_ID)
		REFERENCES language(ID)
		ON UPDATE CASCADE
		ON DELETE RESTRICT,
	FOREIGN KEY FK_MT_MOVIE(MOVIE_ID)
		REFERENCES movie(ID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE person
(
	ID int not null auto_increment,
	FIRST_NAME varchar(250) not null,
	MIDDLE_NAME varchar(250) not null,
	LAST_NAME varchar(250),
	PRIMARY KEY (ID)
);

CREATE TABLE role
(
	ID   int          not null auto_increment,
	NAME varchar(250) not null,
	PRIMARY KEY (ID)
);

CREATE TABLE movie_crew
(
	MOVIE_ID int not null,
	PERSON_ID int not null,
	ROLE_ID int not null,
	PRIMARY KEY (MOVIE_ID, PERSON_ID, ROLE_ID),
	FOREIGN KEY FK_MA_MOVIE (MOVIE_ID)
		REFERENCES movie(ID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY FK_MA_PERSON (PERSON_ID)
		REFERENCES person(ID)
		ON UPDATE CASCADE
		ON DELETE RESTRICT,
	FOREIGN KEY FK_MA_ROLE (ROLE_ID)
		REFERENCES role(ID)
		ON UPDATE CASCADE
		ON DELETE RESTRICT
);

CREATE TABLE genre
(
	ID int not null auto_increment,
	NAME varchar(250) not null,
	PRIMARY KEY (ID)
);

CREATE TABLE movie_genre
(
	MOVIE_ID int not null,
	GENRE_ID int not null,
	PRIMARY KEY (MOVIE_ID, GENRE_ID),
	FOREIGN KEY FK_MG_MOVIE (MOVIE_ID)
		REFERENCES movie(ID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY FK_MG_GENRE (GENRE_ID)
		REFERENCES genre(ID)
		ON UPDATE CASCADE
		ON DELETE RESTRICT
);

-- INDEXES
-- MOVIE
CREATE INDEX idx_movie_release_year ON movie(RELEASE_YEAR);
CREATE INDEX idx_movie_rating ON movie(RATING DESC);
-- MOVIE_CREW
CREATE INDEX idx_movie_crew_role ON movie_crew(ROLE_ID);
CREATE INDEX idx_movie_crew_person ON movie_crew(PERSON_ID);
-- MOVIE_GENRE
CREATE INDEX idx_movie_genre_genre ON movie_genre(GENRE_ID);
-- PERSON
CREATE INDEX idx_person_full_name ON person(LAST_NAME, FIRST_NAME);
