<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%!
    public static final String DB_HOST = "localhost";
    public static final String DB_PORT = "3306";
    public static final String DB_NAME = "event_db";
    public static final String DB_USER = "root";
    public static final String DB_PASS = "Silentkiller@2706"; 
    public static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";

    public static Connection getConnection() throws Exception {
        Class.forName(JDBC_DRIVER);
        String url = "jdbc:mysql://" + DB_HOST + ":" + DB_PORT + "/" + DB_NAME 
                   + "?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
        return DriverManager.getConnection(url, DB_USER, DB_PASS);
    }
%>
<%
    String statusMessage = "";
    boolean dbCreated = false;
    boolean tableCreated = false;
    int dummyCount = 0;
    boolean hasError = false;
    String errorMessage = "";
    int totalRecords = 0;

    String user = request.getParameter("user") != null ? request.getParameter("user") : DB_USER;
    String pass = request.getParameter("pass") != null ? request.getParameter("pass") : DB_PASS;
    String forceReset = request.getParameter("reset");

    Connection conn = null;
    Statement stmt = null;

    try {
        Class.forName(JDBC_DRIVER);
        String serverUrl = "jdbc:mysql://" + DB_HOST + ":" + DB_PORT + "/?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";
        conn = DriverManager.getConnection(serverUrl, user, pass);
        stmt = conn.createStatement();

        // 1. Create database
        stmt.executeUpdate("CREATE DATABASE IF NOT EXISTS " + DB_NAME);
        dbCreated = true;

        stmt.execute("USE " + DB_NAME);

        if ("true".equalsIgnoreCase(forceReset)) {
            stmt.executeUpdate("DROP TABLE IF EXISTS registrations");
        }

        // 2. Create table
        String sqlCreateTable = "CREATE TABLE IF NOT EXISTS registrations ("
                              + "  id INT AUTO_INCREMENT PRIMARY KEY,"
                              + "  fullname VARCHAR(100) NOT NULL,"
                              + "  email VARCHAR(100) NOT NULL UNIQUE,"
                              + "  address TEXT NOT NULL,"
                              + "  course VARCHAR(50) NOT NULL,"
                              + "  gender VARCHAR(20) NOT NULL,"
                              + "  registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
                              + ")";
        stmt.executeUpdate(sqlCreateTable);
        tableCreated = true;

        // 3. Count records
        ResultSet rsCount = stmt.executeQuery("SELECT COUNT(*) AS total FROM registrations");
        if (rsCount.next()) {
            totalRecords = rsCount.getInt("total");
        }
        rsCount.close();

        // 4. Seed dummy records if table is empty
        if (totalRecords == 0) {
            String insertDummy = "INSERT INTO registrations (fullname, email, address, course, gender) VALUES "
                               + "('Alice Johnson', 'alice.johnson@example.com', '123 University Campus, Block A', 'web-dev', 'female'), "
                               + "('Bob Smith', 'bob.smith@example.com', '45 North Avenue, Tech Park', 'code', 'male'), "
                               + "('Charlie Brown', 'charlie.brown@example.com', '78 Silicon Lane, South Wing', 'ai-ml', 'male'), "
                               + "('Diana Prince', 'diana.prince@example.com', '99 Cyber Road, Metro Heights', 'cyber', 'female')";
            dummyCount = stmt.executeUpdate(insertDummy);
            totalRecords += dummyCount;
        }

    } catch (ClassNotFoundException e) {
        hasError = true;
        errorMessage = "JDBC Driver Not Found: " + e.getMessage() + ". Ensure mysql-connector-j.jar is in WEB-INF/lib.";
    } catch (SQLException e) {
        hasError = true;
        errorMessage = "SQL / Database Error: " + e.getMessage();
    } catch (Exception e) {
        hasError = true;
        errorMessage = "Unexpected Error: " + e.getMessage();
    } finally {
        if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Database Configuration - Department of IT</title>
    <!-- Fonts & Bootstrap 5 -->
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

        .config-card {
            background: #ffffff;
            border-radius: 20px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 16px 40px -10px rgba(15, 23, 42, 0.08);
            overflow: hidden;
            max-width: 820px;
            margin: 0 auto;
        }

        .config-header {
            background: linear-gradient(135deg, #091124 0%, #0f1c3f 60%, #1e3a8a 100%);
            color: #ffffff;
            padding: 36px 32px;
        }

        .config-header h2 {
            font-family: var(--font-heading);
            font-size: 2rem;
            font-weight: 800;
            margin-bottom: 6px;
        }

        .status-badge {
            font-size: 0.9rem;
            padding: 6px 14px;
            border-radius: 20px;
            font-weight: 600;
        }
    </style>
</head>
<body class="py-5">
    <div class="container">
        
        <div class="config-card">
            
            <div class="config-header">
                <div class="d-flex align-items-center gap-3">
                    <div class="p-3 bg-white bg-opacity-10 rounded-3">
                        <i class="bi bi-database-gear fs-1 text-primary"></i>
                    </div>
                    <div>
                        <h2>Database Setup &amp; Configuration</h2>
                        <p class="text-slate-300 mb-0 opacity-75">
                            Automated MySQL DDL, Table Verification &amp; Seeder &bull; Apache Tomcat 11
                        </p>
                    </div>
                </div>
            </div>

            <div class="p-4 p-md-5">

                <% if (hasError) { %>
                    <div class="alert alert-danger p-4 rounded-4 mb-4" role="alert">
                        <div class="d-flex align-items-center mb-2">
                            <i class="bi bi-exclamation-triangle-fill fs-3 me-3 text-danger"></i>
                            <h5 class="alert-heading fw-bold mb-0">Configuration Failed</h5>
                        </div>
                        <p class="mb-2"><%= errorMessage %></p>
                        <hr>
                        <div class="small">
                            <strong>Quick Troubleshooting Checklist:</strong>
                            <ul class="mb-0 mt-1">
                                <li>Is MySQL service running on port <code><%= DB_PORT %></code>?</li>
                                <li>Are the credentials correct? (User: <code><%= user %></code>, Password: <code><%= pass.isEmpty() ? "[blank]" : "******" %></code>)</li>
                                <li>Is <code>mysql-connector-j-9.1.0.jar</code> present in <code>WEB-INF/lib</code>?</li>
                            </ul>
                        </div>
                    </div>
                <% } else { %>
                    
                    <div class="alert alert-success d-flex align-items-center p-3 rounded-4 mb-4" role="alert">
                        <i class="bi bi-check-circle-fill fs-3 me-3 text-success"></i>
                        <div>
                            <h6 class="alert-heading fw-bold mb-0">Database Ready &amp; Synchronized!</h6>
                            <small class="text-muted">The MySQL database, table structure, and initial data are fully operational.</small>
                        </div>
                    </div>

                    <div class="list-group mb-4 rounded-3 border">
                        <div class="list-group-item d-flex justify-content-between align-items-center py-3">
                            <div>
                                <i class="bi bi-hdd-network text-primary me-2"></i>
                                <strong>MySQL Server:</strong>
                                <span class="text-muted small ms-2"><%= DB_HOST %>:<%= DB_PORT %></span>
                            </div>
                            <span class="badge bg-success status-badge"><i class="bi bi-check-lg me-1"></i> Connected</span>
                        </div>

                        <div class="list-group-item d-flex justify-content-between align-items-center py-3">
                            <div>
                                <i class="bi bi-database text-primary me-2"></i>
                                <strong>Database Schema:</strong>
                                <span class="text-muted small ms-2"><code><%= DB_NAME %></code></span>
                            </div>
                            <span class="badge bg-success status-badge"><i class="bi bi-check-lg me-1"></i> Active</span>
                        </div>

                        <div class="list-group-item d-flex justify-content-between align-items-center py-3">
                            <div>
                                <i class="bi bi-table text-primary me-2"></i>
                                <strong>Table Schema:</strong>
                                <span class="text-muted small ms-2"><code>registrations</code></span>
                            </div>
                            <span class="badge bg-success status-badge"><i class="bi bi-check-lg me-1"></i> Verified</span>
                        </div>

                        <div class="list-group-item d-flex justify-content-between align-items-center py-3">
                            <div>
                                <i class="bi bi-people text-primary me-2"></i>
                                <strong>Total Registered Records:</strong>
                                <span class="text-muted small ms-2">(<%= dummyCount > 0 ? dummyCount + " dummy entries seeded" : "existing data preserved" %>)</span>
                            </div>
                            <span class="badge bg-primary status-badge"><%= totalRecords %> Records</span>
                        </div>
                    </div>

                <% } %>

                <!-- Action Navigation -->
                <div class="d-flex flex-wrap gap-2 justify-content-between pt-3 border-top">
                    <a href="Experiment7.jsp" class="btn btn-primary px-4 py-2 rounded-3">
                        <i class="bi bi-person-plus-fill me-1"></i> Go to Registration Form
                    </a>
                    <div class="d-flex gap-2">
                        <a href="viewDetails.jsp" class="btn btn-outline-success px-4 py-2 rounded-3">
                            <i class="bi bi-table me-1"></i> View Registered Details
                        </a>
                        <a href="dbconfig.jsp?reset=true" class="btn btn-outline-secondary px-3 py-2 rounded-3" onclick="return confirm('Reset table and re-seed dummy entries?');">
                            <i class="bi bi-arrow-clockwise me-1"></i> Reset &amp; Re-seed
                        </a>
                    </div>
                </div>

            </div>

        </div>

    </div>
</body>
</html>
