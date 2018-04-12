USE [Dealership]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
 * Drop all tables
 * - Order matters, you cannot delete tables depended on by other tables
 */
DROP TABLE [Contract]
DROP TABLE [Customer]
DROP TABLE [Lease]
DROP TABLE [Car]
DROP TABLE [CarData]

/*
 * CarData
 */
CREATE TABLE [dbo].[CarData](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Make] [nvarchar](50) NOT NULL,
	[Model] [nvarchar](50) NOT NULL,
	[Year] [int] NOT NULL,
 CONSTRAINT [PK_CarData] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/*
 * Car
 */
CREATE TABLE [dbo].[Car](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CarDataID] [int] NOT NULL,
	[Color] [nvarchar](50) NOT NULL,
	[VIN] [nvarchar](50) NOT NULL,
	[DateAddedToLot] [date] NOT NULL,
	[AvailableForLease] [bit] NOT NULL,
	[MilesDriven] [int] NOT NULL,
 CONSTRAINT [PK_Car] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Car Foreign Keys
ALTER TABLE [dbo].[Car]  WITH CHECK ADD  CONSTRAINT [FK_Car_CarData] FOREIGN KEY([CarDataID])
REFERENCES [dbo].[CarData] ([ID])
GO

ALTER TABLE [dbo].[Car] CHECK CONSTRAINT [FK_Car_CarData]
GO

/*
 * Lease
 */
CREATE TABLE [dbo].[Lease](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CarID] [int] NOT NULL,
	[ExpirationDate] [date] NOT NULL,
	[TotalCost] [money] NOT NULL,
	[UpFrontPayment] [money] NOT NULL,
	[CostPerMonth] [money] NOT NULL, 
 CONSTRAINT [PK_Lease] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Lease Foreign Keys
ALTER TABLE [dbo].[Lease]  WITH CHECK ADD  CONSTRAINT [FK_Lease_Car] FOREIGN KEY([CarID])
REFERENCES [dbo].[Car] ([ID])
GO

ALTER TABLE [dbo].[Lease] CHECK CONSTRAINT [FK_Lease_Car]
GO

/*
 * Customer
 */
CREATE TABLE [dbo].[Customer](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FullName] [nvarchar](50) NULL,
	[Email] [nvarchar](50) NULL,
	[PhoneNumber] [nvarchar](50) NULL,
	[FavoredCustomer] [bit] NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/*
 * Contract
 */
CREATE TABLE [dbo].[Contract](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[LeaseID] [int] NOT NULL,
 CONSTRAINT [PK_Contract] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Contract Foreign Keys
ALTER TABLE [dbo].[Contract]  WITH CHECK ADD  CONSTRAINT [FK_Contract_Customer] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([ID])
GO

ALTER TABLE [dbo].[Contract] CHECK CONSTRAINT [FK_Contract_Customer]
GO

ALTER TABLE [dbo].[Contract]  WITH CHECK ADD  CONSTRAINT [FK_Contract_Lease] FOREIGN KEY([LeaseID])
REFERENCES [dbo].[Lease] ([ID])
GO

ALTER TABLE [dbo].[Contract] CHECK CONSTRAINT [FK_Contract_Lease]
GO

/*
 * Fill tables in with garbage data
 */
insert
	into [dbo].[CarData]
		([Make], [Model], [Year])
	values
		('Toyota', 'Corolla', 1986),
		('Ford', 'Fiesta', 2016),
		('Chevrolet', 'Volt', 2015),
		('BMW', '340i', 2018)
go

insert
	into [dbo].[Car]
		(CarDataID, Color, VIN,
		DateAddedToLot, AvailableForLease, MilesDriven)
	values
		(1, 'panda', '2FMZA52284BA24952',
		'1986-07-14', 0, 863763),
		(2, 'yellow', '1GCHK23G21F180792',
		'2016-04-05', 0, 43567),
		(3, 'green', '1FUW8HCBXYHF86357',
		'2015-11-02', 1, 53729),
		(3, 'blue', '2GBHK34M1B1117870',
		'2017-06-17', 0, 12857),
		(4, 'pink', 'JM1GG12L871114341',
		'2018-03-27', 1, 4275),
		(4, 'red', '1C4AJWAG3DL502912',
		'2018-03-28', 0, 5123)
go

insert
	into [dbo].[Lease]
		(CarID, ExpirationDate, TotalCost, UpFrontPayment, CostPerMonth)
	values
		(1, '1993-07-24', $0, $0, $0),
		(2, '2019-04-22', $0, $0, $0),
		(4, '2023-01-30', $0, $0, $0),
		(6, '2045-04-05', $0, $0, $0)
go

insert 
	into [dbo].[Customer]
		(FullName, Email, PhoneNumber, FavoredCustomer)
	values
		('Arnold Amen', 'aa@example.fake', '938948739', 1),
		('Bonnno Brie', 'bb@example.fake', '143254678', 1),
		('Citt Crosse', 'cc@example.fake', '175847365', 1),
		('Dave Dilber', 'dd@example.fake', '123123456', 1),
		('Elp Elliett', 'ee@example.fake', '938475847', 1),
		('Fann Fruiui', 'ff@example.fake', '375694739', 0),
		('Grell Glenn', 'gg@example.fake', '482067333', 0),
		('Hanna Holte', 'hh@example.fake', '837485877', 0),
		('Ingret Iggs', 'ii@example.fake', '292929485', 0),
		('Jane Juilie', 'jj@example.fake', '555867583', 0)
go

insert
	into [dbo].[Contract]
		(CustomerID, LeaseID)
	values
		(1, 1),
		(3, 2),
		(5, 3),
		(7, 4)
go

 /*
  * Find all non Expired Leases
  */
select *
	from [dbo].[Lease]
	where [ExpirationDate] > convert(date, getdate())
go

 /*
  * Select the email of all favored customers
  */
select [Email]
	from [dbo].[Customer]
	where [FavoredCustomer] = 1
go

 /*
  * Show me the make, model, color, availability, and Miles Driven for all Cars
  */
select [Make], [Model], [Color], [AvailableForLease], [MilesDriven]
	from [dbo].[Car] as Car
		join [dbo].[CarData] as CarData
			on Car.CarDataID = CarData.ID
go

 /*
  * All the emails of Customers that have expired leases
  */
select [Email]
	from [dbo].[Contract] as [Contract]
		join [dbo].[Customer] as Customer
			on [Contract].CustomerID = Customer.ID
		join [dbo].[Lease] as Lease
			on [Contract].LeaseID = Lease.ID
	where
		Lease.ExpirationDate < convert(date, getdate())
go
		
 /*
  * The make and Model of the cars that are leased out
  */
select [Make], [Model]
	from [dbo].[Lease] as Lease
		join [dbo].[Car] as Car
			on Lease.CarID = Car.ID
		join [dbo].[CarData] as CarData
			on Car.CarDataID = CarData.ID
go
