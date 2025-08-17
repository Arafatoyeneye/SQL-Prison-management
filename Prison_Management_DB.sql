/*
    12/08/2024
    Authors: Brandon Hafferman, Alec Burns, Arafat Oyeneye, Aye Keita, and Henok Tekle
    
    Desciption: This Database was designed for a class final project. It does miss several key components that a true prison system would impliment as this project needed
    to stay inside the scope and goals of the class. It does serve as a prime example, however, as a proof of concept design. This system's key tables are the Inmate table
    and the staff table which have many relations to other tables. The Inmates table is the key driver table for this database. 
    
    The PrisonManagement database is designed to manage various aspects of a correctional facility, including staff information, inmate records, facility maintenance, 
    medical care, visitation schedules, programs, and offenses. It provides a robust framework for handling data efficiently while ensuring proper relationships between 
    entities like staff, inmates, and administrative components.
    
    The business situation of this database is that of a rehabilitation prison rather than a for profit prison. As such, none of our KPIs, views, or tables have 
    anything related to the profit or budget of the prison. 

    
    
    Table Break Down:
    Staff Table
		Purpose: Contains general information about all staff members working in the prison, including guards, administrators, medical staff, and maintenance personnel.
        Also, the Staff Table is a super type for all staff.
		Columns:
		StaffID: Unique identifier for each staff member.
		First_Name and Last_Name: Name of the staff member.
		Salary: Monthly salary of the staff member.
	Guards Table
		Purpose: Holds specific information about prison guards, who are a subtype of the staff.
		Columns:
		GuardID: Unique identifier for each guard.
		StaffID: Reference to the general staff table.
		Cell_BlockID: Indicates the cell block assigned to the guard.
		Access_Level: Specifies the guard's access permissions.
	Administrators Table
		Purpose: Manages details for administrative personnel.
		Columns:
		AdministratorID: Unique identifier for administrators.
		StaffID: Reference to the general staff table.
		Administrator_Type: Role or designation of the administrator.
	Maintenance Staff Table
		Purpose: Captures data on staff involved in facility maintenance.
		Columns:
		Maintenance_StaffID: Unique identifier for maintenance personnel.
		StaffID: Reference to the general staff table.
		Maintenance_Specialization: Area of expertise, e.g., electrical, plumbing.
	Maintenance Records Table
		Purpose: Logs all maintenance activities performed in the facility.
		Columns:
		Maintenance_RecordID: Unique identifier for each record.
		Task_Performed: Description of the maintenance task.
		Maintenance_Comments: Additional notes on the task.
		Maintenance_Date: Date of the task.
	Staff Maintenance Records Table
		Purpose: Links maintenance staff to specific maintenance records.
		Columns:
		Staff_Maintenance_RecordID: Unique identifier for this relationship.
		Maintenance_StaffID: Reference to maintenance staff.
		Maintenance_RecordID: Reference to maintenance records.
	Medical Staff Table
		Purpose: Contains details about the medical personnel in the prison.
		Columns:
		Medical_StaffID: Unique identifier for medical staff.
		StaffID: Reference to the general staff table.
		Specialty: Area of medical expertise.
	Medical Records Table
		Purpose: Stores health-related records of inmates.
		Columns:
		Medical_RecordID: Unique identifier for the medical record.
		Medical_Date: Date of the medical examination or care.
		Diagnosis and Medical_Comments: Health status and additional notes.
		InmateID: Reference to the inmate receiving care.
		Receiving_Care: Boolean indicating if the inmate is currently under care.
	Staff Medical Records Table
		Purpose: Connects medical staff with medical records they have managed.
		Columns:
		Staff_Medical_RecordsID: Unique identifier for this link.
		Medical_StaffID: Reference to medical staff.
		Medical_RecordID: Reference to medical records.
	Inmate Table
		Purpose: Stores basic and legal information about prisoners.
		Columns:
		InmateID: Unique identifier for inmates.
		First_Name, Last_Name: Name of the inmate.
		Conviction and Conviction_Date: Nature and date of the crime.
		Risk_Level: Security risk score.
		Release_Date: Scheduled release date.
		SSN: Social Security Number (unique).
		Unique_Prison_ID: Unique internal ID for the prison system.
	Cells Table
		Purpose: Manages cell assignments for inmates.
		Columns:
		CellID: Unique identifier for the cell.
		Comments: Notes on cell conditions.
		Cell_BlockID: Reference to the cell block.
		InmateID: Reference to the inmate assigned to the cell.
	Cell Blocks Table
		Purpose: Provides information about sections of the prison containing multiple cells.
		Columns:
		Cell_BlockID: Unique identifier for cell blocks.
		Max_Occupancy: Maximum number of inmates allowed.
		Cell_Block_Name: Name or label of the block.
		Security_Level: Security classification of the block.
	Visits Table
		Purpose: Logs inmate visitation records.
		Columns:
		VisitID: Unique identifier for visits.
		InmateID: Reference to the inmate being visited.
		Visit_Date: Date of the visit.
		Visit_Comments: Notes about the visit.
	Internal Transfers Table
		Purpose: Tracks inmate movements between cells within the facility.
		Columns:
		Internal_TransferID: Unique identifier for the transfer.
		Current_Cell and New_Cell: References to cells involved in the transfer.
		InmateID: Reference to the inmate being transferred.
		Reason_for_Transfer: Explanation for the move.
	Inmate Release History Table
		Purpose: Records details of inmates who have been released.
		Columns:
		Inmate_Release_HistoryID: Unique identifier for the release record.
		InmateID and Unique_Prison_ID: References to the inmate.
		Release_Date: Date of release.
		Release_Comments: Notes about the release.
	Prison Programs Table
		Purpose: Manages programs offered to inmates, like education or therapy.
		Columns:
		Prison_ProgramID: Unique identifier for the program.
		Program_Start_Date and Program_END_Date: Duration of the program.
		Program_Type: Type of program.
		Program_Specifics and Program_Comments: Details and remarks.
	Inmate Programs Table
		Purpose: Links inmates to the programs they participate in.
		Columns:
		Inmate_ProgramID: Unique identifier for this relationship.
		Prison_ProgramID: Reference to the prison program.
		InmateID: Reference to the inmate.
	Offense Types Table
		Purpose: Defines classifications of offenses that can occur within the prison.
		Columns:
		Offense_TypeID: Unique identifier for the offense type.
		Offense_Classification: Category or level of the offense.
		Offense_Comments: Additional remarks about the offense.
	Offenses Table
		Purpose: Logs offenses committed by inmates within the prison.
		Columns:
		OffenseID: Unique identifier for the offense.
		Offense_TypeID: Reference to the offense type.
		InmateID: Reference to the inmate who committed the offense.
		Offense_Date: Date when the offense occurred.
*/


