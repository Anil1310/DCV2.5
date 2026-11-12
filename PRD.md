# Product Requirements Document

## Divine Classes Institute Management Portal

| Document field | Value |
|---|---|
| Document type | Current-product PRD and acceptance baseline |
| Product | Divine Classes web portal & Android WebView app |
| Version | 2.5 Cloud Edition (Production Deployment @202) |
| Prepared | 9 November 2026 |
| Status | Verified & Deployed (Release v2.5 / @202) |
| Production URL | `AKfycbzlbJUklVvhuJzIDoWv3a3CXY4trX435BiGD1JGIOeuYJC7PiR5lqI15Ymz0kFEpf0P/exec` |
| Dev / Head URL | `AKfycbzU11aFI_SVPhzAX-NAeHXC6iT_3DVgjm9XIV91uDc/dev` |
| Primary users | Admin, Teacher, Student, Developer |

This document describes the web app as it is represented in the current source and user guides. It does not assert that every external integration is configured or operational in a particular deployment. Where the intended behavior needs product-owner confirmation, it is listed as an open decision rather than treated as a settled requirement.

## 1. Product summary

Divine Classes is a responsive, role-based portal for the day-to-day operations of a coaching institute. It brings academic operations, learner records, attendance, fee tracking, learning resources, test results, faculty information, notifications, and institute configuration into one web experience.

The portal is designed for desktop and mobile browsers. An Android WebView app is also maintained as an access channel to the web portal; the web app remains the product described here.

### 1.1 Problem statement

Institute staff need a shared place to maintain class and learner records, communicate updates, and give students access to their own academic information. Without a common system, records and learning resources can be scattered across spreadsheets, messages, and individual devices, making it harder to keep information current and to control who can view or change it.

### 1.2 Product vision

Provide a clear, mobile-friendly portal where institute staff can manage classes and academic operations, while teachers and students see only the information relevant to their role and assigned classes.

## 2. Goals and non-goals

### 2.1 Goals

1. Provide a single responsive portal for institute operations and student-facing academic information.
2. Organize access around Admin, Teacher, Student, and Developer roles.
3. Make routine workflows discoverable: create a batch, manage a roster, mark attendance, record payments, share materials, enter test marks, and communicate updates.
4. Let students view their own batch-related materials, attendance, marks, and fee information.
5. Support cloud persistence and synchronization, with Google Sheets and Google Drive integration points.
6. Let a Developer configure institute settings, role visibility, demo access, and demo data without changing application code.
7. Support a controlled demo experience that can be enabled or disabled independently of sample data.

### 2.2 Non-goals

- Replacing a full accounting, payroll, or statutory finance system.
- Processing card, UPI, or bank transactions inside the portal. The current “Pay / View Details” experience presents fee information and payment guidance; it is not evidence of an in-app payment gateway.
- Providing a separate Parent account or parent login. “Parent” is a feedback submit-as option, not a defined login role.
- Delivering SMS or WhatsApp messages directly. The app creates in-portal notifications; external message delivery is not established by the current implementation.
- Serving as a full online learning-management system with live classes, assignment grading, or examination delivery.

## 3. Users and permissions

### 3.1 Personas

| Persona | Needs |
|---|---|
| Admin | Maintain batches and rosters, manage fees and account access, coordinate faculty and learning resources, and review institute activity. |
| Teacher | Work with assigned batches, record attendance and marks, share class materials, and maintain their faculty profile. |
| Student | Find their batch resources and faculty information, review attendance and marks, and see targeted fee notices. |
| Developer | Configure the portal, manage role visibility and demo mode, and administer integrations and data lifecycle controls. |
| Parent respondent | Submit feedback as a parent; no independent portal account is specified. |

### 3.2 Default role visibility

The default navigation permissions are:

