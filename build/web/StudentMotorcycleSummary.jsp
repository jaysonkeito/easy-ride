<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page session="true" %>

<%
    String pickup = (String) session.getAttribute("PickUpLocation");
    String dropoff = (String) session.getAttribute("DropOffLocation");
    Double distance = (Double) session.getAttribute("distance");
    Double fee = (Double) session.getAttribute("fee");
    String riderName = (String) session.getAttribute("riderName");
    Double estimatedTime = (Double) session.getAttribute("estimatedTime");
    DecimalFormat df = new DecimalFormat("#.##");

    String formattedTime = "Calculating...";
    if (estimatedTime != null) {
        int minutes = (int)Math.round(estimatedTime);
        if (minutes >= 60) {
            int hours = minutes / 60;
            int remMinutes = minutes % 60;
            formattedTime = hours + " hr" + (hours > 1 ? "s" : "") + (remMinutes > 0 ? " " + remMinutes + " min" : "");
        } else {
            formattedTime = minutes + " min";
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Ride Summary</title>
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

        .summary-panel {
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

        .summary-header {
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

        .summary-header a {
            color: white;
            text-decoration: none;
            font-weight: normal;
            font-size: 14px;
            cursor: pointer;
        }

        .summary-body {
            padding: 20px;
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .summary-item {
            font-size: 14px;
        }

        .summary-item strong {
            display: block;
            color: #444;
            margin-bottom: 5px;
        }

        select, textarea {
            width: 100%;
            padding: 10px;
            font-size: 14px;
            border-radius: 6px;
            border: 1px solid #ccc;
            box-sizing: border-box;
        }

        textarea {
            resize: none;
        }

        .confirm-button {
            /*background: linear-gradient(to right, #0072BB, #80D0C7);*/
            background-color: #0072BB;
            border: none;
            padding: 12px;
            color: white;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            border-radius: 6px;
            transition: background-color 0.3s ease;
        }

        .confirm-button:hover {
            background-color: #0072BB;
        }

        .back-link {
            display: block;
            margin-top: 10px;
            text-align: center;
            color: #007bff;
            text-decoration: none;
            font-size: 13px;
        }

        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="summary-panel">
    <div class="summary-header">
        <span>Ride Summary</span>
        <a href="StudentAvailableRidersServlet">Cancel</a>
    </div>
    

    <form action="StudentConfirmRideServlet" method="post" class="summary-body">
        <input type="hidden" name="studentId" value="<%= session.getAttribute("studentId") %>">
        <input type="hidden" name="fullName" value="<%= session.getAttribute("fullName") %>">
        <input type="hidden" name="studentProfilePicture" value="<%= session.getAttribute("studentProfilePicture") %>">
        <div class="summary-item">
            <strong>Pick-Up Location</strong>
            <%= pickup != null ? pickup : "Not selected" %>
        </div>

        <div class="summary-item">
            <strong>Drop-Off Location</strong>
            <%= dropoff != null ? dropoff : "Not selected" %>
        </div>

        <div class="summary-item">
            <strong>Estimated Distance</strong>
            <%= distance != null ? df.format(distance) + " km" : "Calculating..." %>
        </div>

        <div class="summary-item">
            <strong>Estimated Time</strong>
            <%= formattedTime %>
        </div>

        <div class="summary-item">
            <strong>Estimated Fee</strong>
            ₱<%= fee != null ? df.format(fee) : "Calculating..." %>
        </div>

        <div class="summary-item">
            <strong>Driver</strong>
            <%= riderName != null ? riderName : "Not selected" %>
        </div>

        <div class="summary-item">
            <strong>Payment Method</strong>
            <select name="paymentMethod" required>
                <option value="" disabled selected>Select payment method</option>
                <option value="Cash">Cash</option>
                <option value="GCash">GCash</option>
            </select>
        </div>

        <div class="summary-item">
            <strong>Notes</strong>
            <textarea name="notes" rows="3" placeholder="Add pickup details or directions here..."></textarea>
        </div>

        <button type="button" class="confirm-button" onclick="showModal()">Confirm Ride</button>
        <a class="back-link" href="MotorcyclePanel.jsp">← Go Back to Location Selection</a>
        
        <!-- Ride Agreement Modal -->
        <div id="agreementModal" style="display: none; position: fixed; top: 0; left: 0;
            width: 100%; height: 100%; background-color: rgba(0,0,0,0.6); 
            justify-content: center; align-items: center; z-index: 1000;">

            <div style="background: white; padding: 20px; border-radius: 10px; width: 90%; max-width: 400px;">
                <h3>Ride Agreement</h3>
                <p style="font-size: 14px; line-height: 1.5;">
                    By confirming this ride, you agree to be available at the pickup location, pay the agreed fee, 
                    and comply with community guidelines. Cancellation without reason may result in account penalties.
                </p>
                <div style="margin-top: 20px; display: flex; justify-content: space-between;">
                    <button onclick="submitForm()" style="background: #28a745; color: white; padding: 10px 20px; border: none; border-radius: 6px;">I Agree</button>
                    <button onclick="closeModal()" style="background: #dc3545; color: white; padding: 10px 20px; border: none; border-radius: 6px;">Cancel</button>
                </div>
            </div>
        </div>

    </form>
</div>
<script>
    function showModal() {
        document.getElementById('agreementModal').style.display = 'flex';
    }

    function closeModal() {
        document.getElementById('agreementModal').style.display = 'none';
    }

    function submitForm() {
        document.querySelector("form").submit();
    }
</script>

</body>
</html>
