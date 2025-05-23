-- Dependencies: trip

CREATE TABLE Deposits (
    id NUMBER PRIMARY KEY,
    trip_id NUMBER UNIQUE NOT NULL,
    deposit_amount NUMBER(12,2) NOT NULL,
    deposit_type VARCHAR2(20) CHECK (deposit_type IN ('Partial', 'Full')),
    deposit_percentage NUMBER(5,2) CHECK (deposit_percentage >= 0 AND deposit_percentage <= 100),
    payment_method VARCHAR2(20) CHECK (payment_method IN ('Momo', 'ZaloPay')),
    paid_at TIMESTAMP,
    status VARCHAR2(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Completed', 'Failed')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (trip_id) REFERENCES Trips(id) ON DELETE CASCADE
);

CREATE SEQUENCE deposit_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_deposit_bi
    BEFORE INSERT ON Deposits
    FOR EACH ROW
BEGIN
    :NEW.id := deposit_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_deposit_bu
    BEFORE UPDATE ON Deposits
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/
