//Object to store all the elements
const fishingElements = {
  trips: JSON.parse(localStorage.getItem("trips")) || [],
  tripDate: document.getElementById("tripDate"),
  locationInput: document.getElementById("location"),
  fishSpecies: document.getElementById("fishSpecies"),
  weightInput: document.getElementById("weight"),
  baitInput: document.getElementById("bait"),
  addTripBtn: document.getElementById("addTrip"),
  tripList: document.getElementById("tripList"),
  clearTripsBtn: document.getElementById("clearTrips"),
  tripCount: document.getElementById("tripCount"),
  commentInput: document.getElementById("commentInput"),
  saveCommentBtn: document.getElementById("saveComment"),
  popup: document.getElementById("popup-1"),
  imageInput: document.getElementById("imageUpload"),
};

let currentTripIndex = null; // Track which trip is being edited

// Function to save trips to localStorage
function saveTrips() {
  localStorage.setItem("trips", JSON.stringify(fishingElements.trips));
}

// Function to display trips in the list
function displayTrips() {
  fishingElements.tripList.innerHTML = "";
  fishingElements.trips.forEach((trip, index) => {
    const li = document.createElement("li");
    li.innerHTML = `
          <div class="trip-info">
              <span>${trip.date} - <b>${trip.location}</b> caught a <b>${trip.fish}</b> weighing <b>${trip.weight} kg</b> on <b>${trip.bait}</b></span>
              <img src="${trip.uploadedImage || trip.image}" alt="${trip.fish}" class="fish-icon">
          </div>
         
          <button class="add-comment-btn" data-index="${index}">View/Add Trip Info</button>
          <button class="delete-btn" data-index="${index}">
              <img src="fishImages/recycle-bin.png" alt="Delete" width="25" height="25">
          </button>
      `;
    fishingElements.tripList.appendChild(li);
  });
 
  // Update the trip count
  fishingElements.tripCount.textContent = fishingElements.trips.length;
}


// Function to capitalize the first letter of the input
function capitalizeFirstLetter(inputElement) {
  inputElement.addEventListener("input", function () {
    const value = inputElement.value;
    inputElement.value = value.charAt(0).toUpperCase() + value.slice(1);
  });
}

capitalizeFirstLetter(fishingElements.locationInput);
capitalizeFirstLetter(fishingElements.baitInput);

// Function to toggle popup
function togglePopup() {
  fishingElements.popup.style.display =
    fishingElements.popup.style.display === "block" ? "none" : "block";
}

// Event listener to open popup for a specific trip
fishingElements.tripList.addEventListener("click", (e) => {
  if (e.target.classList.contains("add-comment-btn")) {
    currentTripIndex = e.target.dataset.index;
    fishingElements.commentInput.value = fishingElements.trips[currentTripIndex].comment || "";
    togglePopup();
  }
});

// Event listener for saving a comment
fishingElements.saveCommentBtn.addEventListener("click", () => {
  if (currentTripIndex !== null) {
    fishingElements.trips[currentTripIndex].comment = fishingElements.commentInput.value.trim();
    saveTrips();
    displayTrips();
    togglePopup();
  }
});

// Event listener for adding a new trip
fishingElements.addTripBtn.addEventListener("click", () => {
  if (!fishingElements.tripDate.value || !fishingElements.locationInput.value.trim() ||
    !fishingElements.fishSpecies.value || !fishingElements.weightInput.value ||
    !fishingElements.baitInput.value.trim()) {
    alert("Please fill in all fields!");
    return;
  }



  const selectedOption = fishingElements.fishSpecies.options[fishingElements.fishSpecies.selectedIndex];
  const imgSrc = selectedOption.getAttribute("data-img");
  
  // Check if an image was uploaded if not use the default image
  let uploadedImage = "";

  if (fishingElements.imageInput.files.length > 0) {
      const reader = new FileReader();
      reader.onload = function (e) {
          uploadedImage = e.target.result;
          saveTrip(imgSrc, uploadedImage);
      };
      reader.readAsDataURL(fishingElements.imageInput.files[0]);
  } else {
      saveTrip(imgSrc, uploadedImage);
  }
});

// Function to save the trip to the trips array
function saveTrip(imgSrc, uploadedImage) {
  fishingElements.trips.push({
      date: fishingElements.tripDate.value,
      location: fishingElements.locationInput.value.trim(),
      fish: fishingElements.fishSpecies.value,
      weight: fishingElements.weightInput.value,
      bait: fishingElements.baitInput.value,
      image: imgSrc,
      uploadedImage: uploadedImage || "",
  });

  saveTrips();
  displayTrips();



  // Reset input fields
  fishingElements.tripDate.value = "";
  fishingElements.locationInput.value = "";
  fishingElements.fishSpecies.value = "";
  fishingElements.weightInput.value = "";
  fishingElements.baitInput.value = "";
  fishingElements.imageInput.value = "";
};

// Event listener for deleting a trip
fishingElements.tripList.addEventListener("click", (e) => {
  if (e.target.closest(".delete-btn")) {
    const index = e.target.closest(".delete-btn").dataset.index;
    fishingElements.trips.splice(index, 1);
    saveTrips();
    displayTrips();
  }
});

// Event listener for clearing all trips
fishingElements.clearTripsBtn.addEventListener("click", () => {
  if (confirm("Are you sure you want to clear all trips?")) {
    fishingElements.trips = [];
    saveTrips();
    displayTrips();
  }
});

// Display trips when the page loads
document.addEventListener("DOMContentLoaded", displayTrips);


// Add bullet points when pressing Enter key in the comment input
document.getElementById("commentInput").addEventListener("keydown", function (event) {
  if (event.key === "Enter") {
    event.preventDefault(); // Prevents default new line behavior
    this.value += "\n• "; // Adds a bullet point at the start of the new paragraph
  }
});

// Add bullet points when pasting text in the comment input
document.getElementById("commentInput").addEventListener("input", function () {
  if (this.value.length === 1 && this.value !== "•") {
    this.value = "• " + this.value;
  }
});

// Close popup if clicking outside of it
document.addEventListener("click", (e) => {
  if (fishingElements.popup.style.display === "block" && !fishingElements.popup.contains(e.target) && !fishingElements.tripList.contains(e.target)) {
    togglePopup();
  }
});

// Prevent the popup from closing when clicking inside the popup
fishingElements.popup.addEventListener("click", (e) => {
  e.stopPropagation();
});

