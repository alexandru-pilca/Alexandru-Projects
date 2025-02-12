CREATE TABLE FISHING_USERS(
    user_id number primary key,
    first_name VARCHAR2(100),
    last_name VARCHAR2(100),
    email VARCHAR2(200),
    phone VARCHAR2(15)
);


   CREATE PROCEDURE INS_FISHING_USERS (
    p_user_id IN FISHING_USERS.user_id%TYPE,
    p_first_name IN FISHING_USERS.first_name%TYPE,
    p_last_name IN FISHING_USERS.last_name%TYPE,
    p_email IN FISHING_USERS.email%TYPE,
    p_phone IN FISHING_USERS.phone%TYPE
);
is 
Begin
insert into FISHING_USERS( user_id, first_name, last_name, email, phone)
values (p_user_id, p_first_name, p_last_name, p_email, p_phone);

end INS_FISHING_USERS;

CREATE SEQUENCE fishing_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;