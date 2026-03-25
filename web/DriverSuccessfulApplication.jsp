<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Driver Sign-Up | EasyRide</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * {
            box-sizing: border-box;
        }

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

        .container {
            max-width: 600px;
            background: #fff;
            margin: 30px auto;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            margin-bottom: 10px;
        }

        .progress {
            text-align: center;
            font-weight: bold;
            margin-bottom: 20px;
            color: #555;
        }

        .form-page p {
            text-align: center;
        }

        button {
            display: block;
            width: 100%;
            padding: 10px;
            background-color: #0072BB;
            color: white;
            font-size: 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 20px;
        }

        button:hover {
            background-color: #005b99;
        }

        button:disabled {
            background: #ccc;
            cursor: not-allowed;
        }

        @media (max-width: 600px) {
            .container {
                margin: 15px;
                padding: 15px;
            }
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
        }
    </style>
    <script>
        function returnToIndex() {
            window.location.href = 'Index.jsp'; // or 'index.jsp' or any target page
        }
    </script>
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
<div class="container">
    <div class="form-page active" id="page">
        <h2>Thank You!</h2>
        <div class="progress">Page 4 of 4</div>

        <p>Thank you for filling out our EasyRide Motorcycle Taxi Pre-Registration Form!</p>
        <p>Stay tuned for updates or visit our office at Norsu-BSC.</p>
        <button onclick="returnToIndex()">Done</button>
    </div>
</div>

</body>
</html>
