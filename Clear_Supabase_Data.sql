-- ============================================================================
-- DIVINE CLASSES: PERMANENTLY CLEAR APP RECORDS
-- Clears all testing/demo records from Supabase tables before client handover:
--   batches, students, attendance, materials, offline_tests, teachers,
--   gallery, feedbacks, notifications.
--
-- PRESERVED FOREVER (NEVER CLEARED):
--   1. external_links (educational portals and resources)
--   2. settings_config (institute contact info, passwords, URLs, payment IDs)
--   3. db_json (main snapshot key is preserved with clean arrays)
--
-- Safe to run in Supabase SQL Editor. Commits changes.
-- ============================================================================

BEGIN;

DO $clear$
DECLARE
    tbl text;
    affected_rows bigint;
    record_tables text[] := ARRAY[
        'notifications',
        'attendance',
        'offline_tests',
        'feedbacks',
        'materials',
        'students',
        'batches',
        'teachers',
        'gallery'
    ];
BEGIN
    FOREACH tbl IN ARRAY record_tables LOOP
        IF to_regclass(format('%I.%I', 'public', tbl)) IS NOT NULL THEN
            EXECUTE format('DELETE FROM %I.%I', 'public', tbl);
            GET DIAGNOSTICS affected_rows = ROW_COUNT;
            RAISE NOTICE 'Deleted % row(s) from public.%', affected_rows, tbl;
        ELSE
            RAISE NOTICE 'Skipped public.% (table not found)', tbl;
        END IF;
    END LOOP;

    -- Update wipe flags in settings_config; all other 29 settings remain intact
    IF to_regclass('public.settings_config') IS NOT NULL THEN
        UPDATE public.settings_config
        SET configured_value = CASE setting_parameter
            WHEN 'Show Dummy / Demo Data' THEN 'Off'
            WHEN 'Dummy Data Wiped' THEN 'Yes'
        END
        WHERE setting_parameter IN ('Show Dummy / Demo Data', 'Dummy Data Wiped');

        INSERT INTO public.settings_config (setting_parameter, configured_value, description)
        SELECT setting_parameter, configured_value, description
        FROM (
            VALUES
                ('Show Dummy / Demo Data', 'Off', 'Seed demo students/batches/tests visibility'),
                ('Dummy Data Wiped', 'Yes', 'Permanent clearance status before client handover')
        ) AS wipe_flags(setting_parameter, configured_value, description)
        WHERE NOT EXISTS (
            SELECT 1
            FROM public.settings_config AS existing
            WHERE existing.setting_parameter = wipe_flags.setting_parameter
        );
        RAISE NOTICE 'Updated wipe flags; external_links and all other settings_config rows are preserved.';
    END IF;

    -- Update db_json snapshot while keeping settings and externalLinks
    IF to_regclass('public.db_json') IS NOT NULL THEN
        UPDATE public.db_json AS snapshot
        SET payload =
                (
                    COALESCE(snapshot.payload::jsonb, '{}'::jsonb)
                    || jsonb_build_object(
                        'batches', '[]'::jsonb,
                        'students', '[]'::jsonb,
                        'materials', '[]'::jsonb,
                        'offlineTests', '[]'::jsonb,
                        'teachers', '[]'::jsonb,
                        'gallery', '[]'::jsonb,
                        'feedbacks', '[]'::jsonb,
                        'notifications', '[]'::jsonb,
                        'attendanceRecords', '[]'::jsonb,
                        'settings',
                            (
                                COALESCE(snapshot.payload::jsonb -> 'settings', '{}'::jsonb)
                            )
                            || jsonb_build_object(
                                'dummyDataWiped', true,
                                'showDummyData', false,
                                '_applicationDataClearEpoch', clock_timestamp()::text
                            )
                    )
                ),
            updated_at = clock_timestamp()
        WHERE snapshot_key = 'main';
        RAISE NOTICE 'Cleared record arrays in db_json; external_links and settings preserved.';
    END IF;
END;
$clear$;

COMMIT;

-- Verification: report remaining row count per table
SELECT
    table_name,
    (
        xpath(
            '/row/count/text()',
            query_to_xml(
                format('SELECT count(*) AS count FROM %I.%I', 'public', table_name),
                false,
                true,
                ''
            )
        )
    )[1]::text::bigint AS remaining_rows
FROM unnest(ARRAY[
    'teachers',
    'batches',
    'students',
    'attendance',
    'offline_tests',
    'materials',
    'gallery',
    'feedbacks',
    'notifications',
    'external_links',
    'settings_config',
    'db_json'
]) AS tables(table_name)
WHERE to_regclass(format('%I.%I', 'public', table_name)) IS NOT NULL
ORDER BY table_name;
