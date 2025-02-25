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
    if (response.status == 404) {
      document.querySelector(".error").style.display = "block";
      document.querySelector(".weather").style.display = "none";
    } else {
      let data = await response.json();

      console.log(data);

      document.querySelector(".city").innerHTML = data.name;
      document.querySelector(".temp").innerHTML = Math.round(data.main.temp) + "°C";
      document.querySelector(".humidity").innerHTML = data.main.humidity + "%";
      document.querySelector(".wind").innerHTML = data.wind.speed + " km/h";

      let currentTime = data.dt;
      let sunriseTime = data.sys.sunrise;
      let sunsetTime = data.sys.sunset;
      let isNight = currentTime < sunriseTime || currentTime > sunsetTime;

      if (data.weather[0].main === "Clouds") {
        weatherApp.weatherIcon.src = isNight
          ? "images/cloudy (1).png"
          : "images/cloudy.png";
      } else if (data.weather[0].main === "Clear") {
        weatherApp.weatherIcon.src = isNight
          ? "images/crescent-moon.png"
          : "images/sun.png";
      } else if (data.weather[0].main === "Snow") {
        weatherApp.weatherIcon.src = isNight
          ? "images/snow (1).png"
          : "images/snow.png";
      } else if (data.weather[0].main === "Rain") {
        weatherApp.weatherIcon.src = isNight
          ? "images/thunder.png"
          : "images/storm.png";
      } else if (data.weather[0].main === "Mist") {
        weatherApp.weatherIcon.src = isNight
          ? "images/mist.png"
          : "images/mist.png";
      }
      document.querySelector(".weather").style.display = "block";
      document.querySelector(".error").style.display = "none";
    }
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
