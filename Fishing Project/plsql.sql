--Weather app PL/SQL

declare
   v_city         varchar2(100);
   v_api_key      varchar2(50) := '635f8fdd8d70254799ea58b5997f56d7';
   v_url          varchar2(4000);
   v_response     clob;
   v_temp         number;
   v_humidity     number;
   v_wind_speed   number;
   v_weather_des  varchar2(100);
   v_current_time number;
   v_sunrise_time number;
   v_sunset_time  number;
   v_icon         varchar2(100);
begin
   v_url := 'https://api.openweathermap.org/data/2.5/weather?units=metric&q='
            || v_city
            || '&appid='
            || v_api_key;
   v_response := null;
   begin
      select utl_http.request(v_url)
        into v_response
        from dual;
   exception
      when others then
         dbms_output.put_line('Error fetching weather data.');
         return;
   end;


   v_temp := json_value(v_response,
           '$.main.temp');
   v_humidity := json_value(v_response,
           '$.main.humidity');
   v_wind_speed := json_value(v_response,
           '$.wind.speed');
   v_weather_desc := json_value(v_response,
           '$.weather[0].main');
   v_current_time := json_value(v_response,
           '$.dt');
   v_sunrise_time := json_value(v_response,
           '$.sys.sunrise');
   v_sunset_time := json_value(v_response,
           '$.sys.sunset');
   if v_current_time < v_sunrise_time
   or v_current_time > v_sunset_time then
      if v_weather_desc = 'Clouds' then
         v_icon := 'images/cloudy_night.png';
      elsif v_weather_desc = 'Clear' then
         v_icon := 'images/moon.png';
      elsif v_weather_desc = 'Snow' then
         v_icon := 'images/snow_night.png';
      elsif v_weather_desc = 'Rain' then
         v_icon := 'images/rain_night.png';
      else
         v_icon := 'images/mist_night.png';
      end if;
   else
      if v_weather_desc = 'Clouds' then
         v_icon := 'images/cloudy.png';
      elsif v_weather_desc = 'Clear' then
         v_icon := 'images/sun.png';
      elsif v_weather_desc = 'Snow' then
         v_icon := 'images/snow.png';
      elsif v_weather_desc = 'Rain' then
         v_icon := 'images/rain.png';
      else
         v_icon := 'images/mist.png';
      end if;
   end if;


   dbms_output.put_line('City: ' || v_city);
   dbms_output.put_line('Temperature: '
                        || v_temp
                        || '°C');
   dbms_output.put_line('Humidity: '
                        || v_humidity
                        || '%');
   dbms_output.put_line('Wind Speed: '
                        || v_wind_speed
                        || ' km/h');
   dbms_output.put_line('Weather: ' || v_weather_desc);
   dbms_output.put_line('Icon: ' || v_icon);
exception
   when others then
      dbms_output.put_line('An error occurred.');
end; 


--Fishing app PL/SQL


create table fishing_trips (
   id           number primary key,
   trip_date    date not null,
   location     varchar2(100) not null,
   fish_species varchar2(100) not null,
   weight       number not null,
   image_url    varchar2(500)
);

create sequence fishing_seq start with 1 increment by 1;

create or replace procedure add_fishing_trip (
   p_date      date,
   p_location  varchar2,
   p_specie    varchar2,
   p_weight    number,
   p_image_url varchar2
) is
begin
   insert into fishing_trips (
      id,
      trip_date,
      location,
      fish_species,
      weight,
      image_url
   ) values ( fishing_seq.nextval,
              p_date,
              p_location,
              p_specie,
              p_weight,
              p_image_url );
   commit;
   dbms_output.put_line('Fishing trip added successfully.');
end add_fishing_trip;

create or replace procedure display_fishing_trip as
begin
   for i in (
      select *
        from fishing_trips
       order by trip_date desc
   ) loop
      dbms_output.put_line(i.trip_date
                           || ' - '
                           || i.location
                           || ' caught a '
                           || i.fish_species
                           || ' weighing '
                           || i.weight
                           || ' kg');
      dbms_output.put_line('Image: ' || i.image_url);
   end loop;
exception
   when no_data_found then
      dbms_output.put_line('No fishing trips found.');
end display_fishing_trip;


create or replace package del_fishing_trip is
   procedure del_trip (
      p_id number
   );
   procedure del_all_trips;
end del_fishing_trip;

create or replace package body del_fishing_trip is

   procedure del_trip (
      p_id number
   ) is
   begin
      delete from fishing_trips
       where id = p_id;

      commit;
      dbms_output.put_line('Fishing trip deleted successfully!');
   end del_trip;

   procedure del_all_trips is
   begin
      delete from fishing_trips;

      commit;
      dbms_output.put_line('All fishing trips have been cleared.');
   end del_all_trips;

end del_fishing_trip;