| Area | Admin | Teacher | Student | Developer |
|---|:---:|:---:|:---:|:---:|
| Dashboard | Yes | Yes | Yes | Yes |
| Batches & Students | Yes | Yes | Yes, scoped to own batch | Yes |
| Attendance | Yes | Yes, assigned batches | Yes, own attendance | Yes |
| Student Fees & Reminders | Yes | No | No | Yes |
| Access Control | Yes | No | No | Yes |
| Assignments & DPPs | Yes | Yes | Yes, general and own-batch resources | Yes |
| Offline Marks Tracker | Yes | Yes | Yes, own report | Yes |
| Faculty Management | Yes | Own-profile functions where exposed | View as allowed | Yes |
| Results & Gallery | Yes | Yes | Yes | Yes |
| External Study Hub | Yes | Yes | Yes | Yes |
| Feedback | Yes | Yes | Yes | Yes |
| Chatbot | If enabled and permitted | If enabled and permitted | If enabled and permitted | Yes |
| Settings | No | No | No | Yes |

The Developer can override visibility for Admin, Teacher, and Student on a per-module basis. Settings remains Developer-only in the navigation/access helper. A visible navigation item is not a substitute for authorization: sensitive reads and writes must be authorized at the service/backend boundary as well as hidden in the UI.

Faculty behavior is split across the faculty page and profile-specific controls: the default navigation lists Faculty Management for Admin, while Teacher profile actions are described in the user guide and surfaced in profile/dashboard flows. Confirm the final intended navigation for teachers and students before changing role defaults.

## 4. Core user journeys

### 4.1 Admin onboarding and daily operations

1. Admin signs in and lands on the dashboard.
2. Admin creates a batch with a name, schedule, subjects, room, and teacher.
3. Admin adds existing students or registers new students and assigns them to a batch.
4. Admin maintains teacher/student access and account status.
5. Admin records fee payments, reviews outstanding balances, and sends in-app reminders.
6. Admin or Teacher shares materials and records offline test results.
7. Admin reviews feedback and publishes gallery items or institute links.

### 4.2 Teacher class workflow

1. Teacher signs in and reviews assigned batches and shortcuts.
2. Teacher selects an assigned batch and date to record attendance.
3. Teacher adds students to a batch where permitted.
4. Teacher uploads study material and enters test marks for a class.
5. Teacher updates their own faculty profile and photo.

### 4.3 Student learning workflow

1. Student signs in and sees their batch and relevant dashboard information.
2. Student opens batch or general materials and downloads a resource.
3. Student reviews personal attendance and test results, and prints a report if needed.
4. Student opens faculty, gallery, and external study resources.
5. Student sees targeted fee reminders and institute notifications.
6. Student or parent respondent submits feedback.

### 4.4 Developer configuration and demo workflow

1. Developer signs in using server-verified Developer credentials.
2. Developer configures institute profile, contact details, theme, role access, chatbot, and storage/database settings.
3. Developer separately enables or disables password-free demo login buttons for Admin, Teacher, and Student previews.
4. Developer creates clearly identified sample data for demos/testing, or permanently clears demo data when no longer needed.
5. Developer verifies the selected configuration and external service status before handover.

## 5. Functional requirements

### 5.1 Authentication and session

- **FR-AUTH-01** The portal shall provide a login form supporting the account identifiers configured for Admin, Teacher, and Student accounts, including roll number, email, phone, or an Admin identifier where applicable.
- **FR-AUTH-02** The login form shall provide password visibility control, a Remember me option, and a way to display institute contact information for forgotten passwords.
- **FR-AUTH-03** The portal shall distinguish Admin, Teacher, Student, and Developer identities and apply the corresponding role experience.
- **FR-AUTH-04** Blocked and inactive student/teacher accounts shall not be permitted to sign in.
- **FR-AUTH-05** Developer credential verification shall occur on the server; Developer secrets shall not be sent to the browser.
- **FR-AUTH-06** The portal shall support inactivity logout and an explicit logout route/action.
- **FR-AUTH-07** When enabled by the Developer, the login page shall show separate one-tap Demo Mode entry points for Admin, Teacher, and Student. Demo login and sample-data visibility are independent controls.

