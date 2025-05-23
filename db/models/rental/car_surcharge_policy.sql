-- Dependencies: car

CREATE TABLE CarSurchargePolicies (
    id NUMBER PRIMARY KEY,
    car_id NUMBER UNIQUE NOT NULL,
    mileage_overage_fee NUMBER(10,2) CHECK (mileage_overage_fee > 0),
    daily_mileage_limit NUMBER CHECK (daily_mileage_limit > 0),
    cleaning_fee NUMBER(10,2) CHECK (cleaning_fee > 0),
    hourly_overtime_fee NUMBER(10,2) CHECK (hourly_overtime_fee > 0),
    daily_overtime_threshold NUMBER CHECK (daily_overtime_threshold > 0),
    odor_removal_fee NUMBER(10,2) CHECK (odor_removal_fee >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (car_id) REFERENCES Cars(id) ON DELETE CASCADE
);

CREATE SEQUENCE car_surcharge_policies_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_car_surcharge_policies_bi
    BEFORE INSERT ON CarSurchargePolicies
    FOR EACH ROW
BEGIN
    :NEW.id := car_surcharge_policies_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_car_surcharge_policies_bu
    BEFORE UPDATE ON CarSurchargePolicies
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/
