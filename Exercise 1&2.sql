USE EmpSample_#OK;
GO

select *from tblEmployees;

---1. Employees with a One-Part Name
SELECT *
FROM dbo.tblEmployees
WHERE Name NOT LIKE '% %';

---2. Employees with a Three-Part Name
SELECT *
FROM dbo.tblEmployees
WHERE LEN(Name) - LEN(REPLACE(Name, ' ', '')) = 2;

---3. Employees whose Full Name is ONLY 'Ram'
select emp.Name
from dbo.tblEmployees emp
where emp.Name like 'ram[ ]%' or emp.Name like '%[ ]ram' or emp.Name like '%[. ]ram[ ]%';

---4. Bitwise Operation
--4.1

select emp.EmployeeNumber, emp.Name, emp.CentreCode
from dbo.tblEmployees emp
where emp.CentreCode = 65 or emp.CentreCode = 11;

--4.2

select COUNT(*)
from dbo.tblEmployees emp
where (emp.CategoryCode = 65 and emp.CentreCode <> 11) or ((emp.CategoryCode <> 65 and emp.CentreCode = 11));
  
  --OR

select COUNT(*)
from tblEmployees emp
where (emp.CategoryCode = 65 or emp.CentreCode = 11) and ((emp.CategoryCode <> 65 and emp.CentreCode <> 11));  

--4.3

select emp.EmployeeNumber, emp.Name, emp.CentreCode, emp.CategoryCode
from tblEmployees emp
where emp.CategoryCode = 12 and emp.CentreCode = 4;

--4.4

select emp.EmployeeNumber, emp.Name, emp.CentreCode, emp.CategoryCode
from dbo.tblEmployees emp
where (emp.CategoryCode=12 and emp.CentreCode=4)or (emp.CategoryCode=13 and emp.CentreCode=1);

--4.5

select emp.EmployeeNumber, emp.Name
from dbo.tblEmployees emp
where emp.EmployeeNumber = 127 or emp.EmployeeNumber = 64;

--4.6

select emp.EmployeeNumber,emp.Name
from dbo.tblEmployees emp
where (emp.CategoryCode = 127 and emp.CentreCode <> 64) or ((emp.CategoryCode <> 127 and emp.CentreCode = 64));

--4.7

select emp.EmployeeNumber,emp.Name
from dbo.tblEmployees emp
where (emp.CategoryCode = 127 and emp.CentreCode <> 128) or ((emp.CategoryCode <> 127 and emp.CentreCode = 128));

--4.8

select emp.EmployeeNumber, emp.Name
from dbo.tblEmployees emp
where emp.EmployeeNumber = 127 and emp.AreaCode = 64;

--4.9

select emp.EmployeeNumber, emp.Name
from dbo.tblEmployees emp
where emp.EmployeeNumber = 127 and emp.AreaCode = 128;

---All Data from dbo.tblCentreMaster
SELECT * FROM dbo.tblCentreMaster;

---6. List of Unique Employee Types
SELECT DISTINCT EmployeeType
FROM dbo.tblEmployees

---7. Query: Name, FatherName, DOB of employees based on PresentBasic
---a. Greater than 3000
SELECT Name, FatherName, DOB
FROM dbo.tblEmployees
WHERE PresentBasic > 3000;

---b. Less than 3000
SELECT Name, FatherName, DOB
FROM dbo.tblEmployees
WHERE PresentBasic < 3000;

---c. Between 3000 and 5000 (inclusive)
SELECT Name, FatherName, DOB
FROM dbo.tblEmployees
WHERE PresentBasic BETWEEN 3000 AND 5000;

--- 8. Query: All details of employees based on Name
---a. Ends with 'KHAN'
SELECT *
FROM dbo.tblEmployees
WHERE Name LIKE '%KHAN';

---b. Starts with 'CHANDRA'
SELECT *
FROM dbo.tblEmployees
WHERE Name LIKE 'CHANDRA%';

---c. Name is 'RAMESH' and initial is between A–T
SELECT *
FROM dbo.tblEmployees
WHERE Name LIKE '[A-T].RAMESH';

--------------------------------------Exercise 2--------------------------
 ---1. Total PresentBasic by DepartmentCode > 30000, sorted
 SELECT DepartmentCode, SUM(PresentBasic) AS TotalPresentBasic
FROM dbo.tblEmployees
GROUP BY DepartmentCode
HAVING SUM(PresentBasic) > 30000
ORDER BY DepartmentCode;