### 5.2 Portal shell and navigation

- **FR-NAV-01** After authentication, the portal shall provide a dashboard, role-aware page navigation, account/profile controls, notification access, and a cloud sync indicator.
- **FR-NAV-02** Navigation shall group related modules and adapt to mobile and desktop screen sizes.
- **FR-NAV-03** Users shall not be able to navigate to a module disabled for their role; the application shall show an appropriate fallback if no modules are available.
- **FR-NAV-04** Theme, Guide, and chatbot entry points shall be shown only when enabled for the user's role and by portal configuration.

### 5.3 Dashboard

- **FR-DASH-01** The dashboard shall present role-relevant summaries and shortcuts to the user's available modules.
- **FR-DASH-02** Admin dashboard content shall summarize operational information such as batches, study uploads, tests, and pending fees.
- **FR-DASH-03** Teacher dashboard content shall prioritize assigned batches and academic workflow shortcuts.
- **FR-DASH-04** Student dashboard content shall prioritize the student's batch, attendance, materials, tests, report/ID actions, and applicable fee notices.
- **FR-DASH-05** Dashboard shortcuts shall open the corresponding module without requiring users to search the navigation.

### 5.4 Batches and students

- **FR-BATCH-01** Admin shall be able to create and maintain batches with a name, subject(s), schedule, classroom/location, teacher, and student roster.
- **FR-BATCH-02** Admin shall be able to add an existing student to a batch or create a student record with identifying, contact, parent, fee, due-date, and optional photo details.
- **FR-BATCH-03** Teacher shall be able to view batches and add students as allowed by the active role configuration.
- **FR-BATCH-04** Student batch views shall be read-only and restricted to the student's own batch and permitted class context.
- **FR-BATCH-05** Users with access shall be able to view batch details and use shortcuts to batch materials.
- **FR-BATCH-06** The portal shall provide student ID-card display and browser print/share affordances where supported.

### 5.5 Attendance

- **FR-ATT-01** Admin and Teacher shall be able to select a date and batch and record Present, Absent, Late, or Leave attendance for valid students.
- **FR-ATT-02** Teacher attendance actions shall be limited to assigned batches.
- **FR-ATT-03** The system shall validate attendance dates, selected batch, student eligibility, duplicate student entries, and role before saving.
- **FR-ATT-04** The system shall support daily save and month-wise record review; users with edit access shall be able to correct saved records.
- **FR-ATT-05** Student attendance views shall show the student's own records, counts, and attendance summary.
- **FR-ATT-06** Attendance save requests shall support no more than 500 student entries per request.
- **FR-ATT-07** Unmarked students shall not be silently changed to Absent when a partial save is used.

### 5.6 Fees and reminders

- **FR-FEE-01** Admin shall have access to a fee ledger and summary values for expected/collected fees, due students, and collection health.
- **FR-FEE-02** Admin shall be able to record a positive payment amount, retain payment history, update the paid balance and due state, and mirror supported changes to the student record.
- **FR-FEE-03** Admin shall be able to export the fee ledger as CSV.
- **FR-FEE-04** Admin shall be able to create individual or bulk in-app reminders for students with outstanding fees.
- **FR-FEE-05** The system shall generate due-fee notifications through its scheduled reminder workflow where configured.
- **FR-FEE-06** A student shall see only their own fee/reminder information and applicable institute payment instructions.
- **FR-FEE-07** The portal shall not represent a payment as completed unless a verified payment integration has been added; the current payment-details view is not a transaction processor.

### 5.7 Access control

