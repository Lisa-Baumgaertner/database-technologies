-- Trigger und Funktionen für Rollenverwaltung entfernen
DROP TRIGGER IF EXISTS trigger_assign_user_and_role ON PERSON;
DROP FUNCTION IF EXISTS assign_user_and_role();

-- Trigger für  Tabellen entfernen
DROP TRIGGER IF EXISTS trigger_set_due_date ON LENDING;
DROP TRIGGER IF EXISTS trigger_set_return_date ON LENDING;

-- Funktionen für  Trigger entfernen
DROP FUNCTION IF EXISTS set_due_date();
DROP FUNCTION IF EXISTS set_return_date();

-- Tabellen löschen (mit CASCADE, um Abhängigkeiten zu entfernen)
DROP TABLE IF EXISTS ADDRESS CASCADE;
DROP TABLE IF EXISTS CONTACT CASCADE;
DROP TABLE IF EXISTS LENDING CASCADE;
DROP TABLE IF EXISTS REVIEW CASCADE;
DROP TABLE IF EXISTS WAITLIST CASCADE;
DROP TABLE IF EXISTS BOOK CASCADE;
DROP TABLE IF EXISTS KEYWORD CASCADE;
DROP TABLE IF EXISTS PERSON CASCADE;
DROP TABLE IF EXISTS BOOK_KEYWORD CASCADE;

-- Rollen löschen
-- Entfernen von Privilegien, bevor Rollen gelöscht werden
DO $$
    BEGIN
        -- Privilegien für admin_role entfernen
        REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM admin_role;
        REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public FROM admin_role;
        REVOKE ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public FROM admin_role;

        -- Rollen löschen
        IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'worker_role') THEN
            EXECUTE 'DROP ROLE worker_role';
        END IF;
        IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'borrower_role') THEN
            EXECUTE 'DROP ROLE borrower_role';
        END IF;
        IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'admin_role') THEN
            EXECUTE 'DROP ROLE admin_role';
        END IF;
    END $$;
