# Campus Connect – Feature Specification & Bug Fix Report

**Project:** Campus Connect (Flutter App)  
**University:** City University Malaysia  
**Date:** March 2026  

---

## 1. Locker Management

### 1.1 Student Side

- Students can view the list of available lockers.
- A student can select **only one locker** (maximum one locker per student; selecting more than one is not allowed).
- After selecting, the student can book the locker for a duration of **2 months to 1 year**.
- Cost is **RM10 per month**.
- Upon booking, the student pays:
  - **RM100 deposit** (refundable)
  - **RM10 for the first month's rent**
- After payment, the student receives locker details:
  - If the locker uses a **password/digital lock**: the password is shown in the app.
  - If the locker uses a **key system**: the student visits the inventory/locker manager and collects the key by presenting the payment receipt.
- The locker status is updated in the app after booking.
- When the student completes the full booking period, the **RM100 deposit is refunded**.
- If the student fails to pay rent for one month, or the overdue period exceeds one month, the agreement is automatically cancelled and the deposit is forfeited.
- The student must complete the full chosen booking duration to be eligible for a deposit refund.

### 1.2 Admin Side

- Admin can view all lockers with details: who is renting which locker, how many lockers are available.
- Admin can send notices or reminders to any locker tenant by writing a custom message.
- Admin can perform the following actions on any locker:
  - **Terminate** a locker agreement
  - **Block** a locker
  - **Release** a locker
- Admin holds the physical key for key-based lockers.

### 1.3 Bug Fix Required

- Actions from the admin locker section, such as status changes and sending notices, are currently not working.
- All locker admin actions must be fully functional and reflect changes in real time.

---

## 2. Event Management

### 2.1 Bug Fix Required

From the admin panel, the following actions are not working and must be fixed:

- Marking an event as completed
- Removing or deleting an event
- Sending a notice to the event host

Students must also receive updates in the app reflecting these admin changes.

---

## 3. Found Report (Lost & Found – Found Item Submission)

### 3.1 Student Side

- A student who finds an item can submit a found report in the app by:
  - Taking a photo of the item
  - Writing item details
- The student then physically hands over the item to the inventory manager.
- After handover, the admin generates a **one-time QR code** from the admin site.
- The student scans this QR code as proof of handover, confirming the student actually handed over the item.
- The student sees a **Done** confirmation after scanning.
- In the **My Found Reports** section, the student can track the progress:
  - Whether the item has been handed over
  - Whether someone is claiming the item

### 3.2 QR Code – Handover Proof

- Admin generates a one-time QR code from the admin panel.
- The QR code is accessible only within the admin account for security.
- Once the student scans the QR code, it becomes invalid for reuse.
- Scanning the QR code serves as the official proof of handover.

---

## 4. Student Account Registration & Approval

- Students can register an account using:
  - Student ID
  - Chosen password
  - Personal details
- After registration, the account enters a pending state awaiting admin approval.
- Admin reviews the submitted information and approves or rejects the account.
- Once approved, the student can log in using their Student ID and chosen password.

---

## 5. Issue Management

### 5.1 Bug Fix Required

- When admin updates the status of an issue, such as **Resolved** or **In Progress**, the change is not being saved or reflected in the app and demo data continues to appear.
- Status changes must be saved to the database and dynamically displayed in the app.
- Delete actions from the admin panel must function correctly.
- Progress updates must be visible to the student in real time.

---

## 6. Lost & Found – Admin Side

### 6.1 Bug Fix Required

- When admin tries to change the status of a found item, such as marking it as **Done** or moving it to **Archive**, the change does not apply.
- Status changes must be saved and reflected immediately in the app.

### 6.2 New Feature: Receive Button

- Add a **Receive** button on the admin side in the found item section.
- When admin clicks **Receive**, a one-time QR code is generated.
- The student scans this QR code as proof of handover.
- The QR code is accessible only within the admin account for security.
- Once scanned, the QR code becomes invalid.

### 6.3 New Feature: Handover Button

- Add a **Handover** button on the admin side for when a student claims a found item.
- When admin clicks **Handover**, a QR code is generated that links to a Google Form.
- The claiming student must complete two steps:
  1. Register details in the physical register book.
  2. Scan the QR code and fill in the Google Form with their name and student details.
- This creates both an offline and online official record of item collection.

---

## 7. Bug Fix Table

| Module | Issue | Expected Fix |
|---|---|---|
| Locker Management | Admin actions not working | All actions such as terminate, block, release, and notices must function |
| Event Management | Admin cannot complete, delete, or send notice | All event admin actions must work and update the student side |
| Issue Management | Status changes not saving, demo data persists | Dynamic status updates must be saved and shown in the app |
| Lost & Found | Found item status change not applying | Fix status update and archive functionality |

---

*Document prepared for Campus Connect – City University Malaysia*
