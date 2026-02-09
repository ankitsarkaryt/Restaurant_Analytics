USE RESTAURANT_ANALYTICS_DB;
USE SCHEMA SEMANTIC;


 CREATE OR REPLACE TABLE RESTAURANT_ANALYTICS_DB.SEMANTIC.RAG_CONTEXT (
    DOC_ID        STRING,
    DOC_TYPE      STRING,
    DOC_SOURCE    STRING,
    CONTENT       STRING,
    CREATED_AT    TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

INSERT INTO RESTAURANT_ANALYTICS_DB.SEMANTIC.RAG_CONTEXT (DOC_ID, DOC_TYPE, DOC_SOURCE, CONTENT)
VALUES
(
  'DOC_001',
  'BUSINESS_DEFINITION',
  'HLD',
  'Revenue is calculated as the sum of NET_AMOUNT from completed orders. NET_AMOUNT already accounts for quantity, unit price, and discounts.'
),
(
  'DOC_002',
  'BUSINESS_DEFINITION',
  'HLD',
  'Average Order Value (AOV) is defined as total revenue divided by the number of distinct orders.'
),
(
  'DOC_003',
  'DIMENSION_LOGIC',
  'DATA_MODEL',
  'The semantic model is based on the dynamic table SEMANTIC.DT_ORDER_ANALYTICS, which joins fact orders with date, restaurant, customer, and menu item dimensions.'
),
(
  'DOC_004',
  'FILTER_LOGIC',
  'HLD',
  'Date filters should always use DATE_VALUE from the date dimension. All time-based analysis must rely on DATE_VALUE.'
),
(
  'DOC_005',
  'FILTER_LOGIC',
  'HLD',
  'Region-level analysis should use the REGION column from the restaurant dimension.'
),
(
  'DOC_006',
  'BUSINESS_RULE',
  'OPERATIONS',
  'Only current records from customer and menu item dimensions are included, based on IS_CURRENT = TRUE.'
),
(
  'DOC_007',
  'BUSINESS_RULE',
  'PRICING',
  'Discount percentage represents promotional discounts applied at order line level.'
),
(
  'DOC_008',
  'ANALYTICS_GUIDE',
  'REPORTING',
  'When analyzing menu performance, revenue contribution should be aggregated by ITEM_NAME and CUISINE.'
),
(
  'DOC_009',
  'ANALYTICS_GUIDE',
  'REPORTING',
  'Restaurant performance analysis typically focuses on revenue, order count, and regional comparison.'
),
(
  'DOC_010',
  'DATA_GOVERNANCE',
  'POLICY',
  'All analytics queries must be restricted to the semantic layer and should not directly query raw or staging tables.'
);


USE ROLE ACCOUNTADMIN;

-- Allow Snowflake to route inference to any supported region if the model isn't local
ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'ANY_REGION';


SELECT SNOWFLAKE.CORTEX.COMPLETE(
  'mistral-large',
  'What is Snowflake?'
) AS reply;


SELECT * FROM RESTAURANT_ANALYTICS_DB.SEMANTIC.DOCS_REPOSITORY;

SELECT * FROM RESTAURANT_ANALYTICS_DB.SEMANTIC.DT_ORDER_ANALYTICS;
SELECT * FROM RESTAURANT_ANALYTICS_DB.SEMANTIC.RAG_CONTEXT;