SET @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS; -- Save the current state of foreign key checks into a user-defined variable to restore later
SET FOREIGN_KEY_CHECKS = 0; -- Temporarily disable foreign key checks to allow for dropping and creating tables without constraint issues


DROP DATABASE IF EXISTS `PrisonManagement`;
-- Database for Prison Management System
CREATE DATABASE `PrisonManagement`;
USE `PrisonManagement`;


-- Staff Table (Supertype)
DROP TABLE IF EXISTS Staff;
CREATE TABLE Staff (
    StaffID INT AUTO_INCREMENT PRIMARY KEY,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Salary DECIMAL(10, 2)
);

-- Guards Table (Subtype of Staff)
DROP TABLE IF EXISTS Guards;
CREATE TABLE Guards (
    GuardID INT AUTO_INCREMENT PRIMARY KEY,
    StaffID INT UNIQUE,
    Cell_BlockID INT,
    Access_Level VARCHAR(50),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
    FOREIGN KEY (Cell_BlockID) REFERENCES Cell_Blocks(Cell_BlockID)
);

-- Administrators Table (Subtype of Staff)
DROP TABLE IF EXISTS Administrators;
CREATE TABLE Administrators (
    AdministratorID INT AUTO_INCREMENT PRIMARY KEY,
    StaffID INT UNIQUE,
    Administrator_Type VARCHAR(50),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);

-- Maintenance Staff Table (Subtype of Staff)
DROP TABLE IF EXISTS Maintenance_Staff;
CREATE TABLE Maintenance_Staff (
    Maintenance_StaffID INT AUTO_INCREMENT PRIMARY KEY,
    StaffID INT UNIQUE,
    Maintenance_Specialization VARCHAR(255),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);

-- Maintenance Records Table
DROP TABLE IF EXISTS Maintenance_Records;
CREATE TABLE Maintenance_Records (
    Maintenance_RecordID INT AUTO_INCREMENT PRIMARY KEY,
    Task_Performed VARCHAR(255),
    Maintenance_Comments VARCHAR(255),
    Maintenance_Date DATE
);

-- Staff Maintenance Records Bridge Table
DROP TABLE IF EXISTS Staff_Maintenance_Records;
CREATE TABLE Staff_Maintenance_Records (
    Staff_Maintenance_RecordID INT AUTO_INCREMENT PRIMARY KEY,
    Maintenance_StaffID INT,
    Maintenance_RecordID INT,
    FOREIGN KEY (Maintenance_StaffID) REFERENCES Maintenance_Staff(Maintenance_StaffID),
    FOREIGN KEY (Maintenance_RecordID) REFERENCES Maintenance_Records(Maintenance_RecordID)
);

-- Medical Staff Table (Subtype of Staff)
DROP TABLE IF EXISTS Medical_Staff;
CREATE TABLE Medical_Staff (
    Medical_StaffID INT AUTO_INCREMENT PRIMARY KEY,
    StaffID INT UNIQUE,
    Specialty VARCHAR(100),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);

-- Medical Records Table
DROP TABLE IF EXISTS Medical_Records;
CREATE TABLE Medical_Records (
    Medical_RecordID INT AUTO_INCREMENT PRIMARY KEY,
    Medical_Date DATE,
    Diagnosis VARCHAR(255),
    Medical_Comments VARCHAR(255),
    InmateID INT,
    Receiving_Care BOOLEAN,
    FOREIGN KEY (InmateID) REFERENCES Inmate(InmateID)
);

-- Staff Medical Records Bridge Table
DROP TABLE IF EXISTS Staff_Medical_Records;
CREATE TABLE Staff_Medical_Records (
    Staff_Medical_RecordsID INT AUTO_INCREMENT PRIMARY KEY,
    Medical_StaffID INT,
    Medical_RecordID INT,
    FOREIGN KEY (Medical_StaffID) REFERENCES Medical_Staff(Medical_StaffID),
    FOREIGN KEY (Medical_RecordID) REFERENCES Medical_Records(Medical_RecordID)
);

-- Prison Table and Related Entities
-- Inmate Table
DROP TABLE IF EXISTS Inmate;
CREATE TABLE Inmate (
    InmateID INT AUTO_INCREMENT PRIMARY KEY,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Conviction VARCHAR(255),
    Conviction_Date DATE,
    Risk_Level INT,
    Release_Date DATE,
    SSN VARCHAR(15) UNIQUE,
    Unique_Prison_ID BIGINT UNIQUE
);

-- Cells Table
DROP TABLE IF EXISTS Cells;
CREATE TABLE Cells (
    CellID INT AUTO_INCREMENT PRIMARY KEY,
    Comments VARCHAR(255), -- Referring to any wear and tear or special notes
    Cell_BlockID INT,
    InmateID INT UNIQUE,
    FOREIGN KEY (Cell_BlockID) REFERENCES Cell_Blocks(Cell_BlockID),
    FOREIGN KEY (InmateID) REFERENCES Inmate(InmateID)
);

-- Cell Blocks Table
DROP TABLE IF EXISTS Cell_Blocks;
CREATE TABLE Cell_Blocks (
    Cell_BlockID INT AUTO_INCREMENT PRIMARY KEY,
    Max_Occupancy INT,
    Cell_Block_Name VARCHAR(255),
    Security_Level VARCHAR(100)
);

