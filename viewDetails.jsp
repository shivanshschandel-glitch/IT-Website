<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>
<%
    String dbHost = "localhost";
    String dbPort = "3306";
    String dbName = "event_db";
    String dbUser = "root";
    String dbPass = "";

    Connection con = null;
    Statement stmt = null;
    ResultSet rs = null;

    boolean hasError = false;
    String errorMessage = "";
    int totalCount = 0;
    int webDevCount = 0;
    int codeCount = 0;
    int cyberCount = 0;
    int aimlCount = 0;

    // Use a list to store participant records so we can calculate stats cleanly
    class Participant {
        int id;
        String name;
        String email;
        String address;
        String course;
        String gender;
        Timestamp regTime;
    }

    List<Participant> participants = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://" + dbHost + ":" + dbPort + "/" + dbName 
                   + "?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
        con = DriverManager.getConnection(url, dbUser, dbPass);
        stmt = con.createStatement();
        rs = stmt.executeQuery("SELECT id, fullname, email, address, course, gender, registered_at FROM registrations ORDER BY id ASC");

        while (rs.next()) {
            Participant p = new Participant();
            p.id = rs.getInt("id");
            p.name = rs.getString("fullname");
            p.email = rs.getString("email");
            p.address = rs.getString("address");
            p.course = rs.getString("course");
            p.gender = rs.getString("gender");
            p.regTime = rs.getTimestamp("registered_at");
            participants.add(p);

            totalCount++;
            if ("web-dev".equalsIgnoreCase(p.course)) webDevCount++;
            else if ("code".equalsIgnoreCase(p.course)) codeCount++;
            else if ("cyber".equalsIgnoreCase(p.course)) cyberCount++;
            else if ("ai-ml".equalsIgnoreCase(p.course)) aimlCount++;
        }
    } catch (ClassNotFoundException e) {
        hasError = true;
        errorMessage = "MySQL JDBC Driver (com.mysql.cj.jdbc.Driver) was not found in WEB-INF/lib.";
    } catch (SQLException e) {
        hasError = true;
        errorMessage = "Database Error (" + e.getErrorCode() + "): " + e.getMessage();
    } catch (Exception e) {
        hasError = true;
        errorMessage = "Unexpected Error: " + e.getMessage();
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
        if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
        if (con != null) try { con.close(); } catch (Exception ignored) {}
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registered Event Participants - Department of IT</title>
    <!-- Fonts & Bootstrap 5 -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        :root {
            --primary: #2563eb;
            --navy-dark: #091124;
            --font-heading: 'Outfit', sans-serif;
            --font-body: 'Inter', sans-serif;
        }

        body {
            background-color: #f8fafc;
            font-family: var(--font-body);
            color: #1e293b;
        }

        .header-card {
            background: linear-gradient(135deg, #091124 0%, #0f1c3f 50%, #1e3a8a 100%);
            color: #ffffff;
            border-radius: 20px;
            padding: 36px 32px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            margin-bottom: 28px;
        }

        .header-card h2 {
            font-family: var(--font-heading);
            font-size: 2.2rem;
            font-weight: 800;
            margin-bottom: 6px;
        }

        .stat-card-mini {
            background: #ffffff;
            border-radius: 16px;
            padding: 20px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.03);
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
        }

        .stat-val {
            font-family: var(--font-heading);
            font-size: 1.6rem;
            font-weight: 800;
            line-height: 1.1;
            color: #0f172a;
        }

        .table-card {
            background: #ffffff;
            border-radius: 20px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 6px 25px rgba(0, 0, 0, 0.04);
            overflow: hidden;
        }

        .table thead th {
            background-color: #0f172a;
            color: #ffffff;
            font-weight: 600;
            font-size: 13.5px;
            padding: 16px 20px;
            border: none;
            letter-spacing: 0.3px;
        }

        .table tbody td {
            padding: 16px 20px;
            vertical-align: middle;
            border-bottom: 1px solid #f1f5f9;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #e0f2fe;
            color: #0369a1;
            font-weight: 700;
            font-size: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .badge-track {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .track-web-dev { background: #eff6ff; color: #1d4ed8; border: 1px solid #bfdbfe; }
        .track-code { background: #ecfdf5; color: #047857; border: 1px solid #a7f3d0; }
        .track-cyber { background: #fffbeb; color: #b45309; border: 1px solid #fde68a; }
        .track-ai-ml { background: #faf5ff; color: #6d28d9; border: 1px solid #ddd6fe; }

        @media print {
            .no-print { display: none !important; }
            body { background: #fff; }
            .table-card { box-shadow: none; border: 1px solid #ddd; }
        }
    </style>
</head>
<body class="py-4">
    <div class="container-fluid px-md-5">
        
        <!-- Header Banner -->
        <div class="header-card no-print">
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
                <div>
                    <span class="badge bg-primary bg-opacity-35 text-white border border-primary border-opacity-50 px-3 py-1 rounded-pill mb-2">
                        <i class="bi bi-database-check me-1"></i> Database Roster &bull; Tomcat 11
                    </span>
                    <h2>Registered Event Participants</h2>
                    <p class="text-slate-300 mb-0 opacity-75">
                        Live participant data persisted in MySQL database (<code><%= dbName %>.registrations</code>)
                    </p>
                </div>
                <div class="d-flex flex-wrap gap-2">
                    <a href="Experiment7.jsp" class="btn btn-primary rounded-pill px-4">
                        <i class="bi bi-person-plus-fill me-1"></i> New Registration
                    </a>
                    <a href="dbconfig.jsp" class="btn btn-outline-light rounded-pill px-3">
                        <i class="bi bi-database-gear me-1"></i> DB Setup
                    </a>
                    <button onclick="window.print();" class="btn btn-outline-light rounded-pill px-3" title="Print this roster">
                        <i class="bi bi-printer"></i>
                    </button>
                    <button onclick="window.location.reload();" class="btn btn-outline-light rounded-pill px-3" title="Refresh">
                        <i class="bi bi-arrow-clockwise"></i>
                    </button>
                </div>
            </div>
        </div>

        <% if (hasError) { %>
            <div class="alert alert-danger p-4 rounded-4 shadow-sm" role="alert">
                <div class="d-flex align-items-center mb-2">
                    <i class="bi bi-exclamation-triangle-fill fs-3 text-danger me-3"></i>
                    <h4 class="alert-heading fw-bold mb-0">Database Connection Failed</h4>
                </div>
                <p class="mb-3"><%= errorMessage %></p>
                <hr>
                <p class="mb-0">
                    Run the database setup script to initialize MySQL: 
                    <a href="dbconfig.jsp" class="btn btn-danger btn-sm ms-2"><i class="bi bi-gear-fill me-1"></i> Open dbconfig.jsp</a>
                </p>
            </div>
        <% } else { %>

            <!-- Stats Overview Cards -->
            <div class="row g-3 mb-4 no-print">
                <div class="col-6 col-md-3">
                    <div class="stat-card-mini">
                        <div class="stat-icon bg-primary bg-opacity-10 text-primary">
                            <i class="bi bi-people-fill"></i>
                        </div>
                        <div>
                            <div class="stat-val"><%= totalCount %></div>
                            <small class="text-muted">Total Participants</small>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="stat-card-mini">
                        <div class="stat-icon bg-info bg-opacity-10 text-primary">
                            <i class="bi bi-globe"></i>
                        </div>
                        <div>
                            <div class="stat-val"><%= webDevCount %></div>
                            <small class="text-muted">Web Development</small>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="stat-card-mini">
                        <div class="stat-icon bg-success bg-opacity-10 text-success">
                            <i class="bi bi-code-slash"></i>
                        </div>
                        <div>
                            <div class="stat-val"><%= codeCount %></div>
                            <small class="text-muted">Coding Track</small>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="stat-card-mini">
                        <div class="stat-icon bg-purple-subtle text-purple" style="background:#faf5ff; color:#7c3aed;">
                            <i class="bi bi-shield-check"></i>
                        </div>
                        <div>
                            <div class="stat-val"><%= cyberCount + aimlCount %></div>
                            <small class="text-muted">Cyber &amp; AI Tracks</small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Table Card -->
            <div class="table-card p-4">
                
                <!-- Filter Bar -->
                <div class="row g-3 mb-4 align-items-center justify-content-between no-print">
                    <div class="col-12 col-md-5">
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0"><i class="bi bi-search text-muted"></i></span>
                            <input type="text" id="searchInput" class="form-control border-start-0" placeholder="Search by name, email, course, address, or ID...">
                        </div>
                    </div>
                    <div class="col-auto d-flex align-items-center gap-2">
                        <span class="badge bg-light text-secondary border px-3 py-2 fs-6" id="recordBadge">
                            <%= totalCount %> Records Found
                        </span>
                        <button onclick="exportCSV();" class="btn btn-outline-secondary btn-sm" title="Download CSV">
                            <i class="bi bi-download me-1"></i> Export CSV
                        </button>
                    </div>
                </div>

                <!-- Table Content -->
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0" id="registrationsTable">
                        <thead>
                            <tr>
                                <th scope="col" style="width: 70px;">#ID</th>
                                <th scope="col">Participant</th>
                                <th scope="col">Contact Email</th>
                                <th scope="col">Course Track</th>
                                <th scope="col">Gender</th>
                                <th scope="col">Campus Address</th>
                                <th scope="col">Registered At</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
                                for (Participant p : participants) {
                                    String initial = (p.name != null && p.name.length() > 0) ? p.name.substring(0, 1).toUpperCase() : "U";
                                    String trackBadge = "badge-track track-web-dev";
                                    String trackName = p.course;
                                    if ("web-dev".equalsIgnoreCase(p.course)) { trackBadge = "badge-track track-web-dev"; trackName = "Web Development"; }
                                    else if ("code".equalsIgnoreCase(p.course)) { trackBadge = "badge-track track-code"; trackName = "Coding & Algorithms"; }
                                    else if ("cyber".equalsIgnoreCase(p.course)) { trackBadge = "badge-track track-cyber"; trackName = "CyberSecurity"; }
                                    else if ("ai-ml".equalsIgnoreCase(p.course)) { trackBadge = "badge-track track-ai-ml"; trackName = "AI & Machine Learning"; }
                                    
                                    String timeStr = p.regTime != null ? sdf.format(p.regTime) : "N/A";
                            %>
                            <tr>
                                <td class="fw-bold text-muted">#<%= String.format("%03d", p.id) %></td>
                                <td>
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="user-avatar"><%= initial %></div>
                                        <div>
                                            <div class="fw-bold text-dark"><%= p.name %></div>
                                            <small class="text-muted">Student Participant</small>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <a href="mailto:<%= p.email %>" class="text-decoration-none text-dark">
                                        <i class="bi bi-envelope text-primary me-1"></i><%= p.email %>
                                    </a>
                                </td>
                                <td>
                                    <span class="<%= trackBadge %>">
                                        <%= trackName %>
                                    </span>
                                </td>
                                <td>
                                    <% if ("male".equalsIgnoreCase(p.gender)) { %>
                                        <span class="badge bg-light text-primary border"><i class="bi bi-gender-male me-1"></i>Male</span>
                                    <% } else if ("female".equalsIgnoreCase(genderCheck(p.gender))) { %>
                                        <span class="badge bg-light text-danger border"><i class="bi bi-gender-female me-1"></i>Female</span>
                                    <% } else { %>
                                        <span class="badge bg-light text-secondary border"><i class="bi bi-person me-1"></i><%= p.gender %></span>
                                    <% } %>
                                </td>
                                <td class="text-truncate" style="max-width: 220px;" title="<%= p.address %>">
                                    <%= p.address %>
                                </td>
                                <td class="small text-muted"><%= timeStr %></td>
                            </tr>
                            <%
                                }
                                if (totalCount == 0) {
                            %>
                            <tr>
                                <td colspan="7" class="text-center py-5">
                                    <i class="bi bi-folder2-open display-4 text-muted mb-3 d-block"></i>
                                    <h5 class="fw-bold text-dark">No Registered Participants Found</h5>
                                    <p class="text-muted mb-3">The database table is ready, but currently contains 0 records.</p>
                                    <div class="d-flex justify-content-center gap-2">
                                        <a href="dbconfig.jsp" class="btn btn-outline-primary btn-sm">
                                            <i class="bi bi-database-fill-add me-1"></i> Seed Sample Records
                                        </a>
                                        <a href="Experiment7.jsp" class="btn btn-primary btn-sm">
                                            <i class="bi bi-person-plus me-1"></i> Register First Participant
                                        </a>
                                    </div>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>

                <!-- Footer info -->
                <div class="d-flex justify-content-between align-items-center mt-3 pt-3 border-top small text-muted no-print">
                    <span>Showing <strong><%= totalCount %></strong> registered participant(s)</span>
                    <span>Apache Tomcat 11 &bull; Jakarta JSP &bull; MySQL Connector/J 9.1.0</span>
                </div>

            </div>

        <% } %>

    </div>

    <!-- Client-side Search and CSV Export Script -->
    <script>
        const searchInput = document.getElementById('searchInput');
        if (searchInput) {
            searchInput.addEventListener('keyup', function () {
                const query = this.value.toLowerCase();
                const rows = document.querySelectorAll('#registrationsTable tbody tr');
                let count = 0;

                rows.forEach(row => {
                    const text = row.innerText.toLowerCase();
                    if (text.includes(query)) {
                        row.style.display = '';
                        count++;
                    } else {
                        row.style.display = 'none';
                    }
                });

                document.getElementById('recordBadge').innerText = count + ' of <%= totalCount %> Records';
            });
        }

        function exportCSV() {
            let csv = "ID,Full Name,Email,Course Track,Gender,Address,Registered At\n";
            const rows = document.querySelectorAll('#registrationsTable tbody tr');
            rows.forEach(r => {
                const cols = r.querySelectorAll('td');
                if (cols.length >= 7) {
                    const rowData = [
                        cols[0].innerText.replace('#', '').trim(),
                        '"' + cols[1].innerText.replace(/\n.*/, '').trim() + '"',
                        '"' + cols[2].innerText.trim() + '"',
                        '"' + cols[3].innerText.trim() + '"',
                        '"' + cols[4].innerText.trim() + '"',
                        '"' + cols[5].innerText.trim() + '"',
                        '"' + cols[6].innerText.trim() + '"'
                    ];
                    csv += rowData.join(',') + "\n";
                }
            });

            const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
            const link = document.createElement("a");
            link.href = URL.createObjectURL(blob);
            link.setAttribute("download", "Registered_Participants_2026.csv");
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }
    </script>
</body>
</html>
<%!
    private String genderCheck(String g) {
        return g != null ? g.toLowerCase() : "";
    }
%>
