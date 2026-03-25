<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Admin Dashboard</title>

<style>
    * {
        box-sizing: border-box;
    }

    body {
        margin: 0;
        font-family: Arial, sans-serif;
        display: flex;
        height: 100vh;
        background: #EAF0F0;
        overflow-x: hidden;
        position: relative;
    }

    .sidebar {
        width: 250px;
        height: calc(100vh - 50px);
        margin-top: 50px;
        background-color: #f0f8ff;
        color: #007fff;
        padding: 30px 20px;
        display: flex;
        flex-direction: column;
        border-right: 1px solid rgba(0, 127, 255, 0.1);
        box-shadow: 2px 0 10px rgba(0, 0, 0, 0.05);
        border-radius: 0 15px 0 0;
        position: relative;
        z-index: 20;
    }

    .sidebar .admin-profile {
        display: flex;
        flex-direction: column;
        align-items: center;
        margin-bottom: 30px;
        padding-bottom: 20px;
        border-bottom: 1px solid rgba(0, 127, 255, 0.1);
    }

    .sidebar .admin-profile img {
        width: 80px;
        height: 80px;
        border-radius: 50%;
        object-fit: cover;
        border: 3px solid #007fff;
        margin-bottom: 12px;
        box-shadow: 0 4px 12px rgba(0, 127, 255, 0.2);
    }

    .sidebar .admin-profile .admin-name {
        color: #007fff;
        font-size: 18px;
        font-weight: 600;
        margin-bottom: 4px;
        text-align: center;
    }

    .sidebar .admin-profile .admin-role {
        color: #007fff;
        font-size: 14px;
        font-weight: 400;
        opacity: 0.8;
        text-align: center;
    }

    .sidebar a {
        color: #007fff;
        text-decoration: none;
        margin: 8px 0;
        font-size: 16px;
        font-weight: 500;
        display: block;
        padding: 12px 16px;
        border-radius: 12px;
        cursor: pointer;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        position: relative;
        overflow: hidden;
        text-align: center;
    }

    .sidebar a:hover {
        background-color: #ffffff;
        color: #007fff;
        transform: translateX(4px);
        box-shadow: 0 4px 12px rgba(0, 127, 255, 0.15);
    }

    .sidebar a.active {
        background-color: #ffffff;
        color: #007fff;
        box-shadow: 0 2px 8px rgba(0, 127, 255, 0.2);
        font-weight: 600;
    }

    .main-content {
        flex: 1;
        padding: 30px;
        padding-top: 250px; /* Increased padding to prevent content from being covered by header */
        overflow-y: auto;
        background: rgba(248, 249, 250, 0.1);
        backdrop-filter: blur(10px);
        position: relative;
        z-index: 10;
        transition: padding-top 0.3s ease;
    }

    .main-content.full-view {
        padding-top: 30px;
    }

    #home {
        margin-top: 0; /* Removed negative margin */
    }

    #home h2 {
        margin-top: 50px;
        margin-bottom: 15px;
    }

    #home table {
        margin-top: 20px;
    }


    #home table {
        margin-top: 20px;
    }

    .dashboard-container {
        position: fixed;
        top: 0;
        left: 0;
        width: 100vw;
        background-color: #007fff;
        border-radius: 0 0 16px 16px;
        box-shadow: 0 8px 32px rgba(0, 127, 255, 0.2);
        display: flex;
        justify-content: center;
        z-index: 15;
        height: auto;
        padding: 20px 0;
        user-select: none;
        box-sizing: border-box;
        transition: transform 0.3s ease;
    }

    .dashboard-container.hidden {
        transform: translateY(-100%);
    }

    .dashboard-inner {
        width: 100%;
        max-width: 1100px;
        padding: 0 30px;
        display: flex;
        flex-direction: column;
    }

    .main-title {
        display: flex;
        flex-direction: row; /* Arrange items in a row */
        align-items: center; /* Vertically center logo + text */
        justify-content: center; /* Center the whole group horizontally */
        gap: 10px; /* Space between logo, text, and logo */
        margin-bottom: 20px;
        margin-top: 0 !important;
    }

    .main-title img {
        height: 50px;
        width: 50px;
    }


    .main-title h2 {
        margin: 0;
        font-size: 36px;
        font-weight: 700;
        color: #ffffff;
        text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }

    .dashboard-overview {
        color: #ffffff;
        font-size: 24px;
        font-weight: 600;
        margin-bottom: 10px;
        text-align: left;
        padding-left: 85px;
        max-width: 400px;
    }
    
    
    .dashboard-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 5px;
        width: 100%;
    }

    .dashboard-header .btn-primary {
        text-decoration: none;
        color: white;
        background-color: #007bff;
        border-radius: 5px;
        font-size: 20px;
        font-weight: bold;
    }


    .card-container-wrapper {
        display: flex;
        justify-content: flex-start;
        width: 100%;
        margin-top: 10px;
        padding-left: 85px;
    }

    .dashboard-cards {
        display: flex;
        gap: 20px;
        flex-wrap: nowrap;
        flex-direction: row;
        width: 100%;
    }

    .card {
        flex: 0 0 auto;
        min-width: 350px;
        max-width: 350px;
        background: rgba(255, 255, 255, 0.15);
        backdrop-filter: blur(15px);
        -webkit-backdrop-filter: blur(15px);
        border: 1px solid rgba(255, 255, 255, 0.2);
        border-radius: 16px;
        padding: 20px 20px 20px 30px;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        transition: all 0.3s ease;
        cursor: pointer;
        color: white;
        user-select: none;
        text-align: center;
        min-height: 120px;
    }

    .card:hover {
        transform: translateY(-5px);
        box-shadow: 0 12px 40px rgba(0, 0, 0, 0.15);
        background: rgba(255, 255, 255, 0.2);
    }

    .card h3 {
        margin: 0;
        font-size: 16px;
        color: rgba(255, 255, 255, 0.9);
        font-weight: 600;
        margin-bottom: 12px;
    }

    .card p {
        font-size: 24px;
        font-weight: bold;
        margin: 0;
        text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }

    h2 {
        color: #007FFF;
        margin-bottom: 20px;
        font-size: 28px;
        font-weight: 600;
    }

    table {
        width: 100%;
        background: white;
        border-collapse: collapse;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        border-radius: 12px;
        overflow: hidden;
        margin-bottom: 30px;
    }

    th, td {
        padding: 16px 20px;
        border-bottom: 1px solid rgba(0, 127, 255, 0.1);
        text-align: left;
    }

    th {
        background: #007fff;
        color: white;
        font-weight: 600;
        font-size: 14px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    tr:hover {
        background-color: rgba(0, 127, 255, 0.05);
        transition: background-color 0.3s ease;
    }

    .section {
        display: none;
        opacity: 0;
        transform: translateY(20px);
        transition: opacity 0.3s ease, transform 0.3s ease;
    }

    .section.active {
        display: block;
        opacity: 1;
        transform: translateY(0);
    }

    @media (max-width: 768px) {
        body {
            flex-direction: column;
        }

        .sidebar {
            width: 100%;
            flex-direction: row;
            overflow-x: auto;
            padding-top: 15px;
            height: auto;
            border-radius: 0 0 15px 15px;
            box-shadow: none;
            margin-top: 0;
            position: relative;
            z-index: 30;
        }

        .sidebar a {
            margin: 5px;
            font-size: 14px;
            white-space: nowrap;
            flex-shrink: 0;
        }

        .main-content {
            padding: 15px;
            padding-top: 100px;
        }

        .dashboard-container {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            border-radius: 0 0 0 0;
            padding: 15px 15px;
            box-shadow: none;
            z-index: 15;
            user-select: none;
            justify-content: center;
        }

        .dashboard-inner {
            max-width: 100%;
            padding: 0 15px;
        }

        .dashboard-overview {
            padding-left: 0;
            max-width: none;
        }

        .card-container-wrapper {
            justify-content: center;
            padding-right: 0;
            margin-top: 15px;
        }

        .dashboard-cards {
            max-width: 100%;
        }
    }

    /* Form styles */
    form {
        background: white;
        padding: 25px;
        border-radius: 12px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
    }

    input[type="text"],
    input[type="email"],
    textarea {
        width: 100%;
        padding: 12px 15px;
        margin: 8px 0;
        border: 1px solid rgba(0, 127, 255, 0.2);
        border-radius: 8px;
        font-size: 14px;
        transition: all 0.3s ease;
    }

    input[type="text"]:focus,
    input[type="email"]:focus,
    textarea:focus {
        border-color: #007fff;
        box-shadow: 0 0 0 3px rgba(0, 127, 255, 0.1);
        outline: none;
    }

    /* Checkbox styles */
    input[type="checkbox"] {
        width: 18px;
        height: 18px;
        margin-right: 8px;
        accent-color: #007fff;
    }

    /* Button styles */
    button {
        background: #007fff;
        color: white;
        border: none;
        padding: 12px 24px;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        margin-top: 15px;
    }

    button:hover {
        background: #0066cc;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0, 127, 255, 0.2);
    }

    button:disabled {
        background: #ccc;
        cursor: not-allowed;
        transform: none;
        box-shadow: none;
    }

    /* Modal styles */
    .modal {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.6);
        align-items: center;
        justify-content: center;
        z-index: 999;
    }

    .modal-content {
        background: white;
        padding: 30px;
        border-radius: 12px;
        max-width: 500px;
        width: 90%;
        position: relative;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
    }

    .modal-close {
        position: absolute;
        top: 15px;
        right: 20px;
        font-size: 24px;
        cursor: pointer;
        color: #666;
        transition: color 0.3s ease;
    }

    .modal-close:hover {
        color: #007fff;
    }

    .modal-profile {
        text-align: center;
        margin-bottom: 25px;
    }

    .modal-profile img {
        width: 120px;
        height: 120px;
        border-radius: 50%;
        object-fit: cover;
        border: 3px solid #007fff;
        margin-bottom: 15px;
        box-shadow: 0 4px 12px rgba(0, 127, 255, 0.2);
    }

    .modal-profile h3 {
        color: #007fff;
        margin: 0;
        font-size: 20px;
        font-weight: 600;
    }

    .modal-info {
        margin-top: 20px;
    }

    .modal-info p {
        margin: 10px 0;
        color: #333;
        font-size: 14px;
    }

    .modal-info strong {
        color: #007fff;
        font-weight: 600;
        margin-right: 8px;
    }

    /* Search input styles */
    .search-container {
        margin-bottom: 20px;
    }

    .search-input {
        width: 100%;
        max-width: 300px;
        padding: 12px 20px;
        border: 1px solid rgba(0, 127, 255, 0.2);
        border-radius: 8px;
        font-size: 14px;
        transition: all 0.3s ease;
    }

    .search-input:focus {
        border-color: #007fff;
        box-shadow: 0 0 0 3px rgba(0, 127, 255, 0.1);
        outline: none;
    }

    .status-message {
        padding: 10px 15px;
        border-radius: 5px;
        margin-bottom: 10px;
        font-weight: bold;
        transition: opacity 0.5s ease;
    }

    .status-message.success {
        background-color: #d4edda;
        color: #155724;
    }

    .status-message.error {
        background-color: #f8d7da;
        color: #721c24;
    }
