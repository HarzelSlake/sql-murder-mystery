-- SQLite

-- First Clue: The crime was a murder and occured on Jan. 15, 2018 in SQL City.
SELECT
    *
FROM
    crime_scene_report
WHERE
    date = 20180115
    AND type = 'murder'
    AND city = 'SQL City';

-- The description shows that there were 2 witnesses.
-- First witness lives at the last house on Northwestern Dr
-- The second is named Annabel who lives somewhere on Franklin Ave

-- Query to gather data about the first witness: Morty Schapiro - 
SELECT
    *
FROM
    person
WHERE
    address_street_name = 'Northwestern Dr'
ORDER BY
    address_number DESC
LIMIT
    1;

-- Query to gather data about the second witness: Annabel Miller
SELECT
    *
FROM
    person
WHERE
    name LIKE 'Annabel%'
    AND address_street_name = 'Franklin Ave';

-- Let's take a look of what our witnesses said during the interview
-- Morty Schapiro id: 14887
-- Annabel Miller id: 16371
SELECT
    *
FROM
    interview
WHERE
    person_id IN (14887, 16371);

-- Clues found:
-- 1. Murderer is a male who had a 'Get Fit Now Gym' and his membership number on
-- the bag starts with '48Z'. Only gold members have those bag. Then got into
-- a car with a plate that included 'H42W'.
-- 2. Murderer was present in the gym on January 9th. 
SELECT
    *
FROM
    get_fit_now_member
WHERE
    membership_status = 'gold'
    AND id LIKE '48Z%';-- Two suspects: Joe Germuska and Jeremy Bowers

-- Let's look back at the interviews table. It turns out that Jeremy Bowers is the murderer.
SELECT
    *
FROM
    interview
WHERE
    person_id IN (SELECT id FROM person
                  WHERE name IN ('Joe Germuska','Jeremy Bowers'));

-- Jeremy stated that he was hired by a woman with a lot of money
-- Height: 5'5'' (65'') or 5'7'' (67'')
-- Red hair
-- Drives a Tesla Model S
-- Attended SQL Symphony Concert 3 times in December 2017. 

CREATE VIEW drivers_license_info AS
SELECT
    *
FROM
    drivers_license
WHERE
    gender = 'female'
    AND hair_color = 'red'
    AND car_make = 'Tesla'
    AND car_model = 'Model S'
    AND height BETWEEN 65 AND 67; -- Three person satistfies all these condition.


-- We utilize the last clue where the woman attends SQL Symphony Concert 3 times in December 2017
SELECT
    person_id, COUNT(person_id) AS attendance_count
FROM
    facebook_event_checkin
WHERE
    event_name = 'SQL Symphony Concert'
    AND date LIKE '201712%'
GROUP BY
    person_id
HAVING
    attendance_count = 3; -- Two people satisfy these conditions: person_id 24556 and 99716

-- Let's take a look at these two people's data.
SELECT
    license_id
FROM
    person
WHERE
    id IN (24556, 99716)

INTERSECT

SELECT
    id
FROM
    drivers_license_info; -- This returns the license_id 202298, the license_id that attended
-- the SQL Symphony Concert 3 times and satisfies the information given by the murderer.

-- Therefore, the woman behind the murder is: Miranda Priestly.
SELECT
    *
FROM
    person
WHERE
    license_id = 202298;

-- INSERT this information to the solution table
INSERT INTO solution (person_id, name)
VALUES
    (202298, 'Miranda Priestly');
