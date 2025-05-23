-- Dependencies: trip, payment

CREATE TABLE Refunds (
    id NUMBER PRIMARY KEY,
    trip_id NUMBER UNIQUE NOT NULL,
    payment_id NUMBER,
    amount_refunded NUMBER(12,2) NOT NULL,
    refund_type VARCHAR2(20) CHECK (refund_type IN ('Partial', 'Full')),
    payment_method VARCHAR2(20) CHECK (payment_method IN ('Momo', 'ZaloPay')),
    refunded_at TIMESTAMP,
    refund_reason NCLOB,
    status VARCHAR2(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Processed', 'Failed')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (trip_id) REFERENCES Trips(id) ON DELETE CASCADE,
    FOREIGN KEY (payment_id) REFERENCES Payments(id)
);

CREATE INDEX idx_refund_payment_id ON Refunds(payment_id);

CREATE SEQUENCE refund_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_refund_bi
    BEFORE INSERT ON Refunds
    FOR EACH ROW
BEGIN
    :NEW.id := refund_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_refund_bu
    BEFORE UPDATE ON Refunds
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/
