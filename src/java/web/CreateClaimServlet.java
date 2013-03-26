package web;

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
import util.Email;
import util.RPLError;
import util.RPLPage;
import util.RPLServlet;
import util.Util;

/**
 * This servlet is for the creation of Claims by students. It is used to create
 * both RPL and Previous Studies Claims.
 * @author James Purves
 */
public class CreateClaimServlet extends HttpServlet {

    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Initialises the lists as null as well as the claim.
        ArrayList<Campus> campuses = null;
        ArrayList<Course> courses = null;
        ArrayList<Discipline> disciplines = null;
        Claim claim = null;
        
        // Initialises the url for the next page to an empty string, and gets 
        // the session and the current user.
        String url = "";
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Gets the current claim from the session. There should only be a claim
        // if the servlet is being called by the createClaim jsp page. If the 
        // claim is null or there is a claim and the request has come from the 
        // student home page then set the claim to a new, empty claim.
        claim = (Claim) session.getAttribute("claim");
        if (claim == null || request.getParameter("createClaim") != null){
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
        campuses = this.getCampusList(user);
        claim.setCampus(this.getSelectedCampus(request, campuses));
        claim.setCampusID(claim.getCampus().getCampusID());
        disciplines = this.getDisciplineList(user, claim);
        claim.setDiscipline(this.getSelectedDiscipline(request, disciplines));
        claim.setDisciplineID(claim.getDiscipline().getDisciplineID());
        courses = this.getCourseList(user, claim);
        claim.setCourse(this.getSelectedCourse(request, courses));
        claim.setCourseID(claim.getCourse().getCourseID());
        
        // If a campus discipline and course were selected it will create a 
        // claim. Depending on the button pressed the claim will either be RPL 
        // or Previous Studies.
        ClaimIO claimIO = new ClaimIO(user.getRole()); 
        ClaimRecordIO claimRecordIO = new ClaimRecordIO(user.getRole());    // Kyoungho Lee
        if (!claim.getCampusID().equals("") 
                && claim.getDisciplineID() != Util.INT_ID_EMPTY 
                && !claim.getCourseID().equals("")){
            if (request.getParameter("claimType").equals("prevStudies")) {
                claim.setClaimType(Claim.ClaimType.PREVIOUS_STUDIES);
                try {
                    claim.setAssessorID("123456789");
                    claimIO.insert(claim);
                    //Email.send(user.getEmail(), "Regarding your claim", "<b>Your claim is successfully created!</b>");
                    claimRecordIO.insert(new ClaimRecord(claim.getClaimID(), claim.getStudentID(), 0, user.getUserID(), "", 0, 0, claim.getCampusID(), claim.getCourseID(), claim.getClaimType().desc)); // Kyoungho Lee
                    claim.setClaimID(claimIO.getList(user).size());
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
                    claimRecordIO.insert(new ClaimRecord(claim.getClaimID(), claim.getStudentID(), 0, user.getUserID(), "", 0, 0, claim.getCampusID(), claim.getCourseID(), claim.getClaimType().desc)); // Kyoungho Lee
                    claim.setClaimID(claimIO.getList(user).size());
                    //Email.send(user.getEmail(), "Cliam#:" + claim.getClaimID(), "Your claim is successfully created!!");
                } catch (SQLException sqlEx) {
                    Logger.getLogger(CreateClaimServlet.class.getName()).log(Level.SEVERE, null, sqlEx);
                }
                url = RPLServlet.UPDATE_RPL_CLAIM_SERVLET.relativeAddress;
            } else if (request.getParameter("back") != null) {
                url = RPLPage.STUDENT_HOME.relativeAddress;
            } else {
                /*request.setAttribute("claimError", 
                        new RPLError("Please select a Claim Type!!!"));*/
                url = RPLPage.CREATE_CLAIM.relativeAddress;
            }
        }
        else if (request.getParameter("back") != null) {
            url = RPLPage.STUDENT_HOME.relativeAddress;
        } else {
            url = RPLPage.CREATE_CLAIM.relativeAddress;
        }
        
        // Sets the session and request attributes and forwards the request to
        // the next url.
        session.setAttribute("claim", claim);
        request.setAttribute("campuses", campuses);
        request.setAttribute("disciplines", disciplines);
        request.setAttribute("courses", courses);
        RequestDispatcher dispatcher = request.getRequestDispatcher(url);
        dispatcher.forward(request, response);
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
    
    /**
     * Returns the campus selected in the campus combobox on the createClaim 
     * page, if there was one selected.
     * @param request the request
     * @param campuses the list of campuses to get the campus from
     * @return the selected campus
     */
    private Campus getSelectedCampus(HttpServletRequest request, 
            ArrayList<Campus> campuses){
        String campusID = request.getParameter("campus");
        if (campusID != null){
            String id = campusID;
            for (Campus campus : campuses){
                if (campus.getCampusID().equals(id)){
                    return campus;
                }
            }
        }
        return new Campus();
    }
    
    /**
     * Returns the discipline selected in the discipline combobox on the 
     * createClaim page, if there was one selected.
     * @param request the request
     * @param disciplines the list of disciplines to get the discipline from
     * @return the selected discipline
     */
    private Discipline getSelectedDiscipline(HttpServletRequest request, 
            ArrayList<Discipline> disciplines){
        String disciplineID = request.getParameter("discipline");
        if (disciplineID != null){
            int id = Integer.valueOf(disciplineID);
            for (Discipline discipline : disciplines){
                if (discipline.getDisciplineID() == id){
                    return discipline;
                }
            }
        }
        return new Discipline();
    }
    
    /**
     * Returns the course selected in the course combobox on the createClaim 
     * page, if there was one selected.
     * @param request the request
     * @param courses the list of courses to get the course from
     * @return the selected course
     */
    private Course getSelectedCourse(HttpServletRequest request, 
            ArrayList<Course> courses) {
        String courseID = request.getParameter("course");
        if (courseID != null){
            String id = courseID;
            for (Course course : courses){
                if (course.getCourseID().equals(id)){
                    return course;
                }
            }
        }
        return new Course();
    }
    
    /**
     * Retrieves a list of campuses from the database.
     * @param user the current user
     * @return the list of campuses
     */
    private ArrayList<Campus> getCampusList(User user){
        CampusIO campusIO = new CampusIO(user.role);
        ArrayList<Campus> campuses = new ArrayList<Campus>();
        campuses = campusIO.getList();
        campuses.add(0, new Campus());
        return campuses;
    }
    
    /**
     * Returns a list of disciplines for a given campus.
     * @param user the current user
     * @param claim the current claim
     * @return the list of disciplines
     */
    private ArrayList<Discipline> getDisciplineList(User user, Claim claim){
        DisciplineIO disciplineIO = new DisciplineIO(user.role);
        ArrayList<Discipline> disciplines = new ArrayList<Discipline>();
        String campusID = claim.getCampusID();
        
        if (campusID == null || campusID.equals("")){
            disciplines = new ArrayList<Discipline>();
        } else {
            disciplines = disciplineIO.getList(campusID);
        }
        disciplines.add(0, new Discipline());
        return disciplines;
    }
    
    /**
     * Returns a list of courses for a given campus and discipline.
     * @param user the current user
     * @param claim the current claim
     * @return the list of courses
     */
    private ArrayList<Course> getCourseList(User user, Claim claim){
        CourseIO courseIO = new CourseIO(user.role);
        ArrayList<Course> courses = new ArrayList<Course>();
        String campusID = claim.getCampusID();
        int disciplineID = claim.getDisciplineID();
        
        if ((campusID == null || campusID.equals("")) && disciplineID == 0){
            courses = new ArrayList<Course>();
        } else {
            courses = courseIO.getList(campusID, disciplineID);
        }
        courses.add(0, new Course());
        return courses;
    }
}
