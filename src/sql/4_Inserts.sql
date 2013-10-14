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
				12/8/2013:  Corey: 	Added more test data.
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
INSERT INTO "Module" VALUES ('ICAICT401A', 'Determine and confirm client business requirements', '');
INSERT INTO "Module" VALUES ('ICAICT403A', 'Apply software development methodologies', '');
INSERT INTO "Module" VALUES ('ICAICT404A', 'Use Online learning tools', '');
INSERT INTO "Module" VALUES ('ICAICT407A', 'Maintain website information standards', '');
INSERT INTO "Module" VALUES ('ICAICT408A', 'Create technical documentation', '');
INSERT INTO "Module" VALUES ('ICAICT417A', 'Identify, evaluate and apply current industry-specific technologies to meet industry standards', '');
INSERT INTO "Module" VALUES ('ICAICT418A', 'Contribute to copyright, ethics and privacy in an IT environment', '');
INSERT INTO "Module" VALUES ('ICAICT420A', 'Develop client user interface', '');
INSERT INTO "Module" VALUES ('ICAPRG401A', 'Maintain open-source code programs', '');
INSERT INTO "Module" VALUES ('ICAPRG402A', 'Apply query language', '');
INSERT INTO "Module" VALUES ('ICAPRG403A', 'Develop data-driven applications', '');
INSERT INTO "Module" VALUES ('ICAPRG404A', 'Test applications', '');
INSERT INTO "Module" VALUES ('ICAPRG405A', 'Automate processes', '');
INSERT INTO "Module" VALUES ('ICAPRG406A', 'Apply introductory object-oriented language skills', '');
INSERT INTO "Module" VALUES ('ICAPRG407A', 'Write script for software applications', '');
INSERT INTO "Module" VALUES ('ICAPRG409A', 'Develop mobile applications', '');
INSERT INTO "Module" VALUES ('ICAPRG410A', 'Build a user interface', '');
INSERT INTO "Module" VALUES ('ICAPRG412A', 'Configure and maintain databases', '');
INSERT INTO "Module" VALUES ('ICAPRG413A', 'Use a library or pre-existing components', '');
INSERT INTO "Module" VALUES ('ICAPRG414A', 'Apply introductory programming skills in another language', '');
INSERT INTO "Module" VALUES ('ICAPRG415A', 'Apply skills in object-oriented design', '');
INSERT INTO "Module" VALUES ('ICAPRG418A', 'Apply intermediate programming skills in another language', '');
INSERT INTO "Module" VALUES ('ICAPRG419A', 'Analyse software requirements', '');
INSERT INTO "Module" VALUES ('ICAPRG425A', 'Use structured query language', '');
INSERT INTO "Module" VALUES ('ICAPRG427A', 'Use XML effectively', '');
INSERT INTO "Module" VALUES ('ICAPRG428A', 'Use regular expressions in programming languages', '');
INSERT INTO "Module" VALUES ('ICAPRG527A', 'Apply intermediate object-oriented language skills', '');
INSERT INTO "Module" VALUES ('ICAWEB401A', 'Design a website to meet technical requirements', '');
INSERT INTO "Module" VALUES ('ICAWEB402A', 'Confirm accessibility of websites for people with special needs', '');
INSERT INTO "Module" VALUES ('ICAWEB403A', 'Transfer content to a website using commercial packages', '');
INSERT INTO "Module" VALUES ('ICAWEB404A', 'Maintain website performance', '');
INSERT INTO "Module" VALUES ('ICAWEB405A', 'Monitor traffic and compile website traffic reports', '');
INSERT INTO "Module" VALUES ('ICAWEB406A', 'Create website testing procedures', '');
INSERT INTO "Module" VALUES ('ICAWEB407A', 'Conduct operational acceptance tests of websites', '');
INSERT INTO "Module" VALUES ('ICAWEB408A', 'Ensure basic website security', '');
INSERT INTO "Module" VALUES ('ICAWEB409A', 'Develop cascading style sheets', '');
INSERT INTO "Module" VALUES ('ICAWEB410A', 'Apply web authoring tool to convert client data for websites', '');
INSERT INTO "Module" VALUES ('ICAWEB411A', 'Produce basic client-side script for dynamic web pages', '');
INSERT INTO "Module" VALUES ('ICAWEB412A', 'Produce interactive web animation', '');
INSERT INTO "Module" VALUES ('ICAWEB413A', 'Optimise search engines', '');
INSERT INTO "Module" VALUES ('ICAWEB414A', 'Design simple web page layouts', '');
INSERT INTO "Module" VALUES ('ICAWEB415A', 'Produce server-side script for dynamic web pages', '');
INSERT INTO "Module" VALUES ('ICAWEB416A', 'Customise content management system', '');
INSERT INTO "Module" VALUES ('ICAWEB417A', 'Integrate social web technologies', '');
INSERT INTO "Module" VALUES ('ICAWEB421A', 'Ensure website content meets technical protocols and standards', '');
INSERT INTO "Module" VALUES ('ICAWEB424A', 'Evaluate and select a web hosting service', '');
INSERT INTO "Module" VALUES ('ICAWEB425A', 'Apply structured query language to extract and manipulate data', '');
INSERT INTO "Module" VALUES ('ICAWEB429A', 'Create a markup language document to specification', '');
INSERT INTO "Module" VALUES ('ICANWK401A', 'Install and manage a server', '');
INSERT INTO "Module" VALUES ('ICANWK402A', 'Install and configure virtual machines for sustainable ICT', '');
INSERT INTO "Module" VALUES ('ICANWK403A', 'Manage network and data integrity', '');
INSERT INTO "Module" VALUES ('ICANWK404A', 'Install, operate and troubleshoot a small enterprise branch network', '');
INSERT INTO "Module" VALUES ('ICANWK405A', 'Build a small wireless local area network', '');
INSERT INTO "Module" VALUES ('ICANWK406A', 'Install, configure and test network security', '');
INSERT INTO "Module" VALUES ('ICANWK407A', 'Install and configure client-server applications and services', '');
INSERT INTO "Module" VALUES ('ICANWK408A', 'Configure a desktop environment', '');
INSERT INTO "Module" VALUES ('ICANWK409A', 'Create scripts for networking', '');
INSERT INTO "Module" VALUES ('ICANWK410A', 'Install hardware to a network', '');
INSERT INTO "Module" VALUES ('ICANWK411A', 'Deploy software to networked computers', '');
INSERT INTO "Module" VALUES ('ICANWK412A', 'Create network documentation', '');
INSERT INTO "Module" VALUES ('ICADBS403A', 'Create basic databases', '');
INSERT INTO "Module" VALUES ('ICAPMG401A', 'Support small scale IT projects', '');
INSERT INTO "Module" VALUES ('ICASAD401A', 'Develop and present feasibility reports', '');
INSERT INTO "Module" VALUES ('ICASAD501A', 'Model data objects', '');
INSERT INTO "Module" VALUES ('ICASAD502A', 'Model data processes', '');
INSERT INTO "Module" VALUES ('ICASAS426A', 'Locate and troubleshoot IT equipment, system and software faults', '''');
INSERT INTO "Module" VALUES ('BSBCRT401A', 'Articulate, present and debate ideas', '');
INSERT INTO "Module" VALUES ('BSBOHS302B', 'Participate effectively in OHS communication and consultative processes', '');
INSERT INTO "Module" VALUES ('BSBSUS301A', 'Implement and monitor environmentally sustainable work practices', '');
INSERT INTO "Module" VALUES ('BSBWOR404B', 'Develop work priorities', '');
INSERT INTO "Module" VALUES ('CUFPPM404A', 'Create storyboards', '');
--Uncomment when database changes made to ID
--INSERT INTO "Module" VALUES ('ICTSUS4183A', 'Install and test renewable energy system for ICT networks', '');
--INSERT INTO "Module" VALUES ('ICTSUS4184A', 'Install and test power saving hardware', '');
--INSERT INTO "Module" VALUES ('ICTSUS4185A', 'Install and test power management software', '');
--INSERT INTO "Module" VALUES ('ICTSUS4186A', 'Install thin client applications for power over ethernet', '');
--INSERT INTO "Module" VALUES ('ICTOPN4116A', 'Use advanced optical test equipment', '');
--INSERT INTO "Module" VALUES ('ICTTEN4198A', 'Install, configure and test an internet protocol network', '');
--INSERT INTO "Module" VALUES ('ICTTEN4199A', 'Install, configure and test a router', '');
--INSERT INTO "Module" VALUES ('ICTTEN4202A', 'Install and test a radio frequency identification system', '');
--INSERT INTO "Module" VALUES ('ICTTEN4210A', 'Implement and troubleshoot enterprise routers and switches', '');
--INSERT INTO "Module" VALUES ('ICTTEN4211A', 'Design, install and configure an internetwork', '');
--INSERT INTO "Module" VALUES ('ICTTEN5200A', 'Install, configure and test a local area network switch', '');

--
-- Data for Name: Course; Type: TABLE DATA; Schema: public; Owner: -
--
-- cousreID, name, guideFileAddress
INSERT INTO "Course" VALUES ('10309', 'Certificate IV in Information Technology', NULL);
INSERT INTO "Course" VALUES ('10315', 'Certificate IV in Web-Based Technologies', NULL);
INSERT INTO "Course" VALUES ('10316', 'Certificate IV in Information Technology Networking', NULL);
INSERT INTO "Course" VALUES ('10317', 'Certificate IV in Programming', NULL);
INSERT INTO "Course" VALUES ('10322', 'Certificate IV in Digital Media Technologies', NULL);
INSERT INTO "Course" VALUES ('10326', 'Certificate IV in Computer Systems Technology', NULL);
INSERT INTO "Course" VALUES ('10327', 'Diploma of Information Technology', NULL);
INSERT INTO "Course" VALUES ('10333', 'Diploma of Information Technology Networking', NULL);
INSERT INTO "Course" VALUES ('10334', 'Diploma of Database Design and Development', NULL);
INSERT INTO "Course" VALUES ('10335', 'Diploma of Website Development', NULL);
INSERT INTO "Course" VALUES ('10336', 'Diploma of Software Development', NULL);

--
-- Data for Name: CampusDisciplineCourse; Type: TABLE DATA; Schema: public; Owner: -
--
-- courseID, disciplineID, campusID
INSERT INTO "CampusDisciplineCourse" VALUES ('10315', 1, '011');
INSERT INTO "CampusDisciplineCourse" VALUES ('10316', 1, '011');
INSERT INTO "CampusDisciplineCourse" VALUES ('10317', 1, '011');

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
INSERT INTO "Element" VALUES (1, 'ICAPRG401A', 'Investigate open-source paradigm');
INSERT INTO "Element" VALUES (2, 'ICAPRG401A', 'Familiarise with target project');
INSERT INTO "Element" VALUES (3, 'ICAPRG401A', 'Prepare for maintenance activities');
INSERT INTO "Element" VALUES (4, 'ICAPRG401A', 'Maintain code');
INSERT INTO "Element" VALUES (5, 'ICAPRG401A', 'Maintain documentation');
INSERT INTO "Element" VALUES (6, 'ICAPRG401A', 'Participate in community');

INSERT INTO "Element" VALUES (1, 'ICAPRG402A', 'Determine the requirements of developing queries');
INSERT INTO "Element" VALUES (2, 'ICAPRG402A', 'Write queries to retrieve and sort values');
INSERT INTO "Element" VALUES (3, 'ICAPRG402A', 'Write queries to selectively retrieve values');
INSERT INTO "Element" VALUES (4, 'ICAPRG402A', 'Perform calculation in queries');

INSERT INTO "Element" VALUES (1, 'ICAPRG403A', 'Design data-access layer (DAL)');
INSERT INTO "Element" VALUES (2, 'ICAPRG403A', 'Establish a connection with a data source');
INSERT INTO "Element" VALUES (3, 'ICAPRG403A', 'Execute commands and return results from the data source');
INSERT INTO "Element" VALUES (4, 'ICAPRG403A', 'Modify data in the data source');
INSERT INTO "Element" VALUES (5, 'ICAPRG403A', 'Manage disconnected data');
INSERT INTO "Element" VALUES (6, 'ICAPRG403A', 'Document data-access layer');

INSERT INTO "Element" VALUES (1, 'ICAPRG404A', 'Determine testing need in development');
INSERT INTO "Element" VALUES (2, 'ICAPRG404A', 'Prepare test plan document');
INSERT INTO "Element" VALUES (3, 'ICAPRG404A', 'Write and execute test procedures');
INSERT INTO "Element" VALUES (4, 'ICAPRG404A', 'Review test results');

INSERT INTO "Element" VALUES (1, 'ICAPRG405A', 'Develop algorithms to represent solution to a given problem');
INSERT INTO "Element" VALUES (2, 'ICAPRG405A', 'Describe structures of algorithms');
INSERT INTO "Element" VALUES (3, 'ICAPRG405A', 'Design and write script or code');
INSERT INTO "Element" VALUES (4, 'ICAPRG405A', 'Verify and review script or code');
INSERT INTO "Element" VALUES (5, 'ICAPRG405A', 'Document script or code');

INSERT INTO "Element" VALUES (1, 'ICAWEB401A', 'Define technical environment');
INSERT INTO "Element" VALUES (2, 'ICAWEB401A', 'Define human computer interface');
INSERT INTO "Element" VALUES (3, 'ICAWEB401A', 'Determine site hierarchy');
INSERT INTO "Element" VALUES (4, 'ICAWEB401A', 'Integrate design components');

INSERT INTO "Element" VALUES (1, 'ICAWEB402A', 'Identify accessibility standards');
INSERT INTO "Element" VALUES (2, 'ICAWEB402A', 'Test for website accessibility');
INSERT INTO "Element" VALUES (3, 'ICAWEB402A', 'Test pages');

INSERT INTO "Element" VALUES (1, 'ICANWK401A', 'Prepare to install a server');
INSERT INTO "Element" VALUES (2, 'ICANWK401A', 'Install server as required by the specification');
INSERT INTO "Element" VALUES (3, 'ICANWK401A', 'Configure and administer the server');
INSERT INTO "Element" VALUES (4, 'ICANWK401A', 'Monitor and test the server');
INSERT INTO "Element" VALUES (5, 'ICANWK401A', 'Complete documentation and clean up worksite');

INSERT INTO "Element" VALUES (1, 'ICANWK402A', 'Identify virtualisation benefits and features');
INSERT INTO "Element" VALUES (2, 'ICANWK402A', 'Install and configure virtualisation software');
INSERT INTO "Element" VALUES (3, 'ICANWK402A', 'Install and configure virtual machines');
INSERT INTO "Element" VALUES (4, 'ICANWK402A', 'Configure virtual networks of virtual machines');
INSERT INTO "Element" VALUES (5, 'ICANWK402A', 'Back up and restore virtual machines');

--
-- Data for Name: Criterion; Type: TABLE DATA; Schema: public; Owner: -
--
-- criterionID, elementID, description, moduleID
INSERT INTO "Criterion" VALUES (1, 1, 'Examine the open-source paradigm and demonstrate an understanding of the differences from the traditional software development models', 'ICAPRG401A');
INSERT INTO "Criterion" VALUES (2, 1, 'Investigate and demonstrate understanding of the types of online resources', 'ICAPRG401A');
INSERT INTO "Criterion" VALUES (3, 1, 'Investigate and demonstrate understanding of the types of project documentation', 'ICAPRG401A');
INSERT INTO "Criterion" VALUES (4, 1, 'Recognise and demonstrate understanding of the role of an online community and international collaboration', 'ICAPRG401A');
INSERT INTO "Criterion" VALUES (5, 1, 'Examine and demonstrate understanding of motivational factors for contributors to open-source code', 'ICAPRG401A');
INSERT INTO "Criterion" VALUES (6, 1, 'Analyse and demonstrate understanding of open-source licensing models', 'ICAPRG401A');
INSERT INTO "Criterion" VALUES (1, 2, 'Examine online resources associated with the target project', 'ICAPRG401A');
INSERT INTO "Criterion" VALUES (2, 2, 'Download pre-built executable binaries to install and run project', 'ICAPRG401A');
INSERT INTO "Criterion" VALUES (3, 2, 'Download, read and demonstrate understanding of supporting documentation', 'ICAPRG401A');
INSERT INTO "Criterion" VALUES (1, 3, 'Select and register with a relevant online community open-source group', 'ICAPRG401A');
INSERT INTO "Criterion" VALUES (2, 3, 'Download nightly snapshots of latest source code and supporting documentation', 'ICAPRG401A');
INSERT INTO "Criterion" VALUES (3, 3, 'Build and execute snapshot where appropriate', 'ICAPRG401A');
INSERT INTO "Criterion" VALUES (1, 4, 'Access the project bug database and select bugs to be resolved or features to be added', 'ICAPRG401A');
INSERT INTO "Criterion" VALUES (2, 4, 'Make changes to local copy of code to resolve selected bugs', 'ICAPRG401A');
INSERT INTO "Criterion" VALUES (3, 4, 'Test resulting code to ensure it performs appropriately', 'ICAPRG401A');
INSERT INTO "Criterion" VALUES (4, 4, 'Prepare code patch for submission', 'ICAPRG401A');
INSERT INTO "Criterion" VALUES (5, 4, 'Submit code patch to project', 'ICAPRG401A');
INSERT INTO "Criterion" VALUES (6, 4, 'Use appropriate software-development tools and environment', 'ICAPRG401A');
INSERT INTO "Criterion" VALUES (1, 5, 'Access project documentation', 'ICAPRG401A');
INSERT INTO "Criterion" VALUES (2, 5, 'Prepare and contribute new information or updates to existing documentation', 'ICAPRG401A');
INSERT INTO "Criterion" VALUES (3, 5, 'Prepare and submit documentation changes to project', 'ICAPRG401A');
INSERT INTO "Criterion" VALUES (1, 6, 'Exchange messages with other project members and actively participate in community activities', 'ICAPRG401A');
INSERT INTO "Criterion" VALUES (2, 6, 'Take action to ensure exchanges are socially acceptable', 'ICAPRG401A');
INSERT INTO "Criterion" VALUES (3, 6, 'Submit code and documentation code patches for inclusion', 'ICAPRG401A');
INSERT INTO "Criterion" VALUES (4, 6, 'Access online project resources frequently to keep up-to-date with project and community developments', 'ICAPRG401A');
INSERT INTO "Criterion" VALUES (5, 6, 'Take action to ensure community-participation standards are observed and maintained', 'ICAPRG401A');

INSERT INTO "Criterion" VALUES (1, 1, 'Recognise various query-related terminologies', 'ICAPRG402A');
INSERT INTO "Criterion" VALUES (2, 1, 'Identify the type of data source for a chosen query language', 'ICAPRG402A');
INSERT INTO "Criterion" VALUES (3, 1, 'Identify and use necessary tools and environment in building queries', 'ICAPRG402A');
INSERT INTO "Criterion" VALUES (1, 2, 'Use an expression to retrieve values from a single unit', 'ICAPRG402A');
INSERT INTO "Criterion" VALUES (2, 2, 'Use an expression to combine values from more than one unit', 'ICAPRG402A');
INSERT INTO "Criterion" VALUES (3, 2, 'Use an expression to sort values into certain order', 'ICAPRG402A');
INSERT INTO "Criterion" VALUES (1, 3, 'Use an expression to filter a sequence based on a predicate or condition', 'ICAPRG402A');
INSERT INTO "Criterion" VALUES (2, 3, 'Use an expression to filter a subset of sequence based on a predicate or condition', 'ICAPRG402A');
INSERT INTO "Criterion" VALUES (3, 3, 'Use an expression to extract a specific value by position', 'ICAPRG402A');
INSERT INTO "Criterion" VALUES (1, 4, 'Use expression to perform calculation on numeric values', 'ICAPRG402A');
INSERT INTO "Criterion" VALUES (2, 4, 'Use expression to perform operation on text values', 'ICAPRG402A');
INSERT INTO "Criterion" VALUES (3, 4, 'Use expression to perform operation on date and time values', 'ICAPRG402A');

INSERT INTO "Criterion" VALUES (1, 1, 'Design DAL in a multi-layer application model', 'ICAPRG403A');
INSERT INTO "Criterion" VALUES (2, 1, 'Determine data-access application programming interface (API) for connecting to various data sources', 'ICAPRG403A');
INSERT INTO "Criterion" VALUES (1, 2, 'Create and manage connection strings', 'ICAPRG403A');
INSERT INTO "Criterion" VALUES (2, 2, 'Connect to a data source by using different data providers', 'ICAPRG403A');
INSERT INTO "Criterion" VALUES (3, 2, 'Create code to handle connection exceptions', 'ICAPRG403A');
INSERT INTO "Criterion" VALUES (1, 3, 'Query data from the data source', 'ICAPRG403A');
INSERT INTO "Criterion" VALUES (2, 3, 'Retrieve data from the data source as result sets', 'ICAPRG403A');
INSERT INTO "Criterion" VALUES (3, 3, 'Manage result sets', 'ICAPRG403A');
INSERT INTO "Criterion" VALUES (4, 3, 'Manage exceptions when retrieving data', 'ICAPRG403A');
INSERT INTO "Criterion" VALUES (1, 4, 'Insert, update or delete data', 'ICAPRG403A');
INSERT INTO "Criterion" VALUES (2, 4, 'Manage data integrity', 'ICAPRG403A');
INSERT INTO "Criterion" VALUES (3, 4, 'Manage exceptions when modifying data', 'ICAPRG403A');
INSERT INTO "Criterion" VALUES (1, 5, 'Research a disconnected data management strategy', 'ICAPRG403A');
INSERT INTO "Criterion" VALUES (2, 5, 'Ensure that application can deal with disconnected data', 'ICAPRG403A');
INSERT INTO "Criterion" VALUES (1, 6, 'Document the code', 'ICAPRG403A');
INSERT INTO "Criterion" VALUES (2, 6, 'Document database connectivity', 'ICAPRG403A');

INSERT INTO "Criterion" VALUES (1, 1, 'Identify testing role across software development life cycle', 'ICAPRG404A');
INSERT INTO "Criterion" VALUES (2, 1, 'Identify testing types and testing tools', 'ICAPRG404A');
INSERT INTO "Criterion" VALUES (3, 1, 'Recognise testing benefits, standard and terms', 'ICAPRG404A');
INSERT INTO "Criterion" VALUES (1, 2, 'Gather requirements to develop test plan', 'ICAPRG404A');
INSERT INTO "Criterion" VALUES (2, 2, 'Analyse and identify test data using various test-case design techniques', 'ICAPRG404A');
INSERT INTO "Criterion" VALUES (3, 2, 'Define and design test cases', 'ICAPRG404A');
INSERT INTO "Criterion" VALUES (1, 3, 'Choose and adopt a unit test framework', 'ICAPRG404A');
INSERT INTO "Criterion" VALUES (2, 3, 'Design and implement algorithm in test procedures', 'ICAPRG404A');
INSERT INTO "Criterion" VALUES (3, 3, 'Perform test executions', 'ICAPRG404A');
INSERT INTO "Criterion" VALUES (1, 4, 'Record test results', 'ICAPRG404A');
INSERT INTO "Criterion" VALUES (2, 4, 'Analyse test results', 'ICAPRG404A');
INSERT INTO "Criterion" VALUES (3, 4, 'Produce test progress reports', 'ICAPRG404A');
INSERT INTO "Criterion" VALUES (4, 4, 'Manage defects', 'ICAPRG404A');

INSERT INTO "Criterion" VALUES (1, 1, 'Develop an algorithm which is an exact and sufficient description of the solution', 'ICAPRG405A');
INSERT INTO "Criterion" VALUES (2, 1, 'Develop an algorithm which takes account of all expected possible situations', 'ICAPRG405A');
INSERT INTO "Criterion" VALUES (3, 1, 'Develop an algorithm which is guaranteed to end', 'ICAPRG405A');
INSERT INTO "Criterion" VALUES (1, 2, 'Demonstrate use of structure, sequence, selection and iteration', 'ICAPRG405A');
INSERT INTO "Criterion" VALUES (2, 2, 'Use structures to describe algorithmic solutions to a problem', 'ICAPRG405A');
INSERT INTO "Criterion" VALUES (1, 3, 'Create an abstract design to fulfil the requirements of the proposed process', 'ICAPRG405A');
INSERT INTO "Criterion" VALUES (2, 3, 'Review the abstract design for omissions or errors', 'ICAPRG405A');
INSERT INTO "Criterion" VALUES (3, 3, 'Translate the abstract design to the chosen language', 'ICAPRG405A');
INSERT INTO "Criterion" VALUES (4, 3, 'Create internal documentation', 'ICAPRG405A');
INSERT INTO "Criterion" VALUES (1, 4, 'Check the script or code for syntax and semantic errors', 'ICAPRG405A');
INSERT INTO "Criterion" VALUES (2, 4, 'Identify areas that are not covered or are covered incorrectly in the script or code', 'ICAPRG405A');
INSERT INTO "Criterion" VALUES (1, 5, 'Create technical-level documentation', 'ICAPRG405A');
INSERT INTO "Criterion" VALUES (2, 5, 'Create user-level documentation', 'ICAPRG405A');

INSERT INTO "Criterion" VALUES (1, 1, 'Identify business requirements', 'ICAWEB401A');
INSERT INTO "Criterion" VALUES (2, 1, 'Identify appropriate standards required to develop the site', 'ICAWEB401A');
INSERT INTO "Criterion" VALUES (3, 1, 'Identify appropriate hardware and software required', 'ICAWEB401A');
INSERT INTO "Criterion" VALUES (1, 2, 'Conduct user analysis to determine a user profile and user needs', 'ICAWEB401A');
INSERT INTO "Criterion" VALUES (2, 2, 'Determine user content and requirements', 'ICAWEB401A');
INSERT INTO "Criterion" VALUES (3, 2, 'Determine appropriate design principles for the site', 'ICAWEB401A');
INSERT INTO "Criterion" VALUES (4, 2, 'Identify appropriate operating system', 'ICAWEB401A');
INSERT INTO "Criterion" VALUES (1, 3, 'Identify hierarchy of pages', 'ICAWEB401A');
INSERT INTO "Criterion" VALUES (2, 3, 'Ensure content is logical and accessible to user', 'ICAWEB401A');
INSERT INTO "Criterion" VALUES (3, 3, 'Ensure that navigation between pages is consistent and clear', 'ICAWEB401A');
INSERT INTO "Criterion" VALUES (1, 4, 'Apply appropriate information hierarchy to site design', 'ICAWEB401A');
INSERT INTO "Criterion" VALUES (2, 4, 'Ensure design principles are appropriate to business and user', 'ICAWEB401A');
INSERT INTO "Criterion" VALUES (3, 4, 'Ensure process flow is developed in a logical and simple manner', 'ICAWEB401A');
INSERT INTO "Criterion" VALUES (4, 4, 'Test site against user needs', 'ICAWEB401A');
INSERT INTO "Criterion" VALUES (5, 4, 'Complete and document the design structure', 'ICAWEB401A');

INSERT INTO "Criterion" VALUES (1, 1, 'Research and identify specific user groups with particular accessibility requirements', 'ICAWEB402A');
INSERT INTO "Criterion" VALUES (2, 1, 'Identify general legislated and industry accessibility standards and requirements to understand the wider context of accessibility', 'ICAWEB402A');
INSERT INTO "Criterion" VALUES (3, 1, 'Identify web development standards and prioritise application', 'ICAWEB402A');
INSERT INTO "Criterion" VALUES (4, 1, 'Consolidate specific and general standards and requirements into an accessibility checklist for application to website-related work', 'ICAWEB402A');
INSERT INTO "Criterion" VALUES (1, 2, 'Select and prepare appropriate automatic testing tools and software', 'ICAWEB402A');
INSERT INTO "Criterion" VALUES (2, 2, 'Run automatic testing tools and make document changes based on results', 'ICAWEB402A');
INSERT INTO "Criterion" VALUES (3, 2, 'Ensure that the text equivalent for every non-text element is present in the website where feasible', 'ICAWEB402A');
INSERT INTO "Criterion" VALUES (4, 2, 'Verify that information conveyed with colour is also available without colour', 'ICAWEB402A');
INSERT INTO "Criterion" VALUES (5, 2, 'Identify changes in the natural language of a document text', 'ICAWEB402A');
INSERT INTO "Criterion" VALUES (6, 2, 'Check and ensure that document can be read without style sheets', 'ICAWEB402A');
INSERT INTO "Criterion" VALUES (7, 2, 'Check and ensure that priorities identified in the analysis of web development standards are met and completed', 'ICAWEB402A');
INSERT INTO "Criterion" VALUES (8, 2, 'Test site with different user groups to ensure that the site transforms successfully and maintains accessibility', 'ICAWEB402A');
INSERT INTO "Criterion" VALUES (1, 3, 'Check and ensure that pages are not dependent on colour and can operate in a monochrome environment', 'ICAWEB402A');
INSERT INTO "Criterion" VALUES (2, 3, 'Check and ensure that pages are logical and accessible in a text-only environment', 'ICAWEB402A');
INSERT INTO "Criterion" VALUES (3, 3, 'Verify that pages operate on text-to-speech browser', 'ICAWEB402A');
INSERT INTO "Criterion" VALUES (4, 3, 'Ensure that accessibility of website is signed off by appropriate person as meeting web-development standards', 'ICAWEB402A');

INSERT INTO "Criterion" VALUES (1, 1, 'Prepare for work, according to site-specific safety requirements and enterprise OHS processes and procedures', 'ICANWK401A');
INSERT INTO "Criterion" VALUES (2, 1, 'Obtain server applications and features from appropriate person', 'ICANWK401A');
INSERT INTO "Criterion" VALUES (3, 1, 'Choose the most suitable operating system features and network services with reference to required server solution and technical requirements', 'ICANWK401A');
INSERT INTO "Criterion" VALUES (4, 1, 'Review required installation options', 'ICANWK401A');
INSERT INTO "Criterion" VALUES (5, 1, 'Analyse data migration requirements', 'ICANWK401A');
INSERT INTO "Criterion" VALUES (6, 1, 'Back up local data in preparation for installation', 'ICANWK401A');
INSERT INTO "Criterion" VALUES (7, 1, 'Arrange access to site and advise client of deployment and potential down time', 'ICANWK401A');
INSERT INTO "Criterion" VALUES (1, 2, 'Create disk-partitioning scheme', 'ICANWK401A');
INSERT INTO "Criterion" VALUES (2, 2, 'Create file systems and virtual memory', 'ICANWK401A');
INSERT INTO "Criterion" VALUES (3, 2, 'Install network operating system', 'ICANWK401A');
INSERT INTO "Criterion" VALUES (4, 2, 'Install and configure server applications and network services', 'ICANWK401A');
INSERT INTO "Criterion" VALUES (5, 2, 'Reconnect and reconfigure connectivity devices', 'ICANWK401A');
INSERT INTO "Criterion" VALUES (6, 2, 'Patch the operating system and applications to ensure maximum security and reliability', 'ICANWK401A');
INSERT INTO "Criterion" VALUES (7, 2, 'Restore local data to new server', 'ICANWK401A');
INSERT INTO "Criterion" VALUES (1, 3, 'Configure network directory service', 'ICANWK401A');
INSERT INTO "Criterion" VALUES (2, 3, 'Create and manage accounts to facilitate security and network access', 'ICANWK401A');
INSERT INTO "Criterion" VALUES (3, 3, 'Configure user environment using operating system policies and scripts', 'ICANWK401A');
INSERT INTO "Criterion" VALUES (4, 3, 'Create directory structure and quotas to meet client requirements', 'ICANWK401A');
INSERT INTO "Criterion" VALUES (5, 3, 'Configure and manage print services', 'ICANWK401A');
INSERT INTO "Criterion" VALUES (6, 3, 'Set the security, access and sharing of system resources to meet client requirements', 'ICANWK401A');
INSERT INTO "Criterion" VALUES (7, 3, 'Implement security policy to prevent unauthorised access to the system', 'ICANWK401A');
INSERT INTO "Criterion" VALUES (8, 3, 'Implement backup and recovery methods to enable restoration capability in the event of a disaster', 'ICANWK401A');
INSERT INTO "Criterion" VALUES (9, 3, 'Configure update services to provide automatic updates for operating system and applications', 'ICANWK401A');
INSERT INTO "Criterion" VALUES (1, 4, 'Test server for benchmarking against client specification and requirements according to test plan, and record outcomes', 'ICANWK401A');
INSERT INTO "Criterion" VALUES (2, 4, 'Analyse the error report and make changes as required', 'ICANWK401A');
INSERT INTO "Criterion" VALUES (3, 4, 'Use troubleshooting tools and techniques to diagnose and correct server problems', 'ICANWK401A');
INSERT INTO "Criterion" VALUES (4, 4, 'Test required changes or additions', 'ICANWK401A');
INSERT INTO "Criterion" VALUES (5, 4, 'Validate changes or additions against specifications', 'ICANWK401A');
INSERT INTO "Criterion" VALUES (1, 5, 'Make and document server configuration and operational changes', 'ICANWK401A');
INSERT INTO "Criterion" VALUES (2, 5, 'Complete client report and notification of server status', 'ICANWK401A');
INSERT INTO "Criterion" VALUES (3, 5, 'Clean up and restore worksite to client’s satisfaction', 'ICANWK401A');
INSERT INTO "Criterion" VALUES (4, 5, 'Secure sign-off from appropriate person', 'ICANWK401A');

INSERT INTO "Criterion" VALUES (1, 1, 'Research and determine government and industry guidelines and policies for use of desktop and server virtualisation', 'ICANWK402A');
INSERT INTO "Criterion" VALUES (2, 1, 'Identify benefits of virtualisation of desktop and server environments', 'ICANWK402A');
INSERT INTO "Criterion" VALUES (3, 1, 'Identify available features of current virtualisation software', 'ICANWK402A');
INSERT INTO "Criterion" VALUES (4, 1, 'Select virtualisation solution based on current and future needs of the client', 'ICANWK402A');
INSERT INTO "Criterion" VALUES (1, 2, 'Identify, clarify and organise requirements of the client relating to virtualisation technologies, following organisational requirements', 'ICANWK402A');
INSERT INTO "Criterion" VALUES (2, 2, 'Identify the hardware and software, infrastructure components, required to be installed and configured to meet technical requirements', 'ICANWK402A');
INSERT INTO "Criterion" VALUES (3, 2, 'Install and configure software to provide support for virtualisation of desktop and server operating systems', 'ICANWK402A');
INSERT INTO "Criterion" VALUES (4, 2, 'Configure virtualisation software application features to accommodate required functionality, relating to client and business needs', 'ICANWK402A');
INSERT INTO "Criterion" VALUES (1, 3, 'Install virtual machine consistent with client, commercial and business requirements', 'ICANWK402A');
INSERT INTO "Criterion" VALUES (2, 3, 'Configure virtual machine consistent with client, commercial and business requirements', 'ICANWK402A');
INSERT INTO "Criterion" VALUES (3, 3, 'Test functionality of installed virtual machine', 'ICANWK402A');
INSERT INTO "Criterion" VALUES (1, 4, 'Configure IP addressing to match chosen network configuration', 'ICANWK402A');
INSERT INTO "Criterion" VALUES (2, 4, 'Configure virtual network as host only configuration', 'ICANWK402A');
INSERT INTO "Criterion" VALUES (3, 4, 'Configure virtual network as bridged configuration', 'ICANWK402A');
INSERT INTO "Criterion" VALUES (4, 4, 'Configure virtual network as network address translation (NAT) configuration', 'ICANWK402A');
INSERT INTO "Criterion" VALUES (5, 4, 'Configure services to operate under current network configuration', 'ICANWK402A');
INSERT INTO "Criterion" VALUES (6, 4, 'Test functionality of virtual network configuration', 'ICANWK402A');
INSERT INTO "Criterion" VALUES (1, 5, 'Back up virtual machine state on shutdown', 'ICANWK402A');
INSERT INTO "Criterion" VALUES (2, 5, 'Restore state on start-up of virtual machine', 'ICANWK402A');
INSERT INTO "Criterion" VALUES (3, 5, 'Back up virtual hard drive and software configuration files', 'ICANWK402A');
INSERT INTO "Criterion" VALUES (4, 5, 'Restore virtual hard drive and software configuration files', 'ICANWK402A');

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
-- courseID, ModuleID, elective
INSERT INTO "CourseModule" ("courseID","moduleID","elective") VALUES
	('10309','ICAICT401A',false),
	('10315','ICAICT401A',false),
	('10316','ICAICT401A',false),
	('10326','ICAICT401A',false),
	('10309','ICAICT403A',true),
	('10315','ICAICT403A',true),
	('10316','ICAICT403A',true),
	('10336','ICAICT403A',true),
	('10309','ICAICT404A',true),
	('10317','ICAICT404A',true),
	('10322','ICAICT404A',false),
	('10309','ICAICT407A',true),
	('10315','ICAICT407A',true),
	('10315','ICAICT408A',true),
	('10316','ICAICT408A',true),
	('10317','ICAICT408A',true),
	('10322','ICAICT408A',true),
	('10326','ICAICT408A',true),
	('10309','ICAICT417A',true),
	('10315','ICAICT417A',true),
	('10316','ICAICT417A',true),
	('10317','ICAICT417A',true),
	('10322','ICAICT417A',true),
	('10326','ICAICT417A',true),
	('10309','ICAICT418A',false),
	('10315','ICAICT418A',false),
	('10316','ICAICT418A',false),
	('10317','ICAICT418A',false),
	('10322','ICAICT418A',false),
	('10326','ICAICT418A',false),
	('10333','ICAICT418A',false),
	('10334','ICAICT418A',false),
	('10335','ICAICT418A',false),
	('10336','ICAICT418A',false),
	('10309','ICAICT420A',true),
	('10315','ICAICT420A',true),
	('10317','ICAICT420A',true);


/* Sample Data for Presentation : RELIES UPON SOME OF THE INFORMATION ABOVE */
-- Create new users: 123456789, demo_steve, demo_deb, demo_admin, all passwords are 'password'
-- Course to create a claim for: 19010: Certificate IV in Information Technology (Programming)
SELECT fn_insertstudent('student','demo.student@tafensw.net.au','Student','Jones','Jake','123 Fake Street','','Faketown','NSW',2315,'02 4343 4343','123456789',false,'password');
SELECT fn_insertUser('assesor','password','T','stephen.etherington@tafe.nsw.edu.au','Assesor','Etherington');
SELECT fn_insertUser('delegate','password','A','deborah.spindler@tafe.nsw.edu.au','Delegate','Spindler');
SELECT fn_insertUser('admin','password','C','admin@tafe.nsw.edu.au','Admin','Istrator');
SELECT fn_updateuser('teacher','teacher','password');
SELECT fn_updateuser('delegate','delegate','password');
INSERT INTO "Teacher" VALUES ('delegate','delegate');
INSERT INTO "Teacher" VALUES ('assesor','assesor');
INSERT INTO "Assessor" VALUES ('011', '10317', 1, false, 'assesor');

