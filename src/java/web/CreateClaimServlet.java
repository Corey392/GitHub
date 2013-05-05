package web;

/**<b>Purpose:</b> Processes the 'Create Claim' form for Students.
 * @author ?, Todd Wiggins, Mitchell Carr
 * @version: 1.12
 * Created:	?
 * Modified: 25/04/2013: TW: Added validation for all 4 fields and now returns an error message for each.
 *			 30/04/2013: TW: Moved to an AJAX method of updating select boxes. Added the 'post' boolean to process request.
 *			 04/05/2013: MC: Fixed setClaimID calls
 *			 05/05/2013: TW: Fixed reset of Campus on failed submit attempt.
 */
import data.*;
import domain.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.RequestDispatcher;
import util.FieldError;
import util.RPLError;
import util.RPLPage;
import util.RPLServlet;
import util.Util;

/**
 * This servlet is for the creation of Claims by students. It is used to create
 * both RPL and Previous Studies Claims.
 * <p/>
 * @author James Purves
 */
public class CreateClaimServlet extends HttpServlet {
	/**
	 * Processes requests for both HTTP
	 * <code>GET</code> and
	 * <code>POST</code> methods.
	 * <p/>
	 * @param request  servlet request
	 * @param response servlet response
	 * @throws ServletException if a servlet-specific error occurs
	 * @throws IOException      if an I/O error occurs
	 */
	protected void processRequest(HttpServletRequest request, HttpServletResponse response, boolean post) throws ServletException, IOException {

		String url;
		//Mitchell: There is currently no path on which this variable is not
		//initialized, so it doesn't need a default variable. This will change only
		//if the current if/else structure below is altered

		// Gets the session and the current user.
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute("user");

		// Gets the current claim from the session. There should only be a claim
		// if the servlet is being called by the createClaim jsp page. If the
		// claim is null or there is a claim and the request has come from the
		// student home page then set the claim to a new, empty claim.
		Claim claim = (Claim) session.getAttribute("claim");
		if (claim == null || request.getParameter("createClaim") != null) {
			claim = new Claim();
			claim.setStudentID(user.getUserID());
			claim.setCampus(new Campus());
			claim.setCampusID("");
			claim.setDiscipline(new Discipline());
			claim.setDisciplineID(Util.INT_ID_EMPTY);
			claim.setCourse(new Course());
			claim.setCourseID("");
			claim.setClaimedModules(new ArrayList<ClaimedModule>());
		}

		// Gets the campus, discipline and course lists and sets the claim's
		// campus, discipline and course.
		ArrayList<Campus> campuses = this.getCampusList(user);
		claim.setCampus(this.getSelectedCampus(request, campuses));
		claim.setCampusID(claim.getCampus().getCampusID());
		ArrayList<Discipline> disciplines = getDisciplineList(user, claim);
		claim.setDiscipline(this.getSelectedDiscipline(request, disciplines));
		claim.setDisciplineID(claim.getDiscipline().getDisciplineID());
		ArrayList<Course> courses = getCourseList(user, claim);
		claim.setCourse(this.getSelectedCourse(request, courses));
		claim.setCourseID(claim.getCourse().getCourseID());

		if (post) {

			// If a campus discipline and course were selected it will create a
			// claim. Depending on the button pressed the claim will either be RPL
			// or Previous Studies.
			ClaimIO claimIO = new ClaimIO(user.getRole());

			//TW: Validate all the fields have been supplied, and return an error if not.
			boolean valid = false;
			if (claim.getCampusID().equals("")) {
				request.setAttribute("errorCampusID", new RPLError(FieldError.CAMPUS_NOT_SELECTED));
			} else if (claim.getDisciplineID() == Util.INT_ID_EMPTY) {
				request.setAttribute("errorDisciplineID", new RPLError(FieldError.DISCIPLINE_NOT_SELECTED));
			} else if (claim.getCourseID().equals("")) {
				request.setAttribute("errorCourseID", new RPLError(FieldError.COURSE_NOT_SELECTED));
			} else if (request.getParameter("claimType") == null) {
				request.setAttribute("errorClaimType", new RPLError(FieldError.CLAIM_TYPE_NOT_SELECTED));
			} else {
				valid = true;
			}
			if (!valid) {	//Forces the Campus select box to be reset.
				claim.setCampusID("");
			}

			if (valid) {
				if (request.getParameter("claimType").equals("prevStudies")) {
					claim.setClaimType(Claim.ClaimType.PREVIOUS_STUDIES);
					try {
						claim.setAssessorID("123456789");
						claimIO.insert(claim);
						//Email.send(user.getEmail(), "Regarding your claim", "<b>Your claim is successfully created!</b>");
						claim.setClaimID(claimIO.getTotalClaims());
						//Email.send(user.getEmail(), "Cliam#:" + claim.getClaimID(), "Your claim is successfully created!!");
					} catch (SQLException sqlEx) {
						Logger.getLogger(CreateClaimServlet.class.getName()).log(Level.SEVERE, null, sqlEx);
					}
					url = RPLServlet.UPDATE_PREV_CLAIM_SERVLET.relativeAddress;
				} else if (request.getParameter("claimType").equals("rpl")) {
					claim.setClaimType(Claim.ClaimType.RPL);
					try {
						claim.setAssessorID("123456789");

						claimIO.insert(claim);
						//Email.send(user.getEmail(), "Regarding your claim", "<b>Your claim is successfully created!</b>");
						claim.setClaimID(claimIO.getTotalClaims());
						//Email.send(user.getEmail(), "Cliam#:" + claim.getClaimID(), "Your claim is successfully created!!");
					} catch (SQLException sqlEx) {
						Logger.getLogger(CreateClaimServlet.class.getName()).log(Level.SEVERE, null, sqlEx);
					}
					url = RPLServlet.UPDATE_RPL_CLAIM_SERVLET.relativeAddress;
				} else if (request.getParameter("back") != null) {
					url = RPLPage.STUDENT_HOME.relativeAddress;
				} else {
					/*request.setAttribute("claimError", new RPLError("Please select a Claim Type!!!"));*/
					url = RPLPage.CREATE_CLAIM.relativeAddress;
				}
			} else if (request.getParameter("back") != null) {
				url = RPLPage.STUDENT_HOME.relativeAddress;
			} else {
				url = RPLPage.CREATE_CLAIM.relativeAddress;
			}
		} else {
			url = RPLPage.CREATE_CLAIM.relativeAddress;
		}

		// Sets the session and request attributes and forwards the request to the next url.
		session.setAttribute("claim", claim);
		request.setAttribute("campuses", campuses);
		request.setAttribute("disciplines", disciplines);
		request.setAttribute("courses", courses);
		RequestDispatcher dispatcher = request.getRequestDispatcher(url);
		dispatcher.forward(request, response);
	}

