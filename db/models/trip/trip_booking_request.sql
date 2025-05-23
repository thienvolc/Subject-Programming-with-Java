-- Dependencies: trip, user

CREATE TABLE TripBookingRequests (
    id NUMBER PRIMARY KEY,
    trip_id NUMBER NOT NULL,
    owner_id NUMBER NOT NULL,
    renter_id NUMBER NOT NULL,
    requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR2(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Approved', 'Rejected')),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES Users(id),
    FOREIGN KEY (renter_id) REFERENCES Users(id)
);

ALTER TABLE TripBookingRequests ADD FOREIGN KEY (trip_id) REFERENCES Trips(id) ON DELETE CASCADE;

CREATE INDEX idx_trip_booking_request_trip_id ON TripBookingRequests(trip_id);
CREATE INDEX idx_trip_booking_request_owner_id ON TripBookingRequests(owner_id);
CREATE INDEX idx_trip_booking_request_renter_id ON TripBookingRequests(renter_id);

CREATE SEQUENCE trip_booking_request_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_trip_booking_request_bi
    BEFORE INSERT ON TripBookingRequests
    FOR EACH ROW
BEGIN
    :NEW.id := trip_booking_request_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_trip_booking_request_bu
    BEFORE UPDATE ON TripBookingRequests
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/
