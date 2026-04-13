-- Feed for Looker Studio Dashboard
CREATE OR REPLACE VIEW
  `driiiportfolio`.`tfbcic_staging`.`vw_monthly_policy_action_dq_summary` AS
SELECT
  DATE_TRUNC(action_effective_date, MONTH) AS reporting_month,
  COUNT(*) AS volume,
  -- Calculate Data Quality Acceptance Standard
  ( SUM(
      CASE
        WHEN clean_tdi_reason_code IN ('MISSING_MANDATORY', 'INVALID_CODE') THEN 1
        ELSE 0
    END
      ) / COUNT(*)) * 100 AS tdi_error_rate,
  (SUM(CASE
        WHEN clean_zip_code = '00000' THEN 1
        ELSE 0
    END
      ) / COUNT(*)) * 100 AS zip_error_rate,
  SUM(is_logical_date_error) AS date_logic_failures
FROM
  `driiiportfolio`.`tfbcic_staging`.`vw_cleansed_policy_actions`
GROUP BY
  reporting_month
ORDER BY
  reporting_month DESC;
