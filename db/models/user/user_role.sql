-- Dependencies: user, role

CREATE TABLE UserRoles (
    id NUMBER PRIMARY KEY,
    user_id NUMBER NOT NULL,
    role_id NUMBER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_user_role_user_id ON UserRoles(user_id);

CREATE SEQUENCE user_role_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_user_role_bi
    BEFORE INSERT ON UserRoles
    FOR EACH ROW
BEGIN
    :NEW.id := user_role_seq.NEXTVAL;
END;
/
