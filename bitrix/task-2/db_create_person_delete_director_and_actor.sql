ALTER TABLE movie
    DROP FOREIGN KEY movie_ibfk_1;
# здесь FK_MOVIE_DIRECTOR выдаёт ошибку
ALTER TABLE movie
    DROP COLUMN DIRECTOR_ID;

DROP TABLE director;

DROP TABLE movie_actor;

DROP TABLE actor;


CREATE TABLE person
(
    ID int not null auto_increment,
    NAME varchar(500) not null,
    PRIMARY KEY (ID)
);


CREATE TABLE IF NOT EXISTS role
(
    ID   int          not null auto_increment,
    NAME varchar(100) not null,
    PRIMARY KEY (ID)
);


CREATE TABLE movie_person_role
(
    ID        int not null auto_increment,
    MOVIE_ID  int not null,
    PERSON_ID int not null,
    ROLE_ID   int not null,

    PRIMARY KEY (ID),
    UNIQUE KEY UK_MOVIE_PERSON_ROLE (MOVIE_ID, PERSON_ID, ROLE_ID),

    FOREIGN KEY FK_MPR_MOVIE (MOVIE_ID)
        REFERENCES movie (ID) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY FK_MPR_PERSON (PERSON_ID)
        REFERENCES person (ID) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY FK_MPR_ROLE (ROLE_ID)
        REFERENCES role (ID) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE actor_character_name
(
    MOVIE_PERSON_ROLE_ID int          not null,
    CHARACTER_NAME       varchar(256) not null,

    PRIMARY KEY (MOVIE_PERSON_ROLE_ID, CHARACTER_NAME),
    FOREIGN KEY FK_ACN_MPR (MOVIE_PERSON_ROLE_ID)
        REFERENCES movie_person_role (ID) ON UPDATE CASCADE ON DELETE CASCADE
);



