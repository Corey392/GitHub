/* Purpose:  	Adds the Views to the database.
 * Authors:		Ryan,Kelly,Todd,Mitch
 * Created:		?
 * Version:		4.014
 * Modified:	15/06/2013
 * Change Log:	v2: Todd: Added new users into User, Student, Teacher and Assessor tables.
 * 				v3: Ryan:
				09/04/2013: Todd:   Updated Student inserts to match new table structure
				25/04/2013: Todd:   Added more insert statements for CourseModule
				06/05/2013: Bryce:  Updated insert statements to match new Element PK system
				08/05/2013: Todd:   Removed Evidence for claims. Add from a claim on site instead.
				05/06/2013: Todd:   Added sample data for the Demonstration.
				15/06/2013: Mitch:  Removed sample data not intended for Demonstration.
					    Mitch:  Further removal of sample data not intended for Demonstration.
                                18/06/2013: Bryce:  Put removed Criterion back.
                                                    Added 'demo_steve' to Assessor table for the presentation.
 * Pre-conditions: Must be run after all other setup database scripts.
 */

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
-- Data for Name: File; Type: TABLE DATA; Schema: public; Owner: -
--
-- fileID, claimID, filename
INSERT INTO "File" VALUES (11, 1, 'something.txt');
INSERT INTO "File" VALUES (12, 2, 'someother.txt');

--
-- Data for Name: Element; Type: TABLE DATA; Schema: public; Owner: -
--
-- elementID, moduleID, description
INSERT INTO "Element" VALUES (1, 'ICAA5151B', 'Database Development and Design');
INSERT INTO "Element" VALUES (1, 'ICAA5158B', 'Implement and Mointor web development');
INSERT INTO "Element" VALUES (1, 'ICAA5046B', 'Provide information to the workgroup about team policies');
INSERT INTO "Element" VALUES (1, 'ICAA5139B', 'Investigate and suggest improvements to the cost to running the operation');
INSERT INTO "Element" VALUES (2, 'ICAA5046B', 'Implement and monitor participative arrangements for the management of OHS');
INSERT INTO "Element" VALUES (3, 'ICAA5046B', 'Provide information to the workgroup about OHS policies and procedures.');
INSERT INTO "Element" VALUES (2, 'ICAA5151B', 'Investigate current practices in relation to resource usage');

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
-- Data for Name: CourseModule; Type: TABLE DATA; Schema: public; Owner: -
--
-- courseID, ModuleID
INSERT INTO "CourseModule" VALUES ('19003', 'ICAA5151B',true);
INSERT INTO "CourseModule" VALUES ('19010', 'ICAA5158B',false);
INSERT INTO "CourseModule" ("courseID","moduleID","elective") VALUES
	('19010','ICAA5151B',true),
	('19010','ICAA5139B',true),
	('19010','ICAA5046B',true);


/* Sample Data for Presentation : RELIES UPON SOME OF THE INFORMATION ABOVE */
-- Create new users: 123456789, demo_steve, demo_deb, demo_admin, all passwords are 'password'
-- Course to create a claim for: 19010: Certificate IV in Information Technology (Programming)
SELECT fn_insertstudent('123456789','demo.student@tafensw.net.au','(DEMO) Jimmy','Jones','Jake','123 Fake Street','','Faketown','NSW',2315,'02 4343 4343','123456789',false,'password');
SELECT fn_insertUser('demo_steve','password','T','stephen.etherington@tafe.nsw.edu.au','(DEMO) Stephen','Etherington');
SELECT fn_insertUser('demo_deb','password','A','deborah.spindler@tafe.nsw.edu.au','(DEMO) Deb','Spindler');
SELECT fn_insertUser('demo_admin','password','C','admin@tafe.nsw.edu.au','(DEMO) Admin','Istrator');
SELECT fn_updateuser('demo_steve','demo_steve','password');
SELECT fn_updateuser('demo_deb','demo_deb','password');
INSERT INTO "Teacher" VALUES ('demo_deb','demo_deb');
INSERT INTO "Teacher" VALUES ('demo_steve','demo_steve');
INSERT INTO "Assessor" VALUES ('011', '19010', 1, false, 'demo_steve');
-- Uses Campus 011, Discipline 1, Course 19010, the 4 Modules, Elements, Criterions,
INSERT INTO "Criterion" VALUES (1, 3, 'Accurately explain relevant provisions of OHS legislation and codes of practice to the workgroup.', 'ICAA5046B');
INSERT INTO "Criterion" VALUES (2, 3, 'Provide information to the workgroup on the organisation''s OHS policies, procedures and programs, ensuring it is readily accessible by the workgroup.', 'ICAA5046B');
INSERT INTO "Criterion" VALUES (1, 1, 'Regularly provide and clearly explain information about identified hazards and the outcomes of risk assessment and control to the workgroup.', 'ICAA5151B');
INSERT INTO "Criterion" VALUES (2, 1, 'Identify environmental regulations applying to the enterprise', 'ICAA5151B');
INSERT INTO "Criterion" VALUES (1, 2, 'Analyse procedures for assessing compliance with environmental/sustainability regulations', 'ICAA5151B');
INSERT INTO "Criterion" VALUES (2, 2, 'Collect information on environmental and resource efficiency systems and procedures, and provide to the work group where appropriate', 'ICAA5151B');
