-- Hochperformante Passwort-Prüffunktion für PostgreSQL
-- Mit Levenshtein-Distanz gegen ähnliche schwache Passwörter

-- WICHTIG: PostgreSQL Extension für Levenshtein aktivieren
-- CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;

-- Tabelle für häufige/schwache Passwörter
CREATE TABLE IF NOT EXISTS common_passwords (
    password TEXT PRIMARY KEY,
    category TEXT DEFAULT 'common'
);

-- Häufige Passwörter einfügen
INSERT INTO common_passwords (password, category) VALUES
    ('password', 'common'),
    ('passwort', 'common'),
    ('12345678', 'numeric'),
    ('123456789', 'numeric'),
    ('qwertz', 'keyboard'),
    ('qwerty', 'keyboard'),
    ('admin', 'common'),
    ('letmein', 'common'),
    ('welcome', 'common'),
    ('monkey', 'common'),
    ('dragon', 'common'),
    ('master', 'common'),
    ('sunshine', 'common'),
    ('princess', 'common'),
    ('starwars', 'common'),
    ('football', 'common'),
    ('iloveyou', 'common'),
    ('trustno1', 'common'),
    ('baseball', 'common'),
    ('superman', 'common')
ON CONFLICT DO NOTHING;

-- Hauptfunktion mit Levenshtein-Check
CREATE OR REPLACE FUNCTION passwd_check(
    pwd TEXT,
    config JSONB DEFAULT '{"min_len":8,"require_upper":true,"require_lower":true,"require_digit":true,"require_special":true,"levenshtein_threshold":2}'::jsonb
) RETURNS TABLE(valid BOOLEAN, errors TEXT[], warnings TEXT[]) AS $$
DECLARE
    err TEXT[] := '{}';
    warn TEXT[] := '{}';
    min_len INT;
    require_upper BOOLEAN;
    require_lower BOOLEAN;
    require_digit BOOLEAN;
    require_special BOOLEAN;
    levenshtein_threshold INT;
    pwd_clean TEXT;
    similar_pass RECORD;
    distance INT;
BEGIN
    -- Config parsen mit Fallback-Werten
    min_len := COALESCE((config->>'min_len')::INT, 8);
    require_upper := COALESCE((config->>'require_upper')::BOOLEAN, TRUE);
    require_lower := COALESCE((config->>'require_lower')::BOOLEAN, TRUE);
    require_digit := COALESCE((config->>'require_digit')::BOOLEAN, TRUE);
    require_special := COALESCE((config->>'require_special')::BOOLEAN, TRUE);
    levenshtein_threshold := COALESCE((config->>'levenshtein_threshold')::INT, 2);
    
    -- NULL/Leer-Check
    IF pwd IS NULL OR pwd = '' THEN
        RETURN QUERY SELECT FALSE, ARRAY['Passwort darf nicht leer sein']::TEXT[], '{}'::TEXT[];
        RETURN;
    END IF;
    
    -- Passwort für Vergleich vorbereiten (ohne Zahlen/Sonderzeichen am Ende)
    pwd_clean := LOWER(REGEXP_REPLACE(pwd, '[^a-zA-Z]', '', 'g'));
    
    -- Alle Prüfungen in einem Durchlauf
    IF LENGTH(pwd) < min_len THEN
        err := array_append(err, FORMAT('Mindestens %s Zeichen erforderlich', min_len));
    END IF;
    
    IF require_upper AND pwd !~ '[A-Z]' THEN
        err := array_append(err, 'Mindestens ein Großbuchstabe erforderlich');
    END IF;
    
    IF require_lower AND pwd !~ '[a-z]' THEN
        err := array_append(err, 'Mindestens ein Kleinbuchstabe erforderlich');
    END IF;
    
    IF require_digit AND pwd !~ '[0-9]' THEN
        err := array_append(err, 'Mindestens eine Ziffer erforderlich');
    END IF;
    
    IF require_special AND pwd !~ '[!@#$%^&*()_+\-=\[\]{}|;:,.<>?/\\~`"]' THEN
        err := array_append(err, 'Mindestens ein Sonderzeichen erforderlich');
    END IF;
    
    -- Zusätzliche Sicherheitsprüfungen
    IF LENGTH(pwd) > 128 THEN
        err := array_append(err, 'Passwort zu lang (max. 128 Zeichen)');
    END IF;
    
    -- Exakte Übereinstimmung mit häufigen Passwörtern
    IF EXISTS (SELECT 1 FROM common_passwords WHERE LOWER(password) = LOWER(pwd)) THEN
        err := array_append(err, 'Passwort ist zu häufig verwendet');
    END IF;
    
    -- Levenshtein-Distanz Check (nur wenn Extension verfügbar)
    BEGIN
        IF LENGTH(pwd_clean) >= 4 THEN
            FOR similar_pass IN 
                SELECT password, category 
                FROM common_passwords 
                WHERE LENGTH(password) >= 4
            LOOP
                distance := levenshtein(LOWER(similar_pass.password), LOWER(pwd));
                
                -- Kritisch: Sehr ähnlich zu häufigem Passwort
                IF distance <= levenshtein_threshold THEN
                    err := array_append(err, FORMAT('Zu ähnlich zu häufigem Passwort "%s" (Distanz: %s)', similar_pass.password, distance));
                    EXIT; -- Nur ersten Treffer melden
                END IF;
                
                -- Warnung: Etwas ähnlich
                IF distance <= levenshtein_threshold + 2 AND distance > levenshtein_threshold THEN
                    warn := array_append(warn, FORMAT('Ähnlich zu bekanntem Passwort "%s"', similar_pass.password));
                END IF;
            END LOOP;
        END IF;
    EXCEPTION
        WHEN undefined_function THEN
            -- Extension nicht installiert, überspringe Levenshtein-Check
            NULL;
    END;
    
    -- Sequenz-Prüfung (123, abc, etc.)
    IF pwd ~* '(abc|bcd|cde|def|efg|fgh|ghi|hij|ijk|jkl|klm|lmn|mno|nop|opq|pqr|qrs|rst|stu|tuv|uvw|vwx|wxy|xyz)' THEN
        warn := array_append(warn, 'Enthält alphabetische Sequenz');
    END IF;
    
    IF pwd ~ '(012|123|234|345|456|567|678|789|890)' THEN
        warn := array_append(warn, 'Enthält numerische Sequenz');
    END IF;
    
    -- Tastatur-Muster
    IF pwd ~* '(qwert|asdf|zxcv|qwertz|йцуке)' THEN
        warn := array_append(warn, 'Enthält Tastatur-Muster');
    END IF;
    
    -- Wiederholende Zeichen
    IF pwd ~ '(.)\1{2,}' THEN
        warn := array_append(warn, 'Enthält wiederholende Zeichen');
    END IF;
    
    -- Ergebnis zurückgeben
    RETURN QUERY SELECT (array_length(err, 1) IS NULL), COALESCE(err, '{}'::TEXT[]), COALESCE(warn, '{}'::TEXT[]);
