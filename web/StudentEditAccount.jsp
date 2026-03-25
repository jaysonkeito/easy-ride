<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Account - EasyRide</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
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

        .container {
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

        .panel-header {
            /*background: linear-gradient(to right, #0072BB, #80D0C7);*/
            background-color: #0072BB;
            padding: 15px 20px;
            color: white;
            font-size: 18px;
            font-weight: bold;
            text-align: left;
        }

        .edit-form {
            padding: 20px;
        }

        .edit-form h2 {
            margin-bottom: 15px;
            color: #13547a;
            text-align: center;
        }

        .form-group {
            margin-bottom: 15px;
        }

        label {
            font-weight: bold;
            display: block;
            margin-bottom: 5px;
            color: #333;
        }

        input[type="text"],
        input[type="email"],
        input[type="password"],
        input[type="file"] {
            width: 100%;
            padding: 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
            box-sizing: border-box;
        }

        .note {
            font-size: 13px;
            color: #777;
        }

        .btn-submit {
            background: #13547a;
            color: white;
            font-weight: bold;
            border: none;
            padding: 12px;
            border-radius: 6px;
            width: 100%;
            cursor: pointer;
        }

        .btn-submit:hover {
            background: #0e3d5b;
        }

        .back-link {
            margin-top: 15px;
            display: block;
            text-align: center;
            color: #13547a;
            text-decoration: none;
            font-weight: bold;
        }

        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<%
    String studentId = (String) session.getAttribute("studentId");
    if (studentId == null) {
        response.sendRedirect("StudentSignIn.jsp");
        return;
    }

    String email = "";
    String phone = "";

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql:///EasyRide", "root", "");
        PreparedStatement ps = conn.prepareStatement("SELECT Email, PhoneNumber FROM registeredstudents WHERE StudentID = ?");
        ps.setString(1, studentId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            email = rs.getString("Email");
            phone = rs.getString("PhoneNumber");
        }
        rs.close(); ps.close(); conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<div class="container">
    <div class="panel-header">Edit Account</div>
    <form class="edit-form" action="StudentEditAccountServlet" method="post" enctype="multipart/form-data">
        <input type="hidden" name="studentId" value="<%= studentId %>">

        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" name="email" id="email" value="<%= email %>">
        </div>

        <div class="form-group">
            <label for="phone">Phone Number</label>
            <input type="text" name="phone" id="phone" value="<%= phone %>">
        </div>

        <div class="form-group">
            <label for="newPassword">New Password <span class="note">(Leave blank if not changing)</span></label>
            <input type="password" name="newPassword" id="newPassword">
        </div>

        <div class="form-group">
            <label for="confirmPassword">Confirm New Password</label>
            <input type="password" name="confirmPassword" id="confirmPassword">
        </div>

        <div class="form-group">
            <label for="profilePic">Profile Picture</label>
            <input type="file" name="profilePic" id="profilePic" accept="image/*">
        </div>

        <div class="form-group">
            <label for="currentPassword">Confirm Current Password <span class="note">(Required to apply changes)</span></label>
            <input type="password" name="currentPassword" id="currentPassword" required>
        </div>

        <button type="submit" class="btn-submit">Update Account</button>
        <a href="StudentAccount.jsp" class="back-link">Cancel / Back to Account</a>
    </form>
</div>

</body>
</html>
