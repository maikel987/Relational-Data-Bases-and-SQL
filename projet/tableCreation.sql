-- create DataBase and Table

CREATE DATABASE RealEstate3;

CREATE TABLE CITY(
Name Char(20),
Area Char(20),
CONSTRAINT CityState PRIMARY KEY (Name,Area));

CREATE TABLE NEIGHBORHOOD(
NeighborhoodID int,
NeighborhoodName Char(20) Not null,
cityname char(20),
statename char(20),
Primary key (NeighborhoodID),
CONSTRAINT FK_CityState FOREIGN KEY (cityname,statename)
    REFERENCES city(Name,Area));

Create Table HOUSETYPE(
HouseTypeName char(20) not null Primary key );


CREATE TABLE Client (
TZ int NOT NULL primary key,
LastName varchar(255) NOT NULL,
FirstName varchar(255),
Adress char(30),
TelephoneNumber int not null unique,
Birthdate date check(year(getdate()) - year(birthdate) > 18));


Create Table HOUSEFORSALE(
HouseID int not null Primary key,
NeighborhoodID int References NEIGHBORHOOD(NeighborhoodID),
streetNumber int not null,
StreetName char(30) not null,
PurchaseDate date,
ClientTZ int references Client(TZ),
HouseType char(20) references HOUSETYPE(HouseTypeName),
Architect char(20),
Surface int not null,
RoomsNumber int not null,
Terrasse int,
Parking int,
Price int not null);

CREATE TABLE Employee (
TZ int NOT NULL primary key,
LastName varchar(255) NOT NULL,
FirstName varchar(255) not null,
Adress char(30),
TelephoneNumber int not null unique,
Birthdate date check(year(getdate()) - year(Birthdate) > 18));

Create Table SALESMAN(
LicenseNumber int primary key,
EmployeeTZ int unique references Employee(TZ));

Create Table SALE(
SaleId int primary key,
ClientTZ int references Client(TZ) not null,
HouseID int references HOUSEFORSALE(HouseID) not null,
SalesmanLicenseNumber int references SALESMAN(LicenseNumber),
TransactionDate date,
Price int not null,
Commission int not null, 
check (Price*0.002 < Commission));

Create Table House2Sale(
SaleID int not null references Sale(SaleID),
HouseID int not null references houseforsale(HouseID));

