create database Public_HI;
use public_hi;
select * from public_housing_inspection_data;

DROP table  if exists date_inspection_change;

CREATE TABLE date_inspection_change AS SELECT inspection_id,
    STR_TO_DATE(inspection_date, '%m/%d/%Y') AS inspection_date FROM
    public_housing_inspection_data;
    
DROP table if exists Inspection;

CREATE TABLE Inspection AS SELECT public_housing_inspection_data.inspection_id,
    public_housing_agency_name,
    cost_of_inspection_in_dollars,
    public_housing_inspection_data.inspection_date FROM
    public_housing_inspection_data
        LEFT JOIN
    date_inspection_change ON public_housing_inspection_data.inspection_id = date_inspection_change.inspection_id;
    
    
select * from Public_HI_1;
CREATE TABLE Public_HI_1 AS 
SELECT public_housing_agency_name, cost_of_inspection_in_dollars , inspection_date , row_number()
OVER(PARTITION BY public_housing_agency_name ORDER BY inspection_date DESC) AS flag,
LEAD(inspection_date) 
OVER (PARTITION BY public_housing_agency_name ORDER BY inspection_date DESC) AS SECOND_MR_INSPECTION_DATE,
LEAD(cost_of_inspection_in_dollars) 
OVER (PARTITION BY public_housing_agency_name ORDER BY  public_housing_agency_name, inspection_date DESC) AS SECOND_MR_INSPECTION_COST,
cost_of_inspection_in_dollars - (LEAD(cost_of_inspection_in_dollars) 
OVER (PARTITION BY public_housing_agency_name ORDER BY inspection_date DESC)) AS CHANGE_IN_COST,
ROUND((((cost_of_inspection_in_dollars - (LEAD(cost_of_inspection_in_dollars) OVER (PARTITION BY public_housing_agency_name ORDER BY inspection_date DESC)))/
(LEAD(cost_of_inspection_in_dollars) OVER (PARTITION BY public_housing_agency_name ORDER BY inspection_date DESC)))*100),2) AS PERCENT_CHANGE_IN_COST 
FROM Inspection;

SELECT * FROM Public_HI_1;

DROP TABLE IF EXISTS Public_HI_2;
CREATE TABLE Public_HI_2 AS
SELECT public_housing_agency_name AS PHA_NAME, inspection_date AS MR_INSPECTION_DATE,SECOND_MR_INSPECTION_DATE, COST_OF_INSPECTION_IN_DOLLARS AS MR_INSPECTION_COST,
SECOND_MR_INSPECTION_COST, CHANGE_IN_COST, PERCENT_CHANGE_IN_COST FROM A
WHERE flag = 1 AND PERCENT_CHANGE_IN_COST > 0;

select * from Public_HI_2;






    

    
        
 




