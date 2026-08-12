# ☕ Brewlytics – Coffee Shop Sales Analysis

## 📌 Project Overview

Brewlytics is a data analytics project that analyzes coffee shop sales data to understand business performance, product performance, store performance, customer purchasing patterns, and revenue trends.

The project combines **Python, Pandas, NumPy, Matplotlib, Seaborn, SQL, and MySQL** to perform data analysis, visualization, and generate actionable business recommendations.

---

## 🎯 Objectives

- Analyze overall coffee shop sales performance
- Identify the best and worst performing stores
- Identify the best and worst performing product categories
- Analyze top-selling products
- Study monthly revenue trends
- Analyze sales by hour
- Analyze sales by day of the week
- Compare weekday and weekend performance
- Analyze store and product category performance
- Calculate revenue contribution
- Identify important sales patterns
- Generate business recommendations

---

## 🛠️ Technologies Used

- Python
- Pandas
- NumPy
- Matplotlib
- Seaborn
- Jupyter Notebook
- SQL
- MySQL
- MySQL Workbench

---

## 📊 Key Business Findings

| Metric | Result |
|---|---:|
| Total Revenue | $698,812.33 |
| Total Transactions | 149,116 |
| Total Items Sold | 214,470 |
| Best Performing Store | Hell's Kitchen |
| Best Store Revenue | $236,511.17 |
| Lowest Performing Store | Lower Manhattan |
| Lowest Store Revenue | $230,057.25 |
| Best Product Category | Coffee |
| Coffee Revenue | $269,952.45 |
| Lowest Product Category | Packaged Chocolate |
| Packaged Chocolate Revenue | $14,407.64 |
| Best Product Type | Barista Espresso |
| Barista Espresso Revenue | $91,406.20 |
| Lowest Product Type | Green beans |
| Green beans Revenue | $1,340.00 |

---

## 📈 Dashboard

The project includes an executive dashboard containing:

- Revenue by store
- Revenue by product category
- Monthly revenue trend
- Average revenue per transaction

Dashboard file:

`charts/brewlytics_dashboard.png`

---

## 🧮 SQL Analysis

The SQL analysis includes queries for:

- Overall sales performance
- Store performance
- Product category performance
- Top-selling products
- Revenue by store
- Monthly revenue
- Monthly revenue growth
- Sales by hour
- Sales by day of week
- Store and product performance
- Revenue contribution
- Weekday vs weekend performance
- Cumulative revenue trends

The complete SQL analysis is available in:

`sql/brewlytics_analysis.sql`

---

## 🐍 Python Analysis

The Jupyter Notebook contains analysis and visualization using:

- Pandas
- NumPy
- Matplotlib
- Seaborn

Notebook:

`notebooks/Brewlytics_Analysis.ipynb`

---

## 💡 Business Recommendations

Based on the analysis:

1. Focus inventory and marketing efforts on high-performing product categories.
2. Investigate the reasons behind lower-performing categories and products.
3. Study successful store-level strategies and apply them where appropriate.
4. Optimize staffing around peak sales periods.
5. Use promotional campaigns during weaker sales periods.
6. Encourage combo purchases to increase items per transaction.
7. Monitor monthly revenue trends for inventory and staffing decisions.

---

## 📂 Project Structure

```text
Brewlytics/
│
├── charts/
│   └── brewlytics_dashboard.png
│
├── data/
│   └── brewlytics_sales_raw.csv
│
├── notebooks/
│   └── Brewlytics_Analysis.ipynb
│
├── sql/
│   └── brewlytics_analysis.sql
│
├── README.md
└── requirements.txt