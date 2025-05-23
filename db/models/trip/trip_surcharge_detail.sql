-- Dependencies: trip

CREATE TABLE TripSurchargeDetails (
    id NUMBER PRIMARY KEY,
    trip_id NUMBER UNIQUE NOT NULL,
    mileage_overage_fee NUMBER(10,2),
    daily_mileage_limit NUMBER,
    cleaning_fee NUMBER(10,2),
    overtime_fee NUMBER(10,2),
    daily_overtime_threshold NUMBER,
    odor_removal_fee NUMBER(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (trip_id) REFERENCES Trips(id) ON DELETE CASCADE
);

CREATE SEQUENCE trip_surcharge_detail_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_trip_surcharge_detail_bi
    BEFORE INSERT ON TripSurchargeDetails
    FOR EACH ROW
BEGIN
    :NEW.id := trip_surcharge_detail_seq.NEXTVAL;
END;
/
