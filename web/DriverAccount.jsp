<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%
    String driverFullName = (String) session.getAttribute("driverFullName");
    String driverUsername = (String) session.getAttribute("driverUsername");
    if (driverUsername == null) {
        response.sendRedirect("DriverSignIn.jsp");
        return;
    }

    String fullName = "", email = "", mobileNumber = "", city = "", service = "", baseOffice = "";
    String profilePicture = "images/Default.png", driverUniqueID = "", ratings = "", registrationDate = "";


    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        conn = DriverManager.getConnection("jdbc:mysql:///EasyRide", "root", "");
        String query = "SELECT * FROM registereddrivers WHERE Username = ?";
        stmt = conn.prepareStatement(query);
        stmt.setString(1, driverUsername);
        rs = stmt.executeQuery();

        if (rs.next()) {
            driverUniqueID = rs.getString("DriverUniqueID");
            fullName = rs.getString("FullName");
            email = rs.getString("Email");
            mobileNumber = rs.getString("MobileNumber");
            city = rs.getString("City");
            service = rs.getString("Service");
            baseOffice = rs.getString("BaseOffice");
            profilePicture = rs.getString("ProfilePicture");
            if (profilePicture != null && !profilePicture.trim().equals("")) {
                profilePicture = profilePicture;
            }
            ratings = rs.getString("Ratings");
            registrationDate = rs.getString("RegistrationDate");

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
    <title>Driver Account - EasyRide</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to bottom, rgba(19, 84, 122, 0.5), rgba(128, 208, 199, 0.5)),
                        url('resources/Campus.jpg') no-repeat center center fixed;
            background-size: cover;
            margin: 0;
            padding-bottom: 70px;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
        }

        .panel {
            background-color: white;
            width: 100%;
            max-width: 600px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.25);
            display: flex;
            flex-direction: column;
            overflow-y: auto;
            min-height: 91vh;
        }

        header {
            width: 100%;
            /*background-color: rgba(0, 0, 0, 0.4);*/
            background-color: #0072BB;
            padding: 15px 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            box-sizing: border-box;
        }

        header img {
            height: 50px;
        }

        .header-text-desktop {
            display: block;
            font-size: 20px;
            font-weight: bold;
            color: white;
        }

        .header-text-mobile {
            display: none;
        }

        h2 {
            margin: 20px;
            font-size: 20px;
            color: #fff;
            text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.6);
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
            padding: 0px 15px;
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
        }

        .support-logout button:hover {
            background: #0f3f57;
        }

        .navbar {
            width: 100%;
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
        @media (max-width: 600px) {
            
            .profile-pic {
                width: 80px;
                height: 80px;
            }
            
            
            .header-text-desktop {
                display: none;
            }

            .header-text-mobile {
                display: flex;
                align-items: center;
                flex-direction: column;
                color: #fff;
                text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.7);
                font-weight: bold;
                text-align: center;
            }

            .header-text-mobile .title {
                font-size: 22px;
            }

            .header-text-mobile .subtitle {
                font-size: 16px;
                font-weight: normal;
                color: #ddd;
            }

            header img {
                height: 60px;
            }

            h2 {
                font-size: 18px;
                margin: 15px;
            }
        }

    </style>
</head>
<body>
<!-- HEADER -->
<header>
    <img src="resources/EasyRideDriver.png" alt="Logo" />
    <div class="header-text-desktop">EasyRide NORSU Driver</div>
    <div class="header-text-mobile">
        <div class="title">EASYRIDE</div>
        <div class="subtitle">NORSU Driver</div>
    </div>
    <img src="resources/NorsuLogo.png" alt="Logo" />
</header>
<h2>Account</h2>
    <div class="panel">
        <div style="text-align: center; margin-top: 10px;">
            <img class="profile-pic" src="<%= (profilePicture != null && !profilePicture.trim().isEmpty()) ? profilePicture : "images/drivers/Default.png" %>" alt="Profile Picture" />
        </div>

        <div class="account-info">
            <div class="account-item">
                <div class="account-label">Full Name</div>
                <div class="account-value"><%= fullName %></div>
            </div>
            <div class="account-item">
                <div class="account-label">Driver ID</div>
                <div class="account-value"><%= driverUniqueID %></div>
            </div>
            <div class="account-item">
                <div class="account-label">Username</div>
                <div class="account-value"><%= driverUsername %></div>
            </div>
            <div class="account-item">
                <div class="account-label">Email</div>
                <div class="account-value"><%= email %></div>
            </div>
            <div class="account-item">
                <div class="account-label">Phone Number</div>
                <div class="account-value"><%= mobileNumber %></div>
            </div>
            <div class="account-item">
                <div class="account-label">City</div>
                <div class="account-value"><%= city %></div>
            </div>
            <div class="account-item">
                <div class="account-label">Service</div>
                <div class="account-value"><%= service %></div>
            </div>
            <div class="account-item">
                <div class="account-label">Base Office</div>
                <div class="account-value"><%= baseOffice %></div>
            </div>
            <div class="account-item">
                <div class="account-label">Ratings</div>
                <div class="account-value"><%= ratings %></div>
            </div>
            <div class="account-item">
                <div class="account-label">Registration Date</div>
                <div class="account-value"><%= registrationDate %></div>
            </div>
            <div class="account-item">
                <div class="account-label">Action</div>
                <div class="account-value">
                    <a href="DriverEditAccount.jsp" class="edit-button"><i class="fas fa-edit" style="margin-right: 6px;"></i>Edit</a>
                </div>
            </div>
        </div>


        <div class="section-title">Support & Logout</div>
        <div class="support-logout">
            <button onclick="location.href='DriverSupport.jsp'">Support</button>
            <button onclick="location.href='DriverLogOutServlet'">Log Out</button>
        </div>
    </div>

<div class="navbar">
    <a href="DriverDashboard.jsp" class="nav-item">
        <img src="resources/Home.png" alt="Home">
        <span>Home</span>
    </a>
    <a href="DriverHistoryRides.jsp" class="nav-item">
        <img src="resources/RideStatus.png" alt="Ride History">
        <span>Ride History</span>
    </a>
    <a href="DriverInbox.jsp" class="nav-item ">
        <img src="resources/Inbox.png" alt="Inbox">
        <span>Inbox</span>
    </a>
    <a href="DriverAccount.jsp" class="nav-item active">
        <img src="resources/Account.png" alt="Account">
        <span>Account</span>
    </a>
</div>

</body>
</html>
