<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ page session="true" %>
<%
    String driverUsername = (String) session.getAttribute("driverUsername");
    if (driverUsername == null) {
        response.sendRedirect("DriverSignIn.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html>
<head>
    <title>Driver Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="update-location.js"></script>
    <style>
        html, body {
            overflow-x: hidden;
        }
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to bottom, rgba(19, 84, 122, 0.5), rgba(128, 208, 199, 0.5)),
                        url('resources/Campus.jpg') no-repeat center center fixed;
            background-size: cover;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            color: #fff; /* Make default text white */
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
            color: #fff; /* Ensure white text */
            text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.7); /* Add shadow for readability */
        }

        .header-text-mobile {
            display: none;
            color: #fff;
        }

        h2 {
            margin: 20px;
            font-size: 20px;
            color: #fff; /* Make the welcome text white */
            text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.6);
        }

        .section {
            padding: 10px 20px;
            width: 100%;
            max-width: 600px;
        }

        .card {
            background: rgba(255, 255, 255, 0.9); /* Slight transparency so bg image shows a bit */
            padding: 15px 20px;
            margin-bottom: 15px;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
            color: #333; /* Dark text inside card for contrast */
        }

        .card h3 {
            margin-top: 0;
        }
        
        .welcome-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            width: 90%;
            max-width: 600px;
            margin: 20px auto;
            background: rgba(0, 0, 0, 0.4);
            padding: 12px 20px;
            border-radius: 10px;
        }

        .welcome-text {
            font-size: 18px;
            color: #fff;
        }

        .toggle-container {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* Real toggle switch */
        .switch {
            position: relative;
            display: inline-block;
            width: 50px;
            height: 28px;
        }

        .switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }

        .slider {
            position: absolute;
            cursor: pointer;
            top: 0; 
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #dc3545; /* offline default */
            transition: 0.4s;
            border-radius: 28px;
        }

        .slider:before {
            position: absolute;
            content: "";
            height: 22px;
            width: 22px;
            left: 3px;
            bottom: 3px;
            background-color: white;
            transition: 0.4s;
            border-radius: 50%;
        }

        input:checked + .slider {
            background-color: #28a745; /* online */
        }

        input:checked + .slider:before {
            transform: translateX(22px);
        }


        .btn {
            padding: 10px 15px;
            border: none;
            border-radius: 6px;
            margin-right: 10px;
            cursor: pointer;
            font-size: 14px;
            color: white;
        }

        .accept-btn {
            background-color: #28a745;
        }

        .decline-btn {
            background-color: #dc3545;
        }

        .track-btn {
            background-color: #007bff;
        }

        .cancel-btn {
            background-color: #6c757d;
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            color: white;
            margin-left: 10px;
        }

        .COMPLETED {
            background-color: #28a745;
        }

        .CANCELLED {
            background-color: #dc3545;
        }

        .navbar {
            width: 100%;
            background: rgba(0, 0, 0, 0.4);
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
            color: #fff;
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

        @media screen and (max-width: 600px) {
            .card {
                padding: 12px;
            }

            .header-text-desktop {
                display: none;
            }

            .header-text-mobile {
                display: flex;
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
        <div class="title">EASY RIDE</div>
        <div class="subtitle">NORSU Driver</div>
    </div>
    <img src="resources/NorsuLogo.png" alt="Logo" />
</header>

<%
    String driverStatus = "Offline"; // default
    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql:///EasyRide", "root", "");
        String statusSql = "SELECT Status FROM registereddrivers WHERE Username = ?";
        stmt = conn.prepareStatement(statusSql);
        stmt.setString(1, driverUsername);
        rs = stmt.executeQuery();
        if (rs.next()) {
            driverStatus = rs.getString("Status");
        }
    } catch (Exception e) {
        out.println("<p>Error loading status: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>

<div class="welcome-container">
    <div class="welcome-text">
        Welcome, <%= driverUsername %>
    </div>
    <div class="toggle-container">
        <label class="switch">
            <input type="checkbox" id="statusToggleSwitch" <%= "Online".equals(driverStatus) ? "checked" : "" %> />
            <span class="slider"></span>
        </label>
        <span id="statusLabel"><%= driverStatus %></span>
    </div>
    <input type="hidden" id="driverUsername" value="<%= driverUsername %>" />
</div>

<!-- Home Section (Pending Requests) -->
<div class="section tab-content" id="homeTab">
    <div id="pendingRequestsContainer">
        <%
            
            try {
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql:///EasyRide", "root", "");

                String sql = "SELECT * FROM rides WHERE RiderUsername = ? AND Status NOT IN ('Completed', 'Cancelled', 'Rated') ORDER BY RequestTime DESC";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, driverUsername);
                rs = stmt.executeQuery();

                boolean hasRides = false;
                while (rs.next()) {
                    hasRides = true;
                    String transactionNumber = rs.getString("TransactionNumber");
                    String studentId = rs.getString("StudentID");
                    String pickup = rs.getString("PickUpLocation");
                    String dropoff = rs.getString("DropOffLocation");
                    double fee = rs.getDouble("Fee");
                    String status = rs.getString("Status");
                    double distance = rs.getDouble("Distance");
                    Timestamp time = rs.getTimestamp("RequestTime");
                    String timeFormatted = new SimpleDateFormat("MMM dd, yyyy HH:mm").format(time);
        %>
        <div class="card">
            <h3>Transaction #: <%= transactionNumber %></h3>
            <p><strong>Student:</strong> <%= studentId %></p>
            <p><strong>Pick-Up:</strong> <%= pickup %></p>
            <p><strong>Drop-Off:</strong> <%= dropoff %></p>
            <p><strong>Distance:</strong> <%= String.format("%.2f", distance) %> km</p>
            <p><strong>Fare:</strong> &#8369;<%= String.format("%.2f", fee) %></p>
            <p><strong>Status:</strong> <%= status %></p>
            <p><strong>Requested at:</strong> <%= timeFormatted %></p>

            <%
                if ("Pending".equals(status)) {
            %>
                <form action="DriverHandleRideRequestServlet" method="post">
                    <input type="hidden" name="transactionNumber" value="<%= transactionNumber %>">
                    <button class="btn accept-btn" name="action" value="accept">Accept</button>
                    <button class="btn decline-btn" name="action" value="decline">Decline</button>
                </form>
            <%
                } else if ("Accepted".equals(status) || "Ongoing".equals(status)) {
            %>
                <form action="DriverCancelRideServlet" method="post" onsubmit="return confirm('Are you sure you want to cancel this ride?');">
                    <input type="hidden" name="transactionNumber" value="<%= transactionNumber %>">
                    <button type="button" class="btn track-btn" onclick="location.href='DriverRideTracking.html?transactionNumber=<%= transactionNumber %>'">Track Ride</button>
                    <button class="btn cancel-btn" type="submit">Cancel Ride</button>
                </form>
            <%
                }
            %>
        </div>
        <%
                }
                if (!hasRides) {
        %>
        <p style="text-align: center; " >No active ride requests.</p>
        <%
                }
            } catch (Exception e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        %>
    </div>
</div>

<!-- Bottom Navbar -->
<div class="navbar">
    <a href="DriverDashboard.jsp" class="nav-item active">
        <img src="resources/Home.png" alt="Home">
        <span>Home</span>
    </a>
    <a href="DriverHistoryRides.jsp" class="nav-item">
        <img src="resources/RideStatus.png" alt="Ride History">
        <span>Ride History</span>
    </a>
    <a href="DriverInbox.jsp" class="nav-item">
        <img src="resources/Inbox.png" alt="Inbox">
        <span>Inbox</span>
    </a>
    <a href="DriverAccount.jsp" class="nav-item">
        <img src="resources/Account.png" alt="Account">
        <span>Account</span>
    </a>
</div>

<!-- JavaScript -->
<script>
    function showTab(tab) {
        const tabs = ['home', 'history', 'account'];
        tabs.forEach(t => {
            document.getElementById(t + 'Tab').style.display = (t === tab) ? 'block' : 'none';
            document.getElementById('nav' + t.charAt(0).toUpperCase() + t.slice(1)).classList.toggle('active', t === tab);
        });
    }

    function loadPendingRides() {
        fetch('DriverPendingRides.jsp')
          .then(response => response.text())
          .then(html => {
            document.getElementById('pendingRequestsContainer').innerHTML = html;
          })
          .catch(err => console.error('Error loading pending rides:', err));
    }

    //setInterval(loadPendingRides, 15000);
    
    document.getElementById("statusToggleSwitch").addEventListener("change", function() {
        const newStatus = this.checked ? "Online" : "Offline";

        fetch("DriverUpdateStatusServlet", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: "username=" + encodeURIComponent(document.getElementById("driverUsername").value) +
                  "&status=" + encodeURIComponent(newStatus)
        })
        .then(response => response.text())
        .then(data => {
            document.getElementById("statusLabel").textContent = newStatus;
        })
        .catch(err => {
            console.error("Error updating status:", err);
            alert("Failed to update status.");
            // Roll back switch if update fails
            this.checked = !this.checked;
            document.getElementById("statusLabel").textContent = this.checked ? "Online" : "Offline";
        });
    });
</script>

</body>
</html>