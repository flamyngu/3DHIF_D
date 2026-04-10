CREATE DATABASE IF NOT EXISTS tennisdb;
USE tennisdb;

DROP TABLE IF EXISTS pe_penalties;
DROP TABLE IF EXISTS m_matches;
DROP TABLE IF EXISTS t_teams;
DROP TABLE IF EXISTS p_players;

CREATE TABLE p_players (
    p_playerno       INT            NOT NULL,
    p_name           VARCHAR(50)    NOT NULL,
    p_initials       VARCHAR(10)    NOT NULL,
    p_year_of_birth  INT            NOT NULL,
    p_sex            CHAR(1)        NOT NULL,
    p_year_joined    INT            NOT NULL,
    p_street         VARCHAR(50)    NOT NULL,
    p_houseno        VARCHAR(10)    NOT NULL,
    p_postcode       VARCHAR(10)    NOT NULL,
    p_town           VARCHAR(50)    NOT NULL,
    p_phoneno        VARCHAR(20)    NOT NULL,
    p_leagueno       VARCHAR(10)    NULL,
    CONSTRAINT pk_p_players PRIMARY KEY (p_playerno),
    CONSTRAINT uq_p_players_name_initials UNIQUE (p_name, p_initials),
    CONSTRAINT uq_p_players_leagueno UNIQUE (p_leagueno),
    CONSTRAINT ck_p_players_sex CHECK (p_sex IN ('M', 'F')),
    CONSTRAINT ck_p_players_birth CHECK (p_year_of_birth BETWEEN 1900 AND 2100),
    CONSTRAINT ck_p_players_joined CHECK (p_year_joined BETWEEN p_year_of_birth AND 2100)
);

CREATE TABLE t_teams (
    t_teamno         INT            NOT NULL,
    t_p_playerno     INT            NOT NULL,
    t_division       VARCHAR(20)    NOT NULL,
    CONSTRAINT pk_t_teams PRIMARY KEY (t_teamno),
    CONSTRAINT uq_t_teams_captain UNIQUE (t_p_playerno),
    CONSTRAINT fk_t_teams_captain FOREIGN KEY (t_p_playerno)
        REFERENCES p_players (p_playerno)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE m_matches (
    m_matchno        INT            NOT NULL,
    m_t_teamno       INT            NOT NULL,
    m_p_playerno     INT            NOT NULL,
    m_won            INT            NOT NULL,
    m_lost           INT            NOT NULL,
    CONSTRAINT pk_m_matches PRIMARY KEY (m_matchno),
    CONSTRAINT fk_m_matches_team FOREIGN KEY (m_t_teamno)
        REFERENCES t_teams (t_teamno)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_m_matches_player FOREIGN KEY (m_p_playerno)
        REFERENCES p_players (p_playerno)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT ck_m_matches_nonnegative CHECK (m_won >= 0 AND m_lost >= 0),
    CONSTRAINT ck_m_matches_result CHECK (
        (m_won = 2 AND m_lost IN (0,1)) OR
        (m_won = 3 AND m_lost IN (0,1,2)) OR
        (m_lost = 2 AND m_won IN (0,1)) OR
        (m_lost = 3 AND m_won IN (0,1,2))
    )
);

CREATE TABLE pe_penalties (
    pe_paymentno     INT            NOT NULL,
    pe_p_playerno    INT            NOT NULL,
    pe_pen_date      DATE           NOT NULL,
    pe_amount        INT            NOT NULL,
    CONSTRAINT pk_pe_penalties PRIMARY KEY (pe_paymentno),
    CONSTRAINT fk_pe_penalties_player FOREIGN KEY (pe_p_playerno)
        REFERENCES p_players (p_playerno)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT ck_pe_penalties_amount CHECK (pe_amount > 0)
);
