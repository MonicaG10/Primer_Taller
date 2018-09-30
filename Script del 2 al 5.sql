--2. Create 3 Tablespaces:
--a. first one with 2 Gb and 1 datafile, tablespace should be named "uber"

CREATE TABLESPACE UBER DATAFILE 
'uber.dbf' SIZE 25M
AUTOEXTEND ON NEXT 1000K MAXSIZE 2048M
EXTENT MANAGEMENT LOCAL 
SEGMENT SPACE MANAGEMENT AUTO
ONLINE;

--b. Undo tablespace with 25Mb of space and 1 datafile

CREATE UNDO TABLESPACE UNDO_TBS datafile
'UNDO_TBS1.dbf' size 25M
AUTOEXTEND OFF;

--c. Bigfile tablespace of 5Gb

CREATE BIGFILE TABLESPACE uber2 DATAFILE
'C:\uber2.dbf' SIZE 5G;

--d. Set the undo tablespace to be used in the system
ALTER SYSTEM SET UNDO_TABLESPACE = UNDO_TBS scope = both;

--3. Create a DBA user (with the role DBA) and assign it to the tablespace called " uber ", this user has
--unlimited space on the tablespace (The user should have permission to connect)

CREATE USER DBAUSER1 IDENTIFIED BY DBAUSER1
DEFAULT TABLESPACE UBER
TEMPORARY TABLESPACE TEMP
QUOTA UNLIMITED ON UBER;

GRANT DBA TO DBAUSER1;
GRANT CONNECT, RESOURCE TO DBAUSER1;

--4. Create 2 profiles.
--a. Profile 1: "clerk" password life 40 days, one session per user, 10 minutes idle, 4 failed login
--attempts

CREATE PROFILE CLERK LIMIT
SESSIONS_PER_USER 1
CPU_PER_SESSION UNLIMITED
CPU_PER_CALL UNLIMITED
CONNECT_TIME 240
IDLE_TIME 10
PRIVATE_SGA 20 M
FAILED_LOGIN_ATTEMPTS 4
PASSWORD_LIFE_TIME 40
PASSWORD_REUSE_MAX 4
PASSWORD_LOCK_TIME 1
PASSWORD_GRACE_TIME 2;
 

--b. Profile 3: "development " password life 100 days, two session per user, 30 minutes idle, no
--failed login attempts

CREATE PROFILE DEVELOPMENT LIMIT 
SESSIONS_PER_USER 2
CPU_PER_SESSION UNLIMITED
CPU_PER_CALL UNLIMITED
CONNECT_TIME 240
IDLE_TIME 30
PRIVATE_SGA 20 M
--NO FAILED_LOGIN_ATTEMPTS 
PASSWORD_LIFE_TIME 100
PASSWORD_REUSE_MAX 5
PASSWORD_LOCK_TIME 1
PASSWORD_GRACE_TIME 2;

--5. Create 4 users, assign them the tablespace " uber "; 
--2 of them should have the clerk profile
--and the remaining the development profile, all the users should be allow to connect to the database.

CREATE USER USER1 IDENTIFIED BY USER1
DEFAULT TABLESPACE  UBER
PROFILE CLERK;

GRANT CREATE SESSION TO USER1;

CREATE USER USER2 IDENTIFIED BY USER2
DEFAULT TABLESPACE  UBER
PROFILE CLERK;

GRANT CREATE SESSION TO USER2;

CREATE USER USER3 IDENTIFIED BY USER3
DEFAULT TABLESPACE  UBER
PROFILE DEVELOPMENT;

GRANT CREATE SESSION TO USER3;

CREATE USER USER4 IDENTIFIED BY USER4
DEFAULT TABLESPACE  UBER
PROFILE DEVELOPMENT;

GRANT CREATE SESSION TO USER4;

--Lock one user associate with clerk profile

ALTER USER USER1 
ACCOUNT LOCK ;  



