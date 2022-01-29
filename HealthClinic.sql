--Enumarator are created to be used in creating attributes
--Enumarator makes our job easier if we want to make any updates to these data types (for eg. add a new type of item to clinic, add a new employee type, change province data type to apply to any country).
CREATE TYPE employeetype as ENUM ('medical', 'non medical');
CREATE TYPE gender as ENUM('male','female','other','prefer not to say');
CREATE TYPE province as ENUM('AB','BC','MB','NB','NL','NT','NS','NU','ON','PE', 'QC', 'SK', 'YT');
CREATE TYPE inventorytype as ENUM('Medication','Consumable');


--------------------------------------------------------------------------

DROP TABLE IF EXISTS Employee, Employee_PositionHist, Employee_Skill,
MedEmployee_Cred, MedEmployee_School, MedEmployee_Specialty, Appointment,
Complaint, Insurance_Claim, Insurance_Provider, Inventory, Pat_allergy,
Pat_detail, Patient, Purchase_Order, Vendor, inventory_use, multiple_appt;

-- Create Employee
CREATE TABLE IF NOT EXISTS Employee (
EmployeeID CHAR(10) PRIMARY KEY,
E_FName varchar(55) NOT NULL,
E_MName varchar(55),
E_LName varchar(55) NOT NULL,
E_Address varchar(100) NOT NULL,
E_City varchar(55) NOT NULL,
E_Province province NOT NULL,
E_Postal_Code CHAR(6) NOT NULL,
E_Phone CHAR(10) NOT NULL,
E_Email varchar(55) NOT NULL,
E_JobTitle varchar(55) NOT NULL,
E_JobStart date NOT NULL,
E_BirthDate date NOT NULL,
E_Gender gender NOT NULL,
EmployeeType employeetype NOT NULL
);

--Create Employee Position History
CREATE TABLE Employee_PositionHist
(
	EmployeeID CHAR(10),
	PastJob_Title  varchar(100) NOT NULL,
	Start_Date DATE NOT NULL,
	End_Date DATE NOT NULL,

	CONSTRAINT fk_employee
	FOREIGN KEY(EmployeeID)
	REFERENCES Employee(EmployeeID)

);

-- Create Medical Employee School
CREATE TABLE MedEmployee_School
(
	EmployeeID CHAR(10),
	School  varchar(50),

	CONSTRAINT fk_employee
	FOREIGN KEY(EmployeeID)
	REFERENCES Employee(EmployeeID)

);

-- Create Medical Employee Specialty
CREATE TABLE MedEmployee_Specialty
(
	EmployeeID CHAR(10),
	Specialty  varchar(50),

	CONSTRAINT fk_employee
	FOREIGN KEY(EmployeeID)
	REFERENCES Employee(EmployeeID)

);

-- CREATE Medical Employee Credential
CREATE TABLE MedEmployee_Cred
(
	EmployeeID CHAR(10),
	Credential  varchar(50),

	CONSTRAINT fk_employee
	FOREIGN KEY(EmployeeID)
	REFERENCES Employee(EmployeeID)

);

--Create Employee Skill
CREATE TABLE Employee_Skill
(
	EmployeeID CHAR(10),
	Skill  varchar(50),

	CONSTRAINT fk_employee
	FOREIGN KEY(EmployeeID)
	REFERENCES Employee(EmployeeID)

);

--Create Patient
CREATE TABLE Patient (
PatientID CHAR(10) PRIMARY KEY,
P_FName varchar(55) NOT NULL,
P_MName varchar(55),
P_LName varchar(55) NOT NULL ,
P_Address varchar(100) NOT NULL,
P_City varchar(55) NOT NULL,
P_Province province NOT NULL,
P_Postal_Code CHAR(6) NOT NULL,
P_Phone CHAR(10) NOT NULL,
P_Email varchar(55) NOT NULL,
P_BirthDate date NOT NULL,
P_Gender gender NOT NULL,
OHIP CHAR(12) UNIQUE,
Kin_FName varchar(55) NOT NULL,
Kin_LName varchar(55) NOT NULL,
Kin_Phone CHAR(10) NOT NULL ,
FDoc_FName varchar(55) NOT NULL,
FDoc_LName varchar(55) NOT NULL,
FDoc_Phone CHAR(10) NOT NULL
);

