Here is your **cleaned, markdown-ready document with a professional badge header added**. No content has been altered beyond citation removal and badge insertion.

---

# **Operation Clean Slate: End-to-End Insurance Data Quality & Compliance Pipeline (BigQuery + Looker Studio, HB 2067)**

![Domain](https://img.shields.io/badge/Domain-Insurance-blue)
![Focus](https://img.shields.io/badge/Focus-Data%20Quality%20%26%20Compliance-orange)
![Tech](https://img.shields.io/badge/Tech-BigQuery%20%7C%20SQL%20%7C%20Python%20%7C%20Looker%20Studio-green)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)
![Data Completeness](https://img.shields.io/badge/Data%20Completeness-90.01%25-success)
![Duplicate Rate](https://img.shields.io/badge/Duplicate%20Rate-0.00%25-success)

---

## **1. Generated Documentation**

### **I. Project Overview: Operation Clean Slate**

Operation Clean Slate is a data engineering and quality initiative designed to modernize the underwriting data lifecycle at **Texas Farm Bureau Casualty Insurance Company (TFBCIC)**. The project focuses on the transition from legacy spreadsheet-based tracking to a centralized BigQuery environment to ensure strict compliance with **Texas House Bill 2067 (HB 2067)**. This mandate requires high-fidelity reporting of policy cancellations, non-renewals, and declinations to the Texas Department of Insurance (TDI).

---

### **II. Data Dictionary**

* **`policy_id`**: Unique identifier for the insurance policy.
* **`tdi_reason_code`**: The standardized regulatory code for the underwriting action (e.g., UW01, CL02).
* **`clean_zip_code`**: A 5-digit validated Texas ZIP code, stripped of malformed characters or invalid patterns.
* **`quality_status_flag`**: A binary indicator (0/1) used to track if a record meets all audit-readiness standards.
* **`is_logical_date_error`**: A boolean flag identifying records where the action date precedes the effective date.

---

### **III. Technical Stack Summary**

* **Python (Colab)**: Used for synthetic data generation and initial data profiling to simulate real-world underwriting anomalies.
* **SQL (BigQuery)**: The primary engine for data transformation, deduplication, and regulatory rule enforcement.
* **Looker Studio**: The strategic visualization layer for monitoring real-time compliance KPIs.
* **Guidewire PolicyCenter**: The source system context for raw underwriting data ingestion.

---

### **IV. Data Profiling & Metrics Summary**

The project achieved a significant improvement in data integrity through the automated BigQuery pipeline:

* **Baseline Audit-Readiness**: 81.76% (Initial state with logical date errors and malformed ZIPs)
* **Post-Cleansing Completeness**: 90.01%
* **Duplicate Rate**: Reduced from 0.91% to 0.00% via MD5 hash-based deduplication
* **TDI Compliance**: Automated identification of 1,732 records requiring immediate remediation

---

### **V. Detailed Looker Studio Dashboard Summary (.MD)**

The **HB 2067 Data Quality & Compliance Monitoring Dashboard** provides a centralized strategic view of underwriting data health.

#### **KPI Scorecards**

* **Overall Completeness (90.01%)**: Tracks the population of mandatory regulatory fields across policy actions
* **Duplicate Rate (0.00%)**: Confirms the removal of redundant entries to prevent the artificial inflation of policy counts
* **TDI Error Rate (8.09%)**: Identifies the percentage of records failing statutory reporting standards

#### **Visual Components**

* **Anomalies Over Time (Combo Chart)**: Maps daily trends of TDI errors and ZIP code failures, allowing the Data Office to identify systemic ingestion issues
* **Exception Queue (Table)**: A tactical remediation tool listing specific Policy IDs, their error types (e.g., "INVALID CODE"), and logical date failures for 24-hour correction

---

### **VI. Strategic Recommendations**

1. **Automate 24-Hour Remediation**: Utilize the Looker Studio Exception Queue to drive daily workflows for the Underwriting Data Office
2. **Upstream Validation**: Integrate the "Clean ZIP" and "Reason Code" SQL logic directly into the Guidewire PolicyCenter entry forms to prevent errors at the point of ingestion
3. **Audit Readiness**: Maintain the BigQuery transformation logs as a secondary "Golden Record" for annual TDI data calls

---

## **2. Project Disclaimer (Concise)**

> **Professional Disclaimer**: All data utilized in "Operation Clean Slate" is synthetic and was programmatically generated for portfolio demonstration purposes only. This project is a simulated academic exercise to showcase data engineering and regulatory compliance proficiency and does not contain actual Texas Farm Bureau member information.

---

If you want to push this further, the next high-impact upgrade would be:

* **Table of Contents (clickable navigation)**
* **Architecture diagram section**
* **SQL + Python code snippets collapsible blocks**

That’s what moves this from *good portfolio* → *top-tier, interview-winning artifact*.
