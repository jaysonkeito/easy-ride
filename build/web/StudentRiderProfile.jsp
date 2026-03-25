<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Rider Profile</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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

        .profile-panel {
            background-color: white;
            width: 100%;
            max-width: 480px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.25);
            display: flex;
            flex-direction: column;
            overflow-y: auto;
            min-height: 100vh;
        }

        .profile-header-bar {
            /*background: linear-gradient(to right, #0072BB, #80D0C7);*/
            background-color: #0072BB;
            padding: 15px 20px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 18px;
            font-weight: bold;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }

        .profile-header-bar a {
            color: white;
            text-decoration: none;
            font-weight: normal;
            font-size: 14px;
            cursor: pointer;
        }

        .profile-content {
            background-color: white;
            padding: 20px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100px;
        }

        .profile-photo {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 15px;
            border: 3px solid #13547a;
        }

        .profile-name {
            color: #13547a;
            font-size: 22px;
            font-weight: bold;
            margin-bottom: 8px;
            text-align: center;
        }

        .profile-rating {
            font-size: 16px;
            margin-bottom: 15px;
            color: #333;
            text-align: center;
        }

        .profile-info p {
            margin: 8px 0;
            font-size: 16px;
            width: 100%;
            text-align: left;
            color: #333;
        }

        .choose-btn {
            margin-top: auto;
            width: 100%;
            padding: 12px 0;
            background-color: #13547a;
            color: white;
            border: none;
            border-radius: 6px;
            font-weight: bold;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .choose-btn:hover {
            background-color: #0e3a5f;
        }
    </style>
</head>
<body>
<div class="profile-panel">
    <div class="profile-header-bar">
        <span>Rider's Profile</span>
        <a href="StudentAvailableRidersServlet">Cancel</a>
    </div>

    <%
        String riderIdStr = request.getParameter("riderId");
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        // Get pickup coordinates from session
        String pickupLatStr = (String) session.getAttribute("PickUpLatitude");
        String pickupLngStr = (String) session.getAttribute("PickUpLongitude");

        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql:///EasyRide", "root", "");

            String sql = "SELECT * FROM registereddrivers WHERE Id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(riderIdStr));
            rs = stmt.executeQuery();

            if (rs.next()) {
                String driverUniqueID = rs.getString("DriverUniqueID");
                String fullName = rs.getString("FullName");
                String email = rs.getString("Email");
                String mobile = rs.getString("MobileNumber");
                String city = rs.getString("City");
                String service = rs.getString("Service");
                String baseOffice = rs.getString("BaseOffice");
                String profilePicture = rs.getString("ProfilePicture");
                double rating = rs.getDouble("Ratings");

                // Get driver's coordinates
                double driverLat = rs.getDouble("latitude");
                double driverLng = rs.getDouble("longitude");

                // Calculate distance
                double pickupLat = Double.parseDouble(pickupLatStr);
                double pickupLng = Double.parseDouble(pickupLngStr);

                // Haversine formula in Java
                final int R = 6371; // Radius of Earth in km
                double latDistance = Math.toRadians(driverLat - pickupLat);
                double lngDistance = Math.toRadians(driverLng - pickupLng);
                double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
                         + Math.cos(Math.toRadians(pickupLat)) * Math.cos(Math.toRadians(driverLat))
                         * Math.sin(lngDistance / 2) * Math.sin(lngDistance / 2);
                double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
                double distance = R * c; // in kilometers
    %>

    <div class="profile-content">
        <img src="<%= profilePicture %>" alt="Rider Photo" class="profile-photo" />
        <div class="profile-name"><%= fullName %></div>
        <div class="profile-rating">Rating: <%= rating %> ⭐</div>

        <div class="profile-info">
            <p><strong>Driver ID:</strong> <%= driverUniqueID %></p>
            <p><strong>Email:</strong> <%= email %></p>
            <p><strong>Mobile Number:</strong> <%= mobile %></p>
            <p><strong>City:</strong> <%= city %></p>
            <p><strong>Service:</strong> <%= service %></p>
            <p><strong>Base Office:</strong> <%= baseOffice %></p>
            <p><strong>Distance from Pick-up:</strong> <%= String.format("%.2f", distance) %> km</p>
        </div>

        <form action="StudentMotorcycleSummaryServlet" method="post" style="width: 100%;">
            <input type="hidden" name="riderId" value="<%= riderIdStr %>">
            <button type="submit" class="choose-btn">Choose this Rider</button>
        </form>
    </div>

    <%
            } else {
    %>
    <div class="profile-content" style="justify-content: center; text-align: center;">
        <p>Rider not found.</p>
    </div>
    <%
            }
        } catch (Exception e) {
    %>
    <div class="profile-content" style="justify-content: center; text-align: center; color: red;">
        <p>Error: <%= e.getMessage() %></p>
    </div>
    <%
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
            if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
    %>
</div>
</body>
</html>