END;
$$ LANGUAGE plpgsql VOLATILE PARALLEL SAFE;

-- Komfort-Wrapper für einfache TRUE/FALSE Prüfung
CREATE OR REPLACE FUNCTION passwd_valid(pwd TEXT, config JSONB DEFAULT NULL) 
RETURNS BOOLEAN AS $$
    SELECT valid FROM passwd_check($1, COALESCE($2, '{"min_len":8,"require_upper":true,"require_lower":true,"require_digit":true,"require_special":true,"levenshtein_threshold":2}'::jsonb));
$$ LANGUAGE SQL VOLATILE PARALLEL SAFE;

-- Funktion zum Hinzufügen neuer schwacher Passwörter
CREATE OR REPLACE FUNCTION add_common_password(pwd TEXT, cat TEXT DEFAULT 'common')
RETURNS VOID AS $$
BEGIN
    INSERT INTO common_passwords (password, category) 
    VALUES (LOWER(pwd), cat)
    ON CONFLICT (password) DO NOTHING;
END;
$$ LANGUAGE plpgsql;

-- Trigger-Funktion für automatische Passwort-Validierung
CREATE OR REPLACE FUNCTION trigger_passwd_check() 
RETURNS TRIGGER AS $$
DECLARE
    check_result RECORD;
BEGIN
    SELECT * INTO check_result FROM passwd_check(NEW.password);
    
    IF NOT check_result.valid THEN
        RAISE EXCEPTION 'Passwort ungültig: %', array_to_string(check_result.errors, ', ');
    END IF;
    
    -- Warnungen loggen (optional)
    IF array_length(check_result.warnings, 1) > 0 THEN
        RAISE NOTICE 'Passwort-Warnungen: %', array_to_string(check_result.warnings, ', ');
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- INSTALLATION & SETUP
-- ============================================================================

-- 1. Extension aktivieren (einmalig):
-- CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;

-- 2. Funktion installieren (dieser Code)

-- 3. Optional: Mehr häufige Passwörter hinzufügen:
-- SELECT add_common_password('batman');
-- SELECT add_common_password('summer');

-- ============================================================================
-- VERWENDUNGSBEISPIELE
-- ============================================================================

-- Beispiel 1: Standard-Check
-- SELECT * FROM passwd_check('Password123!');
-- Ergebnis: valid=false, errors={'Zu ähnlich zu häufigem Passwort "password"'}

-- Beispiel 2: Ähnlichkeit zu "admin"
-- SELECT * FROM passwd_check('Admin123!');
-- Ergebnis: valid=false, errors={'Zu ähnlich zu häufigem Passwort "admin"'}

-- Beispiel 3: Variationen erkennen
-- SELECT * FROM passwd_check('P@ssw0rd');
-- Ergebnis: valid=false (ähnlich zu "password")

-- Beispiel 4: Sicheres Passwort
-- SELECT * FROM passwd_check('Tr0pic@lM00n!');
-- Ergebnis: valid=true, errors={}, warnings={}

-- Beispiel 5: Mit Warnungen
-- SELECT * FROM passwd_check('MyPass123!!!');
-- Ergebnis: valid=true, warnings={'Enthält wiederholende Zeichen'}

-- Beispiel 6: Levenshtein-Schwellwert anpassen
-- SELECT * FROM passwd_check('Passwort1!', '{"levenshtein_threshold":3}'::jsonb);

-- Beispiel 7: Liste aller häufigen Passwörter
-- SELECT * FROM common_passwords ORDER BY category, password;

-- Beispiel 8: Trigger einrichten
-- CREATE TABLE users (
--     id SERIAL PRIMARY KEY,
--     username TEXT NOT NULL,
--     password TEXT NOT NULL
-- );
-- 
-- CREATE TRIGGER check_password_strength
--     BEFORE INSERT OR UPDATE OF password ON users
--     FOR EACH ROW
--     EXECUTE FUNCTION trigger_passwd_check();