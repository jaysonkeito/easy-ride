<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%
    String fullName = (String) session.getAttribute("fullName");
    String studentId = (String) session.getAttribute("studentId");

    if (fullName == null) {
        response.sendRedirect("SignIn.jsp");
        return;
    }

    String email = "";
    String phoneNumber = "";
    String imagePath = "";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        conn = DriverManager.getConnection("jdbc:mysql:///EasyRide", "root", "");
        String query = "SELECT Email, PhoneNumber, StudentsImagePath FROM registeredstudents WHERE StudentID = ?";
        stmt = conn.prepareStatement(query);
        stmt.setString(1, studentId);
        rs = stmt.executeQuery();

        if (rs.next()) {
            email = rs.getString("Email");
            phoneNumber = rs.getString("PhoneNumber");
            imagePath = rs.getString("StudentsImagePath");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (SQLException ignored) {}
        try { if (stmt != null) stmt.close(); } catch (SQLException ignored) {}
        try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Account - EasyRide</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: linear-gradient(to bottom, rgba(19, 84, 122, 0.5), rgba(128, 208, 199, 0.5)),
                        url('resources/Campus.jpg') no-repeat center center fixed;
            background-size: cover;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            min-height: 100vh;
            padding: 0 10px;
            box-sizing: border-box;
        }

        .panel {
            background-color: white;
            width: 100%;
            max-width: 480px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.25);
            display: flex;
            flex-direction: column;
            overflow-y: auto;
            min-height: 91vh;
        }

        .panel-header {
            position: sticky;
            top: 0;
            z-index: 10;
            /*background: linear-gradient(to right, #0072BB, #80D0C7);*/
            background-color: #0072BB;
            padding: 15px 20px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-direction: row;
            font-size: 18px;
            font-weight: bold;
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .account-info {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .account-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #ddd;
            padding: 10px 15px;
        }

        .account-label {
            font-weight: 600;
            color: #333;
            flex: 1;
        }

        .account-value {
            flex: 2;
            color: #555;
            word-break: break-word;
            text-align: right;
        }

        .edit-button {
            cursor: pointer;
            color: #13547a;
            font-weight: 600;
            font-size: 14px;
            text-decoration: underline;
        }

        .profile-pic {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 20px;
            border: 2px solid #13547a;
        }

        .section-title {
            font-weight: 700;
            font-size: 16px;
            margin-top: 30px;
            margin-bottom: 10px;
            color: #13547a;
            border-bottom: 1px solid #13547a;
            padding: 0px 15px 3px 15px;
        }

        .support-logout {
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin-top: 15px;
            padding: 0px 15px 0px 15px;
        }

        .support-logout button {
            background: #13547a;
            color: white;
            border: none;
            padding: 12px;
            font-weight: 700;
            border-radius: 6px;
            cursor: pointer;
            transition: background 0.3s;
            width: 100%;
        }

        .support-logout button:hover {
            background: #0f3f57;
        }

        /* Bottom Navbar */
        .navbar {
            width: 100%;
            max-width: 480px;
            background: rgba(0, 0, 0, 0.3);
            backdrop-filter: blur(12px);
            display: flex;
            justify-content: space-around;
            position: fixed;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            border-top-left-radius: 12px;
            border-top-right-radius: 12px;
            box-shadow: 0 -2px 8px rgba(0, 0, 0, 0.25);
            padding: 10px 0;
        }

        .nav-item {
            color: white;
            text-decoration: none;
            font-size: 12px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .nav-item img {
            width: 24px;
            filter: brightness(0) invert(1);
            margin-bottom: 2px;
        }

        .nav-item.active span {
            font-weight: bold;
            color: #fff;
        }

        .nav-item.active img {
            filter: none;
        }

        @media (max-width: 480px) {
            .panel-header {
                font-size: 16px;
                padding: 15px 15px;
            }
            
            .panel {
                min-height: 83vh;
                border-radius: 10px;
            }
            
            .profile-pic {
                width: 70px;
                height: 70px;
            }

            .account-item {
                flex-direction: column;
                align-items: flex-start;
                padding: 5px 15px;
            }

            .account-label, .account-value {
                width: 100%;
                font-size: 13px;
                text-align: left;
            }

            .edit-button {
                padding-top: 8px;
                display: inline-block;
            }
        }
    </style>
</head>
<body>

<div class="panel">
    <div class="panel-header">
        <div class="header-left">
            <span>Account</span>
        </div>
    </div>

    <div style="text-align: center; margin-top: 10px;">
        <img class="profile-pic" src="<%= (imagePath != null && !imagePath.trim().isEmpty()) ? imagePath : "images/students/Default.png" %>" alt="Profile Picture" />
    </div>

    <div class="account-info">
        <div class="account-item">
            <div class="account-label">Full Name</div>
            <div class="account-value"><%= fullName %></div>
        </div>
        <div class="account-item">
            <div class="account-label">Student ID</div>
            <div class="account-value"><%= studentId %></div>
        </div>
        <div class="account-item">
            <div class="account-label">Email</div>
            <div class="account-value"><%= email %></div>
        </div>
        <div class="account-item">
            <div class="account-label">Phone Number</div>
            <div class="account-value"><%= phoneNumber %></div>
        </div>
        <div class="account-item">
            <div class="account-label">Action</div>
            <div class="account-value">
                <a href="EditAccount.jsp" class="edit-button"><i class="fas fa-edit" style="margin-right: 6px;"></i>Edit</a>
            </div>
        </div>
    </div>

    <div class="section-title">Support & Logout</div>
    <div class="support-logout">
        <button onclick="location.href='Support.jsp'">Support</button>
        <button onclick="location.href='LogoutServlet'">Log Out</button>
    </div>
</div>

<div class="navbar">
    <a href="Home.jsp" class="nav-item">
        <img src="resources/Home.png" alt="Home" />
        <span>Home</span>
    </a>
    <a href="RideStatus.jsp" class="nav-item">
        <img src="resources/RideStatus.png" alt="Ride Status" />
        <span>Ride Status</span>
    </a>
    <a href="Inbox.jsp" class="nav-item">
        <img src="resources/Inbox.png" alt="Inbox" />
        <span>Inbox</span>
    </a>
    <a href="Account.jsp" class="nav-item active">
        <img src="resources/Account.png" alt="Account" />
        <span>Account</span>
    </a>
</div>

</body>
</html>
