-- Dependencies: user

CREATE TABLE OtpRequests (
    id NUMBER PRIMARY KEY,
    user_id NUMBER NOT NULL,
    code VARCHAR2(10) NOT NULL,
    phone_number VARCHAR2(20) NOT NULL,
    request_type VARCHAR2(20) CHECK (request_type IN ('Registration', 'PasswordReset')),
    attempt_count NUMBER DEFAULT 0,
    max_attempts NUMBER DEFAULT 5,
    expiration_time TIMESTAMP NOT NULL,
    status VARCHAR2(20) DEFAULT 'Valid' CHECK (status IN ('Valid', 'Canceled', 'Used')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE,
    CHECK (attempt_count <= max_attempts)
);

CREATE INDEX idx_otp_request_user_id ON OtpRequests(user_id);
CREATE INDEX idx_otp_request_phone_number ON OtpRequests(phone_number);

CREATE SEQUENCE otp_request_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_otp_request_bi
    BEFORE INSERT ON OtpRequests
    FOR EACH ROW
BEGIN
    :NEW.id := otp_request_seq.NEXTVAL;
END;
/
