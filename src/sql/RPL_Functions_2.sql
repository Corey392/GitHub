\connect "RPL_2012"

DROP FUNCTION public.fn_verifylogin("userID" text, password bytea);
DROP FUNCTION public.fn_submitclaim(claimid integer, studentid text);
DROP FUNCTION public.fn_showpassword(text);
DROP FUNCTION public.fn_insertuser(text, bytea, character);
DROP FUNCTION public.fn_insertuser("userID" text, role text);
DROP FUNCTION public.fn_insertuser("userID" text, role character);
DROP FUNCTION public.fn_insertteacher("teacherID" text, "firstName" text, "lastName" text, email text);
DROP FUNCTION public.fn_insertstudent("studentID" text, "firstName" text, "lastName" text, email text, password bytea);
DROP FUNCTION public.fn_insertprovider("providerID" character, name text);
DROP FUNCTION public.fn_insertmodule(text, text, text);
DROP FUNCTION public.fn_insertevidence("studentID" text, "claimID" integer, "elementID" integer, description text, "moduleID" text);
DROP FUNCTION public.fn_insertelement("elementID" integer, "moduleID" text, description text);
DROP FUNCTION public.fn_insertdiscipline("disciplineID" integer, name text);
DROP FUNCTION public.fn_insertdelegate("teacherID" text, "firstName" text, "lastName" text, email text, "disciplineID" integer, "campusID" text);
DROP FUNCTION public.fn_insertcriterion("criterionID" integer, "elementID" integer, "moduleID" text, description text);
DROP FUNCTION public.fn_insertcourse("courseID" text, name text);
DROP FUNCTION public.fn_insertclerical("userID" text);
DROP FUNCTION public.fn_insertclaim(claimid integer, studentid text, claimtype boolean, courseid text, campusid text, disciplineid integer, option character);
DROP FUNCTION public.fn_insertcampus("campusID" text, name text);
DROP FUNCTION public.fn_insertassessor("teacherID" text, "firstName" text, "lastName" text, email text, "disciplineID" integer, "campusID" text, "courseID" text, "courseCoordinator" boolean);
DROP FUNCTION public.fn_insertadmin("userID" text, password bytea);
DROP FUNCTION public.fn_getuserbyid(userid text);
DROP FUNCTION public.fn_getteacherbyid(teacherid text);
DROP FUNCTION public.fn_getstudentclaims(studentid text);
DROP FUNCTION public.fn_getstudentbyid(studentid text);
DROP FUNCTION public.fn_getproviders(claimid integer, studentid text, moduleid text);
DROP FUNCTION public.fn_getmoduleelements(moduleid text);
DROP FUNCTION public.fn_getmodulebyid(moduleid text);
DROP FUNCTION public.fn_getevidenceelement(claimid integer, studentid text, moduleid text);
DROP FUNCTION public.fn_getelementcriteria(elementid integer, moduleid text);
DROP FUNCTION public.fn_getdisciplinelist("campusID" text);
DROP FUNCTION public.fn_getdelegates(campusid text, disciplineid integer);
DROP FUNCTION public.fn_getcourselist("campusID" text, "disciplineID" integer);
DROP FUNCTION public.fn_getclaimedmodules(claimid integer);
DROP FUNCTION public.fn_getassessors(campusid text, disciplineid integer, courseid text);
DROP FUNCTION public.fn_claimmodule("moduleID" text, "studentID" text, "claimID" integer);
DROP FUNCTION public.fn_checkfordraftclaim(studentid text);
DROP FUNCTION public.fn_assignprovider("studentID" text, "claimID" integer, "moduleID" text, "providerID" character);
DROP FUNCTION public.fn_assignelective("moduleID" text, "courseID" text, "disciplineID" integer, "campusID" text);
DROP FUNCTION public.fn_assigndiscipline("campusID" text, "disciplineID" integer);
DROP FUNCTION public.fn_assigndelegate("teacherID" text, "disciplineID" integer, "campusID" text);
DROP FUNCTION public.fn_assigncourse("courseID" text, "disciplineID" integer, "campusID" text);
DROP FUNCTION public.fn_assigncore("moduleID" text, "courseID" text);
DROP FUNCTION public.fn_assignassessor("teacherID" text, "disciplineID" integer, "campusID" text, "courseID" text, "courseCoordinator" boolean);
DROP FUNCTION public.fn_assessmodule("moduleID" text, "studentID" text, "claimID" integer, approved boolean, "arrangementNo" text, "functionalCode" text, "overseasEvidence" boolean, recognition character, VARIADIC "prevProvider" character[]);
DROP FUNCTION public.fn_assessevidence("studentID" text, "claimID" integer, "moduleID" text, approved boolean, "assessorNote" text);
DROP FUNCTION public.fn_assessclaim(claimid integer, studentid text, requestcomp boolean, assessorid text, assapproved boolean, option character);
DROP FUNCTION public.fn_approveclaim(claimid integer, studentid text, delapproved boolean, delegateid text);
DROP FUNCTION public."fn_GetTeacherUser"("teacherID" text);
DROP FUNCTION public."fn_GetStudentUser"("studentID" text);
DROP FUNCTION public.fn_generatepassword();
DROP FUNCTION public."fn_GetCampusList"();

-- Purpose: Insert a new campus record
-- Parameters: 	
--	campusID: 3-digit code
--	name: name of campus (e.g. Ourimbah)
CREATE OR REPLACE  FUNCTION fn_InsertCampus("campusID" text, "name" text) RETURNS void AS
$BODY$
	INSERT INTO "Campus"("campusID", "name")
	VALUES($1, $2)
$BODY$		
LANGUAGE SQL VOLATILE;

-- Function: InsertUser
-- Purpose: Insert a new user record. This function should only be called by other insert functions.
-- Parameters: 	
--	userID: studentID (9 digit code) or staffID (DET ID)
--	password: as plain text
--	role: 
--		'A': admin (can make teacher accounts, modify other data)
--		'C': clerical (can insert campus, discipline, course, module)
--		'S': student (can make claims)
--		'T': teacher (can assess/approve claims)
CREATE OR REPLACE  FUNCTION fn_InsertUser(text, text, char) RETURNS void AS
$BODY$
	INSERT INTO "User"("userID", "password", "role") 
	VALUES($1, md5($2)::bytea, $3)
$BODY$
LANGUAGE SQL VOLATILE;

-- Function: InsertStudent
-- Purpose: Insert a new student record
-- Parameters: 	
--	studentID: 9-digit code
--	firstName: first name of student
--	lastName: last name of student
--	email: email address ending with '@tafensw.net.au'
CREATE OR REPLACE  FUNCTION fn_InsertStudent("studentID" text, "firstName" text, "lastName" text, "email" text, "password" text) RETURNS void AS
$BODY$
	INSERT INTO "Student"("studentID", "firstName", "lastName", "email")
	VALUES($1, $2, $3, $4);
	SELECT fn_InsertUser($1,$5,'S');
$BODY$
LANGUAGE SQL VOLATILE;

