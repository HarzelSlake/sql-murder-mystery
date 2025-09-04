# The SQL Murder Mystery

A crime has taken place and the detective needs your help. The detective gave you the crime scene report, but you somehow lost it. You vaguely remember that the crime was a murder that occurred sometime on Jan.15, 2018 and that it took place in SQL City. All the clues to this mystery are buried in a huge database, and you need to use SQL to navigate through this vast network of information.

## 1. Search for Murder in SQL City on January 15, 2018
```sql
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
```
**Result:**
| date      | type   | description                                                                                                                                                                              | city     |
|-----------|--------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|
| 20180115  | murder	| Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". The second witness, named Annabel, lives somewhere on "Franklin Ave".| SQL City |

## 2. Extract information about the witnesses
```sql
-- Query to gather data about the first witness 
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
```
**Result:**
|id    |name          |license_id|address_number|address_street_name|ssn      |
|----- |--------------|----------|--------------|-------------------|---------|
|14887 |Morty Schapiro|118009	   |4919	         |Northwestern Dr    |111564949|

```sql
-- Query to gather data about the second witness
SELECT
    *
FROM
    person
WHERE
    name LIKE 'Annabel%'
    AND address_street_name = 'Franklin Ave';
```
**Result:**
|id   |name	         |license_id|address_number|address_street_name|ssn      |
|-----|--------------|----------|--------------|-------------------|---------|
|16371|Annabel Miller|490173    |103	        |Franklin Ave       |318771143|

## 3. What does the witnesses have to say?
```sql
-- Let's take a look of what our witnesses said during the interview
-- Morty Schapiro id: 14887
-- Annabel Miller id: 16371
SELECT
    *
FROM
    interview
WHERE
    person_id IN (14887, 16371);
```
**Result:**
|person_id| transcript                                                                                                                                                                                                                      |
|---------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|14887    |I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". Only gold members have those bags. The man got into a car with a plate that included "H42W".  |
|16371	 |I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.                                                                                                            |

## 4. Query the clues and find two suspects for the murder
```sql
SELECT
    *
FROM
    get_fit_now_member
WHERE
    membership_status = 'gold'
    AND id LIKE '48Z%';-- Two suspects: Joe Germuska and Jeremy Bowers
```
**Result:**
|id    |person_id|	name	      |membership_start_date|membership_status|
|---|---|---|---|---|
|48Z7A |28819	 |Joe Germuska	|20160305	          |gold|
|48Z55 |67318	 |Jeremy Bowers|	20160101	          |gold|

## 5. What does these two people had say during the interview?
```sql
-- Let's look back at the interviews table. It turns out that Jeremy Bowers is the murderer.
SELECT
    *
FROM
    interview
WHERE
    person_id IN (SELECT id FROM person
                  WHERE name IN ('Joe Germuska','Jeremy Bowers'));
```
**Result:**
|person_id|transcript|
|---|---|
|67318|I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017.|

**GREAT!** We found that person_id 67318, **Jeremy Bowers** is the murderer!
But it seems that Jeremy isn't the mastermind of this murder. A mysterious woman who we need to catch. Another mystery emerged!

## 6. Query information using the clues given by the murderer to find the mastermind. Store it as a view.
```sql
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
```
**Result:**
|id|	age	|height|	eye_color|	hair_color|	gender|	plate_number	|car_make	|car_model|
|---|---|---|---|---|---|---|---|---|
|202298|	68|	66|	green	|red|	female|	500123|	Tesla	|Model S|
|291182	|65	|66	|blue|	red	|female|	08CM64	|Tesla	|Model S|
|918773	|48	|65	|black|	red	|female|	917UU3|	Tesla|	Model S|


## 7. Query information using the last clue: She attends SQL Symphony Concert 3 times in December 2017
```sql
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
```
**Result:**
|person_id|attendance_count|
|---|---|
|24556|3|
|99716|3|

## 8. Find the mastermind by matching the results from #6 and #7
```sql
-- Find the license_id of these two person and see if any of them matches the id
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
```
**Result:**
|license_id|
|---|
|202298|

## 9. The mastermind behind the murder.
```sql
-- The woman behind the murder is:
SELECT
    *
FROM
    person
WHERE
    license_id = 202298;
```
**Result:**
|id|	name|	license_id|	address_number|address_street_name|	ssn|
|---|---|---|---|---|---|
|99716|	Miranda Priestly	|202298|	1883|	Golden Ave|	987756388|

Therefore, the mastermind behind murder is: **Miranda Priestly** ... evil woman!
