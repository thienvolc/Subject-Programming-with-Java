-- Dependencies: user

CREATE TABLE UserSessions (
    id NUMBER PRIMARY KEY,
    user_id NUMBER NOT NULL,
    device_info NVARCHAR2(500),
    ip_address VARCHAR2(45),
    user_agent NVARCHAR2(1000),
    last_activity_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active NUMBER(1) DEFAULT 1 CHECK (is_active IN (0, 1)),
    expired_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE
);

CREATE INDEX idx_user_session_user_id ON UserSessions(user_id);

CREATE SEQUENCE user_session_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_user_session_bi
    BEFORE INSERT ON UserSessions
    FOR EACH ROW
BEGIN
    :NEW.id := user_session_seq.NEXTVAL;
END;
/
