let weatherApp = {
  apiKey: "635f8fdd8d70254799ea58b5997f56d7",
  apiUrl: "https://api.openweathermap.org/data/2.5/weather?units=metric&q=",
  searchBox: document.querySelector(".search input"),
  searchBtn: document.querySelector(".search button"),
  weatherIcon: document.querySelector(".weather-icon"),
};

async function checkWeather(city) {
  try {
    let response = await fetch(
      weatherApp.apiUrl + city + `&appid=${weatherApp.apiKey}`
    );
    let data = await response.json();

    if (response.status == 404 || data.cod === "404") {
      document.querySelector(".error").style.display = "block";
      document.querySelector(".weather").style.display = "none";
      return;
    }

    console.log(data);

    document.querySelector(".city").innerHTML = data.name;
    document.querySelector(".temp").innerHTML =
      Math.round(data.main.temp) + "°C";
    document.querySelector(".humidity").innerHTML = data.main.humidity + "%";
    document.querySelector(".wind").innerHTML = data.wind.speed + " km/h";

    if (data.weather[0].main === "Clouds") {
      weatherApp.weatherIcon.src = "images/cloud.png";
    } else if (data.weather[0].main === "Clear") {
      weatherApp.weatherIcon.src = "images/sun.png";
    } else if (data.weather[0].main === "Snow") {
      weatherApp.weatherIcon.src = "images/snow.png";
    } else if (data.weather[0].main === "Rain") {
      weatherApp.weatherIcon.src = "images/rain.png";
    }

    document.querySelector(".weather").style.display = "block";
    document.querySelector(".error").style.display = "none";
  } catch (error) {
    console.error("Error fetching weather data:", error);
  }
}

function handleSearch() {
  if (weatherApp.searchBox.value.trim() !== "") {
    checkWeather(weatherApp.searchBox.value);
  } else {
    alert("Please enter a city name.");
  }
}

weatherApp.searchBtn.addEventListener("click", handleSearch);

weatherApp.searchBox.addEventListener("keydown", function (event) {
  if (event.key === "Enter") {
    event.preventDefault();
    handleSearch();
  }
});
