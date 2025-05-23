-- Dependencies: trip, user

CREATE TABLE Payments (
    id NUMBER PRIMARY KEY,
    trip_id NUMBER NOT NULL,
    payer_id NUMBER NOT NULL,
    amount_paid NUMBER(12,2) NOT NULL,
    payment_method VARCHAR2(20) CHECK (payment_method IN ('Momo', 'ZaloPay')),
    external_transaction_id VARCHAR2(100) UNIQUE,
    paid_at TIMESTAMP,
    status VARCHAR2(20) DEFAULT 'Pending' CHECK (status IN ('Success', 'Pending', 'Refunded', 'Failed')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (trip_id) REFERENCES Trips(id),
    FOREIGN KEY (payer_id) REFERENCES Users(id)
);

CREATE INDEX idx_payment_trip_id ON Payments(trip_id);
CREATE INDEX idx_payment_payer_id ON Payments(payer_id);

CREATE SEQUENCE payment_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_payment_bi
    BEFORE INSERT ON Payments
    FOR EACH ROW
BEGIN
    :NEW.id := payment_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_payment_bu
    BEFORE UPDATE ON Payments
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/