-- Visits Table
DROP TABLE IF EXISTS Visits;
CREATE TABLE Visits (
    VisitID INT AUTO_INCREMENT PRIMARY KEY,
    InmateID INT,
    Visit_Date DATE,
    Visit_Comments VARCHAR(255),
    FOREIGN KEY (InmateID) REFERENCES Inmate(InmateID)
);

-- Internal Transfers Table
DROP TABLE IF EXISTS Internal_Transfers;
CREATE TABLE Internal_Transfers (
    Internal_TransferID INT AUTO_INCREMENT PRIMARY KEY,
    Current_Cell INT,
    New_Cell INT,
    InmateID INT,
    Reason_for_Transfer VARCHAR(255),
	FOREIGN KEY (InmateID) REFERENCES Inmates(InmateID),
    FOREIGN KEY (Current_Cell) REFERENCES Cells(CellID),
    FOREIGN KEY (New_Cell) REFERENCES Cells(CellID)
);

-- Inmate Release History Table
DROP TABLE IF EXISTS Inmate_Release_History;
CREATE TABLE Inmate_Release_History (
    Inmate_Release_HistoryID INT AUTO_INCREMENT PRIMARY KEY,
    InmateID INT,
    Unique_Prison_ID BIGINT,
    Release_Date DATE,
    Release_Comments VARCHAR(255),
    FOREIGN KEY (InmateID) REFERENCES Inmate(InmateID),
    FOREIGN KEY (Unique_Prison_ID) REFERENCES Inmate(Unique_Prison_ID)
);

-- Prison Programs Table
DROP TABLE IF EXISTS Prison_Programs;
CREATE TABLE Prison_Programs (
    Prison_ProgramID INT AUTO_INCREMENT PRIMARY KEY,
    Program_Start_Date DATE,
    Program_END_Date DATE,
    Program_Type VARCHAR(100),
    Program_Specifics VARCHAR(255),
    Program_Comments VARCHAR(255)
);

-- Inmate Programs Bridge Table
DROP TABLE IF EXISTS Inmate_Programs;
CREATE TABLE Inmate_Programs (
    Inmate_ProgramID INT AUTO_INCREMENT PRIMARY KEY,
    Prison_ProgramID INT,
    InmateID INT,
    FOREIGN KEY (Prison_ProgramID) REFERENCES Prison_Programs(Prison_ProgramID),
    FOREIGN KEY (InmateID) REFERENCES Inmate(InmateID)
);

-- Offense Types Table
DROP TABLE IF EXISTS Offense_Types;
CREATE TABLE Offense_Types (
    Offense_TypeID INT AUTO_INCREMENT PRIMARY KEY,
    Offense_Classification VARCHAR(100),
    Offense_Comments VARCHAR(255)
);

-- Offenses Bridge Table
DROP TABLE IF EXISTS Offenses;
CREATE TABLE Offenses (
    OffenseID INT AUTO_INCREMENT PRIMARY KEY,
    Offense_TypeID INT,
    InmateID INT,
    Offense_Date DATE,
    FOREIGN KEY (Offense_TypeID) REFERENCES Offense_Types(Offense_TypeID),
    FOREIGN KEY (InmateID) REFERENCES Inmate(InmateID)
);


-- ============================================================================================================================================================================== --
-- Insert Statments


INSERT INTO Staff (First_Name, Last_Name, Salary) VALUES 
('Hank', 'McSneezle', 500000.00),
('Babs', 'Nuttersworth', 60000.00),
('Jimothy', 'Clangbucket', 55000.00),
('Eliza', 'Wigglebottom', 45000.00),
('Fergus', 'Doodlewhip', 48000.00),
('Minnie', 'Fluffernoodle', 47000.00),
('Grover', 'Bananaface', 51000.00),
('Zelda', 'Snapdragon', 53000.00),
('Thaddeus', 'Jellyspoon', 5000.00),
('Luna', 'Picklepants', 62000.00),
('Archibald', 'Whiskerfoot', 57000.00),
('Clara', 'Snickerdoodle', 46000.00),
('Waldo', 'Twinkletoes', 52000.00),
('Eudora', 'Bumblecrump', 48000.00),
('Bartholomew', 'Muffinface', 54000.00),
('Gertie', 'Jellybean', 49000.00),
('Oscar', 'Crankleberry', 60000.00),
('Penelope', 'Fizzlewhip', 43000.00),
('Rupert', 'Tiddlywink', 58000.00),
('Margo', 'Wobblefeather', 47000.00),
('Sylvester', 'Buttonsnout', 62000.00),
('Winnie', 'Crumblepatch', 45000.00),
('Cecil', 'Nibbletooth', 55000.00),
('Matilda', 'Quibblefluff', 56000.00),
('Horatio', 'Gigglebuns', 50000.00),
('Florence', 'Twizzlestick', 47000.00),
('Alfred', 'Puffernickel', 52000.00),
('Greta', 'Muffinwhisk', 48000.00),
('Hugo', 'Sparklefrost', 51000.00),
('Fiona', 'Dabbledeedle', 49000.00),
('Lionel', 'Flitterwig', 58000.00),
('Ivy', 'Sprinklefoot', 44000.00),
('Victor', 'Bumblepuff', 53000.00),
('Nora', 'Ticklethistle', 50000.00),
('Hector', 'Jigglesnout', 55000.00),
('Prudence', 'Snagglefluff', 47000.00),
('Dexter', 'Wifflebeam', 59000.00),
('Rosalind', 'Pinkerpeach', 54000.00),
('Quincy', 'Fizzlepot', 52000.00),
('Ophelia', 'Nibblestone', 48000.00);


INSERT INTO Guards (StaffID, Cell_BlockID, Access_Level) VALUES 
(1, 1, 'High'),
(2, 2, 'Medium'),
(3, 3, 'Low'),
(4, 4, 'High'),
(5, 5, 'Medium'),
(6, 6, 'Low'),
(7, 7, 'High'),
(8, 8, 'Medium'),
(9, 9, 'Low'),
(10, 10, 'High');


