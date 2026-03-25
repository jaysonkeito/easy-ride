<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Driver Sign In - EasyRide</title>
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
            max-width: 400px;
            display: flex;
            flex-direction: column;
            box-sizing: border-box;
            margin: 20px;
        }

        h2 {
            text-align: center;
            color: white;
            margin-bottom: 20px;
        }

        input[type="text"],
        input[type="password"] {
            margin-bottom: 15px;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 16px;
            transition: border-color 0.3s;
        }

        input:focus {
            border-color: #007bff;
            outline: none;
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

        .signup-link {
            margin-top: 15px;
            text-align: center;
            font-size: 14px;
        }

        .signup-link a {
            color: #13547a;
            text-decoration: none;
            font-weight: bold;
        }

        .signup-link a:hover {
            text-decoration: underline;
        }

        .alert {
            margin: 10px 0;
            padding: 12px;
            border-radius: 6px;
            text-align: center;
            font-weight: bold;
        }

        .alert.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .alert.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
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

<form method="post" action="DriverSignInServlet">
    <h2>Driver Sign In</h2>

    <input type="text" name="username" placeholder="Username" required />
    <input type="password" name="password" placeholder="Password" required />
    <button type="submit">Sign In</button>

    <div class="signup-link">
        Don't have an account? <a href="Index.jsp">Apply here</a>
    </div>

    <!-- Alert Message -->
    <% if (request.getAttribute("message") != null) {
        String type = (String) request.getAttribute("messageType");
        if (type == null) type = "error";
    %>
        <div class="alert <%= type %>">
            <%= request.getAttribute("message") %>
        </div>
    <% } %>
</form>

</body>
</html>