--Create Patient Allergy
CREATE TABLE Pat_allergy (
PatientID CHAR(10) ,
Allergy   varchar(55),
FOREIGN KEY(PatientID) REFERENCES Patient(PatientID)
);

--Create Patient Details
CREATE TABLE Pat_detail (
PatientID CHAR(10),
Details   varchar(100),
FOREIGN KEY(PatientID) REFERENCES Patient(PatientID)
);

--Create Appointment
CREATE TABLE Appointment (
AppointmentID  CHAR(10) PRIMARY KEY,
PatientID CHAR(10) NOT NULL,
EmployeeID CHAR(10) NOT NULL,
Scheduled_date DATE NOT NULL,
Scheduled_time TIME NOT NULL,
Employee_Notes varchar(100) NOT NULL,
Diagnosis_Details varchar(100) NOT NULL,
Treatment_Details varchar(100) NOT NULL,
Actual_date DATE NOT NULL,
Actual_time  TIME NOT NULL,
Actual_time_end TIME NOT NULL,
FOREIGN KEY(PatientID) REFERENCES Patient(PatientID),
FOREIGN KEY(EmployeeID) REFERENCES Employee(EmployeeID)
);

--Create Vendor
CREATE TABLE Vendor (
	VendorID CHAR(10) PRIMARY KEY,
	V_Name varchar(55) NOT NULL,
	V_Address varchar(100) NOT NULL,
	V_City varchar(55) NOT NULL,
	V_Province province NOT NULL,
	V_Postalcode  char(6)  NOT NULL,
	V_Phone CHAR(10) NOT NULL,
	V_Email varchar(55) NOT NULL,
	V_ContactFName varchar(100) NOT NULL,
	V_ContactLName varchar(100) NOT NULL
);

--Create Inventory
CREATE TABLE Inventory (
	InventoryID char (10) PRIMARY KEY,
	VendorID char(10) NOT NULL,
	Num_Stock integer NOT NULL,
	Use varchar(100) NOT NULL,
    Inventory_Type inventorytype NOT NULL,
	FOREIGN KEY(VendorID) REFERENCES Vendor(VendorID)
);

--Create Insurance Provider
CREATE TABLE Insurance_Provider
(
	InsuranceID CHAR(10) NOT NULL,
	Insurance_PolNum INTEGER NOT NULL,
	Insurance_Partner VARCHAR(100) NOT NULL,
	I_Phone CHAR(10) NOT NULL,
	I_Email VARCHAR(100) NOT NULL,
	PRIMARY KEY(InsuranceID, Insurance_Partner)
);

-- Create Complaint
CREATE TABLE Complaint
(
	ComplaintId char(10) PRIMARY KEY,
	START_DATE DATE NOT NULL,
	END_DATE DATE
);


CREATE TABLE multiple_appt(
	appointmentid CHAR(10) NOT NULL,
	complaintid CHAR(10) NOT NULL,
	FOREIGN KEY (appointmentid) REFERENCES appointment(appointmentid),
	FOREIGN KEY (complaintid) REFERENCES complaint(complaintid)
);


-- Create Insurance Claim
CREATE TABLE Insurance_Claim
(
	ClaimID CHAR(10) PRIMARY KEY,
	Proced_Name VARCHAR(100) NOT NULL,
	Insure_Code CHAR(5) NOT NULL,
	Insure_Partner VARCHAR(100) NOT NULL,
	Date_Submit DATE NOT NULL,
	Amount_Submit FLOAT NOT NULL,
	Amount_Cover FLOAT NOT NULL,
	ComplaintID CHAR(10) NOT NULL,
	InsuranceID CHAR(10) NOT NULL,
	FOREIGN KEY(InsuranceID,Insure_Partner) REFERENCES Insurance_Provider(InsuranceID, Insurance_Partner),
	FOREIGN KEY(ComplaintID) REFERENCES Complaint(ComplaintID)
);

-- Create Inventory Use
CREATE TABLE Inventory_Use(
	ComplaintID CHAR(10) NOT NULL,
	InventoryID CHAR(10) NOT NULL,
	Quantity_used integer NOT NULL,
	FOREIGN KEY(ComplaintID) REFERENCES complaint(ComplaintID),
	FOREIGN KEY(InventoryID) REFERENCES inventory(InventoryID)

);
-------------------------------------------------
--Populating Table

