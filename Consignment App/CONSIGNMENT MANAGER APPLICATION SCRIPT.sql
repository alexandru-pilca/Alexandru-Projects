CREATE TABLE CATEGORIES 
    ( 
     CATEGORY_ID   NUMBER  NOT NULL , 
     ITEM_CATEGORY VARCHAR2 (100)  NOT NULL 
    ) 
;

ALTER TABLE CATEGORIES 
    ADD CONSTRAINT CATEGORIES_PK PRIMARY KEY ( CATEGORY_ID ) ;

CREATE TABLE CONSIGNORS 
    ( 
     CONSIGNOR_ID   NUMBER  NOT NULL , 
     FIRST_NAME     VARCHAR2 (100)  NOT NULL , 
     LAST_NAME      VARCHAR2 (100)  NOT NULL , 
     PHONE_NUMBER   VARCHAR2 (15)  NOT NULL , 
     EMAIL          VARCHAR2 (100)  NOT NULL , 
     ADDRESS        VARCHAR2 (250)  NOT NULL , 
     CITY           VARCHAR2 (50) , 
     STATE          VARCHAR2 (50) , 
     ZIP_CODE       VARCHAR2 (20)  NOT NULL , 
     COUNTRY_ALPHA2 VARCHAR2 (5)  NOT NULL , 
     PHONE_PREFIX   VARCHAR2 (10) 
    ) 
;

ALTER TABLE CONSIGNORS 
    ADD CONSTRAINT CONSIGNORS_PK PRIMARY KEY ( CONSIGNOR_ID ) ;

CREATE TABLE ITEM_IMAGES 
    ( 
     IMAGE_ID           NUMBER  NOT NULL , 
     ROW_VERSION_NUMBER NUMBER , 
     FILENAME           VARCHAR2 (4000) , 
     FILE_MIMETYPE      VARCHAR2 (512) , 
     FILE_CHARSET       VARCHAR2 (512) , 
     FILE_BLOB          BLOB , 
     UPLOAD_DATE        DATE , 
     ITEM_ID            NUMBER  NOT NULL 
    ) 
;

ALTER TABLE ITEM_IMAGES 
    ADD CONSTRAINT ITEM_IMAGES_PK PRIMARY KEY ( IMAGE_ID ) ;

CREATE TABLE ITEMS 
    ( 
     ITEM_ID           NUMBER  NOT NULL , 
     ITEM              VARCHAR2 (50)  NOT NULL , 
     CONSIGNOR_ID      NUMBER  NOT NULL , 
     PRICE             NUMBER  NOT NULL , 
     DATE_ADDED        DATE  NOT NULL , 
     DESCRIPTION       VARCHAR2 (500) , 
     COMMISSION_RATE   NUMBER DEFAULT 0.5, 
     COMMISSION_AMOUNT NUMBER , 
     TRANSACTION_DATE  DATE , 
     IMAGE             BLOB , 
     MIMETYPE          VARCHAR2 (50) , 
     FILENAME          VARCHAR2 (250) , 
     CREATE_DATE       DATE , 
     SATUS             VARCHAR2 (20) , 
     ITEM_CATEGORY     VARCHAR2 (150) , 
     CATEGORY_ID       NUMBER  NOT NULL 
    ) 
;

ALTER TABLE ITEMS 
    ADD CONSTRAINT ITEMS_PK PRIMARY KEY ( ITEM_ID ) ;

CREATE TABLE PAYMENTS 
    ( 
     PAYMENT_ID   INTEGER  NOT NULL , 
     AMOUNT_PAID  NUMBER , 
     PAYMENT_DATE DATE  NOT NULL , 
     ITEM_ID      NUMBER  NOT NULL , 
     CONSIGNOR_ID NUMBER  NOT NULL 
    ) 
;

ALTER TABLE PAYMENTS 
    ADD CONSTRAINT PAYMENTS_PK PRIMARY KEY ( PAYMENT_ID ) ;

CREATE TABLE PHONE_PREFIXES 
    ( 
     COUNTRY_NAME   VARCHAR2 (100)  NOT NULL , 
     COUNTRY_ALPHA2 VARCHAR2 (5)  NOT NULL , 
     PHONE_PREFIX   VARCHAR2 (10)  NOT NULL 
    ) 
;

ALTER TABLE PHONE_PREFIXES 
    ADD CONSTRAINT PHONE_PREFIXES_PK PRIMARY KEY ( COUNTRY_ALPHA2 ) ;

