# Data Dictionary: Operation Clean Slate

This document serves as the centralized metadata repository for the Operation Clean Slate data quality pipeline, adhering to Data Governance execution standards (SOP 7). It defines the schema, data types, and business logic for all tables and views utilized in the HB 2067 compliance reporting pipeline.

## 1. Source Table: `raw_policy_actions`
**Description:** Raw staging table containing simulated export data representing policy cancellation, declination, and non-renewal records ingested from the policy administration system (e.g., Guidewire PolicyCenter).

| Column Name | Data Type | Business Definition | Quality/Validation Notes |
| :--- | :--- | :--- | :--- |
| `policy_id` | STRING | Unique alphanumeric identifier for the policyholder's risk record. | Must be unique per action. |
| `effective_date` | DATE | The date the policy coverage was originally bound and became active. | Foundational date for longitudinal timeline. |
| `action_effective_date` | DATE | The date the cancellation, declination, or non-renewal takes effect. | **Rule:** Must be >= `effective_date`. |
| `policy_status` | STRING | The current state of the policy (e.g., Active, Canceled, Non-Renewed, Declined). | Determines if TDI reporting is required. |
| `tdi_reason_code` | STRING | The Texas Department of Insurance (TDI) shorthand code explaining the adverse action. | Must map to an approved TDI statutory code. |
| `property_zip_code` | STRING | The postal code of the insured property location. | Target format: 5-digit string. |

---

## 2. Cleansed View: `vw_cleansed_policy_actions`
**Description:** Standardized view applying Regex and CASE logic (SOP 3) to enforce validation rules (SOP 2) and flag logical exceptions for Root Cause Analysis (SOP 4).

| Column Name | Data Type | Business Definition | Transformation / Rule Applied |
| :--- | :--- | :--- | :--- |
| `policy_id` | STRING | Unique policy identifier. | Deduplicated utilizing `ROW_NUMBER()`. |
| `effective_date` | DATE | Original policy effective date. | Passed through from raw. |
| `action_effective_date` | DATE | Effective date of the adverse action. | Passed through from raw. |
| `policy_status` | STRING | Current state of the policy. | Passed through from raw. |
| `clean_tdi_reason_code` | STRING | Cleansed and standardized TDI reason code. | UPPER/TRIM applied. Invalid codes flagged as `INVALID_CODE`; missing mandatory codes flagged as `MISSING_MANDATORY`. |
| `clean_zip_code` | STRING | Standardized 5-digit property ZIP code. | Regex applied to extract 5 digits. Malformed codes flagged as `00000`. |
| `is_logical_date_error` | INT64 | Boolean flag indicating a temporal anomaly where the action predates the policy start. | `1` if `action_effective_date < effective_date`, else `0`. |

---

## 3. Aggregation View: `vw_monthly_policy_action_dq_summary`
**Description:** Aggregated metrics table feeding the downstream Business Intelligence visualizations (SOP 6) to monitor data health and trigger automated alerts.

| Column Name | Data Type | Business Definition | Calculation Logic |
| :--- | :--- | :--- | :--- |
| `reporting_month` | DATE | The truncated month and year of the adverse action. | `DATE_TRUNC(action_effective_date, MONTH)` |
| `volume` | INT64 | Total count of adverse actions processed in the reporting month. | `COUNT(*)` |
| `tdi_error_rate` | FLOAT64 | Percentage of records with missing or invalid TDI reason codes. | `(Sum of errors / Total volume) * 100` |
| `zip_error_rate` | FLOAT64 | Percentage of records with malformed property ZIP codes. | `(Sum of errors / Total volume) * 100` |
| `date_logic_failures` | INT64 | Total count of temporal anomalies identified in the batch. | `SUM(is_logical_date_error)` |
