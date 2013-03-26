\connect "RPL_2012"


-- File: RPL_Test_Data.sql
-- Purpose: Deletes all data from database and fills with some test data, runs test queries
-- Author: Adam Shortall
-- Date: 12/4/11

DROP FUNCTION IF EXISTS fn_ShowPassword(text); -- Purely for testing purposes, shows password of created user
CREATE OR REPLACE FUNCTION fn_ShowPassword(text) returns void as
$BODY$
BEGIN
	RAISE NOTICE 'Password: %', $1;
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

-- Delete all data in database to fill with test data
DELETE FROM "Assessor";
DELETE FROM "Campus";
DELETE FROM "CampusDiscipline";
DELETE FROM "CampusDisciplineCourse";
DELETE FROM "Claim";
DELETE FROM "ClaimedModule";
DELETE FROM "ClaimedModuleProvider";
DELETE FROM "Core";
DELETE FROM "Course";
DELETE FROM "Criterion";
DELETE FROM "Delegate";
DELETE FROM "Discipline";
DELETE FROM "Elective";
DELETE FROM "Element";
DELETE FROM "Evidence";
DELETE FROM "Module";
DELETE FROM "Provider";
DELETE FROM "Student";
DELETE FROM "Teacher";
DELETE FROM "User";

-- Create campuses, disciplines, courses
SELECT fn_InsertCampus('001', 'Ourimbah');
SELECT fn_InsertCampus('002', 'Wyong');

-- Insert two disciplines into Ourimbah campus
SELECT fn_InsertDiscipline(1, 'Information Technology', '001');
SELECT fn_InsertDiscipline(2, 'Business', '001');
-- Now assign those disciplines to Wyong campus as well
SELECT fn_AssignDiscipline('002', 1);
SELECT fn_AssignDiscipline('002', 2);

-- Insert courses into Ourimbah campus
SELECT fn_InsertCourse('19003', 'Certificate III in Information Technology (Network Administration)', '001', 1);
SELECT fn_InsertCourse('19010', 'Certificate IV in Information Technology (Programming)', '001', 1);
SELECT fn_InsertCourse('19018', 'Diploma in Information Technology (Software Development)', '001', 1);
SELECT fn_InsertCourse('17804', 'Certificate IV Business', '001', 2);
-- Assign courses to Wyong campus
SELECT fn_AssignCourse('19003', 1, '002');
SELECT fn_AssignCourse('19010', 1, '002');
SELECT fn_AssignCourse('19018', 1, '002');
SELECT fn_AssignCourse('17804', 2, '002');

-- Now Delegates and Assessors are inserted
SELECT fn_InsertDelegate('deb.spindler', 'deb', 'spindler', 'deb.spindler@tafensw.edu.au', 1, '001');
SELECT fn_AssignDelegate('deb.spindler', 1, '002');

SELECT fn_InsertDelegate('kim.king6', 'kim', 'king', 'kim.king6@tafensw.edu.au', 2, '001');
SELECT fn_AssignDelegate('kim.king6', 2, '002');

SELECT fn_InsertAssessor('steve.etherington', 'steve', 'etherington', 'steve.etherington@tafensw.edu.au', 1, '001', '19003', true);
SELECT fn_AssignAssessor('steve.etherington', 1, '001', '19010', true);
SELECT fn_AssignAssessor('steve.etherington', 1, '001', '19018', true);

SELECT fn_AssignAssessor('kim.king6', 2, '002', '17804', false);

-- Now entering Modules for the courses
SELECT fn_InsertModule('BSBOHS407A', 'Monitor a safe workplace', 'C:\\guides\\BSBOHS407A.docx');
SELECT fn_InsertModule('BSBADM405B', 'Organise Meetings', 'C:\\guides\\BSBADM405B.docx');
SELECT fn_InsertModule('ICAB5223B', 'Apply intermediate object-oriented language skills', 'C:\\guides\\ICAB5223B.docx');
SELECT fn_InsertModule('ICAB5068B', 'Build using rapid application development', 'C:\\guides\\ICAB5068B.docx');

-- Now assign core module to the Cert IV Business course:
SELECT fn_AssignCore('BSBOHS407A', '17804');
-- and elective:
SELECT fn_AssignElective('BSBADM405B', '17804', 2, '002');

-- Now the same for 19018:
SELECT fn_AssignCore('ICAB5068B', '19018');
SELECT fn_AssignElective('ICAB5068B', '19018', 1, '001');

-- Now create a student account
SELECT fn_InsertStudent('355878635', 'Adam', 'Shortall', 'adam.shortall@tafensw.net.au', md5('myPassword')::bytea);

-- This returns a randomly generated text password, application MUST use this return value to create the email to be sent to the user
SELECT fn_ShowPassword(fn_InsertClerical('clerical.person'));

-- Insert elements for modules
SELECT fn_InsertElement(1, 'BSBOHS407A', 'Provide information to the workgroup about OHS policies and procedures');
SELECT fn_InsertElement(2, 'BSBOHS407A', 'Implement and monitor participative arrangements for the management of OHS');

-- and criteria for the elements
SELECT fn_InsertCriterion(1, 1, 'BSBOHS407A', 'Accurately explain relevant provisions of OHS legislation and codes of practice to the workgroup.');
SELECT fn_InsertCriterion(2, 1, 'BSBOHS407A', 'Provide information to the workgroup on the orgainsation''s OHS policies, procedures and programs, ensuring it is readily accessible by the workgroup.');
SELECT fn_InsertCriterion(1, 2, 'BSBOHS407A', 'Explain the importance of effective consultative mechanisms in managing health and safety risks.');
SELECT fn_InsertCriterion(2, 2, 'BSBOHS407A', 'Implement and monitor consultative procedures to facilitate participation of workgroup in management of work area hazards.');

-- Create previous provider codes:
SELECT fn_InsertProvider('1', 'University');
SELECT fn_InsertProvider('2', 'Adult and Community Education');
SELECT fn_InsertProvider('3', 'School');
SELECT fn_InsertProvider('4', 'TAFE NSW');
SELECT fn_InsertProvider('5', 'Other VET provider');
SELECT fn_InsertProvider('6', 'Non-formal/other');

-- Now the student makes an initial claim
SELECT fn_InsertClaim(1,'355878635',true,'19003','001',1,null);