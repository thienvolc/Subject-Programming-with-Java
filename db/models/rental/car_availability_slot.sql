-- Dependencies: car

CREATE TABLE CarAvailabilitySlots (
    id NUMBER PRIMARY KEY,
    car_id NUMBER UNIQUE NOT NULL,
    pickup_start_time TIMESTAMP NOT NULL,
    pickup_end_time TIMESTAMP NOT NULL,
    return_start_time TIMESTAMP NOT NULL,
    return_end_time TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (car_id) REFERENCES Cars(id) ON DELETE CASCADE,
    CHECK (pickup_start_time < pickup_end_time),
    CHECK (return_start_time < return_end_time)
);

CREATE SEQUENCE car_availability_slots_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_car_availability_slots_bi
    BEFORE INSERT ON CarAvailabilitySlots
    FOR EACH ROW
BEGIN
    :NEW.id := car_availability_slots_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_car_availability_slots_bu
    BEFORE UPDATE ON CarAvailabilitySlots
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/
