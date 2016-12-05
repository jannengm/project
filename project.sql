SPOOL project.out
SET ECHO ON
/******************************************************************************************
* CIS 353 - Database Design Project
* Authors: Mark Jannenga, 
*	   Chasman Rose, 
*	   Amanda Malaric, 
*	   Devon Ozogo, 
*	   Eric Zienstra
*******************************************************************************************/
--Drop tables (for testing, can remove later (MJ))
DROP TABLE Line;
DROP TABLE Orders;
DROP TABLE Customers;
DROP TABLE Employee;
DROP TABLE Part;
DROP TABLE Bin;
DROP TABLE Vendors;
DROP TABLE Class;
DROP TABLE Location;
--Orders Table details order information 
----------------------------------------------------------------------------------------------------
CREATE TABLE Customers(
	cID CHAR(5) NOT NULL,
	cName CHAR(200), --not sure of CHAR(size) here or just can have string
	cLocation CHAR(200), --same as above
	Class CHAR(1) NOT NULL,
--	
	CONSTRAINT CUST_IC1 PRIMARY KEY (cID), --PRIMARY KEY(cID),
	CONSTRAINT CUST_IC2 CHECK (class IN ('A', 'B', 'C'))
);
----------------------------------------------------------------------------------------------------------------------
CREATE TABLE Orders(
	OrderID CHAR(6) NOT NULL, -- Made this change to avoid aggregation issues; PK
	PayMethod CHAR(200), 
	ShippingAddress CHAR(200), 
	cID CHAR(5) NOT NULL, -- foreign key to Customers Table
--
	ActualShipDate DATE,
	ExpectedShipDate DATE NOT NULL,
	ReceivedDate DATE NOT NULL,
--
	Pickup CHAR(5) NOT NULL,
--
	Discount Float, --float is correct, want discount as % of ord cost
	CONSTRAINT ORD_IC1 PRIMARY KEY (OrderID), --PRIMARY KEY(OrderID),
	CONSTRAINT ORD_IC2 FOREIGN KEY (cID) REFERENCES Customers(cID),
	CONSTRAINT ORD_IC3 CHECK (ExpectedShipDate <= ReceivedDate),
	CONSTRAINT ORD_IC4 CHECK (ActualShipDate <= ReceivedDate),
	CONSTRAINT ORD_IC5 CHECK (PayMethod IN ('credit', 'check', 'NEFT', 'IMPS', 'RTGS')),
	CONSTRAINT ORD_IC6 CHECK (Discount <= 1 AND Discount >= 0)
);
---------------------------------------------------------------------------------------------------------------
CREATE TABLE Location(
	LocationID CHAR(4) NOT NULL,
	LocationName CHAR(200), --will fix when other like questions are answered
	Address CHAR(200),
	City CHAR(200),
--
	ZipCode INTEGER NOT NULL,
--	Latitude Float NOT NULL, -- Wanted to add these just for functionality, map building!
--	Longitude Float NOT NULL,
	CONSTRAINT LOC_IC1 PRIMARY KEY (LocationID) --PRIMARY KEY(LocationID)
);
------------------------------- ------------------------------------------------------------------------------------
CREATE TABLE Employee(
	EmployeeID CHAR(3) NOT NULL, -- Again changes made for aggregation purposes don't want to get sum of emp ID, just cnt
	NameFirst CHAR(200), --not sure again of length of CHAR or can just have string
	NameLast CHAR(200), --same as above
	Job CHAR(20) NOT NULL,
--	
	PayRate Float, -- Change made because I wasn't sure if this is an efficiency rate. 
--			--not sure if FLOAT is a type, or if we have to use INTEGER
--		       -- if so, calculation would be better generated with a Query
	LocationID CHAR(4), -- FK to Location Table
--
	CONSTRAINT EMP_IC1 PRIMARY KEY (EmployeeID), --PRIMARY KEY(EmployeeID)
	CONSTRAINT EMP_IC2 FOREIGN KEY (LocationID) REFERENCES Location(LocationID)
);
------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Line(
	OrderID CHAR(6) NOT NULL, --FK->Order
	LineNumber CHAR(3) NOT NULL,	
	EmployeeID CHAR(3) NOT NULL, -- FK -> Employee 
	LinePrice FLOAT NOT NULL, -- MV? —-set as float, can have decimals
	QuantityRequested INTEGER NOT NULL,
	QuantitySelected INTEGER NOT NULL,
--	
	CONSTRAINT LN_IC1 PRIMARY KEY (OrderID, LineNumber),--PRIMARY KEY(OrderID, LineNumber),
	CONSTRAINT LN_IC2 CHECK (QuantityRequested > 0),
	CONSTRAINT LN_IC3 CHECK (QuantitySelected >= 0),
	CONSTRAINT LN_IC4 CHECK (LinePrice >= 0),
	CONSTRAINT LN_IC5 FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
	CONSTRAINT LN_IC6 FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);
