<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String email = request.getParameter("email");
    String FullName = "", firstName = "", lastName = "", mobile = "", city = "", service = "", baseOffice = "";

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql:///EasyRide", "root", "");
        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM pendingdrivers WHERE Email = ?");
        stmt.setString(1, email);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            firstName = rs.getString("FirstName");
            lastName = rs.getString("LastName");
            mobile = rs.getString("MobileNumber");
            city = rs.getString("City");
            service = rs.getString("Service");
            baseOffice = rs.getString("BaseOffice");
            
        } else {
            //out.println("<p style='color:red;'>Invalid or expired registration link.</p>");
        }
        FullName = firstName + lastName;

        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Complete Driver Registration - EasyRide</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(to bottom, rgba(19, 84, 122, 0.5), rgba(128, 208, 199, 0.5)),
                        url('resources/Campus.jpg') no-repeat center center fixed;
            background-size: cover;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            padding: 0;
        }

        header {
            width: 100%;
            padding: 20px;
            /*background-color: rgba(0, 0, 0, 0.4);*/
            background-color: #0072BB;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            font-size: 20px;
            font-weight: bold;
            box-sizing: border-box;
            position: relative;
        }

        .header-text-desktop {
            display: block;
        }

        .header-text-mobile {
            display: none;
        }

        header img {
            height: 40px;
            flex-shrink: 0;
        }

        form {
            background-color: rgba(19, 84, 122, 0.2);
            backdrop-filter: blur(8px);
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            width: 90%;
            max-width: 500px;
            display: flex;
            flex-direction: column;
            margin: 20px;
            box-sizing: border-box;
        }

        h2 {
            text-align: center;
            color: #13547a;
            margin-bottom: 20px;
        }

        input[type="text"],
        input[type="email"],
        input[type="password"],
        input[type="file"] {
            margin-bottom: 15px;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 16px;
            background-color: white;
        }

        input.readonly {
            background-color: #f0f0f0;
        }

        button {
            padding: 12px;
            background-color: #007bff;
            color: white;
            font-size: 16px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        button:hover {
            background-color: #0056b3;
        }

        @media (max-width: 600px) {
            
            header {
                justify-content: center;
                gap: 20px;
                padding: 15px 10px;
                font-size: 16px;
                align-items: center;
            }

            .header-text-desktop {
                display: none;
            }

            .header-text-mobile {
                display: flex;
                flex-direction: column;
                justify-content: center;
                text-align: center;
                font-weight: bold;
                color: white;
                line-height: 1;
            }

            .header-text-mobile .title {
                font-size: 28px;
                text-transform: uppercase;
                margin: 0;
            }

            .header-text-mobile .subtitle {
                font-size: 20px;
                font-weight: normal;
                margin: 0;
                color: #ddd;
            }

            header img {
                height: auto;
                max-height: 72px;
                flex-shrink: 0;
            }

            form {
                padding: 20px;
            }

            h2 {
                font-size: 20px;
            }

            input,
            button {
                font-size: 14px;
                padding: 10px;
            }
        }
    </style>
</head>
<body>

<header>
    <img src="resources/EasyRideDriver.png" alt="Logo" />
    <div class="header-text-desktop">EasyRide: NORSU Driver</div>
    <div class="header-text-mobile">
        <div class="title">EASYRIDE </div>
        <div class="subtitle">NORSU Driver</div>
    </div>
    <img src="resources/NorsuLogo.png" alt="Logo" />
</header>

<form action="DriverSignUpServlet" method="post" enctype="multipart/form-data">
    <h2>Complete Your Driver Registration</h2>
    
    <input type="hidden" name="email" value="<%= email %>">

    <input type="text" class="readonly" name="fullName" value="<%= FullName %>" readonly placeholder="Full Name">
    <input type="text" class="readonly" name="mobile" value="<%= mobile %>" readonly placeholder="Mobile Number">
    <input type="text" class="readonly" name="city" value="<%= city %>" readonly placeholder="City">
    <input type="text" class="readonly" name="service" value="<%= service %>" readonly placeholder="Service">
    <input type="text" class="readonly" name="baseOffice" value="<%= baseOffice %>" readonly placeholder="Base Office">

    <input type="text" name="username" placeholder="Username" required>
    <input type="password" name="password" placeholder="Password" required>

    <label style="margin-top: 10px;">Upload Profile Picture</label>
    <input type="file" name="profilePic" accept="image/*" required>

    <label>Upload Driver's License or ID (PDF/Image)</label>
    <input type="file" name="driverId" accept="application/pdf,image/*" required>

    <button type="submit">Register</button>
</form>

</body>
</html>
