-- Create Artists table
CREATE TABLE "Artists" (
    artist_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

-- Add artists with songs in 'Rock' and 'Pop' genres to the Artists table
INSERT INTO "Artists" ("name")
VALUES ('Artist RockPop1'),
       ('Artist RockPop2');

-- Add The Beatles to the Artists table
INSERT INTO "Artists" ("name")
VALUES ('The Beatles');

-- Create Albums table
CREATE TABLE "Albums" (
    album_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    artist_id INTEGER NOT NULL,
    release_date TEXT,
    FOREIGN KEY (artist_id) REFERENCES Artists(artist_id)
);


-- Add albums for artists with songs in 'Rock' and 'Pop' genres
INSERT INTO "Albums" ("title", "artist_id", "release_date")
VALUES ('Album RockPop1', 
(SELECT "artist_id" 
FROM "Artists" WHERE "name" = 'Artist RockPop1'), 'YYYY-MM-DD'),
('Album RockPop2', 
(SELECT "artist_id" FROM "Artists" WHERE "name" = 'Artist RockPop2'), 'YYYY-MM-DD');

-- Add albums for The Beatles
INSERT INTO "Albums" ("title", "artist_id", "release_date")
VALUES ('Album 1', (SELECT "artist_id" FROM "Artists" WHERE "name" = 'The Beatles'), 'YYYY-MM-DD');

-- Create Songs table
CREATE TABLE "Songs" (
    song_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    album_id INTEGER NOT NULL,
    genre TEXT,
    duration INTEGER,
    FOREIGN KEY (album_id) REFERENCES Albums(album_id)
);

-- Add songs to the albums
INSERT INTO "Songs" ("title", "album_id", "Genre", "duration")
VALUES ('Song 1', (SELECT "album_id" FROM "Albums" WHERE "title" = 'Album 1'), 'Genre', 180),
       ('Song 2', (SELECT "album_id" FROM "Albums" WHERE "title" = 'Album 1'), 'Genre', 200);


-- Add songs in 'Rock' genre for the first artist
INSERT INTO "Songs" ("title", "album_id", "Genre", "duration")
VALUES ('Rock Song 1', (SELECT "album_id" FROM "Albums" WHERE "title" = 'Album RockPop1'), 'Rock', 180),
       ('Rock Song 2', (SELECT "album_id" FROM "Albums" WHERE "title" = 'Album RockPop1'), 'Rock', 200);

-- Add songs in 'Pop' genre for the second artist
INSERT INTO "Songs" ("title", "album_id", "Genre", "duration")
VALUES ('Pop Song 1', (SELECT "album_id" FROM "Albums" WHERE "title" = 'Album RockPop2'), 'Pop', 180),
       ('Pop Song 2', (SELECT "album_id" FROM "Albums" WHERE "title" = 'Album RockPop2'), 'Pop', 200);

-- Add songs for the albums
INSERT INTO "Songs" ("title", "album_id", "Genre", "duration")
VALUES ('Song 1', (SELECT "album_id" FROM "Albums" WHERE "title" = 'Album 1'), 'Genre', 180),
       ('Song 2', (SELECT "album_id" FROM "Albums" WHERE "title" = 'Album 1'), 'Genre', 200
       );

-- Create Genre table
CREATE TABLE "Genre" (
    genre_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

-- Create Playlists table
CREATE TABLE "Playlists" (
    playlist_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

-- Create PlaylistSongs table to establish many-to-many relationship between 
-- Playlists and Songs
CREATE TABLE "PlaylistSongs" (
    playlist_id INTEGER,
    song_id INTEGER,
    FOREIGN KEY (playlist_id) REFERENCES Playlists(playlist_id),
    FOREIGN KEY (song_id) REFERENCES Songs(song_id),
    PRIMARY KEY (playlist_id, song_id)
);
