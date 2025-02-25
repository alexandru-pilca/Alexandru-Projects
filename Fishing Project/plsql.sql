--Weather app PL/SQL

DECLARE
v_city VARCHAR2(100);
v_api_key VARCHAR2(50) := '635f8fdd8d70254799ea58b5997f56d7';
v_url VARCHAR2(4000);
v_response CLOB;

v_temp NUMBER;
v_humidity number;
v_wind_speed number;
v_weather_des VARCHAR2(100);
v_current_time number;
v_sunrise_time number;
v_sunset_time number;
v_icon VARCHAR2(100);

BEGIN
    v_url := 'https://api.openweathermap.org/data/2.5/weather?units=metric&q=' || v_city || '&appid=' || v_api_key;
    v_response := null;

   BEGIN
    SELECT UTL_HTTP.REQUEST(v_url) INTO v_response FROM DUAL;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error fetching weather data.');
      RETURN;
  END;

  
  v_temp := JSON_VALUE(v_response, '$.main.temp');
  v_humidity := JSON_VALUE(v_response, '$.main.humidity');
  v_wind_speed := JSON_VALUE(v_response, '$.wind.speed');
  v_weather_desc := JSON_VALUE(v_response, '$.weather[0].main');
  v_current_time := JSON_VALUE(v_response, '$.dt');
  v_sunrise_time := JSON_VALUE(v_response, '$.sys.sunrise');
  v_sunset_time := JSON_VALUE(v_response, '$.sys.sunset');

  
  IF v_current_time < v_sunrise_time OR v_current_time > v_sunset_time THEN
    IF v_weather_desc = 'Clouds' THEN
      v_icon := 'images/cloudy_night.png';
    ELSIF v_weather_desc = 'Clear' THEN
      v_icon := 'images/moon.png';
    ELSIF v_weather_desc = 'Snow' THEN
      v_icon := 'images/snow_night.png';
    ELSIF v_weather_desc = 'Rain' THEN
      v_icon := 'images/rain_night.png';
    ELSE
      v_icon := 'images/mist_night.png';
    END IF;
  ELSE
    IF v_weather_desc = 'Clouds' THEN
      v_icon := 'images/cloudy.png';
    ELSIF v_weather_desc = 'Clear' THEN
      v_icon := 'images/sun.png';
    ELSIF v_weather_desc = 'Snow' THEN
      v_icon := 'images/snow.png';
    ELSIF v_weather_desc = 'Rain' THEN
      v_icon := 'images/rain.png';
    ELSE
      v_icon := 'images/mist.png';
    END IF;
  END IF;

  
  DBMS_OUTPUT.PUT_LINE('City: ' || v_city);
  DBMS_OUTPUT.PUT_LINE('Temperature: ' || v_temp || '°C');
  DBMS_OUTPUT.PUT_LINE('Humidity: ' || v_humidity || '%');
  DBMS_OUTPUT.PUT_LINE('Wind Speed: ' || v_wind_speed || ' km/h');
  DBMS_OUTPUT.PUT_LINE('Weather: ' || v_weather_desc);
  DBMS_OUTPUT.PUT_LINE('Icon: ' || v_icon);

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred.');
END; 


--Fishing app PL/SQL


CREATE TABLE FISHING_TRIPS (
    ID NUMBER PRIMARY KEY,
    TRIP_DATE DATE NOT NULL,
    LOCATION VARCHAR2(100) NOT NULL,
    FISH_SPECIES VARCHAR2(100) NOT NULL,
    WEIGHT NUMBER NOT NULL,
    IMAGE_URL VARCHAR2(500)
);

create SEQUENCE fishing_seq start with 1 increment by 1;

create or replace procedure add_fishing_trip(
    p_date date,
    p_location VARCHAR2,
    p_specie VARCHAR2,
    p_weight number,
    p_image_url VARCHAR2
)IS

BEGIN
    INSERT into FISHING_TRIPS (id, TRIP_DATE, LOCATION, FISH_SPECIES, WEIGHT, IMAGE_URL)
    values (fishing_seq.nextval, p_date, p_location, p_specie, p_weight, p_image_url);
  COMMIT;
    DBMS_OUTPUT.PUT_LINE('Fishing trip added successfully.');

    end add_fishing_trip;

    create or replace procedure display_fishing_trip
    AS

    BEGIN
        FOR i in (select * from FISHING_TRIPS order by trip_date desc) LOOP
        DBMS_OUTPUT.PUT_LINE(i.TRIP_DATE || ' - ' || i.LOCATION || ' caught a ' ||
                             i.FISH_SPECIES || ' weighing ' || i.WEIGHT || ' kg');
        DBMS_OUTPUT.PUT_LINE('Image: ' || i.IMAGE_URL);
        end loop;

       EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No fishing trips found.');

        end display_fishing_trip;


        create or replace PACKAGE del_fishing_trip IS
        procedure del_trip(p_id number);
        procedure del_all_trips;
end del_fishing_trip;

create or replace package body del_fishing_trip IS

      procedure del_trip(p_id number)
      IS
      begin 
      delete from FISHING_TRIPS
      where id = p_id;

      commit;

      dbms_output.PUT_LINE('Fishing trip deleted successfully!');

      end del_trip;

      procedure del_all_trips
      IS
      BEGIN
        DELETE from FISHING_TRIPS;

        commit; 

        DBMS_OUTPUT.PUT_LINE('All fishing trips have been cleared.');

        end del_all_trips;

        end del_fishing_trip;

