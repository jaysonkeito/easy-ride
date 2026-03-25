<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Motorcycle Ride</title>
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

        .panel {
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
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 18px;
            font-weight: bold;
        }
        
        .panel-header a {
            color: white;
            text-decoration: none;
            font-weight: normal;
            font-size: 14px;
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .header-left a {
            color: white;
            text-decoration: none;
            font-size: 15px;
            font-weight: bold;
        }

        .panel-body {
            padding: 20px;
            display: flex;
            flex-direction: column;
            gap: 18px;
        }

        .location-box {
            border: 2px solid #13547a;
            border-radius: 8px;
            padding: 15px;
            background-color: #f7f7f7;
            transition: transform 0.2s ease;
        }

        .location-box:hover {
            transform: scale(1.01);
        }

        .location-box p {
            margin: 0;
            font-size: 14px;
            color: #555;
            margin-bottom: 6px; /* Add this for spacing below the label */
        }

        .location-box strong {
            font-size: 16px;
            color: #000;
            display: block;
        }


        @media (max-width: 480px) {
            .panel {
                max-width: 100%;
                border-radius: 10px;
                height: 100vh;
            }

            .panel-header {
                font-size: 18px;
                padding: 15px 20px;
            }

            .panel-body {
                padding: 15px;
                gap: 12px;
            }

            .location-box {
                padding: 12px;
            }

            .location-box p {
                font-size: 15px;
                margin-bottom: 10px;
            }

            .location-box strong {
                font-size: 15px;
            }
        }
    </style>
</head>

<body>
    <div class="panel">
        <div class="panel-header">
            <div class="header-left">
                <a href="StudentClearLocationSessionServlet" >&#10005;</a>
                <span>Motorcycle</span>
            </div>
           
            <a href="StudentAvailableRidersServlet">Done</a>
        </div>

        <div class="panel-body">
            <a href="StudentMotorcyclePickUpPanel.html" style="text-decoration: none;">
                <div class="location-box">
                    <p>Pickup</p>
                    <strong>
                        <%
                            String PickUpLocation = (String) session.getAttribute("PickUpLocation");
                            if (PickUpLocation != null) {
                                out.print(PickUpLocation);
                            } else {
                                out.print("Search Pickup Location");
                            }
                        %>
                    </strong>
                </div>
            </a>


            <a href="StudentMotorcycleDropOffPanel.html" style="text-decoration: none;">
                <div class="location-box">
                    <p>Drop Off</p>
                    <strong>
                        <%
                            String DropOffLocation = (String) session.getAttribute("DropOffLocation");
                            if (DropOffLocation != null) {
                                out.print(DropOffLocation);
                            } else {
                                out.print("Search Drop-off Location");
                            }
                        %>
                    </strong>
                </div>
            </a>
        </div>

    </div>
</body>
<script>
    const params = new URLSearchParams(window.location.search);
    const message = params.get("message");
    if (message) {
        alert(decodeURIComponent(message));
    }
</script>
</html>
