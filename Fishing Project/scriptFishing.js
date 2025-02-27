const fishingElements = {
  trips: JSON.parse(localStorage.getItem("trips")) || [],
  tripDate: document.getElementById("tripDate"),
  locationInput: document.getElementById("location"),
  fishSpecies: document.getElementById("fishSpecies"),
  weightInput: document.getElementById("weight"),
  addTripBtn: document.getElementById("addTrip"),
  tripList: document.getElementById("tripList"),
  clearTripsBtn: document.getElementById("clearTrips"),
  fishImageContainer: document.getElementById("fishImageContainer"),
  tripCount: document.getElementById("tripCount"),
  baitInput: document.getElementById("bait"),
   
};

document.addEventListener("DOMContentLoaded", () => {

  // Function to save trips to localStorage
  function saveTrips() {
    try {
      localStorage.setItem("trips", JSON.stringify(fishingElements.trips));
    } catch (e) {
      console.error("Could not save trips to localStorage", e);
    }
  }

  // Function to display trips in the list
  function displayTrips() {
    fishingElements.tripList.innerHTML = "";
    fishingElements.trips.forEach((trip, index) => {
      const li = document.createElement("li");
      li.innerHTML = `
        <div class="trip-info">
          <span>${trip.date} - <b>${trip.location}</b> caught a <b>${trip.fish}</b> weighing <b>${trip.weight} kg</b> on <b>${trip.bait}</b></span>
          <img src="${trip.image}" alt="${trip.fish}" class="fish-icon">
        </div>
        <button class="delete-btn" data-index="${index}">
          <img src="fishImages/recycle-bin.png" alt="Delete" width="25" height="25">
        </button>
      `;
      fishingElements.tripList.appendChild(li);
    });
    fishingElements.tripCount.textContent = fishingElements.trips.length;
  }

  // Function to capitalize the first letter of input fields
  function capitalizeFirstLetter(inputElement) {
    inputElement.addEventListener("input", function () {
      const value = inputElement.value;
      inputElement.value = value.charAt(0).toUpperCase() + value.slice(1);
    });
  }

  // Apply the capitalizeFirstLetter function to the input fields
  capitalizeFirstLetter(fishingElements.locationInput);
  capitalizeFirstLetter(fishingElements.baitInput);

  // Event listener for delete buttons
  fishingElements.tripList.addEventListener("click", (e) => {
    if (e.target.closest(".delete-btn")) {
      const index = e.target.closest(".delete-btn").dataset.index;
      fishingElements.trips.splice(index, 1);
      saveTrips();
      displayTrips();
    }
  });

  // Event listener for adding a new trip
  fishingElements.addTripBtn.addEventListener("click", () => {
    if (
      !fishingElements.tripDate.value ||
      !fishingElements.locationInput.value.trim() ||
      !fishingElements.fishSpecies.value ||
      !fishingElements.weightInput.value ||
      !fishingElements.baitInput.value.trim()
    ) {
      alert("Please fill in all fields!");
      return;
    }

    const selectedOption =
      fishingElements.fishSpecies.options[
      fishingElements.fishSpecies.selectedIndex
      ];
    const imgSrc = selectedOption.getAttribute("data-img");

    fishingElements.trips.push({
      date: fishingElements.tripDate.value,
      location: fishingElements.locationInput.value.trim(),
      fish: fishingElements.fishSpecies.value,
      weight: fishingElements.weightInput.value,
      image: imgSrc,
      bait: fishingElements.baitInput.value,
    });

    saveTrips();
    displayTrips();

    fishingElements.tripDate.value = "";
    fishingElements.locationInput.value = "";
    fishingElements.fishSpecies.value = "";
    fishingElements.weightInput.value = "";
    fishingElements.baitInput.value = "";
  });

  // Event listener for clearing all trips
  fishingElements.clearTripsBtn.addEventListener("click", () => {
    if (confirm("Are you sure you want to clear all trips?")) {
      fishingElements.trips = [];
      saveTrips();
      displayTrips();
    }
  });

  // Display trips when the page is loaded
  displayTrips();

});



