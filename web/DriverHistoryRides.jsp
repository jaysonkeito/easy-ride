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
    String studentProfilePicture = "";
%>

<!DOCTYPE html>
<html>
<head>
    <title>Ride History</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
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

        .section {
            width: 100%;
            max-width: 700px;
            padding: 0 15px 20px 15px;
            box-sizing: border-box;
        }

        .card {
            background: #ffffff;
            padding: 15px 20px;
            margin-bottom: 15px;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            cursor: pointer;
        }

        .card h3 {
            margin-top: 0;
            font-size: 16px;
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

        .modal {
            display: none;
            position: fixed;
            z-index: 10;
            left: 0; top: 0;
            width: 100%; height: 100%;
            background: rgba(0,0,0,0.4);
        }

        .modal-content {
            background-color: white;
            margin: 10% auto;
            padding: 20px;
            width: 90%;
            max-width: 400px;
            border-radius: 10px;
        }

        .close-btn {
            background-color: #13547a;
            color: white;
            padding: 6px 10px;
            border: none;
            border-radius: 6px;
        }

        .status {
            background-color: #ccc;
            color: white;
            border-radius: 5px;
            padding: 2px 8px;
            font-size: 12px;
        }

        .status.CANCELLED {
            background-color: #444;
        }

        .status.COMPLETED {
            background-color: #28a745;
        }

        .label-value {
            display: flex;
            align-items: flex-start;
            margin-bottom: 5px;
            font-size: 13px;
            line-height: 1.4;
        }

        .label {
            min-width: 90px;
            font-weight: bold;
        }

        .value {
            flex: 1;
            word-wrap: break-word;
        }

        @media screen and (max-width: 600px) {
            .card {
                padding: 12px 15px;
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

<header>
    <img src="resources/EasyRideDriver.png" alt="Logo" />
    <div class="header-text-desktop">EasyRide NORSU Driver</div>
    <div class="header-text-mobile">
        <div class="title">EASYRIDE</div>
        <div class="subtitle">NORSU Driver</div>
    </div>
    <img src="resources/NorsuLogo.png" alt="Logo" />
</header>

<h2>Ride History</h2>

<div class="section">
    <%
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql:///EasyRide", "root", "");

            String sql = "SELECT * FROM rides WHERE RiderUsername = ? AND (Status = 'Completed' OR Status = 'Cancelled' OR Status = 'Rated') ORDER BY RequestTime DESC";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, driverUsername);
            rs = stmt.executeQuery();

            boolean hasHistory = false;
            while (rs.next()) {
                hasHistory = true;
                String transactionNumber = rs.getString("TransactionNumber");
                String studentId = rs.getString("StudentID");
                String studentFullName = rs.getString("StudentFullName");
                studentProfilePicture = rs.getString("StudentProfilePicture");
                String pickup = rs.getString("PickUpLocation");
                String dropoff = rs.getString("DropOffLocation");
                double fee = rs.getDouble("Fee");
                double distance = rs.getDouble("Distance");
                String paymentMethod = rs.getString("PaymentMethod");
                String status = rs.getString("Status");
                Timestamp time = rs.getTimestamp("RequestTime");
                String timeFormatted = new SimpleDateFormat("MMM dd, yyyy HH:mm").format(time);
    %>
    <div class="card" onclick="openModal('<%= transactionNumber %>', 
                   '<%= studentId %>', 
                   '<%= studentFullName %>', 
                   '<%= pickup.replace("'", "\\'") %>', 
                   '<%= dropoff.replace("'", "\\'") %>', 
                   '<%= timeFormatted %>', 
                   '<%= String.format("%.2f", fee) %>', 
                   '<%= status.toUpperCase() %>', 
                   '<%= String.format("%.2f", distance) %>', 
                   '<%= paymentMethod %>', 
                   '<%= studentProfilePicture %>')">

        <h3 style="justify-content: space-between; display: flex;">Transaction No.: <%= transactionNumber %> 
            <span class="status-badge <%= status.toUpperCase() %>"><%= status.toUpperCase() %></span>
        </h3>
        <p><strong>Pick-Up:</strong> <%= pickup %></p>
        <p><strong>Drop-Off:</strong> <%= dropoff %></p>
        <p><strong>Date & Time:</strong> <%= timeFormatted %></p>
    </div>
    <%
            }
            if (!hasHistory) {
    %>
    <p>No completed or cancelled rides found.</p>
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

<!-- MODAL -->
<div id="rideModal" class="modal">
    <div class="modal-content">
        <div style="display: flex; justify-content: space-between; align-items: center; font-weight: bold; font-size: 16px; margin-bottom: 5px;">
            <span>Transaction No.</span>
            <span id="modalTxn"></span>
        </div>

        <hr>

        <div style="display: flex; align-items: center; gap: 10px; margin: 10px 0;">
            <img id="modalPhoto" src="<%= (studentProfilePicture != null && !studentProfilePicture.trim().isEmpty()) ? studentProfilePicture : "images/students/Default.png" %>" alt="Profile Picture"
                 style="width: 60px; height: 60px; object-fit: cover; border-radius: 10px; border: 1px solid #ccc;">
            <div style="display: flex; flex-direction: column;">
                <strong id="modalFullname" style="font-size: 15px;"></strong>
                <strong id="modalStudent" style="font-size: 14px;"></strong>
            </div>
        </div>

        <hr>

        <div style="display: flex; justify-content: space-between; font-size: 14px;">
            <span>Motorcycle</span>
            <span id="modalStatus" class="status">--</span>
        </div>
        <div id="modalDate" style="font-size: 13px; margin-bottom: 10px;"></div>

        <hr>

        <div class="label-value" style="margin-bottom: 6px;">
            <span class="label">Total </span> &#8369;
            <span class="value" id="modalFee">0.00</span>
        </div>
        <div class="label-value" style="margin-bottom: 6px;">
            <span class="label">Distance</span>
            <span class="value" id="modalDistance">-- km</span>
        </div>
        <div class="label-value" style="margin-bottom: 6px;">
            <span class="label">Payment</span>
            <span class="value" id="modalPayment">--</span>
        </div>

        <hr>

        <div class="label-value">
            <span class="label">Pickup</span>
            <span class="value" id="modalPickup"></span>
        </div>
        <div class="label-value">
            <span class="label">Drop-off</span>
            <span class="value" id="modalDropoff"></span>
        </div>

        <hr>

        <div class="modal-footer" style="display: flex; justify-content: space-between;">
            <button class="close-btn" onclick="document.getElementById('rideModal').style.display='none'">Close</button>
        </div>
    </div>
</div>

<div class="navbar">
    <a href="DriverDashboard.jsp" class="nav-item">
        <img src="resources/Home.png" alt="Home">
        <span>Home</span>
    </a>
    <a href="DriverHistoryRides.jsp" class="nav-item active">
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

<script>
    function openModal(txn, student, fullname, pickup, dropoff, datetime, fee, status, distance, payment, photoURL) {
        document.getElementById('modalTxn').innerText = txn;
        document.getElementById('modalStudent').innerText = student;
        document.getElementById('modalFullname').innerText = fullname;
        document.getElementById('modalPickup').innerText = pickup;
        document.getElementById('modalDropoff').innerText = dropoff;
        document.getElementById('modalDate').innerText = datetime;

        const roundedFee = parseFloat(fee).toFixed(2);
        const roundedDistance = parseFloat(distance).toFixed(2);

        document.getElementById('modalFee').innerText = roundedFee;
        document.getElementById('modalDistance').innerText = roundedDistance + ' km';
        document.getElementById('modalPayment').innerText = payment;

        const modalStatus = document.getElementById('modalStatus');
        modalStatus.innerText = status.toUpperCase();
        modalStatus.classList.remove('CANCELLED', 'COMPLETED');
        modalStatus.classList.add(status.toUpperCase());

        document.getElementById('modalPhoto').src = photoURL ? photoURL : "images/students/Default.png";
        document.getElementById('rideModal').style.display = 'block';
    }
    function closeModal() {
        document.getElementById('rideModal').style.display = 'none';
    }

    window.onclick = function(event) {
        let modal = document.getElementById('rideModal');
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }
</script>

</body>
</html>
