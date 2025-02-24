const apiKey = "635f8fdd8d70254799ea58b5997f56d7";
const apiUrl = "https://api.openweathermap.org/data/2.5/weather?units=metric&q=";
const searchBox = document.querySelector(".search input");
const searchBtn = document.querySelector(".search button");
const weatherIcon = document.querySelector(".weather-icon");

async function checkWeather(city) {
    try {
        const response = await fetch(apiUrl + city + `&appid=${apiKey}`);
        let data = await response.json();


        console.log(data);

        document.querySelector(".city").innerHTML = data.name;
        document.querySelector(".temp").innerHTML = Math.round(data.main.temp) + "°C";
        document.querySelector(".humidity").innerHTML = data.main.humidity + "%";
        document.querySelector(".wind").innerHTML = data.wind.speed + " km/h";

        if (data.weather[0].main === "Clouds") {
            weatherIcon.src = "image/sun with cloud.webp";
        } else if (data.weather[0].main === "Clear") {
            weatherIcon.src = "image/sun.png";
        } else if (data.weather[0].main === "Snow") {
            weatherIcon.src = "image/snow.webp";
        } else if (data.weather[0].main === "Rain") {
            weatherIcon.src = "image/weather07-512.webp";
        }
    } 
};

searchBtn.addEventListener("click", () => {
    if (searchBox.value.trim() !== "") {
        checkWeather(searchBox.value);
    } else {
        alert("Please enter a city name.");
    }
});