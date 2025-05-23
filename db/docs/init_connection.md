# 🐦 Oracle Database Create New Connection

Instruct to set up an Oracle Database instance in Docker, create a user with DBA privileges, and connect using SQL tools like DataGrip.

---

## Step 🐸: Connect to the Database Container

Use the following command to access the Oracle container:

```bash
docker exec -it oracle-db-test-car-rental sqlplus / as sysdba
```

---

## Step 🐸🐸: Connect as SYSDBA

Within `sqlplus`, execute:

```sql
CONNECT sys AS sysdba;
-- Password: Thien55555=
```

---

## Step 🐸🐸🐸: Initialize the Database

```sql
ALTER DATABASE OPEN RESETLOGS;
ALTER PLUGGABLE DATABASE ALL OPEN;
ALTER SYSTEM DISABLE RESTRICTED SESSION;
ALTER SESSION SET CONTAINER = CDB$ROOT;
```

---

## Step 🐸🐸🐸🐸: Create a New User

```sql
CREATE USER c##myuser IDENTIFIED BY "Thien55555=";
```

> 🕒 You may wait \~10 seconds after executing the above command before proceeding.

---

## Step 🐸🐸🐸🐸🐸: Check the User

```sql
SELECT username FROM dba_users WHERE username = 'C##MYUSER';
```

---

## Step 🐸🐸🐸🐸🐸🐸: Grant DBA Privileges

```sql
GRANT DBA TO c##myuser;
```

---

## 🚩 Connect Using the New User

Reconnect in `sqlplus`:

```sql
CONNECT c##myuser;
```

---

## 🚩 IDE Connection Crednetials
```plaintext
Host: localhost
Service: ORCL
Port: 1521
Username: c##myuser
Password: Thien55555=
```

---

## 📌 Notes

* Ensure the Oracle database is running and the container is healthy.
* Use the `c##` prefix for common users in Oracle Container Databases (CDB).
