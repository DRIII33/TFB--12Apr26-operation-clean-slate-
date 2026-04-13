-- Create a cleansed, standardized view applying Regex and CASE logic [cite: 46, 56]
CREATE OR REPLACE VIEW `driiiportfolio.tfbcic_staging.vw_cleansed_policy_actions` AS
WITH Deduplicated AS (
    SELECT 
        *,
        ROW_NUMBER() OVER(PARTITION BY policy_id ORDER BY action_effective_date DESC) as row_num
    FROM `driiiportfolio.tfbcic_staging.raw_policy_actions`
)
SELECT
    policy_id,
    effective_date,
    action_effective_date,
    policy_status,
    
    -- SOP 3: Standardization - Force Uppercase, replace invalid with 'UNKNOWN'
    CASE 
        WHEN tdi_reason_code IN ('UW01', 'UW02', 'UW03', 'CL01', 'CL02', 'MISC') THEN UPPER(TRIM(tdi_reason_code))
        WHEN tdi_reason_code IS NULL AND policy_status != 'Active' THEN 'MISSING_MANDATORY'
        ELSE 'INVALID_CODE'
    END AS clean_tdi_reason_code,
    
    -- SOP 3: Regex Standardization for ZIP codes (extract first 5 digits) [cite: 57, 485]
    CASE
        WHEN REGEXP_CONTAINS(property_zip_code, r'^[0-9]{5}$') THEN property_zip_code
        WHEN REGEXP_CONTAINS(property_zip_code, r'^[0-9]{5}-[0-9]{4}$') THEN SUBSTR(property_zip_code, 1, 5)
        ELSE '00000' -- Flag for SOP 4 Root Cause Analysis
    END AS clean_zip_code,

    -- SOP 2: Cross-field Validation [cite: 489, 808]
    CASE 
        WHEN action_effective_date < effective_date THEN 1 
        ELSE 0 
    END AS is_logical_date_error

FROM Deduplicated
WHERE row_num = 1; -- Enforce Uniqueness [cite: 508]
