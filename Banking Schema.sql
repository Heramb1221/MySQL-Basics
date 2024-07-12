CREATE DATABASE BMS_DB1;

use BMS_DB1;

-- CUSTOMER PERSONAL_INFO

CREATE TABLE Customer_personal_info(
	Customer_id VARCHAR(5),
    Customer_name VARCHAR(30),
    DOB DATE,
    Guardian_name VARCHAR(30),
    Address VARCHAR(50),
    Contact_No BIGINT(10),
    Mail VARCHAR(30),
    Gender CHAR(1),
    Marital_status VARCHAR(100),
    Identification_doc_type VARCHAR(20),
    ID_doc_no VARCHAR(20),
    Citizenship VARCHAR(10),
    CONSTRAINT CUT_PERS_INFO_PK PRIMARY KEY(CUSTOMER_ID)
);

-- CUSTOMER_REFERENCE_INFO

CREATE TABLE Customer_reference_info(
	Customer_id VARCHAR(5),
    Refrence_acc_name VARCHAR(20),
    Reference_acc_no BIGINT(16),
    Reference_acc_address VARCHAR(50),
    Relation VARCHAR(25),
    CONSTRAINT CUST_REF_INFO_PK PRIMARY  KEY(Customer_id),
    CONSTRAINT CUST_REF_INFO_PK FOREIGN KEY(Customer_id) REFERENCES Customer_personal_info(Customer_id)
);

-- BANK INFO
CREATE TABLE Bank_info(
	IFSC_code VARCHAR(15),
    Bank_name VARCHAR(25),
    Branch_name VARCHAR(25),
    CONSTRAINT BANK_INFO_PK PRIMARY KEY(IFSC_code)
);

-- ACOUNT INFO

CREATE TABLE Account_info(
	Account_no BIGINT(16),
    Customer_id VARCHAR(5),
    Acount_type VARCHAR(10),
    Registration_date DATE,
    Activation_date DATE,
    IFSC_code VARCHAR(10),
    Interest DECIMAL(7,2),
    Initial_deposit BIGINT(10),
    CONSTRAINT ACC_INFO_PK PRIMARY KEY(Account_no),
    CONSTRAINT ACC_INFO_PERS_FK FOREIGN KEY(Customer_id) REFERENCES Customer_personal_info(Customer_id),
    CONSTRAINT ACC_INFO_BANK_FK FOREIGN KEY(IFSC_code) REFERENCES Bank_info(IFSC_code)
    );
    
-- BANK INFO
    
    INSERT INTO Bank_info(IFSC_code,Bank_name,Branch_name) VALUES('HDVL0012','HDFC','VALASARAVAKKAM');
    INSERT INTO Bank_info(IFSC_code,Bank_name,Branch_name) VALUES('SBITN0123','SBI','TNAGAR');
    INSERT INTO Bank_info(IFSC_code,Bank_name,Branch_name) VALUES('ICITN0232','ICICI','TNAGAR');
    INSERT INTO Bank_info(IFSC_code,Bank_name,Branch_name) VALUES('ICIPG0242','ICICI','PERUNGUDI');
    INSERT INTO Bank_info(IFSC_code,Bank_name,Branch_name) VALUES('SBISD0113','SBI','SAIDAPET');
    
-- CUSTOMER_PERSONAL_INFO

INSERT INTO Customer_personal_info(
    Customer_id, Customer_name, DOB, Guardian_name, Address, Contact_No, Mail, Gender, Marital_status, Identification_doc_type, ID_doc_no, Citizenship)
VALUES
('C001', 'John Doe', '1990-01-01', 'Jane Doe', '123 Main St', 9876543210, 'john@example.com', 'M', 'Single', 'Passport', 'P1234567', 'USA'),
('C002', 'Jane Smith', '1985-05-15', 'Robert Smith', '456 Elm St', 9123456780, 'jane@example.com', 'F', 'Married', 'Driving License', 'D7654321', 'UK'),
('C003', 'Alice Johnson', '1992-07-21', 'Emily Johnson', '789 Oak St', 9234567890, 'alice@example.com', 'F', 'Single', 'Passport', 'P2345678', 'CAN'),
('C004', 'Bob Brown', '1988-02-10', 'Nancy Brown', '101 Pine St', 9345678901, 'bob@example.com', 'M', 'Married', 'National ID', 'N8765432', 'AUS'),
('C005', 'Charlie Davis', '1995-03-30', 'Laura Davis', '202 Maple St', 9456789012, 'charlie@example.com', 'M', 'Single', 'Passport', 'P3456789', 'IND');

-- CUSTOMER_REFERENCE_INFO

INSERT INTO Customer_reference_info(
    Customer_id, Refrence_acc_name, Reference_acc_no, Reference_acc_address, Relation)
VALUES
('C001', 'Michael Brown', 1234567890123456, '500 King St', 'Friend'),
('C002', 'Sarah Wilson', 1234567890123457, '600 Queen St', 'Colleague'),
('C003', 'David Lee', 1234567890123458, '700 Prince St', 'Neighbor'),
('C004', 'Emma White', 1234567890123459, '800 Duke St', 'Relative'),
('C005', 'Chris Green', 1234567890123460, '900 Earl St', 'Friend');

-- ACCOUNT_INFO

INSERT INTO Account_info(
    Account_no, Customer_id, Acount_type, Registration_date, Activation_date, IFSC_code, Interest, Initial_deposit)
VALUES
(1111222233334444, 'C001', 'Savings', '2023-01-01', '2023-01-02', 'HDVL0012', 4.5, 5000),
(1111222233334445, 'C002', 'Current', '2023-02-01', '2023-02-02', 'SBITN0123', 3.5, 10000),
(1111222233334446, 'C003', 'Savings', '2023-03-01', '2023-03-02', 'ICITN0232', 4.0, 7500),
(1111222233334447, 'C004', 'Current', '2023-04-01', '2023-04-02', 'ICIPG0242', 3.0, 12000),
(1111222233334448, 'C005', 'Savings', '2023-05-01', '2023-05-02', 'SBISD0113', 4.2, 6000);

select * from account_info;
select * from bank_info;
select * from customer_personal_info;
select * from customer_reference_info;
