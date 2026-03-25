<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%
    String fullName = (String) session.getAttribute("fullName");
    String studentId = (String) session.getAttribute("studentId");

    if (studentId == null) {
        response.sendRedirect("StudentSignIn.jsp");
        return;
    }
    
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Inbox - EasyRide</title>
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
            min-height: 91vh;
        }

        .header {
            position: sticky;
            top: 0;
            z-index: 10;
            /*background: linear-gradient(to right, #0072BB, #80D0C7);*/
            background-color: #0072BB;
            padding: 15px 20px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-direction: row;
            font-size: 18px;
            font-weight: bold;
        }

        .header a {
            color: white;
            text-decoration: none;
            font-size: 14px;
        }

        .section {
            width: 100%;
            max-width: 700px;
            padding: 0 15px 20px 15px;
            box-sizing: border-box;
        }

        .message-card {
            background: #ffffff;
            padding: 15px 20px;
            margin-bottom: 15px;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            cursor: pointer;
            position: relative;
            transition: transform 0.3s ease, opacity 0.3s ease;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0; top: 0;
            width: 100%; height: 100%;
            background: rgba(0,0,0,0.6);
            justify-content: center;
            align-items: center;
        }

        .modal-content {
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            width: 90%;
            max-width: 400px;
        }

        .modal-content h3 {
            margin-top: 0;
        }

        .modal-content button {
            margin-top: 15px;
            padding: 8px 16px;
            border: none;
            background: #dc3545;
            color: #fff;
            border-radius: 6px;
            cursor: pointer;
        }

        .modal-content button.close {
            background: #6c757d;
            margin-right: 10px;
        }

        .message-card h3 {
            margin-top: 0;
            font-size: 16px;
        }

        .message-card p {
            font-size: 13px;
            margin: 5px 0;
        }

        /* Bottom Navbar */
        .navbar {
            width: 100%;
            max-width: 480px;
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

        @media (max-width: 480px) {
            .header {
                font-size: 16px;
                padding: 15px 15px;
            }

            .panel {
                min-height: 83vh;
                border-radius: 10px;
            }

            .inbox-empty {
                font-size: 16px;
                padding: 15px;
                margin-top: 60px;
            }
        }
    </style>
</head>
<body>

<div class="panel">
    <div class="header">
        Inbox
    </div>

    <div class="section">
        <%
            try {
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql:///EasyRide", "root", "");

                String sql = "SELECT * FROM studentsinbox WHERE StudentID = ? ORDER BY SentTime DESC";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, studentId);
                rs = stmt.executeQuery();

                boolean hasMessages = false;
                while (rs.next()) {
                    hasMessages = true;
                    int msgId = rs.getInt("Id");
                    String subject = rs.getString("Subject");
                    String message = rs.getString("Message");
                    Timestamp sentTime = rs.getTimestamp("SentTime");
                    String timeFormatted = new java.text.SimpleDateFormat("MMM dd, yyyy HH:mm").format(sentTime);
        %>
        <div class="message-card"
             data-id="<%= msgId %>"
             data-subject="<%= subject %>"
             data-message="<%= message %>"
             data-time="<%= timeFormatted %>"
             data-sender="Admin">
            <h3><%= subject %></h3>
            <p><strong>From:</strong> Admin</p>
        </div>
        <%
                }
                if (!hasMessages) {
        %>
        <p style="color: black; text-align: center;">No messages found.</p>
        <%
                }
            } catch (Exception e) {
                out.println("<p style='color:white;'>Error: " + e.getMessage() + "</p>");
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        %>
    </div>

    <!-- Modal -->
    <div class="modal" id="messageModal">
        <div class="modal-content">
            <h3 id="modalSubject"></h3>
            <p><strong>From:</strong> <span id="modalSender"></span></p>
            <p id="modalMessage"></p>
            <p style="font-size: 12px; color: #777;" id="modalTime"></p>
            <div style="text-align: right;">
                <button class="close" onclick="closeModal()">Close</button>
                <button onclick="deleteMessage()">Delete</button>
            </div>
        </div>
    </div>
</div>

<div class="navbar">
    <a href="StudentDashboard.jsp" class="nav-item">
        <img src="resources/Home.png" alt="Home" />
        <span>Home</span>
    </a>
    <a href="StudentRideStatus.jsp" class="nav-item">
        <img src="resources/RideStatus.png" alt="Ride Status" />
        <span>Ride Status</span>
    </a>
    <a href="StudentInbox.jsp" class="nav-item active">
        <img src="resources/Inbox.png" alt="Inbox" />
        <span>Inbox</span>
    </a>
    <a href="StudentAccount.jsp" class="nav-item">
        <img src="resources/Account.png" alt="Account" />
        <span>Account</span>
    </a>
</div>

</body>
<script>
    const cards = document.querySelectorAll('.message-card');
    let selectedId = null;

    cards.forEach(card => {
        card.addEventListener('click', () => {
            selectedId = card.dataset.id;
            document.getElementById('modalSubject').innerText = card.dataset.subject;
            document.getElementById('modalSender').innerText = card.dataset.sender;
            document.getElementById('modalMessage').innerText = card.dataset.message;
            document.getElementById('modalTime').innerText = card.dataset.time;
            document.getElementById('messageModal').style.display = 'flex';
        });

        let startX = 0;
        card.addEventListener('touchstart', e => {
            startX = e.touches[0].clientX;
        });
        card.addEventListener('touchend', e => {
            let endX = e.changedTouches[0].clientX;
            if (endX - startX > 100) {
                deleteMessageById(card.dataset.id, card);
            }
        });
    });

    function closeModal() {
        document.getElementById('messageModal').style.display = 'none';
    }

    function deleteMessage() {
        if (selectedId) {
            deleteMessageById(selectedId);
        }
    }

    function deleteMessageById(id, cardElement = null) {
        if (confirm('Are you sure you want to delete this message?')) {
            fetch('StudentDeleteMessageServlet?id=' + id, { method: 'GET' })
                .then(() => {
                    if (cardElement) {
                        cardElement.style.opacity = '0';
                        setTimeout(() => cardElement.remove(), 300);
                    } else {
                        location.reload();
                    }
                    closeModal();
                })
                .catch(err => alert('Delete failed.'));
        }
    }
</script>
</html>
