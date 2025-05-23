-- Dependencies: car

CREATE TABLE CarUnavailableDates (
    id NUMBER PRIMARY KEY,
    car_id NUMBER NOT NULL,
    apply_date DATE NOT NULL,
    reason NVARCHAR2(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (car_id) REFERENCES Cars(id) ON DELETE CASCADE,
    UNIQUE (car_id, apply_date)
);

CREATE INDEX idx_car_unavailable_dates_car_id ON CarUnavailableDates(car_id);

CREATE SEQUENCE car_unavailable_dates_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_car_unavailable_dates_bi
    BEFORE INSERT ON CarUnavailableDates
    FOR EACH ROW
BEGIN
    :NEW.id := car_unavailable_dates_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_car_unavailable_dates_bu
    BEFORE UPDATE ON CarUnavailableDates
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/
