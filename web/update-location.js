function updateDriverLocation() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function (position) {
            const latitude = position.coords.latitude;
            const longitude = position.coords.longitude;
            const username = document.getElementById("driverUsername").value;

            fetch("DriverUpdateLocationServlet", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: `username=${encodeURIComponent(username)}&latitude=${latitude}&longitude=${longitude}`
            }).then(response => {
                if (!response.ok) {
                    console.error("Failed to update location");
                }
            }).catch(err => {
                console.error("Error sending location:", err);
            });
        }, function (error) {
            console.error("Geolocation error:", error.message);
        });
    } else {
        console.warn("Geolocation is not supported by this browser.");
    }
}

// Call on page load
window.onload = updateDriverLocation;
// Repeat every 15 seconds
setInterval(updateDriverLocation, 15000);
