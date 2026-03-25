<%@ page import="java.sql.*, java.text.DecimalFormat" %>
<%@ page session="true" %>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%
    //String fullName = (String) session.getAttribute("fullName");
    String studentId = (String) session.getAttribute("studentId");

    if (studentId == null) {
        response.sendRedirect("SignIn.jsp");
        return;
    }
    DecimalFormat df = new DecimalFormat("#.##");

    String pickup = "", dropoff = "", status = "", rider = "", payment = "", notes = "", transactionCode = "";
    double distance = 0, fee = 0, time = 0;
    boolean hasRide = false;
    
    int rideIdValue = 0;
    String driverUsernameValue = "";


    if (studentId != null) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DriverManager.getConnection("jdbc:mysql:///EasyRide", "root", "");
            //String query = "SELECT * FROM rides WHERE StudentID = ? ORDER BY id DESC LIMIT 1";
            //String query = "SELECT * FROM rides WHERE StudentID = ? AND Status NOT IN ('Cancelled', 'Completed') ORDER BY id DESC LIMIT 1";
            //String query = "SELECT r.*, d.Username FROM rides r LEFT JOIN registereddrivers d ON r.RiderName = d.FullName WHERE r.StudentID = ? AND ((r.Status = 'Completed' AND r.Rated = 'No') OR (r.Status NOT IN ('Cancelled', 'Completed'))) ORDER BY r.id DESC LIMIT 1";
            String query = 
                "SELECT r.*, d.Username " +
                "FROM rides r " +
                "LEFT JOIN registereddrivers d ON r.RiderName = d.FullName " +
                "WHERE r.StudentID = ? " +
                "AND ( " +
                    "r.Status IN ('Pending', 'Accepted', 'Ongoing') " +
                    "OR (r.Status = 'Completed' AND r.Rated = 'No') " +
                ") " +
                "ORDER BY r.id DESC " +
                "LIMIT 1";


            stmt = conn.prepareStatement(query);
            stmt.setString(1, studentId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                pickup = rs.getString("PickUpLocation");
                dropoff = rs.getString("DropOffLocation");
                distance = rs.getDouble("Distance");
                fee = rs.getDouble("Fee");
                time = rs.getDouble("EstimatedTime");
                rider = rs.getString("RiderName");
                payment = rs.getString("PaymentMethod");
                notes = rs.getString("Notes");
                status = rs.getString("Status");
                transactionCode = rs.getString("TransactionNumber");
                rideIdValue = rs.getInt("Id");  // rides table Id
                driverUsernameValue = rs.getString("Username");  // from registereddrivers
                hasRide = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException ignored) {}
            try { if (stmt != null) stmt.close(); } catch (SQLException ignored) {}
            try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Ride Status - EasyRide</title>
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
            padding: 0 10px; /* padding for mobile spacing */
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
            max-height: 91vh;
        }


        .panel h2 {
            margin-top: 0;
            margin-bottom: 25px;
            color: black;
            font-weight: 700;
            text-align: center;
            letter-spacing: 1.2px;
        }

        /* Header updated to match MotorcyclePanel.jsp style */
        .header {
            position: sticky;
            top: 0;
            z-index: 10;
            /*background: linear-gradient(to right, #0072BB, #80D0C7);*/
            background-color: #0072BB;
            padding: 8px 20px 7px 20px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-direction: row; /* <-- change this from column to row */
            font-size: 18px;
            font-weight: bold;
        }


        .header a {
            color: white;
            text-decoration: none;
            font-size: 14px;
        }
        
        
        .header .nav-item {
            color: white;
            text-decoration: none;
            font-size: 10px;
            display: flex;
            flex-direction: column;
            align-items: center;
            transition: color 0.3s;
            cursor: pointer;
        }

        .header .nav-item img {
            width: 25px;
            height: auto;
            margin-bottom: 0px;
            filter: brightness(0) invert(1);
        }

        .header .nav-item:hover,
        .header .nav-item.active {
            color: #80d0c7;
        }

        

        /* Ride summary styling */
        .ride-summary {
            background-color: white;
            padding: 0px 20px;
            color: #e5f2f8;
            width: 100%;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .ride-summary p {
            display: flex;
            align-items: flex-start;
            flex-wrap: wrap;
            margin-bottom: 0.8em;
            line-height: 1.4;
        }

        .ride-summary strong {
            width: 110px;
            flex-shrink: 0;
            color: black;
            font-weight: 600;
        }

        .ride-summary .colon {
            margin-left: 5px;
            margin-right: 3px;
            color: black;
            flex-shrink: 0;
        }

        .ride-summary .value,
        .ride-summary .value.status {
            flex: 1;
            color: black;
            word-break: break-word;
            white-space: pre-wrap;
        }

        .ride-summary .value.status {
            font-weight: bold;
            color: #6be386;
        }
        .ride-summary .multiline-text {
            display: inline-block;
            max-width: 350px;
            color: black;
            margin-left: 4px;
            white-space: pre-wrap;
            line-height: 1.3;
        }

        .no-ride {
            text-align: center;
            margin-top: 60px;
            font-size: 20px;
            color: #fff;
        }
        
        .no-ride p {
            color: black;
            text-decoration: noce;
            font-weight: 600;
            margin-top: 20px;
            font-size: 20px;
        }

        .no-ride .Tagline {
            width: 300px;
            color: black;
            text-decoration: none;
            font-weight: 500;
            margin-top: 15px;
            display: inline-block;
            font-size: 16px;
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
        
        form select#rating,
        form textarea#comments {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            background-color: #f9f9f9;
            font-size: 14px;
            box-sizing: border-box; /* ensure padding/border included in width */
            transition: border-color 0.3s;
        }


        form select#rating:focus {
            border-color: #0072BB;
            outline: none;
        }

        form textarea#comments {
            border: 1px solid #ccc;
            border-radius: 6px;
            padding: 10px;
            font-size: 14px;
            background-color: #f9f9f9;
            transition: border-color 0.3s;
        }

        form textarea#comments:focus {
            border-color: #0072BB;
            outline: none;
        }

        form button[type="submit"] {
            width: 100%;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        form button[type="submit"]:hover {
            background-color: #005f99;
        }



        @media (max-width: 600px) {
            .header {
                font-size: 16px;
                padding: 6px 15px;
            }

            .panel {
                min-height: 83vh;
                border-radius: 10px;
            }

            .ride-summary strong {
                width: 100px;
                font-size: 14px;
            }

            .ride-summary .value {
                font-size: 14px;
            }

            .no-ride p,
            .no-ride .Tagline {
                font-size: 16px;
                text-align: center;
            }
            
            .ride-summary strong {
                width: 100px;
            }
            
            
        }
    </style>
</head>
<body>



<div class="panel">
    <div class="panel-header">
        <div class="header">
            <span>Ride Status</span>
            <a href="StudentHistory.jsp" class="nav-item">
                <img src="resources/History.png" alt="History" />
                <span>History</span>
            </a>
        </div>
    </div>

    <% if (hasRide) { %>
        <div class="ride-summary">
            <p><strong>Status</strong><span class="colon">:</span> <span class="value status"><%= status %></span></p>
            <p><strong>Transaction ID</strong><span class="colon">:</span> <span class="value"><%= transactionCode %></span></p>
            <p><strong>Pickup</strong><span class="colon">:</span> <span class="value"><%= pickup %></span></p>
            <p><strong>Drop-off</strong><span class="colon">:</span> <span class="value"><%= dropoff %></span></p>
            <p><strong>Distance</strong><span class="colon">:</span> <span class="value"><%= df.format(distance) %> km</span></p>
            <p><strong>Estimated Time</strong><span class="colon">:</span> <span class="value"><%= (int)Math.round(time) %> min</span></p>
            <p><strong>Fee</strong><span class="colon">:</span> <span class="value">₱<%= df.format(fee) %></span></p>
            <p><strong>Rider</strong><span class="colon">:</span> <span class="value"><%= rider %></span></p>
            <p><strong>Payment</strong><span class="colon">:</span> <span class="value"><%= payment %></span></p>

            <% if (notes != null && !notes.trim().isEmpty()) { %>
                <p><strong>Notes</strong><span class="colon">:</span> <span class="value"><%= notes %></span></p>
            <% } %>
        </div>

        <% if ("Completed".equalsIgnoreCase(status)) { %>
        <form action="StudentSubmitRatingServlet" method="post" style="padding: 15px;">
            <input type="hidden" name="transactionNumber" value="<%= transactionCode %>" />
            <input type="hidden" name="riderName" value="<%= rider %>" />
            <input type="hidden" name="rideId" value="<%= rideIdValue %>" />
            <input type="hidden" name="driverUsername" value="<%= driverUsernameValue %>" />

            <label for="rating"><strong>Rate your Rider:</strong></label><br>
            <select name="rating" id="rating" required>
                <option value="">Select Rating</option>
                <option value="1">1 - Very Poor</option>
                <option value="2">2 - Poor</option>
                <option value="3">3 - Average</option>
                <option value="4">4 - Good</option>
                <option value="5">5 - Excellent</option>
            </select><br><br>

            <label for="comments"><strong>Comments (optional):</strong></label><br>
            <textarea name="comments" id="comments" rows="3"></textarea><br><br>

            <button type="submit" style="padding: 8px 16px; background-color: #0072BB; color: white; border: none; border-radius: 6px;">Submit Feedback</button>
        </form>
        <% } %>

    <% } else { %>
        <div class="no-ride">
            <p>Time to book an EasyRide!</p>
            <p class="Tagline">We'll help match you with an available driver partner for your rides!</p>
        </div>
    <% } %>

</div>

<!-- Bottom Navbar -->
<div class="navbar">
    <a href="StudentDashboard.jsp" class="nav-item">
        <img src="resources/Home.png" alt="Home">
        <span>Home</span>
    </a>
    <a href="StudentRideStatus.jsp" class="nav-item active">
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

</body>
</html>
