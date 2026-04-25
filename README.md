# 📦 Bookstore Data Warehouse Project

## 🚀 Overview
This project transforms the **Gravity Bookstore** OLTP database — a real-world retail bookstore system — into a fully structured Data Warehouse optimized for analytical reporting and business insights.

The source system contains 13 normalized tables tracking books, authors, customers, orders, and shipping. The goal was to model, extract, transform, and load this data into a clean dimensional model ready for analysis.

---

## 🧱 Data Warehouse Design

The transactional database was redesigned into a **Star Schema** following Kimball's dimensional modeling methodology.

### Grain
> One row per order line — the most granular level of a sale.

### Schema

| Table | Type | Rows |
|-------|------|------|
| fact_sales | Fact Table | 15,385 |
| dim_date | Dimension — Generated | 7,671 |
| dim_book | Dimension — SCD Type 2 | 11,127 |
| dim_customer | Dimension — SCD Type 2 | 2,000 |
| dim_address | Dimension | 1,000 |
| dim_status_history | Dimension | 7,544 |
| bridge_book_author | Bridge Table | 17,642 |
| dim_author | Dimension | 9,235 |

### Key Design Decisions
- **SCD Type 2** applied on `dim_book` and `dim_customer` to track historical changes over time
- **Bridge table** to resolve the many-to-many relationship between books and authors
- **dim_status_history** stores the latest order status and shipping method (denormalized for simplicity)
- **shipping_cost_allocated** = total shipping cost divided by number of lines per order

---

## ⚙️ ETL Process — SSIS

8 SSIS packages were built to load data from the source database into the DWH:

| Package | Description |
|---------|-------------|
| dim_date | Generated calendar table (2015–2035) |
| dim_author | Full load from OLTP |
| dim_book | SCD Type 2 — Lookup + Conditional Split + OLE DB Command |
| dim_customer | SCD Type 2 — Lookup + Conditional Split + OLE DB Command |
| dim_address | Full load with country JOIN |
| dim_status_history | Latest status per order with shipping info |
| bridge_book_author | Lookup dim_book + dim_author → Destination |
| fact_sales | 5 Lookups + Derived Column for shipping cost allocation |

---

## 📊 OLAP Layer — SSAS

An SSAS Cube was built on top of the DWH to enable multidimensional analysis.

- **Measures:** Price, Shipping Cost Allocated, Fact Sales Count
- **Dimensions:** Date (Year → Quarter → Month hierarchy), Book, Customer, Address, Status History
- **15,385 rows** successfully processed

---

## 🏗️ Architecture

```
OLTP (gravity_books)
        ↓
   SSIS ETL (8 Packages)
        ↓
   Star Schema DWH (Bookstore_DWH)
        ↓
   SSAS Cube (Bookstore_DWH_View)
```

---

## 📁 Project Structure

```
Bookstore-DWH/
├── SQL/
│   ├── 01_Create_Tables.sql        ← DWH schema creation
│   ├── 02_DWH_Queries.sql          ← Analytical queries
│   └── 03_Data_Verification.sql    ← Data quality checks
├── SSIS/
│   ├── Screenshots/                ← Data flow screenshots per package
│   └── SSIS_project_DWH.sln       ← SSIS solution file
├── SSAS/
│   ├── Screenshots/                ← Cube structure and process results
│   └── SSAS_DWH_Project.sln       ← SSAS solution file
└── Docs/
    ├── Bookstore_DWH_Documentation.pdf
    └── dwh_star_schema.png
```

---

## 🛠️ Technologies Used

- **SQL Server** — Database and DWH creation
- **SSIS** — ETL pipeline development
- **SSAS** — OLAP Cube development
- **Visual Studio** — SSIS and SSAS projects