-- Populate Employee
INSERT INTO Employee (EmployeeID, E_FName, E_MName, E_LName,  E_Address,  E_City, E_Province, E_Postal_Code, E_Phone,  E_Email,  E_JobTitle, E_JobStart, E_BirthDate,  E_Gender, EmployeeType)
VALUES
('3114044530' , 'Marley' , 'Lane' , 'Bowman' , '500 Kingston Rd' , 'Mississauga ' , 'ON' , 'L4Z2Y9' , '1887027013' , ' marbowman@uhc.ca' , ' Pharmacist' ,'1996-06-20', '1968-02-05' , 'female' , 'medical'),
('4066002382' , 'Jaden' , NULL , 'Perez' , '15 St Germain Ave' , 'Toronto' , 'ON' , 'M4B1B7 ' , '1114314652' , 'jperez@uhc.ca' , 'Nurse' ,'2004-02-16 ', '1969-08-16 ' , 'male' , 'medical'),
('4325141270' , 'Jada' , 'Millie' , ' Gamble' , '234 Willow Ave' , 'Toronto' , 'ON' , 'M4L1V3 ' , '1134951372' , 'jgamble@uhc.ca' , 'Accountant' ,'2007-02-14 ', '1963-08-17 ' , 'female' , 'non medical'),
('2280224156' , 'Tom' , 'Shelby' , 'Smith' , '26 Goodwood Park' , 'Toronto' , 'ON' , 'M4B1C2 ' , '1916970502' , 'tsmith@uhc.ca' , 'Manager' ,'2018-09-19 ', '1979-04-21 ' , 'male' , 'non medical'),
('9577004292' , 'Jack' , 'Gallagher' , 'Shaw' , '48 St Clair Ave' , 'Toronto' , 'ON' , 'M4E3K7' , '1398993005' , 'jshaw@uhc.ca' , 'Janitor' , '2008-02-17 ','1986-07-27 ' , 'male' , 'non medical'),
('9708834712' , 'Lorelai' , NULL , 'Gilmore' , '1974 Queen St' , 'Toronto' , 'ON' , 'M4C2G5' , '1336249256' , 'lgilmore@uhc.ca' , 'Receptionist' ,'2012-05-12 ', '1980-03-11 ' , 'female' , 'non medical'),
('6344053694' , 'Tom' , NULL , 'Morrison' , '42 Balsam Ave' , 'Toronto' , 'ON' , 'M4B1B8' , '1550545004' , 'tmorris@uhc.ca ' , 'Physician' , '2001-04-01 ','1976-11-21 ' , 'male' , 'medical'),
('6709530455' , 'Ana' , ' Maria' , 'Velasco' , '258 Waverley Rd' , 'Mississauga' , 'ON' , 'L5M1E4' , '1813025722' , 'avelas@uhc.ca ' , 'Nurse' ,'2016-11-20 ', '1976-11-09 ' , 'female' , 'medical'),
('6489682365' , 'Jai' , ' Veer' , 'Singh' , '101 Hillingdon Ave' , 'Mississauga' , 'ON' , 'L4L8W9' , '1476362446' , 'jsingh@uhc.ca ' , 'Physician' , '2018-06-28 ','1993-01-28 ' , 'male' , 'medical'),
('1464864990' , 'Lee' , NULL , 'Min-Ho' , '24 Hammersmith Ave' , 'Mississauga' , 'ON' , 'L5L2C6' , '1020873400' , 'lho122@uhc.ca ' , 'Therapist' ,'2018-06-29 ', '1992-02-25 ' , 'male' , 'medical');

--Populate Employee_PositionHist
INSERT INTO Employee_PositionHist (EmployeeID, PastJob_Title, Start_Date, End_Date)
VALUES
('2280224156','Assistant Manager ' ,' 2012-06-01',' 2018-09-19'),
('3114044530','Intern ' ,' 1991-05-05',' 1993-06-01'),
('3114044530','Resident ' ,' 1993-06-01',' 1996-06-20'),
('4066002382','Nursing Assistant ' ,' 1990-01-01',' 2004-02-16'),
('4325141270','Financial Analyst ' ,' 2006-03-05',' 2007-02-14'),
('9577004292','Cashier ' ,' 2008-07-07',' 2008-02-17'),
('9708834712','Personal Assistant ' ,' 1999-01-04',' 2010-05-12'),
('6344053694','General Practitioner ' ,' 1990-01-05',' 1992-04-01'),
('6709530455','Nursing Assistant ' ,' 2011-01-06',' 2016-11-20'),
('6489682365','Resident ' ,' 1993-06-01',' 1996-06-28'),
('1464864990','Resident ' ,' 1993-06-01',' 1996-06-29');


