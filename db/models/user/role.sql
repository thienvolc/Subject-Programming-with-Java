-- Dependencies: none

CREATE TABLE Roles (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(20) CHECK (name IN ('Admin', 'User')),
    description NVARCHAR2(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE SEQUENCE role_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_role_bi
    BEFORE INSERT ON Roles
    FOR EACH ROW
BEGIN
    :NEW.id := role_seq.NEXTVAL;
END;
/