-- Function: UpdateStudent
-- Purpose: Update a student record
CREATE OR REPLACE FUNCTION fn_UpdateStudent(oldID text, newID text, firstName text, lastName text, email text, password text) RETURNS void AS
$BODY$
    UPDATE "Student"
    SET 
        "studentID" = $2,
        "firstName" = $3,
        "lastName" = $4,
        "email" = $5
    WHERE 
        "Student"."studentID" = $1;

    UPDATE "User"
    SET
	"userID" = $2,
	"password" = md5($6)::bytea
    WHERE 
	"User"."userID" = $1
$BODY$
LANGUAGE SQL VOLATILE;

-- Function: InsertModule
-- Purpose: Insert a new module record
-- Parameters: 	
--	moduleID: 9-10 digit code
--	name: module name (e.g. "Build a database")
--	guide: path to recognition guide for this module
CREATE OR REPLACE  FUNCTION fn_InsertModule(text, text, text) RETURNS void AS
$BODY$	
	INSERT INTO "Module"("moduleID", "name", "instructions") 
	VALUES($1, $2, $3);
        INSERT INTO "Element"("moduleID", "elementID", "description")
        VALUES($1, 0, ' ');
$BODY$		
LANGUAGE SQL VOLATILE;

-- Function: AssignDiscipline
-- Purpose: Assign existing discipline to an existing campus
-- Parameters:
--	campusID, disciplineID
CREATE OR REPLACE FUNCTION fn_AssignDiscipline("campusID" text, "disciplineID" int) RETURNS void AS
$BODY$	
	INSERT INTO "CampusDiscipline"("campusID", "disciplineID")
	VALUES($1,$2)
$BODY$
LANGUAGE SQL VOLATILE;	

-- Function: InsertDiscipline
-- Purpose: Insert a new discipline record
-- Parameters: 	
--	disciplineID: integer made up for this system to identify each discipline
--	name: name of discipline(e.g. 'Information Technology')
CREATE OR REPLACE  FUNCTION fn_InsertDiscipline("name" text) RETURNS void AS
$BODY$
DECLARE disciplineID int;
BEGIN
        disciplineID := MAX("disciplineID") FROM "Discipline";
        IF disciplineID IS NULL THEN disciplineID = 0; END IF;
        disciplineID := disciplineID + 1;
	INSERT INTO "Discipline"("disciplineID", "name")
	VALUES(disciplineID, $1);
END;
$BODY$	
LANGUAGE PLPGSQL VOLATILE;

-- Function: AssignCourse
-- Purpose: Assign existing course to an existing campus & discipline
-- Parameters:
--	courseID, disciplineID, campusID
CREATE OR REPLACE FUNCTION fn_AssignCourse("courseID" text, "disciplineID" int, "campusID" text) RETURNS void AS
$BODY$
	INSERT INTO "CampusDisciplineCourse"("courseID", "disciplineID", "campusID")
	VALUES($1,$2,$3)
$BODY$
LANGUAGE SQL VOLATILE;

-- Function: InsertCourse
-- Purpose: Insert a new course record
-- Parameters: 	
--	courseID: 5-digit code
--	name: name of course (e.g. 'Certificate III in Information Technology')
CREATE OR REPLACE  FUNCTION fn_InsertCourse("courseID" text, "name" text) RETURNS void AS
$BODY$
	INSERT INTO "Course"("courseID", "name")
	VALUES($1,$2);
$BODY$	
LANGUAGE SQL VOLATILE;

-- Function: AssignDelegate
-- Purpose: an existing teacher is assigned to be the delegate of a campus' discipline
-- Parameters:
--	teacherID, disciplineID, campusID
CREATE OR REPLACE FUNCTION fn_AssignDelegate("teacherID" text, "disciplineID" int, "campusID" text) RETURNS void AS
$BODY$
	INSERT INTO "Delegate"("teacherID", "disciplineID", "campusID")
	VALUES($1,$2,$3)
$BODY$
LANGUAGE SQL VOLATILE;

-- Function: InsertTeacher
-- Purpose: Inserts a new Teacher
-- Parameters:
--	teacherID, firstName, lastName, email
CREATE OR REPLACE FUNCTION fn_InsertTeacher("teacherID" text, "firstName" text, "lastName" text, "email" text) RETURNS TEXT AS
$BODY$
DECLARE password text;
BEGIN
    INSERT INTO "Teacher"("teacherID", "firstName", "lastName", "email")
    VALUES($1,$2,$3,$4);

    SELECT INTO password fn_InsertUser($1, 'T');
    RETURN password;
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

-- Function: UpdateTeacher
-- Purpose: updates a teacher record with new data
CREATE OR REPLACE FUNCTION fn_UpdateTeacher(oldID text, newID text, firstName text, lastName text, email text, password text) RETURNS void AS
$BODY$
    UPDATE "Teacher"
    SET 
        "teacherID" = $2,
        "firstName" = $3,
        "lastName" = $4,
        "email" = $5
    WHERE 
        "Teacher"."teacherID" = $1;

    UPDATE "User"
    SET
	"userID" = $2,
	"password" = md5($6)::bytea
    WHERE 
	"User"."userID" = $1
$BODY$
LANGUAGE SQL VOLATILE;

-- Function: InsertDelegate
-- Purpose: Insert a new delegate, i.e. teacher associated with discipline and campus
-- Parameters:
--	teacherID: staff member's DET ID
--	firstName: text
--	lastName: text
--	email: ends with '@tafensw.net.au'
--	disciplineID: discipline that the delegate handles (int)
--	campusID: campus that the discipline is run at (char(3))
CREATE OR REPLACE FUNCTION fn_InsertDelegate("teacherID" text, "firstName" text, "lastName" text, "email" text, "disciplineID" int, "campusID" text) RETURNS void AS
$BODY$
	SELECT fn_InsertTeacher($1,$2,$3,$4);
	SELECT fn_AssignDelegate($1,$5,$6);
$BODY$	
LANGUAGE SQL VOLATILE;

-- Function: AssignAssessor
-- Purpose: Assign a current teacher to be an assessor of a course
-- Parameters:
--	teacherID: staff member's DET ID
--	disciplineID: discipline that the delegate handles (int)
--	campusID: campus that the discipline is run at (char(3))
--	courseID: course that the assessor may assess
--	courseCoordinator: boolean, true if assessor is course coordinator of this associated course
CREATE OR REPLACE FUNCTION fn_AssignAssessor("teacherID" text, "disciplineID" int, "campusID" text, "courseID" text, "courseCoordinator" boolean) RETURNS void AS
$BODY$
	INSERT INTO "Assessor"("teacherID", "disciplineID", "campusID", "courseID", "courseCoordinator")
	VALUES($1,$2,$3,$4,$5)
$BODY$
LANGUAGE SQL VOLATILE;	

-- Function: InsertAssessor
-- Purpose: Insert a new assessor, i.e. teacher associated with course, discipline, campus
-- Parameters:
--	teacherID: staff member's DET ID
--	firstName: text
--	lastName: text
--	email: ends with '@tafensw.net.au'
--	disciplineID: discipline that the delegate handles (int)
--	campusID: campus that the discipline is run at (char(3))
--	courseID: course that the assessor may assess
--	courseCoordinator: boolean, true if assessor is course coordinator of this associated course
CREATE OR REPLACE FUNCTION fn_InsertAssessor("teacherID" text, "firstName" text, "lastName" text, "email" text, "disciplineID" int, "campusID" text, "courseID" text, "courseCoordinator" boolean) RETURNS void AS
$BODY$
	SELECT fn_InsertTeacher($1,$2,$3,$4);
	SELECT fn_AssignAssessor($1,$5,$6,$7,$8);
