WITH ParsedData AS (
    -- Extract environment and number from the service account name
    SELECT
        ServiceAccountName,
        serviceAccountType,
        CASE 
            WHEN Environment = 'DEV' THEN 'd'
            WHEN Environment = 'PRD' THEN 'p'
            WHEN Environment = 'QA' THEN 'q'
            ELSE NULL
        END AS EnvironmentMapped, -- Map 'DEV', 'PRD', 'QA' to 'd', 'p', 'q'
        RIGHT(ServiceAccountName, 4) AS Number, -- Extract the 4-digit number
        CASE 
            WHEN serviceAccountType = 'Agent' THEN 'sa'
            WHEN serviceAccountType = 'Browser' THEN 'sb'
            WHEN serviceAccountType = 'SSIS' THEN 'is'
            WHEN serviceAccountType = 'FullText' THEN 'ft'
            WHEN serviceAccountType = 'Engine' THEN 'sq'
            ELSE NULL
        END AS ServiceTypeMapped -- Map serviceAccountType to corresponding type
    FROM
        YourTable
),
ExpectedCombinations AS (
    -- Define all expected combinations of environment, number, and service type
    SELECT DISTINCT
        p.EnvironmentMapped AS Environment,
        p.Number,
        t.ServiceTypeMapped AS ServiceType
    FROM 
        ParsedData p
    CROSS APPLY (VALUES ('sa'), ('sb'), ('is'), ('ft'), ('sq')) AS t(ServiceTypeMapped)
),
MissingAccounts AS (
    -- Find missing combinations by comparing actual and expected
    SELECT
        e.Environment,
        e.Number,
        e.ServiceType
    FROM
        ExpectedCombinations e
    LEFT JOIN ParsedData p
        ON e.Environment = p.EnvironmentMapped
        AND e.Number = p.Number
        AND e.ServiceType = p.ServiceTypeMapped
    WHERE
        p.ServiceTypeMapped IS NULL
)
-- Final output: Check for missing service types
SELECT 
    Environment,
    Number,
    ServiceType,
    CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM MissingAccounts 
            WHERE Environment = ec.Environment 
              AND Number = ec.Number
        )
        THEN 'Missing'
        ELSE 'Complete'
    END AS Status
FROM
    ExpectedCombinations ec
ORDER BY
    Environment, Number, ServiceType;
