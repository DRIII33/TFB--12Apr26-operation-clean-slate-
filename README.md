# Operation Clean Slate: Automated Data Quality Pipeline for HB 2067 Regulatory Compliance

**Author:** Daniel Rodriguez III  
**Role Context:** Data Quality Analyst II Portfolio Project  

## Executive Summary
"Operation Clean Slate" is an end-to-end data quality pipeline designed to safeguard property and casualty insurance data integrity. Under Texas House Bill (HB) 2067, insurers are legally mandated to proactively provide written reasons for policy declinations, cancellations, and non-renewals to the Texas Department of Insurance (TDI). 

This project simulates the rigorous data governance required at the Underwriting Data Office. It profiles, cleanses, and monitors raw policy transaction data to guarantee that all cancellation records exported from the policy administration system contain valid TDI reason codes, formatted Texas ZIP codes, and logically sound effective dates, achieving a 100% validity rate for statutory reporting.

## Architecture & Workflow

1. **Ingestion & Generation:** Python simulates a raw data extraction from an administration system (e.g., Guidewire PolicyCenter) featuring deliberate anomalies (nulls, formatting errors, logical date sequencing issues).
2. **Data Profiling (SOP 1):** BigQuery SQL calculates baseline health metrics, computing completeness indexes and duplicate rates.
3. **Validation & Cleansing (SOP 2 & 3):** SQL Views utilize advanced `CASE` logic and `REGEX` to standardize ZIP codes, enforce uppercase statutory codes, and flag anomalies based on Set Theory and relational logic.
4. **Monitoring & Alerting (SOP 6):** Aggregated metrics feed into a Looker Studio dashboard, acting as the daily observability layer to catch threshold breaches before data reaches the TDI.

## Technical Stack
* **Data Generation:** Python (Pandas, Numpy, Faker) via Google Colab.
* **Data Warehouse & Transformation:** Google BigQuery (Standard SQL). *(Enterprise Equivalent: Azure Synapse / SQL Server)*
* **Data Visualization:** Looker Studio. *(Enterprise Equivalent: Power BI)*
* **Version Control & Documentation:** Git / GitHub.

## Repository Navigation
* [`data_dictionary.md`](./data_dictionary.md): Comprehensive metadata, data types, and business logic for all tables.
* [`01_data_generation/`](./01_data_generation/): Python scripts used to synthesize the raw HB 2067 dataset.
* [`02_sql_pipeline/`](./02_sql_pipeline/): Core BigQuery SQL scripts executing Profiling, Cleansing, and Aggregation (SOP 1-6).
* [`03_visualizations/`](./03_visualizations/): Dashboard specifications and monitoring KPIs.

## Incident Response: Mock JIRA Ticket (SOP 4 & 5)
**Issue Key:** DQ-1042  
**Summary:** Logical Date Sequence Violation in Policy Actions  
**Assignee:** Daniel Rodriguez III (Data Quality Analyst II)  
**Reporter:** Automated DQ Pipeline (`vw_cleansed_policy_actions`)  
**Status:** In Progress  
**Priority/Severity:** High  (SLA: 24-Hour Resolution)  

### Description
During the nightly execution of the `vw_cleansed_policy_actions` validation view, the data observability pipeline flagged a critical logical anomaly: multiple records reflect an `action_effective_date` that occurs *prior* to the policy's `effective_date` (`is_logical_date_error = 1`). 

### Business Impact
This is a direct violation of the Texas Department of Insurance (TDI) HB 2067 reporting schema. A cancellation or non-renewal cannot legally or logically precede the initiation of the policy coverage. If this data is pushed to the TDI Statutory Reporting system, it will result in rejected filings, potential regulatory fines, and degraded actuarial trust in our cancellation lifecycle metrics.

### Affected Records
* **Query Reference:** `SELECT policy_id, effective_date, action_effective_date FROM driiiportfolio.tfbcic_staging.vw_cleansed_policy_actions WHERE is_logical_date_error = 1;`
* **Volume:** Approximately 2% of the generated synthetic batch.

### Proposed Resolution Steps (Root Cause Analysis - SOP 4)
1.  **Isolate:** Quarantine the flagged records from the downstream `vw_monthly_policy_action_dq_summary` feed to prevent data contamination.
2.  **Trace Lineage:** Cross-reference the affected `policy_id`s with the upstream Guidewire PolicyCenter transaction logs to determine if the error originates from a system clock bug, a manual agent override in the portal, or an ETL ingestion lag.
3.  **Remediate:** If traced to manual entry, collaborate with the Underwriting Operations team to implement a hard UI block in the Guidewire portal preventing retroactive cancellations prior to binding dates.
4.  **Validate:** Run `05_sop6_monitoring_aggregation.sql` post-fix to ensure `date_logic_failures` drops to `0`.

## 💡 Strategic Recommendations for Data Governance
Based on the outcomes of this pipeline, the following actions are recommended for enterprise deployment:
1. **Upstream Prevention:** Shift data validation rules "left" by embedding hard stops in the agent portal (Dynamics 365) to block the submission of policies missing mandatory TDI reason codes.
2. **Automated Alerting:** Integrate the `vw_monthly_policy_action_dq_summary` view with automated threshold alerts to notify Underwriting Managers immediately if the monthly TDI error rate exceeds the 1% acceptable risk threshold.
3. **Master Data Management:** Utilize the cleansed ZIP code outputs to enrich the master location data, ensuring more accurate catastrophe (CAT) modeling for Texas wind and hail risk.