ALTER TABLE CONSIGNORS 
    ADD CONSTRAINT CONSIGNORS_PHONE_PREFIXES_FK FOREIGN KEY 
    ( 
     COUNTRY_ALPHA2
    ) 
    REFERENCES PHONE_PREFIXES 
    ( 
     COUNTRY_ALPHA2
    ) 
;

ALTER TABLE ITEM_IMAGES 
    ADD CONSTRAINT ITEM_IMAGES_ITEMS_FK FOREIGN KEY 
    ( 
     ITEM_ID
    ) 
    REFERENCES ITEMS 
    ( 
     ITEM_ID
    ) 
;

ALTER TABLE ITEMS 
    ADD CONSTRAINT ITEMS_CATEGORIES_FK FOREIGN KEY 
    ( 
     CATEGORY_ID
    ) 
    REFERENCES CATEGORIES 
    ( 
     CATEGORY_ID
    ) 
;

ALTER TABLE ITEMS 
    ADD CONSTRAINT ITEMS_CONSIGNORS_FK FOREIGN KEY 
    ( 
     CONSIGNOR_ID
    ) 
    REFERENCES CONSIGNORS 
    ( 
     CONSIGNOR_ID
    ) 
;

ALTER TABLE PAYMENTS 
    ADD CONSTRAINT PAYMENTS_CONSIGNORS_FK FOREIGN KEY 
    ( 
     CONSIGNOR_ID
    ) 
    REFERENCES CONSIGNORS 
    ( 
     CONSIGNOR_ID
    ) 
;

ALTER TABLE PAYMENTS 
    ADD CONSTRAINT PAYMENTS_ITEMS_FK FOREIGN KEY 
    ( 
     ITEM_ID
    ) 
    REFERENCES ITEMS 
    ( 
     ITEM_ID
    ) 
;

 CREATE OR REPLACE FORCE EDITIONABLE VIEW "CONSIGNOR_DETAILS" ("CONSIGNOR_ID", "FIRST_NAME", "LAST_NAME", "PHONE_NUMBER", "EMAIL", "ADDRESS", "CITY", "STATE", "ZIP_CODE") AS 
  SELECT  
    CONSIGNOR_ID,
    FIRST_NAME,
    LAST_NAME,
    '(' || PHONE_PREFIX || ')' || PHONE_NUMBER AS PHONE_NUMBER, 
    EMAIL,
    ADDRESS,
    CITY,
    STATE,
    ZIP_CODE
  FROM 
    CONSIGNORS;

     CREATE OR REPLACE FORCE EDITIONABLE VIEW "CONSIGNOR_ITEMS_PAYMENTS" ("CONSIGNOR_NAME", "CONSIGNOR_ID", "ITEM", "ITEM_ID", "PRICE", "COMMISSION_AMOUNT", "AMOUNT_PAID", "PAYMENT_DATE", "PAYMENT_ID") AS 
  SELECT
    c.first_name,
    c.consignor_id,
    i.item,
    i.item_id,
    i.price,
    i.commission_amount,
    p.amount_paid,
    p.payment_date,
    p.payment_id
FROM
    consignors c
JOIN 
    items i ON c.consignor_id = i.consignor_id
FULL OUTER JOIN 
    payments p ON i.item_id = p.item_id
WHERE 
    i.commission_amount IS NOT NULL;


      CREATE OR REPLACE FORCE EDITIONABLE VIEW "CONSIGNOR_PAYMENTS_VIEW" ("CONSIGNOR_ID", "FULL_NAME", "PHONE_NUMBER", "EMAIL", "ADDRESS") AS 
  SELECT 
    CONSIGNOR_ID,
    FIRST_NAME || ' ' || LAST_NAME AS FULL_NAME,
    PHONE_PREFIX || PHONE_NUMBER AS PHONE_NUMBER,
    EMAIL,
    ADDRESS || ' ' || CITY || ' ' || STATE || ' ' || ZIP_CODE AS ADDRESS
