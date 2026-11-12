# Data synchronization and clearing

- Removed demo and test record seeding from startup, empty-database recovery, and ordinary sync. New/handed-over installs start without student, batch, teacher, material, test, gallery, feedback, or notification seed records.
- Added a server-side Script Properties lock that keeps cleared demo/test data deleted even if a stale browser or old snapshot syncs. Explicit developer actions can intentionally recreate samples; the clear action re-locks them.
- Made browser defaults empty and added client-side filtering when the persisted lock is active, including direct Supabase table/snapshot and Realtime updates.
- Extended dummy-student detection and Supabase cleanup to recognize the seeded roll numbers in both `students` and `students_master`, and kept seed student/test references from being restored during sync.
- Routed the explicit “Create Demo Data” control through the demo-data creation API so ordinary sync cannot bypass the lock.
- Updated Supabase loading so an empty cloud table clears the corresponding app collection rather than leaving stale records visible.
- Added Supabase-first startup behavior to avoid replacing cloud data with an older Apps Script snapshot.
- Removed fallback/demo roster IDs when Supabase batches have no students.
- Added propagation of app-side row deletions to Supabase.
- Parallelized Supabase table reads and independent table writes. Sync now sends changed rows where possible, and overlapping sync requests queue a follow-up so changes made during an in-flight save are not lost.
- Added Supabase Realtime listeners for app tables, `db_json`, and `settings_config`, with a slower periodic refresh fallback and refreshes when the app returns to the foreground.
- Updated the Developer clear-all operation to remove all application records, including external-link entries, from supported Supabase tables, Apps Script Cloud Database collections, Google Sheets data tabs, and attendance rows. It retains operational settings and sheet headers, updates only the demo-wipe flags, verifies Supabase deletes, and publishes an empty snapshot for connected clients.
- Clarified the clear-all UI to describe the affected stores and reset local app state after a successful clear.
- Added a developer-only “Clear Student Table” action requiring server-verified developer credentials and the exact `CLEAR STUDENTS` confirmation. It clears the app roster, `Students_Master`, and supported Supabase student tables.
- Persisted a student-seed lock and clear timestamp so demo students and stale pre-clear rows cannot be restored by a later sync. New enrollments retain their creation timestamp and remain eligible for sync; Supabase reloads recover that timestamp from the saved snapshot.
- Made the student enrollment flow wait for the cloud/Supabase persistence result and report failures rather than indicating success before the write completes.

## Teacher profile access

- Connected the teacher dashboard’s “My Profile” action to the signed-in teacher’s own profile view.
- Changed Facebook social links to open in the top-level page so Facebook is not embedded in the Apps Script frame, which can refuse the connection.
- Applied the selected portal accent palette to rose-colored action buttons as well, including destructive action buttons, while retaining the selected theme’s hover color.

## Google Drive material uploads

- Changed material upload persistence to update only the materials and notifications collections instead of loading and rewriting the entire app database.
- Changed the `Materials_Repository` mirror to insert the new material row instead of rebuilding the whole sheet.
- Avoided a redundant full app sync after the upload API has already saved the material.
- Matched the server and browser material-notification IDs and calculated the displayed file size from the decoded file bytes.
- Added cleanup of the newly created Drive file if the primary material record cannot be saved.

## Login and logout responsiveness

- Avoided the developer-login settings/sheet lookup when the developer email is already configured in Script Properties; credential verification remains server-side.
- Avoided redundant logout rendering of the hidden sidebar.
- Increased the Apps Script notification polling interval from 20 to 60 seconds; foreground refresh remains enabled.

## `App_Data` sheet investigation

- Searched the project for an `App_Data` spreadsheet tab reference and did not find one. The project uses a hidden `DB_JSON` snapshot tab and a browser local-storage cache; `App_Data` may belong to another or older deployment.

## Validation and deployment notes

- Parsed the modified JavaScript and inline HTML script blocks.
- Ran focused mock checks for empty-table replacement, parallel Supabase reads/writes, queued sync changes, Realtime row insert/update/delete handling, empty-snapshot handling, clear-all snapshot recreation, and incremental Drive upload persistence.
- These checks passed. No live Supabase, Google Sheets, or Drive test was run, and the changes have not been deployed.
- The seed-data lock, empty cold startup, stale-client sync, explicit recreation, browser-side filtering, student clear timestamp cutoff, and clear-all settings preservation/table-alias behavior were syntax-checked and mock-tested locally; confirm the clear actions against the live Supabase project before client handover.
- Supabase Realtime requires the relevant tables to be enabled in the project’s Realtime publication. If it is unavailable, the slower periodic refresh remains as a fallback. End-to-end millisecond sync and performance for 150 simultaneous users have not been load-tested.

## Android companion app modernization & release signing

- Resolved Groovy DSL deprecations in `android/app/build.gradle` using canonical assignment syntax (`namespace = ...`, `compileSdk = 35`, etc.).
- Created `android/app/proguard-rules.pro` protecting `@android.webkit.JavascriptInterface` native bridge methods and WebClient classes against R8/ProGuard stripping.
- Created `android/local.properties` pointing to the verified local Android SDK (Platform 35).
- Generated 2048-bit RSA release signing keystore `divine-release.jks` and configured `signingConfigs.release`.
- Configured lint exception bypass for preview/newer Java 25 JBR runtimes.
- Built and verified both `app-debug.apk` (2.7 MB) and `app-release.apk` (2.2 MB signed with APK Signature Scheme v2).

## Session duration alignment & PRD resolution

- Unified remembered credentials and auth session lifetime in `javascript.html` to **30 days** (`THIRTY_DAYS_MS`), matching `User_Manual.md` Section 4.4, while preserving the 2-hour inactivity auto-logout for unattended active browser sessions.
- Updated `PRD.md` Section 10 to record resolved decisions: 30-day session alignment, in-portal notifications as authoritative for v2.5, and external payment instructions without direct gateway checkout.

## Apps Script live deployment

- Pushed 67 project files live to Google Apps Script (`1pb6iaWboEufMVFkVC1vi9sfn9QH6-h7ykql4RAXdAxsgLAhl0WEnEkEJ`) via clasp.
- Updated production web app deployment `AKfycbzlbJUklVvhuJzIDoWv3a3CXY4trX435BiGD1JGIOeuYJC7PiR5lqI15Ymz0kFEpf0P` to version `@197`, serving the latest live build to web and Android companion app clients.

## Completed implementation summary

- Completed 62 steps in 8m 35s.
- Implemented teacher self-profile access, student enrollment persistence to the app database and Supabase, developer-only student-table clearing, the persistent student seed lock and stale-row cutoff, and Supabase recovery of student creation timestamps.
- Updated `javascript.html`, `Code.js`, `Seeds.js`, `supabase.html`, and `Pages/Settings/code.js`.
- JavaScript syntax checks and the focused student seed-lock/cutoff behavior check passed. The live Apps Script/Supabase flow was not tested.
- Recorded implementation totals: `+529-24`; 7 files changed, `+521-16`.