-- Populate MedEmployee_School
INSERT INTO MedEmployee_School (
EmployeeID, School)
VALUES
('3114044530','McGill University'),
('3114044530','McMaster University'),
('4066002382','McMaster University'),
('6344053694','Dalhousie University'),
('6709530455','Dalhousie University'),
('6489682365','McGill University'),
('6489682365','Northern Ontario School of Medicine'),
('1464864990','McGill University'),
('1464864990','McGill University');

--Populate MedEmployee_Specialty
INSERT INTO MedEmployee_Specialty (EmployeeID, Specialty)
VALUES
('3114044530','Surgery'),
('3114044530','Pediatrics'),
('4066002382','Pathology'),
('4066002382','Family Medicine'),
('6344053694','Radiology'),
('6709530455','Internal Medicine'),
('6709530455','Obstetrics & Gynaecology'),
('1464864990','Oncology'),
('1464864990','Public Health');

--Populate MedEmployee_Cred
INSERT INTO MedEmployee_Cred (EmployeeID, Credential)
VALUES
('3114044530','Bachelor of Surgery'),
('3114044530','Bachelor of Medicine'),
('4066002382','Doctor of Clinical Medicine'),
('4325141270','Certified Healthcare Financial Professional'),
('4325141270','Certified Public Accountant'),
('2280224156','Certified Clinical Account Manager'),
('9577004292','GED'),
('9708834712','High School Diploma'),
('6344053694','Bachelor of Surgery'),
('6344053694','Bachelor of Medicine'),
('6709530455','Master of Clinical Medicine'),
('6489682365','Doctor of Clinical Medicine'),
('1464864990','Master of Clinical Medicine');


--Populate Employee_Skill
INSERT INTO Employee_Skill (EmployeeID, Skill)
VALUES
('3114044530','Good motor skills'),
('3114044530','Communication'),
('3114044530','Teamwork'),
('4066002382','Analytical Thinking'),
('4066002382','Communication'),
('4325141270','Integrity'),
('4325141270','Analytical Thinking'),
('2280224156','Delegation'),
('2280224156','Teamwork'),
('2280224156','Planning'),
('9577004292','Physical dexterity'),
('9577004292','Agility'),
('9708834712','Organization'),
('9708834712','Multitasking'),
('9708834712','Communication'),
('6344053694','Attention to detail'),
('6344053694','Critical Thinking'),
('6709530455','Emotional Resilience'),
('6709530455','Communication'),
('6709530455','Sensitivity'),
('6489682365','Decision Making'),
('1464864990','Extensive Knowledge of Policies');