$BODY$
LANGUAGE SQL VOLATILE;	

-- Function: AssignDelegate
-- Purpose: Assign a current teacher to be a delegate of a discipline
-- Parameters:
--	teacherID: staff member's DET ID
--	disciplineID: discipline that the delegate handles (int)
--	campusID: campus that the discipline is run at (char(3))
CREATE OR REPLACE FUNCTION fn_AssignDelegate("teacherID" text, "disciplineID" int, "campusID" text) RETURNS void AS
$BODY$
	INSERT INTO "Delegate"("teacherID", "disciplineID", "campusID")
	VALUES($1,$2,$3)
$BODY$
LANGUAGE SQL VOLATILE;	

-- Function: AssignElective
-- Purpose: A module is assigned as an Elective of a Course
-- Parameters:
--	moduleID, courseID, disciplineID, campusID
CREATE OR REPLACE FUNCTION fn_AssignElective("moduleID" text, "courseID" text, "disciplineID" int, "campusID" text) RETURNS void AS
$BODY$
	INSERT INTO "Elective"("moduleID", "courseID", "disciplineID", "campusID")
	VALUES($1,$2,$3,$4)
$BODY$
LANGUAGE SQL VOLATILE;		

-- Function: AssignCore
-- Purpose: A module is assigned as a Core of a Course
-- Parameters:
--	moduleID, courseID
CREATE OR REPLACE FUNCTION fn_AssignCore("moduleID" text, "courseID" text) RETURNS void AS
$BODY$
	INSERT INTO "Core"("moduleID", "courseID")
	VALUES($1,$2)
$BODY$
LANGUAGE SQL VOLATILE;

-- Function: InsertElement
-- Purpose: Inserts an element for a module, with automatic numbering of elementID
-- Parameters:
--	moduleID,  elementID, description
CREATE OR REPLACE FUNCTION fn_InsertElement("moduleID" text, "description" text) RETURNS void AS
$BODY$
    DECLARE elementID int;
    BEGIN
        elementID := MAX("Element"."elementID") FROM "Element" WHERE "Element"."moduleID" = $1;
        elementID := elementID + 1;
        INSERT INTO "Element"("elementID", "moduleID", "description")
        VALUES(elementID,$1,$2);
    END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

-- Function: InsertCriterion
-- Purpose: Inserts a criterion for an element
-- Parameters:
--	criterionID, elementID, moduleID, description
CREATE OR REPLACE FUNCTION fn_InsertCriterion("elementID" int, "moduleID" text, "description" text) RETURNS void AS
$BODY$
    DECLARE criterionID int;
    BEGIN
        criterionID := MAX("Criterion"."criterionID") FROM "Criterion" WHERE "Criterion"."elementID" = $1 AND "Criterion"."moduleID" = $2;
        IF criterionID IS NULL THEN criterionID := 0; END IF;
        criterionID := criterionID + 1;
	INSERT INTO "Criterion"("criterionID", "elementID", "moduleID", "description")
	VALUES(criterionID,$1,$2,$3);
    END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

-- Function: InsertEvidence
-- Purpose: Inserts an Evidence record for a ClaimedModule, this would be done by a student, so the assessor's data is not entered.
-- Parameters:
--	studentID, claimID, elementID, description, moduleID
CREATE OR REPLACE FUNCTION fn_InsertEvidence("studentID" text, "claimID" int, "elementID" int, "description" text, "moduleID" text) RETURNS void AS
$BODY$
	INSERT INTO "Evidence"("studentID", "claimID", "elementID", "description", "moduleID")
	VALUES($1,$2,$3,$4,$5);
$BODY$
LANGUAGE SQL VOLATILE;

-- Function: AssessEvidence
-- Purpose: Existing evidence record is assessed
-- Parameters:
--	studentID, claimID, moduleID: identify the evidence record to change
--	approved, assessorNote: assessment to be added
CREATE OR REPLACE FUNCTION fn_AssessEvidence("studentID" text, "claimID" int, "moduleID" text, "approved" boolean, "assessorNote" text) RETURNS void AS
$BODY$
	UPDATE "Evidence" SET ("approved","assessorNote") = ($4,$5) 
		WHERE "studentID" = $1 AND "claimID" = $2 AND "moduleID" = $3;
$BODY$
LANGUAGE SQL VOLATILE;

-- Function: InsertProvider
-- Purpose: Adds a provider, made up of an ID and name
-- Parameters:
--	providerID: char(1), name: text
CREATE OR REPLACE FUNCTION fn_InsertProvider("providerID" char, "name" text) RETURNS void AS
$BODY$
	INSERT INTO "Provider"("providerID", "name")
	VALUES($1, $2);
$BODY$
LANGUAGE SQL VOLATILE;

-- Function: AssignProvider
-- Purpose: A specified claim's module's provider is assigned.
-- Parameters:
--	studentID, claimID, moduleID, providerID
CREATE OR REPLACE FUNCTION fn_AssignProvider("studentID" text, "claimID" int, "moduleID" text, "providerID" char) RETURNS void AS
$BODY$
	INSERT INTO "ClaimedModuleProvider"("studentID", "claimID", "moduleID", "providerID")
	VALUES($1, $2, $3, $4);
$BODY$
LANGUAGE SQL VOLATILE;

-- Function: InsertClaimedModule
-- Purpose: A module is added to a claim by a student. Certain form information is not set here.
CREATE OR REPLACE FUNCTION fn_InsertClaimedModule("moduleID" text, "studentID" text, "claimID" int) RETURNS void AS
$BODY$
	INSERT INTO "ClaimedModule"("moduleID", "studentID", "claimID")
	VALUES($1,$2,$3);
$BODY$
LANGUAGE SQL VOLATILE;

-- Function: UpdateClaimedModule
-- Purpose: Updates a ClaimedModule record with new information
CREATE OR REPLACE FUNCTION fn_UpdateClaimedModule(claimID int, studentID text, moduleID text, 
                    approved boolean, arrangementNo text, functionalCode text, overseasEvidence boolean, recognition char) RETURNS VOID AS
$_$
    UPDATE "ClaimedModule"
    SET
        "approved" = $4,
        "arrangementNo" = $5,
        "functionalCode" = $6,
        "overseasEvidence" = $7,
        "recognition" = $8
    WHERE
        "claimID" = $1
    AND "studentID" = $2
    AND "moduleID" = $3;
$_$
LANGUAGE SQL VOLATILE;

-- Function: DeleteClaimedModule
-- Purpose: deletes a ClaimedModule record
CREATE OR REPLACE FUNCTION fn_DeleteClaimedModule(claimID int, studentID text, moduleID text) RETURNS void AS
$_$
    DELETE FROM "ClaimedModule" 
    WHERE   
        "claimID" = $1
    AND "studentID" = $2
    AND "moduleID" = $3;
$_$
LANGUAGE SQL VOLATILE;