- **FR-ACCESS-01** Admin shall be able to search/filter student accounts and view active, blocked, and inactive states.
- **FR-ACCESS-02** Admin shall be able to activate/block eligible student and teacher accounts and restore archived student records where supported.
- **FR-ACCESS-03** Admin shall be able to reset student/teacher passwords using the account-management workflow.
- **FR-ACCESS-04** Admin shall be able to update the Admin master password.
- **FR-ACCESS-05** The system shall make the effect of Active, Blocked, and Inactive states clear to administrators.
- **FR-ACCESS-06** Passwords and privileged credentials shall not be exposed through public client data or ordinary logs.

### 5.8 Materials and assignments

- **FR-MAT-01** Admin and Teacher shall be able to add learning materials with title, description, category, batch or general audience, and file.
- **FR-MAT-02** Supported categories shall include Assignment PDF, Worksheet, and Test Paper.
- **FR-MAT-03** Uploaded files shall be stored through the configured Google Drive integration; the material record shall retain links and metadata.
- **FR-MAT-04** Admin and Teacher shall be able to browse/filter materials by batch; Student shall see general resources and resources for their own batch.
- **FR-MAT-05** Users shall be able to open or download available files, with link status made visible when a record lacks a valid file link.
- **FR-MAT-06** Students shall receive an in-portal notice when new material is uploaded, where the notification workflow is enabled.

### 5.9 Offline marks and reports

- **FR-MARK-01** Admin and Teacher shall be able to create a test with batch, title, subject, date, and maximum marks.
- **FR-MARK-02** Authorized users shall be able to save student marks and optional remarks, individually or for a batch.
- **FR-MARK-03** Scores shall be validated against the test's maximum marks.
- **FR-MARK-04** Authorized users shall be able to review score summaries and comparisons.
- **FR-MARK-05** Students shall see only their own report-card results and be able to print/save the report where browser support permits.

### 5.10 Faculty profiles

- **FR-FAC-01** Admin shall be able to create and maintain faculty profiles, including name, subject, qualifications, experience, contact details, specialization, biography, and optional photo.
- **FR-FAC-02** Teacher shall be able to update their own permitted profile fields/photo and view their faculty ID information.
- **FR-FAC-03** Students shall be able to view permitted active faculty information.
- **FR-FAC-04** The portal shall support browser printing/sharing of faculty ID cards where supported.

### 5.11 Results and gallery

- **FR-GAL-01** Authorized staff shall be able to publish gallery entries with title, category, date, caption, badge/achievement text, and image.
- **FR-GAL-02** All permitted roles shall be able to view gallery items and open a larger image/lightbox view.
- **FR-GAL-03** The publishing workflow should support images by URL or configured upload storage.

### 5.12 External study hub

- **FR-LINK-01** The portal shall provide a curated list of external study resources with title, provider, subject, URL, description, and display metadata.
- **FR-LINK-02** Users shall be able to open a resource in a browser/new tab; external links shall not be silently rewritten.
- **FR-LINK-03** Admin and Teacher shall be able to add study links where permitted.
- **FR-LINK-04** Admin deletion of links shall be controlled by the Developer setting; Developer retains management control.
- **FR-LINK-05** The curated External Links Hub shall remain separate from demo-data cleanup and shall not be replaced by sample links during demo creation.

### 5.13 Feedback and notifications

- **FR-COMM-01** Student and Parent respondents shall be able to submit feedback with name, submit-as role, batch, category, rating, and comment.
- **FR-COMM-02** The portal shall display recent feedback with author, date, rating, batch, category, and comment.
- **FR-COMM-03** Admin feedback deletion shall be controlled by the Developer setting.
- **FR-COMM-04** The notification center shall show relevant fee, material, and institute notices, with read/unread state where supported.
- **FR-COMM-05** Notifications targeted to a student shall not be shown to unrelated students.

### 5.14 Chatbot

- **FR-AI-01** The Developer shall be able to enable or disable the Chatbot and its role visibility.
- **FR-AI-02** When enabled, users shall be able to ask typed questions and use voice input where supported by the browser.
- **FR-AI-03** Users shall be able to start a new conversation and copy responses.
- **FR-AI-04** A user's Gemini credential, if required, shall be scoped to that browser profile and must not be stored in shared institute records.
- **FR-AI-05** The chatbot workflow shall not send private student records as prompt context unless an explicit, reviewed product change authorizes that data use.
- **FR-AI-06** The UI shall disclose third-party AI use and make quota/service errors understandable.

