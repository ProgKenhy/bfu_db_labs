CREATE TABLE IF NOT EXISTS director
(
    ID int not null auto_increment,
    NAME varchar(500) not null,
    PRIMARY KEY (ID)
);

CREATE TABLE IF NOT EXISTS language
(
    ID char(2) not null,
    NAME varchar(256) not null,
    PRIMARY KEY (ID)
);

CREATE TABLE movie
(
    ID int not null auto_increment,
    RELEASE_YEAR YEAR,
    LENGTH int,
    MIN_AGE int,
    RATING float,
    DIRECTOR_ID int,

    PRIMARY KEY (ID),
    FOREIGN KEY FK_MOVIE_DIRECTOR (DIRECTOR_ID)
        REFERENCES director(ID)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
);

CREATE TABLE movie_title
(
    LANGUAGE_ID char(2) not null,
    MOVIE_ID int not null,
    TITLE varchar(500) not null,

    PRIMARY KEY (MOVIE_ID, LANGUAGE_ID),
    FOREIGN KEY FK_MT_LANG(LANGUAGE_ID)
        REFERENCES language(ID)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,
    FOREIGN KEY FK_MT_MOVIE(MOVIE_ID)
        REFERENCES movie(ID)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
);

CREATE TABLE actor
(
    ID int not null auto_increment,
    NAME varchar(500) not null,
    PRIMARY KEY (ID)
);

CREATE TABLE movie_actor
(
    MOVIE_ID int not null,
    ACTOR_ID int not null,
    PRIMARY KEY (MOVIE_ID, ACTOR_ID),
    FOREIGN KEY FK_MA_MOVIE (MOVIE_ID)
        REFERENCES movie(ID)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,
    FOREIGN KEY FK_MA_ACTOR (ACTOR_ID)
        REFERENCES actor(ID)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
);

CREATE TABLE genre
(
    ID int not null auto_increment,
    NAME varchar(500) not null,
    PRIMARY KEY (ID)
);

CREATE TABLE movie_genre
(
    MOVIE_ID int not null,
    GENRE_ID int not null,
    PRIMARY KEY (MOVIE_ID, GENRE_ID),
    FOREIGN KEY FK_MG_MOVIE (MOVIE_ID)
        REFERENCES movie(ID)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,
    FOREIGN KEY FK_MG_GENRE (GENRE_ID)
        REFERENCES genre(ID)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
);