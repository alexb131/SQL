--What are the conferences?
SELECT
  DISTINCT conf_name
FROM
  `bigquery-public-data.ncaa_basketball.mbb_teams`;

--How many teams are in each conference?
--Which conference has the most teams?
SELECT
  conf_name,
  COUNT(*) AS teams_in_conf
FROM
  `bigquery-public-data.ncaa_basketball.mbb_teams`
GROUP BY
  conf_name
ORDER BY
  teams_in_conf DESC;

--For the conference with the most teams, which ones are they?
SELECT
  turner_name
FROM
  `bigquery-public-data.ncaa_basketball.mbb_teams`
WHERE
  conf_name = "Atlantic Coast"
ORDER BY
  turner_name;

--How many teams in each state?
--Which state has the most teams?
SELECT
  venue_state,
  COUNT(*) AS num_of_teams_in_state
FROM
  `bigquery-public-data.ncaa_basketball.mbb_teams`
GROUP BY
  venue_state
ORDER BY
  num_of_teams_in_state DESC;

--For the state with the most teams, which ones are they?
SELECT
  turner_name
FROM
  `bigquery-public-data.ncaa_basketball.mbb_teams`
WHERE
  venue_state = "CA"
ORDER BY
  turner_name;

--What are the top 10 venues in terms of capacity?
SELECT
  turner_name,
  venue_name,
  venue_capacity
FROM
  `bigquery-public-data.ncaa_basketball.mbb_teams`
ORDER BY
  venue_capacity DESC
LIMIT
  10;

--What's the biggest venue in each conference?
SELECT
  conf_name,
  MAX(venue_capacity)
FROM
  `bigquery-public-data.ncaa_basketball.mbb_teams`
GROUP BY
  conf_name
ORDER BY
  conf_name;
--Doesn't include turner_name and venue_name

SELECT
  conf_name,
  turner_name,
  venue_name,
  venue_capacity
FROM
  `bigquery-public-data.ncaa_basketball.mbb_teams`
WHERE
  venue_capacity = (
  SELECT
    MAX(venue_capacity)
  FROM
    `bigquery-public-data.ncaa_basketball.mbb_teams`);
--Only gives the overall biggest venue

--Trying with temp table
WITH
  biggest_venues AS (
  SELECT
    conf_name,
    MAX(venue_capacity) AS biggest_venue_capacity
  FROM
    `bigquery-public-data.ncaa_basketball.mbb_teams`
  GROUP BY
    conf_name
  ORDER BY
    conf_name)

SELECT
  teams.conf_name,
  teams.turner_name,
  teams.venue_name,
  biggest_venues.biggest_venue_capacity
FROM
  biggest_venues
INNER JOIN
  `bigquery-public-data.ncaa_basketball.mbb_teams` AS teams
ON
  biggest_venues.biggest_venue_capacity = teams.venue_capacity
  AND biggest_venues.conf_name = teams.conf_name
ORDER BY
  conf_name;
--Using temp table worked
