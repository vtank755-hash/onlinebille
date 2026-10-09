/* ==========================================================================
   ONLINE BILLING SYSTEM  -  OnlineBillingDB
   ==========================================================================
   Creates the SQL Server database file (OnlineBillingDB.mdf + its log)
   directly inside this project's App_Data folder, then creates the 4
   tables of the website:

       Users       - registration / login / Admin-User role
       Customers   - Add Customer page + Bill Entry customer dropdown
       Bills       - invoices saved on Bill Entry (Dashboard / View Bills)
       BillItems   - line items (Item / Qty / Rate) of every bill

   plus the 5 design customers of the Figma layout.

   HOW TO RUN  (one time, on mac book ):
   ---------------------------------------------------------------------------
   1. EDIT the two FILENAME paths marked << EDIT below so they point to the
      App_Data folder of THIS project on your machine, for example:
        C:\Users\you\source\repos\online bille11 \App_Data\OnlineBillingDB.mdf
      (both the .mdf and the .ldf path must sit in the same App_Data folder)

   2. Run the script:
        Method A - double-click this .sql file in Visual Studio Solution
                   Explorer and press Execute (connect to
                   (LocalDB)\MSSQLLocalDB), or
        Method B - in Visual Studio: App_Data > Add > SQL Server Database
                   (name it OnlineBillingDB - VS writes the correct path
                   itself), then execute ONLY from the "2. TABLES" part.

   3. OnlineBillingDB.mdf appears in App_Data - that IS the database.
      Web.config already has the connection string pointing to it.

   NOTE: the script and Web.config use (LocalDB)\MSSQLLocalDB, so the file
   is created and attached by your own Windows account (it can write into
   App_Data without permission problems).
   ========================================================================== */

USE [master];
GO

/* ------------------------- 1. DATABASE FILE ------------------------------ */
IF DB_ID(N'OnlineBillingDB') IS NULL
BEGIN
    CREATE DATABASE [OnlineBillingDB]
    ON PRIMARY
    (
        NAME       = N'OnlineBillingDB',
        FILENAME   = N'C:\PATH\TO\YOUR\PROJECT\App_Data\OnlineBillingDB.mdf',   -- << EDIT
        SIZE       = 8192KB,
        FILEGROWTH = 65536KB
    )
    LOG ON
    (
        NAME       = N'OnlineBillingDB_log',
        FILENAME   = N'C:\PATH\TO\YOUR\PROJECT\App_Data\OnlineBillingDB_log.ldf',   -- << EDIT
        SIZE       = 2048KB,
        FILEGROWTH = 1024KB
    );
END
GO

USE [OnlineBillingDB];
GO

/* ------------------------------- 2. TABLES -------------------------------- */

/* Users - Register inserts a row, Login verifies e-mail + password,
   Session keeps UserId / UserName / Role of the signed-in user.            */
