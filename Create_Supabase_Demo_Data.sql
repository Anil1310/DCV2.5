-- ============================================================================
-- DIVINE CLASSES: CREATE / SEED DEMO DATA
-- Populates the Supabase database with canonical demo records from Seeds.js.
-- Safe to re-run: upserts records via ON CONFLICT (id). Genuine user records
-- with different IDs are preserved.
-- Never touches operational settings (passwords, emails, URLs) or external links.
-- ============================================================================

BEGIN;

-- 1. Ensure all 12 core tables exist with proper columns and RLS enabled
CREATE TABLE IF NOT EXISTS public.teachers (
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

CREATE TABLE IF NOT EXISTS public.batches (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL DEFAULT '',
    subject TEXT DEFAULT '',
    schedule TEXT DEFAULT '',
    room TEXT DEFAULT '',
    teacher TEXT DEFAULT '',
    student_ids JSONB NOT NULL DEFAULT '[]'::jsonb
);

CREATE TABLE IF NOT EXISTS public.students (
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

CREATE TABLE IF NOT EXISTS public.attendance (
    id TEXT PRIMARY KEY,
    date TEXT NOT NULL,
    batch_id TEXT NOT NULL,
    student_id TEXT NOT NULL,
    status TEXT NOT NULL,
    marked_by TEXT DEFAULT '',
    updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.offline_tests (
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

CREATE TABLE IF NOT EXISTS public.materials (
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

CREATE TABLE IF NOT EXISTS public.external_links (
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

CREATE TABLE IF NOT EXISTS public.gallery (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL DEFAULT '',
    category TEXT DEFAULT '',
    date TEXT DEFAULT '',
    caption TEXT DEFAULT '',
    badge TEXT DEFAULT '',
    url TEXT DEFAULT '',
    image_url TEXT DEFAULT ''
);

CREATE TABLE IF NOT EXISTS public.feedbacks (
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

CREATE TABLE IF NOT EXISTS public.notifications (
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

CREATE TABLE IF NOT EXISTS public.settings_config (
    setting_parameter TEXT PRIMARY KEY,
    configured_value TEXT DEFAULT '',
    description TEXT DEFAULT ''
);

CREATE TABLE IF NOT EXISTS public.db_json (
    snapshot_key TEXT PRIMARY KEY,
    payload JSONB NOT NULL DEFAULT '{}'::jsonb,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Ensure RLS is enabled and public access policies exist
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
        IF NOT EXISTS (
            SELECT 1 FROM pg_policies
            WHERE schemaname = 'public' AND tablename = tbl AND policyname = 'Allow public access on ' || tbl
        ) THEN
            EXECUTE format('CREATE POLICY %I ON public.%I FOR ALL USING (true) WITH CHECK (true)', 'Allow public access on ' || tbl, tbl);
        END IF;
    END LOOP;
END
$rls$;

-- 2. Seed permanent External Links (5 curated education portals)
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

-- 3. Seed operational settings
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
('Show Dummy / Demo Data', 'On', 'Seed demo students/batches/tests visibility'),
('Dummy Data Wiped', 'No', 'Permanent clearance status before client handover'),
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

-- 4. Temporary table for payload upsert
CREATE TEMP TABLE demo_seed_payloads (
    table_name text PRIMARY KEY,
    rows jsonb NOT NULL
) ON COMMIT DROP;

CREATE TEMP TABLE demo_seed_report (
    table_name text PRIMARY KEY,
    rows_added bigint NOT NULL,
    rows_updated bigint NOT NULL,
    demo_rows_present bigint NOT NULL
) ON COMMIT DROP;

INSERT INTO demo_seed_payloads (table_name, rows) VALUES
('batches', $json$
[
  {"id":"b1","name":"JEE Advanced Target 2027 (Alpha Batch)","subject":"Physics, Chemistry & Mathematics","schedule":"Mon - Fri • 08:00 AM - 12:30 PM","room":"Lecture Hall 101 (Smart AC)","teacher":"Er. Rajesh Chahar (Ex-IITian)","student_ids":["s1","s2"]},
  {"id":"b2","name":"NEET Medical Dropper & Foundation (Bio-Elite)","subject":"Botany, Zoology, Physics & Chemistry","schedule":"Mon - Sat • 01:30 PM - 06:00 PM","room":"Medical Hall 202","teacher":"Dr. Sunita Sharma (M.D. AIIMS)","student_ids":["s5","s6"]},
  {"id":"b3","name":"Class 10th CBSE Board Excellence & NTSE","subject":"Science, Mathematics & Social Science","schedule":"Tue, Thu, Sat • 04:30 PM - 07:00 PM","room":"Classroom 104","teacher":"Mr. Arvind Verma (M.Sc. Gold Medalist)","student_ids":["s8","s9"]},
  {"id":"b4","name":"Demo Batch 04","subject":"Chemistry","schedule":"Demo schedule — Mon, Wed, Fri • 10:00 AM - 11:00 AM","room":"Demo Classroom 04","teacher":"Demo Faculty 04","student_ids":["s1"]},
  {"id":"b5","name":"Demo Batch 05","subject":"Mathematics","schedule":"Demo schedule — Mon, Wed, Fri • 10:00 AM - 11:00 AM","room":"Demo Classroom 05","teacher":"Demo Faculty 05","student_ids":["s2"]},
  {"id":"b6","name":"Demo Batch 06","subject":"Physics","schedule":"Demo schedule — Mon, Wed, Fri • 10:00 AM - 11:00 AM","room":"Demo Classroom 06","teacher":"Demo Faculty 06","student_ids":["s5"]}
]
$json$::jsonb),
('students', $json$
[
  {"id":"s1","roll":"DC-101","name":"Aarav Sharma","phone":"+91 98765 43210","parent_name":"Rajesh Sharma","total_fee":48000,"paid_fee":32000,"monthly_fee":1000,"due_date":"2026-10-25","last_reminder":"2 days ago","password":"password123","status":"Active","admission_date":"","batch_id":"b1","photo":""},
  {"id":"s2","roll":"DC-102","name":"Priya Patel","phone":"+91 98234 56789","parent_name":"Mukesh Patel","total_fee":48000,"paid_fee":48000,"monthly_fee":1000,"due_date":"Paid","last_reminder":"-","password":"password123","status":"Active","admission_date":"","batch_id":"b1","photo":""},
  {"id":"s5","roll":"DC-201","name":"Kabir Khan","phone":"+91 99110 02233","parent_name":"Imran Khan","total_fee":52000,"paid_fee":26000,"monthly_fee":1000,"due_date":"2026-10-20","last_reminder":"5 days ago","password":"password123","status":"Active","admission_date":"","batch_id":"b2","photo":""},
  {"id":"s6","roll":"DC-202","name":"Ananya Singh","phone":"+91 96543 21098","parent_name":"Virendra Singh","total_fee":52000,"paid_fee":52000,"monthly_fee":1000,"due_date":"Paid","last_reminder":"-","password":"password123","status":"Active","admission_date":"","batch_id":"b2","photo":""},
  {"id":"s8","roll":"DC-301","name":"Ishita Das","phone":"+91 94443 32211","parent_name":"Subhash Das","total_fee":30000,"paid_fee":22000,"monthly_fee":1000,"due_date":"2026-10-22","last_reminder":"Never","password":"password123","status":"Active","admission_date":"","batch_id":"b3","photo":""},
  {"id":"s9","roll":"DC-302","name":"Yashvardhan Chauhan","phone":"+91 93123 45678","parent_name":"Manoj Chauhan","total_fee":30000,"paid_fee":30000,"monthly_fee":1000,"due_date":"Paid","last_reminder":"-","password":"password123","status":"Active","admission_date":"","batch_id":"b3","photo":""}
]
$json$::jsonb),
('materials', $json$
[
  {"id":"m1","batch_id":"b1","batch_name":"","title":"Rotational Dynamics - Advanced DPP #05 with Step Hints","category":"Assignment PDF","type":"PDF","upload_date":"12 Oct 2026","date":"12 Oct 2026","uploaded_by":"Er. Rajesh Chahar","file_size":"2.4 MB","downloads":48,"description":"50 tough multi-concept questions covering Moment of Inertia, Conservation of Angular Momentum, and Pure Rolling on incline.","download_url":"","drive_url":""},
  {"id":"m2","batch_id":"b1","batch_name":"","title":"Chemical Equilibrium & Ionic Equilibria Formula Booster Sheet","category":"Worksheet","type":"PDF","upload_date":"14 Oct 2026","date":"14 Oct 2026","uploaded_by":"Dr. Meera Krishnan","file_size":"1.1 MB","downloads":39,"description":"Complete high-yield shortcut formulas, Ostwald dilution law, buffer solutions, and solubility product numerical tables.","download_url":"","drive_url":""},
  {"id":"m3","batch_id":"b1","batch_name":"","title":"Divine Classes JEE Mock Test #03 (Paper 1 & 2 + Answer Key)","category":"Test Paper","type":"PDF","upload_date":"10 Oct 2026","date":"10 Oct 2026","uploaded_by":"Er. Rajesh Chahar","file_size":"3.6 MB","downloads":55,"description":"Official full-syllabus simulation offline test paper held on Sunday with detailed marking scheme and video solution links.","download_url":"","drive_url":""},
  {"id":"m4","batch_id":"b2","batch_name":"","title":"NEET Human Genetics & Molecular Biology NCERT Drill","category":"Worksheet","type":"PDF","upload_date":"13 Oct 2026","date":"13 Oct 2026","uploaded_by":"Dr. Sunita Sharma","file_size":"2.8 MB","downloads":42,"description":"Line-by-line NCERT diagram drills, pedigree charts, and 120 assertion-reason practice questions.","download_url":"","drive_url":""},
  {"id":"m5","batch_id":"b3","batch_name":"","title":"CBSE 10th Standard Mathematics Real Numbers & Polynomials Board Paper","category":"Test Paper","type":"PDF","upload_date":"11 Oct 2026","date":"11 Oct 2026","uploaded_by":"Mr. Arvind Verma","file_size":"1.4 MB","downloads":31,"description":"CBSE previous 10-year question compilation with step-marking criteria for term exams.","download_url":"","drive_url":""},
  {"id":"m6","batch_id":"b3","batch_name":"","title":"[DEMO] Sample Study Resource 06","category":"Worksheet","type":"PDF","upload_date":"30 Oct 2026","date":"30 Oct 2026","uploaded_by":"Demo Faculty","file_size":"Sample","downloads":0,"description":"Placeholder demo material for testing the Materials Repository. No real file is attached.","download_url":"","drive_url":""}
]
$json$::jsonb),
('offline_tests', $json$
[
  {"id":"t1","batch_id":"b1","title":"Offline Minor Test #1 - Kinematics, NLM & Vectors","name":"Offline Minor Test #1 - Kinematics, NLM & Vectors","subject":"Physics","test_date":"05 Oct 2026","date":"05 Oct 2026","max_marks":100,"marks":{"s1":{"score":92,"remarks":"Outstanding conceptual clarity!"},"s2":{"score":96,"remarks":"Batch Topper • Flawless calculations"}},"results":[],"is_dummy":true},
  {"id":"t2","batch_id":"b1","title":"Offline Grand Test #2 - Physical & Inorganic Chemistry","name":"Offline Grand Test #2 - Physical & Inorganic Chemistry","subject":"Chemistry","test_date":"12 Oct 2026","date":"12 Oct 2026","max_marks":100,"marks":{"s1":{"score":89,"remarks":"Great improvement in thermodynamics"},"s2":{"score":94,"remarks":"Excellent stoichiometry work"}},"results":[],"is_dummy":true},
  {"id":"t3","batch_id":"b2","title":"NEET Offline Minor Test - Cell Division & Plant Kingdom","name":"NEET Offline Minor Test - Cell Division & Plant Kingdom","subject":"Biology","test_date":"08 Oct 2026","date":"08 Oct 2026","max_marks":720,"marks":{"s5":{"score":628,"remarks":"Strong Botany score, revise meiosis stages"},"s6":{"score":680,"remarks":"Top Ranker in Divine Classes! AIIMS caliber"}},"results":[],"is_dummy":true},
  {"id":"t4","batch_id":"b3","title":"Class 10 CBSE Offline Term Assessment #1","name":"Class 10 CBSE Offline Term Assessment #1","subject":"Mathematics & Science","test_date":"09 Oct 2026","date":"09 Oct 2026","max_marks":80,"marks":{"s8":{"score":73,"remarks":"Neat geometry diagrams and proofs"},"s9":{"score":78,"remarks":"Excellent, 100% accuracy in Algebra"}},"results":[],"is_dummy":true},
  {"id":"t5","batch_id":"b2","title":"[DEMO] Sample Assessment 05","name":"[DEMO] Sample Assessment 05","subject":"Mathematics","test_date":"30 Oct 2026","date":"30 Oct 2026","max_marks":100,"marks":{"s1":{"score":75,"remarks":"[DEMO] Sample marks for layout and report testing."}},"results":[],"is_dummy":true},
  {"id":"t6","batch_id":"b3","title":"[DEMO] Sample Assessment 06","name":"[DEMO] Sample Assessment 06","subject":"Physics","test_date":"30 Oct 2026","date":"30 Oct 2026","max_marks":100,"marks":{"s5":{"score":78,"remarks":"[DEMO] Sample marks for layout and report testing."}},"results":[],"is_dummy":true}
]
$json$::jsonb),
('teachers', $json$
[
  {"id":"tr1","name":"Er. Rajesh Chahar","subject":"Senior Physics Faculty & Academic Director","qualification":"B.Tech (IIT Roorkee), M.Tech","experience":"15+ Years Experience","email":"rajesh.chahar@divineclasses.in","phone":"+91 95556 78753","specialization":"Rotational Dynamics, Electromagnetism & JEE Advanced Strategy","bio":"Founder of Divine Classes. Mentored 800+ IITians and NITians. Known for breaking down complex physics into crystal-clear intuitive models.","avatar_color":"bg-slate-600","initials":"RC","password":"teacher123","status":"Active","photo":""},
  {"id":"tr2","name":"Dr. Sunita Sharma","subject":"Head of Biology & Medical Entrance Wing","qualification":"M.B.B.S, M.D. (AIIMS New Delhi)","experience":"12+ Years Experience","email":"dr.sunita@divineclasses.in","phone":"+91 98234 56789","specialization":"Human Physiology, Genetics & High-Yield NEET Revision","bio":"Former clinical fellow turned passionate NEET coach. Produced multiple top-100 All India Ranks in NEET-UG with 350+/360 biology scores.","avatar_color":"from-emerald-600 to-teal-600","initials":"SS","password":"teacher123","status":"Active","photo":""},
  {"id":"tr3","name":"Mr. Arvind Verma","subject":"Mathematics Mentor & Olympiad Specialist","qualification":"M.Sc. Mathematics (Gold Medalist)","experience":"11+ Years Experience","email":"arvind.verma@divineclasses.in","phone":"+91 98345 67890","specialization":"Calculus, Vectors-3D & Rapid Problem Solving Shortcuts","bio":"Celebrated for transforming mathematics from a feared subject into a scoring powerhouse. Author of shortcut trick compilations for competitive tests.","avatar_color":"from-slate-500 to-orange-600","initials":"AV","password":"teacher123","status":"Active","photo":""},
  {"id":"tr4","name":"Dr. Meera Krishnan","subject":"Senior Chemistry Faculty (Organic & Physical)","qualification":"Ph.D. Chemistry (IISc Bangalore)","experience":"10+ Years Experience","email":"meera.krishnan@divineclasses.in","phone":"+91 98456 78901","specialization":"Named Reaction Mechanisms, Thermodynamics & GOC","bio":"Believes in zero rote-memorization. Uses molecular 3D models to make organic synthesis reaction pathways stick effortlessly.","avatar_color":"from-purple-600 to-pink-600","initials":"MK","password":"teacher123","status":"Active","photo":""},
  {"id":"tr5","name":"Demo Faculty 05","subject":"Sample Subject 05","qualification":"Demo qualification","experience":"Sample experience","email":"demo.faculty05@example.invalid","phone":"","specialization":"Demo profile for testing only","bio":"This is a placeholder demo teacher record.","avatar_color":"from-slate-600 to-slate-800","initials":"DF","password":"demo-only","status":"Active","photo":""},
  {"id":"tr6","name":"Demo Faculty 06","subject":"Sample Subject 06","qualification":"Demo qualification","experience":"Sample experience","email":"demo.faculty06@example.invalid","phone":"","specialization":"Demo profile for testing only","bio":"This is a placeholder demo teacher record.","avatar_color":"from-slate-600 to-slate-800","initials":"DF","password":"demo-only","status":"Active","photo":""}
]
$json$::jsonb),
('gallery', $json$
[
  {"id":"g1","title":"JEE Advanced 2026 - All India Top 100 Toppers Felicitation","category":"Result Banner","date":"June 2026","caption":"Divine Classes champions shine bright! AIR 14, AIR 28, and 18 students securing 99.5+ percentile in JEE Advanced.","badge":"AIR 14, 28, 64","url":"https://images.unsplash.com/photo-1523240795612-9a054b0db644?auto=format&fit=crop&w=800&q=80","image_url":"https://images.unsplash.com/photo-1523240795612-9a054b0db644?auto=format&fit=crop&w=800&q=80"},
  {"id":"g2","title":"NEET Medical Selections Felicitation Ceremony","category":"Result Banner","date":"June 2026","caption":"46 selections in Govt. Medical Colleges including AIIMS, MAMC, and LHMC. Highest score: 685/720.","badge":"685/720 Highest","url":"https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?auto=format&fit=crop&w=800&q=80","image_url":"https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?auto=format&fit=crop&w=800&q=80"},
  {"id":"g3","title":"Interactive Smart AC Classroom & Doubt Clearing Sessions","category":"Classroom Photo","date":"September 2026","caption":"Lecture Hall 101 equipped with interactive smart panels, live problem projections, and ergonomic seating.","badge":"Smart Hall 101","url":"https://images.unsplash.com/photo-1524178232363-1fb2b075b655?auto=format&fit=crop&w=800&q=80","image_url":"https://images.unsplash.com/photo-1524178232363-1fb2b075b655?auto=format&fit=crop&w=800&q=80"},
  {"id":"g4","title":"Annual Merit Scholarship & Trophy Distribution Day","category":"Event","date":"August 2026","caption":"Over ₹5 Lakhs worth of merit-cum-means scholarships awarded to meritorious students by Divine Classes management.","badge":"Annual Day","url":"https://images.unsplash.com/photo-1540575467063-178a50c2df87?auto=format&fit=crop&w=800&q=80","image_url":"https://images.unsplash.com/photo-1540575467063-178a50c2df87?auto=format&fit=crop&w=800&q=80"},
  {"id":"g5","title":"[DEMO] Sample Gallery Item 05","category":"Demo Preview","date":"30 Oct 2026","caption":"Placeholder gallery entry for testing only; it does not represent a real result or event.","badge":"DEMO","url":"https://images.unsplash.com/photo-1524178232363-1fb2b075b655?auto=format&fit=crop&w=800&q=80","image_url":"https://images.unsplash.com/photo-1524178232363-1fb2b075b655?auto=format&fit=crop&w=800&q=80"},
  {"id":"g6","title":"[DEMO] Sample Gallery Item 06","category":"Demo Preview","date":"30 Oct 2026","caption":"Placeholder gallery entry for testing only; it does not represent a real result or event.","badge":"DEMO","url":"https://images.unsplash.com/photo-1524178232363-1fb2b075b655?auto=format&fit=crop&w=800&q=80","image_url":"https://images.unsplash.com/photo-1524178232363-1fb2b075b655?auto=format&fit=crop&w=800&q=80"}
]
$json$::jsonb),
('feedbacks', $json$
[
  {"id":"f1","name":"Rajesh Sharma (Parent of Aarav Sharma)","message":"Divine Classes has transformed Aarav’s problem-solving approach. Er. Rajesh Chahar sir’s physics lectures and individual doubt attention are exceptional!","rating":5,"created_at":"13 Oct 2026","batch":"JEE Advanced Target 2027 (Alpha Batch)","role":"Parent","category":"Teaching Quality","read":false},
  {"id":"f2","name":"Ananya Singh","message":"The offline test analysis and Dr. Sunita ma’am’s NCERT biology booster worksheets are the main reason my mock test scores jumped from 520 to 660+!","rating":5,"created_at":"10 Oct 2026","batch":"NEET Medical Dropper & Foundation","role":"Student","category":"Study Material","read":false},
  {"id":"f3","name":"Sanjay Gupta (Parent of Rohan Gupta)","message":"Very disciplined institute. Receiving regular offline test marks and updates gives us complete peace of mind about our ward’s exam prep.","rating":5,"created_at":"06 Oct 2026","batch":"JEE Advanced Target 2027 (Alpha Batch)","role":"Parent","category":"Offline Test Series","read":false},
  {"id":"f4","name":"Demo Respondent 04","message":"[DEMO] Placeholder feedback record for testing only; not a real testimonial.","rating":5,"created_at":"30 Oct 2026","batch":"Demo Batch 04","role":"Parent","category":"Demo Feedback","read":false},
  {"id":"f5","name":"Demo Respondent 05","message":"[DEMO] Placeholder feedback record for testing only; not a real testimonial.","rating":5,"created_at":"30 Oct 2026","batch":"Demo Batch 05","role":"Student","category":"Demo Feedback","read":false},
  {"id":"f6","name":"Demo Respondent 06","message":"[DEMO] Placeholder feedback record for testing only; not a real testimonial.","rating":5,"created_at":"30 Oct 2026","batch":"Demo Batch 06","role":"Parent","category":"Demo Feedback","read":false}
]
$json$::jsonb),
('notifications', $json$
[
  {"id":"monthly_fee_s1_demo","title":"Demo fee reminder","message":"Sample fee reminder for Aarav Sharma.","time":"Demo","timestamp":0,"timestamp_offset_ms":-6000,"read":false,"admin_seen":false,"type":"info","icon":"","icon_color":"","bg_color":"","action_tab":"fees","target_role":"student","material_id":"","batch_name":"JEE Advanced Target 2027 (Alpha Batch)"},
  {"id":"monthly_fee_s2_demo","title":"Demo fee reminder","message":"Sample fee reminder for Priya Patel.","time":"Demo","timestamp":0,"timestamp_offset_ms":-5000,"read":false,"admin_seen":false,"type":"info","icon":"","icon_color":"","bg_color":"","action_tab":"fees","target_role":"student","material_id":"","batch_name":"JEE Advanced Target 2027 (Alpha Batch)"},
  {"id":"monthly_fee_s5_demo","title":"Demo fee reminder","message":"Sample fee reminder for Kabir Khan.","time":"Demo","timestamp":0,"timestamp_offset_ms":-4000,"read":false,"admin_seen":false,"type":"info","icon":"","icon_color":"","bg_color":"","action_tab":"fees","target_role":"student","material_id":"","batch_name":"NEET Medical Dropper & Foundation (Bio-Elite)"},
  {"id":"monthly_fee_s6_demo","title":"Demo fee reminder","message":"Sample fee reminder for Ananya Singh.","time":"Demo","timestamp":0,"timestamp_offset_ms":-3000,"read":false,"admin_seen":false,"type":"info","icon":"","icon_color":"","bg_color":"","action_tab":"fees","target_role":"student","material_id":"","batch_name":"NEET Medical Dropper & Foundation (Bio-Elite)"},
  {"id":"monthly_fee_s8_demo","title":"Demo fee reminder","message":"Sample fee reminder for Ishita Das.","time":"Demo","timestamp":0,"timestamp_offset_ms":-2000,"read":false,"admin_seen":false,"type":"info","icon":"","icon_color":"","bg_color":"","action_tab":"fees","target_role":"student","material_id":"","batch_name":"Class 10th CBSE Board Excellence & NTSE"},
  {"id":"monthly_fee_s9_demo","title":"Demo fee reminder","message":"Sample fee reminder for Yashvardhan Chauhan.","time":"Demo","timestamp":0,"timestamp_offset_ms":-1000,"read":false,"admin_seen":false,"type":"info","icon":"","icon_color":"","bg_color":"","action_tab":"fees","target_role":"student","material_id":"","batch_name":"Class 10th CBSE Board Excellence & NTSE"}
]
$json$::jsonb);

DO $seed$
DECLARE
    item record;
    target_oid oid;
    target_type text;
    seed_rows jsonb;
    available_columns text;
    update_columns text;
    rows_before bigint;
    rows_after bigint;
    rows_added bigint;
    rows_updated bigint;
    notification_anchor_ms bigint;
BEGIN
    FOR item IN SELECT table_name, rows FROM demo_seed_payloads ORDER BY
        CASE table_name
            WHEN 'teachers' THEN 1
            WHEN 'batches' THEN 2
            WHEN 'students' THEN 3
            WHEN 'materials' THEN 4
            WHEN 'offline_tests' THEN 5
            WHEN 'gallery' THEN 6
            WHEN 'feedbacks' THEN 7
            ELSE 8
        END
    LOOP
        seed_rows := item.rows;
        IF item.table_name = 'notifications' THEN
            notification_anchor_ms := floor(extract(epoch FROM clock_timestamp()) * 1000)::bigint;
            seed_rows := (
                SELECT jsonb_agg(
                    (seed.value - 'timestamp_offset_ms') ||
                    jsonb_build_object(
                        'timestamp',
                        notification_anchor_ms + (seed.value ->> 'timestamp_offset_ms')::bigint
                    )
                )
                FROM jsonb_array_elements(seed_rows) AS seed(value)
            );
        END IF;

        target_oid := to_regclass(format('public.%I', item.table_name));
        IF target_oid IS NULL THEN
            RAISE EXCEPTION 'Required Supabase table public.% does not exist', item.table_name;
        END IF;

        target_type := format('%I.%I', 'public', item.table_name);
        SELECT string_agg(format('%I', a.attname), ', ' ORDER BY a.attnum),
               string_agg(format('%1$I = EXCLUDED.%1$I', a.attname), ', ' ORDER BY a.attnum)
        INTO available_columns, update_columns
        FROM pg_attribute AS a
        WHERE a.attrelid = target_oid
          AND a.attnum > 0
          AND NOT a.attisdropped
          AND a.attname <> 'id'
          AND EXISTS (
              SELECT 1
              FROM jsonb_object_keys(seed_rows -> 0) AS keys(key_name)
              WHERE key_name = a.attname
          );

        IF NOT EXISTS (
            SELECT 1
            FROM pg_attribute AS a
            WHERE a.attrelid = target_oid
              AND a.attname = 'id'
              AND a.attnum > 0
              AND NOT a.attisdropped
        ) THEN
            RAISE EXCEPTION 'Required id column is missing from public.%', item.table_name;
        END IF;

        IF update_columns IS NULL THEN
            RAISE EXCEPTION 'No seed columns match public.%', item.table_name;
        END IF;

        available_columns := '"id", ' || available_columns;

        EXECUTE format(
            'SELECT count(*) FROM %I.%I AS target ' ||
            'WHERE target.id::text IN ' ||
            '(SELECT seed.value ->> ''id'' FROM jsonb_array_elements($1) AS seed(value))',
            'public',
            item.table_name
        )
        INTO rows_before
        USING seed_rows;

        EXECUTE format(
            'INSERT INTO %I.%I (%s) ' ||
            'SELECT %s FROM jsonb_populate_recordset(NULL::%s, $1) ' ||
            'ON CONFLICT (id) DO UPDATE SET %s',
            'public',
            item.table_name,
            available_columns,
            available_columns,
            target_type,
            update_columns
        ) USING seed_rows;

        rows_updated := rows_before;
        rows_added := jsonb_array_length(seed_rows) - rows_before;

        EXECUTE format(
            'SELECT count(*) FROM %I.%I AS target ' ||
            'WHERE target.id::text IN ' ||
            '(SELECT seed.value ->> ''id'' FROM jsonb_array_elements($1) AS seed(value))',
            'public',
            item.table_name
        )
        INTO rows_after
        USING seed_rows;

        INSERT INTO demo_seed_report (table_name, rows_added, rows_updated, demo_rows_present)
        VALUES (item.table_name, rows_added, rows_updated, rows_after);
        RAISE NOTICE 'Seeded public.%: % added, % updated', item.table_name, rows_added, rows_updated;
    END LOOP;
END
$seed$;

-- 5. Seed Attendance demo records for Alpha Batch
INSERT INTO public.attendance (id, date, batch_id, student_id, status, marked_by, updated_at) VALUES
('2026-10-25_b1_s1', '2026-10-25', 'b1', 's1', 'Present', 'Er. Rajesh Chahar', now()),
('2026-10-25_b1_s2', '2026-10-25', 'b1', 's2', 'Present', 'Er. Rajesh Chahar', now()),
('2026-10-24_b1_s1', '2026-10-24', 'b1', 's1', 'Present', 'Er. Rajesh Chahar', now()),
('2026-10-24_b1_s2', '2026-10-24', 'b1', 's2', 'Absent', 'Er. Rajesh Chahar', now())
ON CONFLICT (id) DO UPDATE
SET status = EXCLUDED.status,
    marked_by = EXCLUDED.marked_by,
    updated_at = now();

SELECT table_name, rows_added, rows_updated, demo_rows_present
FROM (
    SELECT table_name, rows_added, rows_updated, demo_rows_present, 1 AS sort_order
    FROM demo_seed_report
    UNION ALL
    SELECT 'TOTAL', sum(rows_added), sum(rows_updated), sum(demo_rows_present), 2
    FROM demo_seed_report
) AS report
ORDER BY sort_order, table_name;

COMMIT;
