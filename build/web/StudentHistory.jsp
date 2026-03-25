<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String studentId = (String) session.getAttribute("studentId");
    if (studentId == null) {
        response.sendRedirect("StudentSignIn.jsp"); // or whatever your login page is
        return;
    }
    %>
<!DOCTYPE html>
<html>
<head>
    <title>Ride History</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">

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

        .panel-body {
            padding: 15px;
            overflow-y: auto;
            flex: 1; /* allow this to expand and scroll */
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
            padding: 15px;
            overflow-y: auto;
        }

        .ride-card {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
            padding: 15px;
            margin-bottom: 20px;
            cursor: pointer;
        }

        .ride-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-weight: bold;
            font-size: 14px;
        }

        .status {
            background-color: #ccc;
            color: white;
            border-radius: 5px;
            padding: 2px 8px;
            font-size: 12px;
        }

        .status.CANCELLED {
            background-color: red;
        }

        .status.COMPLETED {
            background-color: #28a745;
        }

        .ride-info {
            margin-top: 10px;
            font-size: 13px;
        }

        .ride-info i {
            margin-right: 5px;
        }

        .ride-footer {
            background: #eee;
            padding: 10px;
            margin-top: 10px;
            display: flex;
            justify-content: space-between;
            font-weight: bold;
            font-size: 13px;
        }

        .label-value {
            display: flex;
            align-items: flex-start;
            margin-bottom: 5px;
            font-size: 13px;
            line-height: 1.4;
        }
        .label {
            min-width: 90px; /* You can adjust this width */
            font-weight: bold;
        }
        .value {
            flex: 1;
            word-wrap: break-word;
        }


        /* MODAL STYLING */
        .modal {
            display: none;
            position: fixed;
            z-index: 10;
            left: 0; top: 0;
            width: 100%; height: 100%;
            background: rgba(0,0,0,0.4);
        }

        .modal-content {
            background-color: white;
            margin: 10% auto;
            padding: 20px;
            width: 90%;
            max-width: 400px;
            border-radius: 10px;
        }

        .modal-header {
            font-weight: bold;
            margin-bottom: 10px;
        }

        .modal-footer {
            text-align: right;
            margin-top: 10px;
        }

        .close-btn {
            background-color: #13547a;
            color: white;
            padding: 6px 10px;
            border: none;
            border-radius: 6px;
        }
        
        @media (max-width: 480px) {
            .panel-header {
                font-size: 16px;
                padding: 15px 15px;
            }
        }
    </style>
</head>
<body>

<div class="panel">
    <div class="panel-header">
        <div class="header-left">
            <span>History</span>
        </div>

        <a href="StudentRideStatus.jsp">Return</a>
    </div>

    <div class="panel-body">
        <%
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            boolean hasRides = false;

            try {
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/EasyRide", "root", "");

                String query = "SELECT * FROM rides WHERE StudentID = ? AND Status IN ('Cancelled', 'Rated') ORDER BY DateTime DESC";
                ps = conn.prepareStatement(query);
                ps.setString(1, studentId);
                rs = ps.executeQuery();

                SimpleDateFormat dateFormat = new SimpleDateFormat("MMM d (E) hh:mm a");

                while (rs.next()) {
                    hasRides = true;
                    String txn = rs.getString("TransactionNumber");
                    String date = dateFormat.format(rs.getTimestamp("DateTime"));
                    String pickup = rs.getString("PickUpLocation");
                    String dropoff = rs.getString("DropOffLocation");
                    String rider = rs.getString("RiderName");
                    String photo = rs.getString("RidersImagePath");
                    double fee = rs.getDouble("Fee");
                    String status = rs.getString("Status");
                    String displayStatus = status.equalsIgnoreCase("Rated") ? "Completed" : status;

                    double distance = rs.getDouble("Distance");
                    String payment = rs.getString("PaymentMethod");
        %>
            <div class="ride-card" onclick="showModal('<%=txn%>', '<%=rider%>', '<%=pickup%>', '<%=dropoff%>', '<%=date%>', '<%=fee%>', '<%=status%>', '<%=distance%>', '<%=payment%>', '<%=photo != null ? photo.replace("'", "\\'") : "" %>')">
                <div class="ride-header">
                    <div><%=txn%></div>
                    <div class="status <%=displayStatus.toUpperCase()%>"><%=displayStatus.toUpperCase()%></div>
                </div>
                <div class="ride-info">
                    <p><i>📅</i> <%=date%></p>
                    <div class="label-value">
                        <span class="label">Pickup</span>
                        <span class="value"><%=pickup%></span>
                    </div>
                    <div class="label-value">
                        <span class="label">Drop-off</span>
                        <span class="value"><%=dropoff%></span>
                    </div>
                </div>
                <div class="ride-footer">
                    <span>Motorcycle Taxi</span>
                    <span><%=rider%></span>
                    <span>Php <%=String.format("%.0f", fee)%></span>
                </div>
            </div>
        <%
                } // end while

                if (!hasRides) {
        %>
            <div style="text-align: center; color: #555; padding: 30px;">
                <strong>No past rides found.</strong><br>
                Once you complete or cancel a ride, it will appear here.
            </div>
        <%
                }

            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            }
        %>

    </div>
