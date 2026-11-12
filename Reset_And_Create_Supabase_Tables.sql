-- ============================================================================
-- WARNING: DESTRUCTIVE SCHEMA RESET
-- Running this script in the Supabase SQL Editor will DROP all existing
-- app tables and views (deleting all rows currently stored in Supabase)
-- and recreate ONLY the 12 clean, required core tables.
-- ============================================================================

BEGIN;

-- 1. Drop all old views (if any)
DROP VIEW IF EXISTS
    public.attendance_register,
    public.batches_roster,
    public.external_links_hub,
    public.feedback_responses,
    public.gallery_banners,
    public.materials_repository,
    public.offline_test_marks,
    public.settings,
    public.students_master,
    public.teachers_roster
CASCADE;

-- 2. Drop all old tables (if any)
DROP TABLE IF EXISTS
    public.attendance,
    public.notifications,
    public.feedbacks,
    public.external_links,
    public.gallery,
    public.offline_tests,
    public.materials,
    public.students,
    public.batches,
    public.teachers,
    public.settings_config,
    public.db_json
CASCADE;

-- 3. Create the 12 required core tables

CREATE TABLE public.teachers (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL DEFAULT '',
    subject TEXT DEFAULT '',
    qualification TEXT DEFAULT '',
    experience TEXT DEFAULT '',
    email TEXT DEFAULT '',
    phone TEXT DEFAULT '',
    specialization TEXT DEFAULT '',
    bio TEXT DEFAULT '',
    initials TEXT DEFAULT '',
    password TEXT DEFAULT 'teacher123',
    status TEXT DEFAULT 'Active',
    photo TEXT DEFAULT '',
    avatar_color TEXT DEFAULT 'bg-slate-600'
);

CREATE TABLE public.batches (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL DEFAULT '',
    subject TEXT DEFAULT '',
    schedule TEXT DEFAULT '',
    room TEXT DEFAULT '',
    teacher TEXT DEFAULT '',
    student_ids JSONB NOT NULL DEFAULT '[]'::jsonb
);

CREATE TABLE public.students (
    id TEXT PRIMARY KEY,
    roll TEXT DEFAULT '',
    name TEXT NOT NULL DEFAULT '',
    phone TEXT DEFAULT '',
    parent_name TEXT DEFAULT '',
    total_fee NUMERIC DEFAULT 0,
    paid_fee NUMERIC DEFAULT 0,
    monthly_fee NUMERIC DEFAULT 0,
    due_date TEXT DEFAULT '',
    last_reminder TEXT DEFAULT '-',
    password TEXT DEFAULT 'password123',
    status TEXT DEFAULT 'Active',
    admission_date TEXT DEFAULT '',
    batch_id TEXT DEFAULT '',
    photo TEXT DEFAULT ''
);

