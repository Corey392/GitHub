/* Purpose:  	Adds the Functions to the database.
 * Authors:		Ryan,Kelly,Bryce,Todd
 * Created:
 * Version:		v3.2
 * Modified:	10/04/2013
 * Change Log:	v2.0: Bryce:
 *				v3.0: Todd: Updated 'fn_insertstudent' to incorporate all columns that have been added
				v3.1: Todd: Updated 'fn_insertstudent' as the processing order falied the foreign key constraints on the User table.
				v3.2: Mitch: Fixed a mistake I made earlier in fn_listcores and fn_listelectives. Both have been tested and work now.
 * Pre-conditions: Database must be created, tables must already exist, functions must not already exist.
 */

--
-- Name: fn_addcoursetodiscipline(text, integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_addcoursetodiscipline(campusid text, disciplineid integer, courseid text) RETURNS void
    LANGUAGE sql
    AS $_$
    INSERT INTO "CampusDisciplineCourse"("campusID", "disciplineID", "courseID")
	VALUES($1,$2,$3);
$_$;

--
-- Name: fn_addprovidertoclaimedmodule( integer, text, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_addprovidertoclaimedmodule( claimid integer, moduleid text, providerid character) RETURNS void
    LANGUAGE sql
    AS $_$
    INSERT INTO "ClaimedModuleProvider"( "claimID", "moduleID", "providerID")
    VALUES($1, $2, $3);
$_$;


--
-- Name: fn_approveclaim(integer, text, boolean, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_approveclaim(claimid integer, studentid text, delapproved boolean, delegateid text) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
BEGIN
	IF (SELECT "assApproved" WHERE "claimID" = $1 AND "studentID" = $2) IS NULL THEN
		RETURN FALSE;
	ELSE
		UPDATE "Claim" SET("delApproved", "delegateID", "status") = ($3, $4, 4);
		RETURN TRUE;
	END IF;
END;
$_$;


--
-- Name: fn_assessclaim(integer, text, boolean, text, boolean, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_assessclaim(claimid integer, studentid text, requestcomp boolean, assessorid text, assapproved boolean, option character) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
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
$_$;


--
-- Name: fn_assessevidence(text, integer, text, boolean, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_assessevidence("studentID" text, "claimID" integer, "moduleID" text, approved boolean, "assessorNote" text) RETURNS void
    LANGUAGE sql
    AS $_$
	UPDATE "Evidence" SET ("approved","assessorNote") = ($4,$5)
		WHERE "claimID" = $2 AND "moduleID" = $3;
$_$;


--
-- Name: fn_assessmodule(text, text, integer, boolean, text, text, boolean, character, character[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_assessmodule("moduleID" text, "studentID" text, "claimID" integer, approved boolean, "arrangementNo" text, "functionalCode" text, "overseasEvidence" boolean, recognition character, VARIADIC "prevProvider" character[]) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
	UPDATE "ClaimedModule" SET("approved", "arrangementNo", "functionalCode", "overseasEvidence", "recognition") = ($4,$5,$6,$7,$8)
		WHERE "moduleID" = $1 AND "studentID" = $2 AND "claimID" = $3;

	FOR i IN array_lower($9)..array_lower($9) + 2 LOOP
		IF $9[i] IS NOT NULL THEN
			PERFORM fn_AssignProvider($2,$3,$1,$9[i]);
		END IF;
	END LOOP;
END;
$_$;


--
-- Name: fn_assignassessor(text, integer, text, text, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_assignassessor("teacherID" text, "disciplineID" integer, "campusID" text, "courseID" text, "courseCoordinator" boolean) RETURNS void
    LANGUAGE sql
    AS $_$
	INSERT INTO "Assessor"("teacherID", "disciplineID", "campusID", "courseID", "courseCoordinator")
	VALUES($1,$2,$3,$4,$5)
$_$;

--
-- Name: fn_assigncourse(text, integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_assigncourse("courseID" text, "disciplineID" integer, "campusID" text) RETURNS void
    LANGUAGE sql
    AS $_$
	INSERT INTO "CampusDisciplineCourse"("courseID", "disciplineID", "campusID")
	VALUES($1,$2,$3)
$_$;


--
-- Name: fn_assigndelegate(text, integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_assigndelegate("teacherID" text, "disciplineID" integer, "campusID" text) RETURNS void
    LANGUAGE sql
    AS $_$
	INSERT INTO "Delegate"("teacherID", "disciplineID", "campusID")
	VALUES($1,$2,$3)
$_$;


--
-- Name: fn_assigndiscipline(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_assigndiscipline("campusID" text, "disciplineID" integer) RETURNS void
    LANGUAGE sql
    AS $_$
	INSERT INTO "CampusDiscipline"("campusID", "disciplineID")
	VALUES($1,$2)
$_$;


--
-- Name: fn_assignprovider( integer, text, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_assignprovider( "claimID" integer, "moduleID" text, "providerID" character) RETURNS void
    LANGUAGE sql
    AS $_$
	INSERT INTO "ClaimedModuleProvider"( "claimID", "moduleID", "providerID")
	VALUES($1, $2, $3);
$_$;


--
-- Name: fn_checkfordraftclaim(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_checkfordraftclaim(studentid text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF (SELECT "submitted" FROM "Claim" where "Claim"."studentID" = studentID AND "Claim"."submitted" = false) IS NOT NULL THEN
		RETURN (SELECT "claimID" from "Claim" where "Claim"."studentID" = studentID AND "Claim"."submitted" = false LIMIT 1);
	ELSE
		RETURN NULL;
	END IF;
END;
$$;


--
-- Name: fn_deletecampus(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_deletecampus("campusID" text) RETURNS void
    LANGUAGE sql
    AS $_$
    DELETE FROM "Campus" WHERE "campusID" = $1;
$_$;


--
-- Name: fn_deleteclaim(integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_deleteclaim(claimid integer, studentid text) RETURNS void
    LANGUAGE sql
    AS $_$
    DELETE FROM "Claim" WHERE "claimID" = $1 AND "studentID" = $2;
    UPDATE "Claim" SET "claimID" = "claimID" - 1 WHERE "claimID" > $1 AND "studentID" = $2;
$_$;


--
-- Name: fn_deleteclaimedmodule(integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_deleteclaimedmodule(claimid integer, moduleid text) RETURNS void
    LANGUAGE sql
    AS $_$
    DELETE FROM "ClaimedModule"
    WHERE
        "claimID" = $1
    AND "moduleID" = $2;
$_$;


--
-- Name: fn_deletecourse(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_deletecourse(courseid text) RETURNS void
    LANGUAGE sql
    AS $_$
    DELETE FROM "Course" WHERE "courseID" = $1;
$_$;


--
-- Name: fn_deletecriterion(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_deletecriterion(criterionid integer, elementid integer) RETURNS void
    LANGUAGE sql
    AS $_$
    DELETE FROM "Criterion"
    WHERE "criterionID" = $1
    AND "elementID" = $2;

    UPDATE "Criterion"
    SET "criterionID" = "criterionID" - 1
    WHERE "elementID" = $2
    AND "criterionID" > $1;
$_$;


--
-- Name: fn_deletediscipline(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_deletediscipline(id integer) RETURNS void
    LANGUAGE sql
    AS $_$
    DELETE FROM "Discipline" WHERE "disciplineID" = $1;
    UPDATE "Discipline"
    SET "disciplineID" = "disciplineID" - 1
    WHERE "disciplineID" > $1;
$_$;


--
-- Name: fn_deleteelement(integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_deleteelement(elementid integer, moduleid text) RETURNS void
    LANGUAGE sql
    AS $_$
    DELETE FROM "Element" WHERE "elementID" = $1 AND "moduleID" = $2;
    UPDATE "Element"
    SET "elementID" = "elementID" - 1
    WHERE "moduleID" = $2
    AND "elementID" > $1;
$_$;


--
-- Name: fn_deletemodule(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_deletemodule(moduleid text) RETURNS void
    LANGUAGE sql
    AS $_$
    DELETE FROM "Module" WHERE "moduleID" = $1;
$_$;


--
-- Name: fn_deleteprovider(character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_deleteprovider(providerid character) RETURNS void
    LANGUAGE sql
    AS $_$
    DELETE FROM "Provider" WHERE "providerID" = $1;
$_$;

--
-- Name: fn_deleteuser(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_deleteuser("userID" text) RETURNS void
    LANGUAGE sql
    AS $_$
    DELETE FROM "User" WHERE "userID" = $1;
$_$;

--
-- Name: fn_deletestudent(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_deletestudent("studentID" text) RETURNS void
    LANGUAGE sql
    AS $_$
    DELETE FROM "Student" WHERE "studentID" = $1;
    SELECT fn_DeleteUser($1);
$_$;


--
-- Name: fn_deleteteacher(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_deleteteacher("teacherID" text) RETURNS void
    LANGUAGE sql
    AS $_$
    DELETE FROM "Teacher" WHERE "teacherID" = $1;
    SELECT fn_DeleteUser($1);
$_$;


--
-- Name: fn_getclaimbyid(integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_getclaimbyid(claimid integer, studentid text) RETURNS SETOF "Claim"
    LANGUAGE sql
    AS $_$
    SELECT * FROM "Claim" WHERE "claimID" = $1 AND "studentID" = $2;
$_$;

--
-- Name: fn_getcampusbyid(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_getcampusbyid(campusid text) RETURNS SETOF "Campus"
    LANGUAGE sql
    AS $_$
    SELECT * FROM "Campus" WHERE "campusID" = $1;
$_$;


--
-- Name: fn_getcourse(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_getcourse(courseid text) RETURNS SETOF "Course"
    LANGUAGE sql
    AS $_$
    SELECT * FROM "Course" WHERE "courseID" = $1;
$_$;

--
-- Name: fn_getcriteria(integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_getcriteria(elementid integer) RETURNS SETOF "Criterion"
    LANGUAGE sql
    AS $_$
    SELECT * FROM "Criterion"
    WHERE "Criterion"."elementID" = $1;
$_$;

--
-- Name: fn_getdiscipline(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_getdiscipline(disciplineid integer) RETURNS SETOF "Discipline"
    LANGUAGE sql
    AS $_$
    SELECT * FROM "Discipline" WHERE "disciplineID" = $1;
$_$;

--
-- Name: fn_getelement(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_getelement(moduleid text, elementid integer) RETURNS SETOF "Element"
    LANGUAGE sql
    AS $_$
    SELECT * FROM "Element"
    WHERE
        "moduleID" = $1
    AND "elementID" = $2
$_$;

--
-- Name: fn_getevidence(integer, text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_getevidence(claimid integer, moduleid text, elementid integer) RETURNS SETOF "Evidence"
    LANGUAGE sql
    AS $_$
    SELECT * FROM "Evidence"
    WHERE
        "claimID" = $1
    AND "moduleID" = $2
    AND "elementID" = $3;
$_$;

--
-- Name: fn_getmodulebyid(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_getmodulebyid(moduleid text) RETURNS SETOF "Module"
    LANGUAGE sql
    AS $_$
    SELECT * FROM "Module" WHERE "Module"."moduleID" = $1;
$_$;

--
-- Name: fn_getmoduleelements(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_getmoduleelements(moduleid text) RETURNS SETOF "Element"
    LANGUAGE sql
    AS $_$
    SELECT * FROM "Element" WHERE "Element"."moduleID" = $1 AND "Element"."elementID" != 0;
$_$;

--
-- Name: fn_getprovider(character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_getprovider(providerid character) RETURNS SETOF "Provider"
    LANGUAGE sql
    AS $_$
    SELECT * FROM "Provider" WHERE "providerID" = $1;
$_$;


--
-- Name: fn_getstudentclaims(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_getstudentclaims(studentid text) RETURNS SETOF "Claim"
    LANGUAGE sql
    AS $_$
    SELECT * FROM "Claim" WHERE "Claim"."studentID" = $1;
$_$;

--
-- Name: fn_getstudentuser(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_getstudentuser("studentID" text) RETURNS SETOF "vw_StudentUser"
    LANGUAGE sql
    AS $_$
    SELECT * FROM "vw_StudentUser" WHERE "userID" = $1;
$_$;

--
-- Name: fn_getteacheruser(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_getteacheruser("teacherID" text) RETURNS SETOF "vw_TeacherUser"
    LANGUAGE sql
    AS $_$
SELECT *
FROM "vw_TeacherUser"
WHERE "teacherID" = $1;
$_$;


--
-- Name: fn_getuserbyid(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_getuserbyid(userid text) RETURNS SETOF "User"
    LANGUAGE sql
    AS $_$
	SELECT * FROM "User" WHERE "User"."userID" = $1;
$_$;


--
-- Name: fn_insertuser(text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_insertuser("userID" text, role text, "email" text, "firstName" text, "lastName" text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
    DECLARE pw TEXT;

    BEGIN
        SELECT INTO pw fn_GeneratePassword();

        PERFORM fn_InsertUser($1, pw, $2, $3, $4, $5);
        RETURN pw;
    END;
$_$;


--
-- Name: fn_insertuser(text, text, character, text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_insertuser(text, text, character, text,text, text) RETURNS void
    LANGUAGE sql
    AS $_$
	INSERT INTO "User"("userID", "password", "role", "email", "firstName", "lastName")
	VALUES($1, md5($2)::bytea, $3, $4, $5, $6)
$_$;

--
-- Name: fn_insertadmin(text, bytea, text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_insertadmin("userID" text, password text, "email" text, "firstName" text, "lastName" text) RETURNS void
    LANGUAGE sql
    AS $_$
	SELECT fn_InsertUser($1, $2, 'A', $3, $4, $5);
$_$;


--
-- Name: fn_insertteacher(text, text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_insertteacher("teacherID" text, "userID" text, "firstName" text, "lastName" text, "email" text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE password text;
BEGIN
    INSERT INTO "Teacher"("teacherID","userID")
    VALUES($1,$2);

    SELECT INTO password fn_InsertUser($1, 'T',$5,$3,$4);
    RETURN password;
END;
$_$;

--
-- Name: fn_insertassessor(text, text, text, text, integer, text, text, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_insertassessor("teacherID" text, "userID" text, "firstName" text, "lastName" text, "email" text, "disciplineID" integer, "campusID" text, "courseID" text, "courseCoordinator" boolean) RETURNS void
    LANGUAGE sql
    AS $_$
	SELECT fn_InsertTeacher($1,$2,$3,$4,$5);
	SELECT fn_AssignAssessor($1,$6,$7,$8,$9);
$_$;


--
-- Name: fn_insertcampus(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_insertcampus("campusID" text, name text) RETURNS void
    LANGUAGE sql
    AS $_$
	INSERT INTO "Campus"("campusID", "name")
	VALUES($1, $2)
$_$;


--
-- Name: fn_insertcampusdiscipline(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_insertcampusdiscipline(campusid text, disciplineid integer) RETURNS void
    LANGUAGE sql
    AS $_$
    INSERT INTO "CampusDiscipline" ("campusID", "disciplineID")
    VALUES ($1, $2);
$_$;


--
-- Name: fn_insertclaim(text, text, integer, text, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_insertclaim(studentid text, campusid text, disciplineid integer, courseid text, claimtype boolean) RETURNS void
    LANGUAGE plpgsql
    AS $_$
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
$_$;


--
-- Name: fn_insertclaimedmodule(text, text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_insertclaimedmodule("moduleID" text,  "claimID" integer) RETURNS void
    LANGUAGE sql
    AS $_$
	INSERT INTO "ClaimedModule"("moduleID", "claimID")
	VALUES($1,$2);
$_$;


--
-- Name: fn_insertclerical(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_insertclerical("userID" text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
	DECLARE pw text;

	BEGIN
		SELECT INTO pw fn_GeneratePassword();
		PERFORM fn_InsertUser($1, md5(pw)::bytea, 'C');
		RETURN pw;
	END;
$_$;


--
-- Name: fn_insertcourse(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_insertcourse("courseID" text, name text) RETURNS void
    LANGUAGE sql
    AS $_$
	INSERT INTO "Course"("courseID", "name")
	VALUES($1,$2);
$_$;


--
-- Name: fn_insertcriterion(integer, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_insertcriterion("elementID" integer, description text) RETURNS void
    LANGUAGE plpgsql
    AS $_$
    DECLARE criterionID int;
    BEGIN
        criterionID := MAX("Criterion"."criterionID") FROM "Criterion" WHERE "Criterion"."elementID" = $1;
        IF criterionID IS NULL THEN criterionID := 0; END IF;
        criterionID := criterionID + 1;
	INSERT INTO "Criterion"("criterionID", "elementID", "description")
	VALUES(criterionID,$1,$2);
    END;
$_$;


--
-- Name: fn_insertdelegate(text, text, text, text, integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_insertdelegate( "teacherID" text,"userID" text, "firstName" text, "lastName" text, "email" text, "disciplineID" integer, "campusID" text) RETURNS void
    LANGUAGE sql
    AS $_$
	SELECT fn_InsertTeacher($1,$2, $3,$4, $5);
	SELECT fn_AssignDelegate($1,$6,$7);
$_$;


--
-- Name: fn_insertdiscipline(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_insertdiscipline(name text) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE disciplineID int;
BEGIN
        disciplineID := MAX("disciplineID") FROM "Discipline";
        IF disciplineID IS NULL THEN disciplineID = 0; END IF;
        disciplineID := disciplineID + 1;
	INSERT INTO "Discipline"("disciplineID", "name")
	VALUES(disciplineID, $1);
END;
$_$;


--
-- Name: fn_insertelement(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_insertelement("moduleID" text, description text) RETURNS void
    LANGUAGE plpgsql
    AS $_$
    DECLARE elementID int;
    BEGIN
        elementID := MAX("Element"."elementID") FROM "Element" WHERE "Element"."moduleID" = $1;
        elementID := elementID + 1;
        INSERT INTO "Element"("elementID", "moduleID", "description")
        VALUES(elementID,$1,$2);
    END;
$_$;


--
-- Name: fn_insertevidence( integer, integer, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_insertevidence( "claimID" integer, "elementID" integer, description text, "moduleID" text) RETURNS void
    LANGUAGE sql
    AS $_$
	INSERT INTO "Evidence"( "claimID", "elementID", "description", "moduleID")
	VALUES($1,$2,$3,$4);
$_$;


--
-- Name: fn_insertmodule(text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_insertmodule(text, text, text) RETURNS void
    LANGUAGE sql
    AS $_$
	INSERT INTO "Module"("moduleID", "name", "instructions")
	VALUES($1, $2, $3);
        INSERT INTO "Element"("moduleID", "elementID", "description")
        VALUES($1, 0, ' ');
$_$;


--
-- Name: fn_insertprovider(character, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_insertprovider("providerID" character, name text) RETURNS void
    LANGUAGE sql
    AS $_$
	INSERT INTO "Provider"("providerID", "name")
	VALUES($1, $2);
$_$;


--
-- Name: fn_insertstudent(text, text, text, text, text, text, text, text, text, integer, text, text, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_insertstudent("userID" text, "email" text, "firstName" text, "lastName" text, "otherName" text, "addressLine1" text, "addressLine2" text, "town" text, "state" text, "postCode" integer, "phoneNumber" text, "studentID" text, "staff" boolean) RETURNS text
    LANGUAGE plpgsql
    AS $_$
    DECLARE pw TEXT;

    BEGIN
		SELECT INTO pw fn_InsertUser($1, 'S', $2, $3, $4);
		INSERT INTO "Student"("userID", "otherName", "addressLine1", "addressLine2", "town", "state", "postCode", "phoneNumber", "studentID", "staff")
			VALUES($1, $5, $6, $7, $8, $9, $10, $11, $12, $13);
		RETURN pw;
    END;
$_$;


--
-- Name: fn_listassessors(text, integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_listassessors(campusid text, disciplineid integer, courseid text) RETURNS SETOF "vw_AssessorDetails"
    LANGUAGE sql
    AS $_$
    SELECT * FROM "vw_AssessorDetails"
    WHERE "vw_AssessorDetails"."campusID" = $1
    AND "vw_AssessorDetails"."disciplineID" = $2
    AND "vw_AssessorDetails"."courseID" = $3;
$_$;


--
-- Name: fn_listcampuses(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_listcampuses() RETURNS SETOF "Campus"
    LANGUAGE sql
    AS $$SELECT * FROM "Campus";$$;

--
-- Name: fn_listclaimedmodules(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_listclaimedmodules(claimid integer) RETURNS SETOF "vw_ClaimedModule_Module"
    LANGUAGE sql
    AS $_$
    SELECT * FROM "vw_ClaimedModule_Module"
    WHERE "claimID" = $1;
$_$;


--
-- Name: fn_listclaimsbystudent(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_listclaimsbystudent(studentid text) RETURNS SETOF "Claim"
    LANGUAGE sql
    AS $_$
    SELECT * FROM "Claim" WHERE "studentID" = $1;
$_$;


--
-- Name: fn_listclaimsbyteacher(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_listclaimsbyteacher(teacherid text) RETURNS SETOF "Claim"
    LANGUAGE sql
    AS $_$
    SELECT * FROM "Claim" WHERE "assessorID" = $1 OR "delegateID" = $1;
$_$;

--
-- Name: fn_listcores(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_listcores(courseid text) RETURNS SETOF "CourseModule"
    LANGUAGE sql
    AS $_$
    SELECT * FROM "CourseModule" WHERE "courseID" = $1 AND "elective" = false;
$_$;

--
-- Name: fn_listelectives(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_listelectives(courseid text) RETURNS SETOF "CourseModule"
    LANGUAGE sql
    AS $_$
    SELECT * FROM "CourseModule" WHERE "courseID" = $1 AND "elective" = true;
$_$;

--
-- Name: fn_listcourses(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_listcourses() RETURNS SETOF "Course"
    LANGUAGE sql
    AS $$
    SELECT * FROM "Course";
$$;


--
-- Name: fn_listcourses(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_listcourses("campusID" text, "disciplineID" integer) RETURNS SETOF "Course"
    LANGUAGE sql
    AS $_$SELECT "Course".* FROM "Course", "CampusDisciplineCourse"
    WHERE "campusID" = $1
    AND "disciplineID" = $2
    AND "Course"."courseID" = "CampusDisciplineCourse"."courseID";$_$;


--
-- Name: fn_listcoursesnotindiscipline(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_listcoursesnotindiscipline(campusid text, disciplineid integer) RETURNS SETOF "Course"
    LANGUAGE sql
    AS $_$
    SELECT DISTINCT "Course".*
    FROM "Course"
    WHERE "Course"."courseID" NOT IN
    (
        SELECT "courseID"
        FROM "CampusDisciplineCourse"
        WHERE "campusID" = $1 AND "disciplineID" = $2
    );
$_$;


--
-- Name: fn_listcriteria(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_listcriteria(elementid integer) RETURNS SETOF "Criterion"
    LANGUAGE sql
    AS $_$
    SELECT * FROM "Criterion" WHERE "elementID" = $1;
$_$;


--
-- Name: fn_listdelegates(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_listdelegates("campusID" text, "disciplineID" integer) RETURNS SETOF "Teacher"
    LANGUAGE sql
    AS $_$
    SELECT
        "Teacher"."teacherID",
        "Teacher"."userID"
    FROM
        "Teacher", "Delegate"
    WHERE
        "Teacher"."teacherID" = "Delegate"."teacherID"
    AND
        "Delegate"."campusID" = $1
    AND
        "Delegate"."disciplineID" = $2;
$_$;


--
-- Name: fn_listdisciplines(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_listdisciplines() RETURNS SETOF "Discipline"
    LANGUAGE sql
    AS $$
    SELECT * FROM "Discipline";
$$;


--
-- Name: fn_listdisciplines(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_listdisciplines("campusID" text) RETURNS SETOF "Discipline"
    LANGUAGE sql
    AS $_$SELECT "Discipline".* FROM "Discipline", "CampusDiscipline"
    WHERE "campusID" = $1
    AND "Discipline"."disciplineID" = "CampusDiscipline"."disciplineID";$_$;


--
-- Name: fn_listdisciplinesnotincampus(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_listdisciplinesnotincampus(campusid text) RETURNS SETOF "Discipline"
    LANGUAGE sql
    AS $_$
    SELECT DISTINCT "Discipline".*
    FROM "Discipline"
    WHERE "Discipline"."disciplineID" NOT IN
    (
        SELECT "disciplineID"
        FROM "CampusDiscipline"
        WHERE "CampusDiscipline"."campusID" = $1
    )
    ORDER BY "Discipline"."name";
$_$;


--
-- Name: fn_listevidence( integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_listevidence( claimid integer, moduleid text) RETURNS SETOF "Evidence"
    LANGUAGE sql
    AS $_$
    SELECT * FROM "Evidence"
    WHERE
	"claimID" = $1
    AND "moduleID" = $2;
$_$;


--
-- Name: fn_listmodules(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_listmodules() RETURNS SETOF "Module"
    LANGUAGE sql
    AS $$
    SELECT * FROM "Module";
$$;

--
-- Name: fn_listproviders(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_listproviders() RETURNS SETOF "Provider"
    LANGUAGE sql
    AS $$
    SELECT * FROM "Provider";
$$;


--
-- Name: fn_listproviders(integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_listproviders(claimid integer, moduleid text) RETURNS SETOF "Provider"
    LANGUAGE sql
    AS $$
    SELECT "Provider"."providerID", "Provider"."name"
    FROM "Provider", "ClaimedModuleProvider"
    WHERE "ClaimedModuleProvider"."claimID" = "claimID"
    AND "ClaimedModuleProvider"."moduleID" = "moduleID"
    AND "ClaimedModuleProvider"."providerID" = "Provider"."providerID";
$$;


--
-- Name: fn_listteacherandadminusers(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_listteacherandadminusers() RETURNS SETOF "vw_TeacherUser"
    LANGUAGE sql
    AS $$
    SELECT * FROM "vw_TeacherUser";
$$;


--
-- Name: fn_removecoursefromdiscipline(text, integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_removecoursefromdiscipline(campusid text, disciplineid integer, courseid text) RETURNS void
    LANGUAGE sql
    AS $_$
    DELETE FROM "CampusDisciplineCourse"
    WHERE
        "campusID" = $1
    AND "disciplineID" = $2
    AND "courseID" = $3;
$_$;


--
-- Name: fn_resetpassword(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_resetpassword(userid text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
    DECLARE
        newPassword text;
    BEGIN
        SELECT INTO newPassword fn_GeneratePassword();
        UPDATE "User" SET "password" = md5(newPassword)::bytea WHERE "userID" = $1;
        RETURN newPassword;
    END;
$_$;


--
-- Name: fn_submitclaim(integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_submitclaim(claimid integer, studentid text) RETURNS void
    LANGUAGE sql
    AS $_$
	UPDATE "Claim" SET ("submitted", "dateMade", "status") = (true, now()::date, 2)
	WHERE "claimID" = $1 AND "studentID" = $2;
	-- TODO: trigger email to course coordinator?
$_$;


--
-- Name: fn_updatecampus(text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_updatecampus("oldID" text, "campusID" text, name text) RETURNS void
    LANGUAGE sql
    AS $_$
    UPDATE "Campus"
    SET
	"campusID" = $2,
	"name" = $3
    WHERE
	"campusID" = $1;
$_$;


--
-- Name: fn_updateclaim(integer, text, text, integer, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_updateclaim(claimid integer, studentid text, campusid text, disciplineid integer, option boolean) RETURNS void
    LANGUAGE sql
    AS $_$
    UPDATE "Claim"
    SET
        "campusID" = $3,
        "disciplineID" = $4,
        "option" = $5
    WHERE
        "claimID" = $1
    AND "studentID" = $2;
$_$;


--
-- Name: fn_updateclaim(integer, text, boolean, boolean, boolean, boolean, date, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_updateclaim(claimid integer, studentid text, assessorapproved boolean, delegateapproved boolean, option boolean, requestcomp boolean, dateresolved date, assessorid text, delegateid text) RETURNS void
    LANGUAGE sql
    AS $_$
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
$_$;


--
-- Name: fn_updateclaimedmodule(integer, text,  boolean, text, text, boolean, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_updateclaimedmodule(claimid integer,  moduleid text, approved boolean, arrangementno text, functionalcode text, overseasevidence boolean, recognition character) RETURNS void
    LANGUAGE sql
    AS $_$
    UPDATE "ClaimedModule"
    SET
        "approved" = $3,
        "arrangementNo" = $4,
        "functionalCode" = $5,
        "overseasEvidence" = $6,
        "recognition" = $7
    WHERE
        "claimID" = $1
    AND "moduleID" = $2;
$_$;


--
-- Name: fn_updatecourse(text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_updatecourse(oldid text, courseid text, name text) RETURNS void
    LANGUAGE sql
    AS $_$
    UPDATE "Course"
    SET
        "courseID" = $2,
        "name" = $3
    WHERE
        "courseID" = $1;
$_$;


--
-- Name: fn_updatecriterion(integer, integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_updatecriterion(criterionid integer, elementid integer, description text) RETURNS void
    LANGUAGE sql
    AS $_$
    UPDATE "Criterion"
    SET "description" = $3
    WHERE
        "criterionID" = $1
    AND "elementID" = $2
$_$;


--
-- Name: fn_updatediscipline(integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_updatediscipline(id integer, name text) RETURNS void
    LANGUAGE sql
    AS $_$
    UPDATE "Discipline" SET "name" = $2 WHERE "disciplineID" = $1;
$_$;


--
-- Name: fn_updateelement(integer, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_updateelement(elementid integer, moduleid text, description text) RETURNS void
    LANGUAGE sql
    AS $_$
    UPDATE "Element" SET "description" = $3 WHERE "elementID" = $1 AND "moduleID" = $2;
$_$;


--
-- Name: fn_updateevidence( integer, text, text, boolean, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_updateevidence( claimid integer, moduleid text, description text, approved boolean, assessornote text) RETURNS void
    LANGUAGE sql
    AS $_$
    UPDATE "Evidence"
    SET
        "description" = $3,
        "approved" = $4,
        "assessorNote" = $5
    WHERE
	"claimID" = $1
    AND "moduleID" = $2;
$_$;


--
-- Name: fn_updatemodule(text, text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_updatemodule(oldid text, moduleid text, name text, instructions text) RETURNS void
    LANGUAGE sql
    AS $_$
    UPDATE "Module"
    SET
        "moduleID" = $2,
        "name" = $3,
        "instructions" = $4
    WHERE
        "moduleID" = $1;
$_$;


--
-- Name: fn_updatestudent(text, text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_updatestudent(oldid text, newid text, firstname text, lastname text, email text, password text) RETURNS void
    LANGUAGE sql
    AS $_$
    UPDATE "Student"
    SET
        "studentID" = $2

    WHERE
        "Student"."studentID" = $1;

    UPDATE "User"
    SET
	"userID" = $2,
	"password" = md5($6)::bytea,
	"firstName" = $3,
        "lastName" = $4,
        "email" = $5
    WHERE
	"User"."userID" = $1
$_$;


--
-- Name: fn_updateteacher(text, text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_updateteacher(oldid text, newid text, firstname text, lastname text, email text, password text) RETURNS void
    LANGUAGE sql
    AS $_$
    UPDATE "Teacher"
    SET
        "teacherID" = $2

    WHERE
        "Teacher"."teacherID" = $1;

    UPDATE "User"
    SET
	"userID" = $2,
	"password" = md5($6)::bytea,
	"firstName" = $3,
        "lastName" = $4,
        "email" = $5
    WHERE
	"User"."userID" = $1
$_$;


--
-- Name: fn_updateuser(text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_updateuser(oldid text, newid text, password text) RETURNS void
    LANGUAGE sql
    AS $_$
    UPDATE "User"
    SET
        "userID" = $2,
        "password" = md5($3)::bytea
    WHERE
        "User"."userID" = $1;
$_$;


--
-- Name: fn_verifylogin(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_verifylogin("userID" text, password text) RETURNS character
    LANGUAGE plpgsql
    AS $_$
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
$_$;

--
-- Name: fn_insertCourseModule(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_insertCourseModule("courseID" text, "moduleID" text) RETURNS void
    LANGUAGE sql
    AS $_$
    INSERT INTO "CourseModule"("courseID", "moduleID")
    VALUES($1, $2);
$_$;


--
-- Name: fn_listmodulesnotincourse(text); Type: FUNCTION; Schema: public; Owner: -
--


CREATE FUNCTION fn_listmodulesnotinacourse("courseID" text) RETURNS SETOF "Module"
    LANGUAGE sql
    AS $_$
    SELECT "Module".*
    FROM "Module", "CourseModule"
    WHERE "CourseModule"."courseID" <> $1
$_$;

--
-- Name: fn_listmodulesnotincourse(); Type: FUNCTION; Schema: public; Owner: -
--


CREATE FUNCTION fn_listmodulesnotinanycourse() RETURNS SETOF "Module"
    LANGUAGE sql
    AS $_$
    SELECT "Module".*
    FROM "Module", "CourseModule"
    WHERE "CourseModule"."moduleID" <> "Module"."moduleID"
$_$;



--
-- Name: public; Type: ACL; Schema: -; Owner: -
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;
GRANT USAGE ON SCHEMA public TO student;


--
-- Name: fn_addcoursetodiscipline(text, integer, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_addcoursetodiscipline(campusid text, disciplineid integer, courseid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_addcoursetodiscipline(campusid text, disciplineid integer, courseid text) FROM postgres;
GRANT ALL ON FUNCTION fn_addcoursetodiscipline(campusid text, disciplineid integer, courseid text) TO postgres;
GRANT ALL ON FUNCTION fn_addcoursetodiscipline(campusid text, disciplineid integer, courseid text) TO admin;
GRANT ALL ON FUNCTION fn_addcoursetodiscipline(campusid text, disciplineid integer, courseid text) TO clerical;
GRANT ALL ON FUNCTION fn_addcoursetodiscipline(campusid text, disciplineid integer, courseid text) TO teacher;
GRANT ALL ON FUNCTION fn_addcoursetodiscipline(campusid text, disciplineid integer, courseid text) TO student;


--
-- Name: fn_addprovidertoclaimedmodule( integer, text, character); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_addprovidertoclaimedmodule(claimid integer, moduleid text, providerid character) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_addprovidertoclaimedmodule(claimid integer, moduleid text, providerid character) FROM postgres;
GRANT ALL ON FUNCTION fn_addprovidertoclaimedmodule(claimid integer, moduleid text, providerid character) TO postgres;
GRANT ALL ON FUNCTION fn_addprovidertoclaimedmodule(claimid integer, moduleid text, providerid character) TO admin;
GRANT ALL ON FUNCTION fn_addprovidertoclaimedmodule(claimid integer, moduleid text, providerid character) TO clerical;
GRANT ALL ON FUNCTION fn_addprovidertoclaimedmodule(claimid integer, moduleid text, providerid character) TO teacher;
GRANT ALL ON FUNCTION fn_addprovidertoclaimedmodule(claimid integer, moduleid text, providerid character) TO student;


--
-- Name: fn_approveclaim(integer, text, boolean, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_approveclaim(claimid integer, studentid text, delapproved boolean, delegateid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_approveclaim(claimid integer, studentid text, delapproved boolean, delegateid text) FROM postgres;
GRANT ALL ON FUNCTION fn_approveclaim(claimid integer, studentid text, delapproved boolean, delegateid text) TO postgres;
GRANT ALL ON FUNCTION fn_approveclaim(claimid integer, studentid text, delapproved boolean, delegateid text) TO admin;
GRANT ALL ON FUNCTION fn_approveclaim(claimid integer, studentid text, delapproved boolean, delegateid text) TO clerical;
GRANT ALL ON FUNCTION fn_approveclaim(claimid integer, studentid text, delapproved boolean, delegateid text) TO teacher;
GRANT ALL ON FUNCTION fn_approveclaim(claimid integer, studentid text, delapproved boolean, delegateid text) TO student;


--
-- Name: fn_assessclaim(integer, text, boolean, text, boolean, character); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_assessclaim(claimid integer, studentid text, requestcomp boolean, assessorid text, assapproved boolean, option character) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_assessclaim(claimid integer, studentid text, requestcomp boolean, assessorid text, assapproved boolean, option character) FROM postgres;
GRANT ALL ON FUNCTION fn_assessclaim(claimid integer, studentid text, requestcomp boolean, assessorid text, assapproved boolean, option character) TO postgres;
GRANT ALL ON FUNCTION fn_assessclaim(claimid integer, studentid text, requestcomp boolean, assessorid text, assapproved boolean, option character) TO admin;
GRANT ALL ON FUNCTION fn_assessclaim(claimid integer, studentid text, requestcomp boolean, assessorid text, assapproved boolean, option character) TO clerical;
GRANT ALL ON FUNCTION fn_assessclaim(claimid integer, studentid text, requestcomp boolean, assessorid text, assapproved boolean, option character) TO teacher;
GRANT ALL ON FUNCTION fn_assessclaim(claimid integer, studentid text, requestcomp boolean, assessorid text, assapproved boolean, option character) TO student;


--
-- Name: fn_assessevidence(text, integer, text, boolean, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_assessevidence("studentID" text, "claimID" integer, "moduleID" text, approved boolean, "assessorNote" text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_assessevidence("studentID" text, "claimID" integer, "moduleID" text, approved boolean, "assessorNote" text) FROM postgres;
GRANT ALL ON FUNCTION fn_assessevidence("studentID" text, "claimID" integer, "moduleID" text, approved boolean, "assessorNote" text) TO postgres;
GRANT ALL ON FUNCTION fn_assessevidence("studentID" text, "claimID" integer, "moduleID" text, approved boolean, "assessorNote" text) TO admin;
GRANT ALL ON FUNCTION fn_assessevidence("studentID" text, "claimID" integer, "moduleID" text, approved boolean, "assessorNote" text) TO clerical;
GRANT ALL ON FUNCTION fn_assessevidence("studentID" text, "claimID" integer, "moduleID" text, approved boolean, "assessorNote" text) TO teacher;
GRANT ALL ON FUNCTION fn_assessevidence("studentID" text, "claimID" integer, "moduleID" text, approved boolean, "assessorNote" text) TO student;


--
-- Name: fn_assessmodule(text, text, integer, boolean, text, text, boolean, character, character[]); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_assessmodule("moduleID" text, "studentID" text, "claimID" integer, approved boolean, "arrangementNo" text, "functionalCode" text, "overseasEvidence" boolean, recognition character, VARIADIC "prevProvider" character[]) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_assessmodule("moduleID" text, "studentID" text, "claimID" integer, approved boolean, "arrangementNo" text, "functionalCode" text, "overseasEvidence" boolean, recognition character, VARIADIC "prevProvider" character[]) FROM postgres;
GRANT ALL ON FUNCTION fn_assessmodule("moduleID" text, "studentID" text, "claimID" integer, approved boolean, "arrangementNo" text, "functionalCode" text, "overseasEvidence" boolean, recognition character, VARIADIC "prevProvider" character[]) TO postgres;
GRANT ALL ON FUNCTION fn_assessmodule("moduleID" text, "studentID" text, "claimID" integer, approved boolean, "arrangementNo" text, "functionalCode" text, "overseasEvidence" boolean, recognition character, VARIADIC "prevProvider" character[]) TO admin;
GRANT ALL ON FUNCTION fn_assessmodule("moduleID" text, "studentID" text, "claimID" integer, approved boolean, "arrangementNo" text, "functionalCode" text, "overseasEvidence" boolean, recognition character, VARIADIC "prevProvider" character[]) TO clerical;
GRANT ALL ON FUNCTION fn_assessmodule("moduleID" text, "studentID" text, "claimID" integer, approved boolean, "arrangementNo" text, "functionalCode" text, "overseasEvidence" boolean, recognition character, VARIADIC "prevProvider" character[]) TO teacher;
GRANT ALL ON FUNCTION fn_assessmodule("moduleID" text, "studentID" text, "claimID" integer, approved boolean, "arrangementNo" text, "functionalCode" text, "overseasEvidence" boolean, recognition character, VARIADIC "prevProvider" character[]) TO student;


--
-- Name: fn_assignassessor(text, integer, text, text, boolean); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_assignassessor("teacherID" text, "disciplineID" integer, "campusID" text, "courseID" text, "courseCoordinator" boolean) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_assignassessor("teacherID" text, "disciplineID" integer, "campusID" text, "courseID" text, "courseCoordinator" boolean) FROM postgres;
GRANT ALL ON FUNCTION fn_assignassessor("teacherID" text, "disciplineID" integer, "campusID" text, "courseID" text, "courseCoordinator" boolean) TO postgres;
GRANT ALL ON FUNCTION fn_assignassessor("teacherID" text, "disciplineID" integer, "campusID" text, "courseID" text, "courseCoordinator" boolean) TO admin;
GRANT ALL ON FUNCTION fn_assignassessor("teacherID" text, "disciplineID" integer, "campusID" text, "courseID" text, "courseCoordinator" boolean) TO clerical;
GRANT ALL ON FUNCTION fn_assignassessor("teacherID" text, "disciplineID" integer, "campusID" text, "courseID" text, "courseCoordinator" boolean) TO teacher;
GRANT ALL ON FUNCTION fn_assignassessor("teacherID" text, "disciplineID" integer, "campusID" text, "courseID" text, "courseCoordinator" boolean) TO student;


--
-- Name: fn_assigncourse(text, integer, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_assigncourse("courseID" text, "disciplineID" integer, "campusID" text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_assigncourse("courseID" text, "disciplineID" integer, "campusID" text) FROM postgres;
GRANT ALL ON FUNCTION fn_assigncourse("courseID" text, "disciplineID" integer, "campusID" text) TO postgres;
GRANT ALL ON FUNCTION fn_assigncourse("courseID" text, "disciplineID" integer, "campusID" text) TO admin;
GRANT ALL ON FUNCTION fn_assigncourse("courseID" text, "disciplineID" integer, "campusID" text) TO clerical;
GRANT ALL ON FUNCTION fn_assigncourse("courseID" text, "disciplineID" integer, "campusID" text) TO teacher;
GRANT ALL ON FUNCTION fn_assigncourse("courseID" text, "disciplineID" integer, "campusID" text) TO student;


--
-- Name: fn_assigndelegate(text, integer, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_assigndelegate("teacherID" text, "disciplineID" integer, "campusID" text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_assigndelegate("teacherID" text, "disciplineID" integer, "campusID" text) FROM postgres;
GRANT ALL ON FUNCTION fn_assigndelegate("teacherID" text, "disciplineID" integer, "campusID" text) TO postgres;
GRANT ALL ON FUNCTION fn_assigndelegate("teacherID" text, "disciplineID" integer, "campusID" text) TO admin;
GRANT ALL ON FUNCTION fn_assigndelegate("teacherID" text, "disciplineID" integer, "campusID" text) TO clerical;
GRANT ALL ON FUNCTION fn_assigndelegate("teacherID" text, "disciplineID" integer, "campusID" text) TO teacher;
GRANT ALL ON FUNCTION fn_assigndelegate("teacherID" text, "disciplineID" integer, "campusID" text) TO student;


--
-- Name: fn_assigndiscipline(text, integer); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_assigndiscipline("campusID" text, "disciplineID" integer) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_assigndiscipline("campusID" text, "disciplineID" integer) FROM postgres;
GRANT ALL ON FUNCTION fn_assigndiscipline("campusID" text, "disciplineID" integer) TO postgres;
GRANT ALL ON FUNCTION fn_assigndiscipline("campusID" text, "disciplineID" integer) TO admin;
GRANT ALL ON FUNCTION fn_assigndiscipline("campusID" text, "disciplineID" integer) TO clerical;
GRANT ALL ON FUNCTION fn_assigndiscipline("campusID" text, "disciplineID" integer) TO teacher;
GRANT ALL ON FUNCTION fn_assigndiscipline("campusID" text, "disciplineID" integer) TO student;

--
-- Name: fn_assignprovider( integer, text, character); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_assignprovider( "claimID" integer, "moduleID" text, "providerID" character) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_assignprovider( "claimID" integer, "moduleID" text, "providerID" character) FROM postgres;
GRANT ALL ON FUNCTION fn_assignprovider( "claimID" integer, "moduleID" text, "providerID" character) TO postgres;
GRANT ALL ON FUNCTION fn_assignprovider( "claimID" integer, "moduleID" text, "providerID" character) TO admin;
GRANT ALL ON FUNCTION fn_assignprovider( "claimID" integer, "moduleID" text, "providerID" character) TO clerical;
GRANT ALL ON FUNCTION fn_assignprovider( "claimID" integer, "moduleID" text, "providerID" character) TO teacher;
GRANT ALL ON FUNCTION fn_assignprovider( "claimID" integer, "moduleID" text, "providerID" character) TO student;


--
-- Name: fn_checkfordraftclaim(text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_checkfordraftclaim(studentid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_checkfordraftclaim(studentid text) FROM postgres;
GRANT ALL ON FUNCTION fn_checkfordraftclaim(studentid text) TO postgres;
GRANT ALL ON FUNCTION fn_checkfordraftclaim(studentid text) TO admin;
GRANT ALL ON FUNCTION fn_checkfordraftclaim(studentid text) TO clerical;
GRANT ALL ON FUNCTION fn_checkfordraftclaim(studentid text) TO teacher;
GRANT ALL ON FUNCTION fn_checkfordraftclaim(studentid text) TO student;


--
-- Name: fn_deletecampus(text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_deletecampus("campusID" text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_deletecampus("campusID" text) FROM postgres;
GRANT ALL ON FUNCTION fn_deletecampus("campusID" text) TO postgres;
GRANT ALL ON FUNCTION fn_deletecampus("campusID" text) TO admin;
GRANT ALL ON FUNCTION fn_deletecampus("campusID" text) TO clerical;
GRANT ALL ON FUNCTION fn_deletecampus("campusID" text) TO teacher;
GRANT ALL ON FUNCTION fn_deletecampus("campusID" text) TO student;


--
-- Name: fn_deleteclaim(integer, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_deleteclaim(claimid integer, studentid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_deleteclaim(claimid integer, studentid text) FROM postgres;
GRANT ALL ON FUNCTION fn_deleteclaim(claimid integer, studentid text) TO postgres;
GRANT ALL ON FUNCTION fn_deleteclaim(claimid integer, studentid text) TO admin;
GRANT ALL ON FUNCTION fn_deleteclaim(claimid integer, studentid text) TO clerical;
GRANT ALL ON FUNCTION fn_deleteclaim(claimid integer, studentid text) TO teacher;
GRANT ALL ON FUNCTION fn_deleteclaim(claimid integer, studentid text) TO student;


--
-- Name: fn_deleteclaimedmodule(integer, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_deleteclaimedmodule(claimid integer,  moduleid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_deleteclaimedmodule(claimid integer,  moduleid text) FROM postgres;
GRANT ALL ON FUNCTION fn_deleteclaimedmodule(claimid integer,  moduleid text) TO postgres;
GRANT ALL ON FUNCTION fn_deleteclaimedmodule(claimid integer,  moduleid text) TO admin;
GRANT ALL ON FUNCTION fn_deleteclaimedmodule(claimid integer,  moduleid text) TO clerical;
GRANT ALL ON FUNCTION fn_deleteclaimedmodule(claimid integer,  moduleid text) TO teacher;
GRANT ALL ON FUNCTION fn_deleteclaimedmodule(claimid integer,  moduleid text) TO student;


--
-- Name: fn_deletecourse(text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_deletecourse(courseid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_deletecourse(courseid text) FROM postgres;
GRANT ALL ON FUNCTION fn_deletecourse(courseid text) TO postgres;
GRANT ALL ON FUNCTION fn_deletecourse(courseid text) TO admin;
GRANT ALL ON FUNCTION fn_deletecourse(courseid text) TO clerical;
GRANT ALL ON FUNCTION fn_deletecourse(courseid text) TO teacher;
GRANT ALL ON FUNCTION fn_deletecourse(courseid text) TO student;


--
-- Name: fn_deletecriterion(integer, integer); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_deletecriterion(criterionid integer, elementid integer) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_deletecriterion(criterionid integer, elementid integer) FROM postgres;
GRANT ALL ON FUNCTION fn_deletecriterion(criterionid integer, elementid integer) TO postgres;
GRANT ALL ON FUNCTION fn_deletecriterion(criterionid integer, elementid integer) TO admin;
GRANT ALL ON FUNCTION fn_deletecriterion(criterionid integer, elementid integer) TO clerical;
GRANT ALL ON FUNCTION fn_deletecriterion(criterionid integer, elementid integer) TO teacher;
GRANT ALL ON FUNCTION fn_deletecriterion(criterionid integer, elementid integer) TO student;


--
-- Name: fn_deletediscipline(integer); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_deletediscipline(id integer) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_deletediscipline(id integer) FROM postgres;
GRANT ALL ON FUNCTION fn_deletediscipline(id integer) TO postgres;
GRANT ALL ON FUNCTION fn_deletediscipline(id integer) TO admin;
GRANT ALL ON FUNCTION fn_deletediscipline(id integer) TO clerical;
GRANT ALL ON FUNCTION fn_deletediscipline(id integer) TO teacher;
GRANT ALL ON FUNCTION fn_deletediscipline(id integer) TO student;


--
-- Name: fn_deleteelement(integer, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_deleteelement(elementid integer, moduleid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_deleteelement(elementid integer, moduleid text) FROM postgres;
GRANT ALL ON FUNCTION fn_deleteelement(elementid integer, moduleid text) TO postgres;
GRANT ALL ON FUNCTION fn_deleteelement(elementid integer, moduleid text) TO admin;
GRANT ALL ON FUNCTION fn_deleteelement(elementid integer, moduleid text) TO clerical;
GRANT ALL ON FUNCTION fn_deleteelement(elementid integer, moduleid text) TO teacher;
GRANT ALL ON FUNCTION fn_deleteelement(elementid integer, moduleid text) TO student;


--
-- Name: fn_deletemodule(text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_deletemodule(moduleid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_deletemodule(moduleid text) FROM postgres;
GRANT ALL ON FUNCTION fn_deletemodule(moduleid text) TO postgres;
GRANT ALL ON FUNCTION fn_deletemodule(moduleid text) TO admin;
GRANT ALL ON FUNCTION fn_deletemodule(moduleid text) TO clerical;
GRANT ALL ON FUNCTION fn_deletemodule(moduleid text) TO teacher;
GRANT ALL ON FUNCTION fn_deletemodule(moduleid text) TO student;


--
-- Name: fn_deleteprovider(character); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_deleteprovider(providerid character) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_deleteprovider(providerid character) FROM postgres;
GRANT ALL ON FUNCTION fn_deleteprovider(providerid character) TO postgres;
GRANT ALL ON FUNCTION fn_deleteprovider(providerid character) TO admin;
GRANT ALL ON FUNCTION fn_deleteprovider(providerid character) TO clerical;
GRANT ALL ON FUNCTION fn_deleteprovider(providerid character) TO teacher;
GRANT ALL ON FUNCTION fn_deleteprovider(providerid character) TO student;


--
-- Name: fn_deletestudent(text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_deletestudent("studentID" text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_deletestudent("studentID" text) FROM postgres;
GRANT ALL ON FUNCTION fn_deletestudent("studentID" text) TO postgres;
GRANT ALL ON FUNCTION fn_deletestudent("studentID" text) TO admin;
GRANT ALL ON FUNCTION fn_deletestudent("studentID" text) TO clerical;
GRANT ALL ON FUNCTION fn_deletestudent("studentID" text) TO teacher;
GRANT ALL ON FUNCTION fn_deletestudent("studentID" text) TO student;


--
-- Name: fn_deleteteacher(text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_deleteteacher("teacherID" text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_deleteteacher("teacherID" text) FROM postgres;
GRANT ALL ON FUNCTION fn_deleteteacher("teacherID" text) TO postgres;
GRANT ALL ON FUNCTION fn_deleteteacher("teacherID" text) TO admin;
GRANT ALL ON FUNCTION fn_deleteteacher("teacherID" text) TO clerical;
GRANT ALL ON FUNCTION fn_deleteteacher("teacherID" text) TO teacher;
GRANT ALL ON FUNCTION fn_deleteteacher("teacherID" text) TO student;


--
-- Name: fn_deleteuser(text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_deleteuser("userID" text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_deleteuser("userID" text) FROM postgres;
GRANT ALL ON FUNCTION fn_deleteuser("userID" text) TO postgres;
GRANT ALL ON FUNCTION fn_deleteuser("userID" text) TO admin;
GRANT ALL ON FUNCTION fn_deleteuser("userID" text) TO clerical;
GRANT ALL ON FUNCTION fn_deleteuser("userID" text) TO teacher;
GRANT ALL ON FUNCTION fn_deleteuser("userID" text) TO student;


--
-- Name: Campus; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE "Campus" FROM PUBLIC;
REVOKE ALL ON TABLE "Campus" FROM postgres;
GRANT ALL ON TABLE "Campus" TO postgres;
GRANT ALL ON TABLE "Campus" TO admin;
GRANT ALL ON TABLE "Campus" TO clerical;
GRANT ALL ON TABLE "Campus" TO student;
GRANT ALL ON TABLE "Campus" TO teacher;


--
-- Name: fn_getcampusbyid(text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_getcampusbyid(campusid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_getcampusbyid(campusid text) FROM postgres;
GRANT ALL ON FUNCTION fn_getcampusbyid(campusid text) TO postgres;
GRANT ALL ON FUNCTION fn_getcampusbyid(campusid text) TO admin;
GRANT ALL ON FUNCTION fn_getcampusbyid(campusid text) TO clerical;
GRANT ALL ON FUNCTION fn_getcampusbyid(campusid text) TO teacher;
GRANT ALL ON FUNCTION fn_getcampusbyid(campusid text) TO student;


--
-- Name: Claim; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE "Claim" FROM PUBLIC;
REVOKE ALL ON TABLE "Claim" FROM postgres;
GRANT ALL ON TABLE "Claim" TO postgres;
GRANT ALL ON TABLE "Claim" TO admin;
GRANT ALL ON TABLE "Claim" TO clerical;
GRANT ALL ON TABLE "Claim" TO student;
GRANT ALL ON TABLE "Claim" TO teacher;


--
-- Name: fn_getclaimbyid(integer, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_getclaimbyid(claimid integer, studentid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_getclaimbyid(claimid integer, studentid text) FROM postgres;
GRANT ALL ON FUNCTION fn_getclaimbyid(claimid integer, studentid text) TO postgres;
GRANT ALL ON FUNCTION fn_getclaimbyid(claimid integer, studentid text) TO admin;
GRANT ALL ON FUNCTION fn_getclaimbyid(claimid integer, studentid text) TO clerical;
GRANT ALL ON FUNCTION fn_getclaimbyid(claimid integer, studentid text) TO teacher;
GRANT ALL ON FUNCTION fn_getclaimbyid(claimid integer, studentid text) TO student;


--
-- Name: Course; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE "Course" FROM PUBLIC;
REVOKE ALL ON TABLE "Course" FROM postgres;
GRANT ALL ON TABLE "Course" TO postgres;
GRANT ALL ON TABLE "Course" TO admin;
GRANT ALL ON TABLE "Course" TO clerical;
GRANT ALL ON TABLE "Course" TO student;
GRANT ALL ON TABLE "Course" TO teacher;


--
-- Name: fn_getcourse(text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_getcourse(courseid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_getcourse(courseid text) FROM postgres;
GRANT ALL ON FUNCTION fn_getcourse(courseid text) TO postgres;
GRANT ALL ON FUNCTION fn_getcourse(courseid text) TO admin;
GRANT ALL ON FUNCTION fn_getcourse(courseid text) TO clerical;
GRANT ALL ON FUNCTION fn_getcourse(courseid text) TO teacher;
GRANT ALL ON FUNCTION fn_getcourse(courseid text) TO student;


--
-- Name: Criterion; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE "Criterion" FROM PUBLIC;
REVOKE ALL ON TABLE "Criterion" FROM postgres;
GRANT ALL ON TABLE "Criterion" TO postgres;
GRANT ALL ON TABLE "Criterion" TO admin;
GRANT ALL ON TABLE "Criterion" TO clerical;
GRANT ALL ON TABLE "Criterion" TO student;
GRANT ALL ON TABLE "Criterion" TO teacher;


--
-- Name: fn_getcriteria(integer); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_getcriteria(elementid integer) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_getcriteria(elementid integer) FROM postgres;
GRANT ALL ON FUNCTION fn_getcriteria(elementid integer) TO postgres;
GRANT ALL ON FUNCTION fn_getcriteria(elementid integer) TO admin;
GRANT ALL ON FUNCTION fn_getcriteria(elementid integer) TO clerical;
GRANT ALL ON FUNCTION fn_getcriteria(elementid integer) TO teacher;
GRANT ALL ON FUNCTION fn_getcriteria(elementid integer) TO student;


--
-- Name: Discipline; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE "Discipline" FROM PUBLIC;
REVOKE ALL ON TABLE "Discipline" FROM postgres;
GRANT ALL ON TABLE "Discipline" TO postgres;
GRANT ALL ON TABLE "Discipline" TO admin;
GRANT ALL ON TABLE "Discipline" TO clerical;
GRANT ALL ON TABLE "Discipline" TO student;
GRANT ALL ON TABLE "Discipline" TO teacher;


--
-- Name: fn_getdiscipline(integer); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_getdiscipline(disciplineid integer) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_getdiscipline(disciplineid integer) FROM postgres;
GRANT ALL ON FUNCTION fn_getdiscipline(disciplineid integer) TO postgres;
GRANT ALL ON FUNCTION fn_getdiscipline(disciplineid integer) TO admin;
GRANT ALL ON FUNCTION fn_getdiscipline(disciplineid integer) TO clerical;
GRANT ALL ON FUNCTION fn_getdiscipline(disciplineid integer) TO teacher;
GRANT ALL ON FUNCTION fn_getdiscipline(disciplineid integer) TO student;


--
-- Name: Element; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE "Element" FROM PUBLIC;
REVOKE ALL ON TABLE "Element" FROM postgres;
GRANT ALL ON TABLE "Element" TO postgres;
GRANT ALL ON TABLE "Element" TO admin;
GRANT ALL ON TABLE "Element" TO clerical;
GRANT ALL ON TABLE "Element" TO student;
GRANT ALL ON TABLE "Element" TO teacher;


--
-- Name: fn_getelement(text, integer); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_getelement(moduleid text, elementid integer) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_getelement(moduleid text, elementid integer) FROM postgres;
GRANT ALL ON FUNCTION fn_getelement(moduleid text, elementid integer) TO postgres;
GRANT ALL ON FUNCTION fn_getelement(moduleid text, elementid integer) TO admin;
GRANT ALL ON FUNCTION fn_getelement(moduleid text, elementid integer) TO clerical;
GRANT ALL ON FUNCTION fn_getelement(moduleid text, elementid integer) TO teacher;
GRANT ALL ON FUNCTION fn_getelement(moduleid text, elementid integer) TO student;


--
-- Name: Evidence; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE "Evidence" FROM PUBLIC;
REVOKE ALL ON TABLE "Evidence" FROM postgres;
GRANT ALL ON TABLE "Evidence" TO postgres;
GRANT ALL ON TABLE "Evidence" TO admin;
GRANT ALL ON TABLE "Evidence" TO clerical;
GRANT ALL ON TABLE "Evidence" TO student;
GRANT ALL ON TABLE "Evidence" TO teacher;


--
-- Name: fn_getevidence(integer, text, integer); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_getevidence(claimid integer,  moduleid text, elementid integer) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_getevidence(claimid integer,  moduleid text, elementid integer) FROM postgres;
GRANT ALL ON FUNCTION fn_getevidence(claimid integer, moduleid text, elementid integer) TO postgres;
GRANT ALL ON FUNCTION fn_getevidence(claimid integer, moduleid text, elementid integer) TO admin;
GRANT ALL ON FUNCTION fn_getevidence(claimid integer, moduleid text, elementid integer) TO clerical;
GRANT ALL ON FUNCTION fn_getevidence(claimid integer, moduleid text, elementid integer) TO teacher;
GRANT ALL ON FUNCTION fn_getevidence(claimid integer, moduleid text, elementid integer) TO student;


--
-- Name: Module; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE "Module" FROM PUBLIC;
REVOKE ALL ON TABLE "Module" FROM postgres;
GRANT ALL ON TABLE "Module" TO postgres;
GRANT ALL ON TABLE "Module" TO admin;
GRANT ALL ON TABLE "Module" TO clerical;
GRANT ALL ON TABLE "Module" TO student;
GRANT ALL ON TABLE "Module" TO teacher;


--
-- Name: fn_getmodulebyid(text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_getmodulebyid(moduleid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_getmodulebyid(moduleid text) FROM postgres;
GRANT ALL ON FUNCTION fn_getmodulebyid(moduleid text) TO postgres;
GRANT ALL ON FUNCTION fn_getmodulebyid(moduleid text) TO admin;
GRANT ALL ON FUNCTION fn_getmodulebyid(moduleid text) TO clerical;
GRANT ALL ON FUNCTION fn_getmodulebyid(moduleid text) TO teacher;
GRANT ALL ON FUNCTION fn_getmodulebyid(moduleid text) TO student;


--
-- Name: fn_getmoduleelements(text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_getmoduleelements(moduleid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_getmoduleelements(moduleid text) FROM postgres;
GRANT ALL ON FUNCTION fn_getmoduleelements(moduleid text) TO postgres;
GRANT ALL ON FUNCTION fn_getmoduleelements(moduleid text) TO admin;
GRANT ALL ON FUNCTION fn_getmoduleelements(moduleid text) TO clerical;
GRANT ALL ON FUNCTION fn_getmoduleelements(moduleid text) TO teacher;
GRANT ALL ON FUNCTION fn_getmoduleelements(moduleid text) TO student;


--
-- Name: Provider; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE "Provider" FROM PUBLIC;
REVOKE ALL ON TABLE "Provider" FROM postgres;
GRANT ALL ON TABLE "Provider" TO postgres;
GRANT ALL ON TABLE "Provider" TO admin;
GRANT ALL ON TABLE "Provider" TO clerical;
GRANT ALL ON TABLE "Provider" TO student;
GRANT ALL ON TABLE "Provider" TO teacher;


--
-- Name: fn_getprovider(character); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_getprovider(providerid character) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_getprovider(providerid character) FROM postgres;
GRANT ALL ON FUNCTION fn_getprovider(providerid character) TO postgres;
GRANT ALL ON FUNCTION fn_getprovider(providerid character) TO admin;
GRANT ALL ON FUNCTION fn_getprovider(providerid character) TO clerical;
GRANT ALL ON FUNCTION fn_getprovider(providerid character) TO teacher;
GRANT ALL ON FUNCTION fn_getprovider(providerid character) TO student;


--
-- Name: fn_getstudentclaims(text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_getstudentclaims(studentid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_getstudentclaims(studentid text) FROM postgres;
GRANT ALL ON FUNCTION fn_getstudentclaims(studentid text) TO postgres;
GRANT ALL ON FUNCTION fn_getstudentclaims(studentid text) TO admin;
GRANT ALL ON FUNCTION fn_getstudentclaims(studentid text) TO clerical;
GRANT ALL ON FUNCTION fn_getstudentclaims(studentid text) TO teacher;
GRANT ALL ON FUNCTION fn_getstudentclaims(studentid text) TO student;


--
-- Name: Student; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE "Student" FROM PUBLIC;
REVOKE ALL ON TABLE "Student" FROM postgres;
GRANT ALL ON TABLE "Student" TO postgres;
GRANT ALL ON TABLE "Student" TO student;
GRANT ALL ON TABLE "Student" TO clerical;
GRANT ALL ON TABLE "Student" TO teacher;


--
-- Name: User; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE "User" FROM PUBLIC;
REVOKE ALL ON TABLE "User" FROM postgres;
GRANT ALL ON TABLE "User" TO postgres;
GRANT ALL ON TABLE "User" TO student;
GRANT ALL ON TABLE "User" TO admin;
GRANT ALL ON TABLE "User" TO teacher;
GRANT ALL ON TABLE "User" TO clerical;


--
-- Name: vw_StudentUser; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE "vw_StudentUser" FROM PUBLIC;
REVOKE ALL ON TABLE "vw_StudentUser" FROM postgres;
GRANT ALL ON TABLE "vw_StudentUser" TO postgres;
GRANT SELECT ON TABLE "vw_StudentUser" TO student;


--
-- Name: fn_getstudentuser(text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_getstudentuser("studentID" text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_getstudentuser("studentID" text) FROM postgres;
GRANT ALL ON FUNCTION fn_getstudentuser("studentID" text) TO postgres;
GRANT ALL ON FUNCTION fn_getstudentuser("studentID" text) TO admin;
GRANT ALL ON FUNCTION fn_getstudentuser("studentID" text) TO clerical;
GRANT ALL ON FUNCTION fn_getstudentuser("studentID" text) TO teacher;
GRANT ALL ON FUNCTION fn_getstudentuser("studentID" text) TO student;


--
-- Name: Teacher; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE "Teacher" FROM PUBLIC;
REVOKE ALL ON TABLE "Teacher" FROM postgres;
GRANT ALL ON TABLE "Teacher" TO postgres;
GRANT ALL ON TABLE "Teacher" TO admin;
GRANT ALL ON TABLE "Teacher" TO clerical;
GRANT ALL ON TABLE "Teacher" TO student;
GRANT ALL ON TABLE "Teacher" TO teacher;


--
-- Name: vw_TeacherUser; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE "vw_TeacherUser" FROM PUBLIC;
REVOKE ALL ON TABLE "vw_TeacherUser" FROM postgres;
GRANT ALL ON TABLE "vw_TeacherUser" TO postgres;
GRANT SELECT ON TABLE "vw_TeacherUser" TO admin;


--
-- Name: fn_getteacheruser(text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_getteacheruser("teacherID" text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_getteacheruser("teacherID" text) FROM postgres;
GRANT ALL ON FUNCTION fn_getteacheruser("teacherID" text) TO postgres;
GRANT ALL ON FUNCTION fn_getteacheruser("teacherID" text) TO admin;
GRANT ALL ON FUNCTION fn_getteacheruser("teacherID" text) TO clerical;
GRANT ALL ON FUNCTION fn_getteacheruser("teacherID" text) TO teacher;
GRANT ALL ON FUNCTION fn_getteacheruser("teacherID" text) TO student;


--
-- Name: fn_getuserbyid(text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_getuserbyid(userid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_getuserbyid(userid text) FROM postgres;
GRANT ALL ON FUNCTION fn_getuserbyid(userid text) TO postgres;
GRANT ALL ON FUNCTION fn_getuserbyid(userid text) TO admin;
GRANT ALL ON FUNCTION fn_getuserbyid(userid text) TO clerical;
GRANT ALL ON FUNCTION fn_getuserbyid(userid text) TO teacher;
GRANT ALL ON FUNCTION fn_getuserbyid(userid text) TO student;


--
-- Name: fn_insertadmin(text, text, text,text,tex); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_insertadmin("userID" text, password text, "email" text, "firstName" text, "lastName" text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_insertadmin("userID" text, password text, email text, firstName text, lastName text) FROM postgres;
GRANT ALL ON FUNCTION fn_insertadmin("userID" text, password text, email text, firstName text, lastName text) TO postgres;
GRANT ALL ON FUNCTION fn_insertadmin("userID" text, password text, email text, firstName text, lastName text) TO admin;
GRANT ALL ON FUNCTION fn_insertadmin("userID" text, password text, email text, firstName text, lastName text) TO clerical;
GRANT ALL ON FUNCTION fn_insertadmin("userID" text, password text, email text, firstName text, lastName text) TO teacher;
GRANT ALL ON FUNCTION fn_insertadmin("userID" text, password text, email text, firstName text, lastName text) TO student;


--
-- Name: fn_insertassessor(text, text text,, text, text, integer, text, text, boolean); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_insertassessor("teacherID" text, "userID" text, "firstName" text, "lastName" text, email text, "disciplineID" integer, "campusID" text, "courseID" text, "courseCoordinator" boolean) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_insertassessor("teacherID" text,"userID" text, "firstName" text, "lastName" text, email text, "disciplineID" integer, "campusID" text, "courseID" text, "courseCoordinator" boolean) FROM postgres;
GRANT ALL ON FUNCTION fn_insertassessor("teacherID" text,"userID" text, "firstName" text, "lastName" text, email text, "disciplineID" integer, "campusID" text, "courseID" text, "courseCoordinator" boolean) TO postgres;
GRANT ALL ON FUNCTION fn_insertassessor("teacherID" text,"userID" text, "firstName" text, "lastName" text, email text, "disciplineID" integer, "campusID" text, "courseID" text, "courseCoordinator" boolean) TO admin;
GRANT ALL ON FUNCTION fn_insertassessor("teacherID" text,"userID" text, "firstName" text, "lastName" text, email text, "disciplineID" integer, "campusID" text, "courseID" text, "courseCoordinator" boolean) TO clerical;
GRANT ALL ON FUNCTION fn_insertassessor("teacherID" text, "userID" text,"firstName" text, "lastName" text, email text, "disciplineID" integer, "campusID" text, "courseID" text, "courseCoordinator" boolean) TO teacher;
GRANT ALL ON FUNCTION fn_insertassessor("teacherID" text, "userID" text,"firstName" text, "lastName" text, email text, "disciplineID" integer, "campusID" text, "courseID" text, "courseCoordinator" boolean) TO student;


--
-- Name: fn_insertcampus(text, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_insertcampus("campusID" text, name text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_insertcampus("campusID" text, name text) FROM postgres;
GRANT ALL ON FUNCTION fn_insertcampus("campusID" text, name text) TO postgres;
GRANT ALL ON FUNCTION fn_insertcampus("campusID" text, name text) TO admin;
GRANT ALL ON FUNCTION fn_insertcampus("campusID" text, name text) TO clerical;
GRANT ALL ON FUNCTION fn_insertcampus("campusID" text, name text) TO teacher;
GRANT ALL ON FUNCTION fn_insertcampus("campusID" text, name text) TO student;


--
-- Name: fn_insertcampusdiscipline(text, integer); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_insertcampusdiscipline(campusid text, disciplineid integer) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_insertcampusdiscipline(campusid text, disciplineid integer) FROM postgres;
GRANT ALL ON FUNCTION fn_insertcampusdiscipline(campusid text, disciplineid integer) TO postgres;
GRANT ALL ON FUNCTION fn_insertcampusdiscipline(campusid text, disciplineid integer) TO admin;
GRANT ALL ON FUNCTION fn_insertcampusdiscipline(campusid text, disciplineid integer) TO clerical;
GRANT ALL ON FUNCTION fn_insertcampusdiscipline(campusid text, disciplineid integer) TO teacher;
GRANT ALL ON FUNCTION fn_insertcampusdiscipline(campusid text, disciplineid integer) TO student;


--
-- Name: fn_insertclaim(text, text, integer, text, boolean); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_insertclaim(studentid text, campusid text, disciplineid integer, courseid text, claimtype boolean) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_insertclaim(studentid text, campusid text, disciplineid integer, courseid text, claimtype boolean) FROM postgres;
GRANT ALL ON FUNCTION fn_insertclaim(studentid text, campusid text, disciplineid integer, courseid text, claimtype boolean) TO postgres;
GRANT ALL ON FUNCTION fn_insertclaim(studentid text, campusid text, disciplineid integer, courseid text, claimtype boolean) TO admin;
GRANT ALL ON FUNCTION fn_insertclaim(studentid text, campusid text, disciplineid integer, courseid text, claimtype boolean) TO clerical;
GRANT ALL ON FUNCTION fn_insertclaim(studentid text, campusid text, disciplineid integer, courseid text, claimtype boolean) TO teacher;
GRANT ALL ON FUNCTION fn_insertclaim(studentid text, campusid text, disciplineid integer, courseid text, claimtype boolean) TO student;


--
-- Name: fn_insertclaimedmodule(text, integer); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_insertclaimedmodule("moduleID" text,  "claimID" integer) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_insertclaimedmodule("moduleID" text,  "claimID" integer) FROM postgres;
GRANT ALL ON FUNCTION fn_insertclaimedmodule("moduleID" text,  "claimID" integer) TO postgres;
GRANT ALL ON FUNCTION fn_insertclaimedmodule("moduleID" text,  "claimID" integer) TO admin;
GRANT ALL ON FUNCTION fn_insertclaimedmodule("moduleID" text,  "claimID" integer) TO clerical;
GRANT ALL ON FUNCTION fn_insertclaimedmodule("moduleID" text,  "claimID" integer) TO teacher;
GRANT ALL ON FUNCTION fn_insertclaimedmodule("moduleID" text,  "claimID" integer) TO student;


--
-- Name: fn_insertclerical(text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_insertclerical("userID" text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_insertclerical("userID" text) FROM postgres;
GRANT ALL ON FUNCTION fn_insertclerical("userID" text) TO postgres;
GRANT ALL ON FUNCTION fn_insertclerical("userID" text) TO admin;
GRANT ALL ON FUNCTION fn_insertclerical("userID" text) TO clerical;
GRANT ALL ON FUNCTION fn_insertclerical("userID" text) TO teacher;
GRANT ALL ON FUNCTION fn_insertclerical("userID" text) TO student;


--
-- Name: fn_insertcourse(text, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_insertcourse("courseID" text, name text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_insertcourse("courseID" text, name text) FROM postgres;
GRANT ALL ON FUNCTION fn_insertcourse("courseID" text, name text) TO postgres;
GRANT ALL ON FUNCTION fn_insertcourse("courseID" text, name text) TO admin;
GRANT ALL ON FUNCTION fn_insertcourse("courseID" text, name text) TO clerical;
GRANT ALL ON FUNCTION fn_insertcourse("courseID" text, name text) TO teacher;
GRANT ALL ON FUNCTION fn_insertcourse("courseID" text, name text) TO student;


--
-- Name: fn_insertcriterion(integer, text, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_insertcriterion("elementID" integer, description text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_insertcriterion("elementID" integer, description text) FROM postgres;
GRANT ALL ON FUNCTION fn_insertcriterion("elementID" integer, description text) TO postgres;
GRANT ALL ON FUNCTION fn_insertcriterion("elementID" integer, description text) TO admin;
GRANT ALL ON FUNCTION fn_insertcriterion("elementID" integer, description text) TO clerical;
GRANT ALL ON FUNCTION fn_insertcriterion("elementID" integer, description text) TO teacher;
GRANT ALL ON FUNCTION fn_insertcriterion("elementID" integer, description text) TO student;


--
-- Name: fn_insertdelegate(text, text, text, text, text, integer, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_insertdelegate("teacherID" text, "userID" text, "firstName" text, "lastName" text, email text, "disciplineID" integer, "campusID" text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_insertdelegate("teacherID" text, "userID" text, "firstName" text, "lastName" text, email text, "disciplineID" integer, "campusID" text) FROM postgres;
GRANT ALL ON FUNCTION fn_insertdelegate("teacherID" text, "userID" text, "firstName" text, "lastName" text, email text, "disciplineID" integer, "campusID" text) TO postgres;
GRANT ALL ON FUNCTION fn_insertdelegate("teacherID" text, "userID" text, "firstName" text, "lastName" text, email text, "disciplineID" integer, "campusID" text) TO admin;
GRANT ALL ON FUNCTION fn_insertdelegate("teacherID" text, "userID" text, "firstName" text, "lastName" text, email text, "disciplineID" integer, "campusID" text) TO clerical;
GRANT ALL ON FUNCTION fn_insertdelegate("teacherID" text, "userID" text, "firstName" text, "lastName" text, email text, "disciplineID" integer, "campusID" text) TO teacher;
GRANT ALL ON FUNCTION fn_insertdelegate("teacherID" text, "userID" text, "firstName" text, "lastName" text, email text, "disciplineID" integer, "campusID" text) TO student;


--
-- Name: fn_insertdiscipline(text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_insertdiscipline(name text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_insertdiscipline(name text) FROM postgres;
GRANT ALL ON FUNCTION fn_insertdiscipline(name text) TO postgres;
GRANT ALL ON FUNCTION fn_insertdiscipline(name text) TO admin;
GRANT ALL ON FUNCTION fn_insertdiscipline(name text) TO clerical;
GRANT ALL ON FUNCTION fn_insertdiscipline(name text) TO teacher;
GRANT ALL ON FUNCTION fn_insertdiscipline(name text) TO student;


--
-- Name: fn_insertelement(text, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_insertelement("moduleID" text, description text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_insertelement("moduleID" text, description text) FROM postgres;
GRANT ALL ON FUNCTION fn_insertelement("moduleID" text, description text) TO postgres;
GRANT ALL ON FUNCTION fn_insertelement("moduleID" text, description text) TO admin;
GRANT ALL ON FUNCTION fn_insertelement("moduleID" text, description text) TO clerical;
GRANT ALL ON FUNCTION fn_insertelement("moduleID" text, description text) TO teacher;
GRANT ALL ON FUNCTION fn_insertelement("moduleID" text, description text) TO student;


--
-- Name: fn_insertevidence( integer, integer, text, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_insertevidence( "claimID" integer, "elementID" integer, description text, "moduleID" text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_insertevidence( "claimID" integer, "elementID" integer, description text, "moduleID" text) FROM postgres;
GRANT ALL ON FUNCTION fn_insertevidence("claimID" integer, "elementID" integer, description text, "moduleID" text) TO postgres;
GRANT ALL ON FUNCTION fn_insertevidence( "claimID" integer, "elementID" integer, description text, "moduleID" text) TO admin;
GRANT ALL ON FUNCTION fn_insertevidence("claimID" integer, "elementID" integer, description text, "moduleID" text) TO clerical;
GRANT ALL ON FUNCTION fn_insertevidence( "claimID" integer, "elementID" integer, description text, "moduleID" text) TO teacher;
GRANT ALL ON FUNCTION fn_insertevidence("claimID" integer, "elementID" integer, description text, "moduleID" text) TO student;


--
-- Name: fn_insertmodule(text, text, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_insertmodule(text, text, text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_insertmodule(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION fn_insertmodule(text, text, text) TO postgres;
GRANT ALL ON FUNCTION fn_insertmodule(text, text, text) TO admin;
GRANT ALL ON FUNCTION fn_insertmodule(text, text, text) TO clerical;
GRANT ALL ON FUNCTION fn_insertmodule(text, text, text) TO teacher;
GRANT ALL ON FUNCTION fn_insertmodule(text, text, text) TO student;


--
-- Name: fn_insertprovider(character, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_insertprovider("providerID" character, name text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_insertprovider("providerID" character, name text) FROM postgres;
GRANT ALL ON FUNCTION fn_insertprovider("providerID" character, name text) TO postgres;
GRANT ALL ON FUNCTION fn_insertprovider("providerID" character, name text) TO admin;
GRANT ALL ON FUNCTION fn_insertprovider("providerID" character, name text) TO clerical;
GRANT ALL ON FUNCTION fn_insertprovider("providerID" character, name text) TO teacher;
GRANT ALL ON FUNCTION fn_insertprovider("providerID" character, name text) TO student;


--
-- Name: fn_insertstudent("userID" text, "email" text, "firstName" text, "lastName" text, "otherName" text, "addressLine1" text, "addressLine2" text, "town" text, "state" text, "postCode" integer, "phoneNumber" text, "studentID" text, "staff" boolean); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_insertstudent("userID" text, "email" text, "firstName" text, "lastName" text, "otherName" text, "addressLine1" text, "addressLine2" text, "town" text, "state" text, "postCode" integer, "phoneNumber" text, "studentID" text, "staff" boolean) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_insertstudent("userID" text, "email" text, "firstName" text, "lastName" text, "otherName" text, "addressLine1" text, "addressLine2" text, "town" text, "state" text, "postCode" integer, "phoneNumber" text, "studentID" text, "staff" boolean) FROM postgres;
GRANT ALL ON FUNCTION fn_insertstudent("userID" text, "email" text, "firstName" text, "lastName" text, "otherName" text, "addressLine1" text, "addressLine2" text, "town" text, "state" text, "postCode" integer, "phoneNumber" text, "studentID" text, "staff" boolean) TO postgres;
GRANT ALL ON FUNCTION fn_insertstudent("userID" text, "email" text, "firstName" text, "lastName" text, "otherName" text, "addressLine1" text, "addressLine2" text, "town" text, "state" text, "postCode" integer, "phoneNumber" text, "studentID" text, "staff" boolean) TO admin;
GRANT ALL ON FUNCTION fn_insertstudent("userID" text, "email" text, "firstName" text, "lastName" text, "otherName" text, "addressLine1" text, "addressLine2" text, "town" text, "state" text, "postCode" integer, "phoneNumber" text, "studentID" text, "staff" boolean) TO clerical;
GRANT ALL ON FUNCTION fn_insertstudent("userID" text, "email" text, "firstName" text, "lastName" text, "otherName" text, "addressLine1" text, "addressLine2" text, "town" text, "state" text, "postCode" integer, "phoneNumber" text, "studentID" text, "staff" boolean) TO teacher;
GRANT ALL ON FUNCTION fn_insertstudent("userID" text, "email" text, "firstName" text, "lastName" text, "otherName" text, "addressLine1" text, "addressLine2" text, "town" text, "state" text, "postCode" integer, "phoneNumber" text, "studentID" text, "staff" boolean) TO student;


--
-- Name: fn_insertteacher(text, text, text, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_insertteacher("teacherID" text, "userID" text, "firstName" text, "lastName" text, "email" text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_insertteacher("teacherID" text, "userID" text, "firstName" text, "lastName" text, "email" text) FROM postgres;
GRANT ALL ON FUNCTION fn_insertteacher("teacherID" text, "userID" text, "firstName" text, "lastName" text, "email" text) TO postgres;
GRANT ALL ON FUNCTION fn_insertteacher("teacherID" text, "userID" text, "firstName" text, "lastName" text, email text) TO admin;
GRANT ALL ON FUNCTION fn_insertteacher("teacherID" text, "userID" text, "firstName" text, "lastName" text, email text) TO clerical;
GRANT ALL ON FUNCTION fn_insertteacher("teacherID" text, "userID" text, "firstName" text, "lastName" text, email text) TO teacher;
GRANT ALL ON FUNCTION fn_insertteacher("teacherID" text, "userID" text, "firstName" text, "lastName" text, email text) TO student;


--
-- Name: fn_insertuser(text, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_insertuser("userID" text, role text, "email" text, "firstName" text, "lastName" text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_insertuser("userID" text, role text, "email" text, "firstName" text, "lastName" text) FROM postgres;
GRANT ALL ON FUNCTION fn_insertuser("userID" text, role text, "email" text, "firstName" text, "lastName" text) TO postgres;
GRANT ALL ON FUNCTION fn_insertuser("userID" text, role text, "email" text, "firstName" text, "lastName" text) TO admin;
GRANT ALL ON FUNCTION fn_insertuser("userID" text, role text, "email" text, "firstName" text, "lastName" text) TO clerical;
GRANT ALL ON FUNCTION fn_insertuser("userID" text, role text, "email" text, "firstName" text, "lastName" text) TO teacher;
GRANT ALL ON FUNCTION fn_insertuser("userID" text, role text, "email" text, "firstName" text, "lastName" text) TO student;


--
-- Name: fn_insertuser(text, text, character); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_insertuser(text, text, character, text, text, text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_insertuser(text, text, character, text, text, text) FROM postgres;
GRANT ALL ON FUNCTION fn_insertuser(text, text, character, text, text, text) TO postgres;
GRANT ALL ON FUNCTION fn_insertuser(text, text, character, text, text, text) TO admin;
GRANT ALL ON FUNCTION fn_insertuser(text, text, character, text, text, text) TO clerical;
GRANT ALL ON FUNCTION fn_insertuser(text, text, character, text, text, text) TO teacher;
GRANT ALL ON FUNCTION fn_insertuser(text, text, character, text, text, text) TO student;


--
-- Name: Assessor; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE "Assessor" FROM PUBLIC;
REVOKE ALL ON TABLE "Assessor" FROM postgres;
GRANT ALL ON TABLE "Assessor" TO postgres;
GRANT ALL ON TABLE "Assessor" TO admin;
GRANT ALL ON TABLE "Assessor" TO clerical;
GRANT ALL ON TABLE "Assessor" TO student;
GRANT ALL ON TABLE "Assessor" TO teacher;


--
-- Name: fn_listassessors(text, integer, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_listassessors(campusid text, disciplineid integer, courseid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_listassessors(campusid text, disciplineid integer, courseid text) FROM postgres;
GRANT ALL ON FUNCTION fn_listassessors(campusid text, disciplineid integer, courseid text) TO postgres;
GRANT ALL ON FUNCTION fn_listassessors(campusid text, disciplineid integer, courseid text) TO admin;
GRANT ALL ON FUNCTION fn_listassessors(campusid text, disciplineid integer, courseid text) TO clerical;
GRANT ALL ON FUNCTION fn_listassessors(campusid text, disciplineid integer, courseid text) TO teacher;
GRANT ALL ON FUNCTION fn_listassessors(campusid text, disciplineid integer, courseid text) TO student;


--
-- Name: fn_listcampuses(); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_listcampuses() FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_listcampuses() FROM postgres;
GRANT ALL ON FUNCTION fn_listcampuses() TO postgres;
GRANT ALL ON FUNCTION fn_listcampuses() TO admin;
GRANT ALL ON FUNCTION fn_listcampuses() TO clerical;
GRANT ALL ON FUNCTION fn_listcampuses() TO teacher;
GRANT ALL ON FUNCTION fn_listcampuses() TO student;


--
-- Name: ClaimedModule; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE "ClaimedModule" FROM PUBLIC;
REVOKE ALL ON TABLE "ClaimedModule" FROM postgres;
GRANT ALL ON TABLE "ClaimedModule" TO postgres;
GRANT ALL ON TABLE "ClaimedModule" TO admin;
GRANT ALL ON TABLE "ClaimedModule" TO clerical;
GRANT ALL ON TABLE "ClaimedModule" TO student;
GRANT ALL ON TABLE "ClaimedModule" TO teacher;


--
-- Name: vw_ClaimedModule_Module; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE "vw_ClaimedModule_Module" FROM PUBLIC;
REVOKE ALL ON TABLE "vw_ClaimedModule_Module" FROM postgres;
GRANT ALL ON TABLE "vw_ClaimedModule_Module" TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "vw_ClaimedModule_Module" TO admin;
GRANT SELECT ON TABLE "vw_ClaimedModule_Module" TO student;
GRANT SELECT ON TABLE "vw_ClaimedModule_Module" TO teacher;
GRANT SELECT ON TABLE "vw_ClaimedModule_Module" TO clerical;


--
-- Name: fn_listclaimedmodules(integer); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_listclaimedmodules(claimid integer) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_listclaimedmodules(claimid integer) FROM postgres;
GRANT ALL ON FUNCTION fn_listclaimedmodules(claimid integer) TO postgres;
GRANT ALL ON FUNCTION fn_listclaimedmodules(claimid integer) TO admin;
GRANT ALL ON FUNCTION fn_listclaimedmodules(claimid integer) TO clerical;
GRANT ALL ON FUNCTION fn_listclaimedmodules(claimid integer) TO teacher;
GRANT ALL ON FUNCTION fn_listclaimedmodules(claimid integer) TO student;


--
-- Name: fn_listclaimsbystudent(text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_listclaimsbystudent(studentid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_listclaimsbystudent(studentid text) FROM postgres;
GRANT ALL ON FUNCTION fn_listclaimsbystudent(studentid text) TO postgres;
GRANT ALL ON FUNCTION fn_listclaimsbystudent(studentid text) TO admin;
GRANT ALL ON FUNCTION fn_listclaimsbystudent(studentid text) TO clerical;
GRANT ALL ON FUNCTION fn_listclaimsbystudent(studentid text) TO teacher;
GRANT ALL ON FUNCTION fn_listclaimsbystudent(studentid text) TO student;


--
-- Name: fn_listclaimsbyteacher(text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_listclaimsbyteacher(teacherid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_listclaimsbyteacher(teacherid text) FROM postgres;
GRANT ALL ON FUNCTION fn_listclaimsbyteacher(teacherid text) TO postgres;
GRANT ALL ON FUNCTION fn_listclaimsbyteacher(teacherid text) TO admin;
GRANT ALL ON FUNCTION fn_listclaimsbyteacher(teacherid text) TO clerical;
GRANT ALL ON FUNCTION fn_listclaimsbyteacher(teacherid text) TO teacher;
GRANT ALL ON FUNCTION fn_listclaimsbyteacher(teacherid text) TO student;


--
-- Name: fn_listcourses(); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_listcourses() FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_listcourses() FROM postgres;
GRANT ALL ON FUNCTION fn_listcourses() TO postgres;
GRANT ALL ON FUNCTION fn_listcourses() TO admin;
GRANT ALL ON FUNCTION fn_listcourses() TO clerical;
GRANT ALL ON FUNCTION fn_listcourses() TO teacher;
GRANT ALL ON FUNCTION fn_listcourses() TO student;


--
-- Name: fn_listcourses(text, integer); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_listcourses("campusID" text, "disciplineID" integer) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_listcourses("campusID" text, "disciplineID" integer) FROM postgres;
GRANT ALL ON FUNCTION fn_listcourses("campusID" text, "disciplineID" integer) TO postgres;
GRANT ALL ON FUNCTION fn_listcourses("campusID" text, "disciplineID" integer) TO admin;
GRANT ALL ON FUNCTION fn_listcourses("campusID" text, "disciplineID" integer) TO clerical;
GRANT ALL ON FUNCTION fn_listcourses("campusID" text, "disciplineID" integer) TO teacher;
GRANT ALL ON FUNCTION fn_listcourses("campusID" text, "disciplineID" integer) TO student;


--
-- Name: fn_listcoursesnotindiscipline(text, integer); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_listcoursesnotindiscipline(campusid text, disciplineid integer) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_listcoursesnotindiscipline(campusid text, disciplineid integer) FROM postgres;
GRANT ALL ON FUNCTION fn_listcoursesnotindiscipline(campusid text, disciplineid integer) TO postgres;
GRANT ALL ON FUNCTION fn_listcoursesnotindiscipline(campusid text, disciplineid integer) TO admin;
GRANT ALL ON FUNCTION fn_listcoursesnotindiscipline(campusid text, disciplineid integer) TO clerical;
GRANT ALL ON FUNCTION fn_listcoursesnotindiscipline(campusid text, disciplineid integer) TO teacher;
GRANT ALL ON FUNCTION fn_listcoursesnotindiscipline(campusid text, disciplineid integer) TO student;


--
-- Name: fn_listcriteria(integer); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_listcriteria(elementid integer) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_listcriteria(elementid integer) FROM postgres;
GRANT ALL ON FUNCTION fn_listcriteria(elementid integer) TO postgres;
GRANT ALL ON FUNCTION fn_listcriteria(elementid integer) TO admin;
GRANT ALL ON FUNCTION fn_listcriteria(elementid integer) TO clerical;
GRANT ALL ON FUNCTION fn_listcriteria(elementid integer) TO teacher;
GRANT ALL ON FUNCTION fn_listcriteria(elementid integer) TO student;


--
-- Name: fn_listdelegates(text, integer); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_listdelegates("campusID" text, "disciplineID" integer) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_listdelegates("campusID" text, "disciplineID" integer) FROM postgres;
GRANT ALL ON FUNCTION fn_listdelegates("campusID" text, "disciplineID" integer) TO postgres;
GRANT ALL ON FUNCTION fn_listdelegates("campusID" text, "disciplineID" integer) TO admin;
GRANT ALL ON FUNCTION fn_listdelegates("campusID" text, "disciplineID" integer) TO clerical;
GRANT ALL ON FUNCTION fn_listdelegates("campusID" text, "disciplineID" integer) TO teacher;
GRANT ALL ON FUNCTION fn_listdelegates("campusID" text, "disciplineID" integer) TO student;


--
-- Name: fn_listdisciplines(); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_listdisciplines() FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_listdisciplines() FROM postgres;
GRANT ALL ON FUNCTION fn_listdisciplines() TO postgres;
GRANT ALL ON FUNCTION fn_listdisciplines() TO admin;
GRANT ALL ON FUNCTION fn_listdisciplines() TO clerical;
GRANT ALL ON FUNCTION fn_listdisciplines() TO teacher;
GRANT ALL ON FUNCTION fn_listdisciplines() TO student;


--
-- Name: fn_listdisciplines(text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_listdisciplines("campusID" text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_listdisciplines("campusID" text) FROM postgres;
GRANT ALL ON FUNCTION fn_listdisciplines("campusID" text) TO postgres;
GRANT ALL ON FUNCTION fn_listdisciplines("campusID" text) TO admin;
GRANT ALL ON FUNCTION fn_listdisciplines("campusID" text) TO clerical;
GRANT ALL ON FUNCTION fn_listdisciplines("campusID" text) TO teacher;
GRANT ALL ON FUNCTION fn_listdisciplines("campusID" text) TO student;


--
-- Name: fn_listdisciplinesnotincampus(text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_listdisciplinesnotincampus(campusid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_listdisciplinesnotincampus(campusid text) FROM postgres;
GRANT ALL ON FUNCTION fn_listdisciplinesnotincampus(campusid text) TO postgres;
GRANT ALL ON FUNCTION fn_listdisciplinesnotincampus(campusid text) TO admin;
GRANT ALL ON FUNCTION fn_listdisciplinesnotincampus(campusid text) TO clerical;
GRANT ALL ON FUNCTION fn_listdisciplinesnotincampus(campusid text) TO teacher;
GRANT ALL ON FUNCTION fn_listdisciplinesnotincampus(campusid text) TO student;

--
-- Name: fn_listevidence( integer, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_listevidence( claimid integer, moduleid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_listevidence( claimid integer, moduleid text) FROM postgres;
GRANT ALL ON FUNCTION fn_listevidence( claimid integer, moduleid text) TO postgres;
GRANT ALL ON FUNCTION fn_listevidence( claimid integer, moduleid text) TO admin;
GRANT ALL ON FUNCTION fn_listevidence( claimid integer, moduleid text) TO clerical;
GRANT ALL ON FUNCTION fn_listevidence( claimid integer, moduleid text) TO teacher;
GRANT ALL ON FUNCTION fn_listevidence( claimid integer, moduleid text) TO student;


--
-- Name: fn_listmodules(); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_listmodules() FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_listmodules() FROM postgres;
GRANT ALL ON FUNCTION fn_listmodules() TO postgres;
GRANT ALL ON FUNCTION fn_listmodules() TO admin;
GRANT ALL ON FUNCTION fn_listmodules() TO clerical;
GRANT ALL ON FUNCTION fn_listmodules() TO teacher;
GRANT ALL ON FUNCTION fn_listmodules() TO student;


--
-- Name: fn_listproviders(); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_listproviders() FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_listproviders() FROM postgres;
GRANT ALL ON FUNCTION fn_listproviders() TO postgres;
GRANT ALL ON FUNCTION fn_listproviders() TO admin;
GRANT ALL ON FUNCTION fn_listproviders() TO clerical;
GRANT ALL ON FUNCTION fn_listproviders() TO teacher;
GRANT ALL ON FUNCTION fn_listproviders() TO student;


--
-- Name: fn_listproviders(integer,  text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_listproviders(claimid integer, moduleid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_listproviders(claimid integer, moduleid text) FROM postgres;
GRANT ALL ON FUNCTION fn_listproviders(claimid integer,  moduleid text) TO postgres;
GRANT ALL ON FUNCTION fn_listproviders(claimid integer,  moduleid text) TO admin;
GRANT ALL ON FUNCTION fn_listproviders(claimid integer,  moduleid text) TO clerical;
GRANT ALL ON FUNCTION fn_listproviders(claimid integer,  moduleid text) TO teacher;
GRANT ALL ON FUNCTION fn_listproviders(claimid integer,  moduleid text) TO student;


--
-- Name: fn_listteacherandadminusers(); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_listteacherandadminusers() FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_listteacherandadminusers() FROM postgres;
GRANT ALL ON FUNCTION fn_listteacherandadminusers() TO postgres;
GRANT ALL ON FUNCTION fn_listteacherandadminusers() TO admin;
GRANT ALL ON FUNCTION fn_listteacherandadminusers() TO clerical;
GRANT ALL ON FUNCTION fn_listteacherandadminusers() TO teacher;
GRANT ALL ON FUNCTION fn_listteacherandadminusers() TO student;


--
-- Name: fn_removecoursefromdiscipline(text, integer, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_removecoursefromdiscipline(campusid text, disciplineid integer, courseid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_removecoursefromdiscipline(campusid text, disciplineid integer, courseid text) FROM postgres;
GRANT ALL ON FUNCTION fn_removecoursefromdiscipline(campusid text, disciplineid integer, courseid text) TO postgres;
GRANT ALL ON FUNCTION fn_removecoursefromdiscipline(campusid text, disciplineid integer, courseid text) TO admin;
GRANT ALL ON FUNCTION fn_removecoursefromdiscipline(campusid text, disciplineid integer, courseid text) TO clerical;
GRANT ALL ON FUNCTION fn_removecoursefromdiscipline(campusid text, disciplineid integer, courseid text) TO teacher;
GRANT ALL ON FUNCTION fn_removecoursefromdiscipline(campusid text, disciplineid integer, courseid text) TO student;

--
-- Name: fn_resetpassword(text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_resetpassword(userid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_resetpassword(userid text) FROM postgres;
GRANT ALL ON FUNCTION fn_resetpassword(userid text) TO postgres;
GRANT ALL ON FUNCTION fn_resetpassword(userid text) TO admin;
GRANT ALL ON FUNCTION fn_resetpassword(userid text) TO clerical;
GRANT ALL ON FUNCTION fn_resetpassword(userid text) TO teacher;
GRANT ALL ON FUNCTION fn_resetpassword(userid text) TO student;


--
-- Name: fn_submitclaim(integer, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_submitclaim(claimid integer, studentid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_submitclaim(claimid integer, studentid text) FROM postgres;
GRANT ALL ON FUNCTION fn_submitclaim(claimid integer, studentid text) TO postgres;
GRANT ALL ON FUNCTION fn_submitclaim(claimid integer, studentid text) TO admin;
GRANT ALL ON FUNCTION fn_submitclaim(claimid integer, studentid text) TO clerical;
GRANT ALL ON FUNCTION fn_submitclaim(claimid integer, studentid text) TO teacher;
GRANT ALL ON FUNCTION fn_submitclaim(claimid integer, studentid text) TO student;


--
-- Name: fn_updatecampus(text, text, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_updatecampus("oldID" text, "campusID" text, name text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_updatecampus("oldID" text, "campusID" text, name text) FROM postgres;
GRANT ALL ON FUNCTION fn_updatecampus("oldID" text, "campusID" text, name text) TO postgres;
GRANT ALL ON FUNCTION fn_updatecampus("oldID" text, "campusID" text, name text) TO admin;
GRANT ALL ON FUNCTION fn_updatecampus("oldID" text, "campusID" text, name text) TO clerical;
GRANT ALL ON FUNCTION fn_updatecampus("oldID" text, "campusID" text, name text) TO teacher;
GRANT ALL ON FUNCTION fn_updatecampus("oldID" text, "campusID" text, name text) TO student;


--
-- Name: fn_updateclaim(integer, text, text, integer, boolean); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_updateclaim(claimid integer, studentid text, campusid text, disciplineid integer, option boolean) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_updateclaim(claimid integer, studentid text, campusid text, disciplineid integer, option boolean) FROM postgres;
GRANT ALL ON FUNCTION fn_updateclaim(claimid integer, studentid text, campusid text, disciplineid integer, option boolean) TO postgres;
GRANT ALL ON FUNCTION fn_updateclaim(claimid integer, studentid text, campusid text, disciplineid integer, option boolean) TO admin;
GRANT ALL ON FUNCTION fn_updateclaim(claimid integer, studentid text, campusid text, disciplineid integer, option boolean) TO clerical;
GRANT ALL ON FUNCTION fn_updateclaim(claimid integer, studentid text, campusid text, disciplineid integer, option boolean) TO teacher;
GRANT ALL ON FUNCTION fn_updateclaim(claimid integer, studentid text, campusid text, disciplineid integer, option boolean) TO student;


--
-- Name: fn_updateclaim(integer, text, boolean, boolean, boolean, boolean, date, text, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_updateclaim(claimid integer, studentid text, assessorapproved boolean, delegateapproved boolean, option boolean, requestcomp boolean, dateresolved date, assessorid text, delegateid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_updateclaim(claimid integer, studentid text, assessorapproved boolean, delegateapproved boolean, option boolean, requestcomp boolean, dateresolved date, assessorid text, delegateid text) FROM postgres;
GRANT ALL ON FUNCTION fn_updateclaim(claimid integer, studentid text, assessorapproved boolean, delegateapproved boolean, option boolean, requestcomp boolean, dateresolved date, assessorid text, delegateid text) TO postgres;
GRANT ALL ON FUNCTION fn_updateclaim(claimid integer, studentid text, assessorapproved boolean, delegateapproved boolean, option boolean, requestcomp boolean, dateresolved date, assessorid text, delegateid text) TO admin;
GRANT ALL ON FUNCTION fn_updateclaim(claimid integer, studentid text, assessorapproved boolean, delegateapproved boolean, option boolean, requestcomp boolean, dateresolved date, assessorid text, delegateid text) TO clerical;
GRANT ALL ON FUNCTION fn_updateclaim(claimid integer, studentid text, assessorapproved boolean, delegateapproved boolean, option boolean, requestcomp boolean, dateresolved date, assessorid text, delegateid text) TO teacher;
GRANT ALL ON FUNCTION fn_updateclaim(claimid integer, studentid text, assessorapproved boolean, delegateapproved boolean, option boolean, requestcomp boolean, dateresolved date, assessorid text, delegateid text) TO student;


--
-- Name: fn_updateclaimedmodule(integer,  text, boolean, text, text, boolean, character); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_updateclaimedmodule(claimid integer,  moduleid text, approved boolean, arrangementno text, functionalcode text, overseasevidence boolean, recognition character) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_updateclaimedmodule(claimid integer,  moduleid text, approved boolean, arrangementno text, functionalcode text, overseasevidence boolean, recognition character) FROM postgres;
GRANT ALL ON FUNCTION fn_updateclaimedmodule(claimid integer,  moduleid text, approved boolean, arrangementno text, functionalcode text, overseasevidence boolean, recognition character) TO postgres;
GRANT ALL ON FUNCTION fn_updateclaimedmodule(claimid integer,  moduleid text, approved boolean, arrangementno text, functionalcode text, overseasevidence boolean, recognition character) TO admin;
GRANT ALL ON FUNCTION fn_updateclaimedmodule(claimid integer,  moduleid text, approved boolean, arrangementno text, functionalcode text, overseasevidence boolean, recognition character) TO clerical;
GRANT ALL ON FUNCTION fn_updateclaimedmodule(claimid integer,  moduleid text, approved boolean, arrangementno text, functionalcode text, overseasevidence boolean, recognition character) TO teacher;
GRANT ALL ON FUNCTION fn_updateclaimedmodule(claimid integer,  moduleid text, approved boolean, arrangementno text, functionalcode text, overseasevidence boolean, recognition character) TO student;


--
-- Name: fn_updatecourse(text, text, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_updatecourse(oldid text, courseid text, name text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_updatecourse(oldid text, courseid text, name text) FROM postgres;
GRANT ALL ON FUNCTION fn_updatecourse(oldid text, courseid text, name text) TO postgres;
GRANT ALL ON FUNCTION fn_updatecourse(oldid text, courseid text, name text) TO admin;
GRANT ALL ON FUNCTION fn_updatecourse(oldid text, courseid text, name text) TO clerical;
GRANT ALL ON FUNCTION fn_updatecourse(oldid text, courseid text, name text) TO teacher;
GRANT ALL ON FUNCTION fn_updatecourse(oldid text, courseid text, name text) TO student;


--
-- Name: fn_updatecriterion(integer, integer,  text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_updatecriterion(criterionid integer, elementid integer,  description text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_updatecriterion(criterionid integer, elementid integer,  description text) FROM postgres;
GRANT ALL ON FUNCTION fn_updatecriterion(criterionid integer, elementid integer,  description text) TO postgres;
GRANT ALL ON FUNCTION fn_updatecriterion(criterionid integer, elementid integer,  description text) TO admin;
GRANT ALL ON FUNCTION fn_updatecriterion(criterionid integer, elementid integer,  description text) TO clerical;
GRANT ALL ON FUNCTION fn_updatecriterion(criterionid integer, elementid integer,  description text) TO teacher;
GRANT ALL ON FUNCTION fn_updatecriterion(criterionid integer, elementid integer,  description text) TO student;


--
-- Name: fn_updatediscipline(integer, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_updatediscipline(id integer, name text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_updatediscipline(id integer, name text) FROM postgres;
GRANT ALL ON FUNCTION fn_updatediscipline(id integer, name text) TO postgres;
GRANT ALL ON FUNCTION fn_updatediscipline(id integer, name text) TO admin;
GRANT ALL ON FUNCTION fn_updatediscipline(id integer, name text) TO clerical;
GRANT ALL ON FUNCTION fn_updatediscipline(id integer, name text) TO teacher;
GRANT ALL ON FUNCTION fn_updatediscipline(id integer, name text) TO student;


--
-- Name: fn_updateelement(integer, text, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_updateelement(elementid integer, moduleid text, description text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_updateelement(elementid integer, moduleid text, description text) FROM postgres;
GRANT ALL ON FUNCTION fn_updateelement(elementid integer, moduleid text, description text) TO postgres;
GRANT ALL ON FUNCTION fn_updateelement(elementid integer, moduleid text, description text) TO admin;
GRANT ALL ON FUNCTION fn_updateelement(elementid integer, moduleid text, description text) TO clerical;
GRANT ALL ON FUNCTION fn_updateelement(elementid integer, moduleid text, description text) TO teacher;
GRANT ALL ON FUNCTION fn_updateelement(elementid integer, moduleid text, description text) TO student;


--
-- Name: fn_updateevidence( integer, text, text, boolean, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_updateevidence( claimid integer, moduleid text, description text, approved boolean, assessornote text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_updateevidence( claimid integer, moduleid text, description text, approved boolean, assessornote text) FROM postgres;
GRANT ALL ON FUNCTION fn_updateevidence( claimid integer, moduleid text, description text, approved boolean, assessornote text) TO postgres;
GRANT ALL ON FUNCTION fn_updateevidence( claimid integer, moduleid text, description text, approved boolean, assessornote text) TO admin;
GRANT ALL ON FUNCTION fn_updateevidence( claimid integer, moduleid text, description text, approved boolean, assessornote text) TO clerical;
GRANT ALL ON FUNCTION fn_updateevidence( claimid integer, moduleid text, description text, approved boolean, assessornote text) TO teacher;
GRANT ALL ON FUNCTION fn_updateevidence( claimid integer, moduleid text, description text, approved boolean, assessornote text) TO student;


--
-- Name: fn_updatemodule(text, text, text, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_updatemodule(oldid text, moduleid text, name text, instructions text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_updatemodule(oldid text, moduleid text, name text, instructions text) FROM postgres;
GRANT ALL ON FUNCTION fn_updatemodule(oldid text, moduleid text, name text, instructions text) TO postgres;
GRANT ALL ON FUNCTION fn_updatemodule(oldid text, moduleid text, name text, instructions text) TO admin;
GRANT ALL ON FUNCTION fn_updatemodule(oldid text, moduleid text, name text, instructions text) TO clerical;
GRANT ALL ON FUNCTION fn_updatemodule(oldid text, moduleid text, name text, instructions text) TO teacher;
GRANT ALL ON FUNCTION fn_updatemodule(oldid text, moduleid text, name text, instructions text) TO student;


--
-- Name: fn_updatestudent(text, text, text, text, text, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_updatestudent(oldid text, newid text, firstname text, lastname text, email text, password text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_updatestudent(oldid text, newid text, firstname text, lastname text, email text, password text) FROM postgres;
GRANT ALL ON FUNCTION fn_updatestudent(oldid text, newid text, firstname text, lastname text, email text, password text) TO postgres;
GRANT ALL ON FUNCTION fn_updatestudent(oldid text, newid text, firstname text, lastname text, email text, password text) TO admin;
GRANT ALL ON FUNCTION fn_updatestudent(oldid text, newid text, firstname text, lastname text, email text, password text) TO clerical;
GRANT ALL ON FUNCTION fn_updatestudent(oldid text, newid text, firstname text, lastname text, email text, password text) TO teacher;
GRANT ALL ON FUNCTION fn_updatestudent(oldid text, newid text, firstname text, lastname text, email text, password text) TO student;


--
-- Name: fn_updateteacher(text, text, text, text, text, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_updateteacher(oldid text, newid text, firstname text, lastname text, email text, password text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_updateteacher(oldid text, newid text, firstname text, lastname text, email text, password text) FROM postgres;
GRANT ALL ON FUNCTION fn_updateteacher(oldid text, newid text, firstname text, lastname text, email text, password text) TO postgres;
GRANT ALL ON FUNCTION fn_updateteacher(oldid text, newid text, firstname text, lastname text, email text, password text) TO admin;
GRANT ALL ON FUNCTION fn_updateteacher(oldid text, newid text, firstname text, lastname text, email text, password text) TO clerical;
GRANT ALL ON FUNCTION fn_updateteacher(oldid text, newid text, firstname text, lastname text, email text, password text) TO teacher;
GRANT ALL ON FUNCTION fn_updateteacher(oldid text, newid text, firstname text, lastname text, email text, password text) TO student;


--
-- Name: fn_updateuser(text, text, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_updateuser(oldid text, newid text, password text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_updateuser(oldid text, newid text, password text) FROM postgres;
GRANT ALL ON FUNCTION fn_updateuser(oldid text, newid text, password text) TO postgres;
GRANT ALL ON FUNCTION fn_updateuser(oldid text, newid text, password text) TO admin;
GRANT ALL ON FUNCTION fn_updateuser(oldid text, newid text, password text) TO clerical;
GRANT ALL ON FUNCTION fn_updateuser(oldid text, newid text, password text) TO teacher;
GRANT ALL ON FUNCTION fn_updateuser(oldid text, newid text, password text) TO student;


--
-- Name: fn_verifylogin(text, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_verifylogin("userID" text, password text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_verifylogin("userID" text, password text) FROM postgres;
GRANT ALL ON FUNCTION fn_verifylogin("userID" text, password text) TO postgres;
GRANT ALL ON FUNCTION fn_verifylogin("userID" text, password text) TO admin;
GRANT ALL ON FUNCTION fn_verifylogin("userID" text, password text) TO clerical;
GRANT ALL ON FUNCTION fn_verifylogin("userID" text, password text) TO teacher;
GRANT ALL ON FUNCTION fn_verifylogin("userID" text, password text) TO student;

--
-- Name: fn_updateuser(text, text, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_listmodulesnotinacourse("courseID" text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_listmodulesnotinacourse("courseID" text) FROM postgres;
GRANT ALL ON FUNCTION fn_listmodulesnotinacourse("courseID" text) TO postgres;
GRANT ALL ON FUNCTION fn_listmodulesnotinacourse("courseID" text) TO admin;
GRANT ALL ON FUNCTION fn_listmodulesnotinacourse("courseID" text) TO clerical;
GRANT ALL ON FUNCTION fn_listmodulesnotinacourse("courseID" text) TO teacher;
GRANT ALL ON FUNCTION fn_listmodulesnotinacourse("courseID" text) TO student;

--
-- Name: fn_updateuser(text, text, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_listmodulesnotinanycourse() FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_listmodulesnotinanycourse() FROM postgres;
GRANT ALL ON FUNCTION fn_listmodulesnotinanycourse() TO postgres;
GRANT ALL ON FUNCTION fn_listmodulesnotinanycourse() TO admin;
GRANT ALL ON FUNCTION fn_listmodulesnotinanycourse() TO clerical;
GRANT ALL ON FUNCTION fn_listmodulesnotinanycourse() TO teacher;
GRANT ALL ON FUNCTION fn_listmodulesnotinanycourse() TO student;


--
-- Name: CampusDiscipline; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE "CampusDiscipline" FROM PUBLIC;
REVOKE ALL ON TABLE "CampusDiscipline" FROM postgres;
GRANT ALL ON TABLE "CampusDiscipline" TO postgres;
GRANT ALL ON TABLE "CampusDiscipline" TO admin;
GRANT ALL ON TABLE "CampusDiscipline" TO clerical;
GRANT ALL ON TABLE "CampusDiscipline" TO student;
GRANT ALL ON TABLE "CampusDiscipline" TO teacher;


--
-- Name: CampusDisciplineCourse; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE "CampusDisciplineCourse" FROM PUBLIC;
REVOKE ALL ON TABLE "CampusDisciplineCourse" FROM postgres;
GRANT ALL ON TABLE "CampusDisciplineCourse" TO postgres;
GRANT ALL ON TABLE "CampusDisciplineCourse" TO admin;
GRANT ALL ON TABLE "CampusDisciplineCourse" TO clerical;
GRANT ALL ON TABLE "CampusDisciplineCourse" TO student;
GRANT ALL ON TABLE "CampusDisciplineCourse" TO teacher;


--
-- Name: ClaimedModuleProvider; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE "ClaimedModuleProvider" FROM PUBLIC;
REVOKE ALL ON TABLE "ClaimedModuleProvider" FROM postgres;
GRANT ALL ON TABLE "ClaimedModuleProvider" TO postgres;
GRANT ALL ON TABLE "ClaimedModuleProvider" TO admin;
GRANT ALL ON TABLE "ClaimedModuleProvider" TO clerical;
GRANT ALL ON TABLE "ClaimedModuleProvider" TO student;
GRANT ALL ON TABLE "ClaimedModuleProvider" TO teacher;


--
-- Name: Delegate; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE "Delegate" FROM PUBLIC;
REVOKE ALL ON TABLE "Delegate" FROM postgres;
GRANT ALL ON TABLE "Delegate" TO postgres;
GRANT ALL ON TABLE "Delegate" TO admin;
GRANT ALL ON TABLE "Delegate" TO clerical;
GRANT ALL ON TABLE "Delegate" TO student;
GRANT ALL ON TABLE "Delegate" TO teacher;

--
-- Name: CampusDisciplineCourse; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE "CourseModule" FROM PUBLIC;
REVOKE ALL ON TABLE "CourseModule" FROM postgres;
GRANT ALL ON TABLE "CourseModule" TO postgres;
GRANT ALL ON TABLE "CourseModule" TO admin;
GRANT ALL ON TABLE "CourseModule" TO clerical;
GRANT ALL ON TABLE "CourseModule" TO student;
GRANT ALL ON TABLE "CourseModule" TO teacher;


--
-- Name: vw_StudentUser; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE "vw_ModulesInCourse" FROM PUBLIC;
REVOKE ALL ON TABLE "vw_ModulesInCourse" FROM postgres;
GRANT ALL ON TABLE "vw_ModulesInCourse" TO postgres;
GRANT SELECT ON TABLE "vw_ModulesInCourse" TO student;

--
-- Name: vw_StudentUser; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE "vw_ModulesOutOfCourse" FROM PUBLIC;
REVOKE ALL ON TABLE "vw_ModulesOutOfCourse" FROM postgres;
GRANT ALL ON TABLE "vw_ModulesOutOfCourse" TO postgres;
GRANT SELECT ON TABLE "vw_ModulesOutOfCourse" TO student;




--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: -; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres REVOKE ALL ON FUNCTIONS  FROM PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres REVOKE ALL ON FUNCTIONS  FROM postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON FUNCTIONS  TO admin;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON FUNCTIONS  TO clerical;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON FUNCTIONS  TO teacher;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON FUNCTIONS  TO student;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: -; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres REVOKE ALL ON TABLES  FROM PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres REVOKE ALL ON TABLES  FROM postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT SELECT,INSERT,DELETE,UPDATE ON TABLES  TO admin;
