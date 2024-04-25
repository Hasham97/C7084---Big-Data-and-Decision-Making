-- Find all songs by a given artist
SELECT *
FROM "Songs"
WHERE "album_id" IN (
    SELECT "album_id"
    FROM "Albums"
    WHERE "artist_id" = (
        SELECT "artist_id"
        FROM "Artists"
        WHERE "name" = 'Artist Name'
    )
);

-- Find all albums released by a given artist
SELECT *
FROM "Albums"
WHERE "artist_id" = (
    SELECT "artist_id"
    FROM "Artists"
    WHERE "name" = 'Artist Name'
);

-- Find all songs in a given genre
SELECT *
FROM "Songs"
WHERE "Genre" = 'Genre Name';

-- Find all songs in a given playlist
SELECT "Songs".*
FROM "playlist_songs"
JOIN "Songs" ON "playlist_songs"."song_id" = "songs"."song_id"
WHERE "playlist_id" = (
    SELECT "playlist_id"
    FROM "Playlists"
    WHERE "name" = 'Playlist Name'
);

-- Add a new artist
INSERT INTO "Artists" ("name")
VALUES ('New Artist Name');

-- Add a new album
INSERT INTO "Albums" ("title", "artist_id", "release_date")
VALUES ('New Album Title', 1, 'YYYY-MM-DD');

-- Add a new song
INSERT INTO "Songs" ("title", "album_id", "Genre", "duration")
VALUES ('New Song Title', 1, 'Genre Name', 180);

-- Create a new playlist
INSERT INTO "Playlists" ("name")
VALUES ('New Playlist Name');

-- Add a song to a playlist
INSERT INTO "playlist_songs" ("playlist_id", "song_id")
VALUES (1, 1);

-- Some interesting queries

-- Add a new artist if it doesn't already exist, otherwise, retrieve the artist's ID.
INSERT INTO "Artists" ("name")
SELECT 'New Artist Name'
WHERE NOT EXISTS (
    SELECT 1
    FROM "Artists"
    WHERE "name" = 'New Artist Name'
)
RETURNING "artist_id";

-- Add a new song if it doesn't already exist in a given album, otherwise, retrieve the song's ID.
WITH album_data AS (
    SELECT "album_id"
    FROM "Albums"
    WHERE "title" = 'Existing Album Title'
)
INSERT INTO "Songs" ("title", "album_id", "Genre", "duration")
SELECT 'New Song Title', "album_id", 'Genre Name', 180
FROM album_data
WHERE NOT EXISTS (
    SELECT 1
    FROM "Songs"
    WHERE "title" = 'New Song Title'
    AND "album_id" = (SELECT "album_id" FROM album_data)
)
RETURNING "song_id";

-- Find all songs released by an artist whose name starts with 'The' and has at least 
-- 5 albums.
SELECT "Songs".*
FROM "Songs"
JOIN "Albums" ON "Songs"."album_id" = "Albums"."album_id"
JOIN "Artists" ON "Albums"."artist_id" = "Artists"."artist_id"
WHERE "Artists"."name" LIKE 'The%'
GROUP BY "Songs"."song_id"
HAVING COUNT(DISTINCT "Albums"."album_id") >= 5;

-- Find all albums released by artists who have songs in the 'Rock' genre and 
-- also in the 'Pop' genre.
SELECT DISTINCT "Albums".*
FROM "Albums"
JOIN "Songs" ON "Albums"."album_id" = "Songs"."album_id"
JOIN "Artists" ON "Albums"."artist_id" = "Artists"."artist_id"
WHERE "Artists"."artist_id" IN (
    SELECT "artist_id"
    FROM "Songs"
    WHERE "Genre" = 'Rock'
)
AND "Artists"."artist_id" IN (
    SELECT "artist_id"
    FROM "Songs"
    WHERE "Genre" = 'Pop'
);

-- Add a new album if it doesn't already exist for a given artist, otherwise, 
-- retrieve the album's ID.
WITH artist_data AS (
    SELECT "artist_id"
    FROM "Artists"
    WHERE "name" = 'Existing Artist Name'
)
INSERT INTO "Albums" ("title", "artist_id", "release_date")
SELECT 'New Album Title', "artist_id", 'YYYY-MM-DD'
FROM artist_data
WHERE NOT EXISTS (
    SELECT 1
    FROM "Albums"
    WHERE "title" = 'New Album Title'
    AND "artist_id" = (SELECT "artist_id" FROM artist_data)
)
RETURNING "album_id";