-- Function: AssessModule
-- Purpose: A claimed module's assessment info is added, i.e. 'office-use' info and 'approval' by an assessor
-- Parameters:
--	moduleID, studentID, claimID, approved, arrangementNo, functionalCode, overseasEvidence, prevProvider, recognition
CREATE OR REPLACE FUNCTION fn_AssessModule("moduleID" text, "studentID" text, "claimID" int, "approved" boolean, 
					   "arrangementNo" text, "functionalCode" text, "overseasEvidence" boolean, 
					   "recognition" char, VARIADIC "prevProvider" char[3]) RETURNS void AS
$BODY$
BEGIN
	UPDATE "ClaimedModule" SET("approved", "arrangementNo", "functionalCode", "overseasEvidence", "recognition") = ($4,$5,$6,$7,$8)
		WHERE "moduleID" = $1 AND "studentID" = $2 AND "claimID" = $3;
		
	FOR i IN array_lower($9)..array_lower($9) + 2 LOOP
		IF $9[i] IS NOT NULL THEN
			PERFORM fn_AssignProvider($2,$3,$1,$9[i]);
		END IF;
	END LOOP;
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

-- Function: GeneratePassword
-- Purpose: Generates a random alphanumeric password 12 chars in length.
-- Source: http://stackoverflow.com/questions/3970795/how-do-you-create-a-random-string-in-postgresql user:grourk, 29/3/11
CREATE OR REPLACE FUNCTION fn_GeneratePassword() RETURNS text AS
$BODY$
	SELECT array_to_string(array(
		SELECT substr('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', trunc(random() * 61)::integer + 1, 1) 
		FROM generate_series(1, 12)), '');
$BODY$
LANGUAGE SQL VOLATILE;

-- Function: VerifyLogin
-- Purpose: Verify that userID exists and password matches for user logging in to the system.
-- Returns: true if user has been verified, false otherwise
CREATE OR REPLACE FUNCTION fn_VerifyLogin("userID" text, "password" text) RETURNS char AS
$BODY$
	DECLARE pw bytea;
	DECLARE role char;
	BEGIN
		SELECT INTO pw "User"."password" FROM "User"
			WHERE "User"."userID" = $1;
			
		IF pw IS null THEN RETURN null; END IF;
		
		SELECT INTO role "User"."role" FROM "User"
			WHERE "User"."userID" = $1;
		IF pw = md5($2)::bytea THEN RETURN ROLE;
		ELSE RETURN null;
		END IF;

	END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

-- Function: InsertClerical
-- Purpsoe: Inserts a new 'Clerical' user. Creates a random password 12 chars long for the user.
-- Returns: the password for this user (in text). This is the only way the application can know the password before it is encrypted.
CREATE OR REPLACE FUNCTION fn_InsertClerical("userID" text) RETURNS text AS
$BODY$
	DECLARE pw text;
	
	BEGIN
		SELECT INTO pw fn_GeneratePassword();
		PERFORM fn_InsertUser($1, md5(pw)::bytea, 'C');
		RETURN pw;
	END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

-- Function: InsertAdmin
-- Purpose: Inserts a new 'Admin' user with a specified (encrypted) password.
CREATE OR REPLACE FUNCTION fn_InsertAdmin("userID" text, "password" bytea) RETURNS void AS
$BODY$
	SELECT fn_InsertUser($1, CAST($2 AS text), 'A');
$BODY$
LANGUAGE SQL VOLATILE;

-- Function: InsertClaim
-- Purpose: A student makes a claim, choosing campus, disicpline and course.
CREATE OR REPLACE FUNCTION fn_InsertClaim(studentID text, campusID text, disciplineID int, courseID text, claimType boolean) RETURNS void AS
$BODY$
    DECLARE claimID int;
    BEGIN
        claimID := MAX("claimID") FROM "Claim" WHERE "studentID" = $1;
        IF claimID IS NULL 
            THEN claimID := 1;
        ELSE
            claimID := claimID + 1;
        END IF;
        
	INSERT INTO "Claim"("claimID", "studentID", "campusID", "disciplineID", "courseID", "claimType", "dateMade", "status", "submitted") 
	VALUES(claimID,$1,$2,$3,$4,$5,DEFAULT,DEFAULT,DEFAULT);
    END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

-- Function: SubmitClaim
-- Purpose: A student submits their existing claim, this function updates the 'dateMade' so date is submission date of claim, and sets 'submitted' to true. Also updates status.
CREATE OR REPLACE FUNCTION fn_SubmitClaim(claimID int, studentID text) RETURNS void AS
$BODY$
	UPDATE "Claim" SET ("submitted", "dateMade", "status") = (true, now()::date, 2)
	WHERE "claimID" = $1 AND "studentID" = $2;
	-- TODO: trigger email to course coordinator?
$BODY$
LANGUAGE SQL VOLATILE;

-- Function: AssessClaim
-- Purpose: An assessor updates an existing claim with 'office-data', checks to see if all modules assessed to set 'assApproved',
--	and updates the status of the claim from 2 to 3: Assessed but requires approval.
-- Returns: true if claim successfully 'assessed', false if this would violate integrity (claimed modules not yet assessed for this claim)
CREATE OR REPLACE FUNCTION fn_AssessClaim(claimID int, studentID text, requestComp boolean, assessorID text, assApproved boolean, "option" char) RETURNS boolean AS
$BODY$
BEGIN
	IF NULL IN(
		SELECT "approved" FROM "ClaimedModule" 
			WHERE "ClaimedModule"."claimID" = claimID
			AND "ClaimedModule"."studentID" = studentID
	) THEN RETURN false;
	ELSE
		UPDATE "Claim" SET ("requestComp", "assessorID", "assApproved", "option", "status") = ($3, $4, $5, $6, 3)
		WHERE "claimID" = $1 AND "studentID" = $2;
		RETURN true;
	END IF;
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

-- Function: ApproveClaim
-- Purpose: A delegate updates an existing claim by approving it. Note that this does not 'resolve' the claim, as the
-- 	claim report must first be printed, so 'dateResolved' is not set.
--	Status changes to 4: Claim approved but not yet printed (thus not resolved).
-- Returns: false if the claim can not yet be approved because it has not been 'assessed.' True otherwise.
CREATE OR REPLACE FUNCTION fn_ApproveClaim(claimID int, studentID text, delApproved boolean, delegateID text) RETURNS boolean AS
$BODY$
BEGIN
	IF (SELECT "assApproved" WHERE "claimID" = $1 AND "studentID" = $2) IS NULL THEN 
		RETURN FALSE;
	ELSE
		UPDATE "Claim" SET("delApproved", "delegateID", "status") = ($3, $4, 4);
		RETURN TRUE;
	END IF;
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
	
-- Function: CheckForDraftClaim
-- Purpose: When a student logs in and has already started a draft claim before, the student should only be able to work on that claim,
--		not start a new one. This function checks for a draft claim for a student and returns its claimID.
CREATE OR REPLACE FUNCTION fn_CheckForDraftClaim(studentID text) RETURNS int AS
$BODY$
BEGIN
	IF (SELECT "submitted" FROM "Claim" where "Claim"."studentID" = studentID AND "Claim"."submitted" = false) IS NOT NULL THEN
		RETURN (SELECT "claimID" from "Claim" where "Claim"."studentID" = studentID AND "Claim"."submitted" = false LIMIT 1);
	ELSE
		RETURN NULL;
	END IF;
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