INSERT INTO Administrators (StaffID, Administrator_Type) VALUES 
(11, 'Warden'),
(12, 'Assistant Warden'),
(13, 'Chief of Security'),
(14, 'Facility Manager'),
(15, 'Director of Operations'),
(16, 'HR Manager'),
(17, 'Finance Manager'),
(18, 'Program Coordinator'),
(19, 'Training Manager'),
(20, 'Medical Administrator');


INSERT INTO Maintenance_Staff (StaffID, Maintenance_Specialization) VALUES 
(21, 'Plumbing'),
(22, 'Electrical'),
(23, 'HVAC'),
(24, 'Carpentry'),
(25, 'Painting'),
(26, 'Masonry'),
(27, 'Welding'),
(28, 'General Repairs'),
(29, 'Landscaping'),
(30, 'Waste Management');


INSERT INTO Maintenance_Records (Task_Performed, Maintenance_Comments, Maintenance_Date) VALUES
('Repaired electric wiring', 'Fixed a short circuit in Block A', '2023-01-05'),
('Unclogged plumbing', 'Resolved a clogged sink in Block C', '2023-02-12'),
('Repaired HVAC', 'Replaced air filters in Block B', '2023-03-18'),
('Painted cell walls', 'Applied anti-graffiti paint in Block E', '2023-04-22'),
('Fixed water leakage', 'Repaired broken pipes in Block D', '2023-05-10'),
('Reinforced cell bars', 'Welded weakened bars in Block A', '2023-06-15'),
('Checked fire alarms', 'Tested and replaced batteries in Block C', '2023-07-30'),
('Fixed cell door locks', 'Repaired jammed locks in Block E', '2023-08-08'),
('Cleaned ventilation ducts', 'Cleared debris in Block B vents', '2023-09-25'),
('Serviced backup generator', 'Oil change and test run', '2023-10-11');


INSERT INTO Staff_Maintenance_Records (Maintenance_StaffID, Maintenance_RecordID) VALUES
(5, 1),
(6, 2),
(7, 3),
(8, 4),
(9, 5),
(10, 6),
(5, 7),
(6, 8),
(7, 9),
(8, 10);


INSERT INTO Medical_Staff (StaffID, Specialty) VALUES 
(31, 'General Practitioner'),
(32, 'Surgeon'),
(33, 'Psychologist'),
(34, 'Nurse Practitioner'),
(35, 'Radiologist'),
(36, 'Orthopedic Specialist'),
(37, 'Cardiologist'),
(38, 'Dentist'),
(39, 'Nutritionist'),
(40, 'Pharmacist');


INSERT INTO Medical_Records (Medical_Date, Diagnosis, Medical_Comments, InmateID, Receiving_Care) VALUES
('2023-01-15', 'Fractured arm', 'Inmate injured during a brawl', 1, FALSE),
('2023-02-20', 'Anxiety disorder', 'Scheduled counseling sessions', 2, TRUE),
('2023-03-10', 'Flu', 'Prescribed medication', 3, TRUE),
('2023-04-05', 'Broken nose', 'Treated after a fight', 4, TRUE),
('2023-05-25', 'Chronic back pain', 'Prescribed physical therapy', 5, TRUE),
('2023-06-30', 'Food poisoning', 'Treated after consuming spoiled food', 6, TRUE),
('2023-07-20', 'Dental cavity', 'Performed tooth extraction', 7, TRUE),
('2023-08-10', 'Skin rash', 'Prescribed ointment', 8, TRUE),
('2023-09-15', 'Concussion', 'Observed after a fall', 9, TRUE),
('2023-10-25', 'Asthma attack', 'Provided inhaler', 10, TRUE);


