CREATE TABLE IF NOT EXISTS director
(
    ID int not null auto_increment,
    NAME varchar(500) not null,
    PRIMARY KEY (ID)
);

CREATE TABLE movie
(
    ID int not null auto_increment,
    TITLE varchar(500) not null,
    RELEASE_YEAR YEAR,
    LENGTH int,
    MIN_AGE int,
    RATING int,

    DIRECTOR_ID int,

    PRIMARY KEY (ID),
    FOREIGN KEY FK_MOVIE_DIRECTOR (DIRECTOR_ID)
        REFERENCES director(ID)
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