-------------------------------------------------------------------------------------------------------------
CREATE TABLE Vendors(
	vID CHAR(3) NOT NULL,
	vName CHAR(200),
	vAddress CHAR(200),
	vCity CHAR(200),
	vState CHAR(2) NOT NULL,
	vZIP INTEGER NOT NULL,
--	
	CONSTRAINT VEN_IC1 PRIMARY KEY (vID) --PRIMARY KEY(vID)
);
--------------------------------------------------------------------------------------------------------------------
CREATE TABLE Part(
	PartID CHAR(10) NOT NULL,
	VendorID CHAR(3) NOT NULL, --fk->Vendors
	Make CHAR(200),
	Model CHAR(200), 
	FromYear INTEGER NOT NULL,
	ToYear INTEGER NOT NULL,
	PartPrice FLOAT NOT NULL,
-- 
	CONSTRAINT PRT_IC1 PRIMARY KEY (PartID), --PRIMARY KEY(PartID)
	CONSTRAINT PRT_IC2 FOREIGN KEY (VendorID) REFERENCES Vendors(vID)
);
--------------------------------------------------------------------------------------------------------------------
CREATE TABLE Bin(
	BinID CHAR(6) NOT NULL,
	LocationID CHAR(4) NOT NULL, --fk->location
--	
	QuantityInStock INTEGER NOT NULL,
	CONSTRAINT BN_IC1 PRIMARY KEY (BinID), --PRIMARY KEY(BinID)
	CONSTRAINT BN_IC2 FOREIGN KEY (LocationID) REFERENCES Location(LocationID)
);
--------------------------------------------------------------------------------------------------------------
CREATE TABLE Class(
	ClassID CHAR(1) NOT NULL,
	ClassType CHAR(200),
	CONSTRAINT CLS_IC1 PRIMARY KEY (ClassID) --PRIMARY KEY(ClassID)
);
--------------------------------------------------------------------------------------------------------------
SET FEEDBACK OFF
--Customers Inserts here
INSERT INTO Customers VALUES ('76434', 'Jane Doe', '555 3rd St, Grand Rapids, MI 49504', 'A');
INSERT INTO Customers VALUES ('65432', 'John Doe', '3214 Grand Rd, Grand Rapids, MI 49504', 'B');
INSERT INTO Customers VALUES ('04324', 'Ray Roy', '898 Out St, Chicago IL, 60290', 'C');
INSERT INTO Customers VALUES ('12345', 'Robert Plant', '1022 Campus Dr, Allendale MI, 49201', 'C');
INSERT INTO Customers VALUES ('45677', 'Jimmy Page', '102 Campus Dr, Allendale MI, 49201', 'C');
INSERT INTO Customers VALUES ('36989', 'Tim Othy', '20 Mallard Dr, Gibraltar MI, 48173', 'A');

--Orders Inserts here
INSERT INTO Orders VALUES ('293840', 'credit', '555 3rd St, Grand Rapids, MI 49504', '74589', TO_DATE('10/09/16', 'mm/dd/yy'), TO_DATE('10/11/16', 'mm/dd/yy'), TO_DATE('10/15/16', 'mm/dd/yy'), 'False', .00);

INSERT INTO Orders VALUES ('910748', 'NEFT', '3214 Grand Rd, Grand Rapids, MI 49504', '16543', TO_DATE('10/13/16', 'mm/dd/yy'), TO_DATE('10/14/16', 'mm/dd/yy'), TO_DATE('10/17/16', 'mm/dd/yy'), 'False', .015);

INSERT INTO Orders VALUES ('712903', 'credit', '898 Out St, Chicago IL, 60290', '04324', TO_DATE('09/08/16', 'mm/dd/yy'), TO_DATE('09/10/16', 'mm/dd/yy'), TO_DATE('09/13/16', 'mm/dd/yy'), 'False', .030);

INSERT INTO Orders VALUES ('571281', 'credit', '1022 Campus Dr, Allendale MI, 49201', '12345', TO_DATE('02/04/16', 'mm/dd/yy'), TO_DATE('02/07/16', 'mm/dd/yy'), TO_DATE('02/14/16', 'mm/dd/yy'), 'False', 0.00);

INSERT INTO Orders VALUES ('797678', 'check', '102 Campus Dr, Allendale MI, 49201', '45677', TO_DATE('05/12/16', 'mm/dd/yy'), TO_DATE('05/16/16', 'mm/dd/yy'), TO_DATE('05/20/16', 'mm/dd/yy'), 'False', 0.010);

INSERT INTO Orders VALUES ('123411', 'IMPS', '20 Mallard Dr,Gibraltar MI, 48173', '36989', TO_DATE('07/19/16', 'mm/dd/yy'), TO_DATE('07/21/16', 'mm/dd/yy'), TO_DATE('07/25/16', 'mm/dd/yy'), 'False', 0.010);

INSERT INTO Orders VALUES ('572831', 'credit', '123 Grade Dr, Chicago IL, 60290', '04324', TO_DATE('03/03/16', 'mm/dd/yy'), TO_DATE('03/04/16', 'mm/dd/yy'), TO_DATE('03/07/16', 'mm/dd/yy'), 'False', 0.030);

