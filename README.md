# Bright-TV-Viewership-Analysis
Repository for Bright TV Viewership Analysis Project: covering data cleaning, exploration, visualisation, and insights. Tools: SQL, Databricks, BigQuery, Excel, PowerPoint, Google Looker Studio, Power BI, Canva, Miro, Figma, etc.

# 📊 Bright TV Viewership Analysis Dashboard
# 📌 Overview
This project explores and visualises viewership behaviour for Bright TV using processed audience and channel consumption data. The goal is to identify who watches the platform, when they watch, and which channels drive the highest engagement across demographics and regions.
This dataset was cleaned, transformed, enriched, and visualised to produce a comprehensive dashboard that supports audience insights and content strategy decisions.

# 🎯 Objectives
Understand Bright TV’s core audience segments
Analyse time-of-day, daily, and monthly viewing behaviours
Identify top-performing channels and regional viewing patterns
Explore demographic influence on engagement (age, gender, province)
Build a full analytics pipeline from raw data → insights → dashboard

# 🛠️ Tech Stack
SQL / Snowflake – Data cleaning, transformation & enrichment
Python (optional) – Exploratory checks
Google Looker Studio – Dashboard visualisation
Excel / CSV – Data structuring and additional pivot analysis
Canva – Presentation design

# 📁 Dataset
Processed dataset used for this project:
Processed Dataset- Bright motors.csv
(uploaded in project files)
Contains:
User demographic fields (Age, Gender, Province, etc.)
Channel information
Watch duration
Time-of-day fields (Day, Time Type, Month, Year)
Calculated fields (duration categories, view intensity, etc.)

# 🔧 Data Processing Steps
The analytics pipeline involved:

1. Data Extraction
Source files imported into Snowflake
Verified schema and column data types

3. Data Cleaning
Removed duplicates
Converted timestamps
Standardised duration formats
Handled missing values
Ensured accurate relationships between user and viewership tables

5. Feature Engineering
Created:
AGE_GROUP
TIME_TYPE (Morning, Afternoon, Evening, Night)
WATCH_DURATION categories
DURATION_MINUTES numeric field
DAY, MONTH, YEAR extracts

7. Dataset Enrichment
Joined user profiles with viewership data
Produced a final enriched dataset for dashboards

9. Visualisation
Built in Google Looker Studio using:
Bar charts
Line graphs
Heatmaps
Donut charts
Stacked visuals
Regional comparisons

# 📊 Key Insights
Viewership is dominated by males aged 26–44.
Afternoon is the peak viewing period; night-time has the lowest activity.
Sports and music channels (ICC Cricket World Cup, SuperSport, Channel O) lead nationally.
Gauteng shows the highest engagement across all age groups.
Mid-week viewing is consistently stronger than weekends.
Bright TV performs best as a daytime viewing platform.

# 🖥️ Dashboard Features
The final dashboard includes:
Audience segmentation (age × gender)
Time-of-day engagement
Provincial viewing distribution
Channel performance by region
Monthly and daily trends
Duration-based behavioural analysis
Gender-specific channel preferences

# 📦 Repository Structure
/data
   └── Processed Dataset- Bright motors.csv
/notebooks
   └── SQL transformation scripts
/dashboard
   └── Bright TV Dashboard (Looker Studio link)
/docs
   └── Presentation slides (Canva)
README.md

# 🚀 How to Use This Project
Clone the repository
Open the data folder to view the processed dataset
Review SQL scripts for transformation steps
Open the Looker Studio link to explore the dashboard
Use the insights for content strategy, BI reporting, or portfolio review

# 📈 Future Improvements
Automating pipeline using Airflow or DBT
Adding predictive modeling (e.g., peak hour forecasting)
Building a viewer churn model
Expanding with real-time streaming data

# 👩🏽‍💻 Author
Ashley Senare
Data Analyst & QA Engineer
Passionate about analytics, automation, and insight-driven storytelling
