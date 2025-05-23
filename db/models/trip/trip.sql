-- Dependencies: car, user

CREATE TABLE Trips (
    id NUMBER PRIMARY KEY,
    car_id NUMBER NOT NULL,
    renter_id NUMBER NOT NULL,
    total_amount NUMBER(12,2) NOT NULL,
    deposit_amount NUMBER(12,2) NOT NULL,
    pickup_date TIMESTAMP NOT NULL,
    pickup_address NVARCHAR2(500),
    return_date TIMESTAMP NOT NULL,
    return_address NVARCHAR2(500),
    status VARCHAR2(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Approved', 'Rejected', 'Canceled', 'InProgress', 'Completed')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (car_id) REFERENCES Cars(id),
    FOREIGN KEY (renter_id) REFERENCES Users(id),
    CHECK (pickup_date < return_date),
    CHECK (deposit_amount <= total_amount)
);

CREATE INDEX idx_trip_car_id ON Trips(car_id);
CREATE INDEX idx_trip_renter_id ON Trips(renter_id);

CREATE SEQUENCE trip_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_trip_bi
    BEFORE INSERT ON Trips
    FOR EACH ROW
BEGIN
    :NEW.id := trip_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_trip_bu
    BEFORE UPDATE ON Trips
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/
