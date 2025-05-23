-- Dependencies: car

CREATE TABLE CarEligibilityPolicies (
    id NUMBER PRIMARY KEY,
    car_id NUMBER UNIQUE NOT NULL,
    requires_deposit NUMBER(1) DEFAULT 1 CHECK (requires_deposit IN (0, 1)),
    requires_driving_license NUMBER(1) DEFAULT 1 CHECK (requires_driving_license IN (0, 1)),
    requires_national_id NUMBER(1) DEFAULT 1 CHECK (requires_national_id IN (0, 1)),
    additional_note NCLOB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (car_id) REFERENCES Cars(id) ON DELETE CASCADE
);

CREATE SEQUENCE car_eligibility_policies_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_car_eligibility_policies_bi
    BEFORE INSERT ON CarEligibilityPolicies
    FOR EACH ROW
BEGIN
    :NEW.id := car_eligibility_policies_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_car_eligibility_policies_bu
    BEFORE UPDATE ON CarEligibilityPolicies
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/
