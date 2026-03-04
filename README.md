# 💳 End-to-End Credit Card Fraud Analytics Pipeline
### Azure Data Factory | Databricks | Delta Lake | Star Schema

## 📌 Project Overview
This project implements a robust, incremental data engineering pipeline using a Medallion Architecture. It processes credit card transaction data from a raw state to a highly optimized Star Schema in a Gold Layer, ready for BI reporting and Fraud Detection analysis.

## 🏗️ System Architecture
The pipeline is divided into three distinct stages:

- Ingestion (ADF & SQL Server): * Data is pulled from a GitHub source into a SQL Database.
  A Watermark Table and Stored Procedures manage incremental loading to ensure only new records are ingested, preventing redundant processing.
  
- Storage (ADLS Gen2):
  Bronze: Raw data landing zone.
  Silver: Cleaned and type-casted Parquet files.
  Gold: Final Delta tables organized in a Star Schema.

- Processing (Databricks & Spark):
  Complex transformations, surrogate key generation, and Delta Merges.

## 🛠️ Data Modeling (The Gold Layer)
Following a Star Schema design, the data is modeled to optimize query performance and maintain historical accuracy.

## Dimensions (SCD Logic)
Implemented a custom Left Join + Null Check logic (derived from technical design notes) to handle incremental dimension loading:

Account Dim: Tracks credit limits and account aging.

Merchant Dim: Categorizes transaction locations.

Card Dim: Manages card-specific metadata (CVV, Expiry).

Logic: New records are identified via Left Joins; surrogate keys are assigned by calculating max(key) + 1 to ensure continuity.

Fact Table (Transactional Hub)
Granularity: Individual credit card transactions.

Idempotency: Utilizes a txn_hash (SHA-256) to perform Delta Merges (Upserts). This ensures that re-running the pipeline never results in duplicate records.

## ⚡ Performance Optimizations
During the development of the Gold Layer, significant optimizations were implemented to handle large-scale data:

Partitioning: The Fact table is partitioned by transactionDate (Date-level) rather than timestamp to avoid the "Small File Problem" and reduce metadata overhead.

Predicate Pushdown: Accelerated Merge operations by adding date filters to the join condition, allowing Spark to skip irrelevant data partitions.

Shuffle Tuning: Utilized .repartition() before writes to ensure optimal file sizes in ADLS Gen2.

## 🚀 How to Run
SQL Setup: Run the scripts in /sql_scripts to initialize the Watermark table.
ADF Pipeline: Trigger the Ingestion pipeline to move data from Source to Bronze.
Databricks Notebooks: * Run Silver_Layer.py for data hardening.
Run Gold_Dimensions.py to update the "spokes."
Run Gold_Fact.py to perform the final Upsert/Merge.

## 📝 Design Philosophy
The logic for this pipeline was heavily influenced by a "Source of Truth" approach—ensuring that every record can be traced back to its origin while maintaining a high-performance, idempotent environment for downstream analytics.
