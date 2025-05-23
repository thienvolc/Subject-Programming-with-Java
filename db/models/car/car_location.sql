-- Dependencies: car

CREATE TABLE CarLocations (
    id NUMBER PRIMARY KEY,
    car_id NUMBER NOT NULL,
    province NVARCHAR2(100),
    district NVARCHAR2(100),
    ward NVARCHAR2(100),
    street_address NVARCHAR2(500),
    longitude NUMBER(10,7),
    latitude NUMBER(10,7),
    FOREIGN KEY (car_id) REFERENCES Cars(id) ON DELETE CASCADE
);

CREATE INDEX idx_car_location_car_id ON CarLocations(car_id);

CREATE SEQUENCE car_location_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_car_location_bi
    BEFORE INSERT ON CarLocations
    FOR EACH ROW
BEGIN
    :NEW.id := car_location_seq.NEXTVAL;
END;
/
