-- Dependencies: none

CREATE TABLE Users (
    id NUMBER PRIMARY KEY,
    phone_number VARCHAR2(20) UNIQUE NOT NULL,
    email VARCHAR2(255) UNIQUE NOT NULL,
    password VARCHAR2(255) NOT NULL,
    full_name NVARCHAR2(255) NOT NULL,
    gender VARCHAR2(10) CHECK (gender IN ('Male', 'Female', 'Other')),
    date_of_birth DATE,
    national_id_number VARCHAR2(50) UNIQUE NOT NULL,
    is_phone_verified NUMBER(1) DEFAULT 0 CHECK (is_phone_verified IN (0, 1)),
    is_email_verified NUMBER(1) DEFAULT 0 CHECK (is_email_verified IN (0, 1)),
    status VARCHAR2(20) DEFAULT 'Active' CHECK (status IN ('Active', 'Inactive', 'Banned')),
    avatar_url VARCHAR2(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE SEQUENCE user_seq 
    START WITH 1 
    INCREMENT BY 1 
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_user_bi
    BEFORE INSERT ON Users
    FOR EACH ROW
BEGIN
    :NEW.id := user_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_user_bu
    BEFORE UPDATE ON Users
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/
