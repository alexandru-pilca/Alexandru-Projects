let weatherApp = {
     apiKey : "635f8fdd8d70254799ea58b5997f56d7",
 apiUrl : "https://api.openweathermap.org/data/2.5/weather?units=metric&q=",
 searchBox : document.querySelector(".search input"),
 searchBtn : document.querySelector(".search button"),
 weatherIcon : document.querySelector(".weather-icon"),
}

async function checkWeather(city) {
    try {
        const response = await fetch(weatherApp.apiUrl + city + `&appid=${weatherApp.apiKey}`);
        let data = await response.json();


        console.log(data);

        document.querySelector(".city").innerHTML = data.name;
        document.querySelector(".temp").innerHTML = Math.round(data.main.temp) + "°C";
        document.querySelector(".humidity").innerHTML = data.main.humidity + "%";
        document.querySelector(".wind").innerHTML = data.wind.speed + " km/h";

        if (data.weather[0].main === "Clouds") {
            weatherApp.weatherIcon.src = "image/sun with cloud.webp";
        } else if (data.weather[0].main === "Clear") {
            weatherApp.weatherIcon.src = "image/sun.png";
        } else if (data.weather[0].main === "Snow") {
            weatherApp.weatherIcon.src = "image/snow.webp";
        } else if  (data.weather[0].main === "Rain") {
            weatherApp.weatherIcon.src = "image/weather07-512.webp";
        }
    } 
}

weatherApp.searchBtn.addEventListener("click", function() {
    if (weatherApp.searchBox.value.trim() !== "") {
        checkWeather(weatherApp.searchBox.value);
    } else {
        alert("Please enter a city name.");
    }
});