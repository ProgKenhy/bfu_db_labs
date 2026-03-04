-- Создание схемы
CREATE SCHEMA IF NOT EXISTS cinema;

-- LANGUAGE
CREATE TABLE cinema.language
(
    id varchar(10) PRIMARY KEY,
    name varchar(250) NOT NULL UNIQUE
);

-- MOVIE
CREATE TABLE cinema.movie
(
    id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    release_year smallint NOT NULL
        CHECK (release_year >= 1888),

    length int NOT NULL
        CHECK (length > 0 AND length <= 1000),

    min_age int
        CHECK (min_age BETWEEN 0 AND 150),

    rating numeric(3,1)
        CHECK (rating BETWEEN 0 AND 10)
);

-- PERSON
CREATE TABLE cinema.person
(
    id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    first_name varchar(250) NOT NULL,
    middle_name varchar(250),
    last_name varchar(250) NOT NULL
);

-- ROLE
CREATE TABLE cinema.role
(
    id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name varchar(250) NOT NULL UNIQUE
);

-- GENRE
CREATE TABLE cinema.genre
(
    id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name varchar(250) NOT NULL UNIQUE
);


-- MOVIE_TITLE
CREATE TABLE cinema.movie_title
(
    language_id varchar(10) NOT NULL,
    movie_id int NOT NULL,
    title varchar(500) NOT NULL,

    PRIMARY KEY (movie_id, language_id),

    CONSTRAINT fk_mt_lang
        FOREIGN KEY (language_id)
        REFERENCES cinema.language(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_mt_movie
        FOREIGN KEY (movie_id)
        REFERENCES cinema.movie(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- MOVIE_CREW
CREATE TABLE cinema.movie_crew
(
    movie_id int NOT NULL,
    person_id int NOT NULL,
    role_id int NOT NULL,

    PRIMARY KEY (movie_id, person_id, role_id),

    CONSTRAINT fk_mc_movie
        FOREIGN KEY (movie_id)
        REFERENCES cinema.movie(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_mc_person
        FOREIGN KEY (person_id)
        REFERENCES cinema.person(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_mc_role
        FOREIGN KEY (role_id)
        REFERENCES cinema.role(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- MOVIE_GENRE
CREATE TABLE cinema.movie_genre
(
    movie_id int NOT NULL,
    genre_id int NOT NULL,

    PRIMARY KEY (movie_id, genre_id),

    CONSTRAINT fk_mg_movie
        FOREIGN KEY (movie_id)
        REFERENCES cinema.movie(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_mg_genre
        FOREIGN KEY (genre_id)
        REFERENCES cinema.genre(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- INDEXES
CREATE INDEX idx_movie_release_year
    ON cinema.movie(release_year);

CREATE INDEX idx_movie_rating
    ON cinema.movie(rating DESC);

CREATE INDEX idx_movie_crew_role
    ON cinema.movie_crew(role_id);

CREATE INDEX idx_movie_crew_person
    ON cinema.movie_crew(person_id);

CREATE INDEX idx_movie_genre_genre
    ON cinema.movie_genre(genre_id);

CREATE INDEX idx_person_full_name
    ON cinema.person(last_name, first_name);