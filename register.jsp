<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    request.setCharacterEncoding("UTF-8");

    String dbHost = "localhost";
    String dbPort = "3306";
    String dbName = "event_db";
    String dbUser = "root";
    String dbPass = "Silentkiller@2706";

    boolean isPost = "POST".equalsIgnoreCase(request.getMethod());
    boolean success = false;
    String errorMessage = "";
    int generatedId = 0;
    Timestamp currentTimestamp = new Timestamp(System.currentTimeMillis());

    String fullname = request.getParameter("fullname");
    String email = request.getParameter("email");
    String address = request.getParameter("address");
    String course = request.getParameter("course");
    String gender = request.getParameter("gender");

    if (isPost) {
        if (fullname == null || fullname.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            address == null || address.trim().isEmpty() ||
            course == null || course.trim().isEmpty() ||
            gender == null || gender.trim().isEmpty()) {
            
            errorMessage = "All registration fields are required. Please go back and complete the form.";
        } else {
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                String url = "jdbc:mysql://" + dbHost + ":" + dbPort + "/" + dbName 
                           + "?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
                con = DriverManager.getConnection(url, dbUser, dbPass);

                String sql = "INSERT INTO registrations (fullname, email, address, course, gender) VALUES (?, ?, ?, ?, ?)";
                ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                ps.setString(1, fullname.trim());
                ps.setString(2, email.trim());
                ps.setString(3, address.trim());
                ps.setString(4, course.trim());
                ps.setString(5, gender.trim());

                int rows = ps.executeUpdate();
                if (rows > 0) {
                    success = true;
                    rs = ps.getGeneratedKeys();
                    if (rs.next()) {
                        generatedId = rs.getInt(1);
                    }
                } else {
                    errorMessage = "Failed to record participant details in the database.";
                }

            } catch (ClassNotFoundException e) {
                errorMessage = "MySQL JDBC Driver (com.mysql.cj.jdbc.Driver) was not found in WEB-INF/lib.";
            } catch (SQLException e) {
                if (e.getErrorCode() == 1062) {
                    errorMessage = "The email address <strong>" + email + "</strong> has already been registered! Each participant must register with a unique email.";
                } else {
                    errorMessage = "Database Error (" + e.getErrorCode() + "): " + e.getMessage() 
                                 + "<br><a href='dbconfig.jsp' class='alert-link'>Click here to configure the database</a>.";
                }
            } catch (Exception e) {
                errorMessage = "Unexpected Error: " + e.getMessage();
            } finally {
                if (rs != null) try { rs.close(); } catch (Exception ignored) {}
                if (ps != null) try { ps.close(); } catch (Exception ignored) {}
                if (con != null) try { con.close(); } catch (Exception ignored) {}
            }
        }
    }

    String courseLabel = course;
    if ("web-dev".equalsIgnoreCase(course)) courseLabel = "Web Development Track";
    else if ("code".equalsIgnoreCase(course)) courseLabel = "Coding & Algorithms";
    else if ("cyber".equalsIgnoreCase(course)) courseLabel = "CyberSecurity Track";
    else if ("ai-ml".equalsIgnoreCase(course)) courseLabel = "Artificial Intelligence & ML";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registration Confirmation - Department of IT</title>
    <!-- Fonts & Bootstrap -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        :root {
            --primary: #2563eb;
            --font-heading: 'Outfit', sans-serif;
            --font-body: 'Inter', sans-serif;
        }

        body {
            background-color: #f1f5f9;
            font-family: var(--font-body);
            color: #1e293b;
        }

        .receipt-card {
            background: #ffffff;
            border-radius: 20px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 20px 40px -15px rgba(0, 0, 0, 0.08);
            overflow: hidden;
            max-width: 680px;
            margin: 0 auto;
        }

        .receipt-header {
            background: linear-gradient(135deg, #091124 0%, #0f1c3f 60%, #1e3a8a 100%);
            color: #ffffff;
            padding: 32px;
            text-align: center;
            position: relative;
        }

        .check-badge {
            width: 64px;
            height: 64px;
            background: #22c55e;
            color: #ffffff;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            margin-bottom: 16px;
            box-shadow: 0 0 0 8px rgba(34, 197, 94, 0.25);
        }

        .receipt-title {
            font-family: var(--font-heading);
            font-size: 1.85rem;
            font-weight: 800;
            margin-bottom: 4px;
        }

        .pass-tag {
            background: #f8fafc;
            border: 1px dashed #cbd5e1;
            border-radius: 12px;
            padding: 16px;
            text-align: center;
            margin-bottom: 24px;
        }

        .pass-id {
            font-family: 'Courier New', Courier, monospace;
            font-size: 22px;
            font-weight: 800;
            color: #2563eb;
            letter-spacing: 2px;
        }

        .avatar-box {
            width: 48px;
            height: 48px;
            background: #2563eb;
            color: white;
            font-weight: 700;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
        }

        @media print {
            .no-print { display: none !important; }
            body { background: #ffffff; }
            .receipt-card { box-shadow: none; border: 1px solid #000; }
        }
    </style>
</head>
<body class="py-5">
    <div class="container">
        
        <div class="receipt-card">

            <% if (!isPost) { %>
                <!-- No POST Data -->
                <div class="p-5 text-center">
                    <i class="bi bi-info-circle text-primary display-3 mb-3"></i>
                    <h3 class="fw-bold mb-2">No Form Submission Detected</h3>
                    <p class="text-muted mb-4">Please submit your details using the Event Registration form to save your info in MySQL.</p>
                    <a href="Experiment7.jsp" class="btn btn-primary px-4 py-2 rounded-3">
                        <i class="bi bi-arrow-left me-1"></i> Go to Registration Form
                    </a>
                </div>

            <% } else if (success) { %>
                <!-- Success Digital Admission Pass -->
                <div class="receipt-header">
                    <div class="check-badge">
                        <i class="bi bi-check-lg"></i>
                    </div>
                    <h2 class="receipt-title">Registration Confirmed!</h2>
                    <p class="text-slate-300 mb-0 opacity-75">Your registration has been securely stored in the MySQL database.</p>
                </div>

                <div class="p-4 p-md-5">
                    
                    <div class="pass-tag">
                        <div class="small text-muted text-uppercase fw-bold mb-1">Official Enrollment Reference</div>
                        <div class="pass-id">REF-ITRC-2026-<%= generatedId > 0 ? String.format("%04d", generatedId) : "OK" %></div>
                        <div class="small text-muted mt-1"><i class="bi bi-clock me-1"></i><%= new SimpleDateFormat("dd MMMM yyyy, hh:mm a").format(currentTimestamp) %></div>
                    </div>

                    <div class="d-flex align-items-center gap-3 mb-4 p-3 bg-light rounded-3">
                        <div class="avatar-box">
                            <%= (fullname != null && fullname.length() > 0) ? fullname.substring(0, 1).toUpperCase() : "U" %>
                        </div>
                        <div>
                            <h5 class="fw-bold mb-0 text-dark"><%= fullname %></h5>
                            <span class="text-muted small"><i class="bi bi-envelope me-1"></i><%= email %></span>
                        </div>
                    </div>

                    <table class="table table-bordered mb-4">
                        <tbody>
                            <tr>
                                <th class="bg-light text-muted w-35" style="width: 35%;">Selected Track:</th>
                                <td class="fw-bold text-primary">
                                    <span class="badge bg-primary px-3 py-1.5"><%= courseLabel %></span>
                                </td>
                            </tr>
                            <tr>
                                <th class="bg-light text-muted">Gender:</th>
                                <td class="text-capitalize"><%= gender %></td>
                            </tr>
                            <tr>
                                <th class="bg-light text-muted">Campus Address:</th>
                                <td><%= address %></td>
                            </tr>
                            <tr>
                                <th class="bg-light text-muted">Database Engine:</th>
                                <td><code>MySQL &bull; event_db.registrations</code></td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="d-flex flex-wrap gap-2 justify-content-between pt-3 border-top no-print">
                        <button onclick="window.print();" class="btn btn-outline-dark px-3 py-2">
                            <i class="bi bi-printer me-1"></i> Print Pass
                        </button>
                        <div class="d-flex gap-2">
                            <a href="viewDetails.jsp" class="btn btn-success px-4 py-2">
                                <i class="bi bi-table me-1"></i> View All Records
                            </a>
                            <a href="Experiment7.jsp" class="btn btn-outline-secondary px-3 py-2">
                                <i class="bi bi-person-plus me-1"></i> Add Another
                            </a>
                        </div>
                    </div>

                </div>

            <% } else { %>
                <!-- Error View -->
                <div class="p-5 text-center">
                    <div class="d-inline-flex align-items-center justify-content-center bg-danger text-white rounded-circle mb-3" style="width: 70px; height: 70px;">
                        <i class="bi bi-exclamation-triangle-fill display-5"></i>
                    </div>
                    <h3 class="fw-bold text-danger mb-2">Registration Could Not Be Completed</h3>
                    <div class="alert alert-danger text-start my-4">
                        <%= errorMessage %>
                    </div>
                    <div class="d-flex gap-2 justify-content-center">
                        <a href="javascript:history.back();" class="btn btn-secondary px-4">
                            <i class="bi bi-arrow-left me-1"></i> Edit Form
                        </a>
                        <a href="dbconfig.jsp" class="btn btn-outline-primary px-4">
                            <i class="bi bi-database-gear me-1"></i> Check DB Setup
                        </a>
                    </div>
                </div>
            <% } %>

        </div>

    </div>
</body>
</html>
