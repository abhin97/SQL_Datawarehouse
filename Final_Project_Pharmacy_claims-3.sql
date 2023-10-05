create database Pharmacy_claims;

use pharmacy_claims;


/* Assign primay key to all fact and dimension tables*/
select * from dim_drug_code;
Alter table dim_drug_code add column drug_code_desc_id int auto_increment primary key;

select * from dim_drug_name;
Alter table dim_drug_name add primary key (drug_ndc);

select * from dim_drug_info;
alter table dim_drug_info add primary key (drug_brand_generic_code);

select * from dim_member_info;
alter table dim_member_info add primary key (member_id);


select * from fact_copay;
Alter table fact_copay add column fact_id int auto_increment primary key;

/* Assign Foreign key*/

Alter table fact_copay
add foreign key dim_drug_name_id_drug_ndc(drug_ndc)	
References dim_drug_name(drug_ndc)
on delete cascade
on update cascade;

Alter table fact_copay
add foreign key dim_drug_code_drug_code_desc_id(drug_code_desc_id)	
References dim_drug_code(drug_code_desc_id)
on delete cascade
on update cascade;

Alter table fact_copay
add foreign key dim_drug_info_drug_brand_generic_code(drug_brand_generic_code)	
References dim_drug_info(drug_brand_generic_code)
on delete cascade
on update cascade;

Alter table fact_copay
add foreign key dim_member_info_member_id(member_id)	
References dim_member_info(member_id)
on delete cascade
on update cascade;

/* Part4: Analytics and Reporting*/

/*identifies the number of prescriptions grouped by drug name*/
SELECT 
    dn.drug_name, COUNT(member_id) AS prescriptions
FROM
    fact_copay AS fc,
    dim_drug_name AS dn
WHERE
    fc.drug_ndc = dn.drug_ndc
GROUP BY dn.drug_ndc
order by prescriptions desc;

/* No of prescriptions were filled for the drug Ambien*/
SELECT 
    COUNT(member_id) AS prescriptions
FROM
    fact_copay AS fc
WHERE
    drug_ndc IN (SELECT 
            drug_ndc
        FROM
            dim_drug_name
        WHERE
            drug_name = 'Ambien');

/*-	Write a SQL query that counts total prescriptions, 
counts unique (i.e. distinct) members, 
sums copay $$, and sums insurance paid $$, 
for members grouped as either ‘age 65+’ or ’ < 65’. 
Use case statement logic to develop this query similar to lecture 3. 
Paste your output in the space below here; your code should be included in your .sql file.*/

select count(fc.drug_ndc) as total_prescriptions,
count( distinct fc.member_id) as total_members,
sum(fc.copay) as total_insurancepay,
CASE
when MI.member_age>65 then "member age above 65"
when MI.member_age<65 then "member age below 65"
end as age_category
from fact_copay fc left join dim_member_info MI
on fc.member_id = MI.member_id
group by age_category;


#Finding unique members are over 65 years of age? 
SELECT member_id,count(DISTINCT member_id) AS unique_members 
FROM A1 
WHERE member_age > 65;

#Prescriptions Filled?
SELECT COUNT( member_id) AS total_prescription
FROM A1 WHERE member_age <  65;
SELECT COUNT( member_id) AS total_prescription
FROM A1 WHERE member_age >  65;

/*Part4-Ques 3*/

DROP TABLE IF EXISTS A1;
CREATE TABLE A1 AS SELECT fc.member_id,
    fc.drug_ndc,
    pi.member_first_name,
    pi.member_last_name,
    fc.fill_date,
    fc.copay,
    fc.insurancepaid FROM
    fact_copay AS fc
        LEFT JOIN
    dim_member_info AS pi ON fc.member_id = pi.member_id;

SELECT 
    *
FROM
    A1;
# Join drug_name Table
DROP TABLE IF EXISTS A2;
CREATE TABLE A2 AS

SELECT 
    fc.member_id,
    fc.drug_ndc,
    dc.drug_name,
    fc.member_first_name,
    fc.member_last_name,
    fc.fill_date,
    fc.copay,
    fc.insurancepaid
FROM
    A1 AS fc
        LEFT JOIN
    dim_drug_name AS dc ON fc.drug_ndc = dc.drug_ndc;

SELECT 
    *
FROM
    A2;
DROP TABLE IF EXISTS fact_copay_formatted_Date;
CREATE TABLE fact_copay_formatted_Date AS

SELECT 
    member_id,
    member_first_name,
    member_last_name,
    drug_ndc,
    drug_name,
    copay,
    insurancepaid,
    fill_date,
    STR_TO_DATE(fill_date, '%m/%d/%Y') AS fill_date_formatted
FROM
    A2;

SELECT 
    member_id,
    member_first_name,
    member_last_name,
    drug_ndc,
    drug_name,
    copay,
    insurancepaid,
    fill_date,
    STR_TO_DATE(fill_date, '%m/%d/%Y') AS fill_date_formatted
FROM
    A2;
SELECT 
    *
FROM
    fact_copay_formatted_Date;
USE pharmacy_claims;
DROP TABLE IF EXISTS A3;
CREATE TABLE A3 AS
SELECT  member_id, member_first_name, member_last_name, drug_name, fill_date, fill_date_formatted AS MR_fill_date,
 LEAD(fill_date_formatted) OVER(PARTITION BY member_first_name 
ORDER BY member_first_name,fill_date_formatted DESC)
AS SECOND_MR_Filled_DATE, insurancepaid  AS MR_insurance_paid,
LEAD(insurancepaid) OVER(PARTITION BY member_first_name 
ORDER BY member_first_name,fill_date_formatted DESC)
AS SECOND_MR_insurance_paid
FROM fact_copay_formatted_Date 
GROUP BY fill_date_formatted;

ALTER TABLE A3
DROP COLUMN SECOND_MR_Filled_DATE,
DROP COLUMN SECOND_MR_insurance_paid;

#For member ID 10003, what was the drug name listed on their most recent fill date?
SELECT 
    drug_name
FROM
    A3
WHERE
    member_id = '10003'
GROUP BY drug_name;  

#How much did their insurance pay for that medication?    
SELECT 
    MR_insurance_paid
FROM
    A3
WHERE
    member_id = '10003'
GROUP BY drug_name; 