### 5.15 Settings and Developer tools

- **FR-DEV-01** Settings shall be Developer-only and provide controls for institute profile, contact/payment details, social links, security, database connections, chatbot, demo mode, demo data, role permissions, storage, and appearance.
- **FR-DEV-02** The Developer shall be able to configure which modules Admin, Teacher, and Student can access.
- **FR-DEV-03** The Developer shall be able to control theme availability by role and set portal accent/theme defaults.
- **FR-DEV-04** The Developer shall be able to configure the portal's Google Drive storage location and inspect configured storage links.
- **FR-DEV-05** Developer actions that clear data shall require explicit confirmation and shall state which records and systems are affected before execution.
- **FR-DEV-06** Create Demo Data shall seed clearly marked sample records while preserving genuine records and protected settings/curated-link data.
- **FR-DEV-07** Demo Login visibility shall be independently switchable from sample-data visibility.
- **FR-DEV-08** A permanent dummy-data cleanup shall remove only demo/test records and preserve genuine records, protected configuration, and curated study links. A separate “clear all application data” action is destructive and must be clearly distinguished.
- **FR-DEV-09** Destructive action completion shall be verified against configured data stores before a success state is displayed.
- **FR-DEV-10** The Developer shall be able to use cloud/Sheets recovery or synchronization controls without reloading the active page unnecessarily.

### 5.16 Appearance and responsive behavior

- **FR-UX-01** The app shall adapt its layout and navigation to mobile and desktop viewports.
- **FR-UX-02** The theme control shall support Light and Dark appearance when available for the user's role.
- **FR-UX-03** The app shall persist the user's chosen appearance on the current device/browser.
- **FR-UX-04** Primary actions, progress states, errors, empty states, and destructive confirmations shall remain legible and usable on small screens.
- **FR-UX-05** Routine background synchronization shall not cause avoidable page reloads, visible flicker, or loss of the user's current page/scroll position.

## 6. Data and integrations

### 6.1 Core records

The application manages these primary record groups:

- Batches and student membership.
- Student profiles, contact and fee fields, account status, and payment history.
- Teacher profiles and account status.
- Attendance records by date, batch, student, and status.
- Learning materials and their Drive links/metadata.
- Offline tests and per-student marks/remarks.
- Gallery entries.
- External study links.
- Feedback entries.
- Notifications and delivery/read targeting metadata.
- Institute and portal settings.

Demo/test records must be identifiable so they can be filtered, displayed, synchronized, or removed without confusing them with genuine operational data.

### 6.2 Integration surfaces

| Integration | Product purpose | Notes |
|---|---|---|
| Google Apps Script | Web app hosting and server-side application functions | Deployment and quota behavior depend on the configured Apps Script project. |
| Google Sheets | Human-readable roster, attendance, materials, marks, settings, and other supported mirrors | Protected tabs, including settings and curated external links, must not be overwritten by demo workflows. |
| Supabase | Primary cloud persistence/synchronization when enabled | Actual project schema, row-level security, credentials, and connectivity must be validated per deployment. |
| Google Drive | Store and serve uploaded materials and photos | Sharing permissions and folder access affect availability. |
| Gemini API | Optional AI assistant | User-provided key/quotas and browser privacy apply. |
| Android WebView | Mobile app wrapper for the portal | External links should open in the device browser when appropriate. |

The implementation has a Supabase snapshot/data path and table-sync paths, plus spreadsheet merge/mirror behavior. Integration availability is deployment-specific; the UI must not claim successful persistence when a configured write fails.

## 7. Non-functional requirements

### 7.1 Security and privacy

