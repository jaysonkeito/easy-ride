<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%
    String driverUsername = (String) session.getAttribute("driverUsername");
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql:///EasyRide", "root", "");

        // Include all non-completed/cancelled rides
        String sql = "SELECT * FROM rides WHERE RiderUsername = ? AND Status NOT IN ('Completed', 'Cancelled') ORDER BY RequestTime DESC";
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
        <form action="HandleRideRequestServlet" method="post">
            <input type="hidden" name="transactionNumber" value="<%= transactionNumber %>">
            <button class="btn accept-btn" name="action" value="accept">Accept</button>
            <button class="btn decline-btn" name="action" value="decline">Decline</button>
        </form>
    <%
        } else if ("Accepted".equals(status) || "Ongoing".equals(status)) {
    %>
        <form action="CancelRideServlet" method="post" onsubmit="return confirm('Are you sure you want to cancel this ride?');">
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
<p>No active ride requests.</p>
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
