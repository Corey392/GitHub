--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: RPL_DB; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE "RPL_2012" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'English, Australia' LC_CTYPE = 'English, Australia';


\connect "RPL_2012"

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: RPL_DB; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON DATABASE "RPL_2012" IS 'Database for the RPL Project. Created 17/06/11 by Adam Shortall.';


--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: -
--

CREATE OR REPLACE PROCEDURAL LANGUAGE plpgsql;


SET search_path = public, pg_catalog;

--
-- Name: fn_addcore(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_addcore(courseid text, moduleid text) RETURNS void
    LANGUAGE sql
    AS $_$
    INSERT INTO "Core"("courseID", "moduleID") 
    VALUES($1, $2);

    DELETE FROM "Elective" 
    WHERE "courseID" = $1 AND "moduleID" = $2;
$_$;


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
-- Name: fn_addelective(text, integer, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_addelective(campusid text, disciplineid integer, courseid text, moduleid text) RETURNS void
    LANGUAGE sql
    AS $_$
    INSERT INTO "Elective"("campusID", "disciplineID", "courseID", "moduleID")
    VALUES($1, $2, $3, $4);
$_$;


--
-- Name: fn_addprovidertoclaimedmodule(text, integer, text, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_addprovidertoclaimedmodule(studentid text, claimid integer, moduleid text, providerid character) RETURNS void
    LANGUAGE sql
    AS $_$
    INSERT INTO "ClaimedModuleProvider"("studentID", "claimID", "moduleID", "providerID")
    VALUES($1, $2, $3, $4);
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
		WHERE "studentID" = $1 AND "claimID" = $2 AND "moduleID" = $3;
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
-- Name: fn_assigncore(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_assigncore("moduleID" text, "courseID" text) RETURNS void
    LANGUAGE sql
    AS $_$
	INSERT INTO "Core"("moduleID", "courseID")
	VALUES($1,$2)
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
-- Name: fn_assignelective(text, text, integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_assignelective("moduleID" text, "courseID" text, "disciplineID" integer, "campusID" text) RETURNS void
    LANGUAGE sql
    AS $_$
	INSERT INTO "Elective"("moduleID", "courseID", "disciplineID", "campusID")
	VALUES($1,$2,$3,$4)
$_$;


--
-- Name: fn_assignprovider(text, integer, text, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_assignprovider("studentID" text, "claimID" integer, "moduleID" text, "providerID" character) RETURNS void
    LANGUAGE sql
    AS $_$
	INSERT INTO "ClaimedModuleProvider"("studentID", "claimID", "moduleID", "providerID")
	VALUES($1, $2, $3, $4);
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
-- Name: fn_deleteclaimedmodule(integer, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_deleteclaimedmodule(claimid integer, studentid text, moduleid text) RETURNS void
    LANGUAGE sql
    AS $_$
    DELETE FROM "ClaimedModule" 
    WHERE   
        "claimID" = $1
    AND "studentID" = $2
    AND "moduleID" = $3;
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
-- Name: fn_deletecriterion(integer, integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_deletecriterion(criterionid integer, elementid integer, moduleid text) RETURNS void
    LANGUAGE sql
    AS $_$
    DELETE FROM "Criterion" 
    WHERE "criterionID" = $1
    AND "elementID" = $2
    AND "moduleID" = $3;
    
    UPDATE "Criterion"
    SET "criterionID" = "criterionID" - 1
    WHERE "elementID" = $2
    AND "moduleID" = $3
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
-- Name: fn_deleteuser(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_deleteuser("userID" text) RETURNS void
    LANGUAGE sql
    AS $_$
    DELETE FROM "User" WHERE "userID" = $1;
$_$;


--
-- Name: fn_generatepassword(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_generatepassword() RETURNS text
    LANGUAGE sql
    AS $$
	SELECT array_to_string(array(
		SELECT substr('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', trunc(random() * 61)::integer + 1, 1) 
		FROM generate_series(1, 12)), '');
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: Campus; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "Campus" (
    "campusID" character(3) NOT NULL,
    name text NOT NULL
);


--
-- Name: TABLE "Campus"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "Campus" IS 'A campus runs several disciplines, and each discipline can be run at
several campuses. This table is related to CampusDiscipline to resolve the N-M relationship.';


--
-- Name: fn_getcampusbyid(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_getcampusbyid(campusid text) RETURNS SETOF "Campus"
    LANGUAGE sql
    AS $_$
    SELECT * FROM "Campus" WHERE "campusID" = $1;
$_$;


--
-- Name: Claim; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "Claim" (
    "claimID" integer NOT NULL,
    "studentID" character(9) NOT NULL,
    "dateMade" date DEFAULT ('now'::text)::date NOT NULL,
    "dateResolved" date,
    "claimType" boolean NOT NULL,
    "courseID" character(5) NOT NULL,
    "campusID" character(3) NOT NULL,
    "disciplineID" integer NOT NULL,
    "assApproved" boolean,
    "delApproved" boolean,
    option character(1),
    "requestComp" boolean,
    submitted boolean DEFAULT false NOT NULL,
    "assessorID" text,
    "delegateID" text,
    status integer DEFAULT 0 NOT NULL,
    CONSTRAINT "ck_Claim_CurrentDate" CHECK (("dateMade" = ('now'::text)::date)),
    CONSTRAINT "ck_Claim_DateResolved" CHECK (("dateResolved" >= ('now'::text)::date)),
    CONSTRAINT "ck_Claim_Option" CHECK ((option = ANY (ARRAY['C'::bpchar, 'D'::bpchar])))
);


--
-- Name: TABLE "Claim"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "Claim" IS 'A claim is made by a student for one or more modules. The dates of the
 claim''s creation and resolution are recorded, as is the type of claim
 (since some claims need evidence to be provided for Elements while some
 only need evidence for Modules.)';


--
-- Name: fn_getclaimbyid(integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_getclaimbyid(claimid integer, studentid text) RETURNS SETOF "Claim"
    LANGUAGE sql
    AS $_$
    SELECT * FROM "Claim" WHERE "claimID" = $1 AND "studentID" = $2;
$_$;


--
-- Name: Course; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "Course" (
    "courseID" character(5) NOT NULL,
    name text NOT NULL,
    "guideFileAddress" text
);


--
-- Name: TABLE "Course"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "Course" IS 'The courseID is a 5 digit identifier in use by TAFE for each course.';


--
-- Name: fn_getcourse(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_getcourse(courseid text) RETURNS SETOF "Course"
    LANGUAGE sql
    AS $_$
    SELECT * FROM "Course" WHERE "courseID" = $1;
$_$;


--
-- Name: Criterion; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "Criterion" (
    "criterionID" integer NOT NULL,
    "elementID" integer NOT NULL,
    description text NOT NULL,
    "moduleID" character varying(10) NOT NULL
);


--
-- Name: TABLE "Criterion"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "Criterion" IS 'Each of the criteria belong to an Element, together an element''s criteria
 explain what is required for a student to be granted credit for that element of the Module.';


--
-- Name: fn_getcriteria(integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_getcriteria(elementid integer, moduleid text) RETURNS SETOF "Criterion"
    LANGUAGE sql
    AS $_$
    SELECT * FROM "Criterion" 
    WHERE "Criterion"."elementID" = $1
    AND "Criterion"."moduleID" = $2;
$_$;


--
-- Name: Discipline; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "Discipline" (
    "disciplineID" integer NOT NULL,
    name text NOT NULL
);


--
-- Name: TABLE "Discipline"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "Discipline" IS 'A discipline is maintained at a campus and runs many courses. A delegate can
 be responsible for an entire discipline, while an assessor may only be responsible 
for a single course. ';


--
-- Name: fn_getdiscipline(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_getdiscipline(disciplineid integer) RETURNS SETOF "Discipline"
    LANGUAGE sql
    AS $_$
    SELECT * FROM "Discipline" WHERE "disciplineID" = $1;
$_$;


--
-- Name: Element; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "Element" (
    "elementID" integer NOT NULL,
    "moduleID" character varying(10) NOT NULL,
    description text NOT NULL
);


--
-- Name: TABLE "Element"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "Element" IS 'An element is one of many that may be required for a student
 to provide evidence against in order to gain credit for a module.
 TAFE identifies elements by an incrementing integer starting from 
1, with an association with a Module, so this table identifies each
 record the same way. The description attribute is the text of the 
element in the recognition guide. For each element there may be many Criteria. ';


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
-- Name: Evidence; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "Evidence" (
    "studentID" character(9) NOT NULL,
    "claimID" integer NOT NULL,
    "elementID" integer,
    description text NOT NULL,
    "moduleID" character varying(10) NOT NULL,
    approved boolean,
    "assessorNote" text
);


--
-- Name: TABLE "Evidence"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "Evidence" IS 'Evidence is made against either a Module or an Element. For each ClaimedModule
 there may be many records in this table, one for each Element, or just one record
 for the entire module depending on the type of claim being made (see "type" in 
the table "Claim").';


--
-- Name: fn_getevidence(integer, text, text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_getevidence(claimid integer, studentid text, moduleid text, elementid integer) RETURNS SETOF "Evidence"
    LANGUAGE sql
    AS $_$
    SELECT * FROM "Evidence"
    WHERE
        "claimID" = $1
    AND "studentID" = $2
    AND "moduleID" = $3
    AND "elementID" = $4;
$_$;


--
-- Name: Module; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "Module" (
    "moduleID" character varying(10) NOT NULL,
    name text NOT NULL,
    instructions text
);


--
-- Name: TABLE "Module"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "Module" IS 'Modules are identified by a 9-10 character code that is already in use by TAFE. 
The guide attribute is an MS-Word document: the recognition guide for this module. 
Students and assessors can read through these documents to determine critical
 aspects of evidence and a description of required skills and knowledge.';


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
-- Name: Provider; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "Provider" (
    "providerID" character(1) NOT NULL,
    name text NOT NULL,
    CONSTRAINT "ck_Provider_ProviderID" CHECK (("providerID" = ANY (ARRAY['1'::bpchar, '2'::bpchar, '3'::bpchar, '4'::bpchar, '5'::bpchar, '6'::bpchar])))
);


--
-- Name: TABLE "Provider"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "Provider" IS 'Previous provider codes used on the ''orange'' form are represented here.';


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
-- Name: Student; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "Student" (
    "studentID" character(9) NOT NULL,
    "firstName" text NOT NULL,
    "lastName" text NOT NULL,
    email text NOT NULL
);


--
-- Name: TABLE "Student"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "Student" IS 'A student account, studentID is the student''s number assigned by TAFE.';


--
-- Name: User; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "User" (
    "userID" text NOT NULL,
    role character(1) NOT NULL,
    password bytea DEFAULT (md5(fn_generatepassword()))::bytea NOT NULL,
    CONSTRAINT "ck_Role" CHECK ((role = ANY (ARRAY['A'::bpchar, 'C'::bpchar, 'S'::bpchar, 'T'::bpchar])))
);


--
-- Name: TABLE "User"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "User" IS 'A user account, where the userID is a student number, a teacher''s ID or an admin''s ID.
The role of each user determines which database login role the application will connect 
to the database with when the user logs in, and therefore the permissions granted to 
the application for that user. Roles are (A)Assessor, (D)Delegate, (M)Admin, (S)Student';


--
-- Name: vw_StudentUser; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW "vw_StudentUser" AS
    SELECT "Student"."firstName", "User"."userID", "User".role, "User".password, "Student"."lastName", "Student".email FROM "User", "Student" WHERE (("Student"."studentID")::text = "User"."userID");


--
-- Name: VIEW "vw_StudentUser"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW "vw_StudentUser" IS 'Combines student and user tables for easier access through functions';


--
-- Name: fn_getstudentuser(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_getstudentuser("studentID" text) RETURNS SETOF "vw_StudentUser"
    LANGUAGE sql
    AS $_$
    SELECT * FROM "vw_StudentUser" WHERE "userID" = $1;
$_$;


--
-- Name: Teacher; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "Teacher" (
    "firstName" text NOT NULL,
    "lastName" text NOT NULL,
    email text NOT NULL,
    "teacherID" text NOT NULL
);


--
-- Name: TABLE "Teacher"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "Teacher" IS 'A teacher account, where teacherID is not the TAFE staff ID, but an ID chosen by the teacher as a username for this system.';


--
-- Name: vw_TeacherUser; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW "vw_TeacherUser" AS
    SELECT "Teacher"."teacherID", "Teacher".email, "Teacher"."lastName", "Teacher"."firstName", "User".password, "User".role, "User"."userID" FROM "User", "Teacher" WHERE ("User"."userID" = "Teacher"."teacherID");


--
-- Name: VIEW "vw_TeacherUser"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW "vw_TeacherUser" IS 'Combines teacher and user tables';


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
-- Name: fn_insertadmin(text, bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_insertadmin("userID" text, password bytea) RETURNS void
    LANGUAGE sql
    AS $_$
	SELECT fn_InsertUser($1, $2, 'A');
$_$;


--
-- Name: fn_insertassessor(text, text, text, text, integer, text, text, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_insertassessor("teacherID" text, "firstName" text, "lastName" text, email text, "disciplineID" integer, "campusID" text, "courseID" text, "courseCoordinator" boolean) RETURNS void
    LANGUAGE sql
    AS $_$
	SELECT fn_InsertTeacher($1,$2,$3,$4);
	SELECT fn_AssignAssessor($1,$5,$6,$7,$8);
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

CREATE FUNCTION fn_insertclaimedmodule("moduleID" text, "studentID" text, "claimID" integer) RETURNS void
    LANGUAGE sql
    AS $_$
	INSERT INTO "ClaimedModule"("moduleID", "studentID", "claimID")
	VALUES($1,$2,$3);
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

CREATE FUNCTION fn_insertcriterion("elementID" integer, "moduleID" text, description text) RETURNS void
    LANGUAGE plpgsql
    AS $_$
    DECLARE criterionID int;
    BEGIN
        criterionID := MAX("Criterion"."criterionID") FROM "Criterion" WHERE "Criterion"."elementID" = $1 AND "Criterion"."moduleID" = $2;
        IF criterionID IS NULL THEN criterionID := 0; END IF;
        criterionID := criterionID + 1;
	INSERT INTO "Criterion"("criterionID", "elementID", "moduleID", "description")
	VALUES(criterionID,$1,$2,$3);
    END;
$_$;


--
-- Name: fn_insertdelegate(text, text, text, text, integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_insertdelegate("teacherID" text, "firstName" text, "lastName" text, email text, "disciplineID" integer, "campusID" text) RETURNS void
    LANGUAGE sql
    AS $_$
	SELECT fn_InsertTeacher($1,$2,$3,$4);
	SELECT fn_AssignDelegate($1,$5,$6);
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
-- Name: fn_insertevidence(text, integer, integer, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_insertevidence("studentID" text, "claimID" integer, "elementID" integer, description text, "moduleID" text) RETURNS void
    LANGUAGE sql
    AS $_$
	INSERT INTO "Evidence"("studentID", "claimID", "elementID", "description", "moduleID")
	VALUES($1,$2,$3,$4,$5);
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
-- Name: fn_insertstudent(text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_insertstudent("studentID" text, "firstName" text, "lastName" text, email text, password text) RETURNS void
    LANGUAGE sql
    AS $_$
	INSERT INTO "Student"("studentID", "firstName", "lastName", "email")
	VALUES($1, $2, $3, $4);
	SELECT fn_InsertUser($1,$5,'S');
$_$;


--
-- Name: fn_insertteacher(text, text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_insertteacher("teacherID" text, "firstName" text, "lastName" text, email text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE password text;
BEGIN
    INSERT INTO "Teacher"("teacherID", "firstName", "lastName", "email")
    VALUES($1,$2,$3,$4);

    SELECT INTO password fn_InsertUser($1, 'T');
    RETURN password;
END;
$_$;


--
-- Name: fn_insertuser(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_insertuser("userID" text, role text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
    DECLARE pw TEXT;

    BEGIN
        SELECT INTO pw fn_GeneratePassword();

        PERFORM fn_InsertUser($1, pw, $2);
        RETURN pw;
    END;
$_$;


--
-- Name: fn_insertuser(text, text, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_insertuser(text, text, character) RETURNS void
    LANGUAGE sql
    AS $_$
	INSERT INTO "User"("userID", "password", "role") 
	VALUES($1, md5($2)::bytea, $3)
$_$;


--
-- Name: Assessor; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "Assessor" (
    "campusID" character(3) NOT NULL,
    "courseID" character(5) NOT NULL,
    "disciplineID" integer NOT NULL,
    "courseCoordinator" boolean NOT NULL,
    "teacherID" character varying(20) NOT NULL
);


--
-- Name: TABLE "Assessor"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "Assessor" IS 'Associative entity for the N-M relationship between Teacher 
and CampusDisciplineCourse. This relationship exists for Assessors,
 who are responsible for one or more courses at a campus.An 
assessor can be a course coordinator, in which case they are 
alerted whenever a claim is made for the CampusDisciplineCourse
 with which they are associated.';


--
-- Name: vw_AssessorDetails; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW "vw_AssessorDetails" AS
    SELECT "Teacher"."firstName", "Teacher"."lastName", "Teacher".email, "Teacher"."teacherID", "Assessor"."courseCoordinator", "Assessor"."campusID", "Assessor"."disciplineID", "Assessor"."courseID" FROM "Teacher", "Assessor" WHERE ("Teacher"."teacherID" = ("Assessor"."teacherID")::text);


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
-- Name: ClaimedModule; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "ClaimedModule" (
    "moduleID" character varying(10) NOT NULL,
    "studentID" character(9) NOT NULL,
    "claimID" integer NOT NULL,
    approved boolean,
    "arrangementNo" character varying(12),
    "functionalCode" character(4),
    "overseasEvidence" boolean,
    recognition character(1)
);


--
-- Name: TABLE "ClaimedModule"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "ClaimedModule" IS 'A record of this entity represents a Module that has been chosen by a 
student for a particular Claim. Certain details are recorded for each
 module, mapping to areas on the ''orange'' and ''yellow'' recognition forms.
  Evidence is provided by a Student against each record here.';


--
-- Name: vw_ClaimedModule_Module; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW "vw_ClaimedModule_Module" AS
    SELECT "ClaimedModule"."moduleID", "ClaimedModule"."studentID", "ClaimedModule"."claimID", "ClaimedModule".approved, "ClaimedModule"."arrangementNo", "ClaimedModule"."functionalCode", "ClaimedModule"."overseasEvidence", "ClaimedModule".recognition, "Module".name, "Module".instructions FROM "ClaimedModule", "Module" WHERE (("ClaimedModule"."moduleID")::text = ("Module"."moduleID")::text);


--
-- Name: fn_listclaimedmodules(integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_listclaimedmodules(claimid integer, studentid text) RETURNS SETOF "vw_ClaimedModule_Module"
    LANGUAGE sql
    AS $_$
    SELECT * FROM "vw_ClaimedModule_Module" 
    WHERE "claimID" = $1
    AND   "studentID" = $2;
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

CREATE FUNCTION fn_listcores(courseid text) RETURNS SETOF "Module"
    LANGUAGE sql
    AS $_$
    SELECT "Module".*
    FROM "Module", "Core"
    WHERE "Module"."moduleID" = "Core"."moduleID"
    AND "courseID" = $1;
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
-- Name: fn_listcriteria(integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_listcriteria(elementid integer, moduleid text) RETURNS SETOF "Criterion"
    LANGUAGE sql
    AS $_$
    SELECT * FROM "Criterion" WHERE "elementID" = $1 AND "moduleID" = $2;
$_$;


--
-- Name: fn_listdelegates(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_listdelegates("campusID" text, "disciplineID" integer) RETURNS SETOF "Teacher"
    LANGUAGE sql
    AS $_$
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
-- Name: fn_listelectives(text, integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_listelectives(campusid text, disciplineid integer, courseid text) RETURNS SETOF "Module"
    LANGUAGE sql
    AS $_$
    SELECT "Module".*
    FROM "Module", "Elective"
    WHERE
        "Module"."moduleID" = "Elective"."moduleID"
        AND "campusID" = $1
        AND "disciplineID" = $2
        AND "courseID" = $3;
$_$;


--
-- Name: fn_listevidence(text, integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_listevidence(studentid text, claimid integer, moduleid text) RETURNS SETOF "Evidence"
    LANGUAGE sql
    AS $_$
    SELECT * FROM "Evidence" 
    WHERE
        "studentID" = $1
    AND "claimID" = $2
    AND "moduleID" = $3;
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
-- Name: fn_listmodulesnotcoreincourse(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_listmodulesnotcoreincourse(courseid text) RETURNS SETOF "Module"
    LANGUAGE sql
    AS $_$
    SELECT DISTINCT "Module".*
    FROM "Module"
    WHERE "Module"."moduleID" NOT IN
    (
        SELECT "moduleID"
        FROM "Core"
        WHERE "courseID" = $1
    )
    ORDER BY "Module"."moduleID";
$_$;


--
-- Name: fn_listmodulesnotincourse(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_listmodulesnotincourse(courseid text) RETURNS SETOF "Module"
    LANGUAGE sql
    AS $_$
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
$_$;


--
-- Name: fn_listproviders(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_listproviders() RETURNS SETOF "Provider"
    LANGUAGE sql
    AS $$
    SELECT * FROM "Provider";
$$;


--
-- Name: fn_listproviders(integer, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_listproviders(claimid integer, studentid text, moduleid text) RETURNS SETOF "Provider"
    LANGUAGE sql
    AS $$
    SELECT "Provider"."providerID", "Provider"."name"
    FROM "Provider", "ClaimedModuleProvider"
    WHERE "ClaimedModuleProvider"."claimID" = "claimID"
    AND "ClaimedModuleProvider"."studentID" = "studentID"
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
-- Name: fn_removecore(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_removecore(courseid text, moduleid text) RETURNS void
    LANGUAGE sql
    AS $_$
    DELETE FROM "Core" 
    WHERE "courseID" = $1
    AND "moduleID" = $2;
$_$;


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
-- Name: fn_removeelective(text, integer, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_removeelective(campusid text, disciplineid integer, courseid text, moduleid text) RETURNS void
    LANGUAGE sql
    AS $_$
    DELETE FROM "Elective" WHERE "campusID" = $1 AND "disciplineID" = $2 AND "courseID" = $3 AND "moduleID" = $4;
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
-- Name: fn_updateclaimedmodule(integer, text, text, boolean, text, text, boolean, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_updateclaimedmodule(claimid integer, studentid text, moduleid text, approved boolean, arrangementno text, functionalcode text, overseasevidence boolean, recognition character) RETURNS void
    LANGUAGE sql
    AS $_$
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
-- Name: fn_updatecriterion(integer, integer, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_updatecriterion(criterionid integer, elementid integer, moduleid text, description text) RETURNS void
    LANGUAGE sql
    AS $_$
    UPDATE "Criterion" 
    SET "description" = $4
    WHERE 
        "criterionID" = $1
    AND "elementID" = $2
    AND "moduleID" = $3;
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
-- Name: fn_updateevidence(text, integer, text, text, boolean, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_updateevidence(studentid text, claimid integer, moduleid text, description text, approved boolean, assessornote text) RETURNS void
    LANGUAGE sql
    AS $_$
    UPDATE "Evidence" 
    SET 
        "description" = $4, 
        "approved" = $5,
        "assessorNote" = $6
    WHERE
        "studentID" = $1 
    AND "claimID" = $2
    AND "moduleID" = $3;
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
$_$;


--
-- Name: fn_updateteacher(text, text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fn_updateteacher(oldid text, newid text, firstname text, lastname text, email text, password text) RETURNS void
    LANGUAGE sql
    AS $_$
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
-- Name: CampusDiscipline; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "CampusDiscipline" (
    "campusID" character(3) NOT NULL,
    "disciplineID" integer NOT NULL
);


--
-- Name: TABLE "CampusDiscipline"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "CampusDiscipline" IS 'Associative entity for the N-M relationship between Campus and Discipline.
 A record in this table represents a particular Campus'' Discipline (e.g. 
Ourimbah''s Information Technology discipline.)';


--
-- Name: CampusDisciplineCourse; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "CampusDisciplineCourse" (
    "courseID" character(5) NOT NULL,
    "disciplineID" integer NOT NULL,
    "campusID" character(3) NOT NULL
);


--
-- Name: TABLE "CampusDisciplineCourse"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "CampusDisciplineCourse" IS 'Associative entity for the N-M relationship between CampusDiscipline
 and Course. A record here represents a completely unique course,
 i.e. one that has elective modules that other courses of the same courseID may not have.';


--
-- Name: ClaimedModuleProvider; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "ClaimedModuleProvider" (
    "studentID" character(9) NOT NULL,
    "claimID" integer NOT NULL,
    "moduleID" character varying(10) NOT NULL,
    "providerID" character(1) NOT NULL
);


--
-- Name: TABLE "ClaimedModuleProvider"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "ClaimedModuleProvider" IS 'Associative entity resolving the N-M relationship between ClaimedModule 
and Provider. A claimed module can have 0..3 providers.';


--
-- Name: Core; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "Core" (
    "courseID" character(5) NOT NULL,
    "moduleID" character varying(10) NOT NULL
);


--
-- Name: TABLE "Core"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "Core" IS 'A core module for a course. Associative entity that resolves the N-M relationship between Course and Module.';


--
-- Name: Delegate; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "Delegate" (
    "disciplineID" integer NOT NULL,
    "campusID" character(3) NOT NULL,
    "teacherID" character varying(20) NOT NULL
);


--
-- Name: TABLE "Delegate"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "Delegate" IS 'A type of teacher that is responsible for an entire discipline at a campus.
 A delegate may, however, be responsible for more than one discipline 
at a campus, and may also be responsible for a discipline in multiple campuses.';


--
-- Name: Elective; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "Elective" (
    "moduleID" character varying(10) NOT NULL,
    "courseID" character(5) NOT NULL,
    "disciplineID" integer NOT NULL,
    "campusID" character(3) NOT NULL
);


--
-- Name: TABLE "Elective"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "Elective" IS 'A record in this table represents a Module that is an elective part 
of a specific course. A course may be made up of different elective 
modules depending on the discipline and the campus where it is being maintained.';


--
-- Name: vw_StudentWithClaims; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW "vw_StudentWithClaims" AS
    SELECT "Student"."firstName", "Student"."lastName", "Student".email, "User".role, "User".password, "Student"."studentID", "Claim"."claimID", "Claim"."dateMade", "Claim"."dateResolved", "Claim"."claimType", "Claim"."courseID", "Claim"."campusID", "Claim"."disciplineID", "Claim"."assApproved", "Claim"."delApproved", "Claim".option, "Claim"."requestComp", "Claim".submitted, "Claim".status, "Campus".name AS "campusName", "Discipline".name AS "disciplineName", "Course".name AS "courseName", "ClaimedModule"."moduleID", "ClaimedModule".approved AS "claimedModuleApproved", "Provider"."providerID", "Provider".name AS "providerName", "Evidence".approved AS "evidenceApproved", "Evidence"."assessorNote", "Evidence".description AS "evidenceDescription", "Element".description AS "elementDescription", "Criterion".description AS "criterionDescription", "Criterion"."criterionID", "Element"."elementID" FROM "Student", "User", "Claim", "Campus", "Discipline", "Course", "ClaimedModule", "ClaimedModuleProvider", "Provider", "Evidence", "Element", "Criterion" WHERE (((((((((((("Student"."studentID")::text = "User"."userID") AND ("Claim"."studentID" = "Student"."studentID")) AND ("Claim"."campusID" = "Campus"."campusID")) AND ("Claim"."disciplineID" = "Discipline"."disciplineID")) AND ("Claim"."courseID" = "Course"."courseID")) AND ("ClaimedModule"."claimID" = "Claim"."claimID")) AND (("ClaimedModule"."moduleID")::text = ("Evidence"."moduleID")::text)) AND (("ClaimedModuleProvider"."moduleID")::text = ("ClaimedModule"."moduleID")::text)) AND ("Provider"."providerID" = "ClaimedModuleProvider"."providerID")) AND ("Evidence"."elementID" = "Element"."elementID")) AND ("Element"."elementID" = "Criterion"."elementID"));


--
-- Name: VIEW "vw_StudentWithClaims"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW "vw_StudentWithClaims" IS 'All student data that will be required for a student user';


--
-- Data for Name: Assessor; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: Campus; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "Campus" VALUES ('011', 'Ourimbah');
INSERT INTO "Campus" VALUES ('022', 'Wyong');
INSERT INTO "Campus" VALUES ('656', 'dfghdgdf');


--
-- Data for Name: CampusDiscipline; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "CampusDiscipline" VALUES ('011', 1);
INSERT INTO "CampusDiscipline" VALUES ('022', 2);
INSERT INTO "CampusDiscipline" VALUES ('656', 2);


--
-- Data for Name: CampusDisciplineCourse; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "CampusDisciplineCourse" VALUES ('19018', 1, '011');
INSERT INTO "CampusDisciplineCourse" VALUES ('19003', 1, '011');
INSERT INTO "CampusDisciplineCourse" VALUES ('19010', 1, '011');
INSERT INTO "CampusDisciplineCourse" VALUES ('45879', 1, '011');


--
-- Data for Name: Claim; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "Claim" VALUES (1, '355878635', '2011-06-17', NULL, false, '19018', '011', 1, NULL, NULL, NULL, NULL, false, NULL, NULL, 0);
INSERT INTO "Claim" VALUES (2, '355878635', '2011-06-17', NULL, false, '19018', '011', 1, NULL, NULL, NULL, NULL, false, NULL, NULL, 0);


--
-- Data for Name: ClaimedModule; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "ClaimedModule" VALUES ('ICAA5046B', '355878635', 1, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "ClaimedModule" VALUES ('ICAA5046B', '355878635', 2, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "ClaimedModule" VALUES ('ICAA5151B', '355878635', 2, NULL, NULL, NULL, NULL, NULL);


--
-- Data for Name: ClaimedModuleProvider; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "ClaimedModuleProvider" VALUES ('355878635', 1, 'ICAA5046B', '1');
INSERT INTO "ClaimedModuleProvider" VALUES ('355878635', 2, 'ICAA5046B', '1');
INSERT INTO "ClaimedModuleProvider" VALUES ('355878635', 2, 'ICAA5151B', '1');
INSERT INTO "ClaimedModuleProvider" VALUES ('355878635', 2, 'ICAA5151B', '2');
INSERT INTO "ClaimedModuleProvider" VALUES ('355878635', 2, 'ICAA5151B', '4');
INSERT INTO "ClaimedModuleProvider" VALUES ('355878635', 2, 'ICAA5151B', '5');


--
-- Data for Name: Core; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "Core" VALUES ('19018', 'ICAA5046B');
INSERT INTO "Core" VALUES ('19018', 'ICAA5139B');


--
-- Data for Name: Course; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "Course" VALUES ('19003', 'Certificate III in Information Technology (Network Administration)', NULL);
INSERT INTO "Course" VALUES ('19010', 'Certificate IV in Information Technology (Programming)', NULL);
INSERT INTO "Course" VALUES ('19018', 'Diploma in Information Technology (Software Development)', NULL);
INSERT INTO "Course" VALUES ('99999', 'Certificate I in Economics', NULL);
INSERT INTO "Course" VALUES ('17804', 'Certificate IV Business', NULL);
INSERT INTO "Course" VALUES ('45454', 'Certificate III Business', NULL);
INSERT INTO "Course" VALUES ('83351', 'Certificate II in Business', NULL);
INSERT INTO "Course" VALUES ('55154', 'Certificate III in Hospitality', NULL);
INSERT INTO "Course" VALUES ('45879', 'Diploma in Information Technology (Web Development)', NULL);


--
-- Data for Name: Criterion; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "Criterion" VALUES (1, 1, 'Accurately explain relevant provisions of OHS legislation and codes of practice to the workgroup.', 'ICAA5046B');
INSERT INTO "Criterion" VALUES (2, 1, 'Provide information to the workgroup on the organisation''s OHS policies, procedures and programs, ensuring it is readily accessible by the workgroup.', 'ICAA5046B');
INSERT INTO "Criterion" VALUES (3, 1, 'Regularly provide and clearly explain information about identified hazards and the outcomes of risk assessment and control to the workgroup.', 'ICAA5046B');
INSERT INTO "Criterion" VALUES (1, 1, 'Identify environmental regulations applying to the enterprise', 'ICAA5151B');
INSERT INTO "Criterion" VALUES (2, 1, 'Analyse procedures for assessing compliance with environmental/sustainability regulations', 'ICAA5151B');
INSERT INTO "Criterion" VALUES (3, 1, 'Collect information on environmental and resource efficiency systems and procedures, and provide to the work group where appropriate', 'ICAA5151B');


--
-- Data for Name: Delegate; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: Discipline; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "Discipline" VALUES (1, 'Information Technology');
INSERT INTO "Discipline" VALUES (2, 'Business');


--
-- Data for Name: Elective; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "Elective" VALUES ('ICAA5151B', '19018', 1, '011');
INSERT INTO "Elective" VALUES ('ICAA5158B', '19018', 1, '011');
INSERT INTO "Elective" VALUES ('ICAA5046B', '19003', 1, '011');
INSERT INTO "Elective" VALUES ('ICAA5139B', '19003', 1, '011');


--
-- Data for Name: Element; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "Element" VALUES (0, 'ICAA5151B', ' ');
INSERT INTO "Element" VALUES (0, 'ICAA5158B', ' ');
INSERT INTO "Element" VALUES (0, 'ICAA5046B', ' ');
INSERT INTO "Element" VALUES (0, 'ICAA5139B', ' ');
INSERT INTO "Element" VALUES (2, 'ICAA5046B', 'Implement and monitor participative arrangements for the management of OHS');
INSERT INTO "Element" VALUES (1, 'ICAA5046B', 'Provide information to the workgroup about OHS policies and procedures.');
INSERT INTO "Element" VALUES (1, 'ICAA5151B', 'Investigate current practices in relation to resource usage');


--
-- Data for Name: Evidence; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "Evidence" VALUES ('355878635', 1, 0, 'BUSB0101', 'ICAA5046B', NULL, NULL);
INSERT INTO "Evidence" VALUES ('355878635', 2, 0, 'BUSB0101', 'ICAA5046B', false, '');
INSERT INTO "Evidence" VALUES ('355878635', 2, 0, 'ggfgdgfd', 'ICAA5151B', false, '');


--
-- Data for Name: Module; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "Module" VALUES ('ICAA5151B', 'Gather data to identify business requirements', '');
INSERT INTO "Module" VALUES ('ICAA5158B', 'Translate business needs into technical requirements', '');
INSERT INTO "Module" VALUES ('ICAA5046B', 'Model preferred business solutions', '');
INSERT INTO "Module" VALUES ('ICAA5139B', 'Design a database', '');


--
-- Data for Name: Provider; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "Provider" VALUES ('1', 'University');
INSERT INTO "Provider" VALUES ('2', 'Adult and Community Education');
INSERT INTO "Provider" VALUES ('3', 'School');
INSERT INTO "Provider" VALUES ('4', 'TAFE NSW');
INSERT INTO "Provider" VALUES ('5', 'Other VET provider');
INSERT INTO "Provider" VALUES ('6', 'Non-formal/other');


--
-- Data for Name: Student; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "Student" VALUES ('355878635', 'Adam', 'Shortall', 'adam.shortall@tafensw.net.au');
INSERT INTO "Student" VALUES ('355878634', 'Henry', 'Tudor', 'Henry.Tudor@tafensw.net.au');


--
-- Data for Name: Teacher; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "Teacher" VALUES ('deb', 'spindler', 'deb.spindler@tafensw.edu.au', 'deb.spindler');
INSERT INTO "Teacher" VALUES ('kim', 'king', 'kim.king6@tafensw.edu.au', 'kim.king6');
INSERT INTO "Teacher" VALUES ('steve', 'etherington', 'steve.etherington@tafensw.edu.au', 'steve.etherington');
INSERT INTO "Teacher" VALUES ('Deb', 'Spindler', 'deb.spindler@tafensw.edu.au', 'admin');
INSERT INTO "Teacher" VALUES ('me', 'me', 'me.me@tafensw.edu.au', 'me.me@tafensw.edu.au');
INSERT INTO "Teacher" VALUES ('me', 'me', 'me.me2@tafensw.edu.au', 'me.me2@tafensw.edu.au');
INSERT INTO "Teacher" VALUES ('me', 'me', 'me.me3@tafensw.edu.au', 'me.me3@tafensw.edu.au');
INSERT INTO "Teacher" VALUES ('me', 'me', 'me.me4@tafensw.edu.au', 'me.me4@tafensw.edu.au');
INSERT INTO "Teacher" VALUES ('steve', 'etherington', 'steve.etherington@tafe.nsw.edu.au', 'steve.etherington@tafe.nsw.edu.au');
INSERT INTO "Teacher" VALUES ('steve', 'etherington', 'steve.etherington2@tafe.nsw.edu.au', 'steve.etherington2@tafe.nsw.edu.au');
INSERT INTO "Teacher" VALUES ('steve', 'etherington', 'steve.etherington3@tafe.nsw.edu.au', 'steve.etherington3@tafe.nsw.edu.au');
INSERT INTO "Teacher" VALUES ('a', 'b', 'a.g@tafe.nsw.edu.au', 'a.g@tafe.nsw.edu.au');
INSERT INTO "Teacher" VALUES ('Adam', 'Shortall', 'adam.shortall@tafe.nsw.edu.au', 'adam.shortall@tafe.nsw.edu.au');
INSERT INTO "Teacher" VALUES ('a', 'b', 'a.b@tafe.nsw.edu.au', 'a.b@tafe.nsw.edu.au');


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "User" VALUES ('deb.spindler', 'T', '\\x3063613462626136666665343332313039376136336263666465316162323033');
INSERT INTO "User" VALUES ('kim.king6', 'T', '\\x3763633062336435383630336538303438313639336565343931376436356631');
INSERT INTO "User" VALUES ('steve.etherington', 'T', '\\x6339346131653661663139663765336161313565643465656535656134356134');
INSERT INTO "User" VALUES ('clerical.person', 'C', '\\x3066313437333539343932376466623434396239393633633031343363346334');
INSERT INTO "User" VALUES ('355878635', 'S', '\\x3537333661663362303963323764333162313864623837353137643962333632');
INSERT INTO "User" VALUES ('clerical', 'C', '\\x3136326362363632633765663464633965383661326235653838636263646639');
INSERT INTO "User" VALUES ('admin', 'A', '\\x3231323332663239376135376135613734333839346130653461383031666333');
INSERT INTO "User" VALUES ('355878634', 'S', '\\x3537333661663362303963323764333162313864623837353137643962333632');
INSERT INTO "User" VALUES ('me.me@tafensw.edu.au', 'T', '\\x3731336466313366653464353765353263356363666666643262306131376638');
INSERT INTO "User" VALUES ('me.me2@tafensw.edu.au', 'T', '\\x6237616534643165303839363139316661363038346465316239656161373962');
INSERT INTO "User" VALUES ('me.me3@tafensw.edu.au', 'T', '\\x3138366461633930616664396437323931356564663562306366653634356533');
INSERT INTO "User" VALUES ('me.me4@tafensw.edu.au', 'T', '\\x6535383964616632626238323163376134393163333838643736613965346330');
INSERT INTO "User" VALUES ('steve.etherington@tafe.nsw.edu.au', 'T', '\\x3563313665656563323661646433663436643039353037383062656133306431');
INSERT INTO "User" VALUES ('steve.etherington2@tafe.nsw.edu.au', 'T', '\\x3031623962343261303334383537353939636536366465366131376632343030');
INSERT INTO "User" VALUES ('steve.etherington3@tafe.nsw.edu.au', 'T', '\\x6338396130376331386236633037613764383663373335306266636335383263');
INSERT INTO "User" VALUES ('a.g@tafe.nsw.edu.au', 'T', '\\x3130656532653763343036333739333237633230316662316639323234373734');
INSERT INTO "User" VALUES ('me.me@tafe.nsw.edu.au', 'C', '\\x6137323439323439373934323032656336343466383234653865666363313862');
INSERT INTO "User" VALUES ('adam.shortall@tafe.nsw.edu.au', 'T', '\\x3763623031666535343662653430386633373635643438633665313033316461');
INSERT INTO "User" VALUES ('a.b@tafe.nsw.edu.au', 'T', '\\x6534653164666561316138343333323863663661313064643231346662316162');


--
-- Name: pk_Assessor; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "Assessor"
    ADD CONSTRAINT "pk_Assessor" PRIMARY KEY ("campusID", "courseID", "disciplineID", "teacherID");


--
-- Name: pk_Campus; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "Campus"
    ADD CONSTRAINT "pk_Campus" PRIMARY KEY ("campusID");


--
-- Name: pk_CampusDiscipline; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "CampusDiscipline"
    ADD CONSTRAINT "pk_CampusDiscipline" PRIMARY KEY ("campusID", "disciplineID");


--
-- Name: pk_CampusDisciplineCourse; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "CampusDisciplineCourse"
    ADD CONSTRAINT "pk_CampusDisciplineCourse" PRIMARY KEY ("courseID", "disciplineID", "campusID");


--
-- Name: pk_Claim; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "Claim"
    ADD CONSTRAINT "pk_Claim" PRIMARY KEY ("claimID", "studentID");


--
-- Name: pk_ClaimedModule; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "ClaimedModule"
    ADD CONSTRAINT "pk_ClaimedModule" PRIMARY KEY ("moduleID", "studentID", "claimID");


--
-- Name: pk_ClaimedModuleProvider; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "ClaimedModuleProvider"
    ADD CONSTRAINT "pk_ClaimedModuleProvider" PRIMARY KEY ("studentID", "claimID", "moduleID", "providerID");


--
-- Name: pk_Core; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "Core"
    ADD CONSTRAINT "pk_Core" PRIMARY KEY ("courseID", "moduleID");


--
-- Name: pk_Course; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "Course"
    ADD CONSTRAINT "pk_Course" PRIMARY KEY ("courseID");


--
-- Name: pk_Criterion; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "Criterion"
    ADD CONSTRAINT "pk_Criterion" PRIMARY KEY ("criterionID", "elementID", "moduleID");


--
-- Name: pk_Delegate; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "Delegate"
    ADD CONSTRAINT "pk_Delegate" PRIMARY KEY ("disciplineID", "campusID", "teacherID");


--
-- Name: pk_Discipline; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "Discipline"
    ADD CONSTRAINT "pk_Discipline" PRIMARY KEY ("disciplineID");


--
-- Name: pk_Elective; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "Elective"
    ADD CONSTRAINT "pk_Elective" PRIMARY KEY ("moduleID", "courseID", "disciplineID", "campusID");


--
-- Name: pk_Element; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "Element"
    ADD CONSTRAINT "pk_Element" PRIMARY KEY ("elementID", "moduleID");


--
-- Name: pk_Evidence; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "Evidence"
    ADD CONSTRAINT "pk_Evidence" PRIMARY KEY ("studentID", "claimID", "moduleID");


--
-- Name: pk_Module; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "Module"
    ADD CONSTRAINT "pk_Module" PRIMARY KEY ("moduleID");


--
-- Name: pk_Provider; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "Provider"
    ADD CONSTRAINT "pk_Provider" PRIMARY KEY ("providerID");


--
-- Name: pk_Student; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "Student"
    ADD CONSTRAINT "pk_Student" PRIMARY KEY ("studentID");


--
-- Name: pk_Teacher; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "Teacher"
    ADD CONSTRAINT "pk_Teacher" PRIMARY KEY ("teacherID");


--
-- Name: pk_User; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "User"
    ADD CONSTRAINT "pk_User" PRIMARY KEY ("userID");


--
-- Name: uq_Email; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "Student"
    ADD CONSTRAINT "uq_Email" UNIQUE (email);


--
-- Name: uq_Name; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "Discipline"
    ADD CONSTRAINT "uq_Name" UNIQUE (name);


--
-- Name: fk_Assessor_CampusDisciplineCourse; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "Assessor"
    ADD CONSTRAINT "fk_Assessor_CampusDisciplineCourse" FOREIGN KEY ("campusID", "courseID", "disciplineID") REFERENCES "CampusDisciplineCourse"("campusID", "courseID", "disciplineID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_Assessor_Teacher; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "Assessor"
    ADD CONSTRAINT "fk_Assessor_Teacher" FOREIGN KEY ("teacherID") REFERENCES "Teacher"("teacherID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_CampusDisciplineCourse_CampusDiscipline; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "CampusDisciplineCourse"
    ADD CONSTRAINT "fk_CampusDisciplineCourse_CampusDiscipline" FOREIGN KEY ("disciplineID", "campusID") REFERENCES "CampusDiscipline"("disciplineID", "campusID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_CampusDisciplineCourse_Course; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "CampusDisciplineCourse"
    ADD CONSTRAINT "fk_CampusDisciplineCourse_Course" FOREIGN KEY ("courseID") REFERENCES "Course"("courseID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_CampusDiscipline_Campus; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "CampusDiscipline"
    ADD CONSTRAINT "fk_CampusDiscipline_Campus" FOREIGN KEY ("campusID") REFERENCES "Campus"("campusID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_CampusDiscipline_Discipline; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "CampusDiscipline"
    ADD CONSTRAINT "fk_CampusDiscipline_Discipline" FOREIGN KEY ("disciplineID") REFERENCES "Discipline"("disciplineID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_ClaimAssessorID_TeacherTeacherID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "Claim"
    ADD CONSTRAINT "fk_ClaimAssessorID_TeacherTeacherID" FOREIGN KEY ("assessorID") REFERENCES "Teacher"("teacherID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_ClaimDelegateID_TeacherTeacherID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "Claim"
    ADD CONSTRAINT "fk_ClaimDelegateID_TeacherTeacherID" FOREIGN KEY ("delegateID") REFERENCES "Teacher"("teacherID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_Claim_CampusDisciplineCourse; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "Claim"
    ADD CONSTRAINT "fk_Claim_CampusDisciplineCourse" FOREIGN KEY ("courseID", "disciplineID", "campusID") REFERENCES "CampusDisciplineCourse"("courseID", "disciplineID", "campusID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_Claim_Student; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "Claim"
    ADD CONSTRAINT "fk_Claim_Student" FOREIGN KEY ("studentID") REFERENCES "Student"("studentID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_ClaimedModuleProvider_ClaimedModule; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "ClaimedModuleProvider"
    ADD CONSTRAINT "fk_ClaimedModuleProvider_ClaimedModule" FOREIGN KEY ("studentID", "claimID", "moduleID") REFERENCES "ClaimedModule"("studentID", "claimID", "moduleID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_ClaimedModuleProvider_Provider; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "ClaimedModuleProvider"
    ADD CONSTRAINT "fk_ClaimedModuleProvider_Provider" FOREIGN KEY ("providerID") REFERENCES "Provider"("providerID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_ClaimedModule_Claim; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "ClaimedModule"
    ADD CONSTRAINT "fk_ClaimedModule_Claim" FOREIGN KEY ("claimID", "studentID") REFERENCES "Claim"("claimID", "studentID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_ClaimedModule_Module; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "ClaimedModule"
    ADD CONSTRAINT "fk_ClaimedModule_Module" FOREIGN KEY ("moduleID") REFERENCES "Module"("moduleID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_Core_Course; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "Core"
    ADD CONSTRAINT "fk_Core_Course" FOREIGN KEY ("courseID") REFERENCES "Course"("courseID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_Criterion_Element; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "Criterion"
    ADD CONSTRAINT "fk_Criterion_Element" FOREIGN KEY ("elementID", "moduleID") REFERENCES "Element"("elementID", "moduleID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_Delegate_CampusDiscipline; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "Delegate"
    ADD CONSTRAINT "fk_Delegate_CampusDiscipline" FOREIGN KEY ("campusID", "disciplineID") REFERENCES "CampusDiscipline"("campusID", "disciplineID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_Delegate_Teacher; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "Delegate"
    ADD CONSTRAINT "fk_Delegate_Teacher" FOREIGN KEY ("teacherID") REFERENCES "Teacher"("teacherID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_Elective_CampusDisciplineCourse; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "Elective"
    ADD CONSTRAINT "fk_Elective_CampusDisciplineCourse" FOREIGN KEY ("courseID", "disciplineID", "campusID") REFERENCES "CampusDisciplineCourse"("courseID", "disciplineID", "campusID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_Elective_Module; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "Elective"
    ADD CONSTRAINT "fk_Elective_Module" FOREIGN KEY ("moduleID") REFERENCES "Module"("moduleID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_Element_Module; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "Element"
    ADD CONSTRAINT "fk_Element_Module" FOREIGN KEY ("moduleID") REFERENCES "Module"("moduleID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_Evidence_ClaimedModule; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "Evidence"
    ADD CONSTRAINT "fk_Evidence_ClaimedModule" FOREIGN KEY ("claimID", "studentID", "moduleID") REFERENCES "ClaimedModule"("claimID", "studentID", "moduleID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_Evidence_Element; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "Evidence"
    ADD CONSTRAINT "fk_Evidence_Element" FOREIGN KEY ("elementID", "moduleID") REFERENCES "Element"("elementID", "moduleID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: pk_Core_Module; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "Core"
    ADD CONSTRAINT "pk_Core_Module" FOREIGN KEY ("moduleID") REFERENCES "Module"("moduleID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: -
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;
GRANT USAGE ON SCHEMA public TO student;


--
-- Name: fn_addcore(text, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_addcore(courseid text, moduleid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_addcore(courseid text, moduleid text) FROM postgres;
GRANT ALL ON FUNCTION fn_addcore(courseid text, moduleid text) TO postgres;
GRANT ALL ON FUNCTION fn_addcore(courseid text, moduleid text) TO admin;
GRANT ALL ON FUNCTION fn_addcore(courseid text, moduleid text) TO clerical;
GRANT ALL ON FUNCTION fn_addcore(courseid text, moduleid text) TO teacher;
GRANT ALL ON FUNCTION fn_addcore(courseid text, moduleid text) TO student;


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
-- Name: fn_addelective(text, integer, text, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_addelective(campusid text, disciplineid integer, courseid text, moduleid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_addelective(campusid text, disciplineid integer, courseid text, moduleid text) FROM postgres;
GRANT ALL ON FUNCTION fn_addelective(campusid text, disciplineid integer, courseid text, moduleid text) TO postgres;
GRANT ALL ON FUNCTION fn_addelective(campusid text, disciplineid integer, courseid text, moduleid text) TO admin;
GRANT ALL ON FUNCTION fn_addelective(campusid text, disciplineid integer, courseid text, moduleid text) TO clerical;
GRANT ALL ON FUNCTION fn_addelective(campusid text, disciplineid integer, courseid text, moduleid text) TO teacher;
GRANT ALL ON FUNCTION fn_addelective(campusid text, disciplineid integer, courseid text, moduleid text) TO student;


--
-- Name: fn_addprovidertoclaimedmodule(text, integer, text, character); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_addprovidertoclaimedmodule(studentid text, claimid integer, moduleid text, providerid character) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_addprovidertoclaimedmodule(studentid text, claimid integer, moduleid text, providerid character) FROM postgres;
GRANT ALL ON FUNCTION fn_addprovidertoclaimedmodule(studentid text, claimid integer, moduleid text, providerid character) TO postgres;
GRANT ALL ON FUNCTION fn_addprovidertoclaimedmodule(studentid text, claimid integer, moduleid text, providerid character) TO admin;
GRANT ALL ON FUNCTION fn_addprovidertoclaimedmodule(studentid text, claimid integer, moduleid text, providerid character) TO clerical;
GRANT ALL ON FUNCTION fn_addprovidertoclaimedmodule(studentid text, claimid integer, moduleid text, providerid character) TO teacher;
GRANT ALL ON FUNCTION fn_addprovidertoclaimedmodule(studentid text, claimid integer, moduleid text, providerid character) TO student;


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
-- Name: fn_assigncore(text, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_assigncore("moduleID" text, "courseID" text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_assigncore("moduleID" text, "courseID" text) FROM postgres;
GRANT ALL ON FUNCTION fn_assigncore("moduleID" text, "courseID" text) TO postgres;
GRANT ALL ON FUNCTION fn_assigncore("moduleID" text, "courseID" text) TO admin;
GRANT ALL ON FUNCTION fn_assigncore("moduleID" text, "courseID" text) TO clerical;
GRANT ALL ON FUNCTION fn_assigncore("moduleID" text, "courseID" text) TO teacher;
GRANT ALL ON FUNCTION fn_assigncore("moduleID" text, "courseID" text) TO student;


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
-- Name: fn_assignelective(text, text, integer, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_assignelective("moduleID" text, "courseID" text, "disciplineID" integer, "campusID" text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_assignelective("moduleID" text, "courseID" text, "disciplineID" integer, "campusID" text) FROM postgres;
GRANT ALL ON FUNCTION fn_assignelective("moduleID" text, "courseID" text, "disciplineID" integer, "campusID" text) TO postgres;
GRANT ALL ON FUNCTION fn_assignelective("moduleID" text, "courseID" text, "disciplineID" integer, "campusID" text) TO admin;
GRANT ALL ON FUNCTION fn_assignelective("moduleID" text, "courseID" text, "disciplineID" integer, "campusID" text) TO clerical;
GRANT ALL ON FUNCTION fn_assignelective("moduleID" text, "courseID" text, "disciplineID" integer, "campusID" text) TO teacher;
GRANT ALL ON FUNCTION fn_assignelective("moduleID" text, "courseID" text, "disciplineID" integer, "campusID" text) TO student;


--
-- Name: fn_assignprovider(text, integer, text, character); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_assignprovider("studentID" text, "claimID" integer, "moduleID" text, "providerID" character) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_assignprovider("studentID" text, "claimID" integer, "moduleID" text, "providerID" character) FROM postgres;
GRANT ALL ON FUNCTION fn_assignprovider("studentID" text, "claimID" integer, "moduleID" text, "providerID" character) TO postgres;
GRANT ALL ON FUNCTION fn_assignprovider("studentID" text, "claimID" integer, "moduleID" text, "providerID" character) TO admin;
GRANT ALL ON FUNCTION fn_assignprovider("studentID" text, "claimID" integer, "moduleID" text, "providerID" character) TO clerical;
GRANT ALL ON FUNCTION fn_assignprovider("studentID" text, "claimID" integer, "moduleID" text, "providerID" character) TO teacher;
GRANT ALL ON FUNCTION fn_assignprovider("studentID" text, "claimID" integer, "moduleID" text, "providerID" character) TO student;


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
-- Name: fn_deleteclaimedmodule(integer, text, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_deleteclaimedmodule(claimid integer, studentid text, moduleid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_deleteclaimedmodule(claimid integer, studentid text, moduleid text) FROM postgres;
GRANT ALL ON FUNCTION fn_deleteclaimedmodule(claimid integer, studentid text, moduleid text) TO postgres;
GRANT ALL ON FUNCTION fn_deleteclaimedmodule(claimid integer, studentid text, moduleid text) TO admin;
GRANT ALL ON FUNCTION fn_deleteclaimedmodule(claimid integer, studentid text, moduleid text) TO clerical;
GRANT ALL ON FUNCTION fn_deleteclaimedmodule(claimid integer, studentid text, moduleid text) TO teacher;
GRANT ALL ON FUNCTION fn_deleteclaimedmodule(claimid integer, studentid text, moduleid text) TO student;


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
-- Name: fn_deletecriterion(integer, integer, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_deletecriterion(criterionid integer, elementid integer, moduleid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_deletecriterion(criterionid integer, elementid integer, moduleid text) FROM postgres;
GRANT ALL ON FUNCTION fn_deletecriterion(criterionid integer, elementid integer, moduleid text) TO postgres;
GRANT ALL ON FUNCTION fn_deletecriterion(criterionid integer, elementid integer, moduleid text) TO admin;
GRANT ALL ON FUNCTION fn_deletecriterion(criterionid integer, elementid integer, moduleid text) TO clerical;
GRANT ALL ON FUNCTION fn_deletecriterion(criterionid integer, elementid integer, moduleid text) TO teacher;
GRANT ALL ON FUNCTION fn_deletecriterion(criterionid integer, elementid integer, moduleid text) TO student;


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
-- Name: fn_getcriteria(integer, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_getcriteria(elementid integer, moduleid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_getcriteria(elementid integer, moduleid text) FROM postgres;
GRANT ALL ON FUNCTION fn_getcriteria(elementid integer, moduleid text) TO postgres;
GRANT ALL ON FUNCTION fn_getcriteria(elementid integer, moduleid text) TO admin;
GRANT ALL ON FUNCTION fn_getcriteria(elementid integer, moduleid text) TO clerical;
GRANT ALL ON FUNCTION fn_getcriteria(elementid integer, moduleid text) TO teacher;
GRANT ALL ON FUNCTION fn_getcriteria(elementid integer, moduleid text) TO student;


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
-- Name: fn_getevidence(integer, text, text, integer); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_getevidence(claimid integer, studentid text, moduleid text, elementid integer) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_getevidence(claimid integer, studentid text, moduleid text, elementid integer) FROM postgres;
GRANT ALL ON FUNCTION fn_getevidence(claimid integer, studentid text, moduleid text, elementid integer) TO postgres;
GRANT ALL ON FUNCTION fn_getevidence(claimid integer, studentid text, moduleid text, elementid integer) TO admin;
GRANT ALL ON FUNCTION fn_getevidence(claimid integer, studentid text, moduleid text, elementid integer) TO clerical;
GRANT ALL ON FUNCTION fn_getevidence(claimid integer, studentid text, moduleid text, elementid integer) TO teacher;
GRANT ALL ON FUNCTION fn_getevidence(claimid integer, studentid text, moduleid text, elementid integer) TO student;


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
-- Name: fn_insertadmin(text, bytea); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_insertadmin("userID" text, password bytea) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_insertadmin("userID" text, password bytea) FROM postgres;
GRANT ALL ON FUNCTION fn_insertadmin("userID" text, password bytea) TO postgres;
GRANT ALL ON FUNCTION fn_insertadmin("userID" text, password bytea) TO admin;
GRANT ALL ON FUNCTION fn_insertadmin("userID" text, password bytea) TO clerical;
GRANT ALL ON FUNCTION fn_insertadmin("userID" text, password bytea) TO teacher;
GRANT ALL ON FUNCTION fn_insertadmin("userID" text, password bytea) TO student;


--
-- Name: fn_insertassessor(text, text, text, text, integer, text, text, boolean); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_insertassessor("teacherID" text, "firstName" text, "lastName" text, email text, "disciplineID" integer, "campusID" text, "courseID" text, "courseCoordinator" boolean) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_insertassessor("teacherID" text, "firstName" text, "lastName" text, email text, "disciplineID" integer, "campusID" text, "courseID" text, "courseCoordinator" boolean) FROM postgres;
GRANT ALL ON FUNCTION fn_insertassessor("teacherID" text, "firstName" text, "lastName" text, email text, "disciplineID" integer, "campusID" text, "courseID" text, "courseCoordinator" boolean) TO postgres;
GRANT ALL ON FUNCTION fn_insertassessor("teacherID" text, "firstName" text, "lastName" text, email text, "disciplineID" integer, "campusID" text, "courseID" text, "courseCoordinator" boolean) TO admin;
GRANT ALL ON FUNCTION fn_insertassessor("teacherID" text, "firstName" text, "lastName" text, email text, "disciplineID" integer, "campusID" text, "courseID" text, "courseCoordinator" boolean) TO clerical;
GRANT ALL ON FUNCTION fn_insertassessor("teacherID" text, "firstName" text, "lastName" text, email text, "disciplineID" integer, "campusID" text, "courseID" text, "courseCoordinator" boolean) TO teacher;
GRANT ALL ON FUNCTION fn_insertassessor("teacherID" text, "firstName" text, "lastName" text, email text, "disciplineID" integer, "campusID" text, "courseID" text, "courseCoordinator" boolean) TO student;


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
-- Name: fn_insertclaimedmodule(text, text, integer); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_insertclaimedmodule("moduleID" text, "studentID" text, "claimID" integer) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_insertclaimedmodule("moduleID" text, "studentID" text, "claimID" integer) FROM postgres;
GRANT ALL ON FUNCTION fn_insertclaimedmodule("moduleID" text, "studentID" text, "claimID" integer) TO postgres;
GRANT ALL ON FUNCTION fn_insertclaimedmodule("moduleID" text, "studentID" text, "claimID" integer) TO admin;
GRANT ALL ON FUNCTION fn_insertclaimedmodule("moduleID" text, "studentID" text, "claimID" integer) TO clerical;
GRANT ALL ON FUNCTION fn_insertclaimedmodule("moduleID" text, "studentID" text, "claimID" integer) TO teacher;
GRANT ALL ON FUNCTION fn_insertclaimedmodule("moduleID" text, "studentID" text, "claimID" integer) TO student;


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

REVOKE ALL ON FUNCTION fn_insertcriterion("elementID" integer, "moduleID" text, description text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_insertcriterion("elementID" integer, "moduleID" text, description text) FROM postgres;
GRANT ALL ON FUNCTION fn_insertcriterion("elementID" integer, "moduleID" text, description text) TO postgres;
GRANT ALL ON FUNCTION fn_insertcriterion("elementID" integer, "moduleID" text, description text) TO admin;
GRANT ALL ON FUNCTION fn_insertcriterion("elementID" integer, "moduleID" text, description text) TO clerical;
GRANT ALL ON FUNCTION fn_insertcriterion("elementID" integer, "moduleID" text, description text) TO teacher;
GRANT ALL ON FUNCTION fn_insertcriterion("elementID" integer, "moduleID" text, description text) TO student;


--
-- Name: fn_insertdelegate(text, text, text, text, integer, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_insertdelegate("teacherID" text, "firstName" text, "lastName" text, email text, "disciplineID" integer, "campusID" text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_insertdelegate("teacherID" text, "firstName" text, "lastName" text, email text, "disciplineID" integer, "campusID" text) FROM postgres;
GRANT ALL ON FUNCTION fn_insertdelegate("teacherID" text, "firstName" text, "lastName" text, email text, "disciplineID" integer, "campusID" text) TO postgres;
GRANT ALL ON FUNCTION fn_insertdelegate("teacherID" text, "firstName" text, "lastName" text, email text, "disciplineID" integer, "campusID" text) TO admin;
GRANT ALL ON FUNCTION fn_insertdelegate("teacherID" text, "firstName" text, "lastName" text, email text, "disciplineID" integer, "campusID" text) TO clerical;
GRANT ALL ON FUNCTION fn_insertdelegate("teacherID" text, "firstName" text, "lastName" text, email text, "disciplineID" integer, "campusID" text) TO teacher;
GRANT ALL ON FUNCTION fn_insertdelegate("teacherID" text, "firstName" text, "lastName" text, email text, "disciplineID" integer, "campusID" text) TO student;


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
-- Name: fn_insertevidence(text, integer, integer, text, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_insertevidence("studentID" text, "claimID" integer, "elementID" integer, description text, "moduleID" text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_insertevidence("studentID" text, "claimID" integer, "elementID" integer, description text, "moduleID" text) FROM postgres;
GRANT ALL ON FUNCTION fn_insertevidence("studentID" text, "claimID" integer, "elementID" integer, description text, "moduleID" text) TO postgres;
GRANT ALL ON FUNCTION fn_insertevidence("studentID" text, "claimID" integer, "elementID" integer, description text, "moduleID" text) TO admin;
GRANT ALL ON FUNCTION fn_insertevidence("studentID" text, "claimID" integer, "elementID" integer, description text, "moduleID" text) TO clerical;
GRANT ALL ON FUNCTION fn_insertevidence("studentID" text, "claimID" integer, "elementID" integer, description text, "moduleID" text) TO teacher;
GRANT ALL ON FUNCTION fn_insertevidence("studentID" text, "claimID" integer, "elementID" integer, description text, "moduleID" text) TO student;


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
-- Name: fn_insertstudent(text, text, text, text, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_insertstudent("studentID" text, "firstName" text, "lastName" text, email text, password text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_insertstudent("studentID" text, "firstName" text, "lastName" text, email text, password text) FROM postgres;
GRANT ALL ON FUNCTION fn_insertstudent("studentID" text, "firstName" text, "lastName" text, email text, password text) TO postgres;
GRANT ALL ON FUNCTION fn_insertstudent("studentID" text, "firstName" text, "lastName" text, email text, password text) TO admin;
GRANT ALL ON FUNCTION fn_insertstudent("studentID" text, "firstName" text, "lastName" text, email text, password text) TO clerical;
GRANT ALL ON FUNCTION fn_insertstudent("studentID" text, "firstName" text, "lastName" text, email text, password text) TO teacher;
GRANT ALL ON FUNCTION fn_insertstudent("studentID" text, "firstName" text, "lastName" text, email text, password text) TO student;


--
-- Name: fn_insertteacher(text, text, text, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_insertteacher("teacherID" text, "firstName" text, "lastName" text, email text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_insertteacher("teacherID" text, "firstName" text, "lastName" text, email text) FROM postgres;
GRANT ALL ON FUNCTION fn_insertteacher("teacherID" text, "firstName" text, "lastName" text, email text) TO postgres;
GRANT ALL ON FUNCTION fn_insertteacher("teacherID" text, "firstName" text, "lastName" text, email text) TO admin;
GRANT ALL ON FUNCTION fn_insertteacher("teacherID" text, "firstName" text, "lastName" text, email text) TO clerical;
GRANT ALL ON FUNCTION fn_insertteacher("teacherID" text, "firstName" text, "lastName" text, email text) TO teacher;
GRANT ALL ON FUNCTION fn_insertteacher("teacherID" text, "firstName" text, "lastName" text, email text) TO student;


--
-- Name: fn_insertuser(text, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_insertuser("userID" text, role text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_insertuser("userID" text, role text) FROM postgres;
GRANT ALL ON FUNCTION fn_insertuser("userID" text, role text) TO postgres;
GRANT ALL ON FUNCTION fn_insertuser("userID" text, role text) TO admin;
GRANT ALL ON FUNCTION fn_insertuser("userID" text, role text) TO clerical;
GRANT ALL ON FUNCTION fn_insertuser("userID" text, role text) TO teacher;
GRANT ALL ON FUNCTION fn_insertuser("userID" text, role text) TO student;


--
-- Name: fn_insertuser(text, text, character); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_insertuser(text, text, character) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_insertuser(text, text, character) FROM postgres;
GRANT ALL ON FUNCTION fn_insertuser(text, text, character) TO postgres;
GRANT ALL ON FUNCTION fn_insertuser(text, text, character) TO admin;
GRANT ALL ON FUNCTION fn_insertuser(text, text, character) TO clerical;
GRANT ALL ON FUNCTION fn_insertuser(text, text, character) TO teacher;
GRANT ALL ON FUNCTION fn_insertuser(text, text, character) TO student;


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
-- Name: fn_listclaimedmodules(integer, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_listclaimedmodules(claimid integer, studentid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_listclaimedmodules(claimid integer, studentid text) FROM postgres;
GRANT ALL ON FUNCTION fn_listclaimedmodules(claimid integer, studentid text) TO postgres;
GRANT ALL ON FUNCTION fn_listclaimedmodules(claimid integer, studentid text) TO admin;
GRANT ALL ON FUNCTION fn_listclaimedmodules(claimid integer, studentid text) TO clerical;
GRANT ALL ON FUNCTION fn_listclaimedmodules(claimid integer, studentid text) TO teacher;
GRANT ALL ON FUNCTION fn_listclaimedmodules(claimid integer, studentid text) TO student;


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
-- Name: fn_listcores(text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_listcores(courseid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_listcores(courseid text) FROM postgres;
GRANT ALL ON FUNCTION fn_listcores(courseid text) TO postgres;
GRANT ALL ON FUNCTION fn_listcores(courseid text) TO admin;
GRANT ALL ON FUNCTION fn_listcores(courseid text) TO clerical;
GRANT ALL ON FUNCTION fn_listcores(courseid text) TO teacher;
GRANT ALL ON FUNCTION fn_listcores(courseid text) TO student;


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
-- Name: fn_listcriteria(integer, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_listcriteria(elementid integer, moduleid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_listcriteria(elementid integer, moduleid text) FROM postgres;
GRANT ALL ON FUNCTION fn_listcriteria(elementid integer, moduleid text) TO postgres;
GRANT ALL ON FUNCTION fn_listcriteria(elementid integer, moduleid text) TO admin;
GRANT ALL ON FUNCTION fn_listcriteria(elementid integer, moduleid text) TO clerical;
GRANT ALL ON FUNCTION fn_listcriteria(elementid integer, moduleid text) TO teacher;
GRANT ALL ON FUNCTION fn_listcriteria(elementid integer, moduleid text) TO student;


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
-- Name: fn_listelectives(text, integer, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_listelectives(campusid text, disciplineid integer, courseid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_listelectives(campusid text, disciplineid integer, courseid text) FROM postgres;
GRANT ALL ON FUNCTION fn_listelectives(campusid text, disciplineid integer, courseid text) TO postgres;
GRANT ALL ON FUNCTION fn_listelectives(campusid text, disciplineid integer, courseid text) TO admin;
GRANT ALL ON FUNCTION fn_listelectives(campusid text, disciplineid integer, courseid text) TO clerical;
GRANT ALL ON FUNCTION fn_listelectives(campusid text, disciplineid integer, courseid text) TO teacher;
GRANT ALL ON FUNCTION fn_listelectives(campusid text, disciplineid integer, courseid text) TO student;


--
-- Name: fn_listevidence(text, integer, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_listevidence(studentid text, claimid integer, moduleid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_listevidence(studentid text, claimid integer, moduleid text) FROM postgres;
GRANT ALL ON FUNCTION fn_listevidence(studentid text, claimid integer, moduleid text) TO postgres;
GRANT ALL ON FUNCTION fn_listevidence(studentid text, claimid integer, moduleid text) TO admin;
GRANT ALL ON FUNCTION fn_listevidence(studentid text, claimid integer, moduleid text) TO clerical;
GRANT ALL ON FUNCTION fn_listevidence(studentid text, claimid integer, moduleid text) TO teacher;
GRANT ALL ON FUNCTION fn_listevidence(studentid text, claimid integer, moduleid text) TO student;


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
-- Name: fn_listmodulesnotcoreincourse(text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_listmodulesnotcoreincourse(courseid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_listmodulesnotcoreincourse(courseid text) FROM postgres;
GRANT ALL ON FUNCTION fn_listmodulesnotcoreincourse(courseid text) TO postgres;
GRANT ALL ON FUNCTION fn_listmodulesnotcoreincourse(courseid text) TO admin;
GRANT ALL ON FUNCTION fn_listmodulesnotcoreincourse(courseid text) TO clerical;
GRANT ALL ON FUNCTION fn_listmodulesnotcoreincourse(courseid text) TO teacher;
GRANT ALL ON FUNCTION fn_listmodulesnotcoreincourse(courseid text) TO student;


--
-- Name: fn_listmodulesnotincourse(text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_listmodulesnotincourse(courseid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_listmodulesnotincourse(courseid text) FROM postgres;
GRANT ALL ON FUNCTION fn_listmodulesnotincourse(courseid text) TO postgres;
GRANT ALL ON FUNCTION fn_listmodulesnotincourse(courseid text) TO admin;
GRANT ALL ON FUNCTION fn_listmodulesnotincourse(courseid text) TO clerical;
GRANT ALL ON FUNCTION fn_listmodulesnotincourse(courseid text) TO teacher;
GRANT ALL ON FUNCTION fn_listmodulesnotincourse(courseid text) TO student;


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
-- Name: fn_listproviders(integer, text, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_listproviders(claimid integer, studentid text, moduleid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_listproviders(claimid integer, studentid text, moduleid text) FROM postgres;
GRANT ALL ON FUNCTION fn_listproviders(claimid integer, studentid text, moduleid text) TO postgres;
GRANT ALL ON FUNCTION fn_listproviders(claimid integer, studentid text, moduleid text) TO admin;
GRANT ALL ON FUNCTION fn_listproviders(claimid integer, studentid text, moduleid text) TO clerical;
GRANT ALL ON FUNCTION fn_listproviders(claimid integer, studentid text, moduleid text) TO teacher;
GRANT ALL ON FUNCTION fn_listproviders(claimid integer, studentid text, moduleid text) TO student;


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
-- Name: fn_removecore(text, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_removecore(courseid text, moduleid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_removecore(courseid text, moduleid text) FROM postgres;
GRANT ALL ON FUNCTION fn_removecore(courseid text, moduleid text) TO postgres;
GRANT ALL ON FUNCTION fn_removecore(courseid text, moduleid text) TO admin;
GRANT ALL ON FUNCTION fn_removecore(courseid text, moduleid text) TO clerical;
GRANT ALL ON FUNCTION fn_removecore(courseid text, moduleid text) TO teacher;
GRANT ALL ON FUNCTION fn_removecore(courseid text, moduleid text) TO student;


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
-- Name: fn_removeelective(text, integer, text, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_removeelective(campusid text, disciplineid integer, courseid text, moduleid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_removeelective(campusid text, disciplineid integer, courseid text, moduleid text) FROM postgres;
GRANT ALL ON FUNCTION fn_removeelective(campusid text, disciplineid integer, courseid text, moduleid text) TO postgres;
GRANT ALL ON FUNCTION fn_removeelective(campusid text, disciplineid integer, courseid text, moduleid text) TO admin;
GRANT ALL ON FUNCTION fn_removeelective(campusid text, disciplineid integer, courseid text, moduleid text) TO clerical;
GRANT ALL ON FUNCTION fn_removeelective(campusid text, disciplineid integer, courseid text, moduleid text) TO teacher;
GRANT ALL ON FUNCTION fn_removeelective(campusid text, disciplineid integer, courseid text, moduleid text) TO student;


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
-- Name: fn_updateclaimedmodule(integer, text, text, boolean, text, text, boolean, character); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_updateclaimedmodule(claimid integer, studentid text, moduleid text, approved boolean, arrangementno text, functionalcode text, overseasevidence boolean, recognition character) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_updateclaimedmodule(claimid integer, studentid text, moduleid text, approved boolean, arrangementno text, functionalcode text, overseasevidence boolean, recognition character) FROM postgres;
GRANT ALL ON FUNCTION fn_updateclaimedmodule(claimid integer, studentid text, moduleid text, approved boolean, arrangementno text, functionalcode text, overseasevidence boolean, recognition character) TO postgres;
GRANT ALL ON FUNCTION fn_updateclaimedmodule(claimid integer, studentid text, moduleid text, approved boolean, arrangementno text, functionalcode text, overseasevidence boolean, recognition character) TO admin;
GRANT ALL ON FUNCTION fn_updateclaimedmodule(claimid integer, studentid text, moduleid text, approved boolean, arrangementno text, functionalcode text, overseasevidence boolean, recognition character) TO clerical;
GRANT ALL ON FUNCTION fn_updateclaimedmodule(claimid integer, studentid text, moduleid text, approved boolean, arrangementno text, functionalcode text, overseasevidence boolean, recognition character) TO teacher;
GRANT ALL ON FUNCTION fn_updateclaimedmodule(claimid integer, studentid text, moduleid text, approved boolean, arrangementno text, functionalcode text, overseasevidence boolean, recognition character) TO student;


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
-- Name: fn_updatecriterion(integer, integer, text, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_updatecriterion(criterionid integer, elementid integer, moduleid text, description text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_updatecriterion(criterionid integer, elementid integer, moduleid text, description text) FROM postgres;
GRANT ALL ON FUNCTION fn_updatecriterion(criterionid integer, elementid integer, moduleid text, description text) TO postgres;
GRANT ALL ON FUNCTION fn_updatecriterion(criterionid integer, elementid integer, moduleid text, description text) TO admin;
GRANT ALL ON FUNCTION fn_updatecriterion(criterionid integer, elementid integer, moduleid text, description text) TO clerical;
GRANT ALL ON FUNCTION fn_updatecriterion(criterionid integer, elementid integer, moduleid text, description text) TO teacher;
GRANT ALL ON FUNCTION fn_updatecriterion(criterionid integer, elementid integer, moduleid text, description text) TO student;


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
-- Name: fn_updateevidence(text, integer, text, text, boolean, text); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION fn_updateevidence(studentid text, claimid integer, moduleid text, description text, approved boolean, assessornote text) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_updateevidence(studentid text, claimid integer, moduleid text, description text, approved boolean, assessornote text) FROM postgres;
GRANT ALL ON FUNCTION fn_updateevidence(studentid text, claimid integer, moduleid text, description text, approved boolean, assessornote text) TO postgres;
GRANT ALL ON FUNCTION fn_updateevidence(studentid text, claimid integer, moduleid text, description text, approved boolean, assessornote text) TO admin;
GRANT ALL ON FUNCTION fn_updateevidence(studentid text, claimid integer, moduleid text, description text, approved boolean, assessornote text) TO clerical;
GRANT ALL ON FUNCTION fn_updateevidence(studentid text, claimid integer, moduleid text, description text, approved boolean, assessornote text) TO teacher;
GRANT ALL ON FUNCTION fn_updateevidence(studentid text, claimid integer, moduleid text, description text, approved boolean, assessornote text) TO student;


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
-- Name: Core; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE "Core" FROM PUBLIC;
REVOKE ALL ON TABLE "Core" FROM postgres;
GRANT ALL ON TABLE "Core" TO postgres;
GRANT ALL ON TABLE "Core" TO admin;
GRANT ALL ON TABLE "Core" TO clerical;
GRANT ALL ON TABLE "Core" TO student;
GRANT ALL ON TABLE "Core" TO teacher;


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
-- Name: Elective; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE "Elective" FROM PUBLIC;
REVOKE ALL ON TABLE "Elective" FROM postgres;
GRANT ALL ON TABLE "Elective" TO postgres;
GRANT ALL ON TABLE "Elective" TO admin;
GRANT ALL ON TABLE "Elective" TO clerical;
GRANT ALL ON TABLE "Elective" TO student;
GRANT ALL ON TABLE "Elective" TO teacher;


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


--
-- PostgreSQL database dump complete
--

