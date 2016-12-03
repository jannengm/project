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

	ActualShipDate datetime,
	ExpectedShipDate datetime NOT NULL,
	ReceivedDate datetime NOT NULL,

	Pickup BOOLEAN NOT NULL,
	
	Discount Float, —-float is correct, want discount as % of ord cost
	CONSTRAINT ORD_IC1 PRIMARY KEY (OrderID) —-PRIMARY KEY(OrderID),
	CONSTRAINT ORD_IC2 FOREIGN KEY (cID) REFERENCES Customers(cID),
	CONSTRAINT ORD_IC3 CHECK (ExpectedShipDate => ReceivedDate),
	CONSTRAINT ORD_IC4 CHECK (ActualShipDate +. ReceivedDate),
	CONSTRAINT ORD_IC5 CHECK (PayMethod IN 'credit', 'check', 'NEFT', 'IMPS', 'RTGS'),
	CONSTRAINT ORD_IC6 CHECK (Discount <= 1 AND Discount >= 0)
);
---------------------------------------------------------------------------------------------------------------
CREATE TABLE Customers(
	Class CHAR(1) NOT NULL,
	cName String, —-not sure of CHAR(size) here or just can have string
	cID CHAR(12) NOT NULL,
	cLocation String, —-same as above
	
	CONSTRAINT CUST_IC1 PRIMARY KEY (cID) —-PRIMARY KEY(cID),
	CONSTRAINT CUST_IC2 CHECK (class IN 'individual', 'company', 'wholesale')
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
	CONSTRAINT EMP_IC1 PRIMARY KEY (EmployeeID), -—PRIMARY KEY(EmployeeID)
	CONSTRAINT EMP_IC2 FOREIGN KEY (LocationID) REFERENCES Location(LocationID)
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
	CONSTRAINT LOC_IC1 PRIMARY KEY (LocationID) —-PRIMARY KEY(LocationID)
);
------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Line(
	LineNumber CHAR(3) NOT NULL,
	OrderID CHAR(6) NOT NULL, —-FK->Order	
	EmployeeID CHAR(11) NOT NULL, -- FK -> Employee 

	LinePrice Float, -- MV? —-set as float, can have decimals
	QuantityRequested INTEGER NOT NULL,
	QuantitySelected INTEGER NOT NULL,
	
	CONSTRAINT LN_IC1 PRIMARY KEY (OrderID, LineNumber)—-PRIMARY KEY(OrderID, LineNumber),
	CONSTRAINT LN_IC2 CHECK (QuantityRequested > 0),
	CONSTRAINT LN_IC3 CHECK (QuantitySelected >= 0),
	CONSTRAINT LN_IC4 CHECK (LinePrice >= 0),
	CONSTRAINT LN_IC5 FOREIGN KEY (OrderID) REFERENCES Order(OrderID),
	CONSTRAINT LN_IC6 FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

--------------------------------------------------------------------------------------------------------------------
CREATE TABLE Part(
	PartID CHAR(10) NOT NULL,
	VendorID CHAR(3) NOT NULL, —-fk->Vendors
	Make String,
	Model String, 
	FromYear INTEGER NOT NULL,
	ToYear INTEGER NOT NULL,
	PartPrice Float,
 
	CONSTRAINT PRT_IC1 PRIMARY KEY (PartID) —-PRIMARY KEY(PartID)
	CONSTRAINT PRT_IC2 FOREIGN KEY (VendorID) REFERENCES Vendors(vID)
);
--------------------------------------------------------------------------------------------------------------------
CREATE TABLE Bin(
	BinID CHAR(6) NOT NULL,
	LocationID CHAR(4) NOT NULL, —-fk->location
	
	QuantityInStock INTEGER NOT NULL,
	CONSTRAINT BN_IC1 PRIMARY KEY (BinID) -—PRIMARY KEY(BinID)
	CONSTRAINT BN_IC2 FOREIGN KEY (LocationID) REFERENCES Location(LocationID)
);
-------------------------------------------------------------------------------------------------------------
CREATE TABLE Vendors(
	vID CHAR(3) NOT NULL,
	vName String,
	vAddress String,
	vCity String,
	vState CHAR(2) NOT NULL,
	vZIP INTEGER NOT NULL
	
	CONSTRAINT VEN_IC1 PRIMARY KEY (vID) —-PRIMARY KEY(vID)

);
--------------------------------------------------------------------------------------------------------------

CREATE TABLE Class(
	ClassID CHAR(1) NOT NULL,
	ClassType String,
	CONSTRAINT CLS_IC1 PRIMARY KEY (ClassID) —-PRIMARY KEY(ClassID)

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