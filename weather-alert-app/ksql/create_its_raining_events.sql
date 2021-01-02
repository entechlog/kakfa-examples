SET 'auto.offset.reset' = 'earliest';

-- Create RAW table
CREATE TABLE TBL_WEATHER_ALERT_APP_0010_RAW (ROWKEY VARCHAR PRIMARY KEY)
	WITH (
			KAFKA_TOPIC = 'weather.alert.app.source',
			VALUE_FORMAT = 'AVRO'
			);

-- Filter rainy days 
CREATE TABLE TBL_WEATHER_ALERT_APP_0020_RAIN_IS_HERE_TMP
	WITH (
			KAFKA_TOPIC = 'TBL_WEATHER_ALERT_APP_0020_RAIN_IS_HERE_TMP',
			VALUE_FORMAT = 'json'
			) AS
SELECT ROWKEY,
	CURRENT -> DT AS CURRENT_DT_TIME,
	CURRENT -> TEMP AS CURRENT_TEMP,
	CURRENT -> WEATHER [1] -> DESCRIPTION AS CURRENT_WEATHER_DESC
FROM TBL_WEATHER_ALERT_APP_0010_RAW EMIT CHANGES;

-- Filter out tombstone records, This is a bug in ksql which is generating tombstone
CREATE TABLE TBL_WEATHER_ALERT_APP_0020_RAIN_IS_HERE
	WITH (
			KAFKA_TOPIC = 'TBL_WEATHER_ALERT_APP_0020_RAIN_IS_HERE',
			VALUE_FORMAT = 'json'
			) AS
SELECT *
FROM TBL_WEATHER_ALERT_APP_0020_RAIN_IS_HERE_TMP
WHERE CURRENT_WEATHER_DESC IS NOT NULL EMIT CHANGES;
--WHERE UCASE(CURRENT_WEATHER_DESC) LIKE '%RAIN%' EMIT CHANGES;