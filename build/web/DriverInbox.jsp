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
    PreparedStatement reviewStmt = null;
    ResultSet rs = null;
    ResultSet reviewRs = null;
%>

<!DOCTYPE html>
<html>
<head>
    <title>Driver Inbox</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: linear-gradient(to bottom, rgba(19,84,122,0.5), rgba(128,208,199,0.5)), url('resources/Campus.jpg') no-repeat center center fixed; background-size: cover; margin:0; padding-bottom:70px; display:flex; flex-direction:column; align-items:center; min-height:100vh; }
        header { width:100%; background-color:#0072BB; padding:15px 20px; display:flex; align-items:center; justify-content:center; gap:10px; box-sizing:border-box; }
        header img { height:50px; }
        .toggle-container { margin:20px; display:flex; align-items:center; gap:10px; background:rgba(255,255,255,0.2); padding:5px 10px; border-radius:20px; }
        .toggle-btn {
            padding: 5px 15px;
            border-radius: 15px;
            cursor: pointer;
            color: white;
            font-weight: bold;
            font-size: 14px;
            transition: background 0.3s, color 0.3s;
        }

        .toggle-btn.active {
            background: rgba(255, 255, 255, 0.7);
            color: #0072BB;
        }

        .section { width:100%; max-width:700px; padding:0 15px 20px 15px; box-sizing:border-box; }
        .message-card { background:#fff; padding:15px 20px; margin-bottom:15px; border-radius:12px; box-shadow:0 4px 10px rgba(0,0,0,0.05); cursor:pointer; }
        .navbar { width:100%; background:rgba(0,0,0,0.3); backdrop-filter:blur(12px); display:flex; justify-content:space-around; position:fixed; bottom:0; left:50%; transform:translateX(-50%); border-top-left-radius:12px; border-top-right-radius:12px; box-shadow:0 -2px 8px rgba(0,0,0,0.25); padding:10px 0; }
        .nav-item { color:white; text-decoration:none; font-size:12px; display:flex; flex-direction:column; align-items:center; }
        .nav-item img { width:24px; filter:brightness(0) invert(1); margin-bottom:2px; }
        .nav-item.active span { font-weight:bold; color:#fff; }
        .nav-item.active img { filter:none; }
        .modal { display:none; position:fixed; z-index:999; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,0.6); justify-content:center; align-items:center; }
        .modal-content { background:#fff; padding:20px; border-radius:12px; width:90%; max-width:400px; }
        .modal-content h3 { margin-top:0; }
        .modal-content p { font-size:14px; }
        .modal-buttons { display:flex; justify-content:flex-end; gap:10px; margin-top:15px; }
        .btn { padding:5px 10px; border:none; border-radius:6px; cursor:pointer; }
        .btn-close { background:#999; color:#fff; }
        .btn-delete { background:#e74c3c; color:#fff; }
        #modalDate { font-size:12px; color:gray; margin-top:5px; }
    </style>
</head>
<body>

<header>
    <img src="resources/EasyRideDriver.png" alt="Logo" />
    <div style="color:white;font-weight:bold;">EasyRide NORSU Driver</div>
    <img src="resources/NorsuLogo.png" alt="Logo" />
</header>

<div class="toggle-container">
    <div class="toggle-btn active" id="btnAnnouncements" onclick="showSection('announcements')">Announcements</div>
    <div class="toggle-btn" id="btnFeedback" onclick="showSection('feedback')">Feedback</div>
</div>

<div class="section" id="announcementsSection">
<%
    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql:///EasyRide", "root", "");

        String sql = "SELECT * FROM driversinbox WHERE DriverUsername = ? ORDER BY SentTime DESC";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, driverUsername);
        rs = stmt.executeQuery();

        boolean hasAnnouncements = false;
        while (rs.next()) {
            hasAnnouncements = true;
            String subj = rs.getString("Subject").replace("'", "\\'");
            String msg = rs.getString("Message").replace("'", "\\'");
            String sentTime = new SimpleDateFormat("MMM dd, yyyy HH:mm").format(rs.getTimestamp("SentTime"));
%>
    <div class="message-card" onclick="openModal('announcement', <%= rs.getInt("Id") %>, '<%= subj %>', '<%= msg %>', '<%= sentTime %>')">
        <h3><%= rs.getString("Subject") %></h3>
        <p>From: Admin</p>
    </div>
<%
        }
        if (!hasAnnouncements) {
%>
    <p style="color:white; text-align:center;">No announcements found.</p>
<%
        }

        String reviewSQL = "SELECT * FROM driversfeedback WHERE DriverUsername = ? ORDER BY Id DESC";
        reviewStmt = conn.prepareStatement(reviewSQL);
        reviewStmt.setString(1, driverUsername);
        reviewRs = reviewStmt.executeQuery();
%>
</div>

<div class="section" id="feedbackSection" style="display: none;">
<%
        boolean hasFeedback = false;
        while (reviewRs.next()) {
            hasFeedback = true;
            String comment = reviewRs.getString("Comment");
            if (comment == null || comment.trim().isEmpty()) comment = "No comment";
            comment = comment.replace("'", "\\'");
%>
    <div class="message-card" onclick="openModal('feedback', 
                   <%= reviewRs.getInt("Id") %>, 
                   'Rating: <%= reviewRs.getDouble("Rating") %>', 
                   '<%= comment %>', 
                   '<%= new SimpleDateFormat("MMM dd, yyyy HH:mm").format(reviewRs.getTimestamp("DateReviewed")) %>')">
        <h3>Rating: <%= reviewRs.getDouble("Rating") %></h3>
        <p>From: <%= reviewRs.getString("StudentID") %></p>
    </div>
<%
        }
        if (!hasFeedback) {
%>
    <p style="color:white; text-align:center;">No feedback found.</p>
<%
        }
    } catch(Exception e) {
        out.println("<p style='color:white;'>" + e.getMessage() + "</p>");
    } finally {
        if(rs != null) rs.close();
        if(stmt != null) stmt.close();
        if(reviewRs != null) reviewRs.close();
        if(reviewStmt != null) reviewStmt.close();
        if(conn != null) conn.close();
    }
%>
</div>

<div class="modal" id="itemModal">
    <div class="modal-content">
        <h3 id="modalTitle"></h3>
        <p id="modalDate"></p>
        <p id="modalBody"></p>
        <div class="modal-buttons">
            <button class="btn btn-close" onclick="closeModal()">Close</button>
            <form id="deleteForm" method="post" action="DriverDeleteMessageServlet" style="display:inline;">
                <input type="hidden" name="type" id="deleteType" />
                <input type="hidden" name="id" id="deleteId" />
                <button type="submit" class="btn btn-delete">Delete</button>
            </form>
        </div>
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
    <a href="DriverInbox.jsp" class="nav-item active">
        <img src="resources/Inbox.png" alt="Inbox">
        <span>Inbox</span>
    </a>
    <a href="DriverAccount.jsp" class="nav-item">
        <img src="resources/Account.png" alt="Account">
        <span>Account</span>
    </a>
</div>

<script>
    function showSection(section) {
        document.getElementById('announcementsSection').style.display = (section === 'announcements') ? 'block' : 'none';
        document.getElementById('feedbackSection').style.display = (section === 'feedback') ? 'block' : 'none';

        document.getElementById('btnAnnouncements').classList.toggle('active', section === 'announcements');
        document.getElementById('btnFeedback').classList.toggle('active', section === 'feedback');
    }


    function openModal(type, id, title, body, dateSent) {
        document.getElementById('modalTitle').innerText = title;
        document.getElementById('modalDate').innerText = "Date Sent: " + dateSent;
        document.getElementById('modalBody').innerText = body;
        document.getElementById('deleteType').value = type;
        document.getElementById('deleteId').value = id;
        document.getElementById('itemModal').style.display = 'flex';
    }

    function closeModal() {
        document.getElementById('itemModal').style.display = 'none';
    }
</script>

</body>
</html>
