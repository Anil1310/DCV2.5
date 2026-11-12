# Divine Classes — Institute Portal User Manual

**Version:** 2.5 Cloud Edition  
**Applies to:** Admin, Teacher, Student and Developer portals  
**Last updated:** November 2026

---

## Table of Contents

1. [What This Portal Does](#1-what-this-portal-does)
2. [Roles and Permissions](#2-roles-and-permissions)
3. [Getting Started](#3-getting-started)
4. [Logging In](#4-logging-in)
5. [The Main Screen](#5-the-main-screen)
6. [Dashboard](#6-dashboard)
7. [Batches & Students](#7-batches--students)
8. [Attendance](#8-attendance)
9. [Student Fees & Reminders](#9-student-fees--reminders)
10. [Access Control](#10-access-control)
11. [Assignments & DPPs](#11-assignments--dpps)
12. [Offline Marks Tracker](#12-offline-marks-tracker)
13. [Faculty Management](#13-faculty-management)
14. [Results & Gallery](#14-results--gallery)
15. [External Study Hub](#15-external-study-hub)
16. [Parent & Student Feedback](#16-parent--student-feedback)
17. [Chatbot](#17-chatbot)
18. [Settings (Developer Only)](#18-settings-developer-only)
19. [Demo Mode](#19-demo-mode)
20. [Theme and Accent Colour](#20-theme-and-accent-colour)
21. [Cloud Sync and Data Safety](#21-cloud-sync-and-data-safety)
22. [Dummy / Demo Data](#22-dummy--demo-data)
23. [Client Handover Checklist](#23-client-handover-checklist)
24. [Troubleshooting](#24-troubleshooting)
25. [Glossary](#25-glossary)

---

## 1. What This Portal Does

Divine Classes is a complete coaching-institute management portal. It lets the institute:

- Manage batches and student records.
- Mark daily attendance and view monthly registers.
- Track student fees and send payment reminders.
- Control who can log in and reset passwords.
- Upload assignments, DPPs and test papers.
- Record offline test marks and print report cards.
- Manage faculty profiles and ID cards.
- Publish result banners and event photos.
- Share external study links.
- Collect parent and student feedback.
- Provide an AI study assistant (Gemini chatbot).
- Back up and synchronise data to the cloud.

The portal works on **laptop/desktop** and **mobile/Android**. On mobile, the main modules are available from the bottom navigation bar.

---

## 2. Roles and Permissions

There are four roles. Each role sees a different set of pages.

| Module | Admin | Teacher | Student | Developer |
|---|:---:|:---:|:---:|:---:|
| Dashboard | ✅ | ✅ | ✅ | ✅ |
| Batches & Students | ✅ | ✅ | ✅ (own batch only) | ✅ |
| Attendance | ✅ | ✅ | ✅ (own record) | ✅ |
| Student Fees & Reminders | ✅ | ❌ | ❌ | ✅ |
| Access Control | ✅ | ❌ | ❌ | ✅ |
| Assignments & DPPs | ✅ | ✅ | ✅ (own batch) | ✅ |
| Offline Marks Tracker | ✅ | ✅ | ✅ (own report card) | ✅ |
| Faculty Management | ✅ | ✅ (own profile) | ✅ (view only) | ✅ |
| Results & Gallery | ✅ | ✅ | ✅ | ✅ |
| External Study Hub | ✅ | ✅ | ✅ | ✅ |
| Parent & Student Feedback | ✅ | ✅ | ✅ | ✅ |
| Chatbot | ✅ | ✅ | ✅ | ✅ |
| Settings | ❌ | ❌ | ❌ | ✅ |

### Important role rules

- **Admin is not a Developer.** Admin does not get Developer permissions and cannot open Settings.
- **Settings is Developer-only.** Only the Developer can change global portal settings, database connections, demo data and role access.
- **Admin** manages day-to-day institute work: students, batches, attendance, fees, access control, materials, marks, faculty, gallery, links and feedback.
- **Teacher** manages their own profile, attendance, materials, marks and can add students to batches. Teachers cannot see fees or Access Control.
- **Student** sees only their own batch, attendance, materials, marks and profile-related information. Fees and Access Control are hidden.
- **Developer** can see every page and every setting.

> The Developer can also change which modules Admin, Teacher and Student can see from **Settings → Portal Access by Role**.

---

## 3. Getting Started

### What you need

- The portal web link supplied by the institute/developer.
- A supported browser: Chrome, Microsoft Edge, Safari or the Android browser.
- An internet connection for cloud sync.
- Your Login ID and password.

### First-time setup (Developer)

1. Open **Settings**.
2. Fill in **Institute Profile**, **Contact & Payments** and **Social Media Channels**.
3. Set a strong **Master Admin Password** in **Portal Security & Passwords**.
4. Connect the **Primary Cloud Database** and, if required, the **Cloud Mirror Backup**.
5. Review **Portal Access by Role**.
6. Turn **OFF** requirement labels and demo data before handing the portal to the client.
7. Save all settings.

### First-time setup (Admin)

1. Log in with the Admin ID and password.
2. Open **Batches & Students** and create the first batch.
3. Add students to the batch.
4. Open **Faculty Management** and add faculty profiles.
5. Open **Access Control** and confirm student/faculty accounts are authorised.
6. Change the Admin Master Password from **Access Control → Admin Master Password**.

---

## 4. Logging In

### 4.1 Login screen

Open the portal link. The login card asks for:

- **Login ID** — Roll Number, Email, Phone Number or Admin ID.
- **Password**.
- **Remember me** — keeps you signed in on this device.
- **Forgot Password?** — shows the institute contact number.

Tap the **eye icon** to show or hide the password.

### 4.2 Login IDs by role

| Role | What to enter as Login ID | Default password |
|---|---|---|
| **Admin** | `admin`, `anil`, `anil chahar`, or `admin@divineclasses.in` | `admin123` (or `admin`) |
| **Teacher** | Faculty email, phone number, or full name | `teacher123` (unless changed) |
| **Student** | Roll number (e.g. `DC-101`), phone number, or full name | `password123` (unless changed) |
| **Developer** | Lead Developer email configured on the server | Set in server Script Properties |

> Passwords are case-sensitive. If the institute has changed a password, use the new one. Contact the Admin if you have forgotten it.

### 4.3 Blocked or inactive accounts

- **Blocked** — the account cannot sign in. A helpline message appears.
- **Inactive** — the account is archived and hidden from normal lists.

Only an Admin can block, unblock or reactivate accounts from **Access Control**.

### 4.4 Session and auto-logout

- If **Remember me** is ticked, the session can last up to **30 days**.
- After **2 hours of inactivity**, the portal automatically logs you out for security.
- Always use the **logout button** on a shared computer.

---

## 5. The Main Screen

### 5.1 Header (top bar)

From left to right:

| Icon / area | What it does |
|---|---|
| **☰ Menu** | Opens or closes the sidebar. |
| **Page title** | Shows the current module. |
| **Cloud icon** | Manually syncs data with the cloud database. |
| **Moon / Sun icon** | Switches between Light and Dark theme (if your role is allowed). |
| **Bell icon** | Opens notifications. A red badge shows unread items. |
| **Profile / Logout** | Shows your account and the logout button (on mobile view, displayed as a 4th compact square button with equal spacing matching the other 3 controls). |

### 5.2 Sidebar

The sidebar lists every module your role can access. On mobile, use the **bottom navigation bar** instead.

### 5.3 Mobile bottom navigation

The bottom bar gives one-tap access to the main modules. The active module is highlighted. Some modules may be hidden depending on **Portal Access by Role**.

### 5.4 Notifications

Open the **bell icon** to see:

- Fee reminders.
- New study-material alerts.
- Institute notices.

Students receive fee reminders here and also see a reminder banner on the Dashboard.

### 5.5 Cloud sync indicator

The cloud button shows the sync state:

- **Syncing with Cloud…** — upload in progress.
- **✓ Cloud Synced** — data is up to date.
- **Saved locally** — saved on this device; cloud sync will retry.

---

## 6. Dashboard

The Dashboard is the home screen. It gives a quick summary of the institute.

### Admin dashboard

- **Active Batches** — number of batches and enrolled students.
- **Study Uploads** — total assignments, DPPs and test papers.
- **Offline Class Tests** — number of tests conducted.
- **Pending Fees** — total outstanding amount.
- Quick-action cards open the related module.
- Recent activity and cloud status.

### Teacher dashboard

- Assigned batches.
- Study uploads.
- Offline tests.
- Quick access to attendance, materials and marks.

### Student dashboard

- **My Batch** — the batch the student belongs to.
- **My Batch Materials** — files for the student's batch.
- **Offline Class Tests** — tests conducted.
- **My Attendance** — attendance percentage.
- **Fee reminder banner** — appears when a fee is due, with a **Pay / View Details** button.
- Buttons for **Student ID Card** and **View Attendance Sheet**.

> Dashboard cards are clickable and take you straight to the module.

---

## 7. Batches & Students

This module manages coaching batches and the students inside them.

### 7.1 Create a new batch (Admin / Developer)

1. Open **Batches & Students**.
2. Click **Create New Batch**.
3. Enter the batch name, room/hall, schedule, subjects and mentor.
4. Click **Create Batch**.

### 7.2 Add a student to a batch

**Admin:**

1. Open the batch card.
2. Click **Add Student**.
3. Choose an existing student or register a new one.
4. Save.

**Teacher:**

1. Open **Batches & Students**.
2. Click **+ Add Student to Any Batch**.
3. Select the batch and student.
4. Save.

### 7.3 Register a brand-new student

When adding a student, choose **Option 2: Enroll Brand New Student** and fill in:

- Full name.
- Roll number.
- Parent name.
- Phone number.
- Batch.
- Monthly fee / total fee.
- Due date.
- Photo (optional).

The student can then log in with their roll number, phone number or name.

### 7.4 View batch details

Each batch card shows:

- Room/hall.
- Schedule.
- Subjects.
- Mentor.
- Enrolled students.
- **View Batch Materials →** shortcut.

Students see only their own batch and classmates.

### 7.5 Student ID card

Admin, Teacher (where permitted) and the student can open a student's **ID Card**. The card can be printed or shared from the browser.

---

## 8. Attendance

Attendance is available to Admin, Teacher and Student.

### 8.1 Mark daily attendance (Admin / Teacher)

1. Open **Attendance**.
2. Select the **month**.
3. Select the **date**.
4. Select the **batch**.
5. For each student, choose:
   - **Present**
   - **Absent**
   - **Late**
6. Click **Save** next to a student, or use **Save attendance** to save the whole day.

### 8.2 Monthly register

Below the daily marking area, the monthly register shows saved records for the selected batch and month. Use it to review or correct attendance.

### 8.3 Edit attendance

- Use **Edit** next to a student to unlock a saved record.
- Change the status and save again.
- Use **Sync** to reload the month from the database.

### 8.4 Student view

Students see:

- Their own attendance percentage.
- Present / absent counts.
- The monthly attendance sheet.
- **View Attendance Sheet** from the Dashboard.

### 8.5 Tips

- Mark attendance on the same day to avoid missing records.
- Always choose the correct batch before saving.
- If a student joins mid-month, their earlier days remain blank rather than absent.

---

## 9. Student Fees & Reminders

**Admin and Developer only.** Teachers and students cannot open this module.

### 9.1 Fee summary cards

- **Monthly Expected Fees** — total expected from active students.
- **Total Fees Collected** — cumulative payments.
- **Fee Due Students** — number of students with pending fees.
- **Collection Health** — percentage of students up to date.

### 9.2 Fee ledger

The table lists each active student with:

- Student name and roll.
- Parent/contact.
- Total paid.
- Monthly fee.
- Status / fee due date.
- Actions.

### 9.3 Record a payment

1. Find the student in the fee ledger.
2. Open the payment action.
3. Enter the amount paid.
4. Save.

The student's paid amount and due status update immediately.

### 9.4 Send a reminder to one student

Click the **bell / reminder** button next to a student. The reminder is added to the student's notification bell and dashboard.

### 9.5 Send bulk reminders

Click **Send Bulk Reminders (N)** to notify every student with a pending fee at once.

> Reminders are in-app notifications. The institute can also use the student's phone number to send WhatsApp/SMS manually.

### 9.6 Export fees to CSV

Click **Export to CSV** to download the fee ledger. Open it in Excel, Google Sheets or any spreadsheet app.

### 9.7 Student fee view

Students do not see the fee ledger. They see:

- Their own pending balance.
- The due date.
- A **Pay / View Details** button.
- A fee reminder banner on the Dashboard.
- UPI payment ID from **Settings → Contact & Payments**.

---

## 10. Access Control

**Admin and Developer only.**

Access Control manages login access, passwords and account status.

### 10.1 Students tab

- Search by name, roll number or mobile.
- Filter by batch.
- **Authorize All** — sets all students to Active.
- **Reset All to Default** — resets student passwords to `password123`.
- **Inactive / Removed archive** — view archived students and restore them.

### 10.2 Teachers tab

- View all faculty accounts.
- **Authorize All Teachers** — sets all teachers to Active.
- Block or unblock individual teachers.
- Reset a teacher password.

### 10.3 Admin Master Password tab

- **Reveal / Hide** the current Admin Master Password.
- Enter a new password and confirm it.
- Click **Update Admin Password**.

> The Admin Master Password unlocks the Admin portal, Fees Management and Access Control.

### 10.4 Block or unblock an account

1. Find the student or teacher.
2. Click the status action.
3. Choose **Blocked** or **Active**.

Blocked users are stopped at login and shown a helpline message.

### 10.5 Change a student or teacher password

1. Find the account.
2. Click the key/password action.
3. Enter the new password.
4. Save.

### 10.6 Inactive vs Blocked

| Status | Meaning | Can log in? |
|---|---|---|
| **Active** | Normal account | ✅ Yes |
| **Blocked** | Access denied by Admin | ❌ No |
| **Inactive** | Archived / removed from active lists | ❌ No |

---

## 11. Assignments & DPPs

This module shares study files with students.

### 11.1 Upload a file (Admin / Teacher / Developer)

1. Open **Assignments & DPPs**.
2. Click **Upload Assignment / DPP / Test Paper**.
3. Enter:
   - Title.
   - Description.
   - Category: **Assignment PDF**, **Worksheet**, or **Test Paper**.
   - Batch (or General for all batches).
   - File.
4. Save.

The file is uploaded to the configured Google Drive folder and a download link is stored in the database.

### 11.2 Filter by batch (Admin / Teacher)

Use the **Filter by Batch** dropdown to show files for one batch or all batches.

### 11.3 Student view

Students see only:

- Files for their own batch.
- General files available to everyone.

Click any file to open or download it. On mobile, the file opens in the browser or the phone's download folder.

### 11.4 File status badges

- **Drive Link ✓** — the download link is saved.
- **No Link** — an old record whose file was never uploaded. Delete it and upload again.

### 11.5 Tips

- Use clear titles, e.g. `Physics DPP-04 — Electrodynamics`.
- Keep file names short.
- Check that the Drive folder is shared correctly before uploading.
- Students receive a notification when new material is uploaded.

---

## 12. Offline Marks Tracker

This module records marks from offline class tests.

### 12.1 Create a test (Admin / Teacher / Developer)

1. Open **Offline Marks Tracker**.
2. Click **Create Test Record**.
3. Enter:
   - Target batch.
   - Test title.
   - Subject.
   - Test date.
   - Maximum marks.
4. Click **Create Test Record**.

### 12.2 Enter marks

1. Select the batch and test.
2. For each student, enter the score and optional remarks.
3. Click **Save** next to a student, or **Save All** for the whole batch.

Marks are validated against the maximum marks.

### 12.3 Analytics

The module shows:

- Average score.
- Highest score.
- Student-wise performance.
- Test-wise comparison.

### 12.4 Student report card

Students see:

- **My Test Report Card**.
- Test name, date, subject and marks.
- Percentage and remarks.
- **Print Report** for a PTM report card.
- **My ID Card**.

### 12.5 Print a report

Use **Print Report** / **Print PTM Report Card**. The browser print dialog opens; choose a printer or **Save as PDF**.

---

## 13. Faculty Management

### 13.1 Add faculty (Admin / Developer)

1. Open **Faculty Management**.
2. Click **Add Faculty Profile**.
3. Enter:
   - Name.
   - Subject.
   - Qualification.
   - Experience.
   - Specialisation.
   - Bio.
   - Email and phone (used for login).
   - Photo (optional).
4. Save.

### 13.2 Teacher's own profile

Teachers see a **My Faculty Profile** card with:

- **Edit My Profile**.
- **Update Photo**.
- **Faculty ID Card**.

### 13.3 Student view

Students can view active faculty profiles: subject, qualification, experience, specialisation and doubt-solving timings.

### 13.4 Faculty ID card

Open a faculty profile and click **Faculty ID Card** to print or share it.

---

## 14. Results & Gallery

### 14.1 Add a result banner or photo (Admin / Developer)

1. Open **Results & Gallery**.
2. Click **Share Result Banner / Photo**.
3. Enter:
   - Title.
   - Category.
   - Badge / achievement text.
   - Caption.
   - Image URL or upload.
4. Save.

### 14.2 View the gallery

- Click any image to open the **lightbox**.
- The lightbox shows the full banner.
- Close it with the **×** button.

### 14.3 Tips

- Use clear result banners with student names and ranks only if permission is given.
- Keep images under the recommended size for faster loading.
- Gallery items are visible to all roles.

---

## 15. External Study Hub

This module shares links to external study resources.

### 15.1 Add a study link (Admin / Teacher)

1. Open **External Study Hub**.
2. Click **Add Study Link**.
3. Enter:
   - Resource title.
   - Website / provider.
   - Subject tag.
   - URL.
   - Description.
4. Click **Add Link**.

### 15.2 Open a link

Click **Open Material** to open the resource in a new tab.

### 15.3 Delete a link

Admin can delete a link only if **Settings → Admin Permissions → Allow Admin to Delete Study Links** is ON. The Developer can always delete.

> The **External Study Links Hub** is preserved by the permanent dummy/testing-data cleanup.

---

## 16. Parent & Student Feedback

### 16.1 Submit feedback

1. Open **Parent & Student Feedback**.
2. Enter:
   - Full name.
   - Submitted as: **Parent** or **Student**.
   - Rating (3–5 stars).
   - Associated batch.
   - Category: Teaching Quality, Offline Test Series, Study Material & DPPs, General Suggestion.
   - Comment.
3. Click **Submit Feedback**.

### 16.2 Feedback wall

The right side shows recent feedback with:

- Author and role.
- Batch and date.
- Star rating.
- Comment.
- Category.

### 16.3 Delete feedback

Admin can delete feedback only if **Settings → Admin Permissions → Allow Admin to Delete Feedback** is ON. The Developer can always delete.

---

## 17. Chatbot

The Chatbot is an AI study assistant powered by Google Gemini.

### 17.1 Enable the chatbot (Developer)

1. Open **Settings → Portal Chatbot**.
2. Turn **ON Enable Gemini Help Chatbot**.
3. Save.

### 17.2 Connect your Gemini key (each user)

Each user connects their own key:

1. Open **Chatbot**.
2. Click **Connect Gemini**.
3. Create a Gemini API key in **Google AI Studio** while signed in with your Google account.
4. Paste the key and save.

The key is stored **only in that browser profile** for that portal account. It is not saved in the shared database.

### 17.3 Use the chatbot

- Type a question and press Enter.
- Use the microphone button for voice typing.
- Use suggested prompts for common questions.
- Click **New Chat** to start again.
- Copy a response with the **Copy** button.

### 17.4 Privacy and limits

- Private student records are not sent to Gemini.
- Google AI Studio free-tier quotas apply.
- If the quota is reached, wait or use a paid plan.
- Disconnect the key at any time from the Chatbot settings.

---

## 18. Settings (Developer Only)

Settings is visible **only to the Developer**. Admin, Teacher and Student cannot open it.

Open **Settings** from the sidebar. The categories are:

### 18.1 Institute Profile

- Institute Name.
- Tagline / Mission.
- Centre Address.

The address appears on the login screen.

### 18.2 Contact & Payments

- Helpline Phone.
- Display Contact.
- Official Email.
- UPI Payment ID.

The UPI ID appears in student fee reminders.

### 18.3 Social Media Channels

- Facebook Page URL.
- Instagram Profile URL.
- YouTube Channel URL.

### 18.4 Portal Security & Passwords

- Admin Name.
- Master Admin Password.
- Admin Email ID.

> The Admin can also change the Master Admin Password from **Access Control → Admin Master Password**. Lead Developer credentials are stored server-side and are never sent to the page.

### 18.5 Database Connections

- **Cloud Mirror Backup** — mirrors saves to the secondary backup ledger.
- **Primary Cloud Database** — the main cloud database.
- **Cloud Project URL** and **Cloud Access Key**.
- **Recreate Fresh Cloud Database** — recreates fresh tables and baseline records.

> Use **Recreate Fresh Cloud Database** with caution. It is intended for initial setup or recovery.

### 18.6 Portal Chatbot

- **Enable Gemini Help Chatbot** — shows Chatbot to Admin, Teacher and Student.
- Each user connects their own Gemini key from the Chatbot page.

### 18.7 Client Demo Mode

- **Show "Requirement #N" Labels** — ON for development view, OFF for clean client view.
- **Show Dummy / Demo Data (Seed Records)** — ON creates/restores six demo records per table. OFF permanently deletes demo/testing rows after confirmation.

> Genuine client records and the protected **External Study Links Hub** and **Settings Config** tables are preserved.

### 18.8 Demo Login Button

- **Show Demo Button on Login Page** — ON shows one-tap Admin / Teacher / Student demo buttons. Turn OFF before client handover.
- This switch saves automatically. Teacher and Student demo buttons use the first active account for that role.
- Demo login grants password-free role access. Use demo-safe records and turn the switch OFF as soon as the preview is finished.

### 18.9 Admin Permissions

- **Allow Admin to Delete Feedback**.
- **Allow Admin to Delete Study Links**.

The Developer always keeps full control.

### 18.10 Portal Access by Role

Tick or untick modules for **Admin**, **Teacher** and **Student**. Developer always has access to everything.

Use this to hide a module from a role without changing the code.

### 18.11 Coaching Owner's GDrive Folder

- Owner's Drive Folder Link.
- Google Drive Email ID.
- Google Account Password.
- Drive Link to Open.
- **Open Drive** button.

New assignments, photos and gallery uploads use this folder. Leave the folder link blank to use the portal's default storage.

### 18.12 Demo Data & Database Setup

- **Clear All Application Data** — a Developer-only action clears app records, including genuine client records and attendance, from the Apps Script Cloud Database, Google Sheets, and Supabase. External Study Links, settings, and sheet headers are preserved.

> This is permanent. It removes link entries from the app but does not delete files or content hosted at external URLs.

### 18.13 Portal Appearance & Theme

- **Toggle theme** — Light / Dark.
- **Portal accent colour** — Indigo, Ocean, Emerald or Rose.
- **Theme button access by role** — choose whether Admin, Teacher and Student can see the theme button. Developer always has access.
- These controls save automatically.

### 18.14 Save All Settings

The main settings form has a **Save All Settings** button. Saving instantly syncs changes to the cloud database.

Every settings panel now saves its controls automatically; none of the settings modals shows a **Save changes** button. The main **Save All Settings** button at the bottom of the Settings page remains as an optional full save.

---

## 19. Demo Mode

Demo Mode lets you show the portal without entering passwords.

### 19.1 Use Demo Mode

1. Open the login screen.
2. In the **Demo Mode** card, click:
   - **Admin**
   - **Teacher**
   - **Student**
3. The portal opens instantly as that role.

Demo Mode is intended for sales demos, training and testing.
Teacher and Student previews use the first active account for each role; the Admin preview exposes the Admin role.

### 19.2 Turn Demo Mode on or off

Developer: **Settings → Demo Login Button → Show Demo Button on Login Page**.

- ON — demo buttons visible.
- OFF — demo buttons hidden.

> Turn Demo Mode **OFF before client handover**.

### 19.3 Demo data vs Demo login

These are separate:

- **Demo Login Button** controls the one-tap role buttons.
- **Show Dummy / Demo Data** controls sample records in the database.

You can turn off the demo buttons while keeping demo data, or vice versa.

---

## 20. Theme and Accent Colour

### 20.1 Default theme by device

| Device | Default theme |
|---|---|
| Mobile / Android / narrow screen | **Light** |
| Laptop / desktop / wide screen | **Dark** |

After the first launch, the portal remembers the choice made on that device mode.

### 20.2 Switch theme

Click the **Moon / Sun** button in the header. The choice is saved on the current browser.

If the button is hidden, the Developer has turned off theme access for your role in **Settings → Portal Appearance & Theme**.

### 20.3 Accent colour

Developer: **Settings → Portal Appearance & Theme → Portal accent colour**.

Options:

- Indigo
- Ocean
- Emerald
- Rose

The accent colour changes primary buttons and enabled switches. It is saved on the current browser.

### 20.4 If a phone still looks dark

Some mobile browsers force dark mode on every website. If the portal stays dark on a phone:

1. Open the browser settings.
2. Find **Dark mode** / **Appearance**.
3. Set it to **System default** or **Off** (not **Always**).
4. Clear the browser cache for the portal.
5. Reload the page.

---

## 21. Cloud Sync and Data Safety

### 21.1 How saving works

- Changes are saved on the device immediately.
- The portal then syncs to the cloud database automatically.
- The header cloud button forces a manual sync.

### 21.2 Primary database and backup

- **Primary Cloud Database** stores students, batches, attendance, materials, tests, gallery, feedback and notifications.
- **Cloud Mirror Backup** keeps a secondary copy when enabled.
- **Google Sheets** can be used as a backup/mirror.
- The all-data clear removes **External Study Links Hub** records but preserves **Settings_Config** and Supabase `settings_config`.

### 21.3 Offline mode

If the internet drops:

- The portal keeps working with saved data.
- A message says **Offline Mode: Using saved data on your phone**.
- When the connection returns, cloud sync resumes.

### 21.4 Cross-device sync

Settings and data changes sync automatically between the laptop browser and Android app while Supabase is enabled and both have an internet connection. Settings are checked every 4 seconds while the app is open; when Android resumes a paused app, it checks immediately. Sync happens without reloading the page.

If a change is not visible, check the internet connection and confirm the cloud database is enabled. The cloud icon can still be clicked for a manual sync.

### 21.5 Data safety rules

- Do not clear browser data unless you have a cloud backup.
- Use **Clear All Application Data** only when you are ready to remove all institute records, including genuine client data. External Study Links are preserved.
- Keep the **Settings_Config** tab and Supabase `settings_config` table intact.
- Export fee data to CSV regularly as an extra backup.
- Take a Google Sheets backup before major changes.

---

## 22. Dummy / Demo Data

The portal can create six sample records per table for testing.

### 22.1 Demo data availability

The Developer can use **Show Dummy / Demo Data (Seed Records)** to add sample records for testing. A permanent wipe removes the current sample records, but the Developer can explicitly create them again later. Genuine records are preserved.

Use **Create Demo Data** in **Settings → Database Connections** or turn ON **Show Dummy / Demo Data**. The app verifies the records in its Apps Script Cloud Database and Supabase before reporting success; the button remains available after creation. If Supabase rejects or cannot return the rows (for example due to table schema or RLS permissions), the error is shown instead of a success message. Demo data also refreshes matching Google Sheets tabs and the settings list in **Settings_Config** and Supabase `settings_config`. Admin/Developer password settings and the Supabase key are excluded from Supabase settings and snapshots.

### 22.2 Permanently clear application data

Developer: **Settings → Demo Data & Database Setup → Clear All Application Data**.

This clears application records from the Apps Script Cloud Database, Google Sheets, and Supabase while preserving the **External_Links_Hub** sheet and Supabase external-links tables. Confirm with your Developer email and password, then type **CLEAR ALL APPLICATION DATA**.

- Student, teacher, batch, attendance, material, test, gallery, feedback, and notification records are cleared. External Study Links remain available.
- `Settings_Config`, Supabase `settings_config`, operational settings, and Google Sheets tab headers are preserved so the app remains configured. Only the demo-data wipe flags are updated.
- The portal disables demo-data creation after the clear. The button remains available to clear records added later.
- The current device clears its pending sync state. Connected devices receive the updated snapshot; stale pre-clear state is rejected or replaced before it can sync again.

If Apps Script reports that its daily `UrlFetch` quota is exhausted, use `clear_supabase_data.py` from the project folder. Run `python3 clear_supabase_data.py` for a read-only preview, then `python3 clear_supabase_data.py --execute` to proceed. The script prompts for the Supabase project URL and API key; use a key authorized to delete rows. Alternatively, review `clear_supabase_data.sql` carefully, then run it in the Supabase SQL Editor; it commits the deletion. Both options clear Supabase only, preserve external links and operational settings, and do not clear Google Sheets. Never commit or share a privileged API key.

---

## 23. Client Handover Checklist

Before giving the portal to the client:

- [ ] Update **Institute Profile** (name, tagline, address).
- [ ] Update **Contact & Payments** (phone, email, UPI).
- [ ] Update **Social Media Channels**.
- [ ] Set a strong **Master Admin Password**.
- [ ] Confirm the **Primary Cloud Database** is connected.
- [ ] Review **Portal Access by Role**.
- [ ] Turn **OFF Show "Requirement #N" Labels**.
- [ ] Turn **OFF Show Dummy / Demo Data** and clear demo records.
- [ ] Turn **OFF Demo Login Button**.
- [ ] Review **Admin Permissions** for feedback and link deletion.
- [ ] Check the **Coaching Owner's GDrive Folder**.
- [ ] Test Admin, Teacher and Student logins.
- [ ] Test attendance, fee reminder, material upload and marks entry.
- [ ] Test the theme on laptop and mobile.
- [ ] Export a fee CSV backup.
- [ ] Give the client this manual and the portal link.

---

## 24. Troubleshooting

### I cannot log in

- Check the Login ID: roll number, email, phone or Admin ID.
- Check Caps Lock and the password spelling.
- Ask the Admin to confirm the account is **Active**, not **Blocked** or **Inactive**.
- Ask the Admin to reset the password from **Access Control**.

### The Demo buttons are missing

Developer: **Settings → Demo Login Button → Show Demo Button on Login Page** → ON.

### I cannot see a module

- Your role may not have access.
- Developer: check **Settings → Portal Access by Role**.
- Admin/Teacher/Student: ask the Developer to enable it.

### I cannot see Settings

Settings is **Developer-only**. Admin does not have Developer permissions. Use **Access Control** for passwords and account access.

### Changes are not showing on another device

1. Click the **cloud icon** to sync.
2. Refresh the page.
3. Check the internet connection.
4. Confirm the cloud database is enabled.

### Fee reminders are not appearing

- The student must have a pending balance.
- The reminder must be sent from **Student Fees & Reminders**.
- The student should check the **bell icon** and the Dashboard banner.

### A file will not upload

- Check the Google Drive folder link and sharing permissions.
- Check the file size and format.
- Try a smaller file.
- Confirm the Drive account is connected.

### The chatbot is not working

- Confirm **Settings → Portal Chatbot** is ON.
- Click **Connect Gemini** and paste a valid Google AI Studio key.
- Check the Gemini free-tier quota.
- Try **New Chat**.

### The theme button is missing

Developer: **Settings → Portal Appearance & Theme → Theme button access by role** → enable the role.

### The phone stays dark

- Set the browser's dark mode to **System default** or **Off**.
- Clear the browser cache for the portal.
- Reload the page.
- Try an InPrivate/Incognito tab to test whether the issue is cache-related.

### The page looks outdated or Android app does not show latest changes

- Force-close (swipe away) the Android app and reopen it to bypass WebView cache.
- For desktop browser: refresh the page (`Ctrl+F5` or `Cmd+Shift+R`) or clear the browser cache.
- Confirm the production deployment (`AKfycbzlbJUklVvhuJzIDoWv3a3CXY4trX435BiGD1JGIOeuYJC7PiR5lqI15Ymz0kFEpf0P`) was updated to the latest version number using `clasp deploy -i <id> -V <version>`.
- If Google Apps Script reports that the 200-version cap is reached, open the **Project History (🕒 icon)** in the Apps Script editor, bulk delete old versions, and redeploy.

### Stuck on initial connecting spinner

- The portal has an automatic 1.5-second fail-safe watchdog that forcibly dismisses `#initial-page-loader` and renders the workspace.
- If editing code, avoid using raw double-slash (`//`) comment markers inside JavaScript template literals (`${...}`) as Apps Script's `HtmlService` strips them on the server, causing syntax errors.

### Data disappeared after clearing demo data

After a permanent demo-data wipe, the records are removed from connected stores. A Developer can create fresh demo/testing records again using **Show Dummy / Demo Data (Seed Records)**; previous non-demo records are not restored by that action.

---

## 25. Glossary

| Term | Meaning |
|---|---|
| **Batch** | A group of students taught together. |
| **DPP** | Daily Practice Problems. |
| **Offline Test** | A written test conducted in class. |
| **Fee Ledger** | The table of student fees and payments. |
| **Access Control** | The Admin page for passwords and account status. |
| **Demo Mode** | One-tap login as Admin, Teacher or Student without a password. |
| **Dummy Data** | Sample records used for testing. |
| **Primary Cloud Database** | The main online database. |
| **Cloud Mirror Backup** | A secondary copy of database saves. |
| **External Study Hub** | Links to outside study resources. |
| **Settings Config** | The protected table that stores portal settings. |
| **Requirement Labels** | Development tags like "Requirement #5" shown in headers. |
| **Accent Colour** | The main colour used for buttons and switches. |
| **PTM Report Card** | Parent-Teacher Meeting report printed from marks. |

---

## Quick Reference Card

| Task | Where to go |
|---|---|
| Create a batch | Batches & Students → Create New Batch |
| Add a student | Batches & Students → Add Student |
| Mark attendance | Attendance → select date/batch → Save |
| Record a fee payment | Student Fees & Reminders → student action |
| Send fee reminders | Student Fees & Reminders → Send Bulk Reminders |
| Reset a password | Access Control → student/teacher → key icon |
| Change Admin password | Access Control → Admin Master Password |
| Upload a DPP | Assignments & DPPs → Upload |
| Create a test | Offline Marks Tracker → Create Test Record |
| Print a report card | Offline Marks Tracker → Print Report |
| Add faculty | Faculty Management → Add Faculty Profile |
| Add a gallery photo | Results & Gallery → Share Result Banner / Photo |
| Add a study link | External Study Hub → Add Study Link |
| Submit feedback | Parent & Student Feedback |
| Connect Gemini | Chatbot → Connect Gemini |
| Change theme | Header Moon/Sun button |
| Change accent colour | Settings → Portal Appearance & Theme |
| Turn off demo buttons | Settings → Demo Login Button |
| Clear demo data | Settings → Demo Data & Database Setup |
| Sync now | Header cloud icon |

---

**End of Manual**

For support, contact the institute office or the portal developer.
