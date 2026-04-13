-- Compute baseline metrics for completeness, uniqueness, and format validity
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT policy_id) AS unique_policies,
    -- Completeness Index [cite: 50, 633]
    SUM(CASE WHEN tdi_reason_code IS NULL AND policy_status != 'Active' THEN 1 ELSE 0 END) AS missing_tdi_codes,
    SUM(CASE WHEN property_zip_code IS NULL THEN 1 ELSE 0 END) AS missing_zips,
    -- Duplicate Rate
    (COUNT(*) - COUNT(DISTINCT policy_id)) AS duplicate_count,
    -- Format Anomalies
    SUM(CASE WHEN LENGTH(TRIM(property_zip_code)) != 5 THEN 1 ELSE 0 END) AS invalid_zip_formats
FROM
    `driiiportfolio.tfbcic_staging.raw_policy_actions`;