INSERT INTO Staff_Medical_Records (Medical_StaffID, Medical_RecordID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(1, 6),
(2, 7),
(3, 8),
(4, 9),
(5, 10);


INSERT INTO Cell_Blocks (Max_Occupancy, Cell_Block_Name, Security_Level) VALUES 
(10, 'Alpha Block', 'Maximum'),
(10, 'Beta Block', 'High'),
(10, 'Gamma Block', 'Medium'),
(10, 'Delta Block', 'Medium'),
(20, 'Epsilon Block', 'Low'),
(10, 'Zeta Block', 'Maximum'),
(10, 'Eta Block', 'High'),
(10, 'Theta Block', 'Medium'),
(10, 'Iota Block', 'Medium'),
(20, 'Kappa Block', 'Low');


INSERT INTO Inmate (First_Name, Last_Name, Conviction, Conviction_Date, Risk_Level, Release_Date, SSN, Unique_Prison_ID) VALUES 
('Darth', 'Vader', 'Galactic Rebellion', '2015-01-01', 10, '2045-01-01', '123-45-6789', 6897114123121),
('Hannibal', 'Lecter', 'Cannibalism', '2010-05-12', 9, '2030-05-12', '987-65-4321', 6897114444556),
('Joker', 'Clownface', 'Terrorism', '2018-06-15', 9, '2040-06-15', '321-54-6789', 7610199987654),
('Thanos', 'Titan', 'Genocide', '2020-03-01', 10, '2050-03-01', '111-22-3333', 8697100123456),
('Voldemort', 'Darklord', 'Dark Magic', '2005-12-15', 8, '2025-12-15', '444-55-6666', 67108111321546),
('Kylo', 'Ren', 'Galactic Treason', '2017-08-22', 7, '2037-08-22', '777-88-9999', 75114117567891),
('Sauron', 'Darkeye', 'Dark Sorcery', '2012-09-10', 9, '2032-09-10', '123-12-1234', 77121101222334),
('Freddy', 'Krueger', 'Dream Invader', '1995-10-31', 10, '2025-10-31', '567-89-1234', 82101110777889),
('Palpatine', 'Sidious', 'Galactic Usurper', '2000-04-20', 10, '2030-04-20', '987-65-4322', 83105100987654),
('Michael', 'Myers', 'Serial Murder', '1980-10-20', 10, '2025-10-20', '222-33-4444', 84105116111223
);


INSERT INTO Cells (Comments, Cell_BlockID, InmateID) VALUES 
('Solitary confinement', 1, 1),
('Requires extra monitoring', 2, 2),
('Solitary confinement', 3, 3),
('Single cell, high-risk', 4, 4),
('General population', 5, 5),
('Under observation', 6, 6),
('Solitary confinement', 7, 7),
('Special security measures', 8, 8),
('General population', 9, 9),
('Solitary confinement', 10, 10),
('Solitary confinement', 10, NULL), -- Empty Cell
('Solitary confinement', 10, NULL), -- Empty Cell
('Solitary confinement', 10, NULL), -- Empty Cell
('Solitary confinement', 10, NULL), -- Empty Cell
('Solitary confinement', 10, NULL); -- Empty Cell


INSERT INTO Visits (InmateID, Visit_Date, Visit_Comments) VALUES
(1, '2023-01-15', 'Discussed parole.'),
(2, '2023-02-20', 'Legal advisor visit.'),
(3, '2023-03-10', 'Family member visited.'),
(4, '2023-04-05', 'Psychiatrist meeting.'),
(5, '2023-05-25', 'Interrogation by officials.'),
(6, '2023-06-30', 'Received a package.'),
(7, '2023-07-20', 'Brief visit by friend.'),
(8, '2023-08-10', 'Inmate discussion group.'),
(9, '2023-09-15', 'Health check follow-up.'),
(10, '2023-10-25', 'Meeting with spiritual guide.');


INSERT INTO Internal_Transfers (Current_Cell, New_Cell, InmateID, Reason_for_Transfer) VALUES
(1, 2, 1, 'Conflict with cellmate'),
(2, 3, 2, 'Better medical access'),
(3, 4, 3, 'Security downgrade'),
(4, 5, 4, 'Safety concerns'),
(5, 6, 5, 'Overcrowding in current block'),
(6, 7, 6, 'Rehabilitation program access'),
(7, 8, 7, 'Requested by inmate'),
(8, 9, 8, 'Behavioral issues'),
(9, 10, 9, 'Medical reasons'),
(10, 1, 10, 'Administrative decision');


INSERT INTO Inmate_Release_History (InmateID, Release_Date, Release_Comments, Unique_Prison_ID) VALUES
(1, '2024-01-15', 'Paroled early for good behavior', 1001),
(2, '2024-02-20', 'Sentence completed', 1002),
(3, '2024-03-10', 'Transferred to another facility', 1001),
(4, '2024-04-05', 'Deportation following sentence completion', 1001),
(5, '2024-05-25', 'Death in custody', 1001),
(6, '2024-06-30', 'Paroled with restrictions', 1001),
(7, '2024-07-20', 'Transferred to psychiatric facility', 1001),
(8, '2024-08-10', 'Released after retrial overturned conviction', 1001),
(9, '2024-09-15', 'Early release due to health issues', 1001),
(10, '2024-10-25', 'Sentence reduced on appeal', 1001);


INSERT INTO Prison_Programs (Program_Start_Date, Program_END_Date, Program_Type, Program_Specifics, Program_Comments) VALUES
('2023-01-10', '2023-02-10', 'Education', 'Basic literacy classes', 'Taught by volunteers'),
('2023-03-01', '2023-04-01', 'Anger Management', 'Group therapy', 'Led by psychologist'),
('2023-05-05', '2023-06-05', 'Vocational Training', 'Woodworking skills', 'Sponsored by local company'),
('2023-07-10', '2023-08-10', 'Substance Abuse', 'Rehabilitation program', 'For inmates with addiction issues'),
('2023-09-01', '2023-10-01', 'Fitness Program', 'Yoga classes', 'Taught by certified instructor'),
('2023-11-01', '2023-12-01', 'Art Therapy', 'Painting and sculpture', 'Focus on self-expression'),
('2023-02-15', '2023-03-15', 'Meditation', 'Mindfulness training', 'Run by spiritual leader'),
('2023-04-20', '2023-05-20', 'Cooking Skills', 'Basic cooking lessons', 'For reintegration training'),
('2023-06-25', '2023-07-25', 'IT Training', 'Basic computer skills', 'For future job prospects'),
('2023-08-30', '2023-09-30', 'Conflict Resolution', 'Communication strategies', 'Group-based sessions');


INSERT INTO Inmate_Programs (Prison_ProgramID, InmateID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);


INSERT INTO Offense_Types (Offense_Comments, Offense_Classification) VALUES 
('Stole a guard’s lunch', 'Minor'),
('Broke a sink', 'Moderate'),
('Started a fight', 'Severe'),
('Found with contraband', 'Moderate'),
('Attempted escape', 'Severe'),
('Assaulted another inmate', 'Severe'),
('Graffiti in the cell', 'Minor'),
('Stole from commissary', 'Moderate'),
('Tampered with locks', 'Severe'),
('Misused library privileges', 'Minor');


INSERT INTO Offenses (Offense_TypeID, InmateID, Offense_Date) VALUES
(1, 1, '2023-01-01'),
(2, 2, '2023-02-15'),
(3, 3, '2023-03-20'),
(4, 4, '2023-04-10'),
(5, 5, '2023-05-25'),
(6, 6, '2023-06-30'),
(7, 7, '2023-07-15'),
(8, 8, '2023-08-05'),
(9, 9, '2023-09-10'),
(10, 10, '2023-10-20');


-- ============================================================================================================================================================================== --
-- Views


-- NOTE: For views, triggers, and procedures: Sometimes the insert statments for testing can confuse later tests. If any errors or confusion happens recreate database.

DROP VIEW IF EXISTS Offenses_Per_Month;
CREATE VIEW Offenses_Per_Month AS
SELECT 
    i.InmateID,
    i.First_Name,
    i.Last_Name,
    COUNT(o.OffenseID) AS Offense_Count,
    DATE_FORMAT(o.Offense_Date, '%Y-%m') AS Offense_Month
FROM 
    Inmate i
JOIN 
    Offenses o ON i.InmateID = o.InmateID
WHERE 
    o.Offense_Date BETWEEN DATE_SUB(CURDATE(), INTERVAL 1 MONTH) AND CURDATE()
GROUP BY 
    i.InmateID, DATE_FORMAT(o.Offense_Date, '%Y-%m')
ORDER BY 
    i.InmateID, Offense_Month DESC;

-- Insert sample offenses
INSERT INTO Offenses (Offense_TypeID, InmateID, Offense_Date)
VALUES
(1, 1, '2024-11-05'), 
(1, 1, '2024-11-10'),
(2, 2, '2024-11-15'),
(2, 2, '2024-11-20'); 

SELECT * FROM Offenses_Per_Month;


DROP VIEW IF EXISTS Current_Reoffense_Rate;
CREATE VIEW Current_Reoffense_Rate AS
SELECT 
    i.Unique_Prison_ID,
    i.First_Name,
    i.Last_Name,
    COUNT(ih.Inmate_Release_HistoryID) AS Release_Count,
    CASE 
        WHEN COUNT(ih.Inmate_Release_HistoryID) > 1 THEN 'Reoffended'
        ELSE 'No Reoffense'
    END AS Reoffense_Status,
    CASE 
        WHEN i.InmateID IS NOT NULL THEN 'Currently Serving Time'
        ELSE 'Released'
    END AS Current_Status
FROM 
    Inmate i
LEFT JOIN 
    Inmate_Release_History ih ON i.InmateID = ih.InmateID
GROUP BY 
    i.Unique_Prison_ID, i.First_Name, i.Last_Name, i.InmateID
ORDER BY 
    Release_Count DESC;





-- Insert Sample Inmates
INSERT INTO Inmate (First_Name, Last_Name, Conviction, Conviction_Date, Risk_Level, Release_Date, SSN, Unique_Prison_ID) 
VALUES 
('John', 'Doe', 'Assault', '2020-05-15', 3, '2025-05-15', '123-45-6689', 101),
('Jane', 'Smith', 'Theft', '2022-01-20', 2, '2024-01-20', '987-65-4621', 102),
('Mark', 'Johnson', 'Fraud', '2019-03-10', 1, '2023-08-25', '543-26-9876', 103),
('Alice', 'Williams', 'Assault', '2020-11-11', 2, '2024-11-11', '668-90-1234', 104),
('Bob', 'Brown', 'Murder', '2018-07-05', 4, '2022-07-05', '112-23-4767', 105);

-- Insert Sample Inmate Release History
-- John Doe: Released, reoffended (new release date)
INSERT INTO Inmate_Release_History (InmateID, Unique_Prison_ID, Release_Date, Release_Comments) 
VALUES 
(11, 101, '2025-05-15', 'Release after completing sentence'),
(11, 101, '2026-05-15', 'Reoffended after release');  -- Reoffended

-- Jane Smith: Released, no reoffense
INSERT INTO Inmate_Release_History (InmateID, Unique_Prison_ID, Release_Date, Release_Comments) 
VALUES 
(12, 102, '2024-01-20', 'Release after serving sentence');

-- Mark Johnson: Released, no reoffense
INSERT INTO Inmate_Release_History (InmateID, Unique_Prison_ID, Release_Date, Release_Comments) 
VALUES 
(13, 103, '2023-08-25', 'Release after completing sentence');

-- Alice Williams: Released, no reoffense
INSERT INTO Inmate_Release_History (InmateID, Unique_Prison_ID, Release_Date, Release_Comments) 
VALUES 
(14, 104, '2024-11-11', 'Release after serving time');

-- Bob Brown: Released, reoffended (new release date)
INSERT INTO Inmate_Release_History (InmateID, Unique_Prison_ID, Release_Date, Release_Comments) 
VALUES 
(15, 105, '2022-07-05', 'Release after completing sentence'),
(15, 105, '2023-07-05', 'Reoffended after release');  -- Reoffended


-- Check inserts
SELECT * FROM Inmate;
SELECT * FROM Inmate_Release_History;

-- Select VIEW
SELECT * FROM Current_Reoffense_Rate;



-- View to show upcoming releases
DROP VIEW IF EXISTS UpcomingReleasesJanuary2025;
CREATE VIEW UpcomingReleasesJanuary2025 AS
SELECT InmateID, First_Name, Last_Name, Release_Date
FROM Inmate
WHERE Release_Date BETWEEN '2025-01-01' AND '2025-01-31';

-- Should be blank
SELECT * FROM UpcomingReleasesJanuary2025;

-- Add sample prisoner released in January
INSERT INTO Inmate (First_Name, Last_Name, Conviction, Conviction_Date, Risk_Level, Release_Date, SSN, Unique_Prison_ID) 
VALUES 
('Bill', 'White', 'Theft', '2021-06-04', 2, '2025-01-08', '132-43-4293', 106),
('Billy', 'Whiter', 'Grand Theft Auto', '2021-06-05', 3, '2026-01-07', '132-43-4294', 107);

-- Second test should show inmate Bill White and not Billy Whiter
SELECT * FROM UpcomingReleasesJanuary2025;




DROP VIEW IF EXISTS Program_Enrollment_View;
CREATE VIEW Program_Enrollment_View AS
SELECT 
    pp.Prison_ProgramID,
    pp.Program_Type,
    pp.Program_Specifics,
    pp.Program_Start_Date,
    pp.Program_END_Date,
    COUNT(ip.InmateID) AS Enrolled_Inmates
FROM 
    Prison_Programs pp
LEFT JOIN 
    Inmate_Programs ip ON pp.Prison_ProgramID = ip.Prison_ProgramID
GROUP BY 
    pp.Prison_ProgramID, pp.Program_Type, pp.Program_Specifics, pp.Program_Start_Date, pp.Program_END_Date
ORDER BY 
    Enrolled_Inmates DESC;

-- Insert sample data into Inmate_Programs
INSERT INTO Inmate_Programs (Prison_ProgramID, InmateID)
VALUES
(5, 1), 
(2, 1), 
(3, 1), 
(4, 1); 

-- Select VIEW
SELECT * FROM Program_Enrollment_View;


DROP VIEW IF EXISTS Current_Inmates_Receiving_Medical_Care;
CREATE VIEW Current_Inmates_Receiving_Medical_Care AS
SELECT 
    i.InmateID,
    i.First_Name,
    i.Last_Name,
    i.Conviction,
    i.Risk_Level,
    i.Unique_Prison_ID,
    mr.Medical_Date,
    mr.Diagnosis,
    mr.Medical_Comments,
    ms.Specialty AS Medical_Staff_Specialty,
    ms.Medical_StaffID
FROM 
    Inmate i
JOIN 
    Medical_Records mr ON i.InmateID = mr.InmateID
JOIN 
    Staff_Medical_Records smr ON smr.Medical_RecordID = mr.Medical_RecordID
JOIN 
    Medical_Staff ms ON ms.Medical_StaffID = smr.Medical_StaffID
WHERE 
    mr.Receiving_Care = TRUE;


-- test view
SELECT * FROM Current_Inmates_Receiving_Medical_Care;



DROP VIEW IF EXISTS Current_Escape_Attempts;
CREATE VIEW Current_Escape_Attempts AS
SELECT 
    o.OffenseID,
    o.Offense_TypeID,
    o.InmateID,
    i.First_Name,
    i.Last_Name,
    i.Conviction,
    o.Offense_Date
FROM 
    Offenses o
JOIN 
    Inmate i ON o.InmateID = i.InmateID
WHERE 
    o.Offense_TypeID = 5
    AND YEAR(o.Offense_Date) = YEAR(CURDATE()); -- remove this last line if you want to look for all escape attempts.

-- NOTE: if there is no Attempted escape offense type then this will not work. 
-- ADD in the offense type if needed, however, by default there should be one here. After that make sure you change the Offense_TypeID to the correct value.
-- Insert a record into Offense_Types table for "Attempted escape"
INSERT INTO Offense_Types (Offense_Classification, Offense_Comments)
VALUES ('Severe', 'Attempted escape');
 
-- add escape attempts
INSERT INTO Offenses (Offense_TypeID, InmateID, Offense_Date) VALUES
(5, 1, '2024-01-01'),
(5, 2, '2024-02-15'),
(5, 3, '2024-03-20'),
(5, 10, '2024-10-20');

-- test view
SELECT * FROM Current_Escape_Attempts;


-- ============================================================================================================================================================================== --
-- Triggers


-- increases the prisoner's risk level after 10 offenses
DROP TRIGGER IF EXISTS increase_risk_level_after_offenses;

DELIMITER //
CREATE TRIGGER increase_risk_level_after_offenses
AFTER INSERT ON Offenses
FOR EACH ROW
BEGIN
    DECLARE new_Risk_Level INT;

    -- Check if the prisoner has committed 10 offenses
    IF (SELECT COUNT(*) FROM Offenses WHERE InmateID = NEW.InmateID) >= 10 THEN
        -- Get the current risk level of the prisoner
        SELECT Risk_Level INTO new_Risk_Level FROM Inmate WHERE InmateID = NEW.InmateID;

        -- If the risk level is less than 10, increase it by 1
        IF new_Risk_Level < 10 THEN
            UPDATE Inmate
            SET Risk_Level = new_Risk_Level + 1
            WHERE InmateID = NEW.InmateID;
        END IF;
    END IF;
END //

DELIMITER ;

-- Insert a prisoner with an initial risk level of 5
INSERT INTO Inmate (First_Name, Last_Name, Conviction, Conviction_Date, Risk_Level, Release_Date, SSN, Unique_Prison_ID) VALUES 
('John', 'Smith', 'Serial Murder', '1980-10-20', 5, '2025-10-20', '222-33-4445', 1011);

-- Verify that the Inmate has been created with a risk level of 5
SELECT * FROM Inmate;

-- Create offenses for them
INSERT INTO Offenses (Offense_TypeID, InmateID, Offense_Date) VALUES
(10, 11, '2023-10-20');

SELECT * FROM Offenses;

INSERT INTO Offenses (Offense_TypeID, InmateID, Offense_Date) VALUES
(10, 11, '2023-10-20'),
(10, 11, '2023-10-20'),
(10, 11, '2023-10-20'),
(10, 11, '2023-10-20'),
(10, 11, '2023-10-20'),
(10, 11, '2023-10-20'),
(10, 11, '2023-10-20'),
(10, 11, '2023-10-20'),
(10, 11, '2023-10-20'),
(10, 11, '2023-10-20');

SELECT * FROM Offenses;

-- Select them again
SELECT * FROM Inmate;




DROP TRIGGER IF EXISTS GenerateUniquePrisonID;
DELIMITER $$

CREATE TRIGGER GenerateUniquePrisonID
BEFORE INSERT ON Inmate
FOR EACH ROW
BEGIN
    -- Generates a Unique_Prison_ID based on a numeric transformation of the last name and SSN
    -- Converts the first 3 characters of the last name into a number (ASCII values (was fun to find :|  )) and concatenate with SSN 
    
    SET NEW.Unique_Prison_ID = CAST(CONCAT(
        -- Takes the ASCII values of the first 3 characters of the last name
        CAST(ASCII(SUBSTRING(NEW.Last_Name, 1, 1)) AS CHAR),
        CAST(ASCII(SUBSTRING(NEW.Last_Name, 2, 1)) AS CHAR),
        CAST(ASCII(SUBSTRING(NEW.Last_Name, 3, 1)) AS CHAR),
        
        -- Takes the first 6 digits of the SSN without the dashes
        SUBSTRING(REPLACE(NEW.SSN, '-', ''), 1, 6)
    ) AS UNSIGNED);
-- used as UNSIGNED to increase upper bound (no need for negative IDs)
END$$

DELIMITER ;


-- insert data
INSERT INTO Inmate (First_Name, Last_Name, Conviction, Conviction_Date, Risk_Level, Release_Date, SSN)
VALUES ('TestJohn', 'TestDoe', 'Petty Theft', '2024-01-01', 5, '2025-01-01', '113-45-6989');


-- test trigger
SELECT * FROM Inmate WHERE First_Name = 'TestJohn';
SELECT Unique_Prison_ID FROM Inmate;
SELECT * FROM Inmate WHERE InmateID = LAST_INSERT_ID();



DROP TRIGGER IF EXISTS UpdateCellOnInternalTransfer;
DELIMITER $$
CREATE TRIGGER UpdateCellOnInternalTransfer
AFTER INSERT ON Internal_Transfers
FOR EACH ROW
BEGIN
    -- Check if the new cell is available (InmateID is NULL)
    IF (SELECT InmateID FROM Cells WHERE CellID = NEW.New_Cell) IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' -- prievously used LEAVE however that caused issues. updated to this.
        SET MESSAGE_TEXT = 'New cell is already occupied';
    END IF;

    -- Set the current cell's InmateID to NULL
    UPDATE Cells
    SET InmateID = NULL
    WHERE CellID = NEW.Current_Cell;

    -- Assign the InmateID to the new cell
    UPDATE Cells
    SET InmateID = NEW.InmateID
    WHERE CellID = NEW.New_Cell;
END$$

DELIMITER ;


-- testing:
-- Insert sample data into Internal_Transfers
INSERT INTO Internal_Transfers (Current_Cell, New_Cell, InmateID, Reason_for_Transfer)
VALUES (1, 11, 1, 'Behavior upgrade');

-- check for update:
SELECT * FROM Cells;




DROP TRIGGER IF EXISTS Trigger_Move_Inmate_To_Release;
DELIMITER $$
CREATE TRIGGER Trigger_Move_Inmate_To_Release
AFTER UPDATE ON Inmate
FOR EACH ROW
BEGIN
    -- Check if the inmate's release date has arrived
    IF NEW.Release_Date = CURDATE() THEN
        -- Insert the inmate into the Inmate_Release_History table
        INSERT INTO Inmate_Release_History (InmateID, Unique_Prison_ID, Release_Date, Release_Comments)
        VALUES (NEW.InmateID, NEW.Unique_Prison_ID, NEW.Release_Date, 'Inmate released on scheduled date');

        -- Optionally delete the inmate from the Inmate table (or handle it according to business logic)
        DELETE FROM Inmate WHERE InmateID = NEW.InmateID;
    END IF;
END$$

DELIMITER ;


-- Step 1: Prepare the environment by inserting a test inmate
INSERT INTO Inmate (First_Name, Last_Name, Conviction, Conviction_Date, Risk_Level, Release_Date, SSN, Unique_Prison_ID)
VALUES ('John', 'Doe', 'Theft', '2022-01-01', 2, CURDATE(), '123-45-8888', 1001); -- if trigger for updating inmate Unique_Prison_ID is active this Unique_Prison_ID will not work

-- Step 2: Verify the data is in the Inmate table
SELECT * FROM Inmate WHERE Unique_Prison_ID = 1001;

-- Step 3: Update the Release_Date to trigger the release (normally this happens automatically when the release date arrives)
UPDATE Inmate
SET Release_Date = CURDATE()
WHERE Unique_Prison_ID = 1001;

-- Step 4: Verify the data has been moved to the Inmate_Release_History table
SELECT * FROM Inmate_Release_History WHERE Unique_Prison_ID = 1001;

-- Step 5: Ensure the record is no longer in the Inmate table (if the trigger deletes it)
SELECT * FROM Inmate WHERE Unique_Prison_ID = 1001;



-- ============================================================================================================================================================================== --
-- Procedures

-- Procedure: Insert Staff into Staff and Admin Tables
DELIMITER //

DROP PROCEDURE IF EXISTS Insert_Staff_Admin; -- Drop the procedure if it exists to avoid conflicts
CREATE PROCEDURE Insert_Staff_Admin (
    IN p_First_Name VARCHAR(50),
    IN p_Last_Name VARCHAR(50),
    IN p_Salary DECIMAL(10, 2),
    IN p_Administrator_Type VARCHAR(50)
)
BEGIN
    -- Insert into Staff table
    INSERT INTO Staff (First_Name, Last_Name, Salary)
    VALUES (p_First_Name, p_Last_Name, p_Salary);

    -- Insert into Administrators table, using the StaffID from the last inserted Staff record
    INSERT INTO Administrators (StaffID, Administrator_Type)
    VALUES (LAST_INSERT_ID(), p_Administrator_Type);
END 
//
DELIMITER ;


-- Procedure: Delete Staff from Staff and Admin Tables
DELIMITER //
DROP PROCEDURE IF EXISTS Delete_Staff_Admin; -- Drop the procedure if it exists to avoid conflicts
CREATE PROCEDURE Delete_Staff_Admin (
    IN p_StaffID INT
)
BEGIN
    -- Check if the StaffID exists in the Staff table
    IF EXISTS (SELECT 1 FROM Staff WHERE StaffID = p_StaffID) THEN
        -- Check if the StaffID exists in the Administrators table
        IF EXISTS (SELECT 1 FROM Administrators WHERE StaffID = p_StaffID) THEN
            -- If the staff is an administrator, delete from both tables
            DELETE FROM Administrators WHERE StaffID = p_StaffID;
            DELETE FROM Staff WHERE StaffID = p_StaffID;
        ELSE
            -- If the staff is not an administrator, do not delete from Staff table
            SELECT 'Staff is not an administrator, cannot delete.' AS Message;
        END IF;
    ELSE
        -- If the StaffID does not exist in the Staff table, do not proceed with deletion
        SELECT 'StaffID does not exist in the Staff table, cannot delete.' AS Message;
    END IF;
END //

DELIMITER ;




-- test 
CALL Insert_Staff_Admin('John', 'Doe', 50000.00, 'Senior Administrator');

-- Verify the data
SELECT * FROM Staff;
SELECT * FROM Administrators;

-- test
CALL Delete_Staff_Admin(12);

-- Verify the data
SELECT * FROM Staff;
SELECT * FROM Administrators;



-- ============================================================================================================================================================================== --


/* Restore foreign key checks */
SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS; -- Restore the original state of foreign key checks
