================================================================================
# Department of Information Technology Web Portal & Event Registration System
================================================================================

An executive, responsive departmental web portal featuring pure-CSS tabbed 
navigation, academic and multimedia service hubs, and a full-stack database-backed 
event registration system developed for the Department of Information Technology 
at Madan Mohan Malaviya University of Technology (MMMUT).

# Project Members:
- Member 1: Shivansh Singh Chandel / 2026071157
- Member 2: Sunidh Kumar / 2026071162
- Member 3: Samridhi Tripathi / 2026071152
- Member 4: Ishita Sharma / 2026071132

# Project Supervisor:
- Supervisor: Mr. Tejbahadur / Assistant Professor


## Features
--------------------------------------------------------------------------------
* Pure-CSS Tab Navigation: Zero-JavaScript tabbed interface using hidden radio 
  inputs and sibling combinators (:checked ~ main) ensuring only the selected 
  page is visible on screen.
* Departmental Profile (Experiment 4): Executive overview featuring university 
  motto ("Innovate - Integrate - Dominate"), key performance indicators (KPIs), 
  academic program cards (B.Tech, M.Tech, MCA), and faculty directory roster.
* Academic Services & E-Learning Hub (Experiment 2): Curated resource links 
  (MDN Docs, Wikipedia, Codecademy), modular syllabus viewer (Class.html), and 
  integrated HTML5 media players for video roadmaps and department audio.
* Dynamic Event Registration (Experiment 7): User-friendly form with leading 
  input icons, course track selector, and interactive gender card selectors.
* Server-Side SQL Persistence (JSP & JDBC): Secure parameter handling via 
  PreparedStatement preventing SQL injection, with duplicate email detection.
* Automated Database Setup & Seeding (dbconfig.jsp): Single-click script that 
  creates the MySQL database (event_db), builds the registrations table, and 
  populates initial dummy entries.
* Live Participant Dashboard (viewDetails.jsp): Interactive roster with track 
  statistics, real-time client-side search filtering, participant initials 
  avatars, and one-click export to CSV.
* Digital Admission Pass (register.jsp): Printable confirmation pass featuring 
  unique registration reference codes (REF-ITRC-2026-XXXX) and submission timestamps.


## Tech Stack
--------------------------------------------------------------------------------
* Frontend:
  - HTML5 & CSS3 (Flexbox, CSS Grid, Glassmorphism, CSS Custom Properties)
  - Pure CSS Tab Architecture (no JavaScript required for tab switching)
  - Bootstrap 5.3 & Bootstrap Icons 1.11
  - Typography: Google Fonts (Outfit for headings, Inter for body text)

* Backend:
  - Java SE 17+ / 21+ (Tested on Java 18 & Java 27)
  - Jakarta EE 11 / JSP 4.0 / Servlet 6.1 (Apache Tomcat 11)
  - JDBC API (Java Database Connectivity)

* Database:
  - MySQL Server 8.0+ / 9.x (InnoDB Engine, utf8mb4)
  - Official Connector: MySQL Connector/J 9.1.0 (mysql-connector-j-9.1.0.jar)


## Prerequisites
--------------------------------------------------------------------------------
Ensure the following software packages are installed on your system:
* Java Development Kit (JDK): Version 17 or higher (JDK 21 LTS recommended)
* Web Server: Apache Tomcat 11.0.x (Jakarta EE 11 compatible binary release)
* Relational Database: MySQL Server 8.0+ or MySQL 9.x running on port 3306
* Web Browser: Modern Chromium, Firefox, or Safari browser


## Installation & Setup
--------------------------------------------------------------------------------
1. Deploy Project to Apache Tomcat 11:
   Copy or extract the project directory into your Tomcat webapps folder:
   Path: <TOMCAT_HOME>/webapps/Project/

   Directory layout:
   Project/
   |-- index.html              (Main portal shell with pure-CSS tab navigation)
   |-- Experiment5style.css    (Portal styling and responsive glassmorphic theme)
   |-- Experiment4.html        (Home tab - Department profile and faculty roster)
   |-- Experiment4style.css    (Styling for Department profile)
   |-- Experiment2.html        (Services tab - E-learning resources & multimedia)
   |-- Class.html              (Modular syllabus catalog)
   |-- Experiment7.jsp         (Event registration form)
   |-- register.jsp            (JSP processor - inserts records into MySQL)
   |-- viewDetails.jsp         (Live participants roster and CSV export)
   |-- dbconfig.jsp            (Automated database creation and seeding)
   |-- database.sql            (Standalone SQL script for manual import)
   |-- logo.png / MMMUT.png    (Department branding assets)
   |-- WEB-INF/
       |-- web.xml             (Jakarta EE 11 / Servlet 6.1 deployment descriptor)
       |-- lib/
           |-- mysql-connector-j-9.1.0.jar (MySQL JDBC Driver)

2. Configure Database & Start MySQL:
   * Start your MySQL server on port 3306.
   * If your MySQL root account uses a password, update the DB_PASS variable in:
     - dbconfig.jsp (line 11)
     - register.jsp (line 12)
     - viewDetails.jsp (line 11)
     (Default is set to DB_USER = "root" and DB_PASS = "")

3. Start Apache Tomcat:
   Open a terminal or command prompt in your Tomcat installation directory:
   Windows:
     cd <TOMCAT_HOME>\bin
     catalina.bat start
     (or double-click startup.bat)

4. Initialize Database & Seed Dummy Data:
   Open your browser and navigate to:
   http://localhost:8080/Project/dbconfig.jsp

   This will automatically:
   - Create database 'event_db' if it does not exist
   - Create table 'registrations'
   - Seed 4 initial participant records


## Usage
--------------------------------------------------------------------------------
Once Tomcat and MySQL are running, access the portal endpoints:

1. Main Portal Interface:
   URL: http://localhost:8080/Project/index.html
   - Click "Home" to review department history, degree programs, and faculty.
   - Click "Services" to access classroom resources, syllabus, and videos.
   - Click "Registration" to open the event enrollment form.

2. Event Registration Form:
   URL: http://localhost:8080/Project/Experiment7.jsp
   - Enter Full Name, Email, Address, select a Course Track, and select Gender.
   - Click "Submit & Save Registration".
   - View your digital confirmation pass and click "Print Pass" for a hard copy.

3. View Registered Details:
   URL: http://localhost:8080/Project/viewDetails.jsp
   - Displays all participants stored in the MySQL table.
   - Use the live search bar to instantly filter by name, track, or address.
   - Click "Export CSV" to download the records for reporting.
