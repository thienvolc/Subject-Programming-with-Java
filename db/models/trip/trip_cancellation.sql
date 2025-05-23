-- Dependencies: trip, user

CREATE TABLE TripCancellations (
    id NUMBER PRIMARY KEY,
    trip_id NUMBER UNIQUE NOT NULL,
    cancelled_by_user_id NUMBER NOT NULL,
    reason NCLOB,
    refund_status VARCHAR2(20) DEFAULT 'NotApplicable' CHECK (refund_status IN ('NotApplicable', 'Pending', 'Processed', 'Denied')),
    cancelled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (trip_id) REFERENCES Trips(id) ON DELETE CASCADE,
    FOREIGN KEY (cancelled_by_user_id) REFERENCES Users(id)
);

CREATE SEQUENCE trip_cancellation_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_trip_cancellation_bi
    BEFORE INSERT ON TripCancellations
    FOR EACH ROW
BEGIN
    :NEW.id := trip_cancellation_seq.NEXTVAL;
END;
/
