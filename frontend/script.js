async function updateCounter() {
    try {
        const response = await fetch("https://5oyiwm4qk0.execute-api.us-east-2.amazonaws.com/count");
        const data = await response.json();
        document.getElementById("counter").innerText = data.count;
    } catch (error) {
        console.error("Error fetching counter:", error);
    }
}

updateCounter();