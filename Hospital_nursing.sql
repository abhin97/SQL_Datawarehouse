SELECT * FROM hospital.bed_fact;

use hospital;
select * from hospital.bed_type;
select * from hospital.business;
select * from hospital.bed_fact;

/*Step 4a: Analysis for Leadership Part 1 */
SELECT 
    business_name AS hospital_Name,
    SUM(license_beds) AS total_license_beds
FROM
    bed_fact
        INNER JOIN
    business ON bed_fact.ims_org_id = business.ims_org_id
WHERE
    bed_fact.bed_id = 4
        OR bed_fact.bed_id = 15
GROUP BY business_name
ORDER BY SUM(license_beds) DESC
LIMIT 10;

/* Part2*/
SELECT 
    business_name AS hospital_Name,
    SUM(census_beds) AS total_census_beds
FROM
    bed_fact
        INNER JOIN
    business ON bed_fact.ims_org_id = business.ims_org_id
WHERE
    bed_fact.bed_id = 4
        OR bed_fact.bed_id = 15
GROUP BY business_name
ORDER BY SUM(census_beds) DESC
LIMIT 10;

/* Part 3*/
SELECT 
    business_name AS Hospital_Name,
    SUM(staffed_beds) AS total_staffed_beds
FROM
    bed_fact
        INNER JOIN
    business ON bed_fact.ims_org_id = business.ims_org_id
WHERE
    bed_fact.bed_id = 4
        OR bed_fact.bed_id = 15
GROUP BY business_name
ORDER BY SUM(staffed_beds) DESC
LIMIT 10;

/*5a */
SELECT 
    bf.ims_org_id, SUM(bf.license_beds) as Sufficient_volumn
FROM
    bed_fact bf
        JOIN
    (SELECT 
        ims_org_id, COUNT(*)
    FROM
        bed_fact
    WHERE
        bed_id IN (4 , 15)
    GROUP BY ims_org_id
    HAVING COUNT(*) = 2) a ON a.ims_org_id = bf.ims_org_id
GROUP BY bf.ims_org_id
ORDER BY SUM(bf.license_beds) DESC
LIMIT 10; 