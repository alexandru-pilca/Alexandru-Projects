document.addEventListener("DOMContentLoaded", () => {
    const tripDate = document.getElementById("tripDate");
    const locationInput = document.getElementById("location");
    const fishSpecies = document.getElementById("fishSpecies");
    const weightInput = document.getElementById("weight");
    const addTripBtn = document.getElementById("addTrip");
    const tripList = document.getElementById("tripList");
    const clearTripsBtn = document.getElementById("clearTrips");
    const fishImageContainer = document.getElementById("fishImageContainer");

    let trips = JSON.parse(localStorage.getItem("trips")) || [];

    function saveTrips() {
        localStorage.setItem("trips", JSON.stringify(trips));
    }

    function displayTrips() {
        tripList.innerHTML = "";
        trips.forEach((trip, index) => {
            const li = document.createElement("li");
            li.innerHTML = `
                <div class="trip-info">
                    <span>${trip.date} - <b>${trip.location}</b> caught a <b>${trip.fish}</b> weighing <b>${trip.weight} kg</b></span>
                    <img src="${trip.image}" alt="${trip.fish}" class="fish-icon">
                </div>
                <button class="delete-btn" onclick="deleteTrip(${index})">
    <img src="fishImages/recycle-bin.png" alt="Delete" width="25" height="25">
</button>

            `;
            tripList.appendChild(li);
        });
    }

    window.deleteTrip = function (index) {
        trips.splice(index, 1);
        saveTrips();
        displayTrips();
    };

    addTripBtn.addEventListener("click", () => {
        if (!tripDate.value || !locationInput.value.trim() || !fishSpecies.value || !weightInput.value) {
            alert("Please fill in all fields!");
            return;
        }

        const selectedOption = fishSpecies.options[fishSpecies.selectedIndex];
        const imgSrc = selectedOption.getAttribute("data-img");

        trips.push({
            date: tripDate.value,
            location: locationInput.value.trim(),
            fish: fishSpecies.value,
            weight: weightInput.value,
            image: imgSrc,
        });

        saveTrips();
        displayTrips();

        tripDate.value = "";
        locationInput.value = "";
        fishSpecies.value = "";
        weightInput.value = "";
        fishImageContainer.innerHTML = "";
    });

    clearTripsBtn.addEventListener("click", () => {
        if (confirm("Are you sure you want to clear all trips?")) {
            trips = [];
            saveTrips();
            displayTrips();
        }
    });

    fishSpecies.addEventListener("change", function () {
        const selectedOption = this.options[this.selectedIndex];
        const imgSrc = selectedOption.getAttribute("data-img");

        fishImageContainer.innerHTML = ""; 
        const fishImage = document.createElement("img");
        fishImage.src = imgSrc;
        fishImage.alt = selectedOption.text;
        fishImage.width = 400;
        fishImage.height = 200;
        fishImageContainer.appendChild(fishImage);
    });

    displayTrips();
});

