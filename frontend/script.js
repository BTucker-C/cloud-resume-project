async function updateCounter() {
    try {
        const response = await fetch("YOUR_API_URL_HERE/count");
        const data = await response.json();
        document.getElementById("counter").innerText = data.count;
    } catch (error) {
        console.error("Error fetching counter:", error);
    }
}

updateCounter();