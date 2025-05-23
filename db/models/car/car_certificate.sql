-- Dependencies: car

CREATE TABLE CarCertificates (
    id NUMBER PRIMARY KEY,
    car_id NUMBER UNIQUE NOT NULL,
    car_registration_certificate_url VARCHAR2(500) UNIQUE,
    car_inspection_certificate_url VARCHAR2(500) UNIQUE,
    car_insurance_certificate_url VARCHAR2(500) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (car_id) REFERENCES Cars(id) ON DELETE CASCADE
);

CREATE SEQUENCE car_certificates_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_car_certificates_bi
    BEFORE INSERT ON CarCertificates
    FOR EACH ROW
BEGIN
    :NEW.id := car_certificates_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_car_certificates_bu
    BEFORE UPDATE ON CarCertificates
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/
