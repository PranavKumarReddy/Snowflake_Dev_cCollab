--CREATING STORAGE INTEGRATION FOR ADLS
CREATE OR REPLACE STORAGE INTEGRATION azure_integration
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = AZURE
AZURE_TENANT_ID = 'afa9610e-f35a-47a9-b0b5-1334222eb336'
STORAGE_ALLOWED_LOCATIONS = ('azure://edpdevfdlinboundgateway.blob.core.windows.net/test/')
ENABLED = TRUE;

--TESRTING TO CHECK THE INTEGRATION
DESC STORAGE INTEGRATION azure_integration


--CREATING SNOWFLAKE TABLE 
CREATE OR REPLACE TABLE testdb.public.Patient_Data (
    Patient_Id STRING, 
    Patient_Admission_Date DATE, 
    Patient_First_Initial CHAR(1), 
    Patient_Last_Name STRING, 
    Patient_Gender STRING, 
    Patient_Age INTEGER, 
    Patient_Race STRING, 
    Department_Referral STRING, 
    Patient_Admission_Flag BOOLEAN, 
    Patient_Satisfaction_Score DECIMAL(5, 2), 
    Patient_Waittime INTEGER, 
    Patients_CM INTEGER
);

--CREATING FILE FORMAT
CREATE OR REPLACE FILE FORMAT testdb.public.my_csv
TYPE = CSV FIELD_DELIMITER = ',' SKIP_HEADER = 1;

--CREATING STAGE OBJECT TO GET DATA/FILES FROM
CREATE OR REPLACE STAGE testdb.public.my_azure_stage
STORAGE_INTEGRATION = azure_integration
URL = 'azure://edpdevfdlinboundgateway.blob.core.windows.net/test/HospitalData.csv'
FILE_FORMAT = testdb.public.my_csv;

--CHECKING THE SOURCE DATA, HERE $1 INDICATES 1ST COLUMN ADND SIMILARLY WE CAN SEE OTHER COLUMNS AS WELL
SELECT $1 FROM @testdb.public.my_azure_stage

--USING COPY COMMAND AND LOADING INTO SNOWFLAKE
COPY INTO testdb.public.Patient_Data
from @testdb.public.my_azure_stage