FROM CONSIGNORS;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ITEMS_VW" ("CONSIGNOR_ID", "ITEM_ID", "ITEM", "PRICE", "DESCRIPTION", "ITEM_CATEGORY", "COMMISSION_RATE", "DATE_ADDED", "IMAGE", "MIMETYPE", "FILENAME", "CREATE_DATE", "FILE_UPLOADE") AS 
  SELECT 
    c.consignor_id,
    i.item_id,
    i.item,
    i.price,
    i.description,
    cat.item_category AS item_category, 
    TO_CHAR(i.commission_rate * 100, 'FM999990') || '%' AS commission_rate,
    i.date_added,
    sys.dbms_lob.getlength(i.image)"IMAGE",
    i.MIMETYPE,
    i.FILENAME,
    i.CREATE_DATE,
    null as FILE_UPLOADE
FROM 
    consignors c
JOIN 
    items i ON c.consignor_id = i.consignor_id
LEFT JOIN 
    categories cat ON i.category_id = cat.category_id;


      CREATE OR REPLACE FORCE EDITIONABLE VIEW "SELL_MANAGEMENT_VW" ("CHECKBOX", "FULL_NAME", "ITEM_ID", "ITEM", "TRANSACTION_DATE", "PRICE", "DESCRIPTION", "ITEM_CATEGORY", "STATUS", "COMMISSION_RATE", "COMMISSION_AMOUNT", "DATE_ADDED", "IMAGE", "MIMETYPE", "FILENAME", "CREATE_DATE") AS 
  SELECT 
    apex_item.checkbox2(1, i.item_id) AS "CHECKBOX", 
    c.first_name || ' ' || c.last_name AS full_name,
    i.item_id,
    i.item,
    i.transaction_date,
    i.price,
    i.description,
    cat.item_category AS item_category, 
    i.status,
    i.commission_rate,
    i.commission_amount,
    i.date_added,
    sys.dbms_lob.getlength(i.image) AS "IMAGE",
    i.mimetype,
    i.filename,
    i.create_date
  FROM 
    consignors c
  JOIN 
    items i ON c.consignor_id = i.consignor_id
  LEFT JOIN 
    categories cat ON i.category_id = cat.category_id;


    create or replace PACKAGE items_pkg AS
    PROCEDURE sell_item(p_item_id IN NUMBER);
    PROCEDURE return_item(p_item_id IN NUMBER);
    PROCEDURE upload_item_image(p_item_id IN NUMBER); 
    PROCEDURE delete_selected_images;
END items_pkg;
/
create or replace PACKAGE BODY items_pkg AS


    PROCEDURE sell_item(p_item_id IN NUMBER) IS
    BEGIN
        UPDATE items
        SET 
            commission_amount = price - (price * commission_rate), 
            transaction_date = SYSDATE,
            status = 'Sold' 
        WHERE 
            item_id = p_item_id;  

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'No item found for the given ID or no update was made.');
        END IF;
    END sell_item;

    PROCEDURE return_item(p_item_id IN NUMBER) IS
    BEGIN
        UPDATE items
        SET 
            transaction_date = SYSDATE,         
            commission_amount = NULL,
            status = 'Returned'  
        WHERE
            item_id = p_item_id;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'No item found for the given ID or no update was made.');
        END IF;

        DELETE FROM payments
        WHERE item_id = p_item_id;

        COMMIT;
        
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;  
            RAISE;      
    END return_item;

 PROCEDURE upload_item_image(p_item_id IN NUMBER) IS
        l_count NUMBER;
    BEGIN
        FOR c1 IN (
            SELECT * 
            FROM apex_application_temp_files
        ) LOOP
            BEGIN
                SELECT 1 INTO l_count
                FROM ITEM_IMAGES
               WHERE filename = c1.filename;
                
                CONTINUE;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
   
                    INSERT INTO ITEM_IMAGES (
                        ITEM_ID,
                        filename,
                        file_blob,
                        upload_date,
                        file_mimetype
                    ) VALUES (
                        p_item_id,
                        c1.filename,
                        c1.blob_content,
                        SYSDATE,
                        c1.mime_type
                    );
           DELETE FROM apex_application_temp_files
                               WHERE name = c1.name;         
            END;
        END LOOP;

        COMMIT;
    END upload_item_image;

    
    PROCEDURE delete_selected_images IS
        l_image_id NUMBER;
    BEGIN
        FOR i IN 1..APEX_APPLICATION.G_F01.COUNT LOOP
            l_image_id := APEX_APPLICATION.G_F01(i);
          
            DELETE FROM ITEM_IMAGES WHERE Image_ID = l_image_id;
        END LOOP;

        COMMIT;
    END delete_selected_images;

END items_pkg;
/


