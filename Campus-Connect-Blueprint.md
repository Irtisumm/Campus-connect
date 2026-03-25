# Campus Connect - Complete UI/UX Blueprint & Wireframe Specification
## City University Malaysia - Mobile App (Flutter)
### Version 2.0 - Improved Design with Additional Screens

---

## 1. PROJECT OVERVIEW

**App Name:** Campus Connect
**Platform:** Flutter (Android & iOS)
**University:** City University Malaysia
**Purpose:** A unified campus services mobile app for students and admin staff
**Data Storage:** Local storage (SharedPreferences / in-memory state via Provider)
**Auth:** Local credential-based login (Student + Admin roles)
**Font:** Inter (all weights)
**Design Language:** Material Design 3 with custom rounded, warm-toned theme

---

## 2. DESIGN SYSTEM

### 2.1 Color Palette

| Token             | Hex       | Usage                                      |
|-------------------|-----------|---------------------------------------------|
| Red (Primary)     | #C41E3A   | Primary brand, buttons, active states, nav  |
| Red Dark          | #8B1428   | Gradient end, emphasis text, dark accents   |
| Red Light         | #E8475F   | Gradient start, secondary CTA, highlights   |
| White             | #FFFFFF   | Card backgrounds, text on dark              |
| White Dark        | #F5F5F5   | Subtle backgrounds, dividers                |
| Gold              | #F8D49B   | Amber buttons, warnings, election badges    |
| Gold Dark         | #E8B96A   | Gold gradient end, warning borders          |
| Cream             | #F8E6CB   | Warm accent backgrounds                     |
| Cream Light       | #FDF3E4   | Input fill, surface background              |
| Background (App)  | #F0E8D8   | Main scaffold/page background               |
| Text Primary      | #2B3A4A   | Headings, body text, dark labels            |
| Text Secondary    | #4E6272   | Descriptions, subtext                       |
| Text Muted        | #7FA3B5   | Hints, metadata, timestamps                 |
| Danger            | #D65E5E   | Errors, overdue, destructive actions        |
| Success Indicator | #E8475F   | Matches red-light for success states        |

### 2.2 Gradients

| Name              | Colors                     | Direction          |
|-------------------|----------------------------|--------------------|
| Primary Gradient  | #C41E3A -> #E8475F         | Top-Left to Bottom-Right |
| Header Gradient   | #C41E3A -> #E8475F         | Top-Left to Bottom-Right |
| Gold Gradient     | #F8D49B -> #E8B96A         | Top-Left to Bottom-Right |

### 2.3 Typography

| Style          | Size | Weight   | Color        | Usage                        |
|----------------|------|----------|--------------|------------------------------|
| App Title      | 16px | 800      | White        | Header bar app name          |
| Subtitle       | 10px | 500      | White 80%    | Header university name       |
| Page Heading   | 18px | 800      | Text Primary | Section/page titles          |
| Card Title     | 15-17px | 800   | Text Primary | Card headings, item names    |
| Body           | 13px | 400-500  | Text Secondary | Descriptions, paragraphs   |
| Label          | 12px | 700      | Text Muted   | Form labels, info labels     |
| Section Label  | 11px | 800      | Text Muted   | Uppercase section dividers   |
| Badge Text     | 9px  | 800      | Varies       | Status badges, uppercase     |
| Meta Text      | 11px | 500      | Text Muted   | Timestamps, IDs, counts      |
| Button Text    | 14px | 700      | White        | CTA button labels            |
| Nav Label      | 10px | 500-800  | Varies       | Bottom nav labels            |

### 2.4 Corner Radii

| Element          | Radius |
|------------------|--------|
| Cards            | 16px   |
| Buttons          | 12px   |
| Hub Buttons      | 18px   |
| Inputs           | 12px   |
| Status Badges    | 999px (pill) |
| Bottom Nav Items | 12px   |
| Icon Containers  | 10-14px |
| Locker Grid      | 10px   |
| Modals/Dialogs   | 16px   |

### 2.5 Shadows

| Usage           | Color              | Blur  | Offset   |
|-----------------|---------------------|-------|----------|
| Header          | #5193B3 @ 16%       | 12px  | (0, 3)   |
| Cards           | Red @ 12%           | 8px   | (0, 2)   |
| Hub Buttons     | Red @ 10-30%        | 16px  | (0, 4)   |
| Bottom Nav      | Red @ 12%           | 20px  | (0, -4)  |
| Primary CTA     | Red @ 30%           | 14px  | (0, 4)   |
| Active Booking  | Red @ 30%           | 18px  | (0, 5)   |

### 2.6 Spacing System

| Name      | Value |
|-----------|-------|
| Page Pad  | 16px  |
| Card Pad  | 16px  |
| Gap SM    | 6-8px |
| Gap MD    | 10-12px |
| Gap LG    | 16-20px |
| Section   | 18px top, 10px bottom |

---