-- Function: GetUserByID
-- Purpose: returns a user matching the specified ID, or null
CREATE OR REPLACE FUNCTION fn_GetUserByID(userID text) RETURNS SETOF "User" AS
$BODY$
	SELECT * FROM "User" WHERE "User"."userID" = $1;
$BODY$
LANGUAGE SQL VOLATILE;

-- Function: InsertUser
-- Purpsoe: another insert user method that doesn't require the password parameter.
-- This method generates and returns a random password, and writes the MD5 equivalent
-- into the user table.
CREATE OR REPLACE FUNCTION fn_InsertUser("userID" text, "role" text) RETURNS TEXT AS
$BODY$
    DECLARE pw TEXT;

    BEGIN
        SELECT INTO pw fn_GeneratePassword();

        PERFORM fn_InsertUser($1, pw, $2);
        RETURN pw;
    END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

-- Function: UpdateUser
-- Purpose: updates a user record with new userID and/or password.
CREATE OR REPLACE FUNCTION fn_UpdateUser(oldID text, newID text, password text) RETURNS VOID AS
$BODY$
    UPDATE "User" 
    SET
        "userID" = $2,
        "password" = md5($3)::bytea
    WHERE
        "User"."userID" = $1;
$BODY$
LANGUAGE SQL VOLATILE;

-- Function: GetStudentClaims
-- Purpose: gets all claims that match a student's ID
CREATE OR REPLACE FUNCTION fn_GetStudentClaims(studentID text) RETURNS SETOF "Claim" AS
$BODY$
    SELECT * FROM "Claim" WHERE "Claim"."studentID" = $1;
$BODY$
LANGUAGE SQL VOLATILE;

-- Function: ListClaimedModules
-- Purpose: gets all of a claim's claimed modules
CREATE OR REPLACE FUNCTION fn_ListClaimedModules(claimID int, studentID text) RETURNS SETOF "vw_ClaimedModule_Module" AS
$BODY$
    SELECT * FROM "vw_ClaimedModule_Module" 
    WHERE "claimID" = $1
    AND   "studentID" = $2;
$BODY$
LANGUAGE SQL VOLATILE;

-- Function: ListProviders
-- Purpose: gets all providers for a claimed module
CREATE OR REPLACE FUNCTION fn_ListProviders(claimID int, studentID text, moduleID text) RETURNS SETOF "Provider" AS
$BODY$
    SELECT "Provider"."providerID", "Provider"."name"
    FROM "Provider", "ClaimedModuleProvider"
    WHERE "ClaimedModuleProvider"."claimID" = "claimID"
    AND "ClaimedModuleProvider"."studentID" = "studentID"
    AND "ClaimedModuleProvider"."moduleID" = "moduleID"
    AND "ClaimedModuleProvider"."providerID" = "Provider"."providerID";
$BODY$
LANGUAGE SQL VOLATILE;

-- Function: GetModuleByID
-- Purpose: gets a module record that matches the provided moduleID
CREATE OR REPLACE FUNCTION fn_GetModuleByID(moduleID text) RETURNS SETOF "Module" AS
$BODY$
    SELECT * FROM "Module" WHERE "Module"."moduleID" = $1;
$BODY$
LANGUAGE SQL VOLATILE;

-- Function: GetModuleElements
-- Purpose: gets all elements for a module
CREATE OR REPLACE FUNCTION fn_GetModuleElements(moduleID text) RETURNS SETOF "Element" AS
$BODY$
    SELECT * FROM "Element" WHERE "Element"."moduleID" = $1 AND "Element"."elementID" != 0;
$BODY$
LANGUAGE SQL VOLATILE;

-- Function: GetCriteria
-- Purpose: gets the criteria for an element
CREATE OR REPLACE FUNCTION fn_GetCriteria(elementID int, moduleID text) RETURNS SETOF "Criterion" AS
$BODY$
    SELECT * FROM "Criterion" 
    WHERE "Criterion"."elementID" = $1
    AND "Criterion"."moduleID" = $2;
$BODY$
LANGUAGE SQL VOLATILE;

-- Function: ListAssessors
-- Purpose: gets the teachers that are assessors of the specified campusdisciplinecourse
CREATE OR REPLACE FUNCTION fn_ListAssessors(campusID text, disciplineID int, courseID text) RETURNS SETOF "vw_AssessorDetails" AS
$BODY$
    SELECT * FROM "vw_AssessorDetails"
    WHERE "vw_AssessorDetails"."campusID" = $1
    AND "vw_AssessorDetails"."disciplineID" = $2
    AND "vw_AssessorDetails"."courseID" = $3;
$BODY$
LANGUAGE SQL VOLATILE;

-- Function: GetStudentUser
-- Purpose: gets a student from the database with data from the user table as well
CREATE OR REPLACE FUNCTION fn_GetStudentUser("studentID" text)
  RETURNS SETOF "vw_StudentUser" AS
$BODY$
    SELECT * FROM "vw_StudentUser" WHERE "userID" = $1;
$BODY$
LANGUAGE sql VOLATILE;

-- Function: GetTeacherUser
-- Purpose: gets a teacher from the database with data from the user table as well
CREATE OR REPLACE FUNCTION fn_GetTeacherUser("teacherID" text)
  RETURNS SETOF "vw_TeacherUser" AS
$BODY$
SELECT * 
FROM "vw_TeacherUser"
WHERE "teacherID" = $1;
$BODY$
LANGUAGE sql VOLATILE;

-- Function: ListCampuses
-- Purpose: returns a list of campuses
CREATE OR REPLACE FUNCTION fn_ListCampuses()
  RETURNS SETOF "Campus" AS
'SELECT * FROM "Campus";'
LANGUAGE sql VOLATILE;

-- Function: ListDisciplines
-- Purpose: returns a list of all disciplines
CREATE OR REPLACE FUNCTION fn_ListDisciplines() RETURNS SETOF "Discipline" AS
$_$
    SELECT * FROM "Discipline";
$_$
LANGUAGE SQL VOLATILE;

-- Function: ListDisciplines
-- Purpose: returns a list of disciplines for a campus
CREATE OR REPLACE FUNCTION fn_ListDisciplines("campusID" text)
  RETURNS SETOF "Discipline" AS
    'SELECT "Discipline".* FROM "Discipline", "CampusDiscipline"
    WHERE "campusID" = $1
    AND "Discipline"."disciplineID" = "CampusDiscipline"."disciplineID";'
LANGUAGE SQL VOLATILE;

-- Function: ListCourses
-- Purpose: returns a list of courses for a discipline in a campus
CREATE OR REPLACE FUNCTION fn_ListCourses("campusID" text, "disciplineID" int)
  RETURNS SETOF "Course" AS
    'SELECT "Course".* FROM "Course", "CampusDisciplineCourse"
    WHERE "campusID" = $1 
    AND "disciplineID" = $2
    AND "Course"."courseID" = "CampusDisciplineCourse"."courseID";'