- Enforce authentication and role/record-level authorization for sensitive operations on the server, not only by hiding navigation.
- Do not return Developer secrets, database service credentials, or unnecessary password material to the browser.
- Collect only the student and parent information required for institute operations.
- Protect student data in logs, AI requests, exports, and shared-device sessions.
- Warn before sharing public Drive links or personal/contact information.
- Require clear, typed or equivalent confirmation for irreversible data-clearing operations.
- Keep demo data visibly distinguishable and prevent it from being mistaken for real student results/testimonials.

### 7.2 Reliability and data integrity

- A failed database, Sheets, or Drive operation shall return a visible error and shall not be presented as a successful save.
- Sync operations shall be retryable and idempotent where possible.
- Record updates shall preserve unrelated genuine data and avoid duplicate rows.
- Destructive operations shall record or expose a verifiable completion result.
- Cross-device synchronization shall not overwrite newer server data with stale client state.
- **Boot Lifecycle & Loader Dismissal:** The client initialization (`bootApp`) shall guarantee removal of the `#initial-page-loader` within 1.5 seconds via a resilient watchdog dismissal, preventing frozen loading screens under network delay or script interruptions.
- **Server Preprocessor Safe Syntax:** All client-side JavaScript templates embedded inside Apps Script HTML evaluations shall strictly avoid raw `//` comment delimiters inside `${...}` template interpolations to prevent server-side truncation and syntax errors.

### 7.3 Usability and accessibility

- Core workflows shall be operable by touch and keyboard.
- Inputs, controls, status messages, and dialogs shall have accessible labels and focus behavior.
- Text and action contrast shall remain readable in both themes.
- Forms shall show field-level validation and actionable error text.
- Layouts shall avoid horizontal overflow on common phone widths.
- **Mobile Header Action Controls:** In viewports narrower than 640px (`sm:` breakpoint), the top-right header action group shall present exactly four 2rem × 2rem (32px × 32px) touch targets with a uniform, equal 0.375rem (6px) flex gap: (1) Cloud Sync, (2) Theme Toggle, (3) Notification Bell, and (4) User Profile / Sign-in button. Padding and margins across wrapper containers shall be strictly zeroed to maintain visual alignment and prevent disproportionate gap offsets.

### 7.4 Performance and compatibility

Recommended release targets (to be measured; not claimed as current performance):

- Initial usable view within 4 seconds on a typical mobile broadband connection.
- Common navigation transitions within 1 second after data is loaded.
- No full-page reload for routine background synchronization.
- Validate current Chrome, Edge, Safari, and Android browser/WebView behavior.
- Provide graceful behavior when optional services (Drive, Gemini, Supabase, or Sheets) are unavailable.

## 8. Success measures

The product should instrument these measures without collecting unnecessary personal information:

1. Successful sign-in rate by role and frequency of blocked/inactive account failures.
2. Batch creation and roster maintenance completion rate.
3. Attendance save success rate and number of duplicate/invalid attendance submissions.
4. Material upload success rate and successful student downloads/opens.
5. Test/marks entry completion rate and report-card usage.
6. Fee-ledger update and reminder creation success rate.
7. Cross-device sync success, failure, and recovery rate.
8. Demo-mode enablement and demo-data cleanup verification outcomes.
9. User-reported mobile usability and support incidents.

Targets should be set after a baseline measurement; the current source does not establish analytics instrumentation or measured performance targets.

## 9. Release acceptance checklist

A release is acceptable when:

