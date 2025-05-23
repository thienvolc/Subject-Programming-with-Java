-- Dependencies: user

CREATE TABLE Cars (
    id NUMBER PRIMARY KEY,
    owner_id NUMBER NOT NULL,
    base_price_per_day NUMBER(10,2) NOT NULL,
    license_plate_number VARCHAR2(20) UNIQUE NOT NULL,
    year_of_manufacture NUMBER(4) NOT NULL,
    brand NVARCHAR2(100) NOT NULL,
    model NVARCHAR2(100) NOT NULL,
    number_of_seats NUMBER NOT NULL,
    fuel_type VARCHAR2(20) CHECK (fuel_type IN ('Petrol', 'Diesel')),
    transmission_type VARCHAR2(20) CHECK (transmission_type IN ('Manual', 'Automatic')),
    fuel_consumption NUMBER(5,2),
    vehicle_listing_date DATE,
    total_bookings NUMBER DEFAULT 0,
    average_star_rating NUMBER(3,2) DEFAULT 0 CHECK (average_star_rating BETWEEN 0 AND 5),
    description NCLOB,
    status VARCHAR2(20) DEFAULT 'Available' CHECK (status IN ('Available', 'Unavailable', 'UnderReview')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES Users(id) ON DELETE CASCADE
);

CREATE INDEX idx_car_owner ON Cars(owner_id);
CREATE INDEX idx_car_brand_model ON Cars(brand, model);
CREATE INDEX idx_car_number_of_seats ON Cars(number_of_seats);
CREATE INDEX idx_car_fuel_type ON Cars(fuel_type);
CREATE INDEX idx_car_transmission_type ON Cars(transmission_type);

CREATE SEQUENCE car_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_car_bi
    BEFORE INSERT ON Cars
    FOR EACH ROW
BEGIN
    :NEW.id := car_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_car_update
    BEFORE UPDATE ON Cars
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/
