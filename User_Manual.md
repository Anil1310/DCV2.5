# Divine Classes — Institute Portal User Manual

**For:** Admin, Teacher and Student users  
**Version:** 2.5 Cloud Edition  
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
18. [Theme and Accent Colour](#18-theme-and-accent-colour)
19. [Cloud Sync and Offline Use](#19-cloud-sync-and-offline-use)
20. [Troubleshooting](#20-troubleshooting)
21. [Quick Reference Card](#21-quick-reference-card)

---

## 1. What This Portal Does

Divine Classes is a coaching-institute management portal. It lets the institute manage batches, students, attendance, fees, study material, test marks, faculty, results, study links, feedback and an AI study assistant.

The portal works on **laptop/desktop** and **mobile/Android**. On mobile, the main modules are available from the bottom navigation bar.

---

## 2. Roles and Permissions

There are three user roles. Each role sees a different set of pages.

| Module | Admin | Teacher | Student |
|---|:---:|:---:|:---:|
| Dashboard | ✅ | ✅ | ✅ |
| Batches & Students | ✅ | ✅ | ✅ (own batch only) |
| Attendance | ✅ | ✅ | ✅ (own record) |
| Student Fees & Reminders | ✅ | ❌ | ❌ |
| Access Control | ✅ | ❌ | ❌ |
| Assignments & DPPs | ✅ | ✅ | ✅ (own batch) |
| Offline Marks Tracker | ✅ | ✅ | ✅ (own report card) |
| Faculty Management | ✅ | ✅ (own profile) | ✅ (view only) |
| Results & Gallery | ✅ | ✅ | ✅ |
| External Study Hub | ✅ | ✅ | ✅ |
| Parent & Student Feedback | ✅ | ✅ | ✅ |
| Chatbot | ✅ | ✅ | ✅ |

### Role rules

- **Admin** manages day-to-day institute work: students, batches, attendance, fees, access control, materials, marks, faculty, gallery, links and feedback.
- **Teacher** manages their own profile, attendance, materials and marks, and can add students to batches. Teachers cannot see fees or Access Control.
- **Student** sees only their own batch, attendance, materials, marks and profile-related information.
- **Settings** is not available to users. It is managed by the Developer. Contact the Developer or institute office for portal-wide changes.

> The Developer may also choose which modules Admin, Teacher and Student can see. If a module is missing from your menu, ask the Developer to enable it.

---

## 3. Getting Started

### What you need

- The portal link supplied by the institute.
- A supported browser: Chrome, Microsoft Edge, Safari or the Android browser.
- An internet connection for cloud sync.
- Your Login ID and password.

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

> Passwords are case-sensitive. If the institute has changed a password, use the new one. Contact the Admin if you have forgotten it.

### 4.3 Blocked or inactive accounts

- **Blocked** — the account cannot sign in. A helpline message appears.
- **Inactive** — the account is archived and hidden from normal lists.

Only an Admin can block, unblock or reactivate accounts from **Access Control**.

### 4.4 Session and auto-logout

- If **Remember me** is ticked, the session can last up to **30 days**.
- After **2 hours of inactivity**, the portal automatically logs you out for security.
- Always use the **logout button** on a shared computer.

### 4.5 Demo Mode

If the Developer has enabled it, the login screen shows a **Demo Mode** card with one-tap **Admin**, **Teacher** and **Student** buttons. These open the portal instantly without a password for demos and training.

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
| **Profile / Logout** | Shows your account and the logout button (on mobile view, displayed as a 4th compact square icon with equal spacing matching the other controls). |

### 5.2 Sidebar and mobile navigation

The sidebar lists every module your role can access. On mobile, use the **bottom navigation bar** instead.

If the Developer has enabled it, a **Guide** button also appears in the sidebar. Clicking it opens the user manual with instructions for using the portal.

If the Developer has enabled it, a **Theme** button also appears in the sidebar. Clicking it lets you switch between Light and Dark mode and choose an accent color.

### 5.3 Notifications

Open the **bell icon** to see:

- Fee reminders.
- New study-material alerts.
- Institute notices.

Students receive fee reminders here and also see a reminder banner on the Dashboard.

### 5.4 Cloud sync indicator

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

### 7.1 Create a new batch (Admin)

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

**Admin only.** Teachers and students cannot open this module.

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
- UPI payment ID from the institute's payment settings.

---

## 10. Access Control

**Admin only.**

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

### 11.1 Upload a file (Admin / Teacher)

1. Open **Assignments & DPPs**.
2. Click **Upload Assignment / DPP / Test Paper**.
3. Enter:
   - Title.
   - Description.
   - Category: **Assignment PDF**, **Worksheet**, or **Test Paper**.
   - Batch (or General for all batches).
   - File.
4. Save.

The file is uploaded to the institute's Google Drive folder and a download link is stored in the database.

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

### 12.1 Create a test (Admin / Teacher)

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

### 13.1 Add faculty (Admin)

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

### 14.1 Add a result banner or photo (Admin)

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

Admin can delete a link only if the Developer has enabled **Allow Admin to Delete Study Links**. Otherwise, contact the Developer.

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

Admin can delete feedback only if the Developer has enabled **Allow Admin to Delete Feedback**. Otherwise, contact the Developer.

---

## 17. Chatbot

The Chatbot is an AI study assistant powered by Google Gemini.

### 17.1 Enable the chatbot

The Chatbot is enabled by the Developer. If it is not visible, ask the Developer to turn it on.

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

## 18. Theme and Accent Colour

### 18.1 Default theme by device

| Device | Default theme |
|---|---|
| Mobile / Android / narrow screen | **Light** |
| Laptop / desktop / wide screen | **Dark** |

After the first launch, the portal remembers the choice made on that device mode.

### 18.2 Switch theme

Click the **Moon / Sun** button in the header. The choice is saved on the current browser.

If the button is hidden, the Developer has turned off theme access for your role.

### 18.3 Accent colour

The accent colour is set by the Developer. It changes primary buttons and enabled switches. Options include Indigo, Ocean, Emerald and Rose.

### 18.4 If a phone still looks dark

Some mobile browsers force dark mode on every website. If the portal stays dark on a phone:

1. Open the browser settings.
2. Find **Dark mode** / **Appearance**.
3. Set it to **System default** or **Off** (not **Always**).
4. Clear the browser cache for the portal.
5. Reload the page.

---

## 19. Cloud Sync and Offline Use

### 19.1 How saving works

- Changes are saved on the device immediately.
- The portal then syncs to the cloud database automatically.
- The header cloud button forces a manual sync.

### 19.2 Offline mode

If the internet drops:

- The portal keeps working with saved data.
- A message says **Offline Mode: Using saved data on your phone**.
- When the connection returns, cloud sync resumes.

### 19.3 Cross-device sync

Changes made on one device appear on other devices after sync. If a change is not visible:

1. Click the **cloud icon** to sync.
2. Refresh the page.
3. Check the internet connection.
4. Confirm the cloud database is enabled.

### 19.4 Data safety

- Do not clear browser data unless you have a cloud backup.
- Export fee data to CSV regularly as an extra backup.
- Contact the Developer before major data changes.

---

## 20. Troubleshooting

### I cannot log in

- Check the Login ID: roll number, email, phone or Admin ID.
- Check Caps Lock and the password spelling.
- Ask the Admin to confirm the account is **Active**, not **Blocked** or **Inactive**.
- Ask the Admin to reset the password from **Access Control**.

### The Demo buttons are missing

Demo Mode is controlled by the Developer. Ask the Developer to enable it if needed.

### I cannot see a module

- Your role may not have access.
- Ask the Developer to enable it in **Portal Access by Role**.

### I cannot see Settings

Settings is managed by the Developer and is not available to users.

### Changes are not showing on another device

1. Click the **cloud icon** to sync.
2. Refresh the page.
3. Check the internet connection.

### Fee reminders are not appearing

- The student must have a pending balance.
- The reminder must be sent from **Student Fees & Reminders**.
- The student should check the **bell icon** and the Dashboard banner.

### A file will not upload

- Check the Google Drive folder link and sharing permissions.
- Check the file size and format.
- Try a smaller file.

### The chatbot is not working

- Confirm the Chatbot is enabled by the Developer.
- Click **Connect Gemini** and paste a valid Google AI Studio key.
- Check the Gemini free-tier quota.
- Try **New Chat**.

### The theme button is missing

The Developer controls theme access by role. Ask the Developer to enable it.

### The phone stays dark

- Set the browser's dark mode to **System default** or **Off**.
- Clear the browser cache for the portal.
- Reload the page.

### The page looks outdated or Android app does not show latest changes

- On Android: force-close (swipe away) the Divine Classes app and reopen it.
- On desktop: press `Ctrl+F5` (or `Cmd+Shift+R` on Mac) to refresh without cache.
- Clear the browser cache and reopen the portal.
- Ask the Developer to confirm the production version was deployed.

---

## 21. Quick Reference Card

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
| Sync now | Header cloud icon |

---

**End of Manual**

For support, contact the institute office or the portal developer.