- [ ] Each role can sign in and sees only its allowed navigation and record scope.
- [ ] Developer settings cannot be opened by Admin, Teacher, or Student.
- [ ] Admin can create a batch/student and maintain account status and fees.
- [ ] Teacher attendance is constrained to assigned batches; student attendance is scoped to the logged-in student.
- [ ] Materials upload/download behavior works with the configured Drive permissions.
- [ ] Test creation, score validation, student report view, and print flow work.
- [ ] Fee reminders are targeted correctly and do not claim external SMS/WhatsApp delivery unless implemented.
- [ ] Feedback, gallery, and curated study links work on desktop and mobile.
- [ ] Demo login can be enabled/disabled independently from demo sample data.
- [ ] Demo seed and cleanup workflows preserve genuine records and protected settings/curated links, and verify all configured destinations.
- [ ] Failed writes and integrations show an explicit error; no false success notification is shown.
- [ ] Background sync does not unexpectedly reload the page or lose the user's current context.
- [ ] Android WebView outbound links open in the intended browser/app.

## 10. Risks and resolved/open product decisions

1. **Session duration alignment [RESOLVED]:** Unified saved credentials and session duration to **30 days** (`THIRTY_DAYS_MS`), matching `User_Manual.md` Section 4.4. The **2-hour inactivity auto-logout** is maintained for unattended active browser sessions to ensure security on shared devices.
2. **Payment collection [CONFIRMED]:** Confirmed that for v2.5 the portal operates as an internal fee ledger with institute bank/UPI instructions and receipt records; direct payment gateway checkout and banking reconciliation remain non-goals.
3. **Reminders [CONFIRMED]:** Confirmed that in-app notification center is the primary delivery channel for v2.5; third-party SMS/WhatsApp gateway delivery remains out-of-scope for this release.
4. **Apps Script Version & Deployment Lifecycle [RESOLVED]:** Script version history has been cleaned to operate safely beneath Google's hard 200-version cap. The 18 legacy deployments were retired, establishing a two-deployment operational structure: Development (`@HEAD` on `/dev`) and Production (`@202` on `/exec`).
5. **Mobile Top Navigation Uniformity [RESOLVED]:** Standardized all four mobile header action controls (`#btn-sync`, `#btn-theme-toggle`, `#btn-notifications`, and `#btn-mobile-profile`) to identical 2rem × 2rem boundaries with zero outer padding and uniform 0.375rem (6px) flex gaps, eliminating the visual gap mismatch previously observed adjacent to the profile button.
6. **Template String Comment Preprocessor Safety [RESOLVED]:** Sanitized template expressions in `javascript.html` to eliminate consecutive slash characters (`//`) within `${...}` interpolation blocks, preventing Apps Script's `HtmlService` parser from truncating lines and triggering browser `SyntaxError` failures during client boot.
7. **Parent access:** confirm whether parents should remain feedback-only respondents or receive a dedicated account and scoped student view.
8. **Authorization model:** confirm that server-side role and record-level checks cover every sensitive API, not just navigation and selected workflows.
9. **Offline behavior:** define exactly which edits may be queued offline, conflict-resolution rules, and what the user sees when local and server values differ.
10. **Source of truth:** document the intended precedence among Supabase, Apps Script storage, and Google Sheets for each record group.
11. **Database backup:** define backup schedule, restoration steps, retention period, and ownership of the connected cloud projects.
12. **Demo data:** define which operational tabs/tables receive demo records and confirm the protected-tab policy for every demo/cleanup action.
13. **Accessibility and performance:** establish supported viewport/device matrix and measurable release targets.

## 11. Source basis

This PRD was prepared from the application source and available user guides, including:

- `javascript.html` for login, navigation, role visibility, dashboard, module rendering, settings, and client workflows.
- `Code.js`, `Sheets.js`, and `supabase.html` for server operations, persistence, synchronization, attendance, notifications, and data management.
- `attendance.html`, `PageModules.html`, and the `Pages/` and `Routes/` modules for module structure and attendance behavior.
- `Seeds.js` for the canonical demo dataset.
- `User_Manual.md` and `User_Manual_Developer.md` for documented user and Developer workflows.
- `android/app/src/main/java/com/divineclasses/portal/MainActivity.java` for the Android WebView access channel.

The manuals include some claims and defaults that may differ from implementation details. The open-decision section records the known discrepancy; deployment-specific service configuration should be verified before treating an integration as production-ready.