</style>

<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
    <div class="admin-profile">
        <img src="resources/NorsuLogo.png" alt="Admin Profile Picture" />
        <div class="admin-name">NORSU</div>
        <div class="admin-role">Admin</div>
    </div>
    <a class="tab-link active" onclick="showSection('home')">Home</a>
    <a class="tab-link" onclick="showSection('pending')">Pending Applicants</a>
    <a class="tab-link" onclick="showSection('registered-drivers')">Registered Drivers</a>
    <a class="tab-link" onclick="showSection('registered-students')">Registered Students</a>
    <a class="tab-link" onclick="showSection('announcement')">Announcement</a>
    <a href="logout.jsp">Log Out</a>
</div>

<!-- Dashboard container: full width header background, with centered content inside -->
<div class="dashboard-container" role="banner" aria-label="Dashboard Header">
    <div class="dashboard-inner">
        <div class="main-title">
            <img src="resources/EasyRide.png" alt="Logo" />
            <h2>EasyRide NORSU</h2>
            <img src="resources/EasyRideDriver.png" alt="Logo" />
        </div>
        <div class="dashboard-header">
            <h3 class="dashboard-overview">Dashboard Overview</h3>
            <a href="AdminDownloadFullReportServlet" class="btn btn-primary" style="margin-bottom: -20px; margin-right: -135px; ">
                <i class="fa-solid fa-download"></i> Download Report
            </a>
        </div>

        <div class="card-container-wrapper">
            <div class="dashboard-cards" role="list">
                <div class="card" onclick="showSection('pending')" role="button" tabindex="0" aria-pressed="false" role="listitem">
                    <h3>Pending Applicants</h3>
                    <p><%
                        int pendingCount = 0;
                        int driverCount = 0;
                        int studentCount = 0;
                        try {
                            Class.forName("com.mysql.jdbc.Driver");
                            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EasyRide", "root", "");
                            Statement stmt = con.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM recentpendingdrivers");
                            if (rs.next()) pendingCount = rs.getInt(1);
                            rs = stmt.executeQuery("SELECT COUNT(*) FROM registereddrivers");
                            if (rs.next()) driverCount = rs.getInt(1);
                            rs = stmt.executeQuery("SELECT COUNT(*) FROM registeredstudents");
                            if (rs.next()) studentCount = rs.getInt(1);
                            rs.close();
                            stmt.close();
                            con.close();
                        } catch (Exception e) {
                            out.println("0");
                        }
                    %><%= pendingCount %></p>
                </div>
                <div class="card" onclick="showSection('registered-drivers')" role="button" tabindex="0" aria-pressed="false" role="listitem">
                    <h3>Registered Drivers</h3>
                    <p><%= driverCount %></p>
                </div>
                <div class="card" onclick="showSection('registered-students')" role="button" tabindex="0" aria-pressed="false" role="listitem">
                    <h3>Registered Students</h3>
                    <p><%= studentCount %></p>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Main Content -->
