/* Purpose:  	Adds the Views to the database.
 * Authors:		Ryan,Kelly,Todd
 * Created:
 * Version:		4.010
 * Modified:	06/05/2013
 * Change Log:	v2: Todd: Added new users into User, Student, Teacher and Assessor tables.
 * 				v3: Ryan:
				09/04/2013: Todd:   Updated Student inserts to match new table structure
				25/04/2013: Todd:   Added more insert statements for CourseModule
				06/05/2013: Bryce:  Updated insert statements to match new Element PK system
 * Pre-conditions: Must be run after all other setup database scripts.
 */
 --
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: -
--
-- userID, role, password, email, firstName, lastName
INSERT INTO "User" VALUES ('deb.spindler', 'T', '\\x3063613462626136666665343332313039376136336263666465316162323033', 'deb.spindler@tafensw.edu.au', 'deb', 'spindler');
INSERT INTO "User" VALUES ('kim.king6', 'T', '\\x3763633062336435383630336538303438313639336565343931376436356631','kim.king6@tafensw.edu.au','kim', 'king');
INSERT INTO "User" VALUES ('steve.etherington', 'T', '\\x6339346131653661663139663765336161313565643465656535656134356134','steve.etherington@tafensw.edu.au','steve', 'etherington');
INSERT INTO "User" VALUES ('clerical.person', 'C', '\\x3066313437333539343932376466623434396239393633633031343363346334', 'clerical@tafensw.edu.au', 'clericla', 'person');
INSERT INTO "User" VALUES ('admin.person', 'A', '\\x3231323332663239376135376135613734333839346130653461383031666333', 'admin@tafensw.edu.au', 'admin', 'person');
INSERT INTO "User" VALUES ('me.me', 'T', '\\x3731336466313366653464353765353263356363666666643262306131376638', 'me.me@tafensw.edu.au','me', 'me');
INSERT INTO "User" VALUES ('355878634', 'S', '\\x6535383964616632626238323163376134393163333838643736613965346330', 'Henry.Tudor@tafensw.net.au', 'Henry', 'Tudor');
INSERT INTO "User" VALUES ('a.g', 'T', '\\x3130656532653763343036333739333237633230316662316639323234373734','a.g@tafe.nsw.edu.au','a', 'g');
INSERT INTO "User" VALUES ('adam.shortall', 'T', '\\x3763623031666535343662653430386633373635643438633665313033316461', 'adam.shortall@tafensw.net.au', 'Adam', 'Shortall');
INSERT INTO "User" VALUES ('a.b', 'T', '\\x6534653164666561316138343333323863663661313064643231346662316162','a.b@tafe.nsw.edu.au','a', 'b');
-- 02/04/2013, (Todd Wiggins): Our usernames -- All password = password
SELECT fn_insertuser('374371959','password','S','todd.wiggins3@tafensw.net.au','Todd','Wiggins');
SELECT fn_insertuser('365044651','password','S','mitch________@tafensw.net.au','Mitch','Carr');
SELECT fn_insertuser('366796436','password','S','bryce________@tafensw.net.au','Bryce','Carr');
SELECT fn_insertuser('355273971','password','S','ryan.donaldson3@tafensw.net.au','Ryan','Donaldson');
SELECT fn_insertuser('366688315','password','S','kelly.bayliss3@tafensw.net.au','Kelly','Bayliss');
-- 02/04/2013, (Todd Wiggins): Other roles -- All password = password
SELECT fn_insertuser('teacher','password','T','email@teacher','Teacher','Teacher');
SELECT fn_insertuser('assessor','password','A','email@assessor','Assessor','Assessor');
SELECT fn_insertuser('admin','password','C','email@admin','Admin','Admin');
-- 03/04/2013, (Todd Wiggins): Student/Teacher/Assessor Data to match the user names created
INSERT INTO "Student" VALUES ('374371959',NULL,NULL,NULL,'Ourimbah','NSW',2258,NULL,'374371959',false);
INSERT INTO "Student" VALUES ('365044651',NULL,NULL,NULL,'Hornsby','NSW',2000,NULL,'365044651',false);
INSERT INTO "Student" VALUES ('366796436',NULL,NULL,NULL,'Gorokan','NSW',2265,NULL,'366796436',false);
INSERT INTO "Student" VALUES ('355273971',NULL,NULL,NULL,'Newcastle','NSW',2500,NULL,'355273971',false);
INSERT INTO "Student" VALUES ('366688315',NULL,NULL,NULL,'Newcastle','NSW',2500,NULL,'366688315',false);
INSERT INTO "Teacher" VALUES ('teacher','teacher');
INSERT INTO "Teacher" VALUES ('assessor','assessor');
INSERT INTO "Teacher" VALUES ('admin','admin');