IF OBJECT_ID(N'dbo.Users', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Users
    (
        UserId    INT           IDENTITY(1,1) NOT NULL,
        FullName  NVARCHAR(100) NOT NULL,
        Email     NVARCHAR(100) NOT NULL,          -- login key
        Mobile    NVARCHAR(10)  NOT NULL,
        [Password] NVARCHAR(50) NOT NULL,
        Role      NVARCHAR(20)  NOT NULL
                  CONSTRAINT DF_Users_Role DEFAULT N'User',   -- 'Admin' / 'User'
        CreatedOn DATETIME      NOT NULL
                  CONSTRAINT DF_Users_CreatedOn DEFAULT GETDATE(),

        CONSTRAINT PK_Users PRIMARY KEY CLUSTERED (UserId),
        CONSTRAINT UX_Users_Email UNIQUE (Email)
    );
END
GO

/* Customers - the Add Customer page saves a row here; the Bill Entry
   dropdown reads it and auto-fills Mobile / Address / Bill Date.
   CustId is the display code CST-1048 style used on the pages.             */
IF OBJECT_ID(N'dbo.Customers', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Customers
    (
        CustomerId INT           IDENTITY(1,1) NOT NULL,
        CustId     NVARCHAR(12)  NOT NULL,         -- e.g. CST-1048
        Name       NVARCHAR(100) NOT NULL,
        Mobile     NVARCHAR(10)  NOT NULL,
        Address    NVARCHAR(200) NOT NULL,
        CreatedOn  DATETIME      NOT NULL
                   CONSTRAINT DF_Customers_CreatedOn DEFAULT GETDATE(),

        CONSTRAINT PK_Customers PRIMARY KEY CLUSTERED (CustomerId),
        CONSTRAINT UX_Customers_CustId UNIQUE (CustId)
    );
END
GO

/* Bills - one row per invoice saved on Bill Entry (bill number, date,
   customer, grand total, Cash/Pending). Feeds Dashboard stats, the saved
   toast and the future View Bills page.
   CustomerId NULL  =  "Walk-in Customer" (no customer selected).
   CreatedBy  = UserId of the signed-in user who created the bill.          */
IF OBJECT_ID(N'dbo.Bills', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Bills
    (
        BillNo      NVARCHAR(30)  NOT NULL,        -- BIL-yyyyMMddHHmmss-####
        BillDate    DATE          NOT NULL,
        CustomerId  INT           NULL,
        GrandTotal  DECIMAL(18,2) NOT NULL,
        PaymentMode NVARCHAR(10)  NOT NULL,        -- only 'Cash' or 'Pending'
        CreatedBy   INT           NULL,
        CreatedOn   DATETIME      NOT NULL
                    CONSTRAINT DF_Bills_CreatedOn DEFAULT GETDATE(),

        CONSTRAINT PK_Bills PRIMARY KEY CLUSTERED (BillNo),
        CONSTRAINT CK_Bills_GrandTotal  CHECK (GrandTotal >= 0),
        CONSTRAINT CK_Bills_PaymentMode CHECK (PaymentMode IN (N'Cash', N'Pending')),
        CONSTRAINT FK_Bills_Customers FOREIGN KEY (CustomerId)
                    REFERENCES dbo.Customers (CustomerId),
        CONSTRAINT FK_Bills_Users FOREIGN KEY (CreatedBy)
                    REFERENCES dbo.Users (UserId)
    );
END
GO

/* BillItems - the item rows typed in the Bill Entry grid (Item / Qty /
   Rate), Amount = Qty x Rate. Deleting a bill removes its items
   (ON DELETE CASCADE).                                                    */
IF OBJECT_ID(N'dbo.BillItems', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.BillItems
    (
        ItemId   INT           IDENTITY(1,1) NOT NULL,
        BillNo   NVARCHAR(30)  NOT NULL,
        ItemName NVARCHAR(150) NOT NULL,
        Qty      INT           NOT NULL,
        Rate     DECIMAL(18,2) NOT NULL,
        Amount   DECIMAL(18,2) NOT NULL,           -- Qty x Rate

        CONSTRAINT PK_BillItems PRIMARY KEY CLUSTERED (ItemId),
        CONSTRAINT CK_BillItems_Qty    CHECK (Qty > 0),
        CONSTRAINT CK_BillItems_Rate   CHECK (Rate >= 0),
        CONSTRAINT CK_BillItems_Amount CHECK (Amount >= 0),
        CONSTRAINT FK_BillItems_Bills FOREIGN KEY (BillNo)
                    REFERENCES dbo.Bills (BillNo) ON DELETE CASCADE
    );
END
GO

/* --------------------------- 3. INDEXES (FK columns) ---------------------- */
IF NOT EXISTS (SELECT 1 FROM sys.indexes
               WHERE name = N'IX_Bills_CustomerId'
                 AND object_id = OBJECT_ID(N'dbo.Bills'))
    CREATE NONCLUSTERED INDEX IX_Bills_CustomerId ON dbo.Bills (CustomerId);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes
               WHERE name = N'IX_Bills_CreatedBy'
                 AND object_id = OBJECT_ID(N'dbo.Bills'))
    CREATE NONCLUSTERED INDEX IX_Bills_CreatedBy ON dbo.Bills (CreatedBy);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes
               WHERE name = N'IX_BillItems_BillNo'
                 AND object_id = OBJECT_ID(N'dbo.BillItems'))
    CREATE NONCLUSTERED INDEX IX_BillItems_BillNo ON dbo.BillItems (BillNo);
GO

/* --------------------------- 4. SAMPLE DATA ------------------------------- */
/* The 5 customers of the Figma design (Bill Entry dropdown + Dashboard).
   Inserted only while the table is empty, so re-running the script is safe.
   Delete them freely - they are sample rows, not required by the code.      */
IF NOT EXISTS (SELECT 1 FROM dbo.Customers)
BEGIN
    INSERT INTO dbo.Customers (CustId, Name, Mobile, Address) VALUES
        (N'CST-1043', N'Rahul Patel',  N'9876543210', N'24, MG Road, Indore'),
        (N'CST-1044', N'Anjali Gupta', N'9825012345', N'7, Lake View, Bhopal'),
        (N'CST-1045', N'Amit Yadav',   N'9765432109', N'15, Station Road, Jabalpur'),
        (N'CST-1046', N'Raj Mehta',    N'9911223344', N'3, Nehru Nagar, Ujjain'),
        (N'CST-1047', N'Pooja Sharma', N'9798765432', N'88, Vijay Nagar, Gwalior');
END
GO

/* Optional demo login for testing - uncomment to insert:
   e-mail  admin@billing.com   password  admin123

INSERT INTO dbo.Users (FullName, Email, Mobile, [Password], Role)
VALUES (N'Shop Admin', N'admin@billing.com', N'9000000000', N'admin123', N'Admin');
*/

/* --------------------------- 5. CHECK ------------------------------------- */
SELECT [Table] = name FROM sys.tables ORDER BY name;
/* Expected: BillItems, Bills, Customers, Users  (4 rows)                   */