LANGUAGE SQL VOLATILE;

-- Function: ListCourses
-- Purpose: returns a list of all courses
CREATE OR REPLACE FUNCTION fn_ListCourses() RETURNS SETOF "Course" AS
$_$
    SELECT * FROM "Course";
$_$
LANGUAGE SQL VOLATILE;

-- Function: DeleteUser
-- Purpose: deletes a user from the database
CREATE OR REPLACE FUNCTION fn_DeleteUser("userID" text) RETURNS void AS
$_$
    DELETE FROM "User" WHERE "userID" = $1;
$_$
LANGUAGE SQL VOLATILE;

-- Function: DeleteStudent
-- Purpose: deletes a student from the database, including all claims made by the student
CREATE OR REPLACE FUNCTION fn_DeleteStudent("studentID" text) RETURNS void AS
$_$
    DELETE FROM "Student" WHERE "studentID" = $1;
    SELECT fn_DeleteUser($1);
$_$
LANGUAGE SQL VOLATILE;

-- Function: DeleteTeacher
-- Purpose: deletes a teacher from the database, including all associations dependant on that record
CREATE OR REPLACE FUNCTION fn_DeleteTeacher("teacherID" text) RETURNS void AS
$_$
    DELETE FROM "Teacher" WHERE "teacherID" = $1;
    SELECT fn_DeleteUser($1);
$_$
LANGUAGE SQL VOLATILE;

-- Function: UpdateCampus
-- Purpose: updates a campus record
CREATE OR REPLACE FUNCTION fn_UpdateCampus("oldID" text, "campusID" text, "name" text) RETURNS void AS
$_$
    UPDATE "Campus"
    SET
	"campusID" = $2,
	"name" = $3
    WHERE
	"campusID" = $1;
$_$
LANGUAGE SQL VOLATILE;

-- Function: DeleteCampus
-- Purpose: deletes a campus record, and all dependent records
CREATE OR REPLACE FUNCTION fn_DeleteCampus("campusID" text) RETURNS void AS
$_$
    DELETE FROM "Campus" WHERE "campusID" = $1;	
$_$
LANGUAGE SQL VOLATILE;

-- Function: ListDelegates
-- Purpose: returns a list of delegates for a given campus/discipline
CREATE OR REPLACE FUNCTION fn_ListDelegates("campusID" text, "disciplineID" int) RETURNS SETOF "Teacher" AS
$_$
    SELECT 
        "Teacher"."teacherID",
        "Teacher"."email",
        "Teacher"."firstName",
        "Teacher"."lastName"
    FROM
        "Teacher", "Delegate"
    WHERE 
        "Teacher"."teacherID" = "Delegate"."teacherID"
    AND
        "Delegate"."campusID" = $1
    AND
        "Delegate"."disciplineID" = $2;
$_$
LANGUAGE SQL VOLATILE;

-- Function: UpdateDiscipline
-- Purpose: updates a discipline with a new name
CREATE OR REPLACE FUNCTION fn_UpdateDiscipline(id int, name text) RETURNS void AS
$_$
    UPDATE "Discipline" SET "name" = $2 WHERE "disciplineID" = $1;
$_$
LANGUAGE SQL VOLATILE;

-- Function: DeleteDiscipline
-- Purpose: deletes a discipline
CREATE OR REPLACE FUNCTION fn_DeleteDiscipline(id int) RETURNS void AS
$_$
    DELETE FROM "Discipline" WHERE "disciplineID" = $1;
    UPDATE "Discipline"
    SET "disciplineID" = "disciplineID" - 1
    WHERE "disciplineID" > $1;
$_$
LANGUAGE SQL VOLATILE;

-- Function: UpdateCourse
-- Purpose: updates a course
CREATE OR REPLACE FUNCTION fn_UpdateCourse(oldID text, courseID text, name text) RETURNS void AS
$_$
    UPDATE "Course"
    SET
        "courseID" = $2,
        "name" = $3
    WHERE
        "courseID" = $1;
$_$
LANGUAGE SQL VOLATILE;

-- Function: DeleteCourse
-- Purpose: deletes a course
CREATE OR REPLACE FUNCTION fn_DeleteCourse(courseID text) RETURNS void AS
$_$
    DELETE FROM "Course" WHERE "courseID" = $1;
$_$
LANGUAGE SQL VOLATILE;

-- Function: UpdateModule
-- Purpose: updates a module
CREATE OR REPLACE FUNCTION fn_UpdateModule(oldID text, moduleID text, name text, instructions text) RETURNS void AS
$_$
    UPDATE "Module"
    SET
        "moduleID" = $2,
        "name" = $3,
        "instructions" = $4
    WHERE
        "moduleID" = $1;
$_$
LANGUAGE SQL VOLATILE;

-- Function: DeleteModule
-- Purpose: deletes a module and all dependent elements etc.
CREATE OR REPLACE FUNCTION fn_DeleteModule(moduleID text) RETURNS void AS
$_$
    DELETE FROM "Module" WHERE "moduleID" = $1;
$_$
LANGUAGE SQL VOLATILE;

-- Function: ListCores
-- Purpose: lists core modules for a course
CREATE OR REPLACE FUNCTION fn_ListCores(courseID text) RETURNS SETOF "Module" AS
$_$
    SELECT "Module".*
    FROM "Module", "Core"
    WHERE "Module"."moduleID" = "Core"."moduleID"
    AND "courseID" = $1;
$_$
LANGUAGE SQL VOLATILE;

-- Function: ListElectives
-- Purpose: lists elective modules for a course
CREATE OR REPLACE FUNCTION fn_ListElectives(campusID text, disciplineID int, courseID text) RETURNS SETOF "Module" AS
$_$
    SELECT "Module".*
    FROM "Module", "Elective"
    WHERE
        "Module"."moduleID" = "Elective"."moduleID"
        AND "campusID" = $1
        AND "disciplineID" = $2
        AND "courseID" = $3;
$_$
LANGUAGE SQL VOLATILE;

-- Function: ListModules
-- Purpose: lists all modules
CREATE OR REPLACE FUNCTION fn_ListModules() RETURNS SETOF "Module" AS
$_$
    SELECT * FROM "Module";
$_$
LANGUAGE SQL VOLATILE;

-- Function: UpdateElement
-- Purpsoe: updates the specified element
CREATE OR REPLACE FUNCTION fn_UpdateElement(elementID int, moduleID text, description text) RETURNS void AS
$_$
    UPDATE "Element" SET "description" = $3 WHERE "elementID" = $1 AND "moduleID" = $2;
$_$
LANGUAGE SQL VOLATILE;

-- Function: DeleteElement
-- Purpose: deletes the specified element
CREATE OR REPLACE FUNCTION fn_DeleteElement(elementID int, moduleID text) RETURNS void AS
$_$
    DELETE FROM "Element" WHERE "elementID" = $1 AND "moduleID" = $2;
    UPDATE "Element" 
    SET "elementID" = "elementID" - 1 
    WHERE "moduleID" = $2
    AND "elementID" > $1;
$_$
LANGUAGE SQL VOLATILE;

