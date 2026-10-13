# Campus Career Hub ? Student Training & Placement Management Portal

> **A modern, responsive, and feature-rich Flutter Web application engineered for higher education placement cells, training directors, and graduating students.**

![Flutter Web](https://img.shields.io/badge/Flutter-3.47.6-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.13.5-0175C2?logo=dart)
![Platform](https://img.shields.io/badge/Platform-Web%20%7C%20Responsive-blue)
![Vercel](https://img.shields.io/badge/Deployed-Vercel-black?logo=vercel)
![License](https://img.shields.io/badge/License-MIT-green)

### 🌐 **Live Website:** [https://campus-career-hub-omega.vercel.app](https://campus-career-hub-omega.vercel.app)
*(Alternative Domain: [https://web-black-pi-22.vercel.app](https://web-black-pi-22.vercel.app))*

---

## ?? Project Overview

**Campus Career Hub** transforms college campus recruitment and career readiness into an intuitive, responsive, and elegant digital experience. Built strictly adhering to **Material 3** guidelines, it supports desktop, tablet, and mobile browsers with seamless dark mode transitions, comprehensive corporate drive management (TCS, Infosys, Deloitte, Accenture, Wipro, Microsoft, Amazon), live interview preparation modules, and an interactive 5-stage application tracker.

---

## ?? Objectives

1. **Centralize Campus Placements:** Streamline company drive circulars, eligibility cutoffs, package details, and deadlines into a single authoritative dashboard.
2. **Accelerate Career Readiness:** Provide quantifiable Career Readiness scores derived from CGPA, skill portfolios, industry certifications, and completed training workshops.
3. **Structured Skill Training:** Offer categorical training programs (Aptitude, Coding, Communication, Soft Skills, Interview Prep, Resume Building) with live enrollment and seat counters.
4. **Transparent Application Tracking:** Allow students to track applications through all 5 critical stages: `Applied` ? `Under Review` ? `Shortlisted` ? `Interview` ? `Selected` (along with `Not Selected` feedback).
5. **Interview Question Bank:** Empower candidates with 10 key technical and HR categories containing model questions, detailed architectural explanations, and interviewer tips.

---

## ?? Key Features

### 1. Authentication & Onboarding
- **Validations:** Academic student ID and email validation.
- **Security:** Interactive show/hide password toggle.
- **Local Persistence:** "Remember me" functionality powered by `shared_preferences`.
- **Demo Access:** One-click instant login button for rapid grading, viva demonstrations, and testing.
- **Account Recovery:** Forgot password modal with simulated reset dispatch.

### 2. Dashboard & Career Analytics
- **KPI Metrics:** Real-time counters for Available Trainings, Active Placement Drives, Internship Openings, and Submitted Applications.
- **Career Readiness Index:** Dynamic circular gauge (0?100%) calculated from academic CGPA, skills breadth, projects, and enrolled training programs.
- **Upcoming Trainings & Latest Drives:** Fast preview of upcoming events with one-click enrollment and direct detail viewing.
- **Quick Action Tools:** Shortcuts to Interview Prep, Student Profile, Application Tracking, and TPO Support.

### 3. Training & Skill Development
- **6 Categories:** Aptitude Mastery, Coding (DSA), Corporate Communication, Soft Skills & Group Discussions, Interview Cracking, and ATS Resume Building.
- **Enrollment Flow:** Live "Register Now" / "Enrolled ?" toggle with instant seat capacity increments and notification broadcasting.
- **Detailed Dialogs:** Course syllabus modules, prerequisites, instructor profiles, mode (Online/Offline), and schedules.

### 4. Campus Placement Drives
- **Top IT & Consulting Recruiters:** Realistic corporate profiles for TCS, Infosys, Deloitte, Accenture, Wipro, Microsoft, Amazon, and Cognizant.
- **Comprehensive Listings:** CTC (LPA), locations, eligible branches, minimum CGPA criteria, required skills, drive dates, and deadlines.
- **Smart Filtering & Sorting:** Filter by location and minimum CTC package; sort by CTC (High to Low), earliest deadline, or company name.
- **Duplicate Prevention:** Protects against accidental multiple submissions for the same drive.

### 5. Internship Portal
- **Key Details:** Monthly stipends (?22,000 ? ?45,000/mo), durations (3?6 months), remote/hybrid modes, and Pre-Placement Offer (PPO) incentives.
- **Filterable:** Instant toggle between Paid Stipend roles and Credit-based internships.
- **Synchronized Tracking:** Automatically populates entries into the candidate's application tracker.

### 6. My Applications Tracker
- **Stage Progression:** Visual 5-step progress indicator (`Applied` ? `Under Review` ? `Shortlisted` ? `Interview` ? `Selected`).
- **Interview Scheduling:** Displays interview dates, MS Teams / Google Meet links, interview rounds, and personalized next-step guidance.
- **Application Management:** Option to inspect detailed timelines or withdraw applications.

### 7. Interview Preparation Hub
- **10 Core Topics:** Aptitude, Logical Reasoning, Verbal Ability, Programming, Data Structures, DBMS, Operating Systems, Computer Networks, HR Questions, and Resume Tips.
- **Interactive Q&A Cards:** Expandable cards with code snippets, difficulty indicators (Easy, Medium, Hard), topic tags, and interviewer pro tips.
- **Bookmarking:** Filter to review saved questions before stepping into an interview.

### 8. Notifications Center
- **Categories:** Interview schedules, shortlisting alerts, deadline warnings, training reminders, and offer letter requirements.
- **Inbox Management:** Unread counter badges in topbar/sidebar, single-click mark-as-read, and "Mark All as Read" actions.

### 9. Student Profile & Resume Portfolio
- **Editable Profile:** Name, Student ID, Email, Phone, Department, Year, and CGPA.
- **Dynamic Skills Stack:** Real-time tag input to add and remove technical skills.
- **Portfolio:** Project showcase with tech stacks and verified industry certifications.
- **Live Recalculation:** Editing CGPA or skills immediately refreshes the Career Readiness score.

### 10. Settings & Placement Cell Support
- **Material 3 Dark Mode:** Indigo/blue slate dark mode toggle with persistent state.
- **Notification & Privacy Controls:** Recruiter visibility toggles and alert preferences.
- **Frequently Asked Questions (FAQs):** Accordion covering eligibility rules, dream drive policies, backlogs, and NOC letters.
- **Placement Cell Contact:** Contact details for Dr. Rajeshwari Ramanathan (TPO Head), office location, email, and phone.
- **Feedback & Rating Form:** Direct feedback modal to submit portal comments.

---

## ?? Demo Credentials

| Role | Student ID / Email | Password | Access Level |
| :--- | :--- | :--- | :--- |
| **Demo Student** | `alex.sharma@campus.edu` *(or `STU2026CS042`)* | `Pass@1234` | Full Student Portal Access |

*(You can also simply click the **"One-Click Demo Student Access"** button on the Login screen).*

---

## ?? Project Architecture & Folder Structure

```text
campus_career_hub/
??? web/
?   ??? index.html                   # HTML5 shell with responsive styling and font loaders
?   ??? manifest.json                # Web App Manifest
?   ??? favicon.png
??? lib/
?   ??? main.dart                    # Application entrypoint & MultiProvider registration
?   ??? theme/
?   ?   ??? app_colors.dart          # Indigo, sky blue, emerald, amber, and slate neutrals
?   ?   ??? app_theme.dart           # Light & Dark Material 3 theme data
?   ??? utils/
?   ?   ??? responsive.dart          # Breakpoint detection (Desktop >=1100, Tablet 768-1100, Mobile <768)
?   ?   ??? app_constants.dart       # Portal strings, TPO contact information, demo credentials
?   ?   ??? formatters.dart          # Currency (LPA / Stipend) and DateTime formatters
?   ??? models/
?   ?   ??? student_model.dart       # Student entity, projects, certifications
?   ?   ??? training_model.dart      # Training module, syllabus, trainer
?   ?   ??? placement_model.dart     # Drive entity, CTC package, eligibility criteria
?   ?   ??? internship_model.dart    # Internship role, stipend, perks
?   ?   ??? application_model.dart   # 5-stage application tracking model
?   ?   ??? notification_model.dart  # Categorized system notices & alerts
?   ?   ??? interview_question_model.dart # Q&A model with difficulty and tips
?   ??? data/
?   ?   ??? demo_data.dart           # Realistic corporate dataset for TCS, Infosys, Deloitte, etc.
?   ??? services/
?   ?   ??? storage_service.dart     # SharedPreferences wrapper for persistence
?   ??? providers/
?   ?   ??? auth_provider.dart       # Authentication state, session handling
?   ?   ??? theme_provider.dart      # Dark/light theme state management
?   ?   ??? portal_provider.dart     # Central business logic (apply, register, profile, filter)
?   ??? widgets/
?   ?   ??? app_sidebar.dart         # Desktop navigation sidebar with active indicator
?   ?   ??? app_topbar.dart          # Top navigation bar with search, notifications, theme toggle
?   ?   ??? metric_card.dart         # KPI metric card with hover translation & shadows
?   ?   ??? status_badge.dart        # Distinct pill badge for application statuses
?   ?   ??? readiness_gauge.dart     # Career Readiness circular progress & score breakdown
?   ?   ??? custom_card.dart         # Reusable card container with border highlights
?   ?   ??? empty_state.dart         # Fallback view for empty filter states
?   ??? screens/
?       ??? auth/login_screen.dart   # Login screen with validation & quick fill
?       ??? main_layout_screen.dart  # Shell coordinating sidebar, topbar, and screen switcher
?       ??? dashboard/dashboard_screen.dart # KPI summary, readiness score, upcoming drives
?       ??? training/
?       ?   ??? training_screen.dart # Filterable skill training modules
?       ?   ??? training_detail_dialog.dart # Training details modal & registration
?       ??? placements/
?       ?   ??? placements_screen.dart # Active recruitment drives & filters
?       ?   ??? placement_detail_dialog.dart # Job description & apply modal
?       ??? internships/
?       ?   ??? internships_screen.dart # Internship listings & stipend filters
?       ?   ??? internship_detail_dialog.dart # Internship scope & apply modal
?       ??? applications/
?       ?   ??? applications_screen.dart # Stage progression application tracker
?       ?   ??? application_detail_dialog.dart # Application timeline & interview call details
?       ??? interview_prep/interview_prep_screen.dart # 10 Q&A categories with expandable cards
?       ??? notifications/notifications_screen.dart # Broadcast alerts & mark as read
?       ??? profile/profile_screen.dart # Editable student dossier & skills stack
?       ??? settings/settings_screen.dart # Theme toggle, FAQs, feedback, TPO contact
??? test/
    ??? widget_test.dart             # Smoke and rendering test suite
```

---

## ?? Setup & Execution Guide

### Prerequisites
- Flutter SDK (v3.16.0 or higher, tested with **Flutter 3.47.6 ? Dart 3.13.5**)
- Google Chrome browser (or modern web browser)

### 1. Clone or Navigate to the Project
```bash
cd C:\Users\sirid\.gemini\antigravity\scratch\campus_career_hub
```

### 2. Fetch Dependencies
```bash
flutter pub get
```

### 3. Run Static Code Analysis
Ensure zero warnings or compile errors:
```bash
flutter analyze
```

### 4. Run the Web Application in Chrome
```bash
flutter run -d chrome
```

### 5. Build for Production Web
Generate the optimized web bundle with HTML5 Canvas/Wasm renderer:
```bash
flutter build web --release
```
The output files will be compiled to `build/web/`, ready to be hosted on Firebase Hosting, GitHub Pages, Vercel, or Apache/Nginx.

---

## ?? Future Enhancements & Scalability

1. **Firebase Authentication & Firestore:** Seamless transition from `StorageService` to Cloud Firestore and Firebase Auth using the modular provider pattern.
2. **Resume PDF Parser:** Automatic resume text extraction using OCR to auto-populate skills and project experiences.
3. **AI Interview Simulator:** Real-time conversational mock interview powered by the Gemini Live API with speech recognition.
4. **Corporate Recruiter Portal:** Dedicated role-based view for corporate HRs to review shortlisted candidates and schedule interviews directly.
5. **Real-time Push Notifications:** Web push notifications for instant interview reschedule notices.

---

## ?? License
This project is licensed under the MIT License - free for academic, personal, and educational use.
