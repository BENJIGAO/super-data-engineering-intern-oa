/*

Solution: Writing a standard SQL query that transforms the data from the 'data' table into a new table 'airline_data' according to the requirements

Assumptions:
- The table 'data' already exists as a table with the column names and values specified in the prompt
- The given column names and row values are valid and won't trigger any errors (e.g., 'Airline Code', 'DelayTimes', 'FlightCodes', 'To_From')
- Standard SQL syntax will be used and won't cause any errors, as the specific SQL syntax wasn't specified in the prompt
- The new table with name 'airline_data' isn't already taken so the new table can be created without any issues
- The 'Airline Code' column name was incorrectly spaced (compared to the other columns), so the correct column name should be 'AirlineCode'
- For the third requirement, numbers should be removed as well (e.g., "<Air France> (12)" and "12. Air France" should both be transformed to "Air France")

*/

-- `airline_data` is the new table that contains the transformed data
CREATE TABLE airline_data AS

    -- requirement #1: flight codes with null values are replaced with the correct codes that are +10 of the previous code
    WITH flight_codes_adjusted AS (
        SELECT
            "Airline Code",
            "DelayTimes",
            CAST(COALESCE("FlightCodes", LAG("FlightCodes") OVER () + 10) AS INTEGER) AS "FlightCodes",
            "To_From"
        FROM data
    ),
    
    -- requirement #2: the "To_From" column is split into a "To" and "From" column
    to_from_columns_added AS (
        SELECT
            "Airline Code",
            "DelayTimes",
            "FlightCodes",
            UPPER(split_part("To_From", '_', 1)) AS "To",
            UPPER(split_part("To_From", '_', 2)) AS "From"
        FROM flight_codes_adjusted
    ),
    
    -- requirement #3: airline codes are cleaned to have no punctuation/numbers except the middle space
    airline_code_cleaned AS (
        SELECT
            TRIM(' ' FROM REGEXP_REPLACE("Airline Code", '[^a-zA-Z]', ' ', 'g')) AS "AirlineCode",
            "DelayTimes",
            "FlightCodes",
            "To",
            "From"
        FROM to_from_columns_added
    )
    
    -- putting everything together
    SELECT * FROM airline_code_cleaned;
