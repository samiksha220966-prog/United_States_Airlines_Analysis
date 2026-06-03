-- =====================================================================
-- Healthcare Cost Prediction - SQL Queries
-- Capstone Project
-- =====================================================================

-- Create merged table from the three datasets
-- Note: In actual implementation, this would be done via JOINs
-- This script assumes data has been loaded into a database

-- =====================================================================
-- QUERY 1: Diabetic Patients with Heart Issues
-- =====================================================================
-- Retrieve summary information about diabetic individuals (HBA1C > 6.5) 
-- with heart problems

SELECT 
    COUNT(*) AS total_diabetic_heart_patients,
    ROUND(AVG(age), 2) AS avg_age,
    ROUND(AVG(children), 2) AS avg_children,
    ROUND(AVG(BMI), 2) AS avg_bmi,
    ROUND(AVG(charges), 2) AS avg_hospitalization_cost,
    ROUND(MIN(charges), 2) AS min_cost,
    ROUND(MAX(charges), 2) AS max_cost
FROM healthcare_data
WHERE HBA1C > 6.5 
  AND heart_issues = 1;

-- Expected Output: Summary statistics for high-risk diabetic patients


-- =====================================================================
-- QUERY 2: Average Hospitalization Cost by Hospital & City Tier
-- =====================================================================
-- Find the average hospitalization cost for each hospital tier and city level

SELECT 
    hospital_tier,
    city_tier,
    COUNT(*) AS patient_count,
    ROUND(AVG(charges), 2) AS avg_cost,
    ROUND(MIN(charges), 2) AS min_cost,
    ROUND(MAX(charges), 2) AS max_cost,
    ROUND(STDDEV(charges), 2) AS std_dev
FROM healthcare_data
GROUP BY hospital_tier, city_tier
ORDER BY hospital_tier, city_tier;

-- Expected Output: Cost breakdown by tier combinations


-- =====================================================================
-- QUERY 3: Patients with Major Surgery AND Cancer History
-- =====================================================================
-- Count of people who have undergone major surgery and have cancer history

SELECT 
    COUNT(*) AS surgery_cancer_count,
    ROUND(AVG(charges), 2) AS avg_cost,
    ROUND(AVG(age), 2) AS avg_age,
    SUM(CASE WHEN heart_issues = 1 THEN 1 ELSE 0 END) AS with_heart_issues,
    SUM(CASE WHEN smoker = 1 THEN 1 ELSE 0 END) AS smokers
FROM healthcare_data
WHERE num_major_surgeries > 0 
  AND cancer_history = 1;

-- Expected Output: High-risk patient statistics


-- =====================================================================
-- QUERY 4: Tier-1 Hospitals per State
-- =====================================================================
-- Find the number of tier-1 hospital patients for each state

SELECT 
    state_id,
    COUNT(*) AS tier1_patient_count,
    ROUND(AVG(charges), 2) AS avg_cost_tier1,
    ROUND(AVG(age), 2) AS avg_age
FROM healthcare_data
WHERE hospital_tier = 'tier - 1'
GROUP BY state_id
ORDER BY tier1_patient_count DESC;

-- Expected Output: State-wise distribution of tier-1 hospital patients


-- =====================================================================
-- ADDITIONAL ANALYSIS QUERIES
-- =====================================================================

-- QUERY 5: Smoker vs Non-Smoker Cost Comparison
SELECT 
    CASE 
        WHEN smoker = 1 THEN 'Smoker'
        ELSE 'Non-Smoker'
    END AS smoking_status,
    COUNT(*) AS patient_count,
    ROUND(AVG(charges), 2) AS avg_cost,
    ROUND(STDDEV(charges), 2) AS std_dev,
    ROUND(MIN(charges), 2) AS min_cost,
    ROUND(MAX(charges), 2) AS max_cost
FROM healthcare_data
GROUP BY smoker
ORDER BY avg_cost DESC;