---2. Max, Min, Avg Age (in Years & Months) by ServiceType, ServiceStatus, CentreCode
select emp.CentreCode,emp.ServiceType,emp.ServiceStatus,
CONVERT(varchar(10),MAX(DATEDIFF(MM,EMP.DOB,GETDATE())/12))+'years '+
CONVERT(varchar(10),MAX(DATEDIFF(MM,EMP.DOB,GETDATE())%12))+'months' as MAX_AGE,
CONVERT(varchar(10),MIN(DATEDIFF(MM,EMP.DOB,GETDATE())/12))+'years '+
CONVERT(varchar(10),MIN(DATEDIFF(MM,EMP.DOB,GETDATE())%12))+'months' as MIN_AGE,            
CONVERT(varchar(10),AVG(DATEDIFF(MM,EMP.DOB,GETDATE())/12))+'years '+
CONVERT(varchar(10),AVG(DATEDIFF(MM,EMP.DOB,GETDATE())%12))+'months' as AVG_AGE
from dbo.tblEmployees emp
group by emp.CentreCode,emp.ServiceType,emp.ServiceStatus
order by emp.CentreCode,emp.ServiceType,emp.ServiceStatus;

--- 3. Max, Min, Avg Service by ServiceType, ServiceStatus, CentreCode (in Years & Months)
SELECT 
  CentreCode,
  ServiceType,
  ServiceStatus,
  MAX(DATEDIFF(MONTH, DOJ, GETDATE()) / 12) AS MaxServiceYears,
  MIN(DATEDIFF(MONTH, DOJ, GETDATE()) / 12) AS MinServiceYears,
  AVG(DATEDIFF(MONTH, DOJ, GETDATE())) / 12.0 AS AvgServiceYears
FROM dbo.tblEmployees
GROUP BY CentreCode, ServiceType, ServiceStatus;

---4. Departments where Total Salary > 3 × Avg Salary
SELECT DepartmentCode
FROM dbo.tblEmployees
GROUP BY DepartmentCode
HAVING SUM(PresentBasic) > 3 * AVG(PresentBasic);

---5. Departments where Total Salary > 2 × Avg AND Max >= 3 × Min
SELECT DepartmentCode
FROM dbo.tblEmployees
GROUP BY DepartmentCode
HAVING 
  SUM(PresentBasic) > 2 * AVG(PresentBasic) AND
  MAX(PresentBasic) >= 3 * MIN(PresentBasic);

---6. Centers where Max Name Length ? 2 × Min Name Length
 SELECT CentreCode
FROM dbo.tblEmployees
GROUP BY CentreCode
HAVING MAX(LEN(Name)) >= 2 * MIN(LEN(Name));

---7. Max, Min, Avg Service in Milliseconds by Centre, ServiceType, Status
select emp.CentreCode,emp.ServiceType,emp.ServiceStatus,            
MAX(DATEDIFF(HH,emp.DOJ,GETDATE())) as MAX_SEVICE ,                        
MIN(DATEDIFF(HH,emp.DOJ,GETDATE())) as MIN_SEVICE,            
AVG(DATEDIFF(HH,emp.DOJ,GETDATE())) as AVG_SEVICE            
from dbo.tblEmployees emp
group by emp.CentreCode,emp.ServiceType,emp.ServiceStatus
order by emp.CentreCode,emp.ServiceType,emp.ServiceStatus; 

---8. Employees with Leading or Trailing Spaces in Name
select emp.Name
from dbo.tblEmployees emp
where emp.Name like '[ ]%' or emp.Name like '%[ ]';

---9. Employees with More Than One Space Between Name Parts
select emp.Name  
from dbo.tblEmployees emp
where emp.Name like '%[a-z]%[ ][ ]%[a-z]%';  -- Two consecutive spaces

---10. Cleaned-up Employee Names (Trim + Single Space Only)
select LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(emp.Name,'.',' '),' ',' %'),'% ',''),'%','') )) as Name                           
from dbo.tblEmployees emp
order by emp.Name;

---11. Max Number of Words in Employee Names
select DummyTable.FormatedName,LEN(DummyTable.FormatedName)-LEN(REPLACE(DummyTable.FormatedName,' ',''))+1
from 
    (
        select LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(emp.Name,'.',' '),' ',' %'),'% ',''),'%','') )) FormatedName                            
        from dbo.tblEmployees emp
    )DummyTable

---12.Names That Start and End With Same Character
SELECT DummyTable.FormatedName as Name
FROM (
               select LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(emp.Name,'.',' '),' ',' %'),'% ',''),'%','') )) FormatedName                            
               from dbo.tblEmployees emp
            )DummyTable