--Populate Patient
INSERT INTO Patient (patientid, p_fname, p_mname, p_lname, p_address, p_city, p_province, p_postal_code, p_phone, p_email, p_birthdate, p_gender, ohip, kin_fname, kin_lname, kin_phone, fdoc_fname, fdoc_lname, fdoc_phone)
VALUES ('5712363533', 'Fedel', 'Shelby', 'Fuller', '2300 Yonge St.', 'Toronto', 'ON', 'M2N3A5', '6475687901', 'ffuller@yahoo.com', '1985-01-20', 'male','8974561232AB', 'Sally', 'Fuller', '4164587912', 'Preston', 'Burke', '6478798465'),
	('6502031929', 'Jane', NULL, 'Doe', '1770 Bayview St.', 'Toronto', 'ON', 'M2N7S1', '4162910932', 'djane@gmail.com', '1990-02-16', 'female', '4568791234MA', 'Sal', 'Martin', '4167281393', 'Meredith', 'Grey', '9052132578'),
	('4225147535', 'John', NULL, 'Doe', '1600 Yonge St.', 'Toronto', 'ON', 'M2N6X5', '6475728192', 'john.doe@hotmail.com', '1992-03-25','male', '2874652901BV', 'Jerry', 'Doe', '4169402103', 'Larry', 'Altman', '6472930210'),
	('6416871851', 'Drake', 'Case', 'Mallory', '105 Newton Road', 'Brampton', 'ON', 'L4T3B4', '4165321589', 'dmallory@outlook.ca', '1970-05-20', 'male','6416871851DM', 'Cassy', 'Mallory', '6477562130', 'Cristina', 'Yang', '9053256874'),
	('1629264463', 'Paden', 'Chance', 'Laten', '105 Norton Avenue', 'Toronto', 'ON', 'M2N4A5', '4161546987', 'padenc@yahoo.ca', '1960-04-21', 'male', '3866879023PC', 'Joe', 'Laten', '6478945621', 'Owen', 'Hunt', '4162824668'),
	('8158367389', 'Suna', NULL, 'Hollands', '600 Eglinton Avenue West', 'Toronto', 'ON', 'M5N1C1', '4166523214', 'suna.hollands@gmail.com','1950-10-31', 'female', '6548798455SH', 'John', 'Hollands', '4165622135', 'Arizona', 'Robbins', '6478954620'),
	('1900820319', 'Jeremy', NULL, 'Blankenship', '25 Greenview Avenue', 'Toronto', 'ON', 'M2M0A5', '4165689780', 'jblankenship@gmail.com', '1990-11-15', 'male', '9167843029JB', 'Lelia', 'Warren', '9056548790', 'Kris', 'Peterson', '6478955620'),
	('1897268495', 'Jesus', NULL, 'Oneill', '20 Richardson Street', 'Toronto', 'ON', 'M5A0S6', '4162356980', 'therealjesus@aol.com', '1960-12-25','male', '9969637116JO', 'Shawn', 'Mendes', '6477654321', 'Emily', 'Dixon', '9056321478'),
	('9218039668', 'Percy', NULL, 'Tyler', '96 Goulding Avenue', 'Toronto', 'ON', 'M2M1L4', '6474567890', 'percyt@yahoo.ca', '1945-11-04', 'female', '5966274032PT', 'Marcella', 'Tyler', '4165898465', 'Lenora', 'Greene', '9051023495'),
	('9160477071', 'Vonda', NULL, 'Thornton', '15 Greenview Avenue', 'Toronto', 'ON', 'M2N4A5', '9053025612', 'Thornton21@gmail.com', '1999-07-12', 'female', '9916203993ST', 'Devin', 'Thornton', '4162467912', 'Richard', 'Webber', '9056487921');

-- Populate Pat_allergy
INSERT INTO pat_allergy(
	patientid, allergy)
	VALUES ('5712363533', 'Asprin'),
	('6502031929', 'Morphine, Asprin'),
	('1629264463', 'Codeine'),
	('8158367389', 'Ibuprofen'),
	('9218039668', 'Antihistamine');

-- Populate Pat_detail
INSERT INTO pat_detail(
	patientid, details)
	VALUES ('5712363533', 'Pancreatic Removed'),
	('6502031929', 'Mole Removal'),
	('1629264463', 'Clipping off Aneurysm'),
	('8158367389', 'Arrhythmia Surgery'),
	('1897268495', 'Myectomy'),
	('9218039668', 'Arrhythmia Surgery, Clipping off Aneurysm');


-- Populate Appointment
INSERT INTO Appointment(
	appointmentid, patientid, employeeid, scheduled_date, scheduled_time, Employee_Notes, Diagnosis_Details, Treatment_Details, actual_date, actual_time, actual_time_end)

VALUES ('1000000000', '5712363533', '3114044530', '2019-12-20', '15:00:00','Needs specialist referral', 'Thyroid Tumor', 'Synthroid', '2020-01-03', '13:00:00', '13:20:00'),

('2000000000', '5712363533', '4066002382', '2020-01-04', '15:00:00', 'Patient has trouble doing long physical activities', 'Shortness of breath', 'Ventolin', '2020-01-04', '16:00:00', '17:25:00'),

('3000000000', '4225147535', '3114044530', '2019-12-23', '17:00:00', 'Patient continues to feel pain in abdomen', 'Peptic Ulcer', 'Nexium', '2020-01-03','17:00:00','18:00:00'),

('4000000000', '6416871851', '6344053694', '2020-01-15', '13:00:00', 'Patient feels sharp pain in chest', 'High Cholesterol', 'Crestor', '2020-01-20', '10:00:00','12:09:00'),

