--  Rollen erstellen und Berechtigungen definieren
Do $$
BEGIN
    -- Rolle für Worker (Mitarbeiter)
    -- Mitarbeiter hat Schreib-, Lese-, Update- und Löschrechte auf bestimmten Tabellen
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'worker_role') THEN
        CREATE ROLE worker_role;
        GRANT SELECT, INSERT, UPDATE, DELETE ON BOOK, PERSON, LENDING, WAITLIST TO worker_role;
    END IF;

    -- Rolle für Borrower (Nutzer)
    -- Nutzer hat Leserechte für Bucher und kann Rezensionen lesen und schreiben
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'borrower_role') THEN
        CREATE ROLE borrower_role;
        GRANT SELECT ON BOOK TO borrower_role; -- Leserechte für Bücher
        GRANT SELECT, INSERT ON REVIEW TO borrower_role; ---- Rezensionen lesen und schreiben
    END IF;

    -- Rolle für Admin
    -- Diese Rolle hat Vollzugriff auf alle Tabellen
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'admin_role') THEN
        CREATE ROLE admin_role;
        GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin_role;
        GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin_role;
        GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO admin_role;
    END IF;
END $$;

-- Funktion, die Benutzer und Rollen automatisch erstellt und zuweist
CREATE OR REPLACE FUNCTION assign_user_and_role() RETURNS TRIGGER AS $$
BEGIN
    -- Benutzer erstellen, wenn noch nicht existiert
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'user_' || NEW.user_id::text) THEN
        EXECUTE format('CREATE USER %I;', 'user_' || NEW.user_id::text);
    END IF;

    -- Basierend auf die Spalte 'role' die entsprechende Role zuweisen
    IF NEW.role = 'borrower' THEN
        EXECUTE format('GRANT borrower_role TO %I;', 'user_' || NEW.user_id::text);
    ELSIF NEW.role = 'worker' THEN
        EXECUTE format('GRANT worker_role TO %I;', 'user_' || NEW.user_id::text);
    ELSIF NEW.role = 'admin' THEN
        EXECUTE format('GRANT admin_role TO %I;', 'user_' || NEW.user_id::text);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger erstellen, der nach dem Einfügen von neuen Benutzer in die person Tabelle die Funktion aufruft
CREATE TRIGGER trigger_assign_user_and_role
    AFTER INSERT ON person
    FOR EACH ROW
    EXECUTE FUNCTION assign_user_and_role();

-- Rollen bestehenden Benutzern in die Tabelle Person zuweisen
DO $$
DECLARE
    person RECORD;
BEGIN
    FOR person IN SELECT user_id, role FROM person LOOP
        -- Benutzer erstellen, falls er noch nicht existiert
        IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'user_' || person.user_id::text) THEN
            EXECUTE format('CREATE USER %I;', 'user_' || person.user_id::text);
        END IF;
        -- Basierend auf die Spalte 'role' die entsprechende Role zuweisen
        IF person.role = 'worker' THEN
            EXECUTE format('GRANT worker_role TO %I;', 'user_' || person.user_id::text);
        ELSIF person.role = 'borrower' THEN
            EXECUTE format('GRANT borrower_role TO %I;', 'user_' || person.user_id::text);
        ELSIF person.role = 'admin' THEN
            EXECUTE format('GRANT admin_role TO %I;', 'user_' || person.user_id::text);
        END IF;
    END LOOP;
END $$;

-- Sicherstellen, dass keine Berechtigungen an PUBLIC vergeben sind
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM PUBLIC;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM PUBLIC;
REVOKE ALL ON ALL FUNCTIONS IN SCHEMA public FROM PUBLIC;