-- Function: DeleteCriterion
-- Purpose: deletes the specified criterion
CREATE OR REPLACE FUNCTION fn_DeleteCriterion(criterionID int, elementID int, moduleID text) RETURNS void AS
$_$
    DELETE FROM "Criterion" 
    WHERE "criterionID" = $1
    AND "elementID" = $2
    AND "moduleID" = $3;
    
    UPDATE "Criterion"
    SET "criterionID" = "criterionID" - 1
    WHERE "elementID" = $2
    AND "moduleID" = $3
    AND "criterionID" > $1;
$_$
LANGUAGE SQL VOLATILE;

-- Function: UpdateCriterion
-- Purpose: updates the selected criterion with a new description
CREATE OR REPLACE FUNCTION fn_UpdateCriterion(criterionID int, elementID int, moduleID text, description text)
    RETURNS void AS
$_$
    UPDATE "Criterion" 
    SET "description" = $4
    WHERE 
        "criterionID" = $1
    AND "elementID" = $2
    AND "moduleID" = $3;
$_$
LANGUAGE SQL VOLATILE;

-- Function: DeleteProvider
-- Purpose: deletes the specified provider
CREATE OR REPLACE FUNCTION fn_DeleteProvider(providerID char) RETURNS void AS
$_$
    DELETE FROM "Provider" WHERE "providerID" = $1;
$_$
LANGUAGE SQL VOLATILE;

-- Function: DeleteClaim
-- Purpose: deletes a claim
CREATE OR REPLACE FUNCTION fn_DeleteClaim(claimID int, studentID text) RETURNS void AS
$_$
    DELETE FROM "Claim" WHERE "claimID" = $1 AND "studentID" = $2;
    UPDATE "Claim" SET "claimID" = "claimID" - 1 WHERE "claimID" > $1 AND "studentID" = $2;
$_$
LANGUAGE SQL VOLATILE;

-- Function: UpdateClaim
-- Purpose: updates a claim for a teacher/admin user
CREATE OR REPLACE FUNCTION fn_UpdateClaim(
    claimID int, 
    studentID text, 
    assessorApproved boolean,
    delegateApproved boolean,
    option boolean,
    requestComp boolean,
    dateResolved date,
    assessorID text,
    delegateID text) RETURNS VOID AS
$_$
    UPDATE "Claim"
    SET
        "assApproved" = $3,
        "delApproved" = $4,
        "option" = $5,
        "requestComp" = $6,
        "dateResolved" = $7,
        "assessorID" = $8,
        "delegateID" = $9
    WHERE
        "claimID" = $1
    AND "studentID" = $2;
$_$
LANGUAGE SQL VOLATILE;

-- Function: UpdateClaim
-- Purpose: updates the claim for a student user
CREATE OR REPLACE FUNCTION fn_UpdateClaim(
    claimID int, 
    studentID text, 
    campusID text, 
    disciplineID int,    
    option boolean) RETURNS VOID AS
$_$
    UPDATE "Claim"
    SET
        "campusID" = $3, 
        "disciplineID" = $4,
        "option" = $5
    WHERE
        "claimID" = $1
    AND "studentID" = $2;
$_$
LANGUAGE SQL VOLATILE;

-- Function: GetProvider
-- Purpose: gets a provider by ID
CREATE OR REPLACE FUNCTION fn_GetProvider(providerID char) RETURNS SETOF "Provider" AS
$_$
    SELECT * FROM "Provider" WHERE "providerID" = $1;
$_$
LANGUAGE SQL VOLATILE;

-- Function: ListProviders
-- Purpose: returns a list of all providers
CREATE OR REPLACE FUNCTION fn_ListProviders() RETURNS SETOF "Provider" AS
$_$
    SELECT * FROM "Provider";
$_$
LANGUAGE SQL VOLATILE;

-- Function: GetDiscipline
-- Purpose: gets a discipline by ID
CREATE OR REPLACE FUNCTION fn_GetDiscipline(disciplineID int) RETURNS SETOF "Discipline" AS
$_$
    SELECT * FROM "Discipline" WHERE "disciplineID" = $1;
$_$
LANGUAGE SQL VOLATILE;

-- Function: GetCourse
-- Purpose: gets a course by ID
CREATE OR REPLACE FUNCTION fn_GetCourse(courseID text) RETURNS SETOF "Course" AS
$_$
    SELECT * FROM "Course" WHERE "courseID" = $1;
$_$
LANGUAGE SQL VOLATILE;

-- Function: ListClaimsByStudent
-- Purpose: lists claims by student
CREATE OR REPLACE FUNCTION fn_ListClaimsByStudent(studentID text) RETURNS SETOF "Claim" AS
$_$
    SELECT * FROM "Claim" WHERE "studentID" = $1;
$_$
LANGUAGE SQL VOLATILE;

-- Function: ListClaimsByTeacher
-- Purpose: lists claims by teacher
CREATE OR REPLACE FUNCTION fn_ListClaimsByTeacher(teacherID text) RETURNS SETOF "Claim" AS
$_$
    SELECT * FROM "Claim" WHERE "assessorID" = $1 OR "delegateID" = $1;
$_$
LANGUAGE SQL VOLATILE;

-- Function: UpdateEvidence
-- Purpose: update evidence record for a 'Previous Studies' claim
CREATE OR REPLACE FUNCTION fn_UpdateEvidence(studentID text, claimID int, moduleID text, 
                                description text, approved boolean, assessorNote text) RETURNS VOID AS
$_$
    UPDATE "Evidence" 
    SET 
        "description" = $4, 
        "approved" = $5,
        "assessorNote" = $6
    WHERE
        "studentID" = $1 
    AND "claimID" = $2
    AND "moduleID" = $3;
$_$
LANGUAGE SQL VOLATILE;

-- Function: UpdateEvidence
-- Purpose: update evidence record for a 'RPL' claim
CREATE OR REPLACE FUNCTION fn_UpdateEvidence(studentID text, claimID int, moduleID text,
                                description text, approved boolean, assessorNote text, elementID text) RETURNS VOID AS
$_$
    UPDATE "Evidence" 
    SET 
        "description" = $5, 
        "approved" = CAST($6 AS boolean),
        "assessorNote" = $7
    WHERE
        "studentID" = $1 
    AND "claimID" = $2
    AND "moduleID" = $3
    AND "elementID" = CAST($4 AS integer);
$_$
LANGUAGE SQL VOLATILE;

-- Function: ListEvidence
-- Purpose: gets a list of evidence records for a student's claim
CREATE OR REPLACE FUNCTION fn_ListEvidence(studentID text, claimID int, moduleID text) RETURNS SETOF "Evidence" AS
$_$
    SELECT * FROM "Evidence" 
    WHERE
        "studentID" = $1
    AND "claimID" = $2
    AND "moduleID" = $3;
$_$
LANGUAGE SQL VOLATILE;

-- Function: GetElement
-- Purpose: gets an element by elementID & moduleID
CREATE OR REPLACE FUNCTION fn_GetElement(moduleID text, elementID int) RETURNS SETOF "Element" AS
$_$
    SELECT * FROM "Element"
    WHERE
        "moduleID" = $1
    AND "elementID" = $2
$_$
LANGUAGE SQL VOLATILE;

