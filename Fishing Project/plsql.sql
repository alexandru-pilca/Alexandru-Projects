--Weather app PL/SQL

CREATE TABLE weather_data (
    city VARCHAR2(100) primary key,
    country VARCHAR2(10),
    temperature NUMBER(5,2),
    weather_condition VARCHAR2(50),
    humidity NUMBER(5,2),
    wind_speed NUMBER(5,2),
    recorded_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT weather_pk PRIMARY KEY (city, recorded_at)	
);


create or replace procedure ins_weather_data (
     p_city VARCHAR2,
      p_country VARCHAR2,
     p_temp number,
     p_weather_con VARCHAR2,
     p_humidity number,
     p_wind number,
     p_rec_time TIMESTAMP
) is

begin

insert into weather_data( city, country, temperature, weather_condition, humidity, wind_speed, recorded_at)
values (p_city, p_country, p_temp, p_weather_con, p_humidity, p_wind, p_rec_time);

commit;

DBMS_OUTPUT.PUT_LINE('Weather data inserted for ' || p_city || ' successfully.');

end ins_weather_data;





create or replace procedure get_weather_data (p_city VARCHAR2) is
v_count NUMBER;
begin 

SELECT COUNT(*) INTO v_count FROM weather_data WHERE city = p_city;

    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No weather data found for ' || p_city || '.');
        RETURN;
    END IF;

for rec in (select * from weather_data where city = p_city) loop
DBMS_OUTPUT.PUT_LINE('City: ' || rec.city || ', Country: ' || rec.country);
        DBMS_OUTPUT.PUT_LINE('Temperature: ' || rec.temperature || '°C');
        DBMS_OUTPUT.PUT_LINE('Condition: ' || rec.weather_condition);
        DBMS_OUTPUT.PUT_LINE('Humidity: ' || rec.humidity || '%');
        DBMS_OUTPUT.PUT_LINE('Wind Speed: ' ||rec.wind_speed || ' km/h');
        DBMS_OUTPUT.PUT_LINE('Recorded At: ' || TO_CHAR(rec.recorded_at, 'YYYY-MM-DD HH24:MI:SS'));

        end loop;

        end get_weather_data;






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



alter table fishing_trips add Additional_Info varchar2(500);

create or replace procedure ins_info(
   p_id number,
   p_info varchar2
) IS
begin 
   update fishing_trips
      set Additional_Info = p_info
    where id = p_id;
   commit;
   dbms_output.put_line('Additional info added successfully.');
end ins_info;  