create or replace PACKAGE payment_pkg AS
    PROCEDURE calculate_payment_amount(
        p_price IN VARCHAR2,
        p_commission_amount IN VARCHAR2,
        p_amount_paid OUT NUMBER
    );
END payment_pkg;
/

create or replace PACKAGE BODY payment_pkg AS
    PROCEDURE calculate_payment_amount(
        p_price IN VARCHAR2,
        p_commission_amount IN VARCHAR2,
        p_amount_paid OUT NUMBER
    ) IS
        v_price NUMBER;
        v_commission NUMBER;
    BEGIN
       
        v_price := TO_NUMBER(NVL(REGEXP_REPLACE(p_price, '[^0-9.-]', ''), '0'), '9999999.99');
        v_commission := TO_NUMBER(NVL(REGEXP_REPLACE(p_commission_amount, '[^0-9.-]', ''), '0'), '9999999.99');
        
        p_amount_paid := v_price - v_commission;
    END calculate_payment_amount;
END payment_pkg;
/



create or replace TRIGGER consignors_before_insert
BEFORE INSERT ON consignors
FOR EACH ROW
BEGIN
  IF :NEW.consignor_id IS NULL THEN
    :NEW.consignor_id := consignors_seq.NEXTVAL;
  END IF;
END;
/


create or replace TRIGGER trg_auto_item_id
BEFORE INSERT ON items
FOR EACH ROW
Begin
    IF :NEW.item_id IS NULL THEN
        :NEW.item_id := items_seq.NEXTVAL;
    END IF;
END;
/

create or replace TRIGGER "item_images_FILES" 
BEFORE INSERT OR UPDATE ON item_images 
FOR EACH ROW 
BEGIN
    IF :new.IMAGE_ID IS NULL THEN
        SELECT TO_NUMBER(SYS_GUID(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') INTO :new.IMAGE_ID FROM dual;
    END IF;

    IF INSERTING THEN
        :new.row_version_number := 1;
    ELSIF UPDATING AND :new.filename IS NOT NULL AND NVL(DBMS_LOB.GETLENGTH(:new.file_blob), 0) > 15728640 THEN
        RAISE_APPLICATION_ERROR(-20000, 'The size of the uploaded file was over 15MB. Please upload a smaller sized file.');
    ELSIF UPDATING THEN
        :new.row_version_number := NVL(:old.row_version_number, 1) + 1;
    END IF;

END;
/

-- SEQUENCES:
CREATE SEQUENCE commission_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE consignor_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE category_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE item_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE payment_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE sale_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

--VALUES INSERTED IN THE PHONE PREFIXES TABLE
-- Albania
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_CODE, PHONE_PREFIX) VALUES ('Albania', 'AL', '+355');

-- Andorra
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_CODE, PHONE_PREFIX) VALUES ('Andorra', 'AD', '+376');

-- Austria
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_CODE, PHONE_PREFIX) VALUES ('Austria', 'AT', '+43');

-- Belarus
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_CODE, PHONE_PREFIX) VALUES ('Belarus', 'BY', '+375');

-- Belgium
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_CODE, PHONE_PREFIX) VALUES ('Belgium', 'BE', '+32');

-- Bosnia and Herzegovina
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_CODE, PHONE_PREFIX) VALUES ('Bosnia and Herzegovina', 'BA', '+387');

-- Bulgaria
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_CODE, PHONE_PREFIX) VALUES ('Bulgaria', 'BG', '+359');

-- Croatia
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_CODE, PHONE_PREFIX) VALUES ('Croatia', 'HR', '+385');

-- Cyprus
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_CODE, PHONE_PREFIX) VALUES ('Cyprus', 'CY', '+357');

-- Czech Republic
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_CODE, PHONE_PREFIX) VALUES ('Czech Republic', 'CZ', '+420');

-- Denmark
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_CODE, PHONE_PREFIX) VALUES ('Denmark', 'DK', '+45');

-- Estonia
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_CODE, PHONE_PREFIX) VALUES ('Estonia', 'EE', '+372');

-- Finland
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_CODE, PHONE_PREFIX) VALUES ('Finland', 'FI', '+358');

-- France
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_CODE, PHONE_PREFIX) VALUES ('France', 'FR', '+33');

-- Germany
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_CODE, PHONE_PREFIX) VALUES ('Germany', 'DE', '+49');

-- Greece
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_CODE, PHONE_PREFIX) VALUES ('Greece', 'GR', '+30');

