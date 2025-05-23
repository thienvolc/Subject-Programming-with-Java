-- Dependencies: car, user

CREATE TABLE CarListingRequests (
    id NUMBER PRIMARY KEY,
    car_id NUMBER NOT NULL,
    approved_by_user_id NUMBER NOT NULL,
    status VARCHAR2(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Approved', 'Rejected')),
    approval_time TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (car_id) REFERENCES Cars(id) ON DELETE CASCADE
);

CREATE INDEX idx_car_listing_request_car_id ON CarListingRequests(car_id);

CREATE SEQUENCE car_listing_request_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_car_listing_request_bi
    BEFORE INSERT ON CarListingRequests
    FOR EACH ROW
BEGIN
    :NEW.id := car_listing_request_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_car_listing_request_bu
    BEFORE UPDATE ON CarListingRequests
    FOR EACH ROW
BEGIN
    IF :NEW.status = 'Approved' OR :NEW.status = 'Rejected' THEN
        :NEW.approval_time := CURRENT_TIMESTAMP;
    END IF;
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/
