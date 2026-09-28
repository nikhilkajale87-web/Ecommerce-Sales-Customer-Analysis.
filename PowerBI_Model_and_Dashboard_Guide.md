# Power BI Model & DAX

## Relationships
- `Customers[CustomerID]` 1 → * `Orders[CustomerID]`
- `Orders[OrderID]` 1 → * `Order_Items[OrderID]`
- `Products[ProductID]` 1 → * `Order_Items[ProductID]`
- `Orders[OrderID]` 1 → 1 `Payments[OrderID]` (or 1 → * if your model permits multiple payments)
- `Calendar[Date]` 1 → * `Orders[OrderDate]`

Mark `Calendar` as the date table using `Calendar[Date]`. Sort `Calendar[MonthName]` by `Calendar[MonthNo]`.

## Measures
```DAX
Product Revenue =
CALCULATE(
    SUM(Order_Items[LineTotal]),
    Orders[OrderStatus] <> "Cancelled",
    Orders[OrderStatus] <> "Returned"
)

Total Orders =
CALCULATE(
    DISTINCTCOUNT(Orders[OrderID]),
    Orders[OrderStatus] <> "Cancelled",
    Orders[OrderStatus] <> "Returned"
)

Total Customers = DISTINCTCOUNT(Orders[CustomerID])

Units Sold =
CALCULATE(
    SUM(Order_Items[Quantity]),
    Orders[OrderStatus] <> "Cancelled",
    Orders[OrderStatus] <> "Returned"
)

Average Order Value = DIVIDE([Product Revenue], [Total Orders])

Estimated Cost =
CALCULATE(
    SUMX(Order_Items, Order_Items[Quantity] * RELATED(Products[CostPrice])),
    Orders[OrderStatus] <> "Cancelled",
    Orders[OrderStatus] <> "Returned"
)

Estimated Gross Profit = [Product Revenue] - [Estimated Cost]

Gross Margin % = DIVIDE([Estimated Gross Profit], [Product Revenue])

Repeat Customers =
COUNTROWS(
    FILTER(
        VALUES(Orders[CustomerID]),
        CALCULATE(DISTINCTCOUNT(Orders[OrderID]), Orders[OrderStatus] <> "Cancelled", Orders[OrderStatus] <> "Returned") >= 2
    )
)

Repeat Customer Rate =
DIVIDE([Repeat Customers], [Total Customers])
```

## Page 1 — E-commerce Executive Overview
- KPI cards: Product Revenue, Total Orders, Total Customers, Average Order Value, Units Sold
- Line chart: Product Revenue by YearMonth
- Bar chart: Revenue by Category
- Bar chart: Top 10 Products by Revenue
- Bar chart: Revenue by Region
- Donut: Order Status distribution
- Slicers: Year, Region, Category, Order Status

## Page 2 — Customer & Product Insights
- Top customers by lifetime product revenue
- Repeat customer rate / order frequency
- Customer segment distribution
- Revenue by age group (create bins in Power BI)
- Product revenue and estimated gross profit
- Payment method mix
- Slicers: Date, Region, Customer Segment, Category, Brand

## Design guidance
Use a 16:9 canvas. Keep a consistent dark navy background, clear KPI cards, readable labels, and restrained accent colors. Ensure every chart responds to slicers.