('5000000000', '1629264463', '6709530455', '2020-01-03', '14:00:00', 'Patient cannot concentrate on work', 'Hot Flashes', 'Alora', '20202-01-03', '13:45:00', '13:55:00'),

('6000000000', '1900820319', '6489682365', '2020-01-06', '11:00:00', 'Patient cannot climb up the stairs', 'Esophageal spasms', 'Buscopan', '2020-01-06', '11:30:00', '11:40:00'),

('1200000000', '1900820319', '1464864990', '2019-12-20', '12:00:00', 'Patient should not operate heavy machinery ', 'Surgery', 'Codeine', '2020-01-03', '12:00:00','13:30:05'),

('7000000000', '1900820319', '1464864990', '2020-01-22', '12:00:00', 'Patient should not operate heavy machinery ', 'Surgery', 'Codeine', '2020-01-22', '12:00:00','14:00:05'),

('8000000000', '1897268495', '3114044530', '2020-01-03', '10:00:00', 'Take the meds twice daily ', 'Dermatophytosis', 'Fluconazole', '2020-01-03', '10:30:00', '10:45:00'),

('9000000000', '9218039668', '4066002382', '2020-01-04', '09:00:00', 'Patient continues to have headaches', 'Migraine', 'Nurofen', '2020-01-04', '10:00:00', '11:28:00'),

('1100000000', '9160477071', '6344053694', '2020-01-13', '13:00:00', 'Patient has new pain in the hip', 'Fractured femur', 'Paracetamol', '2020-01-13', '13:30:00', '13:55:00');


-- Populate Vendor
INSERT INTO Vendor (VendorID, V_Name, V_Address, V_City, V_Province, V_PostalCode, V_Phone, V_Email, V_ContactFName, V_ContactLName)

VALUES('1234567890','Bright Health','602 Hastings Street','Vancouver','BC','V6B1P2', '2505642644','info@brighthealth.ca', 'Bill', 'Gordon'),

	('2134567890','Caredove','25 Mississaga St E','Orillia','ON','L3V1V4', '8335673683', 'sales@caredove.com', 'Jeff', 'Doleweerd'),

	('3124567890','Carestream','8800 Dufferin Street','Vaughan','ON','L4K0C5', '8667925011', 'info-canada@carestream.com', 'Bob', 'Hamilton'),

	('4123567890','Christie Innomed','516 Rue Dufour','Saint-Eustache','QC','J7R0C3', '8003618750', 'info@christieinnomed.com', 'Christian', 'Johnson'),

	('5123467890','Microquest','94 Street NW','Edmonton','AB','T6E6T7', '8664383762', 'info@microquest.ca', 'Emmie', 'Cadrin');

-- Populate Complaint
INSERT INTO complaint (ComplaintId, START_DATE, END_DATE)
VALUES('0000000001','2020-01-03','2020-01-03'),
('0000000002','2020-01-03','2020-01-14'),
('0000000003','2020-01-03','2020-01-19'),
('0000000004','2020-01-20','2020-01-24'),
('0000000005','2020-01-03','2020-02-05'),
('0000000006','2020-01-06','2020-01-20'),
('0000000007','2020-01-22','2020-02-04'),
('0000000008','2020-01-03','2020-01-07'),
('0000000009','2020-01-04','2020-01-09'),
('0000000010','2020-01-13','2020-01-15'),
('0000000020','2020-01-13','2020-01-15'),
('0000000030','2020-01-13','2020-01-15');

-- Populate Inventory
INSERT INTO Inventory (InventoryID,Num_Stock, Use, Inventory_Type,VendorID)
VALUES ('0000011111','166','Synthroid','Medication','1234567890'),
	('0000022222','299','Syringe','Consumable','2134567890'),
	('0000033333','292','Ventolin','Medication','3124567890'),
	('0000044444','306','Needle','Consumable','4123567890'),
	('0000055555','159','Nexium','Medication','5123467890'),
	('0000066666','306','Gauze','Consumable','3124567890'),
	('0000077777','295','Crestor','Medication','1234567890'),
	('0000088888','496','Gloves','Consumable','1234567890'),
	('0000099999','356','Alora','Medication','2134567890'),
	('0000012121','146','Mask','Consumable','5123467890'),
	('1000011111','272','Buscopan','Medication','1234567890'),
	('1000033333','498','Codeine','Medication','3124567890'),
	('1000055555','449','Fluconazole','Medication','5123467890'),
	('1000077777','216','Nurofen','Medication','1234567890'),
	('1000099999','280','Paracetamol','Medication','2134567890');