## 3. SHARED COMPONENTS

### 3.1 Header Bar (AppBar)
- **Height:** 56px
- **Background:** Primary Gradient (#C41E3A -> #E8475F)
- **Shadow:** Blue-tint shadow, blur 12, offset (0,3)
- **Layout:** Row with:
  - [Left] Logo icon container (white @ 20% opacity bg, rounded 10px, school icon 20px white)
  - [Left+10px] Column: "Campus Connect" (16px, w800, white) + "City University Malaysia" (10px, w500, white 80%)
  - [Right] Role toggle pill button:
    - Student mode: white @ 20% bg, person icon + "Student" text, white
    - Admin mode: Gold bg, shield icon + "Admin" text, dark gold (#7A5B00)
  - [Right+8px] Notification bell with orange dot indicator (8px circle)

### 3.2 Bottom Navigation Bar
- **Background:** White, shadow from above
- **4 tabs:** Lost & Found | Issues | Events | Lockers
- **Icons:** search_rounded | warning_amber_rounded | event_rounded | lock_rounded
- **Active state:** Red bg @ 10%, red icon 24px, red label w800, red gradient indicator bar (18x3px pill)
- **Inactive state:** Transparent bg, muted icon 22px, muted label w500
- **Animation:** Scale 0.95 -> 1.0 on active

### 3.3 Status Badge (Pill)
- Rounded pill (999px radius)
- Padding: 9px horizontal, 3px vertical
- Text: 9px, weight 800, uppercase, letter-spacing 0.5
- Color mapping:
  - Active / In Progress / New / Published / Available / Confirmed: Red Dark text, Red @ 12% bg
  - Triaged / In Inventory / Pending Pickup / Pending: Gold Dark (#8A5F0A) text, Gold @ 16% bg
  - Closed / Blocked / Released / Completed / Draft: Grey (#4E6272) text, Grey @ 9% bg
  - Overdue: Danger Red (#B03030) text, Danger @ 9% bg

### 3.4 Card Row (List Item)
- White card bg, rounded 16px, red-tint border @ 10%
- Padding: 14px horizontal, 13px vertical
- Left accent: 3px wide, 44px tall, primary gradient, rounded 3px
- Content: Title (14px, w700) + Subtitle (11px, muted) + optional Extra line (11px, muted)
- Right: Status badge + optional trailing widget
- Far right: Chevron icon (18px, muted)
- Bottom margin: 10px between cards

### 3.5 Hub Button
- Rounded 18px, padding 18px horizontal, 16px vertical
- **Primary variant:** Red gradient bg, white text, red shadow @ 30%
- **Amber variant:** Gold gradient bg, white text, gold shadow @ 35%
- **Default variant:** White bg, red-tint border @ 12%, red shadow @ 10%
- Icon container: 46x46px, rounded 14px
- Title: 15px, w700 | Subtitle: 12px
- Default has chevron arrow, colored variants don't

### 3.6 Notice Box
- Left border accent: 3px, colored
- Padding: 13px all
- Background: accent color @ 7%
- Icon (16px) + message text (12px, height 1.55)
- Bottom margin: 14px

### 3.7 Stat Card
- Padding: 14px vertical, 10px horizontal
- Background: white or tinted
- Border: red @ 12%, rounded 12px
- Shadow: red @ 8%, blur 8px
- Value: 26px, w800, colored
- Label: 9px, w800, muted, uppercase, letter-spacing 0.5

### 3.8 Section Label
- Text: 11px, w800, muted, uppercase, letter-spacing 1.0
- Right side: Horizontal divider line (red @ 18%)
- Spacing: 18px top, 10px bottom

### 3.9 Info Row
- Two-column layout: label left, value right
- Label: 12px, w600, muted
- Value: 13px, w600, text primary, right-aligned
- Vertical padding: 8px

### 3.10 Gradient Button (Primary CTA)
- Full width, padding 14px vertical, 20px horizontal
- Background: Primary gradient
- Shadow: red @ 30%, blur 14px, offset (0,4)
- Text: 14px, w700, white, centered

### 3.11 Outline Button (Secondary CTA)
- Full width, padding 14px vertical
- White bg, border 1.5px colored @ 30%, rounded 12px
- Text: 14px, w700, colored, centered

### 3.12 Admin Bar
- Gold @ 22% bg, gold dark border @ 40%, rounded 10px
- Shield icon (13px) + "ADMIN MODE" text (11px, w800, dark gold, letter-spacing 0.8)
- Margin bottom: 10px

### 3.13 Empty State
- Centered, padding 40px
- Large icon: 56px, muted @ 40%
- Title: 16px, w700, text secondary
- Subtitle: 13px, muted, centered, height 1.6

### 3.14 Countdown Badge
- Pill shape (999px radius), padding 9px horizontal, 3px vertical
- Text: 11px, w700
- Colors: Overdue (red), Warning <=7 days (amber), Normal (red-tinted)

### 3.15 Timeline Item
- Left: Dot (10px circle, red fill, cream border 2px) + vertical line (2px, red @ 20%)
- Right: Date (11px, w700, red) + description text (12px, text secondary, height 1.5)
- Left padding: 16px, gap between dot and text: 12px

---

## 4. SCREEN SPECIFICATIONS

### NEW SCREEN: S-00 Splash Screen
**Route:** Initial (auto-redirect after 2.5s)
**Purpose:** App branding on launch

**Layout:**
- Full screen, Primary Gradient background (#C41E3A -> #E8475F)
- Center-aligned content:
  - University logo/school icon in white circle container (80x80px, white @ 20% bg, rounded 20px)
  - Icon: school_rounded, 48px, white
  - 20px gap
  - App name: "Campus Connect" (28px, w800, white, letter-spacing -0.5)
  - 6px gap
  - University name: "City University Malaysia" (14px, w500, white @ 80%)
  - 40px gap
  - Circular loading indicator (white, strokeWidth 2.5)
- Bottom of screen (40px from bottom):
  - "Powered by Campus Services" (11px, w500, white @ 50%)
- **Animation:** Fade-in logo (300ms) -> slide-up text (500ms) -> fade-in loader (800ms)
- **Auto-navigate** to Login Screen after 2.5 seconds

---

### NEW SCREEN: S-01 Login Screen (Full Page - Student)
**Route:** /login
**Purpose:** Student authentication before accessing app

**Layout:**
- Background: App background (#F0E8D8)
- Top section (no AppBar, use SafeArea):
  - 60px top padding
  - Center: Icon container with primary gradient bg, circle shape
    - person_rounded icon, 48px, white
  - 24px gap
  - "Welcome Back" (24px, w800, text primary)
  - 8px gap
  - "Sign in to your student account" (13px, text muted)
  - 40px gap

- Form section (white card, rounded 16px, padding 24px, margin 16px horizontal):
  - Label: "Student ID" (12px, w700, muted)
  - 8px gap
  - TextField: hint "e.g. S001", prefix icon badge_rounded
  - 16px gap
  - Label: "Password" (12px, w700, muted)
  - 8px gap
  - TextField: hint "--------", obscured, prefix icon lock_rounded, suffix icon visibility toggle
  - 8px gap
  - Row right-aligned: "Forgot Password?" (12px, w600, red)
  - 24px gap
  - Gradient Button: "Sign In"
  - 16px gap
  - Center: "Demo credentials: S001 / pass123" (11px, muted)

- Bottom section:
  - 24px gap
  - Center: "Are you admin?" tappable text (13px, w600, red) -> navigates to admin login variant
  - 16px gap
  - Center: "v2.0 | City University Malaysia" (10px, muted)

**Error State:**
- Red danger container above form fields
- Red bg @ 10%, red border @ 30%, rounded 10px
- Error icon + error message text

**Loading State:**
- Button shows circular progress indicator (white, 20px, strokeWidth 2)
- Input fields disabled

**Demo Credentials:**
- Students: S001/pass123, S002/pass123, S003/pass123
- Admin: ADMIN001/admin123, ADMIN002/admin123

---

### NEW SCREEN: S-01b Login Screen (Admin Variant)
**Route:** /login?admin=true (or dialog overlay)
**Purpose:** Admin authentication

**Same layout as S-01 but:**
- Icon: shield_rounded instead of person_rounded
- Title: "Admin Portal" instead of "Welcome Back"
- Subtitle: "Enter your admin credentials"
- Student ID label changes to "Admin ID"
- Hint: "e.g. ADMIN001"
- Bottom text: "Switch to Student Login" instead of "Are you admin?"

---

### S-02 Lost & Found Hub (Student)
**Route:** /lost-found
**Tab:** 1st tab (search icon)

**Layout (scrollable):**
1. Notice Box: lock icon, "All item details are kept private. Only university management can view full details."
2. Section Label: "REPORT AN ITEM"
3. Hub Button (Primary/Red): search icon, "Report Lost Item", "I've lost something on campus" -> /lost-found/report-lost
4. Hub Button (Amber/Gold): add_box icon, "Report Found Item", "I found something on campus" -> /lost-found/report-found
5. Section Label: "MY REPORTS"
6. Hub Button (Default): description icon, "My Lost Reports", "{count} reports submitted" -> /lost-found/my-lost
7. Hub Button (Default): upload_file icon, "My Found Reports", "{count} reports submitted" -> /lost-found/my-found

**Animations:** Each hub button fades in + slides up with 50ms stagger delay

---

### S-03 Report Lost Item
**Route:** /lost-found/report-lost
**AppBar:** Gradient, "Report Lost Item", back arrow

**Layout (scrollable form):**
1. Notice Box: "Max 5 active reports. Provide a detailed description to improve match accuracy."
2. Dropdown: "Category" -> Phone, Wallet, ID Card, Keys, Bag, Laptop, Books, Other
3. Text Field: "Item Title", hint "e.g. Blue Samsung Galaxy S23"
4. Text Area: "Description", hint "Color, brand, markings..."
5. Dropdown: "Where Lost" -> Block A, Block B, Block C, Library, Cafeteria, Sports Complex, Main Entrance, Other
6. Photo Upload Box: Dashed border container, camera icon, "Add Photos (Optional)", "Max 5 photos, 5MB each"
7. Gradient Button: "Submit Report"
8. Outline Button: "Cancel"

**Success State (replaces form):**
- Center-aligned success view
- Check circle icon (56px, green/red)
- "Report Submitted!" (20px, w800)
- Description text
- Gradient Button: "Back to Hub"
- Outline Button: "View My Reports"

---

### S-04 Report Found Item
**Route:** /lost-found/report-found
**AppBar:** Gradient, "Report Found Item", back arrow

**Layout (same structure as S-03 but):**
1. Notice Box (red-tinted): "Please hand the item to Lost & Found Office (Block A, Level 1) after submitting."
2. Dropdown: "Category"
3. Text Area: "Description", hint "Describe what you found"
4. Dropdown: "Where Found"
5. Photo Upload Box
6. Gradient Button: "Submit Report"
7. Outline Button: "Cancel"

---

### S-05 My Lost Reports
**Route:** /lost-found/my-lost
**AppBar:** Gradient, "My Lost Reports", back arrow, "Report" text button (right)

**Layout:**
- List of Card Row items:
  - Title: item title
  - Subtitle: "Category - Where Lost"
  - Extra: relative time ("Today", "2 days ago")
  - Status badge
  - Chevron -> navigate to /lost-found/lost/{id}
- Empty State if no reports: search_off icon, "No Lost Reports"
- Animation: Fade-in with 60ms stagger

---

### S-06 My Found Reports
**Route:** /lost-found/my-found
**AppBar:** Gradient, "My Found Reports", back arrow

**Layout:** Same structure as S-05 but for found items

---

### S-07 Lost Item Detail (Student)
**Route:** /lost-found/lost/{id}
**AppBar:** Gradient, shows report ID (e.g. "LR-001"), back arrow

**Layout (scrollable):**
1. Notice Box (if match exists): link icon, match status message
2. Card containing:
   - Row: Title (17px, w800) + Status Badge
   - Divider
   - Info Row: Category
   - Info Row: Where Lost
   - Info Row: When Lost (formatted date)
   - Divider
   - Label: "Description"
   - Description text (13px, height 1.65)
3. If status is "Active": Outline Button (danger color): "Close Report"

---

### S-08 Found Item Detail (Student)
**Route:** /lost-found/found/{id}
**AppBar:** Gradient, shows report ID

**Layout:**
- Single card with:
  - Row: Description title + Status Badge
  - Divider
  - Info Rows: Category, Where Found, When Found

---

### S-09 Notifications
**Route:** /lost-found/notifications
**AppBar:** Gradient, "Notifications", back arrow

**Layout (list):**
- Each notification:
  - Container: rounded 14px
  - Unread: red-tinted bg @ 5%, stronger border
  - Read: white bg, subtle border
  - Leading: Circle avatar (personal = red-tint + person icon, generic = gold-tint + campaign icon)
  - Title: notification text (13px, bold if unread)
  - Subtitle: time string (11px, muted)
  - Trailing (unread only): red dot (8px circle)
- Animation: Fade-in + slide-X with 55ms stagger

---

### S-10 Admin Lost & Found Dashboard
**Route:** /lost-found (when admin mode active)

**Layout (scrollable):**
1. Admin Bar
2. Stats Row (3 columns):
   - Active Lost (count, red)
   - In Inventory (count, red dark, red-tint bg)
   - Pending Matches (count, danger red, danger-tint bg)
3. Section Label: "QUICK ACTIONS"
4. Hub Button: list icon, "View Lost Reports", "{count} total"
5. Hub Button (Amber): inventory icon, "Found / Inventory", "{count} items"
6. Hub Button: compare_arrows icon, "Review Matches", "{count} pending"

---

### S-11 Admin Lost Reports List
**Route:** /admin/lost-found/lost-list
**AppBar:** Gradient, "All Lost Reports", back arrow

**Layout:**
- Admin Bar
- List of Card Rows:
  - Title: item title
  - Subtitle: "StudentID - Category"
  - Extra: formatted date
  - Status badge
  - Trailing (if AI score): Gradient pill badge "AI {score}%"

---

### S-12 Admin Found / Inventory List
**Route:** /admin/lost-found/found-list
**AppBar:** Gradient, "Found / Inventory", back arrow

**Layout:**
- Admin Bar
- List of Card Rows: description, category + location, date, status

---

### S-13 Admin Lost Item Detail
**Route:** /admin/lost-found/lost/{id}
**AppBar:** Gradient, report ID, back arrow

**Layout (scrollable):**
1. Admin Bar
2. Card: Title + status, divider, Student ID, Category, Where Lost, Submitted date
3. AI Match Score section (if exists):
   - Gradient-tinted container
   - Brain icon + "AI Match Score" heading
   - Large score text + "/100" suffix
   - If linked found ID shown
4. Admin Action Buttons: "Confirm Match" gradient, "Reject Match" outline

---

### S-14 Admin Match List
**Route:** /admin/lost-found/match-list
**AppBar:** Gradient, "AI Matches", back arrow

**Layout:**
- Admin Bar
- List: match cards showing Lost ID <-> Found ID, score, status, notes

---

### S-15 Admin Match Detail
**Route:** /admin/lost-found/match/{id}

**Layout:**
- Admin Bar
- Match card with: Lost ID, Found ID, Score bar, Status badge, Notes
- Actions: "Confirm Match" + "Reject Match" buttons

---

### S-16 Issues Hub (Student)
**Route:** /issues
**Tab:** 2nd tab (warning icon)

**Layout (scrollable):**
1. Notice Box: "Use this to report facility, safety, IT, or other campus problems. Max 5 reports per day."
2. Hub Button (Primary): warning icon, "Report an Issue", "Submit a new campus issue"
3. Hub Button (Default): description icon, "My Issues", "{count} submitted"
4. Section Label: "MY STATS"
5. Stats Row (3 columns): In Progress | Resolved | New

---

### S-17 Report Issue
**Route:** /issues/report
**AppBar:** Gradient, "Report an Issue", back arrow

**Layout (scrollable form):**
1. Notice Box (danger): "Please report genuine issues only. Abuse may result in restrictions."
2. Dropdown: "Category" -> Facilities, Safety, Cleanliness, IT, Other
3. Text Field: "Issue Title", hint "Brief title"
4. Text Area: "Description", hint "Describe the problem in detail..."
5. Dropdown: "Location" -> Block A, B, C, Library, Cafeteria, Sports Complex, Main Entrance, Other
6. Gradient Button: "Submit Issue"
7. Outline Button: "Cancel"

**Success State:** Check icon + "Issue Reported!" + Gradient "Back to Hub" + Outline "View My Issues"

---

### S-18 My Issues
**Route:** /issues/my-issues
**AppBar:** Gradient, "My Issues", back arrow
**FAB:** Red, plus icon + "Report"

**Layout:**
- List of Card Rows: title, "Category - Location", "Updated {time}", status badge
- Empty State if none

---

### S-19 Issue Detail (Student)
**Route:** /issues/detail/{id}
**AppBar:** Gradient, issue ID, back arrow

**Layout (scrollable):**
1. Card: Title + status, divider, Category, Location, Submitted, Last Updated, divider, Description
2. Feedback box (if Resolved): "Is this issue resolved for you?" + "Yes, close it" (gradient) + "No, still not fixed" (danger gradient)
3. Status Timeline: sequence of Timeline Items showing status changes

---

### S-20 Admin Issues Dashboard
**Route:** /issues (admin mode)

**Layout (scrollable):**
1. Admin Bar
2. Stats Row: New | In Progress/Assigned | Resolved
3. Section Label: "CATEGORY BREAKDOWN"
4. Card with progress bars per category (Facilities, Safety, IT, Cleanliness, Other) with count + percentage bar
5. Gradient Button: "View All Issues"

---

### S-21 Admin Issues List
**Route:** /admin/issues/list
**AppBar:** Gradient, "All Issues", back arrow

**Layout:**
- Admin Bar
- List of Card Rows: title, "StudentID - Category - Location", date, status

---

### S-22 Admin Issue Detail
**Route:** /admin/issues/detail/{id}
**AppBar:** Gradient, issue ID, back arrow

**Layout (scrollable):**
1. Admin Bar
2. Card: Title + status, Student ID, Category, Location, Created date
3. Section Label: "UPDATE STATUS"
4. Card with:
   - Dropdown: "Change Status" -> New, Triaged, Assigned, In Progress, Resolved, Closed - Verified
   - Dropdown: "Assigned Department" -> Facilities Management, IT Services, Security Office, Housekeeping, General Admin
   - Text Area: "Admin Note"
5. Gradient Button: "Update Status"
6. Status Timeline (if history exists)

---

### S-23 Events Hub (Student)
**Route:** /events
**Tab:** 3rd tab (event icon)

**Layout:**
- Top Row: "Upcoming Events" (18px, w800) + "Create" pill button (gradient) + "Elections" pill button (gradient)
- Scrollable list of Event Cards:
  - Top section: 80px tall, category-tinted bg, centered event icon, category pill badge (top-right)
  - Bottom section (14px padding): Title (15px, w800), Meta row: calendar icon + date, clock icon + time, location icon + venue
  - Category color mapping:
    - Academic: Red tint
    - Sport: Red-light tint
    - Club: Gold tint
    - General: Red tint
- Animation: Fade-in + slide-Y with 70ms stagger

---

### S-24 Event Detail
**Route:** /events/detail/{id}
**AppBar:** Gradient, event title, back arrow

**Layout (scrollable):**
1. Category banner: 130px tall, tinted bg, large event icon (64px)
2. Card: Date, Time, Location, Organizer, Category (Info Rows), divider, Description text
3. Gradient Button: "Add to Calendar"
4. Outline Button: "Remind Me"

---

### S-25 Create Event (Student)
**Route:** /events/create
**AppBar:** Gradient, "Create Event", back arrow

**Layout (scrollable form):**
1. Notice Box: "Events you create will be sent to admin for approval before publishing."
2. Text Field: "Event Title"
3. Text Area: "Description"
4. Dropdown: "Category" -> Academic, Sport, Club, General
5. Row: Date field + Time field
6. Text Field: "Location"
7. Text Field: "Organizer"
8. Gradient Button: "Submit for Approval"
9. Outline Button: "Cancel"

**Success State:** "Event Submitted for Approval!" message

---

### S-26 Elections Info
**Route:** /events/elections
**AppBar:** Gradient, "Student Elections 2026", back arrow

**Layout (scrollable):**
1. Notice Box (gold): "This is an information-only page. No online voting is conducted here."
2. Card containing:
   - Section Label: "ABOUT" + description paragraph
   - Section Label: "TIMELINE" + timeline entries (date + event)
   - Section Label: "OPEN POSITIONS" + list with person icons (President, VP, Secretary General, Treasurer)
3. Section Label: "CANDIDATES"
4. Candidate Cards (for each):
   - Row: Avatar circle (gradient bg, first letter initial, 48px) + Content
   - Name (15px, w800)
   - Programme (11px, muted)
   - "Running for: {position}" (12px, w700, red)
   - Manifesto text (12px, text secondary, height 1.55)

---

### S-27 Admin Events Management
**Route:** /events (admin mode) or /admin/events/list
**AppBar:** Gradient, "Events Management", back arrow
**FAB:** Red, plus icon + "Create"

**Layout:**
- Admin Bar
- Tab switcher: "Pending ({count})" | "Published ({count})" with underline indicator
- **Pending tab:** Cards with title, category + date, Reject outline button + Approve gradient button side by side
- **Published tab:** Card Row list with title, category + date, status badge

---

### S-28 Admin Event Editor
**Route:** /admin/events/editor or /admin/events/editor/{id}
**AppBar:** Gradient, "Create Event" or "Edit Event", back arrow

**Layout (scrollable form):**
- Admin Bar
- Text Field: Title
- Text Area: Description (4 lines)
- Dropdown: Category
- Row: Date + Time fields
- Text Field: Location
- Text Field: Organizer
- Dropdown: Status -> Draft, Under Review, Published
- Gradient Button: "Publish Event" or "Save Changes"
- Outline Button: "Cancel"

---

### S-29 Admin Elections Management
**Route:** /admin/events/elections

**Layout:**
- Admin Bar
- Elections management controls

---

### S-30 Locker Hub (Student)
**Route:** /lockers
**Tab:** 4th tab (lock icon)

**Layout (scrollable):**
1. **If booking exists - Active Booking Card:**
   - Gradient container (red gradient, rounded 18px, strong shadow)
   - Lock icon (24px, white) + Locker ID (18px, w800, white)
   - Location (13px, white @ 85%)
   - Stats row: Start date, End date, Countdown badge
   - Below: Outline Button "Manage My Locker"
2. **If no booking:**
   - Notice Box: "You don't have an active locker. You can browse and book one below."
3. Section Label: "SERVICES"
4. Hub Button (Primary if no booking): grid icon, "Browse Available Lockers", "{count} available now"
5. Hub Button: manage_accounts icon, "My Locker", booking ID or "No active booking"

---

### S-31 Browse Lockers
**Route:** /lockers/browse
**AppBar:** Gradient, "Available Lockers", back arrow

**Layout (scrollable):**
1. Notice Box: "Locker rentals are for 6 months. Key collection at Facilities Office, Block A Level 1."
2. For each block section (Block A Level 1, Block B Level 2, Block C Level 1):
   - Section Label: block name
   - Grid (4 columns, aspect ratio 1.1):
     - Each locker cell: rounded 10px, tinted bg + border
     - Lock icon (20px) + locker number (10px, w800)
     - Color by status: Available (red-tint), Active/Taken (red-light-tint), Overdue (danger-tint), Blocked (grey-tint)
     - Only "Available" lockers are tappable
   - Legend row below grid: colored dots with labels (Available, Taken, Overdue)

---

### S-32 Locker Booking Confirmation
**Route:** /lockers/detail/{id}
**AppBar:** Gradient, "Book Locker", back arrow

**Layout (scrollable):**
1. Card:
   - Row: Gradient icon container (lock, 28px) + Locker ID (18px, w800) + Location + Status badge
   - Divider
   - Info Rows: Duration ("Semester 6 months"), Start Date, End Date, Fee
2. Notice Box (gold): policy agreement text
3. Gradient Button: "Confirm Booking"
4. Outline Button: "Cancel"

---

### S-33 My Locker
**Route:** /lockers/my-locker
**AppBar:** Gradient, "My Locker", back arrow

**If no booking:**
- Empty State: lock_open icon, "No Active Booking", subtitle
- Gradient Button: "Browse Lockers"

**If booking exists:**
1. Active Locker Card (gradient, rounded 20px, strong shadow):
   - Lock icon + Locker ID (22px, w800, white)
   - Location
   - Stats row: Start, End, Status, Countdown badge
2. Section Label: "QUICK ACTIONS"
3. Hub Button: swap icon, "Request Extension"
4. Hub Button: report icon, "Report Locker Issue"
5. Hub Button: cancel icon (danger colored), "Release Locker" (shows confirmation dialog)

---

### S-34 Admin Locker Dashboard
**Route:** /lockers (admin mode)

**Layout (scrollable):**
1. Admin Bar
2. Stats Row (4 columns): Total | Available | Active | Overdue
3. Section Label: "ACTIONS"
4. Hub Button: grid icon, "Locker Grid", "View all locker statuses"
5. Hub Button (Amber): person_search icon, "Student Lookup", "Find by student ID"
6. Notice Box (danger, if overdue > 0): "{count} locker(s) are overdue. Action required."

---

### S-35 Admin Lockers List
**Route:** /admin/lockers/list
**AppBar:** Gradient, "All Lockers", back arrow

**Layout:**
- Admin Bar
- List of Card Rows: Locker ID, location, status, student ID (if assigned), countdown badge

---

### S-36 Admin Locker Detail
**Route:** /admin/lockers/detail/{id}
**AppBar:** Gradient, locker ID, back arrow

**Layout (scrollable):**
1. Admin Bar
2. Card: Locker ID + status, Location, Student ID, End Date, Countdown badge
3. Section Label: "ADMIN ACTIONS"
4. Dropdown: "Update Status" -> Available, Active, Pending Pickup, Overdue, Blocked
5. Gradient Button: "Save Changes"
6. If Overdue: Outline Button (danger): "Send Overdue Reminder"
7. Section Label: "HISTORY" (if exists)
8. History entries: action name (13px, w700), timestamp + staff ID (11px, muted), reason (12px)

---

## 5. NAVIGATION ARCHITECTURE

```
App Launch
  |
  v
[S-00] Splash Screen (2.5s)
  |
  v
[S-01] Login Screen
  |
  +--> Student Login -> App Shell (Bottom Nav)
  +--> Admin Login -> App Shell (Admin Mode)
  |
  v
App Shell (Bottom Navigation - 4 tabs)
  |
  +-- Tab 1: Lost & Found
  |     +-- [S-02] Hub (Student) / [S-10] Dashboard (Admin)
  |     +-- [S-03] Report Lost -> Success
  |     +-- [S-04] Report Found -> Success
  |     +-- [S-05] My Lost Reports -> [S-07] Lost Detail
  |     +-- [S-06] My Found Reports -> [S-08] Found Detail
  |     +-- [S-09] Notifications
  |     +-- [S-11] Admin Lost List -> [S-13] Admin Lost Detail
  |     +-- [S-12] Admin Found List
  |     +-- [S-14] Admin Match List -> [S-15] Match Detail
  |
  +-- Tab 2: Issues
  |     +-- [S-16] Hub (Student) / [S-20] Dashboard (Admin)
  |     +-- [S-17] Report Issue -> Success
  |     +-- [S-18] My Issues -> [S-19] Issue Detail
  |     +-- [S-21] Admin Issues List -> [S-22] Admin Issue Detail
  |
  +-- Tab 3: Events
  |     +-- [S-23] Events Hub (Student) / [S-27] Admin Events List
  |     +-- [S-24] Event Detail
  |     +-- [S-25] Create Event -> Success
  |     +-- [S-26] Elections Info
  |     +-- [S-28] Admin Event Editor
  |     +-- [S-29] Admin Elections Mgmt
  |
  +-- Tab 4: Lockers
        +-- [S-30] Locker Hub (Student) / [S-34] Admin Dashboard
        +-- [S-31] Browse Lockers
        +-- [S-32] Locker Booking Confirmation
        +-- [S-33] My Locker
        +-- [S-35] Admin Lockers List -> [S-36] Admin Locker Detail
```

---

## 6. USER FLOWS

### 6.1 Student Login Flow
1. App launches -> Splash Screen (2.5s animation)
2. Navigate to Login Screen
3. Enter Student ID + Password
4. On success -> Navigate to App Shell (Lost & Found tab)
5. On failure -> Show error message, retry

### 6.2 Admin Login Flow
1. From Login Screen -> Tap "Are you admin?"
2. Enter Admin ID + Password
3. On success -> Navigate to App Shell in Admin Mode
4. Admin bar visible on all hub screens
5. Tap role toggle in header to switch back to Student mode

### 6.3 Report Lost Item Flow
1. Lost & Found Hub -> Tap "Report Lost Item"
2. Fill form: Category, Title, Description, Location, Photos
3. Tap "Submit Report"
4. Success screen -> "Back to Hub" or "View My Reports"

### 6.4 Issue Lifecycle (Student)
1. Issues Hub -> "Report an Issue" -> Fill form -> Submit
2. Check "My Issues" -> See status (New)
3. Admin updates status -> Student sees changes in timeline
4. When Resolved -> Student confirms or reopens

### 6.5 Event Creation Flow
1. Events Hub -> Tap "Create" button
2. Fill event form -> Submit for Approval
3. Admin sees in Pending tab -> Approve or Reject
4. Approved events appear in Published list for all students

### 6.6 Locker Booking Flow
1. Lockers Hub -> "Browse Available Lockers"
2. Grid view -> Tap available locker
3. Booking details screen -> "Confirm Booking"
4. Locker Hub now shows active booking card
5. "My Locker" for management (extend, report issue, release)

---

## 7. STATE MANAGEMENT

**Provider Pattern:**
- `AppState` - Authentication state (isAuthenticated, isAdmin, userId)
- `DataService` - All CRUD operations for Lost/Found, Issues, Events, Lockers
- `PhotoUploadService` - Photo upload state management

**Data Persistence:** In-memory via Provider ChangeNotifier (resets on app restart). Future: SharedPreferences or SQLite for local persistence.

---

## 8. ANIMATIONS

| Element           | Type              | Duration | Delay Pattern    |
|-------------------|-------------------|----------|------------------|
| Hub Buttons       | fadeIn + slideY    | default  | 50ms stagger     |
| Card Row items    | fadeIn + slideY    | default  | 55-60ms stagger  |
| Notifications     | fadeIn + slideX    | default  | 55ms stagger     |
| Event Cards       | fadeIn + slideY    | default  | 70ms stagger     |
| Stats Rows        | fadeIn             | default  | 50ms             |
| Nav Tab Active    | scaleXY 0.95->1.0 | 220ms    | -                |
| Nav Indicator     | animated container | 220ms    | -                |
| Splash Elements   | fadeIn + slideY    | 300-800ms| Sequential       |

---

## 9. MOCK DATA SUMMARY

### Users
| ID       | Role    | Password  | Name          |
|----------|---------|-----------|---------------|
| S001     | Student | pass123   | Ahmad Rizwan  |
| S002     | Student | pass123   | Fatima Hassan |
| S003     | Student | pass123   | Mohammad Ali  |
| ADMIN001 | Admin   | admin123  | Admin Panel   |
| ADMIN002 | Admin   | admin123  | Manager Account |

### Lost Reports: 4 student reports (LR-001 to LR-004)
### Found Reports: 3 reports (FR-001 to FR-003)
### Admin Lost Reports: 5 total (LR-001 to LR-005) with AI scores
### Matches: 2 AI matches (M-001, M-002)
### Issues: 4 student, 5 admin-visible (ISS-001 to ISS-005)
### Events: 5 events (EVT-001 to EVT-005)
### Candidates: 4 election candidates
### Lockers: 12 lockers across 3 blocks
### Notifications: 4 sample notifications

---

## 10. IMPROVEMENTS FROM v1

### New Screens Added:
1. **Splash Screen** - Branded loading screen with animation
2. **Full Login Screen** - Dedicated login page (not just dialog) with proper UX

### Design Improvements:
1. **Consistent gradient usage** across all primary CTAs and headers
2. **Staggered animations** on all list views for polished feel
3. **Empty states** on all list screens with icons and helpful text
4. **Admin mode** clearly differentiated with gold admin bar
5. **AI Match scoring** visual in admin views with gradient badges
6. **Category color coding** for events (Academic=red, Sport=pink, Club=gold)
7. **Locker grid visualization** with color-coded availability
8. **Status timeline** with dot-line pattern for issue history
9. **Countdown badges** for locker expiry with color urgency
10. **Notice boxes** with contextual coloring (info=red, warning=gold, danger=red-dark)

### Data Flow Improvements:
1. **Event approval workflow** - Students create -> Admin approves -> Published
2. **Issue feedback loop** - Admin resolves -> Student confirms or reopens
3. **Real-time state updates** via Provider pattern across all screens
4. **Notification system** - Auto-generated for key actions

---

*This blueprint is designed to be used with Antigravity AI or any design tool AI to recreate the complete Campus Connect app UI in Figma or similar design software.*