-- Hungary
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) VALUES ('Hungary', 'HU', '+36');

-- Iceland
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) VALUES ('Iceland', 'IS', '+354');

-- Ireland
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) VALUES ('Ireland', 'IE', '+353');

-- Italy
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) VALUES ('Italy', 'IT', '+39');

-- Kosovo
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) VALUES ('Kosovo', 'XK', '+383');

-- Latvia
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) VALUES ('Latvia', 'LV', '+371');

-- Liechtenstein
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) VALUES ('Liechtenstein', 'LI', '+423');

-- Lithuania
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) VALUES ('Lithuania', 'LT', '+370');

-- Luxembourg
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) VALUES ('Luxembourg', 'LU', '+352');

-- Malta
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) VALUES ('Malta', 'MT', '+356');

-- Moldova
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) VALUES ('Moldova', 'MD', '+373');

-- Monaco
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) VALUES ('Monaco', 'MC', '+377');

-- Montenegro
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) VALUES ('Montenegro', 'ME', '+382');

-- Netherlands
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) VALUES ('Netherlands', 'NL', '+31');

-- North Macedonia
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) VALUES ('North Macedonia', 'MK', '+389');

-- Norway
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) VALUES ('Norway', 'NO', '+47');

-- Poland
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) VALUES ('Poland', 'PL', '+48');

-- Portugal
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) VALUES ('Portugal', 'PT', '+351');

-- Romania
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) VALUES ('Romania', 'RO', '+40');

-- Russia
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) VALUES ('Russia', 'RU', '+7');

-- San Marino
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) VALUES ('San Marino', 'SM', '+378');

-- Serbia
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) VALUES ('Serbia', 'RS', '+381');

-- Slovakia
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) VALUES ('Slovakia', 'SK', '+421');

-- Slovenia
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) VALUES ('Slovenia', 'SI', '+386');

-- Spain
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) VALUES ('Spain', 'ES', '+34');

-- Sweden
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) VALUES ('Sweden', 'SE', '+46');

-- Switzerland
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) VALUES ('Switzerland', 'CH', '+41');

-- Ukraine
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) VALUES ('Ukraine', 'UA', '+380');

-- United Kingdom
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) VALUES ('United Kingdom', 'GB', '+44');

-- Vatican City
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) VALUES ('Vatican City', 'VA', '+379');

-- Territories within NANP
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Bermuda', 'BM', '+1-441');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Bahamas', 'BS', '+1-242');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Barbados', 'BB', '+1-246');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Jamaica', 'JM', '+1-876');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Dominican Republic', 'DO', '+1-809, +1-829, +1-849');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Trinidad and Tobago', 'TT', '+1-868');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Cayman Islands', 'KY', '+1-345');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Anguilla', 'AI', '+1-264');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Antigua and Barbuda', 'AG', '+1-268');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Dominica', 'DM', '+1-767');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Grenada', 'GD', '+1-473');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Saint Kitts and Nevis', 'KN', '+1-869');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Saint Lucia', 'LC', '+1-758');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Saint Vincent and the Grenadines', 'VC', '+1-784');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Sint Maarten', 'SX', '+1-721');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Turks and Caicos Islands', 'TC', '+1-649');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Puerto Rico', 'PR', '+1-787, +1-939');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('U.S. Virgin Islands', 'VI', '+1-340');


-- Central America
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Belize', 'BZ', '+501');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Costa Rica', 'CR', '+506');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('El Salvador', 'SV', '+503');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Guatemala', 'GT', '+502');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Honduras', 'HN', '+504');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Nicaragua', 'NI', '+505');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Panama', 'PA', '+507');


-- South America
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Argentina', 'AR', '+54');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Bolivia', 'BO', '+591');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Brazil', 'BR', '+55');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Chile', 'CL', '+56');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Colombia', 'CO', '+57');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Ecuador', 'EC', '+593');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Guyana', 'GY', '+592');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Paraguay', 'PY', '+595');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Peru', 'PE', '+51');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Suriname', 'SR', '+597');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Uruguay', 'UY', '+598');

INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUE-- Asia

-- Afghanistan
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Afghanistan', 'AF', '+93');

-- Armenia
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Armenia', 'AM', '+374');

-- Azerbaijan
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Azerbaijan', 'AZ', '+994');

-- Bahrain
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Bahrain', 'BH', '+973');

-- Bangladesh
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Bangladesh', 'BD', '+880');