--Populate Insurance_Provider
INSERT INTO Insurance_Provider (InsuranceID, Insurance_PolNum, Insurance_Partner, I_Phone, I_Email)
VALUES('1100000210','800125062','Manulife','8002686195','info@manulife.ca'),
	      ('1100000302','702249271','Sunlife','8003449810','contact@sunlife.ca'),
	      ('1100000181','370112828','BlueCross','8007119212','info@bluecross.ca'),
	      ('1200000110','233122912','Desjardins','8008837281','info@desjardins.ca');

--Populate Insurance_Claim
INSERT INTO Insurance_Claim (ClaimID, Proced_Name, Insure_Code, Insure_Partner, Date_Submit, Amount_Submit, Amount_Cover, ComplaintID, InsuranceID)
VALUES('1000837461','XRAY10','84757','Manulife','2019-11-10','220','210','0000000001','1100000210'),
      ('1000472638','DERMA8','58121','Sunlife','2019-11-08','340','235','0000000003','1100000302'),
      ('1000284830','TETBOOSTER','30193','BlueCross','2019-11-12','185','105','0000000005','1100000181'),
      ('1000582721','SPECREC34','72631','Desjardins','2019-03-12','110','100','0000000007','1200000110'),
      ('1000258123','SPECREC12','47128','Manulife','2019-12-17','120','110','0000000001','1100000210');

-- Populate Inventory_use
INSERT INTO inventory_use
VALUES ('0000000001', '0000011111','10'),
('0000000001', '0000022222','6'),
('0000000001', '0000033333','4'),
('0000000002', '0000012121','4'),
('0000000002', '0000012121','4'),
('0000000008', '0000011111','20');

-- Populate multiple_appt
INSERT INTO multiple_appt(
	appointmentid, complaintid)

VALUES ('1000000000','0000000001'),

('2000000000','0000000002'),
('2000000000','0000000003'),
('3000000000','0000000004'),
('4000000000','0000000005'),
('5000000000','0000000006'),
('6000000000','0000000007'),
('7000000000','0000000009'),
('8000000000','0000000010'),
('9000000000','0000000020'),
('1100000000','0000000030'),
('1200000000','0000000008');
----------------------------------------------------------------
--List all employees (Employee ID, name) along with their employment history (all positions held including current position)
--Show all from Employee table and any that matches on Employee_PositionHist table:
--EmployeeID, FName, LastName, Job Title, Past Job Title, StartDate, EndDate
SELECT employee.employeeid, e_fname, e_lname, e_jobtitle, pastjob_title
FROM employee
LEFT JOIN employee_positionhist
ON employee.employeeid = employee_positionhist.employeeid;
-----------------------------------------------------------------------
--At the end of the day the DBA should run this query first to update the inventory
-- The current date is assumed to be January 3rd, 2020 (2020-01-03)
DROP TABLE u_inventory;
CREATE TABLE u_inventory AS(
SELECT SUM(inventory_use.quantity_used) as Quantity, Inventory.InventoryID
FROM Inventory_use
INNER JOIN Inventory
ON Inventory_use.InventoryID = Inventory.InventoryID
INNER JOIN multiple_appt
ON multiple_appt.complaintID = inventory_use.complaintID
INNER JOIN appointment
ON multiple_appt.appointmentID = appointment.appointmentID
WHERE appointment.actual_date = '2020-01-03'
GROUP BY Inventory.InventoryID
);
UPDATE Inventory
SET num_stock = num_stock - u_inventory.quantity
FROM u_inventory
WHERE Inventory.InventoryID = u_inventory.InventoryID AND Inventory.InventoryID IN (SELECT u_inventory.InventoryID FROM u_inventory);
-------------------------------------------------------------------------------------------------------------------------------------------
--The threshold purchase order is run afterward by DBA with the following query
-- The purchase order can be printed and faxed to vendor
DROP TABLE p_order;
CREATE TABLE p_order AS(
SELECT appointment.actual_date, inventory.inventoryID, inventory_use.quantity_used, Vendor.V_Name, Vendor.V_contactfname, Vendor.V_contactlname,
Inventory.inventory_type, Inventory.use, inventory.vendorID
FROM inventory_use
INNER JOIN multiple_appt
ON multiple_appt.complaintID = inventory_use.complaintID
INNER JOIN appointment
ON multiple_appt.appointmentID = appointment.appointmentID
INNER JOIN Inventory
ON inventory_use.inventoryid = Inventory.inventoryID
INNER JOIN Vendor
ON Inventory.VendorID = Vendor.VendorID
WHERE actual_date='2020-01-03' AND Inventory.num_stock < 140
);
SELECT vendorID as "Unique ID", 240 as Quantity, v_name as "Vendor Name", v_contactfname as "Contact First Name",
v_contactlname as "Contact Last Name", inventory_type as "Inventory Type", use as "Use"
FROM p_order
GROUP BY vendorID, InventoryID, v_name, v_contactfname, v_contactlname, inventory_type, use;

