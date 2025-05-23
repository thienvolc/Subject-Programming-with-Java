-- Dependencies: trip

CREATE TABLE TripEligibilityPolicies (
    id NUMBER PRIMARY KEY,
    trip_id NUMBER UNIQUE NOT NULL,
    requires_deposit NUMBER(1) DEFAULT 1 CHECK (requires_deposit IN (0, 1)),
    requires_driving_license NUMBER(1) DEFAULT 1 CHECK (requires_driving_license IN (0, 1)),
    requires_national_id NUMBER(1) DEFAULT 1 CHECK (requires_national_id IN (0, 1)),
    additional_note NCLOB,
    FOREIGN KEY (trip_id) REFERENCES Trips(id) ON DELETE CASCADE
);

CREATE SEQUENCE trip_eligibility_policy_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_trip_eligibility_policy_bi
    BEFORE INSERT ON TripEligibilityPolicies
    FOR EACH ROW
BEGIN
    :NEW.id := trip_eligibility_policy_seq.NEXTVAL;
END;
/
