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
	OrderID String, -- Made this change to avoid aggregation issues; PK
	PayMethod String,
	ShippingAddress String,
	cID String, -- foreign key to Customers Table

	ActualShipDate Date,
	ExpectedShipDate Date,
	ReceivedDate Date,

	Pickup Boolean,
	
	Discount Float,
	PRIMARY KEY(OrderID)
);
---------------------------------------------------------------------------------------------------------------
CREATE TABLE Customers(
	Class String,
	cName String,
	cID String,
	cLocation String, 
	PRIMARY KEY(cID)
);
-------------------------------------------------------------------------------------------------------------------
CREATE TABLE Employee(
	Job String,
	EmployeeID String, -- Again changes made for aggregation purposes don't want to get sum of emp ID, just cnt
	NameFirst String,
	NameLast String,
	LocationID String, -- FK to Location Table
	
	PayRate Float, -- Change made because I wasn't sure if this is an efficiency rate. 
		       -- if so, calculation would be better generated with a Query
	PRIMARY KEY(EmployeeID)
);
----------------------------------------------------------------------------------------------------------------------
CREATE TABLE Location(
	LocationID String,
	LocationName String,
	Address String,
	City String,

	ZipCode Integer,
	Latitude Integer, -- Wanted to add these just for functionality, map building!
	Longitude Integer,
	PRIMARY KEY(LocationID)
);
------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Line(
	LineNumber String,
	OrderID String,	
	OrderID String, -- FK -> Order
	EmployeeID String, -- FK -> Employee 

	LinePrice Integer, -- MV?
	QuantityRequested Integer,
	QuantitySelected Integer,
	PRIMARY KEY(OrderID, LineNumber)
);
--------------------------------------------------------------------------------------------------------------------
CREATE TABLE Part(
	PartID String,
	VendorID String,

	PartPrice Float,
	PRIMARY KEY(PartID)
);
------------------------------------------------------------------------------------------------------------------
CREATE TABLE Bin(
	BinID String,
	LocationID String,
	
	QuantityInStock Integer,
	PRIMARY KEY(BinID)
);
-------------------------------------------------------------------------------------------------------------
CREATE TABLE Vendors(
	vID String,
	vName String,
	vLocation String,
	PRIMARY KEY(vID)
);
--------------------------------------------------------------------------------------------------------------
SET FEEDBACK OFF
INSERT INTO Vendors VALUES ('V01', 'Paulstra CRC', 'Grand Rapids');
SET FEEDBACK ON
COMMIT;
COMMIT;
SPOOL OFF