--
-- Data for Name: Teacher; Type: TABLE DATA; Schema: public; Owner: -
--
-- userID, teacherID
INSERT INTO "Teacher" VALUES ('deb.spindler','deb.spindler' );
INSERT INTO "Teacher" VALUES ('kim.king6', 'kim.king6');
INSERT INTO "Teacher" VALUES ('steve.etherington', 'steve.etherington');
INSERT INTO "Teacher" VALUES ('me.me', 'me.me');
INSERT INTO "Teacher" VALUES ('a.g', 'a.g');
INSERT INTO "Teacher" VALUES ('adam.shortall', 'adam.shortall');
INSERT INTO "Teacher" VALUES ('a.b', 'a.b');

--
-- Data for Name: Student; Type: TABLE DATA; Schema: public; Owner: -
--
-- userID, otherName, address1, address2, state, phoneNumber, postCode, staff, studentID, town
INSERT INTO "Student" VALUES ('adam.shortall', NULL, NULL, NULL, 'Hamilton', 'NSW', 2303,NULL, '355878635', true );
INSERT INTO "Student" VALUES ('355878634', NULL, NULL, NULL, 'Hamilton', 'NSW', 2303,NULL, '355878634', false);

--
-- Data for Name: Campus; Type: TABLE DATA; Schema: public; Owner: -
--
-- campusID, name
INSERT INTO "Campus" VALUES ('011', 'Ourimbah');
INSERT INTO "Campus" VALUES ('022', 'Wyong');
INSERT INTO "Campus" VALUES ('656', 'dfghdgdf');

--
-- Data for Name: Discipline; Type: TABLE DATA; Schema: public; Owner: -
--
-- disciplineID, name
INSERT INTO "Discipline" VALUES (1, 'Information Technology');
INSERT INTO "Discipline" VALUES (2, 'Business');

--
-- Data for Name: CampusDiscipline; Type: TABLE DATA; Schema: public; Owner: -
--
-- campusID, disciplineID
INSERT INTO "CampusDiscipline" VALUES ('011', 1);
INSERT INTO "CampusDiscipline" VALUES ('022', 2);
INSERT INTO "CampusDiscipline" VALUES ('656', 2);

--
-- Data for Name: Delegate; Type: TABLE DATA; Schema: public; Owner: -
--
-- disciplineID, campusID, teacherID
INSERT INTO "Delegate" VALUES (1, '011', 'deb.spindler');

--
-- Data for Name: Module; Type: TABLE DATA; Schema: public; Owner: -
--
-- moduleID, name, instructions
INSERT INTO "Module" VALUES ('ICAA5151B', 'Gather data to identify business requirements', '');
INSERT INTO "Module" VALUES ('ICAA5158B', 'Translate business needs into technical requirements', '');
INSERT INTO "Module" VALUES ('ICAA5046B', 'Model preferred business solutions', '');
INSERT INTO "Module" VALUES ('ICAA5139B', 'Design a database', '');

--
-- Data for Name: Course; Type: TABLE DATA; Schema: public; Owner: -
--
-- cousreID, name, guideFileAddress
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
-- Data for Name: CampusDisciplineCourse; Type: TABLE DATA; Schema: public; Owner: -
--
-- courseID, disciplineID, campusID
INSERT INTO "CampusDisciplineCourse" VALUES ('19018', 1, '011');
INSERT INTO "CampusDisciplineCourse" VALUES ('19003', 1, '011');
INSERT INTO "CampusDisciplineCourse" VALUES ('19010', 1, '011');
INSERT INTO "CampusDisciplineCourse" VALUES ('45879', 1, '011');

--
-- Data for Name: Assessor; Type: TABLE DATA; Schema: public; Owner: -
-- campusID, courseID, disciplineID, courseCoordinator, teacherID
INSERT INTO "Assessor" VALUES ('011', '19018', 1, true, 'deb.spindler');
INSERT INTO "Assessor" VALUES ('011', '19010', 1, true, 'steve.etherington');

--
-- Data for Name: Claim; Type: TABLE DATA; Schema: public; Owner: -
--
-- claimID, studentID, dateMade, dateResolved, claimType, courseID, campusID, disciplineID, assApproved, delApproved, option, requestComp, submitted, assessorID, delegateID, status
INSERT INTO "Claim" VALUES (1, '355878635',  now()::date, NULL, false, '19018', '011', 1, NULL, NULL, NULL, NULL, false, NULL, NULL, 0);
INSERT INTO "Claim" VALUES (2, '355878635',  now()::date, NULL, false, '19018', '011', 1, NULL, NULL, NULL, NULL, false, NULL, NULL, 0);

--
-- Data for Name: Update; Type: TABLE DATA; Schema: public; Owner: -
--
-- updateID, claimID, userID, dateTime
INSERT INTO "Update" VALUES (12, 1, 'adam.shortall', '2012-02-19');
INSERT INTO "Update" VALUES (13, 1, 'deb.spindler', '2012-03-22');

--
-- Data for Name: File; Type: TABLE DATA; Schema: public; Owner: -
--
-- fileID, claimID, filename
INSERT INTO "File" VALUES (11, 1, 'something.txt');
INSERT INTO "File" VALUES (12, 2, 'someother.txt');