</div>

<!-- MODAL -->
<div id="rideModal" class="modal">
    <div class="modal-content">
        <div style="display: flex; justify-content: space-between; align-items: center; font-weight: bold; font-size: 16px; margin-bottom: 5px;">
            <span>Transaction No.</span>
            <span id="modalTxn"></span>
        </div>

        <hr>

        <div style="display: flex; align-items: center; gap: 10px; margin: 10px 0;">
            <img id="modalPhoto" src="images/riders/Default.png" alt="Driver Photo"
                 style="width: 60px; height: 60px; object-fit: cover; border-radius: 10px; border: 1px solid #ccc;">
            <strong id="modalRider" style="font-size: 15px;"></strong>
        </div>
        <hr>

        <div style="display: flex; justify-content: space-between; font-size: 14px;">
            <span>Motorcycle Taxi</span>
            <span id="modalStatus" class="status">--</span>

        </div>
        <div id="modalDate" style="font-size: 13px; margin-bottom: 10px;"></div>
        <hr>

        <div class="label-value" style="margin-bottom: 6px;">
            <span class="label">Total</span>
            <span class="value" id="modalFee">₱0.00</span>
        </div>
        <div class="label-value" style="margin-bottom: 6px;">
            <span class="label">Distance</span>
            <span class="value" id="modalDistance">-- km</span>
        </div>
        <div class="label-value" style="margin-bottom: 6px;">
            <span class="label">Payment</span>
            <span class="value" id="modalPayment">--</span> <!-- ✅ Added ID -->
        </div>


        <hr>

        <div class="label-value">
            <span class="label">Pickup</span>
            <span class="value" id="modalPickup"></span>
        </div>
        <div class="label-value">
            <span class="label">Drop-off</span>
            <span class="value" id="modalDropoff"></span>
        </div>
        <hr>

        <div class="modal-footer" style="display: flex; justify-content: space-between;">
            <button class="close-btn" onclick="document.getElementById('rideModal').style.display='none'">Close</button>
            <!--<button class="close-btn" style="background-color: #1a2cff;" onclick="rebookRide()">Rebook</button>-->
            
        </div>
    </div>
</div>




<script>
    function showModal(txn, rider, pickup, dropoff, datetime, fee, status, distance, payment, photoURL) {
        document.getElementById('modalTxn').innerText = txn;
        document.getElementById('modalRider').innerText = rider;
        document.getElementById('modalPickup').innerText = pickup;
        document.getElementById('modalDropoff').innerText = dropoff;
        document.getElementById('modalDate').innerText = datetime;

        const roundedFee = parseFloat(fee).toFixed(2);
        const roundedDistance = parseFloat(distance).toFixed(2);

        document.getElementById('modalFee').innerText = '₱' + roundedFee;
        document.getElementById('modalDistance').innerText = roundedDistance + ' km';
        document.getElementById('modalPayment').innerText = payment;

        // Handle status display (convert Rated -> Completed)
        let displayStatus = status;
        if (status.toLowerCase() === 'rated') {
            displayStatus = 'Completed';
        }

        const modalStatus = document.getElementById('modalStatus');
        modalStatus.innerText = displayStatus.toUpperCase();
        modalStatus.classList.remove('CANCELLED', 'COMPLETED');
        modalStatus.classList.add(displayStatus.toUpperCase());

        document.getElementById('modalPhoto').src = photoURL || 'images/riders/Default.png';
        document.getElementById('rideModal').style.display = 'block';
    }


    





</script>

</body>
</html>