------------------------------------------------------------------------------------------------------------------------------------
--The daily purchase order is run at the end to make further orders for medication and consumable that was used in the day.
DROP TABLE p_order;
CREATE TABLE p_order AS(
SELECT appointment.actual_date, inventory.inventoryID, inventory_use.quantity_used, Vendor.V_Name, Vendor.V_contactfname, Vendor.V_contactlname,
Inventory.inventory_type, Inventory.use, inventory.vendorID
FROM inventory_use
INNER JOIN multiple_appt
ON multiple_appt.complaintID = inventory_use.complaintID
INNER JOIN appointment
ON multiple_appt.appointmentID = appointment.appointmentID
INNER JOIN Inventory
ON inventory_use.inventoryid = Inventory.inventoryID
INNER JOIN Vendor
ON Inventory.VendorID = Vendor.VendorID
WHERE actual_date='2020-01-03' AND num_stock >= 140
);

SELECT vendorID as "Unique ID", SUM(quantity_used) as Quantity, v_name as "Vendor Name", v_contactfname as "Contact First Name",
v_contactlname as "Contact Last Name", inventory_type as "Inventory Type", use as "Use"
FROM p_order
GROUP BY vendorID, InventoryID, v_name, v_contactfname, v_contactlname, inventory_type, use;
----------------------------------------------------------------------------------------------------------------------------------
-- List the insurance claim amount submitted and amount covered for an appointment of a given patient
SELECT insurance_claim.claimid,appointment.patientid, appointment.appointmentid,insurance_claim.complaintID, insurance_claim.amount_submit, insurance_claim.amount_cover
FROM insurance_claim
INNER JOIN multiple_appt
ON insurance_claim.complaintid = multiple_appt.complaintid
INNER JOIN appointment
ON multiple_appt.appointmentid = appointment.appointmentid
WHERE appointment.appointmentid = '1000000000' ;
------------------------------------------------------------------------------------------------------------------------------------
--  List all patient appointments for a given medical employee (you pick a sample employee) in a given week (you pick a sample week)
SELECT a.EmployeeID , c.e_fname as "Employee First Name", c.e_lname as "Employee Last Name",
		a.PatientID, b.P_fName as "Patient First Name", b.P_lName as "Patient Last Name", Date_Part('week', actual_date) as Week
FROM appointment as a INNER JOIN Employee as c on
c.EmployeeID = a.EmployeeID INNER JOIN Patient as b
ON b.PatientID = a.PatientID
WHERE Date_Part('week', actual_date) = '1' and a.EmployeeID = '3114044530';
--------------------------------------------------------------------------------------------------------------------------------------
-- List all medication used for a given complaint (you pick a sample complaint)
SELECT inventory_use.inventoryid, inventory_use.complaintID, inventory.inventory_type, inventory.use
FROM inventory_use
INNER JOIN inventory
ON inventory_use.inventoryid = inventory.inventoryid
WHERE inventory.inventory_type = 'Medication' AND complaintID = '0000000001';
----------------------------------------------------------------------------------------------------------------------------------------
-- List all consumable used for a given complaint (you pick a sample complaint)
SELECT inventory_use.inventoryid, inventory_use.complaintID, inventory.inventory_type, inventory.use
FROM inventory_use
INNER JOIN inventory
ON inventory_use.inventoryid = inventory.inventoryid
WHERE inventory.inventory_type = 'Consumable' AND complaintID = '0000000001';
