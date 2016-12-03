SPOOL project.out
SET ECHO ON
/******************************************************************************************
* CIS 353 - Database Design Project
* Authors: Mark Jannenga, 
*	   Chasman Rose, 
*	   Amanda Malaric, 
*	   Devon Ozogo, 
*	   Eric Zienstra
********************************************************************************************

--Orders Table details order information 
----------------------------------------------------------------------------------------------------
CREATE TABLE Orders(
	OrderID CHAR(6) NOT NULL, -- Made this change to avoid aggregation issues; PK
	PayMethod String, —-May need to change to CHAR, but length changes
	ShippingAddress String, —-comment above
	cID CHAR(12) NOT NULL, -- foreign key to Customers Table

	ActualShipDate DATE NOT NULL,
	ExpectedShipDate DATE NOT NULL,
	ReceivedDate DATE NOT NULL,

	Pickup BOOLEAN NOT NULL,
	
	Discount Float, —-not sure if ‘float’ is correct, or if integer is
	CONSTRAINT sIC1 PRIMARY KEY (OrderID) —-PRIMARY KEY(OrderID)
);
---------------------------------------------------------------------------------------------------------------
CREATE TABLE Customers(
	Class CHAR(1) NOT NULL,
	cName String, —-not sure of CHAR(size) here or just can have string
	cID CHAR(12) NOT NULL,
	cLocation String, —-same as above
	CONSTRAINT sIC2 PRIMARY KEY (cID) —-PRIMARY KEY(cID)
);
------------------------------- ------------------------------------------------------------------------------------
CREATE TABLE Employee(
	Job CHAR(20) NOT NULL,
	EmployeeID CHAR(11) NOT NULL, -- Again changes made for aggregation purposes don't want to get sum of emp ID, just cnt
	NameFirst String, —-not sure again of length of CHAR or can just have string
	NameLast String, —-same as above
	LocationID String, -- FK to Location Table
	
	PayRate Float, -- Change made because I wasn't sure if this is an efficiency rate. 
			—-not sure if FLOAT is a type, or if we have to use INTEGER
		       -- if so, calculation would be better generated with a Query
	CONSTRAINT sIC3 PRIMARY KEY (EmployeeID) -—PRIMARY KEY(EmployeeID)
);
----------------------------------------------------------------------------------------------------------------------
CREATE TABLE Location(
	LocationID CHAR(4) NOT NULL,
	LocationName String, —-will fix when other like questions are answered
	Address String,
	City String,

	ZipCode INTEGER NOT NULL,
	Latitude INTEGER NOT NULL, -- Wanted to add these just for functionality, map building!
	Longitude INTEGER NOT NULL,
	CONSTRAINT sIC4 PRIMARY KEY (LocationID) —-PRIMARY KEY(LocationID)
);
------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Line(
	LineNumber CHAR(3) NOT NULL,
	OrderID CHAR(6) NOT NULL, —-FK->Order	
	EmployeeID CHAR(11) NOT NULL, -- FK -> Employee 

	LinePrice Float, -- MV? —-set as float, can have decimals
	QuantityRequested INTEGER NOT NULL,
	QuantitySelected INTEGER NOT NULL,
	CONSTRAINT sIC5 PRIMARY KEY (OrderID)—-PRIMARY KEY(OrderID)
	CONSTRAINT sIC6 PRIMARY KEY (LineNumber)—-PRIMARY KEY(LineNumber)
);

--------------------------------------------------------------------------------------------------------------------
CREATE TABLE Part(
	PartID CHAR(10) NOT NULL,
	VendorID CHAR(3) NOT NULL,

	PartPrice Float, 
	CONSTRAINT sIC7 PRIMARY KEY (PartID) —-PRIMARY KEY(PartID)
);
--------------------------------------------------------------------------------------------------------------------
CREATE TABLE CompatibleCar(
	PartID CHAR(10) NOT NULL,
	Make String,
	Model String, 
	FromYear INTEGER NOT NULL,
	ToYear INTEGER NOT NULL,
	Part Price Float,
	
	QuantityInStock INTEGER NOT NULL,
	CONSTRAINT sIC9 PRIMARY KEY (BinID) -—PRIMARY KEY(BinID)
);
--------------------------------------------------------------------------------------------------------------------
CREATE TABLE CompatibleCar(
	PartID String,
	Make String,
	Model String,
	FromYear Integer,
	ToYear Integer

	PartPrice Float,
	PRIMARY KEY(PartID)
);
------------------------------------------------------------------------------------------------------------------
CREATE TABLE Bin(
	BinID CHAR(6) NOT NULL,
	LocationID CHAR(4) NOT NULL,
	
	QuantityInStock INTEGER NOT NULL,
	CONSTRAINT sIC9 PRIMARY KEY (BinID) -—PRIMARY KEY(BinID)
);
-------------------------------------------------------------------------------------------------------------
CREATE TABLE Vendors(
	vID CHAR(3) NOT NULL,
	vName String,
	vAddress String,
	vCity String,
	vState CHAR(2) NOT NULL,
	vZIP INTEGER NOT NULL
	
	CONSTRAINT sIC10 PRIMARY KEY (vID) —-PRIMARY KEY(vID)

);
--------------------------------------------------------------------------------------------------------------
SET FEEDBACK OFF
INSERT INTO Vendors VALUES ('V01', 'Paulstra CRC', '6500 Divison St E,' 'Grand Rapids', 'MI', 49504);
INSERT INTO Vendors VALUES('V02', 'Thireka', '520 Plainfield Ave NE,' 'Grand Rapids', 'MI', 49504);
INSERT INTO Vendors VALUES('V03', 'Plasan Carbons', '9000 3 Mile Ave NW,' 'Grand Rapids', 'MI', 49504);
INSERT INTO Vendors VALUES('V04' 'Denco Distributing Inc.', '1300 Euclid Ctd. SE,' 'Grand Rapids', 'MI', 49504);
INSERT INTO Vendors VALUES('V05', 'Berco Inc', '2936 S Wilson Ct', 'Grand Rapids', 'MI', 49534)

INSERT INTO Parts VALUES('Windshield Wipers', 'Toyota', 'Tocoma', 1991, 2000)


SET FEEDBACK ON
COMMIT;
COMMIT;
SPOOL OFF