-- Bhutan
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Bhutan', 'BT', '+975');

-- Brunei
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Brunei', 'BN', '+673');

-- Cambodia
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Cambodia', 'KH', '+855');

-- China
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('China', 'CN', '+86');

-- Hong Kong
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Hong Kong', 'HK', '+852');

-- Macau
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Macau', 'MO', '+853');

-- India
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('India', 'IN', '+91');

-- Indonesia
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Indonesia', 'ID', '+62');

-- Iran
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Iran', 'IR', '+98');

-- Iraq
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Iraq', 'IQ', '+964');

-- Israel
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Israel', 'IL', '+972');

-- Japan
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Japan', 'JP', '+81');

-- Jordan
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Jordan', 'JO', '+962');

-- Kazakhstan
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Kazakhstan', 'KZ', '+7');

-- Kuwait
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Kuwait', 'KW', '+965');

-- Kyrgyzstan
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Kyrgyzstan', 'KG', '+996');

-- Laos
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Laos', 'LA', '+856');

-- Lebanon
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Lebanon', 'LB', '+961');

-- Malaysia
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Malaysia', 'MY', '+60');

-- Maldives
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Maldives', 'MV', '+960');

-- Mongolia
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Mongolia', 'MN', '+976');

-- Myanmar (Burma)
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Myanmar (Burma)', 'MM', '+95');

-- Nepal
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Nepal', 'NP', '+977');

-- North Korea
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('North Korea', 'KP', '+850');

-- Oman
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Oman', 'OM', '+968');

-- Pakistan
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Pakistan', 'PK', '+92');

-- Palestine
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Palestine', 'PS', '+970');

-- Philippines
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Philippines', 'PH', '+63');

-- Qatar
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Qatar', 'QA', '+974');

-- Saudi Arabia
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Saudi Arabia', 'SA', '+966');

-- Singapore
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Singapore', 'SG', '+65');

-- South Korea
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('South Korea', 'KR', '+82');

-- Sri Lanka
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Sri Lanka', 'LK', '+94');

-- Syria
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Syria', 'SY', '+963');

-- Taiwan
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Taiwan', 'TW', '+886');

-- Tajikistan
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Tajikistan', 'TJ', '+992');

-- Thailand
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Thailand', 'TH', '+66');

-- Timor-Leste
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Timor-Leste', 'TL', '+670');

-- Turkmenistan
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Turkmenistan', 'TM', '+993');

-- United Arab Emirates
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('United Arab Emirates', 'AE', '+971');

-- Uzbekistan
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Uzbekistan', 'UZ', '+998');

-- Vietnam
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Vietnam', 'VN', '+84');

-- Yemen
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Yemen', 'YE', '+967');

-- Australia and Oceania

-- Australia
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Australia', 'AU', '+61');

-- Fiji
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Fiji', 'FJ', '+679');

-- Kiribati
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Kiribati', 'KI', '+686');

-- Marshall Islands
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Marshall Islands', 'MH', '+692');

-- Micronesia (Federated States)
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Micronesia (Federated States)', 'FM', '+691');

-- Nauru
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('Nauru', 'NR', '+674');

-- New Zealand
INSERT INTO PHONE_PREFIXES (COUNTRY_NAME, COUNTRY_ALPHA2, PHONE_PREFIX) 
VALUES ('New Zealand', 'NZ', '+64');

--VALUES INSERTED INTO CATEGORIES TABLE
INSERT INTO Categories (category_id,item_category) VALUES (1,'Clothing & Accessories');
INSERT INTO Categories (category_id,item_category) VALUES (2,'Electronics & Gadgets');
INSERT INTO Categories (category_id,item_category) VALUES (3,'Home & Furniture');
INSERT INTO Categories (category_id,item_category) VALUES (4,'Books, Movies & Music');
INSERT INTO Categories (category_id,item_category) VALUES (5,'Sports & Outdoors');
INSERT INTO Categories (category_id,item_category) VALUES (6,'Toys & Baby Products');
INSERT INTO Categories (category_id,item_category) VALUES (7,'Health & Beauty');
INSERT INTO Categories (category_id,item_category) VALUES (8,'Collectibles & Antiques');
INSERT INTO Categories (category_id,item_category) VALUES (9,'Vehicles & Vehicle Parts');
INSERT INTO Categories (category_id,item_category) VALUES (10,'Musical Instruments');
INSERT INTO Categories (category_id,item_category) VALUES (11,'Office Supplies & Equipment');
INSERT INTO Categories (category_id,item_category) VALUES (12,'Seasonal Items');


