
const elements = {
    cityInput: document.querySelector('.city-input'),
    searchBtn: document.querySelector('.search-btn'),
    notFound: document.querySelector('.not-found'),
    apiKey: "635f8fdd8d70254799ea58b5997f56d7",
    searchCitySection: document.querySelector('.search-city'),
    weatherInfoSection: document.querySelector('.weather-info'),
    countryTxt: document.querySelector('.country-txt'),
    tempTxt: document.querySelector('.temp-txt'),
    conditionTxt: document.querySelector('.conditions-txt'),
    humidityValueTxt: document.querySelector('.humidity-value-txt'),
    windValueTxt: document.querySelector('.wind-value-txt'),
    weatherSummaryImg: document.querySelector('.weather-summary-img'),
    currentDateTxt: document.querySelector('.current-date-txt'),
    forecastItemsContainer: document.querySelector('.forecast-items-container')
};

elements.searchBtn.addEventListener('click', () => {
    if (elements.cityInput.value.trim() !== '') {
        updateWeatherInfo(elements.cityInput.value);
        elements.cityInput.value = '';
        elements.cityInput.blur();
    }
});

elements.cityInput.addEventListener('keydown', (event) => {
    if (event.key === 'Enter' && elements.cityInput.value.trim() !== '') {
        updateWeatherInfo(elements.cityInput.value);
        elements.cityInput.value = '';
        elements.cityInput.blur();
    }
});

async function getFetchData(endPoint, city) {
    const apiUrl = `https://api.openweathermap.org/data/2.5/${endPoint}?q=${city}&appid=${elements.apiKey}&units=metric`;
    const response = await fetch(apiUrl);
    return response.json();
}

function getWeatherIcon(id, sunrise, sunset) {
    const currentTime = new Date().getTime() / 1000;// Get the current time in seconds
    const isNight = currentTime < sunrise || currentTime > sunset; // Check if it's night

    // If it's night, return moon icon or cloud icon
    if (isNight) {
        if (id === 800) return 'moon.png';
        return 'cloud.png';
    }

    // If it's daytime, proceed with your existing logic
    console.log(id);
    if (id <= 232) return 'thunderstorm.svg';
    if (id <= 321) return 'drizzle.svg';
    if (id <= 531) return 'rain.svg';
    if (id <= 622) return 'snow.svg';
    if (id <= 701) return 'atmosphere.svg';
    if (id <= 500) return 'light-rain.png';
    if (id === 800) return 'clear.svg';
    return 'cloud.png';
}

function getCurrentDate() {
    const currentDate = new Date();
    const options = { weekday: 'short', day: '2-digit', month: 'short' };
    return currentDate.toLocaleDateString('en-GB', options);
}

async function updateWeatherInfo(city) {
    const weatherData = await getFetchData('weather', city);

    if (weatherData.cod !== 200) {
        showDisplaySection(elements.notFound);
        return;
    }

    console.log(weatherData);

    const {
        name,
        sys: { country, sunrise, sunset },
        main: { temp, humidity },
        weather: [{ id, main }],
        wind: { speed },
    } = weatherData;

    // Ensure elements exist before setting textContent
    if (elements.countryTxt) elements.countryTxt.textContent = `${name}, ${country}`;
    if (elements.tempTxt) elements.tempTxt.textContent = `${Math.round(temp)}°C`;
    if (elements.conditionTxt) elements.conditionTxt.textContent = main;
    if (elements.humidityValueTxt) elements.humidityValueTxt.textContent = `${humidity}%`;
    if (elements.windValueTxt) elements.windValueTxt.textContent = `${speed} km/h`;

    if (elements.currentDateTxt) elements.currentDateTxt.textContent = getCurrentDate();
    if (elements.weatherSummaryImg) elements.weatherSummaryImg.src = `assets/weather/${getWeatherIcon(id, sunrise, sunset)}`;

    await updateForecastInfo(city);

    showDisplaySection(elements.weatherInfoSection);
}

async function updateForecastInfo(city) {
    const forecastData = await getFetchData('forecast', city);
    const todayDate = new Date().toISOString().split('T')[0]; // Get today's date

    elements.forecastItemsContainer.innerHTML = '';

    // Create an object to group forecasts by day
    const dailyForecasts = {};

    forecastData.list.forEach(forecastWeather => {
        const forecastDate = forecastWeather.dt_txt.split(' ')[0];  // Extract date part
        if (!dailyForecasts[forecastDate]) {
            dailyForecasts[forecastDate] = forecastWeather;  // Store the first forecast of each day
        }
    });

    // Get the keys of the grouped daily forecasts, filter out today's forecast, and limit to 5 days
    const forecastDates = Object.keys(dailyForecasts)
        .filter(date => date !== todayDate)  // Remove today's forecast
        .slice(0, 5);  // Limit to 5 days

    // For each of the 5 days, update the forecast item
    forecastDates.forEach(date => {
        const weatherData = dailyForecasts[date];
        updateForecastItems(weatherData);
    });
}

function updateForecastItems(weatherData) {
    const {
        dt_txt: date,
        main: { temp },
        weather: [{ id }],

    } = weatherData;

    const dateTaken = new Date(date);
    const dateOptions = { day: '2-digit', month: 'short' };
    const dateResult = dateTaken.toLocaleDateString('en-US', dateOptions);

    const forecastItem = `
        <div class="forecast-item">
            <h5 class="forecast-item-date regular-txt">${dateResult}</h5>
            <img src="assets/weather/${getWeatherIcon(id)}" class="forecast-item-img">
            <h5 class="forecast-item-temp">${Math.round(temp)} ℃</h5>
        </div>
    `;

    elements.forecastItemsContainer.insertAdjacentHTML('beforeend', forecastItem);
}

function showDisplaySection(section) {
    [elements.weatherInfoSection, elements.searchCitySection, elements.notFound].forEach(sec => {
        if (sec) sec.style.display = 'none';
    });

    if (section) section.style.display = 'flex';
}