	// <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
	/**
	 * Handles the HTTP
	 * <code>GET</code> method.
	 * <p/>
	 * @param request  servlet request
	 * @param response servlet response
	 * @throws ServletException if a servlet-specific error occurs
	 * @throws IOException      if an I/O error occurs
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		//Currently 'GET' requests are sent to the servlet, processed and the user sent the JSP at the url. NOT a 403/402 redirect.
		//RequestDispatcher dispatcher = request.getRequestDispatcher(RPLPage.CREATE_CLAIM.relativeAddress);
		//dispatcher.forward(request, response);
		processRequest(request, response, false);
	}

	/**
	 * Handles the HTTP
	 * <code>POST</code> method.
	 * <p/>
	 * @param request  servlet request
	 * @param response servlet response
	 * @throws ServletException if a servlet-specific error occurs
	 * @throws IOException      if an I/O error occurs
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		processRequest(request, response, true);
	}

	/**
	 * Returns a short description of the servlet.
	 * <p/>
	 * @return a String containing servlet description
	 */
	@Override
	public String getServletInfo() {
		return "Short description";
	}// </editor-fold>

	/**
	 * Returns the campus selected in the campus combobox on the createClaim
	 * page, if there was one selected.
	 * <p/>
	 * @param request  the request
	 * @param campuses the list of campuses to get the campus from
	 * @return the selected campus
	 */
	private Campus getSelectedCampus(HttpServletRequest request, ArrayList<Campus> campuses) {
		String campusID = request.getParameter("campus");
		if (campusID != null) {
			String id = campusID;
			for (Campus campus : campuses) {
				if (campus.getCampusID().equals(id)) {
					return campus;
				}
			}
		}
		return new Campus();
	}

	/**
	 * Returns the discipline selected in the discipline combobox on the
	 * createClaim page, if there was one selected.
	 * <p/>
	 * @param request     the request
	 * @param disciplines the list of disciplines to get the discipline from
	 * @return the selected discipline
	 */
	private Discipline getSelectedDiscipline(HttpServletRequest request, ArrayList<Discipline> disciplines) {
		String disciplineID = request.getParameter("discipline");
		if (disciplineID != null) {
			int id = Integer.valueOf(disciplineID);
			for (Discipline discipline : disciplines) {
				if (discipline.getDisciplineID() == id) {
					return discipline;
				}
			}
		}
		return new Discipline();
	}

	/**
	 * Returns the course selected in the course combobox on the createClaim
	 * page, if there was one selected.
	 * <p/>
	 * @param request the request
	 * @param courses the list of courses to get the course from
	 * @return the selected course
	 */
	private Course getSelectedCourse(HttpServletRequest request, ArrayList<Course> courses) {
		String courseID = request.getParameter("course");
		if (courseID != null) {
			String id = courseID;
			for (Course course : courses) {
				if (course.getCourseID().equals(id)) {
					return course;
				}
			}
		}
		return new Course();
	}

	/**
	 * Retrieves a list of campuses from the database.
	 * <p/>
	 * @param user the current user
	 * @return the list of campuses
	 */
	private ArrayList<Campus> getCampusList(User user) {
		CampusIO campusIO = new CampusIO(user.role);
		ArrayList<Campus> campuses = campusIO.getList();
		campuses.add(0, new Campus());
		return campuses;
	}

	/**
	 * Returns a list of disciplines for a given campus.
	 * <p/>
	 * @param user  the current user
	 * @param claim the current claim
	 * @return the list of disciplines
	 */
	protected static ArrayList<Discipline> getDisciplineList(User user, Claim claim) {
		DisciplineIO disciplineIO = new DisciplineIO(user.role);
		ArrayList<Discipline> disciplines;
		String campusID = claim.getCampusID();

		if (campusID == null || campusID.equals("")) {
			disciplines = new ArrayList<Discipline>();
		} else {
			disciplines = disciplineIO.getList(campusID);
		}
		disciplines.add(0, new Discipline());
		return disciplines;
	}

	/**
	 * Returns a list of courses for a given campus and discipline.
	 * <p/>
	 * @param user  the current user
	 * @param claim the current claim
	 * @return the list of courses
	 */
	protected static ArrayList<Course> getCourseList(User user, Claim claim) {
		CourseIO courseIO = new CourseIO(user.role);
		ArrayList<Course> courses;
		String campusID = claim.getCampusID();
		int disciplineID = claim.getDisciplineID();

		if ((campusID == null || campusID.equals("")) && disciplineID == 0) {
			courses = new ArrayList<Course>();
		} else {
			courses = courseIO.getList(campusID, disciplineID);
		}
		courses.add(0, new Course());
		return courses;
	}
}