WHERE LEFT(DummyTable.FormatedName,1)=RIGHT(DummyTable.FormatedName,1);  

---13.First and Second Word Start With Same Character
SELECT *
FROM (
        select LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(emp.Name,'.',' '),' ',' %'),'% ',''),'%','') )) FormatedName                            
        from dbo.tblEmployees emp
      )DummyTable  
where LEFT(DummyTable.FormatedName,1)=SUBSTRING(DummyTable.FormatedName,PATINDEX('%[ ]%',DummyTable.FormatedName)+1,1)        
       AND DummyTable.FormatedName LIKE '%[A-Z]%[ ][A-Z]%';

---14. All Words in Name Start With Same Character
SELECT *
FROM (
        select LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(emp.Name,'.',' '),' ',' %'),'% ',''),'%','') )) FormatedName                            
        from dbo.tblEmployees emp
    )DummyTable 
    
WHERE lEFT(DummyTable.FormatedName,1)= SUBSTRING(DummyTable.FormatedName,PATINDEX('%[ ][A-Z]%',DummyTable.FormatedName)+1,1) AND     
   lEFT(DummyTable.FormatedName,1)= SUBSTRING(DummyTable.FormatedName,CHARINDEX(' ',DummyTable.FormatedName,CHARINDEX(' ',DummyTable.FormatedName)+1)+1,1)AND
   lEFT(DummyTable.FormatedName,1)= SUBSTRING(DummyTable.FormatedName,CHARINDEX(' ',DummyTable.FormatedName,CHARINDEX(' ',DummyTable.FormatedName,CHARINDEX(' ',DummyTable.FormatedName)+1)+1)+1,1)
   AND
   DummyTable.FormatedName LIKE '%[A-Z]%[ ][A-Z]%'  

---15.Any Word (Excl. Initials) Starts and Ends With Same Character
SELECT DummyTable.S      
      FROM (
               select LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(emp.Name,'.',' '),' ',' %'),'% ',''),'%','') )) S
               from dbo.tblEmployees emp
           )DummyTable             
      WHERE ( LEN(SUBSTRING(DummyTable.S,1,PATINDEX('%[ ]%',DummyTable.S)))>4 AND
              LEFT(DummyTable.S,1)= LEFT(REVERSE(SUBSTRING(DummyTable.S,1,PATINDEX('%[ ]%',DummyTable.S)-1)),1) )                 
               OR              
             (LEN(DummyTable.S)-LEN(REPLACE(DummyTable.S,' ',''))+1 = 2 AND LEFT(SUBSTRING(DummyTable.S, (CHARINDEX(' ',DummyTable.S)+1) ,LEN(DummyTable.S)-CHARINDEX(' ',DummyTable.S)),1) =   LEFT(REVERSE(SUBSTRING(DummyTable.S, (CHARINDEX(' ',DummyTable.S)+1) ,LEN(DummyTable.S)-CHARINDEX(' ',DummyTable.S))),1)   )             
             OR             
              ( LEN(DummyTable.S)-LEN(REPLACE(DummyTable.S,' ',''))+1 = 3 AND LEFT(SUBSTRING(DummyTable.S, (CHARINDEX(' ',DummyTable.S,CHARINDEX(' ',DummyTable.S)+1)+1) ,LEN(DummyTable.S)-CHARINDEX(' ',DummyTable.S,CHARINDEX(' ',DummyTable.S)+1)),1)=LEFT(REVERSE(SUBSTRING(DummyTable.S, (CHARINDEX(' ',DummyTable.S,CHARINDEX(' ',DummyTable.S)+1)+1) ,LEN(DummyTable.S)-CHARINDEX(' ',DummyTable.S,CHARINDEX(' ',DummyTable.S)+1))),1)   ) 

---16. Employees Whose PresentBasic is Rounded to 100
---a) Using ROUND:
SELECT Name, PresentBasic
FROM dbo.tblEmployees
WHERE ROUND(PresentBasic, -2) = PresentBasic;

---b) Using FLOOR:
SELECT Name, PresentBasic
FROM dbo.tblEmployees
WHERE FLOOR(PresentBasic / 100.0) * 100 = PresentBasic;

---c) Using MOD:
SELECT Name, PresentBasic
FROM dbo.tblEmployees
WHERE PresentBasic % 100 = 0;

---d)Using CEILING:
SELECT Name, PresentBasic
FROM dbo.tblEmployees
WHERE CEILING(PresentBasic / 100.0) * 100 = PresentBasic;

