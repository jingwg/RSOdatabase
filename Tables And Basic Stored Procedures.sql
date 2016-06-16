--****** IMPORTANT *******
--We made a very important change to our database. We were running into a problem with adding events without 
--creating a registration. Since everything went through registration, associating a fee with an event, organization, 
--or merchandise required that a registration also be created. This cant happen because registrations are only 
--created when people register for events, organizations, or buy merchandise. The change we made was put fee in 
--the center of our table. This way we can create fees associated with events etc. when they are created and located 
--them when a person submits a registration. This also allows us to separate merchandise for events and organizations 
--giving us greater flexibility overall in our table.

-- *****************************
-- Create Tables
-- *****************************

CREATE TABLE PersonType (
	PersonTypeID INTEGER PRIMARY KEY NOT NULL IDENTITY(1,1),
	Name VARCHAR(255) NOT NULL,
	Description VARCHAR(500) NOT NULL
)

CREATE TABLE OrganizationType (
	OrgTypeID INTEGER PRIMARY KEY NOT NULL IDENTITY(1,1),
	OrgTypeName VARCHAR(255) NOT NULL,
	OrgTypeDescription VARCHAR(500)
)

CREATE TABLE Sponsor (
	SponsorID INTEGER PRIMARY KEY NOT NULL IDENTITY(1,1),
	Name VARCHAR(255) NOT NULL,
	SponsorRole VARCHAR(500) NOT NULL
)

CREATE TABLE EventType (
	EventTypeID INTEGER PRIMARY KEY NOT NULL IDENTITY(1,1),
	Name VARCHAR(255) NOT NULL
)

CREATE TABLE MerchType (
	MerchTypeID INTEGER IDENTITY(1,1)PRIMARY KEY NOT NULL,
	MerchTypeName VARCHAR(255) NOT NULL,
	MerchTypeDesc VARCHAR(255)
)

CREATE TABLE Fee (
	FeeID INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	Amount INT NOT NULL,
	DueDate DATETIME
)

CREATE TABLE Event (
	EventID INTEGER PRIMARY KEY NOT NULL IDENTITY(1,1),
	FeeID INTEGER FOREIGN KEY REFERENCES Fee(FeeID) NOT NULL,
	EventTypeID INTEGER FOREIGN KEY REFERENCES EventType(EventTypeID) NOT NULL,
	Name VARCHAR(255) NOT NULL,
	Capacity INTEGER NOT NULL,
	EventDescription VARCHAR(500),
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL
)

CREATE TABLE EventSponsor (
	SponsorID INTEGER FOREIGN KEY REFERENCES Sponsor(SponsorID)NOT NULL,
	EventID INTEGER FOREIGN KEY REFERENCES Event(EventID)NOT NULL,
	PRIMARY KEY(SponsorID, EventID)
)

CREATE TABLE Person (
	PersonID INTEGER PRIMARY KEY NOT NULL IDENTITY(1,1),
	PersonTypeID INT FOREIGN KEY REFERENCES PersonType(PersonTypeID) NOT NULL,
	Email VARCHAR(50) UNIQUE NOT NULL,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	DateOfBirth DATETIME NOT NULL,
	PhoneNumber  VARCHAR(25) NOT NULL
)

CREATE TABLE Registration (
	RegistrationID INTEGER PRIMARY KEY NOT NULL IDENTITY(1,1),
	FeeID INTEGER FOREIGN KEY REFERENCES Fee(FeeID) NOT NULL,
	PersonID INT FOREIGN KEY REFERENCES Person(PersonID) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NULL
)

CREATE TABLE Merchandise (
	MerchID INTEGER PRIMARY KEY NOT NULL IDENTITY(1,1),
	FeeID INTEGER FOREIGN KEY REFERENCES Fee(FeeID) NOT NULL,
	MerchTypeID INTEGER FOREIGN KEY REFERENCES MerchTYPE(MerchTypeID) NOT NULL,
	Name VARCHAR(255) NOT NULL,
	Quantity INTEGER NOT NULL
)

CREATE TABLE Organization (
	OrgID INTEGER PRIMARY KEY NOT NULL IDENTITY(1,1),
	FeeID INTEGER FOREIGN KEY REFERENCES Fee(FeeID) NOT NULL,
	OrgTypeID INTEGER FOREIGN KEY REFERENCES OrganizationType(OrgTypeID) NOT NULL,
	Name VARCHAR(255) NOT NULL,
	Season VARCHAR(255) NOT NULL,
	OrgDescription VARCHAR(500),
	Capacity INTEGER,
)


