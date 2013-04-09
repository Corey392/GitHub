/* Purpose:  	Adds the Views to the database.
 * Authors:		Ryan,Kelly,v2-Todd
 * Created:		
 * Version:		4
 * Modified:	08/04/2013
 * Change Log:	v2: Todd: Added required GRANT statement for the 'vw_TeacherUser' for a 'Teacher' to actually be able to access it.
 * 				v3: Ryan: 
 * 				v4: Todd: Corrected DROP VIEW statements, added IF EXISTS, and added to other views where it was not.
 * Pre-conditions: Must be run after database tables have been created
 */
--
-- Name: vw_AssessorDetails; Type: VIEW; Schema: public; Owner: -
--
DROP VIEW IF EXISTS "vw_AssessorDetails";

CREATE VIEW "vw_AssessorDetails" AS
    SELECT "User"."firstName", "User"."lastName", "User".email, "Teacher"."teacherID", "Assessor"."courseCoordinator", "Assessor"."campusID", "Assessor"."disciplineID", "Assessor"."courseID" 
	FROM "User", "Teacher", "Assessor" 
	WHERE ("Teacher"."teacherID" = ("Assessor"."teacherID")::text) AND ("Teacher"."userID" = ("User"."userID")::text);


--
-- Name: vw_StudentUser; Type: VIEW; Schema: public; Owner: -
--
DROP VIEW IF EXISTS "vw_StudentUser";

CREATE VIEW "vw_StudentUser" AS
    SELECT  "User"."userID", "User"."lastName", "User"."firstName", "User".role, "User".password, "User".email 
	FROM "User", "Student" 
	WHERE (("Student"."studentID")::text = "User"."userID");

--
-- Name: VIEW "vw_StudentUser"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW "vw_StudentUser" IS 'Combines student and user tables for easier access through functions';


--
-- Name: vw_TeacherUser; Type: VIEW; Schema: public; Owner: -
--
DROP VIEW IF EXISTS "vw_TeacherUser";

CREATE VIEW "vw_TeacherUser" AS
    SELECT "Teacher"."teacherID", "User".email, "User"."lastName", "User"."firstName", "User".password, "User".role, "User"."userID" 
	FROM "User", "Teacher" 
	WHERE ("User"."userID" = "Teacher"."teacherID");

--
-- Name: VIEW "vw_TeacherUser"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW "vw_TeacherUser" IS 'Combines teacher and user tables';


--
-- Name: vw_ClaimedModule_Module; Type: VIEW; Schema: public; Owner: -
--
DROP VIEW IF EXISTS "vw_ClaimedModule_Module";

CREATE VIEW "vw_ClaimedModule_Module" AS
    SELECT "ClaimedModule"."moduleID",  "ClaimedModule"."claimID", "ClaimedModule".approved, "ClaimedModule"."arrangementNo", "ClaimedModule"."functionalCode", "ClaimedModule"."overseasEvidence", "ClaimedModule".recognition, "Module".name, "Module".instructions 
	FROM "ClaimedModule", "Module" 
	WHERE (("ClaimedModule"."moduleID")::text = ("Module"."moduleID")::text);

--
-- Name: vw_StudentWithClaims; Type: VIEW; Schema: public; Owner: -
--
DROP VIEW IF EXISTS "vw_StudentWithClaims";

CREATE VIEW "vw_StudentWithClaims" AS
    SELECT "User"."firstName", "User"."lastName", "User".email, "User".role, "User".password, "Student"."studentID", "Claim"."claimID", "Claim"."dateMade", "Claim"."dateResolved", "Claim"."claimType", "Claim"."courseID", "Claim"."campusID", "Claim"."disciplineID", "Claim"."assApproved", "Claim"."delApproved", "Claim"
	.option, "Claim"."requestComp", "Claim".submitted, "Claim".status, "Campus".name AS "campusName", "Discipline".name AS "disciplineName", "Course".name AS "courseName", "ClaimedModule"."moduleID", "ClaimedModule".approved AS "claimedModuleApproved", "Provider"."providerID", "Provider".name AS "providerName", "Evidence".approved AS "evidenceApproved", "Evidence"."assessorNote", "Evidence".description AS "evidenceDescription", "Element".description AS "elementDescription", "Criterion".description AS "criterionDescription", "Criterion"."criterionID", "Element"."elementID" 
	FROM "Student", "User", "Claim", "Campus", "Discipline", "Course", "ClaimedModule", "ClaimedModuleProvider", "Provider", "Evidence", "Element", "Criterion" 
	WHERE (((((((((((("Student"."studentID")::text = "User"."userID") AND ("Claim"."studentID" = "Student"."studentID")) AND ("Claim"."campusID" = "Campus"."campusID")) AND ("Claim"."disciplineID" = "Discipline"."disciplineID")) AND ("Claim"."courseID" = "Course"."courseID")) AND ("ClaimedModule"."claimID" = "Claim"."claimID")) AND (("ClaimedModule"."moduleID")::text = ("Evidence"."moduleID")::text)) AND (("ClaimedModuleProvider"."moduleID")::text = ("ClaimedModule"."moduleID")::text)) AND ("Provider"."providerID" = "ClaimedModuleProvider"."providerID")) AND ("Evidence"."elementID" = "Element"."elementID")) AND ("Element"."elementID" = "Criterion"."elementID"));


--
-- Name: VIEW "vw_StudentWithClaims"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW "vw_StudentWithClaims" IS 'All student data that will be required for a student user';


--
-- Name: vw_ModulesInCourse; Type: VIEW; Schema: public; Owner: -
--
DROP VIEW IF EXISTS "vw_ModulesInCourse";

CREATE VIEW "vw_ModulesInCourse" AS
	SELECT "CourseModule"."moduleID", "CourseModule"."courseID", "Course"."name" AS "Course Name", "Module"."name" AS "Module Name"
	FROM "Module", "Course", "CourseModule"
	WHERE ("Course"."courseID")::text = ("CourseModule"."courseID")::text;

--
-- Name: vw_ModulesOutOfCourse; Type: VIEW; Schema: public; Owner: -
--
DROP VIEW IF EXISTS "vw_ModulesOutOfCourse";

CREATE VIEW "vw_ModulesOutOfCourse" AS
	SELECT "CourseModule"."moduleID", "CourseModule"."courseID", "Course"."name" AS "Course Name", "Module"."name" AS "Module Name"
	FROM "Module", "Course", "CourseModule"
	WHERE ("Course"."courseID")::text <> ("CourseModule"."courseID")::text;


-- Added 03/04/2013, Todd Wiggins
-- Required for Teacher to be able to login.
GRANT SELECT ON TABLE "vw_TeacherUser" TO teacher;