---17.Departments Where ALL Employees Have Salary Rounded to 100
SELECT DepartmentCode
FROM dbo.tblEmployees
GROUP BY DepartmentCode
HAVING MIN(PresentBasic % 100) = 0;

---18.Departments Where NO Employee Has Salary Rounded to 100
SELECT DepartmentCode
FROM dbo.tblEmployees
GROUP BY DepartmentCode
HAVING MAX(PresentBasic % 100) <> 0;

---19.As per the companies rule if an employee has put up service of  1 Year 3 Months and 15 days in office, Then He/She would be eligible for  Bonus. the Bonus would be Paid on first of the Next month after which  a person has attained eligibility.  Find out the eligibility date for all the employees. And also find out the age of the  Employee On the date of Payment of First bonus. Display the  Age in Years, Months and Days.  Also Display the week day Name , week of the year , Day of the year and  week of the month of the date on which the person has attained the eligibility. 
select emp.Name,emp.DOB, emp.DOJ DateOfJoining, 
DATEADD(DAY,15,DATEADD(MONTH,3,DATEADD(YEAR,1,emp.DOJ))) as EligibleDate,
DATEADD(MONTH,1,DATEADD(DAY,-(DATEPART(dd,DATEADD(DAY,15,DATEADD(MONTH,3,DATEADD(YEAR,1,emp.DOJ))))-1),DATEADD(DAY,15,DATEADD(MONTH,3,DATEADD(YEAR,1,emp.DOJ)))))As BonusDate,
CONVERT(varchar(max),(DATEDIFF(MONTH,emp.DOB,DATEADD(MONTH,1,DATEADD(DAY,-(DATEPART(dd,DATEADD(DAY,15,DATEADD(MONTH,3,DATEADD(YEAR,1,emp.DOJ))))-1),DATEADD(DAY,15,DATEADD(MONTH,3,DATEADD(YEAR,1,emp.DOJ))))))/12))+' years '+
CONVERT(varchar(max),(DATEDIFF(MONTH,emp.DOB,DATEADD(MONTH,1,DATEADD(DAY,-(DATEPART(dd,DATEADD(DAY,15,DATEADD(MONTH,3,DATEADD(YEAR,1,emp.DOJ))))-1),DATEADD(DAY,15,DATEADD(MONTH,3,DATEADD(YEAR,1,emp.DOJ))))))%12))+' Months',
DATENAME(dw,DATEADD(DAY,15,DATEADD(MONTH,3,DATEADD(YEAR,1,emp.DOJ))))As WeekDayName,
DATENAME(Wk,DATEADD(DAY,15,DATEADD(MONTH,3,DATEADD(YEAR,1,emp.DOJ))))As WeekOfYear,
DATENAME(dy,DATEADD(DAY,15,DATEADD(MONTH,3,DATEADD(YEAR,1,emp.DOJ))))As DayOfYears,
(DATENAME(DD,DATEADD(DAY,15,DATEADD(MONTH,3,DATEADD(YEAR,1,emp.DOJ))))/7)+1 As WeekOfMonth         
from dbo.tblEmployees emp

---20.Query 20: Bonus Eligibility Based on ServiceType, EmployeeType & Retirement Rules
--1
select emp.CentreCode,emp.ServiceType,emp.EmployeeType,
CONVERT(varchar(10),(DATEDIFF(MM,EMP.DOJ,GETDATE())/12))+' years '+
CONVERT(varchar(10),(DATEDIFF(MM,EMP.DOJ,GETDATE())%12))+' months' as MIN_SERVICE,            
CONVERT(varchar(10),(DATEDIFF(MM,EMP.DOB,GETDATE())/12))+' years '+
CONVERT(varchar(10),(DATEDIFF(MM,EMP.DOB,GETDATE())%12))+' months' as MIN_AGE                       
from dbo.tblEmployees emp   
where emp.ServiceType=1 AND emp.EmployeeType=1 AND (DATEDIFF(MM,EMP.DOJ,GETDATE())/12)>=10 AND CONVERT(int,(DATEDIFF(MM,GETDATE(),emp.RetirementDate)/12))>=15 AND DATEDIFF(YEAR,emp.DOB,emp.RetirementDate)>=60 