--JURNAL TABLES
 CREATE TABLE "CONSIGNORS_JN" 
   (	"JN_OPERATION" CHAR(3) NOT NULL ENABLE, 
	"JN_ORACLE_USER" VARCHAR2(30) NOT NULL ENABLE, 
	"JN_DATETIME" DATE NOT NULL ENABLE, 
	"JN_NOTES" VARCHAR2(240), 
	"JN_APPLN" VARCHAR2(35), 
	"JN_SESSION" NUMBER(38,0), 
	"CONSIGNOR_ID" NUMBER(*,0) NOT NULL ENABLE, 
	"FIRST_NAME" VARCHAR2(100) NOT NULL ENABLE, 
	"LAST_NAME" VARCHAR2(100) NOT NULL ENABLE, 
	"PHONE_NUMBER" VARCHAR2(15) NOT NULL ENABLE, 
	"EMAIL" VARCHAR2(100) NOT NULL ENABLE, 
	"ADDRESS" VARCHAR2(250) NOT NULL ENABLE, 
	"CITY" VARCHAR2(50), 
	"STATE" VARCHAR2(50), 
	"ZIP_CODE" VARCHAR2(20) NOT NULL ENABLE
   ) ;

    CREATE TABLE "ITEMS_JN" 
   (	"JN_OPERATION" CHAR(3) NOT NULL ENABLE, 
	"JN_ORACLE_USER" VARCHAR2(30) NOT NULL ENABLE, 
	"JN_DATETIME" DATE NOT NULL ENABLE, 
	"JN_NOTES" VARCHAR2(240), 
	"JN_APPLN" VARCHAR2(35), 
	"JN_SESSION" NUMBER(38,0), 
	"ITEM_ID" NUMBER(*,0) NOT NULL ENABLE, 
	"CONSIGNOR_ID" NUMBER(*,0) NOT NULL ENABLE, 
	"ITEM" VARCHAR2(250) NOT NULL ENABLE, 
	"PRICE" NUMBER NOT NULL ENABLE, 
	"DATE_ADDED" DATE NOT NULL ENABLE, 
	"DESCRIPTION" VARCHAR2(500), 
	"CATEGORY_ID" NUMBER(*,0), 
	"ITEM_CATEGORY" VARCHAR2(150), 
	"STATUS" VARCHAR2(20), 
	"TRANSACTION_DATE" DATE, 
	"COMMISSION_RATE" NUMBER, 
	"COMMISSION_AMOUNT" NUMBER
   ) ;

    CREATE TABLE "PAYMENTS_JN" 
   (	"JN_OPERATION" CHAR(3) NOT NULL ENABLE, 
	"JN_ORACLE_USER" VARCHAR2(30) NOT NULL ENABLE, 
	"JN_DATETIME" DATE NOT NULL ENABLE, 
	"JN_NOTES" VARCHAR2(240), 
	"JN_APPLN" VARCHAR2(35), 
	"JN_SESSION" NUMBER(38,0), 
	"PAYMENT_ID" NUMBER(*,0) NOT NULL ENABLE, 
	"CONSIGNOR_ID" NUMBER(*,0) NOT NULL ENABLE, 
	"AMOUNT_PAID" NUMBER, 
	"PAYMENT_DATE" DATE NOT NULL ENABLE, 
	"ITEM_ID" NUMBER(*,0) NOT NULL ENABLE
   ) ;

   --TRIGGERS FOR THE JURNAL TABLES
   create or replace TRIGGER consignors_JNtrg
  AFTER 
  INSERT OR 
  UPDATE OR 
  DELETE ON consignors for each row 
 Declare 
  rec consignors_JN%ROWTYPE; 
  blank consignors_JN%ROWTYPE; 
  BEGIN 
    rec := blank; 
    IF INSERTING OR UPDATING THEN 
      rec.consignor_id := :NEW.consignor_id; 
      rec.first_name := :NEW.first_name; 
      rec.last_name := :NEW.last_name; 
      rec.phone_number := :NEW.phone_number; 
      rec.email := :NEW.email; 
      rec.address := :NEW.address; 
      rec.city := :NEW.city; 
      rec.state := :NEW.state; 
      rec.zip_code := :NEW.zip_code; 
      rec.JN_DATETIME := SYSDATE; 
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER'); 
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE'); 
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID'); 
      IF INSERTING THEN 
        rec.JN_OPERATION := 'INS'; 
      ELSIF UPDATING THEN 
        rec.JN_OPERATION := 'UPD'; 
      END IF; 
    ELSIF DELETING THEN 
      rec.consignor_id := :OLD.consignor_id; 
      rec.first_name := :OLD.first_name; 
      rec.last_name := :OLD.last_name; 
      rec.phone_number := :OLD.phone_number; 
      rec.email := :OLD.email; 
      rec.address := :OLD.address; 
      rec.city := :OLD.city; 
      rec.state := :OLD.state; 
      rec.zip_code := :OLD.zip_code; 
      rec.JN_DATETIME := SYSDATE; 
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER'); 
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE'); 
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID'); 
      rec.JN_OPERATION := 'DEL'; 
    END IF; 
    INSERT into consignors_JN VALUES rec; 
  END;