-- QUERY 6: Gender-wise Cost Analysis
SELECT 
    gender,
    COUNT(*) AS patient_count,
    ROUND(AVG(charges), 2) AS avg_cost,
    ROUND(AVG(age), 2) AS avg_age,
    ROUND(AVG(BMI), 2) AS avg_bmi
FROM healthcare_data
WHERE gender IN ('Male', 'Female')
GROUP BY gender
ORDER BY avg_cost DESC;


-- QUERY 7: High-Risk Patients (Multiple Conditions)
SELECT 
    customer_id,
    name,
    age,
    charges,
    CASE 
        WHEN smoker = 1 THEN 'Yes' ELSE 'No'
    END AS is_smoker,
    CASE 
        WHEN heart_issues = 1 THEN 'Yes' ELSE 'No'
    END AS has_heart_issues,
    CASE 
        WHEN cancer_history = 1 THEN 'Yes' ELSE 'No'
    END AS has_cancer_history,
    num_major_surgeries,
    hospital_tier
FROM healthcare_data
WHERE smoker = 1 
  AND heart_issues = 1 
  AND cancer_history = 1
ORDER BY charges DESC
LIMIT 10;


-- QUERY 8: Cost Distribution by Age Groups
SELECT 
    CASE 
        WHEN age < 30 THEN '< 30'
        WHEN age BETWEEN 30 AND 40 THEN '30-40'
        WHEN age BETWEEN 41 AND 50 THEN '41-50'
        WHEN age BETWEEN 51 AND 60 THEN '51-60'
        ELSE '> 60'
    END AS age_group,
    COUNT(*) AS patient_count,
    ROUND(AVG(charges), 2) AS avg_cost,
    ROUND(AVG(BMI), 2) AS avg_bmi,
    ROUND(AVG(HBA1C), 2) AS avg_hba1c
FROM healthcare_data
GROUP BY age_group
ORDER BY age_group;


-- QUERY 9: Top 10 Most Expensive Cases
SELECT 
    customer_id,
    name,
    age,
    gender,
    charges,
    hospital_tier,
    city_tier,
    CASE WHEN smoker = 1 THEN 'Yes' ELSE 'No' END AS smoker,
    CASE WHEN heart_issues = 1 THEN 'Yes' ELSE 'No' END AS heart_issues,
    num_major_surgeries
FROM healthcare_data
ORDER BY charges DESC
LIMIT 10;


-- QUERY 10: Hospital Tier Performance Metrics
SELECT 
    hospital_tier,
    COUNT(*) AS total_patients,
    ROUND(AVG(charges), 2) AS avg_cost,
    ROUND(STDDEV(charges), 2) AS std_dev_cost,
    ROUND(MIN(charges), 2) AS min_cost,
    ROUND(MAX(charges), 2) AS max_cost,
    ROUND(AVG(age), 2) AS avg_patient_age,
    SUM(CASE WHEN smoker = 1 THEN 1 ELSE 0 END) AS smoker_count,
    SUM(CASE WHEN heart_issues = 1 THEN 1 ELSE 0 END) AS heart_issue_count
FROM healthcare_data
GROUP BY hospital_tier
ORDER BY hospital_tier;


-- =====================================================================
-- PRIMARY KEY DEFINITION
-- =====================================================================
-- Add primary key to the merged table

ALTER TABLE healthcare_data
ADD PRIMARY KEY (customer_id);

-- Note: Ensure customer_id is unique before adding primary key


-- =====================================================================
-- CREATE INDEXES FOR BETTER QUERY PERFORMANCE
-- =====================================================================

CREATE INDEX idx_hospital_tier ON healthcare_data(hospital_tier);
CREATE INDEX idx_city_tier ON healthcare_data(city_tier);
CREATE INDEX idx_state_id ON healthcare_data(state_id);
CREATE INDEX idx_smoker ON healthcare_data(smoker);
CREATE INDEX idx_heart_issues ON healthcare_data(heart_issues);
CREATE INDEX idx_charges ON healthcare_data(charges);


-- =====================================================================
-- END OF SQL QUERIES
-- =====================================================================