---2. 
select emp.CentreCode,emp.ServiceType,emp.EmployeeType,
CONVERT(varchar(10),(DATEDIFF(MM,EMP.DOJ,GETDATE())/12))+' years '+
CONVERT(varchar(10),(DATEDIFF(MM,EMP.DOJ,GETDATE())%12))+' months' as MIN_SERVICE,            
CONVERT(varchar(10),(DATEDIFF(MM,EMP.DOB,GETDATE())/12))+' years '+
CONVERT(varchar(10),(DATEDIFF(MM,EMP.DOB,GETDATE())%12))+' months' as MIN_AGE                       
from dbo.tblEmployees emp   
where emp.ServiceType=1 AND emp.EmployeeType=2 AND (DATEDIFF(MM,EMP.DOJ,GETDATE())/12)>=12 AND CONVERT(int,(DATEDIFF(MM,GETDATE(),emp.RetirementDate)/12))>=14 AND DATEDIFF(YEAR,emp.DOB,emp.RetirementDate)>=55

---3.
select emp.CentreCode,emp.ServiceType,emp.EmployeeType,
CONVERT(varchar(10),(DATEDIFF(MM,EMP.DOJ,GETDATE())/12))+' years '+
CONVERT(varchar(10),(DATEDIFF(MM,EMP.DOJ,GETDATE())%12))+' months' as MIN_SERVICE,            
CONVERT(varchar(10),(DATEDIFF(MM,EMP.DOB,GETDATE())/12))+' years '+
CONVERT(varchar(10),(DATEDIFF(MM,EMP.DOB,GETDATE())%12))+' months' as MIN_AGE                       
from dbo.tblEmployees emp   
where emp.ServiceType=1 AND emp.EmployeeType=3 AND (DATEDIFF(MM,EMP.DOJ,GETDATE())/12)>=12 AND CONVERT(int,(DATEDIFF(MM,GETDATE(),emp.RetirementDate)/12))>=12 AND DATEDIFF(YEAR,emp.DOB,emp.RetirementDate)>=55

-----4.

select emp.CentreCode,emp.ServiceType,emp.EmployeeType,
CONVERT(varchar(10),(DATEDIFF(MM,EMP.DOJ,GETDATE())/12))+' years '+
CONVERT(varchar(10),(DATEDIFF(MM,EMP.DOJ,GETDATE())%12))+' months' as MIN_SERVICE,            
CONVERT(varchar(10),(DATEDIFF(MM,EMP.DOB,GETDATE())/12))+' years '+
CONVERT(varchar(10),(DATEDIFF(MM,EMP.DOB,GETDATE())%12))+' months' as MIN_AGE                       
from dbo.tblEmployees emp   
where (emp.ServiceType=2 OR emp.ServiceType=2 OR emp.ServiceType=4) AND (DATEDIFF(MM,EMP.DOJ,GETDATE())/12)>=15 AND CONVERT(int,(DATEDIFF(MM,GETDATE(),emp.RetirementDate)/12))>=20 AND DATEDIFF(YEAR,emp.DOB,emp.RetirementDate)>=65


-----21.
SELECT CONVERT(VARCHAR(12),GETDATE(), 103)  -- 25/11/2011
SELECT CONVERT(VARCHAR(12),GETDATE(), 105)  -- 25-11-2011
SELECT CONVERT(VARCHAR(12),GETDATE(), 104)  -- 25.11.2011
SELECT CONVERT(VARCHAR(12),GETDATE(), 106)  -- 25 Nov 2011
 SELECT CONVERT(VARCHAR(12),GETDATE(), 101)  -- 11/25/2011
SELECT CONVERT(VARCHAR(12),GETDATE(), 110)  -- 11-25-2011
SELECT CONVERT(VARCHAR(12),GETDATE(), 100)  -- Nov 25 2011
SELECT CONVERT(VARCHAR(12),GETDATE(), 107)  -- Nov 25, 2011
SELECT CONVERT(VARCHAR(12),GETDATE(), 102)  -- 2011.11.25
SELECT CONVERT(VARCHAR(12),GETDATE(), 111)  -- 2011/11/25
SELECT CONVERT(VARCHAR(12),GETDATE(), 112)  -- 20111125 

--22. Query 22: Identify Payments Where NetPay < Expected Basic Pay
SELECT emp.EmployeeNumber,
SUM(CASE WHEN emp.TransValue=1 THEN emp.ActualAmount else -emp.ActualAmount END) As ActualSalary,
SUM(CASE WHEN emp.TransValue=1 THEN emp.Amount else -emp.Amount END)As NetSalary
FROM dbo.tblPayEmployeeparamDetails emp
GROUP BY emp.EmployeeNumber,emp.NoteNumber
having SUM(CASE WHEN emp.TransValue=1 THEN emp.ActualAmount else -emp.ActualAmount END) > SUM(CASE WHEN emp.TransValue=1 THEN emp.Amount else -emp.Amount END)
order by emp.EmployeeNumber


