/

create or replace TRIGGER items_JNtrg
  AFTER 
  INSERT OR 
  DELETE ON items for each row 
 Declare 
  rec items_JN%ROWTYPE; 
  blank items_JN%ROWTYPE; 
  BEGIN 
    rec := blank; 
    IF INSERTING OR UPDATING THEN 
      rec.item_id := :NEW.item_id; 
      rec.consignor_id := :NEW.consignor_id; 
      rec.item := :NEW.item; 
      rec.price := :NEW.price; 
      rec.date_added := :NEW.date_added; 
      rec.description := :NEW.description; 
      rec.category_id := :NEW.category_id; 
      rec.item_category := :NEW.item_category; 
      rec.status := :NEW.status; 
      rec.transaction_date := :NEW.transaction_date; 
      rec.commission_rate := :NEW.commission_rate; 
      rec.commission_amount := :NEW.commission_amount; 
      rec.JN_DATETIME := SYSDATE; 
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER'); 
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE'); 
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID'); 
      IF INSERTING THEN 
        rec.JN_OPERATION := 'INS'; 
      END IF; 
    ELSIF DELETING THEN 
      rec.item_id := :OLD.item_id; 
      rec.consignor_id := :OLD.consignor_id; 
      rec.item := :OLD.item; 
      rec.price := :OLD.price; 
      rec.date_added := :OLD.date_added; 
      rec.description := :OLD.description; 
      rec.category_id := :OLD.category_id; 
      rec.item_category := :OLD.item_category; 
      rec.status := :OLD.status; 
      rec.transaction_date := :OLD.transaction_date; 
      rec.commission_rate := :OLD.commission_rate; 
      rec.commission_amount := :OLD.commission_amount; 
      rec.JN_DATETIME := SYSDATE; 
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER'); 
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE'); 
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID'); 
      rec.JN_OPERATION := 'DEL'; 
    END IF; 
    INSERT into items_JN VALUES rec; 
  END;
/

create or replace TRIGGER payments_JNtrg
  AFTER 
  INSERT OR 
  UPDATE OR 
  DELETE ON payments for each row 
 Declare 
  rec payments_JN%ROWTYPE; 
  blank payments_JN%ROWTYPE; 
  BEGIN 
    rec := blank; 
    IF INSERTING OR UPDATING THEN 
      rec.payment_id := :NEW.payment_id; 
      rec.consignor_id := :NEW.consignor_id; 
      rec.amount_paid := :NEW.amount_paid; 
      rec.payment_date := :NEW.payment_date; 
      rec.item_id := :NEW.item_id; 
      rec.JN_DATETIME := SYSDATE; 
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER'); 
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE'); 
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID'); 
      IF INSERTING THEN 
        rec.JN_OPERATION := 'INS'; 
      ELSIF UPDATING THEN 
        rec.JN_OPERATION := 'UPD'; 
      END IF; 
    ELSIF DELETING THEN 
      rec.payment_id := :OLD.payment_id; 
      rec.consignor_id := :OLD.consignor_id; 
      rec.amount_paid := :OLD.amount_paid; 
      rec.payment_date := :OLD.payment_date; 
      rec.item_id := :OLD.item_id; 
      rec.JN_DATETIME := SYSDATE; 
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER'); 
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE'); 
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID'); 
      rec.JN_OPERATION := 'DEL'; 
    END IF; 
    INSERT into payments_JN VALUES rec; 
  END;
/



