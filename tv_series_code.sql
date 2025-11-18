--task 2.1

CREATE VIEW top_series_cast AS
SELECT
    s.series_id,
    s.series_title,
    GROUP_CONCAT(DISTINCT a.actor_name ORDER BY a.actor_name SEPARATOR ', ') AS cast_list
FROM series s
JOIN episodes e ON s.series_id = e.series_id
JOIN actor_episode ae ON e.episode_id = ae.episode_id
JOIN actors a ON ae.actor_id = a.actor_id
WHERE s.rating >= 4
GROUP BY s.series_id, s.series_title;



--task 2.2

CREATE VIEW actor_minutes (actor_id, actor_name, total_minutes_played) AS
SELECT
    a.actor_id,
    a.actor_name,
    COALESCE(SUM(uh.minutes_played), 0) AS total_minutes_played
FROM actors a
LEFT JOIN actor_episode ae ON a.actor_id = ae.actor_id
LEFT JOIN episodes e ON ae.episode_id = e.episode_id
LEFT JOIN user_history uh ON e.episode_id = uh.episode_id
GROUP BY a.actor_id, a.actor_name;

--task 2.3
-- written with mariadb
DELIMITER $$

CREATE OR REPLACE TRIGGER AdjustRating
BEFORE INSERT ON user_history
FOR EACH ROW
BEGIN
    DECLARE episodelength FLOAT;

    SELECT episode_length
    INTO episodelength
    FROM episodes
    WHERE episodes.episode_id = NEW.episode_id;

    IF NEW.minutes_played > episodelength THEN
        SET NEW.minutes_played = episodelength;
    END IF;

    UPDATE series SET rating = rating*1.0001 WHERE series_id IN (SELECT series_id from episodes where episode_id = NEW.episode_id) AND rating < 5;
END$$

DELIMITER ;


--task 2.4
-- DROP PROCEDURE IF EXISTS AddEpisode;

DELIMITER $$

CREATE PROCEDURE AddEpisode(
    IN s_id INTEGER(10), 
    IN s_number TINYINT(4), 
    IN e_number TINYINT(4), 
    IN e_title VARCHAR(128), 
    IN e_length REAL
)
BEGIN
    IF EXISTS (SELECT 1 FROM series WHERE series_id = s_id)
    AND NOT EXISTS (SELECT 1 FROM episodes 
                    WHERE series_id = s_id 
                    AND season_number = s_number 
                    AND episode_number = e_number)
    THEN
        INSERT INTO episodes (
            series_id, 
            season_number, 
            episode_number, 
            episode_title, 
            episode_length, 
            date_of_release
        )
        VALUES (
            s_id,
            s_number,
            e_number,
            e_title,
            e_length,
            CURDATE()
        );
    END IF;
END$$

DELIMITER ;


--task 2.5
DELIMITER $$

CREATE FUNCTION GetEpisodeList(s_id INT, s_number TINYINT)
RETURNS VARCHAR(1000)
DETERMINISTIC 
BEGIN
    DECLARE ep_list VARCHAR(1000);

    SELECT GROUP_CONCAT(episode_title ORDER BY episode_number ASC SEPARATOR ', ')
        INTO ep_list
    FROM episodes
    WHERE series_id = s_id
        AND season_number = s_number; 

    RETURN ep_list; 
END $$

DELIMITER ; 
