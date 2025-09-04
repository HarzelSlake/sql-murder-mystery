# The SQL Murder Mystery

A crime has taken place and the detective needs your help. The detective gave you the crime scene report, but you somehow lost it. You vaguely remember that the crime was a murder that occurred sometime on Jan.15, 2018 and that it took place in SQL City. All the clues to this mystery are buried in a huge database, and you need to use SQL to navigate through this vast network of information. Your first step to solving the mystery is to retrieve the corresponding crime scene report from the police department’s database. Take a look at the cheatsheet to learn how to do this! From there, you can use your SQL skills to find the murderer.

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
```
