<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    String driverUsername = (String) session.getAttribute("driverUsername");
    if (driverUsername == null) {
        response.sendRedirect("DriverSignIn.jsp");
        return;
    }

    String fullName = "", email = "", mobileNumber = "", city = "", service = "", baseOffice = "";
    String profilePicture = "images/default-profile.png", driverUniqueID = "", ratings = "", registrationDate = "";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql:///EasyRide", "root", "");
        String sql = "SELECT DriverUniqueID, Email, FullName, MobileNumber, City, Service, BaseOffice, ProfilePicture, Ratings, RegistrationDate FROM registereddrivers WHERE Username = ?";
        stmt = conn.prepareStatement(sql);
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
            String dbProfilePic = rs.getString("ProfilePicture");
            if (dbProfilePic != null && !dbProfilePic.trim().equals("")) {
                profilePicture = dbProfilePic;
            }
            ratings = rs.getString("Ratings");
            registrationDate = rs.getString("RegistrationDate");
        } else {
            response.sendRedirect("DriverSignIn.jsp");
            return;
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
        if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Driver Account</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
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
            background-color: rgba(0, 0, 0, 0.3);
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
            color: #333;
            text-align: center;
        }
        
        .section {
            justify-content: center;
            display: flex;
            max-width: 600px;
            box-sizing: border-box;
        }

        .account-container {
            width: 100%;
            max-width: 600px;
            background: white;
            padding: 0px 20px 20px 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }

        .profile-pic {
            display: block;
            margin: 0 auto 15px auto;
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #007bff;
        }

        .readonly-info {
            text-align: center;
            color: #555;
            font-size: 14px;
            margin-bottom: 15px;
        }

        label {
            display: block;
            font-weight: bold;
            margin-top: 12px;
            margin-bottom: 4px;
        }

        input[type="text"],
        input[type="email"],
        input[type="tel"],
        input[type="password"],
        input[type="file"] {
            width: 100%;
            padding: 10px;
            font-size: 14px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
        }

        button[type="submit"] {
            width: 100%;
            background-color: #007bff;
            color: white;
            padding: 12px;
            font-size: 15px;
            font-weight: bold;
            border: none;
            border-radius: 6px;
            margin-top: 20px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        button[type="submit"]:hover {
            background-color: #0056b3;
        }

        .logout-btn {
            background-color: crimson;
            color: white;
            padding: 8px 14px;
            font-size: 13px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
        }

        .logout-btn:hover {
            background-color: #c21807;
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
            .account-container {
                width: 100%;
                margin: 15px 10px 90px 10px;
                padding: 15px;
            }

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

<!-- MAIN -->
<div class="section">
    <div class="account-container">
        <h2>Account</h2>
        <img src="<%= profilePicture %>" alt="Profile Picture" class="profile-pic" id="profilePreview" />

        <div class="readonly-info">
            <p><strong>Driver ID:</strong> <%= driverUniqueID %></p>
            <p><strong>Ratings:</strong> <%= ratings != null ? ratings : "N/A" %></p>
            <p><strong>Registration Date:</strong> <%= registrationDate %></p>
        </div>

        <form action="DriverEditAccountServlet" method="post" enctype="multipart/form-data">
            <label for="fullName">Full Name</label>
            <input type="text" name="fullName" id="fullName" value="<%= fullName %>" required />

            <label for="email">Email</label>
            <input type="email" name="email" id="email" value="<%= email %>" required />

            <label for="mobileNumber">Mobile Number</label>
            <input type="tel" name="mobileNumber" id="mobileNumber" value="<%= mobileNumber %>" pattern="[0-9]{10,15}" title="Enter a valid phone number" />

            <label for="password">New Password (leave blank to keep current)</label>
            <input type="password" name="password" id="password" minlength="6" placeholder="******" />

            <label for="profilePicture">Profile Picture</label>
            <input type="file" name="profilePicture" id="profilePicture" accept="image/*" />

            <button type="submit">Update Account</button>
            
            <button type="button" onclick="window.location.href='DriverAccount.jsp'" style="
                width: 100%;
                background-color: #6c757d;
                color: white;
                padding: 12px;
                font-size: 15px;
                font-weight: bold;
                border: none;
                border-radius: 6px;
                margin-top: 10px;
                cursor: pointer;
                transition: background-color 0.3s;">
                Return to Account
            </button>
            

        </form>
    </div>
</div>
<!-- Bottom Navbar -->
<div class="navbar">
    <a href="DriverDashboard.jsp" class="nav-item">
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
    <a href="DriverAccount.jsp" class="nav-item active">
        <img src="resources/Account.png" alt="Account">
        <span>Account</span>
    </a>
</div>

<script>
    // Profile picture preview
    document.getElementById('profilePicture').addEventListener('change', function () {
        const file = this.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function (e) {
                document.getElementById('profilePreview').src = e.target.result;
            };
            reader.readAsDataURL(file);
        }
    });
</script>

</body>
</html>
