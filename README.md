# The SQL Murder Mystery

A crime has taken place and the detective needs your help. The detective gave you the crime scene report, but you somehow lost it. You vaguely remember that the crime was a murder that occurred sometime on Jan.15, 2018 and that it took place in SQL City. All the clues to this mystery are buried in a huge database, and you need to use SQL to navigate through this vast network of information. Your first step to solving the mystery is to retrieve the corresponding crime scene report from the police department’s database!

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
|id	|name|	license_id	|address_number	|address_street_name	|ssn|
|-----|----|----|----|---|
|14887|Morty Schapiro|118009	|4919	|Northwestern Dr	|111564949

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


