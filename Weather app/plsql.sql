DECLARE
    apiKey VARCHAR2(50) := '635f8fdd8d70254799ea58b5997f56d7';
    apiUrl VARCHAR2(200) := 'https://api.openweathermap.org/data/2.5/weather?units=metric&q=';
    city VARCHAR2(50) ;
    response CLOB;
    temp NUMBER;
    humidity NUMBER;
    wind_speed NUMBER;
    weather_main VARCHAR2(50);
    weather_icon VARCHAR2(200);

    BEGIN
        DBMS_OUTPUT.PUT_LINE('City: ' || city);
    DBMS_OUTPUT.PUT_LINE('Temperature: ' || temp || '°C');
    DBMS_OUTPUT.PUT_LINE('Humidity: ' || humidity || '%');
    DBMS_OUTPUT.PUT_LINE('Wind Speed: ' || wind_speed || ' km/h');

    IF weather_main = 'Clouds' THEN
        weather_icon := 'image/sun with cloud.webp';
    ELSIF weather_main = 'Clear' THEN
        weather_icon := 'image/sun.png';
    ELSIF weather_main = 'Snow' THEN
        weather_icon := 'image/snow.webp';
    ELSIF weather_main = 'Rain' THEN
        weather_icon := 'image/weather07-512.webp';
    END IF;

    DBMS_OUTPUT.PUT_LINE('Weather Icon: ' || weather_icon);
END;