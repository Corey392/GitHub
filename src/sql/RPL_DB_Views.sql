\connect "RPL_2012"

-- View: "vw_AssessorDetails"

-- DROP VIEW "vw_AssessorDetails";

CREATE OR REPLACE VIEW "vw_AssessorDetails" AS 
 SELECT "Teacher"."firstName", "Teacher"."lastName", "Teacher".email, "Teacher"."teacherID", "Assessor"."courseCoordinator", "Assessor"."campusID", "Assessor"."disciplineID", "Assessor"."courseID"
   FROM "Teacher", "Assessor"
  WHERE "Teacher"."teacherID" = "Assessor"."teacherID"::text;

ALTER TABLE "vw_AssessorDetails" OWNER TO postgres;

-- View: "vw_StudentUser"

-- DROP VIEW "vw_StudentUser";

CREATE OR REPLACE VIEW "vw_StudentUser" AS 
 SELECT "Student"."firstName", "User"."userID", "User".role, "User".password, "Student"."lastName", "Student".email
   FROM "User", "Student"
  WHERE "Student"."studentID"::text = "User"."userID";

ALTER TABLE "vw_StudentUser" OWNER TO postgres;
GRANT ALL ON TABLE "vw_StudentUser" TO postgres;
GRANT SELECT ON TABLE "vw_StudentUser" TO student;
COMMENT ON VIEW "vw_StudentUser" IS 'Combines student and user tables for easier access through functions';

-- View: "vw_StudentWithClaims"

-- DROP VIEW "vw_StudentWithClaims";

CREATE OR REPLACE VIEW "vw_StudentWithClaims" AS 
 SELECT "Student"."firstName", "Student"."lastName", "Student".email, "User".role, "User".password, "Student"."studentID", "Claim"."claimID", "Claim"."dateMade", "Claim"."dateResolved", "Claim"."claimType", "Claim"."courseID", "Claim"."campusID", "Claim"."disciplineID", "Claim"."assApproved", "Claim"."delApproved", "Claim".option, "Claim"."requestComp", "Claim".submitted, "Claim".status, "Campus".name AS "campusName", "Discipline".name AS "disciplineName", "Course".name AS "courseName", "ClaimedModule"."moduleID", "ClaimedModule".approved AS "claimedModuleApproved", "Provider"."providerID", "Provider".name AS "providerName", "Evidence".approved AS "evidenceApproved", "Evidence"."assessorNote", "Evidence".description AS "evidenceDescription", "Element".description AS "elementDescription", "Criterion".description AS "criterionDescription", "Criterion"."criterionID", "Element"."elementID"
   FROM "Student", "User", "Claim", "Campus", "Discipline", "Course", "ClaimedModule", "ClaimedModuleProvider", "Provider", "Evidence", "Element", "Criterion"
  WHERE "Student"."studentID"::text = "User"."userID" AND "Claim"."studentID" = "Student"."studentID" AND "Claim"."campusID" = "Campus"."campusID" AND "Claim"."disciplineID" = "Discipline"."disciplineID" AND "Claim"."courseID" = "Course"."courseID" AND "ClaimedModule"."claimID" = "Claim"."claimID" AND "ClaimedModule"."moduleID"::text = "Evidence"."moduleID"::text AND "ClaimedModuleProvider"."moduleID"::text = "ClaimedModule"."moduleID"::text AND "Provider"."providerID" = "ClaimedModuleProvider"."providerID" AND "Evidence"."elementID" = "Element"."elementID" AND "Element"."elementID" = "Criterion"."elementID";

ALTER TABLE "vw_StudentWithClaims" OWNER TO postgres;
COMMENT ON VIEW "vw_StudentWithClaims" IS 'All student data that will be required for a student user';

-- View: "vw_TeacherUser"

-- DROP VIEW "vw_TeacherUser";

CREATE OR REPLACE VIEW "vw_TeacherUser" AS 
 SELECT "Teacher"."teacherID", "Teacher".email, "Teacher"."lastName", "Teacher"."firstName", "User".password, "User"."role"
   FROM "User", "Teacher"
  WHERE "User"."userID" = "Teacher"."teacherID";

ALTER TABLE "vw_TeacherUser" OWNER TO postgres;
COMMENT ON VIEW "vw_TeacherUser" IS 'Combines teacher and user tables';

-- View: "vw_ClaimedModule_Module"

-- DROP VIEW "vw_ClaimedModule_Module";

CREATE OR REPLACE VIEW "vw_ClaimedModule_Module" AS 
 SELECT "ClaimedModule"."moduleID", "ClaimedModule"."studentID", "ClaimedModule"."claimID", "ClaimedModule".approved, "ClaimedModule"."arrangementNo", "ClaimedModule"."functionalCode", "ClaimedModule"."overseasEvidence", "ClaimedModule".recognition, "Module".name, "Module".instructions
   FROM "ClaimedModule", "Module"
  WHERE "ClaimedModule"."moduleID" = "Module"."moduleID";

ALTER TABLE "vw_ClaimedModule_Module" OWNER TO postgres;
