-- Dependencies: trip, user

CREATE TABLE TripReviews (
    id NUMBER PRIMARY KEY,
    trip_id NUMBER UNIQUE NOT NULL,
    reviewer_id NUMBER NOT NULL,
    star_rating NUMBER(2,1) CHECK (star_rating >= 0 AND star_rating <= 5),
    review_comment NCLOB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (trip_id) REFERENCES Trips(id) ON DELETE CASCADE,
    FOREIGN KEY (reviewer_id) REFERENCES Users(id)
);

CREATE SEQUENCE trip_review_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_trip_review_bi
    BEFORE INSERT ON TripReviews
    FOR EACH ROW
BEGIN
    :NEW.id := trip_review_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_trip_review_bu
    BEFORE UPDATE ON TripReviews
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/
