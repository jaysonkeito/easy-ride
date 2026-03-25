<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Driver Sign-Up | EasyRide</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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

        .container {
            background: rgba(255, 255, 255, 0.9);
            padding: 30px;
            margin: 20px;
            border-radius: 10px;
            max-width: 500px;
            width: 90%;
            box-shadow: 0 4px 10px rgba(0,0,0,0.3);
        }

        h2 {
            margin: 20px 0;
            font-size: 20px;
            color: #333;
            text-align: center;
        }

        .progress {
            text-align: center;
            font-weight: bold;
            margin-bottom: 20px;
            color: #555;
        }

        .form-page {
            display: none;
        }

        .form-page p {
            text-align: center;
        }

        .form-page.active {
            display: block;
        }

        label {
            display: block;
            margin-top: 10px;
            font-weight: bold;
            color: #333;
        }

        input[type="text"],
        input[type="email"],
        input[type="tel"],
        select {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        .checkbox-group {
            margin-top: 10px;
        }

        .checkbox-group input {
            margin-right: 5px;
        }

        .button-group {
            margin-top: 20px;
            display: flex;
            justify-content: space-between;
        }

        button {
            padding: 10px 20px;
            background: #1976d2;
            border: none;
            color: white;
            border-radius: 5px;
            cursor: pointer;
        }

        button:disabled {
            background: #ccc;
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
<div class="container">
    <form id="signupForm" action="DriverApplicationFormServlet" method="post">
        <!-- Page 1 -->
        <div class="form-page active" id="page1">
            <h2>EasyRide Motorcycle Taxi Pre-Registration</h2>
            <div class="progress">Page 1 of 4</div>
            <p>Welcome! Thank you for signing up.</p>

            <label>Service you want to join:</label>
            <div class="checkbox-group">
                <input type="checkbox" name="service" value="Motorcycle Taxi" required> Motorcycle Taxi
            </div>

            <label>Base Office:</label>
            <div class="checkbox-group">
                <input type="checkbox" name="baseOffice" value="Norsu - BSC" required> Norsu - BSC
            </div>

            <div class="button-group">
                <button type="button" onclick="nextPage()">Next</button>
            </div>
        </div>

        <!-- Page 2 -->
        <div class="form-page" id="page2">
            <h2>Personal Information</h2>
            <div class="progress">Page 2 of 4</div>

            <label>First Name</label>
            <input type="text" name="firstName" required>

            <label>Last Name</label>
            <input type="text" name="lastName" required>

            <label>Mobile Number</label>
            <input type="tel" name="mobileNumber" required>

            <label>Email Address</label>
            <input type="email" name="email" required>

            <label>City / Province / Town</label>
            <select name="city" required>
                <option value="">-- Select City --</option>
                <option value="Negros Oriental - Basay">Negros Oriental - Basay</option>
                <option value="Negros Oriental - Bayawan">Negros Oriental - Bayawan</option>
                <option value="Negros Oriental - Santa Catalina">Negros Oriental - Santa Catalina</option>
            </select>

            <div class="button-group">
                <button type="button" onclick="prevPage()">Back</button>
                <button type="button" onclick="nextPage()">Next</button>
            </div>
        </div>

        <!-- Page 3 -->
        <div class="form-page" id="page3">
            <h2>Requirements</h2>
            <div class="progress">Page 3 of 4</div>

            <ul>
                <li>Age: 20 - 55 Years Old</li>
                <li>1. Professional Driver's License</li>
                <li>2. NBI Clearance</li>
                <li>3. Police or Barangay Clearance</li>
                <li>4. Vehicle OR/CR</li>
                <li>5. Vehicle to be used:
                    <ul>
                        <li>Motorcycle (Any Brand)</li>
                        <li>Not older than 7 years</li>
                        <li>Piston Displacement: 110 to 160cc</li>
                        <li>Vehicle Photos (Front, Side, Back)</li>
                    </ul>
                </li>
                <li>Other conditions:
                    <ul>
                        <li>Borrowed/Rented: Valid ID + Authorization Letter</li>
                        <li>Second Hand: ID + Notarized Deed of Sale</li>
                        <li>Repossessed: Repo Sales Form/Certificate</li>
                    </ul>
                </li>
                <li>Age 50+: Fit to Work Medical Certificate</li>
                <li>Android Phone (Version 8.0 and up)</li>
                <li>App to download: EasyRide Driver App</li>
            </ul>

            <div class="button-group">
                <button type="button" onclick="prevPage()">Back</button>
                <button type="submit">Submit</button>
            </div>
        </div>

        <!-- Page 4 -->
        <div class="form-page" id="page4">
            <h2>Thank You!</h2>
            <div class="progress">Page 4 of 4</div>

            <p>Thank you for filling out our EasyRide Motorcycle Taxi Pre-Registration Form!</p>
            <p>Stay tuned for updates or visit our office at Norsu-BSC.</p>
        </div>
    </form>
</div>

<script>
    let currentPage = 1;
    const totalPages = 4;

    function showPage(pageNum) {
        for (let i = 1; i <= totalPages; i++) {
            document.getElementById('page' + i).classList.remove('active');
        }
        document.getElementById('page' + pageNum).classList.add('active');
        currentPage = pageNum;
    }

    function nextPage() {
        const currentFormPage = document.getElementById('page' + currentPage);
        const inputs = currentFormPage.querySelectorAll('input, select');

        for (let input of inputs) {
            if (input.type === "checkbox" && input.hasAttribute('required') && !input.checked) {
                alert("Please check all required options before continuing.");
                return;
            }
            if ((input.type === "text" || input.type === "email" || input.type === "tel" || input.tagName.toLowerCase() === "select") && input.hasAttribute('required') && !input.value) {
                alert("Please fill in all required fields before continuing.");
                return;
            }
        }

        if (currentPage < totalPages) {
            showPage(currentPage + 1);
        }
    }

    function prevPage() {
        if (currentPage > 1) {
            showPage(currentPage - 1);
        }
    }

    showPage(currentPage);
</script>
</body>
</html>