INSERT INTO Orders VALUES ('129757', 'credit', '5432 Data Rd, Grand Rapids, MI 49504', '76434', TO_DATE('12/01/16', 'mm/dd/yy'), TO_DATE('12/03/16', 'mm/dd/yy'), TO_DATE('12/06/16', 'mm/dd/yy'), 'False', 0.030);

INSERT INTO Orders VALUES ('243491', 'check', '2342 Base Rd, Grand Rapids, MI 49504', '65432', TO_DATE('04/05/16', 'mm/dd/yy'), TO_DATE('04/06/16', 'mm/dd/yy'), TO_DATE('04/10/16', 'mm/dd/yy'), 'False', 0.00);

INSERT INTO Orders VALUES ('228922', 'credit', '6232 Class Rd, Grand Rapids, MI 49504', '36989', TO_DATE('08/08/16', 'mm/dd/yy'), TO_DATE('08/10/16', 'mm/dd/yy'), TO_DATE('08/13/16', 'mm/dd/yy'), 'False', 0.010);

--Location Inserts here
INSERT INTO Location VALUES ('2839', 'Speak St Parts', '1 Speak St', 'Grand Rapids', 49504);
INSERT INTO Location VALUES ('5723', 'Reading Rd Parts', '4323 Reading Rd', 'Grand Rapids', 49504);
INSERT INTO Location VALUES ('5965', 'Git St Parts', '582 Git NW St', 'Allendale', 49201);

--Employee Inserts here
INSERT INTO Employee VALUES ('199', 'Ralph', 'Klasp', 'Manager', 30, '2839');
INSERT INTO Employee VALUES ('438', 'James', 'David', 'Line Worker', 10, '5723');
INSERT INTO Employee VALUES ('458', 'Jeff', 'McCoy', 'Line Worker', 10, '5965');
INSERT INTO Employee VALUES ('678', 'Nate', 'Benson', 'Line Worker', 10, '2839');
INSERT INTO Employee VALUES ('548', 'Chris', 'Haas', 'Line Worker', 10, '5723');
INSERT INTO Employee VALUES ('123', 'Jessica', 'Click', 'Manager', 15, '5965');
INSERT INTO Employee VALUES ('504', 'Emily', 'Barofsky', 'Receptionist', 13, '2839');

--Line Inserts here
INSERT INTO Line VALUES ('123411', '125', '548', 10.91, 1, 1);
INSERT INTO Line VALUES ('572831', '523', '438', 100.23, 3, 3);
INSERT INTO Line VALUES ('129757', '765', '548', 231.43, 1, 1);
INSERT INTO Line VALUES ('243491', '122', '458', 945.15, 5, 5);
INSERT INTO Line VALUES ('228922', '890', '678', 22.01, 2, 2);

--Vendors Inserts here
INSERT INTO Vendors VALUES ('V01', 'Paulstra CRC', '6500 Divison St E', 'Grand Rapids', 'MI', 49504);
INSERT INTO Vendors VALUES('V02', 'Thireka', '520 Plainfield Ave NE', 'Grand Rapids', 'MI', 49504);
INSERT INTO Vendors VALUES('V03', 'Plasan Carbons', '9000 3 Mile Ave NW', 'Grand Rapids', 'MI', 49504);
INSERT INTO Vendors VALUES('V04', 'Denco Distributing Inc.', '1300 Euclid Ctd. SE', 'Grand Rapids', 'MI', 49504);
INSERT INTO Vendors VALUES('V05', 'Berco Inc', '2936 S Wilson Ct', 'Grand Rapids', 'MI', 49534);

--Part Inserts here
INSERT INTO Part VALUES ('123-435', 'V01', 'Honda', 'Civic', 2001, 2014, 120.56);
INSERT INTO Part VALUES ('574-628', 'V01', 'Ford', 'F-150', 2009, 2010, 534.12);
INSERT INTO Part VALUES ('123-435', 'V01', 'Audi', 'A4', 2010, 2015, 50.56);
INSERT INTO Part VALUES ('123-435', 'V01', 'Honda', 'CR-V', 2000, 2004, 10.90);
INSERT INTO Part VALUES ('123-435', 'V01', 'Kia', 'Soul', 2013, 2014, 111.22);

--Bin Inserts here
INSERT INTO Bin VALUES ('1-4234', '2839', 65);
INSERT INTO Bin VALUES ('5-2342', '5723', 12);
INSERT INTO Bin VALUES ('6-4628', '5965', 92);
INSERT INTO Bin VALUES ('3-5341', '2839', 45);
INSERT INTO Bin VALUES ('2-5488', '5965', 23);

--Class Inserts here
INSERT INTO Class VALUES ('A', 'Individual');
INSERT INTO Class VALUES ('B', 'Wholesaler');
INSERT INTO Class VALUES ('C', 'Company');
--
--
--
SET FEEDBACK ON
COMMIT;

--Queries to display each table
SELECT *
FROM Orders;

SELECT *
FROM Customers;

SELECT *
FROM Employee;

SELECT *
FROM Location;

SELECT *
FROM Line;

SELECT *
FROM Part;

SELECT *
FROM Bin;

SELECT *
FROM Vendors;

SELECT *
FROM Class;

COMMIT;
SPOOL OFF