<div class="main-content">
    <div id="home" class="section active">
        <h2 style="padding-top: 15px;" >Recent Pending Applicants</h2>
        <table>
            <tr>
                <th>Full Name</th>
                <th>Email</th>
                <th>Date Applied</th>
            </tr>
            <%
                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EasyRide", "root", "");
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT FirstName, LastName, Email, RegistrationDate FROM recentpendingdrivers ORDER BY RegistrationDate DESC LIMIT 5");
                    while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getString("FirstName") %> <%= rs.getString("LastName") %></td>
                <td><%= rs.getString("Email") %></td>
                <td><%= rs.getString("RegistrationDate") %></td>
            </tr>
            <%
                    }
                    rs.close();
                    stmt.close();
                    con.close();
                } catch (Exception e) {
                    out.println("<tr><td colspan='3'>Error loading applicants.</td></tr>");
                }
            %>
        </table>
    </div>

    <div id="pending" class="section">
        <h2>Pending Applicants</h2>
        <form id="applicantForm" method="post" action="AdminSendRegistrationLinkServlet">
            <table>
                <thead>
                    <tr>
                        <th><input type="checkbox" id="selectAll" onclick="toggleAll(this)"></th>
                        <th>Name</th>
                        <th>Mobile</th>
                        <th>Email</th>
                        <th>City</th>
                        <th>Service</th>
                        <th>Base Office</th>
                        <th>Date</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    try {
                        Class.forName("com.mysql.jdbc.Driver");
                        Connection conn = DriverManager.getConnection("jdbc:mysql:///EasyRide", "root", "");
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT * FROM pendingdrivers ORDER BY RegistrationDate DESC");

                        boolean hasApplicants = false;

                        while (rs.next()) {
                            hasApplicants = true;
                            int id = rs.getInt("Id");
                %>
                <tr>
                    <td><input type="checkbox" name="selectedIds" value="<%= id %>" onchange="toggleSendButton()"></td>
                    <td><%= rs.getString("FirstName") %> <%= rs.getString("LastName") %></td>
                    <td><%= rs.getString("MobileNumber") %></td>
                    <td><%= rs.getString("Email") %></td>
                    <td><%= rs.getString("City") %></td>
                    <td><%= rs.getString("Service") %></td>
                    <td><%= rs.getString("BaseOffice") %></td>
                    <td><%= rs.getTimestamp("RegistrationDate") %></td>
                </tr>
                <%
                        }

                        if (!hasApplicants) {
                %>
                <tr><td colspan="8" style="text-align:center; font-style:italic;">No pending applicants.</td></tr>
                <%
                        }
                        rs.close();
                        stmt.close();
                        conn.close();
                    } catch (Exception e) {
                        out.println("<tr><td colspan='8'>Error loading data.</td></tr>");
                        e.printStackTrace();
                    }
                %>
                </tbody>
            </table>

            <div style="margin-top: 20px;">
                <button type="submit" id="sendLinkBtn" disabled>Send Registration Link</button>
            </div>
        </form>
    </div>

    <div id="registered-drivers" class="section">
        <h2>Registered Drivers</h2>
        <div class="search-container">
            <input type="text" id="driverSearch" class="search-input" placeholder="Search drivers...">
        </div>
        <table>
            <thead>
                <tr>
                    <th>Driver ID</th>
                    <th>Name</th>
                    <th>Mobile</th>
                    <th>Email</th>
                    <th>City</th>
                    <th>Service</th>
                    <th>Base Office</th>
                    <th>Ratings</th>
                </tr>
            </thead>
            <tbody>
            <%
                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    Connection conn = DriverManager.getConnection("jdbc:mysql:///EasyRide", "root", "");
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT * FROM registereddrivers ORDER BY FullName ASC");

                    while (rs.next()) {
                        String driverUniqueID = rs.getString("DriverUniqueID");
                        String fullName = rs.getString("FullName");
                        String mobile = rs.getString("MobileNumber");
                        String email = rs.getString("Email");
                        String city = rs.getString("City");
                        String service = rs.getString("Service");
                        String baseOffice = rs.getString("BaseOffice");
                        String username = rs.getString("Username");
                        String profilePicture = rs.getString("ProfilePicture");
                        Double ratings = rs.getDouble("Ratings");
                        String registrationDate = rs.getTimestamp("RegistrationDate").toString();
            %>
            <tr onclick="showDriverModal('<%=driverUniqueID%>', '<%=fullName%>', '<%=mobile%>', '<%=email%>', '<%=city%>', '<%=service%>', '<%=baseOffice%>', '<%=username%>', '<%=profilePicture%>', '<%=ratings%>', '<%=registrationDate%>')" style="cursor:pointer;">
                <td><%= driverUniqueID %></td>
                <td><%= fullName %></td>
                <td><%= mobile %></td>
                <td><%= email %></td>
                <td><%= city %></td>
                <td><%= service %></td>
                <td><%= baseOffice %></td>
                <td><%=ratings%></td>
            </tr>
            <%
                    }
                    rs.close();
                    stmt.close();
                    conn.close();
                } catch (Exception e) {
                    out.println("<tr><td colspan='7'>Error loading registered drivers.</td></tr>");
                    e.printStackTrace();
                }
            %>
            </tbody>
        </table>

        <!-- Updated Driver Modal -->
        <div id="driverModal" class="modal">
            <div class="modal-content">
                <span class="modal-close" onclick="closeDriverModal()">&times;</span>
                <div class="modal-profile">
                    <img id="driverImage" src="" alt="Profile Picture">
                    <h3 id="driverName"></h3>
                </div>
                <div class="modal-info">
                    <p><strong>Driver ID:</strong> <span id="driverID"></span></p>
                    <p><strong>Email:</strong> <span id="driverEmail"></span></p>
                    <p><strong>Mobile:</strong> <span id="driverMobile"></span></p>
                    <p><strong>City:</strong> <span id="driverCity"></span></p>
                    <p><strong>Service:</strong> <span id="driverService"></span></p>
                    <p><strong>Base Office:</strong> <span id="driverBaseOffice"></span></p>
                    <p><strong>Ratings:</strong> <span id="driverRatings"></span></p>
                    <p><strong>Username:</strong> <span id="driverUsername"></span></p>
                    <p><strong>Registration Date:</strong> <span id="driverRegistrationDate"></span></p>
                </div>
            </div>
        </div>
    </div>

    <div id="registered-students" class="section">
        <h2>Registered Students</h2>
        <div class="search-container">
            <input type="text" id="studentSearch" class="search-input" placeholder="Search by ID or Name...">
        </div>
        <table>
            <thead>
                <tr>
                    <th>Student ID</th>
                    <th>Name</th>
                </tr>
            </thead>
            <tbody>
            <%
                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    Connection conn = DriverManager.getConnection("jdbc:mysql:///EasyRide", "root", "");
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT * FROM registeredstudents ORDER BY FullName ASC");

                    while (rs.next()) {
                        String id = rs.getString("StudentID");
                        String name = rs.getString("FullName");
                        String email = rs.getString("Email");
                        String phone = rs.getString("PhoneNumber");
                        String imagePath = rs.getString("StudentsImagePath");
            %>
            <tr onclick="showStudentModal('<%=id%>', '<%=name%>', '<%=email%>', '<%=phone%>', '<%=imagePath%>')">
                <td><%= id %></td>
                <td><%= name %></td>
            </tr>
            <%
                    }
                    rs.close();
                    stmt.close();
                    conn.close();
                } catch (Exception e) {
                    out.println("<tr><td colspan='2'>Error loading students.</td></tr>");
                    e.printStackTrace();
                }
            %>
            </tbody>
        </table>

        <!-- Updated Student Modal -->
        <div id="studentModal" class="modal">
            <div class="modal-content">
                <span class="modal-close" onclick="closeModal()">&times;</span>
                <div class="modal-profile">
                    <img id="studentImage" src="" alt="Profile Picture">
                    <h3 id="studentName"></h3>
                </div>
                <div class="modal-info">
                    <p><strong>Student ID:</strong> <span id="studentID"></span></p>
                    <p><strong>Email:</strong> <span id="studentEmail"></span></p>
                    <p><strong>Phone:</strong> <span id="studentPhone"></span></p>
                </div>
            </div>
        </div>
    </div>

    <div id="announcement" class="section">
        <%
            String announcementStatus = request.getParameter("announcement");
            if ("success".equals(announcementStatus)) {
        %>
            <div id="announcementStatus" class="status-message success">
                ✅ Announcement sent successfully!
            </div>
        <%
            } else if ("error".equals(announcementStatus)) {
        %>
            <div id="announcementStatus" class="status-message error">
                ❌ Failed to send announcement. Please try again.
            </div>
        <%
            }
        %>

        
        <h2>Send Announcement</h2>
        <form action="AdminSendAnnouncementServlet" method="post">
            <div>
                <label for="subject">Subject:</label>
                <input type="text" id="subject" name="subject" required>
            </div>
            <div>
                <label for="message">Message:</label>
                <textarea id="message" name="message" rows="5" required></textarea>
            </div>
            <div>
                <input type="checkbox" id="sendToDrivers" name="sendToDrivers" value="true">
                <label for="sendToDrivers">Send to Drivers</label><br>

                <input type="checkbox" id="sendToStudents" name="sendToStudents" value="true">
                <label for="sendToStudents">Send to Students</label>
            </div>
            <div>
                <button type="submit">Send Announcement</button>
            </div>
        </form>
    </div>