-- *****************************
-- Basic Stored Procedures
-- *****************************

-- Add Merchandise Type
-- ======================

GO 
CREATE PROCEDURE [dbo].[addMerchType]
	@MerchTypeName varchar(255)
AS
	INSERT INTO MerchType(MerchTypeName)
		VALUES(@MerchTypeName)




-- Add Merchandise
-- ======================

GO
CREATE PROCEDURE [dbo].[addMerchandise]
	@FeeID int,
	@MerchTypeID int,
	@Description varchar(255),
	@Quantity int
AS
	INSERT INTO Merchandise(FeeID, MerchTypeID, Description, Quantity)
		VALUES(@FeeID, @MerchTypeID, @Description, @Quantity)


-- Add Fee
-- ======================

GO
CREATE PROCEDURE [dbo].[addFee]
	@Amount int,
	@DueDate datetime
AS
	INSERT INTO Fee(Amount, DueDate)
		VALUES (@Amount, @DueDate)

-- Add Org Type
-- ======================
GO
CREATE  PROCEDURE [dbo].[addOrganizationType](
	@OrgTypeName varchar(255),
	@OrgTypeDescription varchar(500)
)
AS
INSERT INTO OrganizationType (OrgTypeName, OrgTypeDescription )
            
 VALUES (@OrgTypeName, @OrgTypeDescription)

-- Add Organization
-- ======================
GO
CREATE PROCEDURE [dbo].[addOrganization]
	@Name varchar(255), 
@FeeID int,
@OrgTypeID int,
@Season varchar(255),
	@OrgDescription varchar(255),
@Capacity int
AS
	INSERT INTO Organization (Name, FeeID, OrgTypeID, Season, OrgDescription, Capacity) 
		VALUES(@Name,@FeeID, @OrgTypeID, @Season, @OrgDescription, @Capacity)





-- Add Person Type
-- ======================

CREATE PROCEDURE [dbo].[addPersonType]
	@PersonTypeName varchar(255),
	@PersonTypeDesc varchar(500)
AS
	INSERT INTO PersonType(Name, Description) VALUES (@PersonTypeName, @PersonTypeDesc)

-- Add Person
-- ======================

GO
CREATE PROCEDURE [dbo].[addPerson]
	@PersonTypeID int,
	@Email varchar(255),
	@FName varchar(255),
	@LName varchar(255),
	@DateOfBirth datetime,
	@PhoneNumber varchar(20)
AS
	INSERT INTO Person(PersonTypeID, Email, FirstName, LastName, DateOfBirth, PhoneNumber)
		Values(@PersonTypeID, @Email, @FName, @LName, @DateOfBirth, @PhoneNumber)

-- Add Registration
-- ======================

GO
CREATE PROCEDURE [dbo].[addRegistration]
	@FeeID int,
	@PersonID varchar(255),
	@StartDate datetime,
	@EndDate datetime
AS
	INSERT INTO Registration(FeeID, PersonID, StartDate, EndDate)
		VALUES (@FeeID, @PersonID, @StartDate, @EndDate)

-- Add Sponsor
-- ======================

GO
CREATE PROCEDURE [dbo].[addSponsor](
	@Name varchar(225),
	@SponsorRole varchar(500)
)
AS
	INSERT INTO Sponsor 
		VALUES (@Name, @SponsorRole)

-- Add Event Sponsor
-- ======================

GO
CREATE PROCEDURE [dbo].[addEventSponsor]
	@SponsorID int,
	@EventID int
AS
	INSERT INTO EventSponsor(SponsorID, EventID)
		VALUES(@SponsorID, @EventID)


-- Add Event
-- ======================

GO
CREATE PROCEDURE [dbo].[addEvent]
	@FeeID int,
	@EventTypeID int, 
	@Name varchar(255), 
	@Capacity int, 
	@EventDescription varchar(255),
	@StartDate datetime, 
	@EndDate datetime 
AS
	INSERT INTO Event(FeeID, EventTypeID, Name, Capacity, EventDescription, StartDate, EndDate) 
		VALUES(@FeeID, @EventTypeID, @Name, @Capacity, @EventDescription, @StartDate, @EndDate)


-- Add EventType 
-- ======================

GO
CREATE PROCEDURE [dbo].[addEventType]
	@Name varchar(255)
AS
	INSERT INTO EventType(Name)
		VALUES(@Name)