CREATE TABLE public.attendance (
    id TEXT PRIMARY KEY,
    date TEXT NOT NULL,
    batch_id TEXT NOT NULL,
    student_id TEXT NOT NULL,
    status TEXT NOT NULL,
    marked_by TEXT DEFAULT '',
    updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE public.offline_tests (
    id TEXT PRIMARY KEY,
    batch_id TEXT DEFAULT '',
    name TEXT DEFAULT '',
    title TEXT NOT NULL DEFAULT '',
    subject TEXT DEFAULT '',
    date TEXT DEFAULT '',
    test_date TEXT DEFAULT '',
    max_marks NUMERIC DEFAULT 100,
    marks JSONB NOT NULL DEFAULT '{}'::jsonb,
    results JSONB NOT NULL DEFAULT '[]'::jsonb,
    is_dummy BOOLEAN DEFAULT false
);

CREATE TABLE public.materials (
    id TEXT PRIMARY KEY,
    batch_id TEXT DEFAULT '',
    batch_name TEXT DEFAULT '',
    title TEXT NOT NULL DEFAULT '',
    subject TEXT DEFAULT '',
    category TEXT DEFAULT '',
    type TEXT DEFAULT 'PDF',
    date TEXT DEFAULT '',
    upload_date TEXT DEFAULT '',
    uploaded_by TEXT DEFAULT '',
    file_size TEXT DEFAULT '',
    downloads INTEGER DEFAULT 0,
    description TEXT DEFAULT '',
    download_url TEXT DEFAULT '',
    drive_url TEXT DEFAULT ''
);

CREATE TABLE public.external_links (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL DEFAULT '',
    provider TEXT DEFAULT '',
    subject TEXT DEFAULT '',
    url TEXT NOT NULL DEFAULT '',
    drive_url TEXT DEFAULT '',
    description TEXT DEFAULT '',
    date_added TEXT DEFAULT '',
    category TEXT DEFAULT ''
);

-- Seed initial external links with all columns matching External_Links_Hub
INSERT INTO public.external_links (id, title, provider, subject, url, drive_url, description, date_added, category) VALUES
('l1', 'DIKSHA / NCERT Official Portal - Free e-Textbooks (Class 1-12)', 'NCERT & Ministry of Education', 'Physics, Chemistry, Maths, Biology', 'https://diksha.gov.in/', '', 'Official national digital repository with authentic chapter-by-chapter NCERT books, exemplars, and interactive study modules.', '', 'NCERT & Ministry of Education'),
('l2', 'National Digital Library of India (NDLI)', 'Ministry of Education & IIT Kharagpur', 'JEE / NEET / Olympiad', 'https://www.ndl.gov.in/', '', 'Vast repository of video lectures, solved past question archives, and academic monographs.', '', 'Ministry of Education & IIT Kharagpur'),
('l3', 'Khan Academy India - Concept Mastery Modules', 'Khan Academy', 'Foundation Science & Calculus', 'https://www.khanacademy.org/', '', 'Bite-sized visual lessons, step-by-step calculus proofs, and interactive diagnostic quizzes.', '', 'Khan Academy'),
('l4', 'PhET Interactive STEM Laboratory Simulations', 'University of Colorado Boulder', 'Physics & Chemistry Labs', 'https://phet.colorado.edu/', '', 'Experiment with electrical circuits, wave interference, photo-electric effect, and chemical titrations virtually.', '', 'University of Colorado Boulder'),
('l5', 'CBSE Official Examination Portal - Syllabus & Question Banks', 'CBSE Board', 'Class 10th & 12th Board Exams', 'https://www.cbse.gov.in/', '', 'Official latest board examination blue-prints, competency-focused question banks, curriculum circulars, and answer rubrics.', '', 'CBSE Board')
ON CONFLICT (id) DO UPDATE
SET title = EXCLUDED.title,
    provider = EXCLUDED.provider,
    subject = EXCLUDED.subject,
    url = EXCLUDED.url,
    drive_url = EXCLUDED.drive_url,
    description = EXCLUDED.description,
    date_added = EXCLUDED.date_added,
    category = EXCLUDED.category;

CREATE TABLE public.gallery (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL DEFAULT '',
    category TEXT DEFAULT '',
    date TEXT DEFAULT '',
    caption TEXT DEFAULT '',
    badge TEXT DEFAULT '',
    url TEXT DEFAULT '',
    image_url TEXT DEFAULT ''
);

CREATE TABLE public.feedbacks (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL DEFAULT '',
    message TEXT NOT NULL DEFAULT '',
    rating INTEGER DEFAULT 5,
    created_at TEXT DEFAULT '',
    batch TEXT DEFAULT '',
    role TEXT DEFAULT '',
    category TEXT DEFAULT '',
    read BOOLEAN DEFAULT false
);

CREATE TABLE public.notifications (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL DEFAULT '',
    message TEXT DEFAULT '',
    time TEXT DEFAULT '',
    timestamp BIGINT DEFAULT 0,
    read BOOLEAN DEFAULT false,
    admin_seen BOOLEAN DEFAULT false,
    type TEXT DEFAULT 'info',
    icon TEXT DEFAULT '',
    icon_color TEXT DEFAULT '',
    bg_color TEXT DEFAULT '',
    action_tab TEXT DEFAULT '',
    target_role TEXT DEFAULT '',
    material_id TEXT DEFAULT '',
    batch_name TEXT DEFAULT ''
);

CREATE TABLE public.settings_config (
    setting_parameter TEXT PRIMARY KEY,
    configured_value TEXT DEFAULT '',
    description TEXT DEFAULT ''
);

-- Seed all default settings into settings_config
INSERT INTO public.settings_config (setting_parameter, configured_value, description) VALUES
('Institute Name', 'Divine Classes', 'Official Coaching Name'),
('Tagline', 'Empowering Aspirants for JEE, NEET & Board Excellence', 'Coaching Slogan & Mission'),
('Helpline Phone', '+91 95556 78753', 'Official Contact Number'),
('Display Contact', '9555-6787-53', 'Formatted Helpline'),
('Official Email', 'contact@divineclasses.in', 'Inquiry Email'),
('Address', '235 Paschimpuri Pocket 2, Club Rd New Delhi 110063', 'Center Location'),
('YouTube Channel', 'https://www.youtube.com/@chemcrush?si=VyfGmd_WwqQiU7j8', 'Official Video Channel'),
('Admin Name', 'Ravi Shankar', 'Display Name of Institute Admin'),
('Master Admin Password', 'admin123', 'Password to access Admin portal'),
('Admin Email ID', 'divineclasses1010@gmail.com', 'Official Admin Contact / Login Email'),
('Lead Developer Email', 'anil.chahar170@gmail.com', 'Lead Developer login email'),
('Lead Developer Password', 'Anil@1310', 'Lead Developer login password'),
('UPI Payment ID', 'divineclasses@upi', 'Fee Collection UPI'),
('Facebook Page', 'https://www.facebook.com/edivineclasses/?_rdr', 'Social Channel'),
('Instagram Profile', 'https://www.instagram.com/divineclasses_paschimpuri?utm_source=qr&dlrf=enk4MXRodTU3YTdq', 'Social Channel'),
('Show Requirement Labels', 'Off', 'Page header Requirement #N tags (toggle in Settings)'),
('Chatbot Enabled', 'On', 'Developer-controlled Gemini help chatbot visibility'),
('Show Demo Login Button', 'On', 'Demo login buttons on the login page'),
('Admin Feedback Delete', 'Off', 'Admin delete button on Feedback Wall (toggle in Settings)'),
('Study Link Delete', 'Off', 'Admin delete button on Study Links cards (toggle in Settings)'),
('Show Dummy / Demo Data', 'Off', 'Seed demo students/batches/tests visibility'),
('Dummy Data Wiped', 'Yes', 'Permanent clearance status before client handover'),
('Sheets Mirror Enabled', 'On', 'Google Sheets mirror backup toggle'),
('Theme Toggle Roles', '{"admin":true,"student":true,"teacher":true}', 'Roles allowed to use the theme button'),
('Theme Menu Button Roles', '{"admin":true,"student":true,"teacher":true}', 'Roles allowed to use the theme menu'),
('Guide Button Roles', '{"admin":true,"student":true,"teacher":true}', 'Roles allowed to see the sidebar Guide button'),
('Role Module Access', '{}', 'Per-role page visibility map'),
('Supabase Enabled', 'On', 'Supabase primary database toggle'),
('Supabase URL', 'https://srjqsofkjizwskqnzyfn.supabase.co', 'Supabase Project REST URL'),
('Supabase Key', 'sb_publishable_vxonFVKPpyJjY5O-Y9mS6g_bhSYCcsS', 'Supabase API Key'),
('Last Auto-Sync Timestamp', '31 Oct 2026, 23:20:00', 'Time of last auto-sync from Web App')
ON CONFLICT (setting_parameter) DO UPDATE
SET configured_value = EXCLUDED.configured_value,
    description = EXCLUDED.description;

CREATE TABLE public.db_json (
    snapshot_key TEXT PRIMARY KEY,
    payload JSONB NOT NULL DEFAULT '{}'::jsonb,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Seed initial main snapshot row for db_json PATCH updates
INSERT INTO public.db_json (snapshot_key, payload, updated_at)
VALUES ('main', '{}'::jsonb, now());

-- 4. Enable Row Level Security (RLS) and allow app access on all 12 tables
DO $rls$
DECLARE
    tbl text;
    all_tables text[] := ARRAY[
        'teachers', 'batches', 'students', 'attendance',
        'offline_tests', 'materials', 'external_links', 'gallery',
        'feedbacks', 'notifications', 'settings_config', 'db_json'
    ];
BEGIN
    FOREACH tbl IN ARRAY all_tables LOOP
        EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY', tbl);
        EXECUTE format(
            'CREATE POLICY %I ON public.%I FOR ALL USING (true) WITH CHECK (true)',
            'Allow public access on ' || tbl,
            tbl
        );
    END LOOP;
END
$rls$;

COMMIT;

