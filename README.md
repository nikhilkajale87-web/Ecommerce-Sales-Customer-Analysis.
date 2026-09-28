# E-commerce Sales & Customer Analysis

A portfolio-ready analytics project using **Excel, SQL, and Power BI** to explore e-commerce sales, product performance, customer behavior, repeat purchases, and estimated profitability.

> **Dataset note:** All included records are synthetic and generated for learning and portfolio demonstration. They do not represent real customers, transactions, or a real company.

## Project objectives
- Track revenue, order volume, average order value, and units sold.
- Identify high-performing product categories and products.
- Understand customer purchasing patterns and repeat-customer behavior.
- Compare sales across regions and customer segments.
- Explore payment methods, order statuses, and estimated product profitability.

## Repository structure
```text
Ecommerce_Sales_Customer_Analysis/
├── data/
│   ├── Customers.csv
│   ├── Products.csv
│   ├── Orders.csv
│   ├── Order_Items.csv
│   ├── Payments.csv
│   ├── Calendar.csv
│   └── Ecommerce_Sales_Customer_Analysis.xlsx
├── sql/
│   └── ecommerce_analysis.sql
├── powerbi/
│   └── PowerBI_Model_and_Dashboard_Guide.md
├── screenshots/
│   └── dashboard_layout_preview.png
└── README.md
```

## Tools
- Microsoft Excel
- SQL (SQL Server syntax)
- Power BI Desktop
- Power Query
- DAX

## Data model
- Customers → Orders
- Orders → Order_Items
- Products → Order_Items
- Orders → Payments
- Calendar → Orders

## Key metrics
- Product Revenue (excludes Cancelled and Returned orders)
- Total Orders
- Total Customers
- Average Order Value
- Units Sold
- Estimated Gross Profit and Gross Margin
- Repeat Customer Rate

## How to use
1. Download or clone this repository.
2. Import the CSV files into Power BI, or use the Excel workbook.
3. Create relationships using the guide in `powerbi/PowerBI_Model_and_Dashboard_Guide.md`.
4. Create the DAX measures and build the report pages.
5. Run the queries in `sql/ecommerce_analysis.sql` in SQL Server after creating/loading the tables.
6. Replace the layout preview with screenshots of your actual Power BI report.
7. Add your `.pbix` file if you want to share the editable report.

## Dashboard pages
1. **E-commerce Executive Overview** — KPIs, monthly revenue, category/product performance, regional revenue, and order status.
2. **Customer & Product Insights** — top customers, repeat behavior, segments, estimated profitability, and payment methods.

## Limitations
- Data is synthetic; findings should be described as demonstration insights, not real-world business conclusions.
- Estimated profit uses the generated `CostPrice` field and does not include overhead, taxes, or other operating costs.
- The included dashboard image is a layout concept, not a screenshot from Power BI Desktop.