CREATE OR REPLACE FUNCTION fn_ListModulesNotInCourse(courseID text) RETURNS SETOF "Module" AS
$_$
    SELECT DISTINCT "Module".*
    FROM "Module"
    WHERE "Module"."moduleID" NOT IN
    (
	SELECT DISTINCT "Module"."moduleID"
	FROM "Module", "Core"
	WHERE "Core"."courseID" = $1
	AND "Module"."moduleID" = "Core"."moduleID"
	OR "Module"."moduleID" IN
	(
	    SELECT DISTINCT "Module"."moduleID"
	    FROM "Module", "Elective"
	    WHERE "Module"."moduleID" = "Elective"."moduleID"
	    AND "Elective"."courseID" = $1
	)
    )
$_$
LANGUAGE SQL VOLATILE;

CREATE OR REPLACE FUNCTION fn_GetEvidence(claimID int, studentID text, moduleID text, elementID int) RETURNS SETOF "Evidence" AS
$_$
    SELECT * FROM "Evidence"
    WHERE
        "claimID" = $1
    AND "studentID" = $2
    AND "moduleID" = $3
    AND "elementID" = $4;
$_$
LANGUAGE SQL VOLATILE;

CREATE OR REPLACE FUNCTION fn_ListDisciplinesNotInCampus(campusID text) RETURNS SETOF "Discipline" AS
$_$
    SELECT DISTINCT "Discipline".* 
    FROM "Discipline"
    WHERE "Discipline"."disciplineID" NOT IN
    (
        SELECT "disciplineID"
        FROM "CampusDiscipline"
        WHERE "CampusDiscipline"."campusID" = $1
    )
    ORDER BY "Discipline"."name";
$_$
LANGUAGE SQL VOLATILE;

CREATE OR REPLACE FUNCTION fn_ListModulesNotCoreInCourse(courseID text) RETURNS SETOF "Module" AS
$_$
    SELECT DISTINCT "Module".*
    FROM "Module"
    WHERE "Module"."moduleID" NOT IN
    (
        SELECT "moduleID"
        FROM "Core"
        WHERE "courseID" = $1
    )
    ORDER BY "Module"."moduleID";
$_$
LANGUAGE SQL VOLATILE;

CREATE OR REPLACE FUNCTION fn_InsertCampusDiscipline(campusID text, disciplineID int) RETURNS void AS
$_$
    INSERT INTO "CampusDiscipline" ("campusID", "disciplineID")
    VALUES ($1, $2);
$_$
LANGUAGE SQL VOLATILE;

CREATE OR REPLACE FUNCTION fn_GetCampusByID(campusID text) RETURNS SETOF "Campus" AS
$_$
    SELECT * FROM "Campus" WHERE "campusID" = $1;
$_$
LANGUAGE SQL VOLATILE;

-- Function: AddCore
-- Purpose: Adds a core module to a course. If the module is an elective for that course
-- at any campus-discipline, then it is removed as an elective, as a module should not be
-- both elective and core for a course.
CREATE OR REPLACE FUNCTION fn_AddCore(courseID text, moduleID text) RETURNS void AS
$_$
    INSERT INTO "Core"("courseID", "moduleID") 
    VALUES($1, $2);

    DELETE FROM "Elective" 
    WHERE "courseID" = $1 AND "moduleID" = $2;
$_$
LANGUAGE SQL VOLATILE;

CREATE OR REPLACE FUNCTION fn_RemoveCore(courseID text, moduleID text) RETURNS void AS
$_$
    DELETE FROM "Core" 
    WHERE "courseID" = $1
    AND "moduleID" = $2;
$_$
LANGUAGE SQL VOLATILE;

CREATE OR REPLACE FUNCTION fn_ListCoursesNotInDiscipline(campusID text, disciplineID int) RETURNS SETOF "Course" AS
$_$
    SELECT DISTINCT "Course".*
    FROM "Course"
    WHERE "Course"."courseID" NOT IN
    (
        SELECT "courseID" 
        FROM "CampusDisciplineCourse"
        WHERE "campusID" = $1 AND "disciplineID" = $2
    );
$_$
LANGUAGE SQL VOLATILE;

CREATE OR REPLACE FUNCTION fn_AddCourseToDiscipline(campusID text, disciplineID int, courseID text) RETURNS void AS
$_$
    INSERT INTO "CampusDisciplineCourse"("campusID", "disciplineID", "courseID")
    VALUES($1,$2,$3);
$_$
LANGUAGE SQL VOLATILE;

CREATE OR REPLACE FUNCTION fn_RemoveCourseFromDiscipline(campusID text, disciplineID int, courseID text) RETURNS void AS
$_$
    DELETE FROM "CampusDisciplineCourse"
    WHERE
        "campusID" = $1 
    AND "disciplineID" = $2
    AND "courseID" = $3;
$_$
LANGUAGE SQL VOLATILE;

CREATE OR REPLACE FUNCTION fn_AddElective(campusID text, disciplineID int, courseID text, moduleID text) RETURNS void AS
$_$
    INSERT INTO "Elective"("campusID", "disciplineID", "courseID", "moduleID")
    VALUES($1, $2, $3, $4);
$_$
LANGUAGE SQL VOLATILE;

CREATE OR REPLACE FUNCTION fn_RemoveElective(campusID text, disciplineID int, courseID text, moduleID text) RETURNS void AS
$_$
    DELETE FROM "Elective" WHERE "campusID" = $1 AND "disciplineID" = $2 AND "courseID" = $3 AND "moduleID" = $4;
$_$
LANGUAGE SQL VOLATILE;

CREATE OR REPLACE FUNCTION fn_AddProviderToClaimedModule(studentID text, claimID int, moduleID text, providerID char) RETURNS void AS
$_$
    INSERT INTO "ClaimedModuleProvider"("studentID", "claimID", "moduleID", "providerID")
    VALUES($1, $2, $3, $4);
$_$
LANGUAGE SQL VOLATILE;

CREATE OR REPLACE FUNCTION fn_GetClaimByID(claimID int, studentID text) RETURNS SETOF "Claim" AS
$_$
    SELECT * FROM "Claim" WHERE "claimID" = $1 AND "studentID" = $2;
$_$
LANGUAGE SQL VOLATILE;

CREATE OR REPLACE FUNCTION fn_ListCriteria(elementID int, moduleID text) RETURNS SETOF "Criterion" AS
$_$
    SELECT * FROM "Criterion" WHERE "elementID" = $1 AND "moduleID" = $2;
$_$
LANGUAGE SQL VOLATILE;

CREATE OR REPLACE FUNCTION fn_ListTeacherAndAdminUsers() RETURNS SETOF "vw_TeacherUser" AS
$_$
    SELECT * FROM "vw_TeacherUser";
$_$
LANGUAGE SQL VOLATILE;

CREATE OR REPLACE FUNCTION fn_ResetPassword(userID text) RETURNS text AS
$_$
    DECLARE
        newPassword text;
    BEGIN
        SELECT INTO newPassword fn_GeneratePassword();
        UPDATE "User" SET "password" = md5(newPassword)::bytea WHERE "userID" = $1;
        RETURN newPassword;
    END;    
$_$
LANGUAGE PLPGSQL VOLATILE;