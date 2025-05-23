-- Dependencies: car

CREATE TABLE CarDailyPrices (
    id NUMBER PRIMARY KEY,
    car_id NUMBER NOT NULL,
    price NUMBER(10,2) NOT NULL CHECK (price > 0),
    apply_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (car_id) REFERENCES Cars(id) ON DELETE CASCADE,
    UNIQUE (car_id, apply_date)
);

CREATE INDEX idx_car_daily_prices_car_id ON CarDailyPrices(car_id);

CREATE SEQUENCE car_daily_prices_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_car_daily_prices_bi
    BEFORE INSERT ON CarDailyPrices
    FOR EACH ROW
BEGIN
    :NEW.id := car_daily_prices_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_car_daily_prices_bu
    BEFORE UPDATE ON CarDailyPrices
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/
