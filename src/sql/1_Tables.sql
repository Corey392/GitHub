/* Purpose:  	Adds the Tables to the database.
 * Authors:		Ryan, Kelly, Todd, Bryce
 * Created:		Unknown
 * Version:		v2.025
 * Modified:	13/05/2013
 * Change Log:	v2.000: Todd:	Updated Student table, datatype for PhoneNumber changed to text
 *		v2.010:	Bryce:	Updated CourseModule table, foreign key for CampusDisciplineCourse electives
		v2.020:	Bryce:	Updated Element, Evidence and Criterion tables. Changed PK of Element to a composite key and changed the others' references to match.
		v2.021:	Todd:	Moved 2 SET option here instead of the CreateDB sql.
		v2.022:	Bryce:	Updated "Criterion" table, changed composite primary key to include "moduleID".
		v2.023:	Todd:	Updated "Evidence", removed NOT NULL for 'description'.
		v2.024:	Todd:	Updated "Claim", modified constraint for "DateMade" to be less than or equal to today.
		v2.025:	Todd:	Updated "File", Added fileID to be an auto_increment field (using the 'Serial' data type).
 * Pre-conditions: Database must be created, tables must not already exist.
 */
--------------------------------------------------------------------------------------
-- Make Sure you have closed the query window and opened again on RPL_2012 database --
--------------------------------------------------------------------------------------
SET standard_conforming_strings = off;
SET escape_string_warning = off;
SET default_tablespace = '';
SET default_with_oids = false;

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
--
-- Name: User; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE "User" (
    "userID" text NOT NULL,
    "role" character(1) NOT NULL,
    "password" bytea DEFAULT (md5(fn_generatepassword()))::bytea NOT NULL,
	"email" text NOT NULL,
	"firstName" text NOT NULL,
	"lastName" text NOT NULL,
	CONSTRAINT "pk_User" PRIMARY KEY ("userID"),
	CONSTRAINT "uq_Email" UNIQUE (email),
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
-- Name: Teacher; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE "Teacher" (
    "userID" character varying(20) NOT NULL,
    "teacherID" text NOT NULL,
	CONSTRAINT "pk_Teacher" PRIMARY KEY ("teacherID"),
	CONSTRAINT "fk_Teacher_User" FOREIGN KEY ("userID")
      REFERENCES "User" ("userID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE
);


--
-- Name: TABLE "Teacher"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "Teacher" IS 'A teacher account, where teacherID is not the TAFE staff ID, but an ID chosen by the teacher as a username for this system.';

--
-- Name: Student; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE "Student" (
	"userID" character varying(20) NOT NULL,
	"otherName" text,
	"addressLine1" text,
	"addressLine2" text,
    "town" character varying(30) NOT NULL,
	"state" character varying(3) NOT NULL,
	"postCode" integer NOT NULL,
	"phoneNumber" text,
    "studentID" character(9) NOT NULL,
	"staff" boolean NOT NULL,
	CONSTRAINT "pk_Student" PRIMARY KEY ("studentID"),
	CONSTRAINT "fk_Student_User" FOREIGN KEY ("userID")
      REFERENCES "User" ("userID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE
);


--
-- Name: TABLE "Student"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "Student" IS 'A student account, studentID is the student''s number assigned by TAFE.';

--
-- Name: Campus; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE "Campus" (
    "campusID" character(3) NOT NULL,
    "name" text NOT NULL,
	CONSTRAINT "pk_Campus" PRIMARY KEY ("campusID")
);


--
-- Name: TABLE "Campus"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "Campus" IS 'A campus runs several disciplines, and each discipline can be run at
several campuses. This table is related to CampusDiscipline to resolve the N-M relationship.';

--
-- Name: Discipline; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE "Discipline" (
    "disciplineID" integer NOT NULL,
    "name" text NOT NULL,
	CONSTRAINT "pk_Discipline" PRIMARY KEY ("disciplineID"),
	CONSTRAINT "uq_Name" UNIQUE (name)
);


--
-- Name: TABLE "Discipline"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "Discipline" IS 'A discipline is maintained at a campus and runs many courses. A delegate can
 be responsible for an entire discipline, while an assessor may only be responsible
for a single course. ';

--
-- Name: CampusDiscipline; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE "CampusDiscipline" (
    "campusID" character(3) NOT NULL,
    "disciplineID" integer NOT NULL,
	CONSTRAINT "pk_CampusDiscipline" PRIMARY KEY ("campusID", "disciplineID"),
	CONSTRAINT "fk_CampusDiscipline_Campus" FOREIGN KEY ("campusID")
      REFERENCES "Campus" ("campusID") MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT "fk_CampusDiscipline_Discipline" FOREIGN KEY ("disciplineID")
      REFERENCES "Discipline" ("disciplineID") MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
);


--
-- Name: TABLE "CampusDiscipline"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "CampusDiscipline" IS 'Associative entity for the N-M relationship between Campus and Discipline.
 A record in this table represents a particular Campus'' Discipline (e.g.
Ourimbah''s Information Technology discipline.)';

--
-- Name: Delegate; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE "Delegate" (
    "disciplineID" integer NOT NULL,
    "campusID" character(3) NOT NULL,
    "teacherID" character varying(20) NOT NULL,
	CONSTRAINT "pk_Delegate" PRIMARY KEY ("disciplineID", "campusID", "teacherID"),
	CONSTRAINT "fk_Delegate_CampusDiscipline" FOREIGN KEY ("campusID", "disciplineID")
      REFERENCES "CampusDiscipline" ("campusID", "disciplineID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT "fk_Delegate_Teacher" FOREIGN KEY ("teacherID")
      REFERENCES "Teacher" ("teacherID") MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
);


--
-- Name: TABLE "Delegate"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "Delegate" IS 'A type of teacher that is responsible for an entire discipline at a campus.
 A delegate may, however, be responsible for more than one discipline
at a campus, and may also be responsible for a discipline in multiple campuses.';

--
-- Name: Module; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE "Module" (
    "moduleID" character varying(10) NOT NULL,
    "name" text NOT NULL,
    "instructions" text,
	CONSTRAINT "pk_Module" PRIMARY KEY ("moduleID")
);


--
-- Name: TABLE "Module"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "Module" IS 'Modules are identified by a 9-10 character code that is already in use by TAFE.
The guide attribute is an MS-Word document: the recognition guide for this module.
Students and assessors can read through these documents to determine critical
 aspects of evidence and a description of required skills and knowledge.';

 --
-- Name: Course; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE "Course" (
    "courseID" character(5) NOT NULL,
    "name" text NOT NULL,
    "guideFileAddress" text,
	CONSTRAINT "pk_Course" PRIMARY KEY ("courseID")
);


--
-- Name: TABLE "Course"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "Course" IS 'The courseID is a 5 digit identifier in use by TAFE for each course.';

--
-- Name: TABLE "CampusDisciplineCourse"; Type: COMMENT; Schema: public; Owner: -
--

CREATE TABLE "CampusDisciplineCourse" (
    "courseID" character(5) NOT NULL,
    "disciplineID" integer NOT NULL,
    "campusID" character(3) NOT NULL,
	CONSTRAINT "pk_CampusDisciplineCourse" PRIMARY KEY ("courseID", "disciplineID", "campusID"),
	CONSTRAINT "fk_CampusDisciplineCourse_CampusDiscipline" FOREIGN KEY ("disciplineID", "campusID")
      REFERENCES "CampusDiscipline" ("disciplineID", "campusID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT "fk_CampusDisciplineCourse_Course" FOREIGN KEY ("courseID")
      REFERENCES "Course" ("courseID") MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
);


--
-- Name: TABLE "CampusDisciplineCourse"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "CampusDisciplineCourse" IS 'Associative entity for the N-M relationship between CampusDiscipline
 and Course. A record here represents a completely unique course,
 i.e. one that has elective modules that other courses of the same courseID may not have.';

 --
-- Name: Assessor; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE "Assessor" (
    "campusID" character(3) NOT NULL,
    "courseID" character(5) NOT NULL,
    "disciplineID" integer NOT NULL,
    "courseCoordinator" boolean NOT NULL,
    "teacherID" character varying(20) NOT NULL,
	CONSTRAINT "pk_Assessor" PRIMARY KEY ("campusID", "courseID", "disciplineID", "teacherID"),
	CONSTRAINT "fk_Assessor_CampusDisciplineCourse" FOREIGN KEY ("campusID", "courseID", "disciplineID")
      REFERENCES "CampusDisciplineCourse" ("campusID", "courseID", "disciplineID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT "fk_Assessor_Teacher" FOREIGN KEY ("teacherID")
      REFERENCES "Teacher" ("teacherID") MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
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
    "option" character(1),
    "requestComp" boolean,
    "submitted" boolean DEFAULT false NOT NULL,
    "assessorID" text,
    "delegateID" text,
    "status" integer DEFAULT 0 NOT NULL,
    CONSTRAINT "ck_Claim_CurrentDate" CHECK (("dateMade" <= ('now'::text)::date)),
    CONSTRAINT "ck_Claim_DateResolved" CHECK (("dateResolved" >= ('now'::text)::date)),
    CONSTRAINT "ck_Claim_Option" CHECK ((option = ANY (ARRAY['C'::bpchar, 'D'::bpchar]))),
	CONSTRAINT "pk_Claim" PRIMARY KEY ("claimID"),
	CONSTRAINT "fk_ClaimAssessorID_TeacherTeacherID" FOREIGN KEY ("assessorID")
      REFERENCES "Teacher" ("teacherID") MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT "fk_ClaimDelegateID_TeacherTeacherID" FOREIGN KEY ("delegateID")
      REFERENCES "Teacher" ("teacherID") MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT "fk_Claim_CampusDisciplineCourse" FOREIGN KEY ("courseID", "disciplineID", "campusID")
      REFERENCES "CampusDisciplineCourse" ("courseID", "disciplineID", "campusID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT "fk_Claim_Student" FOREIGN KEY ("studentID")
      REFERENCES "Student" ("studentID") MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
);


--
-- Name: TABLE "Claim"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "Claim" IS 'A claim is made by a student for one or more modules. The dates of the
 claim''s creation and resolution are recorded, as is the type of claim
 (since some claims need evidence to be provided for Elements while some
 only need evidence for Modules.)';

 --
-- Name: Update; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE "Update" (
    "updateID" integer NOT NULL,
	"claimID" integer NOT NULL,
	"userID" character varying(20) NOT NULL,
	"dateTime" date NOT NULL,
	CONSTRAINT "pk_Update" PRIMARY KEY ("updateID"),
	CONSTRAINT "fk_Update_User" FOREIGN KEY ("userID")
      REFERENCES "User" ("userID") MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
);

--
-- Name: TABLE "Update"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "Update" IS 'keeps track of when a claim is updated and by who.';

--
-- Name: File; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE "File" (
    "fileID" serial UNIQUE NOT NULL,
	"claimID" integer NOT NULL,
	"filename" character varying(50) NOT NULL,
	CONSTRAINT "pk_File" PRIMARY KEY ("fileID")
);

--
-- Name: TABLE "File"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "File" IS 'Keeps track of files that are provided as Evidence for a claim.';

--
-- Name: ClaimedModule; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE "ClaimedModule" (
    "moduleID" character varying(10) NOT NULL,
    "claimID" integer NOT NULL,
    "approved" boolean,
    "arrangementNo" character varying(12),
    "functionalCode" character(4),
    "overseasEvidence" boolean,
    "recognition" character(1),
	CONSTRAINT "pk_ClaimedModule" PRIMARY KEY ("moduleID", "claimID"),
	CONSTRAINT "fk_ClaimedModule_Claim" FOREIGN KEY ("claimID")
      REFERENCES "Claim" ("claimID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT "fk_ClaimedModule_Module" FOREIGN KEY ("moduleID")
      REFERENCES "Module" ("moduleID") MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
);


--
-- Name: TABLE "ClaimedModule"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "ClaimedModule" IS 'A record of this entity represents a Module that has been chosen by a
student for a particular Claim. Certain details are recorded for each
 module, mapping to areas on the ''orange'' and ''yellow'' recognition forms.
  Evidence is provided by a Student against each record here.';

--
-- Name: Element; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE "Element" (
    "elementID" integer NOT NULL,
    "moduleID" character varying(10) NOT NULL,
    "description" text NOT NULL,
	CONSTRAINT "pk_Element" PRIMARY KEY ("elementID", "moduleID"),
	CONSTRAINT "fk_Element_Module" FOREIGN KEY ("moduleID")
      REFERENCES "Module" ("moduleID") MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
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
-- Name: Evidence; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE "Evidence" (
    "claimID" integer NOT NULL,
    "elementID" integer NOT NULL,
    "description" text,
    "moduleID" character varying(10) NOT NULL,
    "approved" boolean,
    "assessorNote" text,
	CONSTRAINT "pk_Evidence" PRIMARY KEY ("claimID", "moduleID", "elementID"),
	CONSTRAINT "fk_Evidence_Element" FOREIGN KEY ("elementID", "moduleID")
      REFERENCES "Element" ("elementID", "moduleID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT "fk_Evidence_ClaimedModule" FOREIGN KEY ("claimID",  "moduleID")
	  REFERENCES "ClaimedModule"("claimID", "moduleID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE

);


--
-- Name: TABLE "Evidence"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "Evidence" IS 'Evidence is made against either a Module or an Element. For each ClaimedModule
 there may be many records in this table, one for each Element, or just one record
 for the entire module depending on the type of claim being made (see "type" in
the table "Claim").';

--
-- Name: Criterion; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE "Criterion" (
    "criterionID" integer NOT NULL,
    "elementID" integer NOT NULL,
    "description" text NOT NULL,
    "moduleID" character varying(10) NOT NULL,
	CONSTRAINT "pk_Criterion" PRIMARY KEY ("criterionID", "elementID", "moduleID"),
	CONSTRAINT "fk_Criterion_Element" FOREIGN KEY ("elementID", "moduleID")
	   REFERENCES "Element"("elementID", "moduleID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE
);


--
-- Name: TABLE "Criterion"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "Criterion" IS 'Each of the criteria belong to an Element, together an element''s criteria
 explain what is required for a student to be granted credit for that element of the Module.';
--
-- Name: Provider; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE "Provider" (
    "providerID" character(1) NOT NULL,
    "name" text NOT NULL,
    CONSTRAINT "ck_Provider_ProviderID" CHECK (("providerID" = ANY (ARRAY['1'::bpchar, '2'::bpchar, '3'::bpchar, '4'::bpchar, '5'::bpchar, '6'::bpchar]))),
	CONSTRAINT "pk_Provider" PRIMARY KEY ("providerID")
);


--
-- Name: TABLE "Provider"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "Provider" IS 'Previous provider codes used on the ''orange'' form are represented here.';

--
-- Name: ClaimedModuleProvider; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE "ClaimedModuleProvider" (
    "claimID" integer NOT NULL,
    "moduleID" character varying(10) NOT NULL,
    "providerID" character(1) NOT NULL,
	CONSTRAINT "pk_ClaimedModuleProvider" PRIMARY KEY ("claimID", "moduleID", "providerID"),
	CONSTRAINT "fk_ClaimedModuleProvider_Provider" FOREIGN KEY ("providerID")
      REFERENCES "Provider" ("providerID") MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT "fk_ClaimedModuleProvider_ClaimedModule" FOREIGN KEY ( "claimID", "moduleID")
   	  REFERENCES "ClaimedModule"( "claimID", "moduleID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE
);


--
-- Name: TABLE "ClaimedModuleProvider"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "ClaimedModuleProvider" IS 'Associative entity resolving the N-M relationship between ClaimedModule
and Provider. A claimed module can have 0..3 providers.';


--
-- Name: Course/Module; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE "CourseModule" (
    "courseID" character(5) NOT NULL,
    "moduleID" character varying(10) NOT NULL,
    "elective" boolean NOT NULL,
    "campusID" character(3),
    "disciplineID" integer,
	CONSTRAINT "pk_CourseModule" PRIMARY KEY ("courseID", "moduleID"),
	CONSTRAINT "fk_CourseModule_ModuleID" FOREIGN KEY ("moduleID")
      REFERENCES "Module" ("moduleID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT "fk_Course/Module_CourseID" FOREIGN KEY ("courseID")
      REFERENCES "Course" ("courseID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE,
        CONSTRAINT "fk_courseModule_CampusDisciplineCourse" FOREIGN KEY ("campusID", "disciplineID", "courseID")
      REFERENCES "CampusDisciplineCourse" ("campusID", "disciplineID", "courseID") MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);


--
-- Name: TABLE "Course/Module"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "CourseModule" IS 'Associative entity resolving the N-M relationship between Course and Module';
