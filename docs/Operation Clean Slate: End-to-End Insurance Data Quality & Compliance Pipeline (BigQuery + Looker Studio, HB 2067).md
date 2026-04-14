# **Operation Clean Slate: End-to-End Insurance Data Quality & Compliance Pipeline**

### **(BigQuery + Looker Studio | Texas HB 2067 Compliance)**

![](https://www.google.com/search?q=%23i-project-overview-operation-clean-slate)
![](https://www.google.com/search?q=%23i-project-overview-operation-clean-slate)
![](https://www.google.com/search?q=%23iii-technical-stack-summary)
![](https://www.google.com/search?q=%23)
![](https://www.google.com/search?q=%23iv-data-profiling--metrics-summary)
![](https://www.google.com/search?q=%23iv-data-profiling--metrics-summary)
![](https://www.google.com/search?q=%23v-detailed-looker-studio-dashboard-summary-md)

-----

## **1. Documentation**

### **I. Project Overview: Operation Clean Slate**

**Operation Clean Slate** is a data engineering and quality initiative designed to modernize the underwriting data lifecycle at **Texas Farm Bureau Casualty Insurance Company (TFBCIC)**.

The project facilitates the transition from legacy spreadsheet-based tracking to a centralized **BigQuery** environment. This shift ensures strict compliance with **Texas House Bill 2067 (HB 2067)**, a regulatory mandate requiring high-fidelity reporting of policy cancellations, non-renewals, and declinations to the **Texas Department of Insurance (TDI)**.

-----

### **II. Data Dictionary**

  * **`policy_id`**: Unique identifier for the insurance policy.
  * **`tdi_reason_code`**: Standardized regulatory code for underwriting actions (e.g., UW01, CL02).
  * **`clean_zip_code`**: A validated 5-digit Texas ZIP code, stripped of malformed characters or invalid patterns.
  * **`quality_status_flag`**: A binary indicator (0/1) used to track if a record meets all audit-readiness standards.
  * **`is_logical_date_error`**: A boolean flag identifying records where the action effective date precedes the policy effective date.

-----

### **III. Technical Stack Summary**

  * **Python (Google Colab)**: Utilized for synthetic data generation and initial data profiling to simulate real-world underwriting anomalies.
  * **SQL (BigQuery)**: The core engine for data transformation, deduplication (MD5 hashing), and regulatory rule enforcement.
  * **Looker Studio**: The strategic visualization layer for monitoring real-time compliance KPIs and severity-based trends.
  * **Guidewire PolicyCenter**: The source system context for raw underwriting data ingestion and upstream validation logic.

-----

### **IV. Data Profiling & Metrics Summary**

The automated BigQuery pipeline achieved measurable improvements in data integrity:

  * **Baseline Audit-Readiness**: **81.76%** (Initial state containing logical date errors and malformed ZIPs).
  * **Post-Cleansing Completeness**: **90.01%** (Achieved through automated null handling and formatting).
  * **Duplicate Rate**: Reduced from **0.91% to 0.00%** via primary key and MD5 hash-based deduplication.
  * **TDI Compliance**: Automated identification of **1,732 records** requiring immediate remediation to meet statutory deadlines.

-----

### **V. Detailed Looker Studio Dashboard Summary (.MD)**

The **HB 2067 Data Quality & Compliance Monitoring Dashboard** serves as the primary strategic view for underwriting data health.

#### **KPI Scorecards**

  * **Overall Completeness (90.01%)**: Tracks the population of mandatory regulatory fields across all policy actions.
  * **Duplicate Rate (0.00%)**: Confirms the removal of redundant entries to prevent the artificial inflation of policy counts in regulatory filings.
  * **TDI Error Rate (8.09%)**: Flags the percentage of records failing statutory reporting standards for immediate review.

#### **Visual Components**

  * **Anomalies Over Time (Combo Chart)**: Maps daily trends of TDI errors and ZIP code failures, enabling the Data Office to identify systemic ingestion issues or training gaps.
  * **Exception Queue (Table)**: A tactical remediation tool listing specific Policy IDs, error types (e.g., "INVALID CODE"), and date failures to facilitate mandated 24-hour correction cycles.

-----

### **VI. Strategic Recommendations**

1.  **Automate 24-Hour Remediation**: Integrate the Looker Studio Exception Queue into daily Underwriting Data Office workflows to ensure compliance with TDI turnaround times.
2.  **Upstream Validation**: Port the "Clean ZIP" and "Reason Code" SQL logic into **Guidewire PolicyCenter** entry forms to intercept errors at the point of entry.
3.  **Audit Readiness**: Archive the BigQuery transformation logs as a secondary "Golden Record" to provide full lineage during annual TDI data calls.

-----

## **2. Project Disclaimer**

> **Professional Disclaimer**: All data utilized in "Operation Clean Slate" is synthetic and was programmatically generated for portfolio demonstration purposes only. This project is a simulated exercise to showcase data engineering and regulatory compliance proficiency and does not contain actual Texas Farm Bureau member information.

-----