--
-- Data for Name: ClaimedModule; Type: TABLE DATA; Schema: public; Owner: -
--
-- moduleID, claimID, approved, arrangementNo, functionalCode, overseasEvidence, recognition
INSERT INTO "ClaimedModule" VALUES ('ICAA5046B', 1, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "ClaimedModule" VALUES ('ICAA5046B', 2, NULL, NULL, NULL, NULL, NULL);
INSERT INTO "ClaimedModule" VALUES ('ICAA5151B', 2, NULL, NULL, NULL, NULL, NULL);

--
-- Data for Name: Element; Type: TABLE DATA; Schema: public; Owner: -
--
-- elementID, moduleID, description
INSERT INTO "Element" VALUES (1, 'ICAA5151B', ' ');
INSERT INTO "Element" VALUES (1, 'ICAA5158B', ' ');
INSERT INTO "Element" VALUES (1, 'ICAA5046B', ' ');
INSERT INTO "Element" VALUES (1, 'ICAA5139B', ' ');
INSERT INTO "Element" VALUES (2, 'ICAA5046B', 'Implement and monitor participative arrangements for the management of OHS');
INSERT INTO "Element" VALUES (3, 'ICAA5046B', 'Provide information to the workgroup about OHS policies and procedures.');
INSERT INTO "Element" VALUES (2, 'ICAA5151B', 'Investigate current practices in relation to resource usage');

--
-- Data for Name: Evidence; Type: TABLE DATA; Schema: public; Owner: -
--
-- claimID, elementID, description, moduleID, approved, assessorNote
--INSERT INTO "Evidence" VALUES ( 1, 0, 'BUSB0101', 'ICAA5046B', NULL, NULL);
--INSERT INTO "Evidence" VALUES ( 2, 0, 'BUSB0101', 'ICAA5046B', false, '');
--INSERT INTO "Evidence" VALUES ( 2, 0, 'ggfgdgfd', 'ICAA5151B', false, '');

--
-- Data for Name: Criterion; Type: TABLE DATA; Schema: public; Owner: -
--
-- criterionID, elementID, description, moduleID
INSERT INTO "Criterion" VALUES (1, 1, 'Accurately explain relevant provisions of OHS legislation and codes of practice to the workgroup.', 'ICAA5158B');
INSERT INTO "Criterion" VALUES (2, 1, 'Provide information to the workgroup on the organisation''s OHS policies, procedures and programs, ensuring it is readily accessible by the workgroup.', 'ICAA5158B');
INSERT INTO "Criterion" VALUES (3, 1, 'Regularly provide and clearly explain information about identified hazards and the outcomes of risk assessment and control to the workgroup.', 'ICAA5158B');
INSERT INTO "Criterion" VALUES (1, 2, 'Identify environmental regulations applying to the enterprise', 'ICAA5046B');
INSERT INTO "Criterion" VALUES (2, 1, 'Analyse procedures for assessing compliance with environmental/sustainability regulations', 'ICAA5139B');
INSERT INTO "Criterion" VALUES (3, 1, 'Collect information on environmental and resource efficiency systems and procedures, and provide to the work group where appropriate', 'ICAA5046B');

--
-- Data for Name: Provider; Type: TABLE DATA; Schema: public; Owner: -
--
-- providerID, name
INSERT INTO "Provider" VALUES ('1', 'University');
INSERT INTO "Provider" VALUES ('2', 'Adult and Community Education');
INSERT INTO "Provider" VALUES ('3', 'School');
INSERT INTO "Provider" VALUES ('4', 'TAFE NSW');
INSERT INTO "Provider" VALUES ('5', 'Other VET provider');
INSERT INTO "Provider" VALUES ('6', 'Non-formal/other');

--
-- Data for Name: ClaimedModuleProvider; Type: TABLE DATA; Schema: public; Owner: -
--
-- claimID, moduleID, providerID
INSERT INTO "ClaimedModuleProvider" VALUES ( 1, 'ICAA5046B', '1');
INSERT INTO "ClaimedModuleProvider" VALUES ( 2, 'ICAA5046B', '1');
INSERT INTO "ClaimedModuleProvider" VALUES ( 2, 'ICAA5151B', '1');
INSERT INTO "ClaimedModuleProvider" VALUES ( 2, 'ICAA5151B', '2');
INSERT INTO "ClaimedModuleProvider" VALUES ( 2, 'ICAA5151B', '4');
INSERT INTO "ClaimedModuleProvider" VALUES ( 2, 'ICAA5151B', '5');


--
-- Data for Name: CourseModule; Type: TABLE DATA; Schema: public; Owner: -
--
-- courseID, ModuleID
INSERT INTO "CourseModule" VALUES ('19003', 'ICAA5151B',true);
INSERT INTO "CourseModule" VALUES ('19010', 'ICAA5158B',false);
INSERT INTO "CourseModule" ("courseID","moduleID","elective") VALUES
	('19010','ICAA5151B',true),
	('19010','ICAA5139B',true),
	('19010','ICAA5046B',true);
