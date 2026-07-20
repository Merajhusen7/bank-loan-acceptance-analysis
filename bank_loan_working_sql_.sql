CREATE TABLE bank_loan (
    id INTEGER PRIMARY KEY,
    age INTEGER,
    experience_fixed INTEGER,
    experience INTEGER,
    income INTEGER,
    zip_code INTEGER,
    family INTEGER,
    ccavg NUMERIC(5,2),
    education INTEGER,
    mortgage INTEGER,
    personal_loan INTEGER,
    securities_account INTEGER,
    cd_account INTEGER,
    online INTEGER,
    credit_card INTEGER
);

SELECT COUNT(*)
FROM bank_loan

SELECT *
FROM bank_loan
LIMIT 10


-- Acceptance rate by Education
SELECT 
    education,
    COUNT(*) AS total_customers,
    SUM(personal_loan) AS accepted_loan,
    ROUND(AVG(personal_loan::numeric) * 100, 2) AS acceptance_rate_pct
FROM bank_loan
GROUP BY education
ORDER BY education;

SELECT *
FROM bank_loan


SELECT
     COUNT (*) AS total_customers,
     education,
	 SUM (personal_loan) AS accepted_loan,
	 ROUND(AVG(personal_loan) * 100, 2) AS accepted_rate_percent

FROM bank_loan
GROUP BY education
ORDER BY education 




-- Acceptance rate by CD Account
SELECT 
    cd_account,
    COUNT(*) AS total_customers,
    ROUND(AVG(personal_loan::numeric) * 100, 2) AS acceptance_rate_pct
FROM bank_loan
GROUP BY cd_account;



-- Acceptance rate by Family size

SELECT 
    family,
	COUNT (*) AS total_customer, 
	SUM(personal_loan),
	ROUND(AVG(personal_loan),2) AS loan_percent
	
FROM bank_loan
GROUP BY family
ORDER BY family;

-- OR

SELECT 
    family,
    COUNT(*) AS total_customers,
    ROUND(AVG(personal_loan::numeric) * 100, 2) AS acceptance_rate_pct
FROM bank_loan
GROUP BY family
ORDER BY family;


--2. Income buckets using CASE WHEN

SELECT *
FROM bank_loan

SELECT     
	   CASE
		      WHEN income < 50 THEN '0-50K'
			  WHEN income < 100 THEN '50-100K'
			  WHEN income < 150 THEN '100-150K'
			  WHEN income < 200 THEN '150K-200K'
			  ELSE  '200+k'
	    END AS Income_bracket,
		COUNT (*) AS total_customer,
		ROUND(AVG(personal_loan::numeric) * 100, 2)	AS acceptance_rate_percent	
FROM bank_loan
GROUP BY Income_bracket
ORDER BY MIN(income);


/* 
This lets you answer: "Who are the top 5 credit card spenders within each education level?"
— something a simple GROUP BY can't do, since GROUP BY collapses rows;
window functions let you rank while keeping every individual row visible.
*/



SELECT *
FROM (
			SELECT 
			    education,
			    ccavg,
			    ROW_NUMBER() OVER (
			        PARTITION BY education
			        ORDER BY ccavg DESC
			    ) AS rank
			FROM bank_loan
		) ranked
WHERE rank <= 5
ORDER BY education, rank;



--a combined segment

-- Income bracket x CD Account combined
SELECT 
    CASE 
        WHEN income < 100 THEN 'Under 100K'
        ELSE '100K+'
    END AS income_group,
    cd_account,
    COUNT(*) AS total_customers,
    ROUND(AVG(personal_loan::numeric) * 100, 2) AS acceptance_rate_pct
FROM bank_loan
GROUP BY income_group, cd_account
ORDER BY income_group, cd_account;

