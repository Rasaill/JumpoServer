WITH ParsedData AS (
    -- Extract environment, service_type, and number from the account name
    SELECT
        name AS ServiceAccount,
        SUBSTRING(name, CHARINDEX('_', name) + 1, 1) AS Environment,  -- Extract 'd', 'q', 'p'
        SUBSTRING(name, CHARINDEX('_', name, CHARINDEX('_', name) + 1) + 1, 2) AS ServiceType, -- Extract 'is', 'ft', etc.
        RIGHT(name, 4) AS Number -- Extract the 4-digit number
    FROM
        YourTable
),
ExpectedCombinations AS (
    -- Define all expected combinations of service_type
    SELECT DISTINCT
        Environment,
        Number,
        ServiceType
    FROM ParsedData
    CROSS APPLY (VALUES ('is'), ('ft'), ('sa'), ('sb'), ('sq')) AS Expected(ServiceType)
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
        ON e.Environment = p.Environment
        AND e.Number = p.Number
        AND e.ServiceType = p.ServiceType
    WHERE
        p.ServiceType IS NULL
)
-- Output missing groups or confirm all present
SELECT 
    Environment,
    Number,
    ServiceType,
    CASE WHEN EXISTS (SELECT 1 FROM MissingAccounts WHERE Environment = m.Environment AND Number = m.Number)
        THEN 'Missing'
        ELSE 'Complete'
    END AS Status
FROM
    ExpectedCombinations m
ORDER BY
    Environment, Number, ServiceType;
