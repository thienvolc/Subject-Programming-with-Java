-- Dependencies: user

CREATE TABLE DrivingLicenses (
    id NUMBER PRIMARY KEY,
    user_id NUMBER UNIQUE NOT NULL,
    verified_by_user_id NUMBER NOT NULL,
    license_number VARCHAR2(50) UNIQUE NOT NULL,
    date_of_birth DATE NOT NULL,
    full_name_on_license NVARCHAR2(255) NOT NULL,
    image_url VARCHAR2(500),
    status VARCHAR2(20) DEFAULT 'Pending' CHECK (status IN ('Verified', 'Pending', 'Rejected')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE
);

CREATE SEQUENCE driving_license_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_driving_license_bi
    BEFORE INSERT ON DrivingLicenses
    FOR EACH ROW
BEGIN
    :NEW.id := driving_license_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_driving_license_bu
    BEFORE UPDATE ON DrivingLicenses
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/
