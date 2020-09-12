DROP DATABASE IF EXISTS isuumo;
CREATE DATABASE isuumo;

DROP TABLE IF EXISTS isuumo.estate;
DROP TABLE IF EXISTS isuumo.chair;

CREATE TABLE isuumo.estate
(
    id          INTEGER             NOT NULL PRIMARY KEY,
    name        VARCHAR(64)         NOT NULL,
    description VARCHAR(4096)       NOT NULL,
    thumbnail   VARCHAR(128)        NOT NULL,
    address     VARCHAR(128)        NOT NULL,
    latitude    DOUBLE PRECISION    NOT NULL,
    longitude   DOUBLE PRECISION    NOT NULL,
    rent        INTEGER             NOT NULL,
    door_height INTEGER             NOT NULL,
    door_width  INTEGER             NOT NULL,
    features    VARCHAR(64)         NOT NULL,
    popularity  INTEGER             NOT NULL
);

CREATE TABLE isuumo.chair
(
    id          INTEGER         NOT NULL PRIMARY KEY,
    name        VARCHAR(64)     NOT NULL,
    description VARCHAR(4096)   NOT NULL,
    thumbnail   VARCHAR(128)    NOT NULL,
    price       INTEGER         NOT NULL,
    height      INTEGER         NOT NULL,
    width       INTEGER         NOT NULL,
    depth       INTEGER         NOT NULL,
    color       VARCHAR(64)     NOT NULL,
    features    VARCHAR(64)     NOT NULL,
    kind        VARCHAR(64)     NOT NULL,
    popularity  INTEGER         NOT NULL,
    stock       INTEGER         NOT NULL
);

CREATE INDEX chair_price_asc_id_asc ON isuumo.chair(price ASC,id ASC);
CREATE INDEX estate_rent_asc_id_asc ON isuumo.estate(rent ASC,id ASC);
CREATE INDEX estate_popularity_id ON isuumo.estate(popularity DESC, id ASC);
CREATE INDEX estate_latitude_longitude ON isuumo.estate(latitude, longitude);
CREATE INDEX estate_latitude_longitude_popularity_id ON isuumo.estate(latitude, longitude, popularity DESC, id ASC);

CREATE INDEX chair_price ON isuumo.chair(price);
CREATE INDEX chair_height ON isuumo.chair(height);
CREATE INDEX chair_width ON isuumo.chair(width);
CREATE INDEX chair_depth ON isuumo.chair(depth);
CREATE INDEX chair_kind ON isuumo.chair(kind);
CREATE INDEX chair_color ON isuumo.chair(color);

CREATE INDEX estate_door_height ON isuumo.estate(door_height);
CREATE INDEX estate_door_width ON isuumo.estate(door_width);
CREATE INDEX estate_rent ON isuumo.estate(rent);
CREATE INDEX estate_door_height_door_width ON isuumo.estate(door_height, door_width);
CREATE INDEX estate_door_width_rent ON isuumo.estate(door_width, rent);
CREATE INDEX estate_door_door_height_door_width_rent ON isuumo.estate(door_height, door_width, rent);
