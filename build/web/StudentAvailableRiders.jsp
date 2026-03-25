<%@ page import="java.util.List" %>
<%@ page import="com.easyride.model.RegisteredDriver" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Available Riders</title>
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

        .available-header {
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

        .available-header a {
            color: white;
            text-decoration: none;
            font-weight: normal;
            font-size: 14px;
        }

        .available-body {
            padding: 20px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .rider-card {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 0 6px rgba(0, 0, 0, 0.2);
            padding: 12px;
            display: flex;
            gap: 12px;
            align-items: center;
            position: relative;
            cursor: pointer;
        }

        .rider-card img {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            object-fit: cover;
        }

        .rider-info {
            flex-grow: 1;
            font-size: 18px;
        }

        .view-profile {
            background: none;
            border: none;
            color: #13547a;
            font-weight: bold;
            cursor: pointer;
            text-decoration: underline;
        }

        /* Modal Styling */
        .modal {
            display: none;
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(0,0,0,0.6);
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }

        .modal-content {
            background: #fff;
            padding: 25px 20px;
            border-radius: 12px;
            width: 90%;
            max-width: 400px;
            text-align: left; /* Align content to left */
            position: relative;
            display: flex;
            flex-direction: column;
            align-items: center;
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
        }

        .modal-content img {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 15px;
            border: 3px solid #13547a;
        }

        .modal-content h2 {
            color: #13547a;
            font-size: 22px;
            font-weight: bold;
            margin: 0 0 10px;
            text-align: center;
        }

        .modal-content p {
            font-size: 16px;
            margin: 6px 0;
            width: 100%;
            text-align: left;
            color: #333;
        }

        .close {
            position: absolute;
            top: 10px; right: 15px;
            font-size: 20px;
            font-weight: bold;
            cursor: pointer;
            color: #333;
        }

        .choose-btn {
            background: #13547a;
            color: white;
            border: none;
            padding: 12px;
            margin-top: 20px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
        }
        .choose-btn:hover {
            background-color: #0e3a5f;
        }

        .no-riders {
            color: #333;
            text-align: center;
            padding: 10px;
            background: white;
            border-radius: 6px;
        }
    </style>
</head>
<body>

<div class="panel">
    <div class="available-header">
        <span>Motorcycle Rider</span>
        <a href="StudentMotorcyclePanel.jsp">Cancel</a>
    </div>

    <div class="available-body">
        <%
            List<RegisteredDriver> riders = (List<RegisteredDriver>) request.getAttribute("riders");
            if (riders != null && !riders.isEmpty()) {
                int maxDrivers = Math.min(riders.size(), 10);
                for (int i = 0; i < maxDrivers; i++) {
                    RegisteredDriver r = riders.get(i);
        %>
            <div class="rider-card" onclick="location.href='StudentRiderProfile.jsp?riderId=<%= r.getId() %>'">
                <img src="<%= r.getProfilePicture() %>" alt="Profile Image">
                <div class="rider-info">
                    <strong><%= r.getFullName() %></strong><br>
                    <small>Driver ID: <%= r.getDriverUniqueID() %></small><br>
                    <small>Distance from Pick-up: <%= String.format("%.2f", r.getDistance()) %>km</small><br>
                </div>
                <button class="view-profile" 
                    onclick="event.stopPropagation(); 
                    showProfileModal(
                        '<%= r.getId() %>', 
                        '<%= r.getProfilePicture() %>', 
                        '<%= r.getFullName() %>', 
                        '<%= r.getRatings() %>', 
                        '<%= r.getService() %>', 
                        '<%= r.getMobileNumber() %>', 
                        '<%= r.getEmail() %>', 
                        '<%= r.getDriverUniqueID() %>', 
                        '<%= r.getCity() %>', 
                        '<%=  String.format("%.2f", r.getDistance()) %>'
                    )">View</button>
            </div>
        <%
                } // end for loop
            } else {
        %>
            <div class="no-riders">No riders available at the moment.</div>
        <%
            }
        %>

    </div>
</div>

<!-- Modal -->
<div id="riderModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="document.getElementById('riderModal').style.display='none'">&times;</span>
        <img id="modalImage" src="" alt="Rider">
        <h2 id="modalName"></h2>
        <p><strong>Driver ID:</strong> <span id="modalDriverID"></span></p>
        <p><strong>Rating:</strong> <span id="modalRating"></span> ⭐</p>
        <p><strong>Service:</strong> <span id="modalService"></span></p>
        <p><strong>Phone:</strong> <span id="modalPhone"></span></p>
        <p><strong>Email:</strong> <span id="modalEmail"></span></p>
        <p><strong>City:</strong> <span id="modalCity"></span></p>
        <p><strong>Distance from Pick-up:</strong> <span id="modalDistance">km</span></p>
        <form action="StudentMotorcycleSummaryServlet" method="post" style="width: 100%;">
            <input type="hidden" name="riderId" id="chosenRiderId">
            <button type="submit" class="choose-btn">Choose This Rider</button>
        </form>
    </div>
</div>

<script>
    function showProfileModal(id, imagePath, fullName, rating, service, phone, email, driverId, city, distance) {
        document.getElementById('modalImage').src = imagePath;
        document.getElementById('modalName').textContent = fullName;
        document.getElementById('modalRating').textContent = rating;
        document.getElementById('modalService').textContent = service;
        document.getElementById('modalPhone').textContent = phone;
        document.getElementById('modalEmail').textContent = email;
        document.getElementById('modalDriverID').textContent = driverId;
        document.getElementById('modalCity').textContent = city;
        document.getElementById('modalDistance').textContent = distance;
        document.getElementById('chosenRiderId').value = id;
        document.getElementById('riderModal').style.display = 'flex';
    }

    window.onclick = function(event) {
        let modal = document.getElementById('riderModal');
        if (event.target === modal) {
            modal.style.display = "none";
        }
    }
</script>

</body>
</html>
