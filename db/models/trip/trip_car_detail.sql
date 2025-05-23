-- Dependencies: trip

CREATE TABLE TripCarDetails (
    id NUMBER PRIMARY KEY,
    trip_id NUMBER UNIQUE NOT NULL,
    license_plate_number VARCHAR2(20) NOT NULL,
    year_of_manufacture NUMBER(4) NOT NULL,
    brand NVARCHAR2(100) NOT NULL,
    model NVARCHAR2(100) NOT NULL,
    number_of_seats NUMBER NOT NULL,
    fuel_type VARCHAR2(20),
    transmission_type VARCHAR2(20),
    fuel_consumption NUMBER(5,2),
    vehicle_registration_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (trip_id) REFERENCES Trips(id) ON DELETE CASCADE
);

CREATE SEQUENCE trip_car_detail_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_trip_car_detail_bi
    BEFORE INSERT ON TripCarDetails
    FOR EACH ROW
BEGIN
    :NEW.id := trip_car_detail_seq.NEXTVAL;
END;
/
