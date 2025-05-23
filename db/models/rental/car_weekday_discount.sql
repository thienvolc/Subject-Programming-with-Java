-- Dependencies: car

CREATE TABLE CarWeekdayDiscounts (
    id NUMBER PRIMARY KEY,
    car_id NUMBER NOT NULL,
    weekday VARCHAR2(10) CHECK (weekday IN ('Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun')),
    discount_percentage NUMBER(5,2) CHECK (discount_percentage BETWEEN 0 AND 100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (car_id) REFERENCES Cars(id) ON DELETE CASCADE,
    UNIQUE (car_id, weekday)
);

CREATE INDEX idx_car_weekday_discounts_car_id ON CarWeekdayDiscounts(car_id);

CREATE SEQUENCE car_weekday_discounts_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_car_weekday_discounts_bi
    BEFORE INSERT ON CarWeekdayDiscounts
    FOR EACH ROW
BEGIN
    :NEW.id := car_weekday_discounts_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_car_weekday_discounts_bu
    BEFORE UPDATE ON CarWeekdayDiscounts
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/
