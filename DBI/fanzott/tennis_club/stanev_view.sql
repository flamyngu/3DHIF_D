USE tennisdb;

CREATE OR REPLACE VIEW v_towns AS
SELECT DISTINCT p_town
FROM p_players;

CREATE OR REPLACE VIEW v_competition_players AS
SELECT p_playerno, p_leagueno
FROM p_players
WHERE p_leagueno IS NOT NULL;

DELETE FROM p_players
WHERE p_leagueno = '7060';

CREATE OR REPLACE VIEW v_competition_player_count AS
SELECT COUNT(*) AS competition_player_count
FROM v_competition_players;

CREATE OR REPLACE VIEW v_stratford_players
(playerno, player_name, initials, year_of_birth) AS
SELECT p_playerno, p_name, p_initials, p_year_of_birth
FROM p_players
WHERE p_town = 'Stratford';

CREATE OR REPLACE VIEW v_players_per_town AS
SELECT p_town, COUNT(*) AS number_of_players
FROM p_players
GROUP BY p_town;

CREATE OR REPLACE VIEW v_veterans AS
SELECT *
FROM p_players
WHERE p_year_of_birth < 1950;

UPDATE v_veterans
SET p_year_of_birth = 1960
WHERE p_playerno = 2;

CREATE OR REPLACE VIEW v_veterans_checked AS
SELECT *
FROM p_players
WHERE p_year_of_birth < 1950
WITH CHECK OPTION;

CREATE OR REPLACE VIEW a_ages_v (playerno, begin_ages) AS
SELECT p_playerno, p_year_joined - p_year_of_birth
FROM p_players;
