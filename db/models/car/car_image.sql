-- Dependencies: car

CREATE TABLE CarImages (
    id NUMBER PRIMARY KEY,
    car_id NUMBER NOT NULL,
    image_url VARCHAR2(500) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (car_id) REFERENCES Cars(id) ON DELETE CASCADE
);

CREATE INDEX idx_car_image_car_id ON CarImages(car_id);

CREATE SEQUENCE car_image_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_car_image_bi
    BEFORE INSERT ON CarImages
    FOR EACH ROW
BEGIN
    :NEW.id := car_image_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_car_image_bu
    BEFORE UPDATE ON CarImages
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/
