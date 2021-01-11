-- Create the demo database
USE ROLE SYSADMIN;
CREATE DATABASE KAFKA_S3_SNOWPIPE_DEMO_DB;

-- Create storage integration
CREATE OR REPLACE STORAGE INTEGRATION KAFKA_S3_SNOWPIPE_DEMO_INT
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = S3
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN = 'iam-role'
STORAGE_ALLOWED_LOCATIONS = ('s3://entechlog-demo/kafka-snowpipe-demo/');

-- Describe Integration and retrieve the AWS IAM User (STORAGE_AWS_IAM_USER_ARN and STORAGE_AWS_EXTERNAL_ID) for Snowflake Account
DESC INTEGRATION KAFKA_S3_SNOWPIPE_DEMO_INT;

-- Grant the IAM user permissions to access S3 Bucket. See blog for details on this

-- Create file format for incoming files
CREATE OR REPLACE FILE FORMAT KAFKA_S3_SNOWPIPE_DEMO_FILE_FORMAT
TYPE = JSON COMPRESSION = AUTO TRIM_SPACE = TRUE NULL_IF = ('NULL', 'NULL');

-- Create state for incoming files. Update `URL` with s3 bucket details
CREATE OR REPLACE STAGE KAFKA_S3_SNOWPIPE_DEMO_STAGE
STORAGE_INTEGRATION = KAFKA_S3_SNOWPIPE_DEMO_INT
URL = 's3://entechlog-demo/kafka-snowpipe-demo/'
FILE_FORMAT = KAFKA_S3_SNOWPIPE_DEMO_FILE_FORMAT;

-- Create target table for JSON data
CREATE OR REPLACE TABLE KAFKA_S3_SNOWPIPE_DEMO_RAW (
         "event" VARIANT
);

-- Describe table
DESC TABLE KAFKA_S3_SNOWPIPE_DEMO_RAW;

-- Create snowpipe to ingest data from `STAGE` to `TABLE`
CREATE
	OR REPLACE PIPE KAFKA_S3_SNOWPIPE_DEMO_DB.PUBLIC.KAFKA_S3_SNOWPIPE_DEMO_SNOWPIPE AUTO_INGEST = TRUE AS COPY
INTO KAFKA_S3_SNOWPIPE_DEMO_DB.PUBLIC.KAFKA_S3_SNOWPIPE_DEMO_RAW
FROM @KAFKA_S3_SNOWPIPE_DEMO_DB.PUBLIC.KAFKA_S3_SNOWPIPE_DEMO_STAGE;

-- Describe snowpipe and copy the ARN for notification_channel	
SHOW PIPES LIKE '%KAFKA_S3_SNOWPIPE_DEMO_SNOWPIPE%';

-- Validate data in snowflake
SELECT * FROM KAFKA_S3_SNOWPIPE_DEMO_DB.PUBLIC.KAFKA_S3_SNOWPIPE_DEMO_RAW;

-- Pause pipe
ALTER PIPE KAFKA_S3_SNOWPIPE_DEMO_DB.PUBLIC.KAFKA_S3_SNOWPIPE_DEMO_SNOWPIPE
SET PIPE_EXECUTION_PAUSED = TRUE;

-- Truncate table before reloading
TRUNCATE TABLE KAFKA_S3_SNOWPIPE_DEMO_DB.PUBLIC.KAFKA_S3_SNOWPIPE_DEMO_RAW;

-- Set pipe for refresh
ALTER PIPE KAFKA_S3_SNOWPIPE_DEMO_DB.PUBLIC.KAFKA_S3_SNOWPIPE_DEMO_SNOWPIPE REFRESH;
