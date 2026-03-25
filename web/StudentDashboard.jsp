<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String fullName = (String) session.getAttribute("fullName");
    String studentId = (String) session.getAttribute("studentId");

    if (fullName == null && studentId == null) {
        response.sendRedirect("StudentSignIn.jsp");
        return;
    }

    session.removeAttribute("PickUpLocation");
    session.removeAttribute("DropOffLocation");

    boolean hasActiveRide = false;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql:///EasyRide", "root", "");
        PreparedStatement ps = con.prepareStatement(
            "SELECT * FROM rides WHERE studentId = ? AND (status = 'Pending' OR status = 'Ongoing' OR status = 'Accepted')"
        );
        ps.setString(1, studentId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            hasActiveRide = true;
        }
        rs.close();
        ps.close();
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Home - EasyRide</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(to bottom, rgba(19, 84, 122, 0.4), rgba(128, 208, 199, 0.4)),
                        url('resources/Campus.jpg') no-repeat center center;
            background-size: cover;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            padding: 0;
        }

        /* Top header bar */
        header {
            width: 100%;
            /*background: linear-gradient(to right, #0072BB, #80D0C7);*/
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

        @media (max-width: 480px) {
            body {
                background: linear-gradient(to bottom, rgba(19, 84, 122, 0.4), rgba(128, 208, 199, 0.4)),
                            url('resources/CampusMobile.jpg') no-repeat center center;
                background-size: cover;
            }
            
            .header-text-desktop {
                display: none;
            }

            .header-text-mobile {
                display: flex;
                justify-content: center;
                align-items: center;
                flex-direction: column;
                color: white;
                font-weight: bold;
                line-height: 1.2;
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
        }

        /* Greeting */
        .greeting {
            text-align: center;
            color: white;
            margin: 30px 0 10px;
        }

        .greeting h1 {
            font-size: 26px;
            margin: 0;
        }

        .greeting p {
            font-size: 16px;
            margin-top: 5px;
        }

        /* Ride Options */
        .ride-options {
            display: flex;
            justify-content: center;
            width: 90%;
            max-width: 400px;
            margin: 20px 0;
        }

        .ride-option {
            background: rgba(255, 255, 255, 0.5);
            border-radius: 16px;
            padding: 10px 5px;
            width: 100%;
            max-width: 150px;
            text-align: center;
            color: black;
            text-decoration: none;
            transition: 0.3s;

            /* Flex for centering */
            display: flex;
            flex-direction: column;
            align-items: center;
        }


        .ride-option:hover {
            background: rgba(255, 255, 255, 0.3);
        }

        .ride-option img {
            width: 70px;
            height: auto;
            margin-bottom: 5px;
        }

        .ride-option span {
            font-size: 16px;
            font-weight: 600;
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

        /* Modal for active ride */
        #activeRideModal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0; top: 0;
            width: 100%; height: 100%;
            background-color: rgba(0,0,0,0.6);
        }

        #activeRideModal .modal-content {
            background: white;
            color: black;
            margin: 100px auto;
            padding: 20px;
            width: 90%;
            max-width: 400px;
            border-radius: 12px;
            text-align: center;
        }

        #activeRideModal button {
            padding: 10px 20px;
            margin-top: 20px;
            background-color: #13547a;
            color: white;
            border: none;
            border-radius: 6px;
        }
    </style>
</head>
<body>

<header>
    <img src="resources/EasyRide.png" alt="Logo" />
    <div class="header-text-desktop">EasyRide NORSU: Student Transport System</div>
    <div class="header-text-mobile">
        <div class="title">EASYRIDE NORSU</div>
        <div class="subtitle">Student Transport System</div>
    </div>
    <img src="resources/NorsuLogo.png" alt="Logo" />
</header>

<div class="greeting">
    <h1><%= fullName %></h1>
    <p>How can we help you today?</p>
</div>

<div class="ride-options">
    <%
        if (!hasActiveRide) {
    %>
        <a href="StudentMotorcyclePanel.jsp" class="ride-option">
            <img src="resources/MotorcycleTaxi.png" alt="Motorcycle">
            <span>Motorcycle Taxi</span>
        </a>
    <%
        } else {
    %>
        <div class="ride-option" onclick="showActiveRideModal()">
            <img src="resources/MotorcycleTaxi.png" alt="Motorcycle">
            <span>Motorcycle Taxi</span>
        </div>
    <%
        }
    %>
</div>


<!-- Bottom Navbar -->
<div class="navbar">
    <a href="StudentDashboard.jsp" class="nav-item active">
        <img src="resources/Home.png" alt="Home">
        <span>Home</span>
    </a>
    <a href="StudentRideStatus.jsp" class="nav-item">
        <img src="resources/RideStatus.png" alt="Ride Status">
        <span>Ride Status</span>
    </a>
    <a href="StudentInbox.jsp" class="nav-item">
        <img src="resources/Inbox.png" alt="Inbox">
        <span>Inbox</span>
    </a>
    <a href="StudentAccount.jsp" class="nav-item">
        <img src="resources/Account.png" alt="Account">
        <span>Account</span>
    </a>
</div>

<!-- Modal -->
<div id="activeRideModal">
    <div class="modal-content">
        <h2>Active Ride Detected</h2>
        <p>You cannot request a new ride while you have a pending or ongoing ride.</p>
        <button onclick="closeActiveRideModal()">OK</button>
    </div>
</div>

<script>
    function showActiveRideModal() {
        document.getElementById('activeRideModal').style.display = 'block';
    }

    function closeActiveRideModal() {
        document.getElementById('activeRideModal').style.display = 'none';
    }
</script>

</body>
</html>
