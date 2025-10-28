USE [mssql_dbaas_inventory]
GO

/****** Object:  Table [dbo].[inventory]    Script Date: 10/28/2025 9:37:24 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[inventory](
	[server] [varchar](30) NOT NULL,
	[instance] [varchar](250) NOT NULL,
	[databaseName] [varchar](250) NOT NULL,
	[environment] [char](3) NOT NULL,
	[version] [varchar](70) NOT NULL,
	[edition] [varchar](70) NOT NULL,
	[dbStatus] [varchar](10) NOT NULL,
	[size] [varchar](20) NULL,
	[cname] [varchar](270) NULL,
	[businessGroup] [varchar](255) NULL,
	[location_id] [int] NOT NULL,
	[uuid] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_dbo.inventory] PRIMARY KEY CLUSTERED 
(
	[uuid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [SO],
 CONSTRAINT [UQ_inventory] UNIQUE NONCLUSTERED 
(
	[server] ASC,
	[databaseName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [SO]
) ON [SO]
GO

ALTER TABLE [dbo].[inventory]  WITH CHECK ADD FOREIGN KEY([location_id])
REFERENCES [dbo].[locations] ([Location_ID])
GO

ALTER TABLE [dbo].[inventory]  WITH CHECK ADD  CONSTRAINT [FK_inventory_Server] FOREIGN KEY([server])
REFERENCES [Dbaas].[Servers] ([ServerName])
GO

ALTER TABLE [dbo].[inventory] CHECK CONSTRAINT [FK_inventory_Server]
GO

USE [mssql_dbaas_inventory]
GO

/****** Object:  Table [dbo].[ssasInventory]    Script Date: 10/28/2025 9:37:38 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ssasInventory](
	[server] [varchar](30) NOT NULL,
	[instance] [varchar](250) NOT NULL,USE [mssql_dbaas_inventory]
GO

/****** Object:  Table [dbo].[ssisInventory]    Script Date: 10/28/2025 9:37:50 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ssisInventory](
	[server] [varchar](30) NOT NULL,
	[environment] [char](3) NOT NULL,
	[version] [varchar](70) NOT NULL,
	[edition] [varchar](70) NOT NULL,
	[path]  AS (('F:\SSIS\'+([businessGroup]+'\'))+[projectName]),
	[cname] [varchar](270) NOT NULL,
	[businessGroup] [varchar](255) NOT NULL,
	[projectName] [varchar](255) NOT NULL,
	[fullName]  AS (([businessGroup]+'\')+[projectName]),
	[uuid] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_dbo.ssisInventory] PRIMARY KEY CLUSTERED 
(
	[uuid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [SO],
 CONSTRAINT [UQ_ssisInventory] UNIQUE NONCLUSTERED 
(
	[server] ASC,
	[projectName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [SO]
) ON [SO]
GO

ALTER TABLE [dbo].[ssisInventory] ADD  DEFAULT (newid()) FOR [uuid]
GO

ALTER TABLE [dbo].[ssisInventory]  WITH CHECK ADD  CONSTRAINT [FK_ssisInventory_Server] FOREIGN KEY([server])
REFERENCES [Dbaas].[Servers] ([ServerName])
GO

ALTER TABLE [dbo].[ssisInventory] CHECK CONSTRAINT [FK_ssisInventory_Server]
GO

USE [mssql_dbaas_inventory]
GO

/****** Object:  Table [dbo].[ssrsInventory]    Script Date: 10/28/2025 9:38:03 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ssrsInventory](
	[server] [varchar](30) NOT NULL,
	[environment] [char](3) NOT NULL,
	[projectName] [varchar](250) NOT NULL,
	[version] [varchar](70) NOT NULL,
	[edition] [varchar](70) NOT NULL,
	[cname] [varchar](270) NOT NULL,
	[businessGroup] [varchar](255) NOT NULL,
	[fullName]  AS (([businessGroup]+'\')+[projectName]),
	[url]  AS (lower((((((('https://'+rtrim(ltrim([CNAME])))+'/')+rtrim(ltrim([ENVIRONMENT])))+'/browse/')+rtrim(ltrim([businessGroup])))+'/')+rtrim(ltrim([projectName])))),
	[uuid] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_dbo.ssrsInventory] PRIMARY KEY CLUSTERED 
(
	[uuid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [SO],
 CONSTRAINT [UQ_ssrsInventory] UNIQUE NONCLUSTERED 
(
	[server] ASC,
	[businessGroup] ASC,
	[projectName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [SO]
) ON [SO]
GO

ALTER TABLE [dbo].[ssrsInventory] ADD  DEFAULT (newid()) FOR [uuid]
GO

ALTER TABLE [dbo].[ssrsInventory]  WITH CHECK ADD  CONSTRAINT [FK_ssrsInventory_Server] FOREIGN KEY([server])
REFERENCES [Dbaas].[Servers] ([ServerName])
GO

ALTER TABLE [dbo].[ssrsInventory] CHECK CONSTRAINT [FK_ssrsInventory_Server]
GO

USE [mssql_dbaas_inventory]
GO

/****** Object:  Table [dbo].[dbiaasInstances]    Script Date: 10/28/2025 9:38:17 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[dbiaasInstances](
	[VroInstanceId] [varchar](46) NOT NULL,
	[InstanceName] [varchar](16) NOT NULL,
	[ServerName] [varchar](30) NULL,
	[Cname] [varchar](60) NOT NULL,
	[BusinessGroup] [varchar](30) NOT NULL,
	[InstanceCollation] [varchar](250) NOT NULL,
	[DataSpaceReservation] [int] NULL,
	[DataSpaceUsed] [int] NULL,
	[DataSpaceFree] [int] NULL,
	[LogSpaceReservation] [int] NULL,
	[LogSpaceUsed] [int] NULL,
	[LogSpaceFree] [int] NULL,
	[TempdbSpaceReservation] [int] NULL,
	[TempdbSpaceUsed] [int] NULL,
	[TempdbSpaceFree] [int] NULL,
	[InstancePort] [int] NULL,
	[InstanceEngineServiceAccount] [varchar](20) NOT NULL,
	[InstanceAgentServiceAccount] [varchar](20) NOT NULL,
	[InstanceBrowserServiceAccount] [varchar](20) NOT NULL,
	[InstanceFulltextSearchServiceAccount] [varchar](20) NOT NULL,
	[InstanceIntegrationServicesServiceAccount] [varchar](20) NOT NULL,
	[FriendlyName] [varchar](10) NOT NULL,
	[FriendlyNameVisible]  AS (case when [InstanceName]='MSSQLSERVER' then [Cname] else ([Cname]+'\')+[InstanceName] end),
	[uuid] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_dbo.dbiaasInstances] PRIMARY KEY CLUSTERED 
(
	[uuid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [SO],
 CONSTRAINT [UQ_dbiaasInstances] UNIQUE NONCLUSTERED 
(
	[ServerName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [SO]
) ON [SO]
GO

ALTER TABLE [dbo].[dbiaasInstances] ADD  DEFAULT (newid()) FOR [uuid]
GO

ALTER TABLE [dbo].[dbiaasInstances]  WITH CHECK ADD FOREIGN KEY([InstanceEngineServiceAccount])
REFERENCES [dbo].[serviceAccounts] ([ServiceAccountName])
GO

ALTER TABLE [dbo].[dbiaasInstances]  WITH CHECK ADD FOREIGN KEY([InstanceAgentServiceAccount])
REFERENCES [dbo].[serviceAccounts] ([ServiceAccountName])
GO

ALTER TABLE [dbo].[dbiaasInstances]  WITH CHECK ADD FOREIGN KEY([InstanceBrowserServiceAccount])
REFERENCES [dbo].[serviceAccounts] ([ServiceAccountName])
GO

ALTER TABLE [dbo].[dbiaasInstances]  WITH CHECK ADD FOREIGN KEY([InstanceFulltextSearchServiceAccount])
REFERENCES [dbo].[serviceAccounts] ([ServiceAccountName])
GO

ALTER TABLE [dbo].[dbiaasInstances]  WITH CHECK ADD FOREIGN KEY([InstanceIntegrationServicesServiceAccount])
REFERENCES [dbo].[serviceAccounts] ([ServiceAccountName])
GO

ALTER TABLE [dbo].[dbiaasInstances]  WITH CHECK ADD FOREIGN KEY([ServerName])
REFERENCES [dbo].[dbiaasServers] ([ServerName])
GO


	[databaseName] [varchar](250) NOT NULL,
	[environment] [char](3) NOT NULL,
	[version] [varchar](70) NOT NULL,
	[edition] [varchar](70) NOT NULL,
	[cname] [varchar](270) NOT NULL,
	[businessGroup] [varchar](255) NOT NULL,
	[mode] [varchar](20) NULL,
	[vroDatabaseId] [varchar](250) NULL,
	[uuid] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_dbo.ssasInventory] PRIMARY KEY CLUSTERED 
(
	[uuid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [SO],
 CONSTRAINT [UQ_ssasInventory] UNIQUE NONCLUSTERED 
(
	[server] ASC,
	[databaseName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [SO]
) ON [SO]
GO

ALTER TABLE [dbo].[ssasInventory] ADD  DEFAULT (newid()) FOR [uuid]
GO

ALTER TABLE [dbo].[ssasInventory]  WITH CHECK ADD  CONSTRAINT [FK_ssasInventory_Server] FOREIGN KEY([server])
REFERENCES [Dbaas].[Servers] ([ServerName])
GO

ALTER TABLE [dbo].[ssasInventory] CHECK CONSTRAINT [FK_ssasInventory_Server]
GO


USE [mssql_dbaas_inventory]
GO

/****** Object:  Table [Tracking].[ServerChangeLog]    Script Date: 10/28/2025 9:44:07 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Tracking].[ServerChangeLog](
	[ChangeID] [bigint] IDENTITY(1,1) NOT NULL,
	[ServerName] [nvarchar](30) NOT NULL,
	[Environment] [char](3) NOT NULL,
	[LocationID] [int] NOT NULL,
	[SqlVersion] [nvarchar](10) NOT NULL,
	[ServiceName] [nvarchar](50) NOT NULL,
	[LifecycleState] [char](1) NOT NULL,
	[OperationType] [char](6) NOT NULL,
	[CreatedAt] [datetime2](3) NOT NULL,
	[CreatedBy] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[ChangeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [SO]
) ON [SO]
GO

ALTER TABLE [Tracking].[ServerChangeLog] ADD  CONSTRAINT [DF_ServerChangeLog_CreatedAt]  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO

ALTER TABLE [Tracking].[ServerChangeLog] ADD  CONSTRAINT [DF_ServerChangeLog_CreatedBy]  DEFAULT (suser_sname()) FOR [CreatedBy]
GO

ALTER TABLE [Tracking].[ServerChangeLog]  WITH CHECK ADD  CONSTRAINT [CK_ServerChangeLog_OperationType] CHECK  (([OperationType]='UPDATE' OR [OperationType]='DELETE' OR [OperationType]='INSERT'))
GO

ALTER TABLE [Tracking].[ServerChangeLog] CHECK CONSTRAINT [CK_ServerChangeLog_OperationType]
GO