</div>

<script>
    function showSection(id) {
        const sections = document.querySelectorAll('.section');
        sections.forEach(sec => sec.classList.remove('active'));

        const target = document.getElementById(id);
        if (target) {
            target.classList.add('active');
        }

        const links = document.querySelectorAll('.tab-link');
        links.forEach(link => link.classList.remove('active'));

        const clickedLink = Array.from(links).find(link => link.textContent.trim().toLowerCase().includes(id.replace("-", " ")));
        if (clickedLink) {
            clickedLink.classList.add('active');
        }

        // Handle dashboard visibility and content positioning
        const dashboardContainer = document.querySelector('.dashboard-container');
        const mainContent = document.querySelector('.main-content');
        
        if (id === 'home') {
            dashboardContainer.classList.remove('hidden');
            mainContent.classList.remove('full-view');
        } else {
            dashboardContainer.classList.add('hidden');
            mainContent.classList.add('full-view');
        }
    }
    
    function showStudentModal(id, name, email, phone, imagePath) {
        document.getElementById("studentID").innerText = id;
        document.getElementById("studentName").innerText = name;
        document.getElementById("studentEmail").innerText = email;
        document.getElementById("studentPhone").innerText = phone;
        document.getElementById("studentImage").src = imagePath;

        document.getElementById("studentModal").style.display = "flex";
    }

    function closeModal() {
        document.getElementById("studentModal").style.display = "none";
    }
    
    function toggleAll(source) {
        const checkboxes = document.getElementsByName('selectedIds');
        for (let i = 0; i < checkboxes.length; i++) {
            checkboxes[i].checked = source.checked;
        }
        toggleSendButton();
    }

    function toggleSendButton() {
        const checkboxes = document.querySelectorAll('input[name="selectedIds"]:checked');
        document.getElementById('sendLinkBtn').disabled = checkboxes.length === 0;
    }
    
    // Live search for Registered Students
    document.getElementById('studentSearch').addEventListener('input', function () {
        const filter = this.value.toLowerCase();
        const rows = document.querySelectorAll('#registered-students table tbody tr');

        rows.forEach(row => {
            const id = row.cells[0].textContent.toLowerCase();
            const name = row.cells[1].textContent.toLowerCase();
            const matches = id.includes(filter) || name.includes(filter);
            row.style.display = matches ? '' : 'none';
        });
    });
    
    function showDriverModal(driverID, fullName, mobile, email, city, service, baseOffice, username, profilePicture, ratings, registrationDate) {
        document.getElementById("driverID").innerText = driverID;
        document.getElementById("driverName").innerText = fullName;
        document.getElementById("driverEmail").innerText = email;
        document.getElementById("driverMobile").innerText = mobile;
        document.getElementById("driverCity").innerText = city;
        document.getElementById("driverService").innerText = service;
        document.getElementById("driverBaseOffice").innerText = baseOffice;
        document.getElementById("driverRatings").innerText = ratings;
        document.getElementById("driverUsername").innerText = username;
        document.getElementById("driverRegistrationDate").innerText = registrationDate;

        // Show profile picture or fallback image
        const img = document.getElementById("driverImage");
        if (profilePicture && profilePicture.trim() !== "") {
            img.src = profilePicture;
        } else {
            img.src = "images/Default.png"; // your default profile picture path
        }

        document.getElementById("driverModal").style.display = "flex";
    }

    function closeDriverModal() {
        document.getElementById("driverModal").style.display = "none";
    }
    
    window.onload = function() {
        // Handle hash scroll and showSection
        const hash = window.location.hash.substring(1);
        if (hash) {
            showSection(hash);

            const target = document.getElementById(hash);
            if (target) {
                setTimeout(() => {
                    target.scrollIntoView({ behavior: 'smooth' });
                }, 100);
            }
        }

        // Auto-hide the announcementStatus after 3 seconds
        const statusDiv = document.getElementById('announcementStatus');
        if (statusDiv) {
            setTimeout(() => {
                statusDiv.style.opacity = '0';
                setTimeout(() => {
                    statusDiv.style.display = 'none';
                }, 500); // give time for opacity transition
            }, 3000);
        }
    }
</script>

</body>
</html>