package util;

import data.CampusIO;
import data.ClaimIO;
import data.ClaimedModuleIO;
import data.CourseIO;
import data.CriterionIO;
import data.DisciplineIO;
import data.ElementIO;
import data.EvidenceIO;
import data.ModuleIO;
import data.ProviderIO;
import data.UserIO;
import domain.*;
import domain.User.Role;
import java.util.ArrayList;
import java.util.Enumeration;
import javax.servlet.http.HttpServletRequest;

/**
 * @author Adam Shortall, Bryce Carr, Mitch Carr, Todd Wiggins
 * @version 1.02
 * <b>Created:</b>  Unknown<br/>
 * <b>Modified:</b> 24/04/2013<br/>
 * <b>Change Log:</b>  08/04/2013:  Bryce Carr: Removed code to account for removal of moduleID field in DB's Criterion table.<br/>
 *                  24/04/2013: Bryce Carr: Added header comments to match code conventions.<br/>
 * 		    30/04/2013: Mitch Carr: Removed all instances of ClaimRecord and classes/methods pertaining to it.<br/>
 * 		    01/05/2013: Mitch Carr: Updated to reflect change made to ClaimIO.getById(Claim)<br/>
 *                  07/05/2013: Mitch Carr: Updated getCompleteEvidence and removed getCompleteEvidenceList<br />
 *                  07/05/2013: TW: Changed evidence to ArrayList<Evidence> in getCompleteEvidence().<br />
 * <b>Purpose:</b>  Appears to provide reusable access to commonly-used complex interactions with IO classes.
 */
public final class Util {

    public static final int INT_ID_EMPTY = 0;

    private Util() {}

    /**
     * Returns an integer value (probably representing an ID field) from a jsp where
     * the parameter name has a particular prefix followed by a colon.
     * @param request
     * @param prefix
     * @return
     */
    public static Integer getPageIntID(HttpServletRequest request, String prefix) {
        String stringID = getPageStringID(request, prefix);
        return stringID == null ? null : Integer.parseInt(stringID);
    }

    /**
     * Returns a String value (probably representing an ID field) from a jsp
     * where the parameter name has a particular prefix followed by a colon.
     * @param request
     * @param prefix
     * @return
     */
    public static String getPageStringID(HttpServletRequest request, String prefix) {
        Enumeration<String> requestParameters = request.getParameterNames();

        while (requestParameters.hasMoreElements()) {
            String p = requestParameters.nextElement();
            String[] updateTokens = p.split(":");
            if (updateTokens[0].equals(prefix)) {
                return updateTokens[1];
            }
        }
        return null;
    }

    /**
     *
     * @param campusID
     * @param disciplineID
     * @param courseID
     * @param role
     * @return A course with all elective and core modules set
     */
    public static Course getCourseWithModules(String campusID, int disciplineID, String courseID, Role role) {
        CourseIO courseIO = new CourseIO(role);
        Course course = courseIO.getByID(courseID);

        if (campusID == null || campusID.isEmpty() || disciplineID == Util.INT_ID_EMPTY) {
            return course;
        }

        ModuleIO moduleIO = new ModuleIO(role);
        course.setCoreModules(moduleIO.getListOfCores(courseID));
        course.setElectiveModules(moduleIO.getListOfElectives(courseID));
        return course;
    }

    /**
     * Returns an Element with all of its criteria set.
     * @param elementID
     * @param moduleID
     * @param role
     * @return
     */
    public static Element getCompleteElement(int elementID, String moduleID, Role role) {
        ElementIO elementIO = new ElementIO(role);
        CriterionIO criterionIO = new CriterionIO(role);
        Element element = elementIO.getByID(moduleID, elementID);
        ArrayList<Criterion> criteria = criterionIO.getList(elementID);
        element.setCriteria(criteria);

        return element;
    }
    /**
     *
     * @param moduleID
     * @param role
     * @return
     */
    public static Module getCompleteModule(String moduleID, Role role) {
        ElementIO elementIO = new ElementIO(role);
        CriterionIO criterionIO = new CriterionIO(role);
        ModuleIO moduleIO = new ModuleIO(role);

        Module module = moduleIO.getByID(moduleID);

        if (module == null) {
			return new Module();
		}
        module.setElements(elementIO.getList(moduleID));
        for (Element e : module.getElements()) {
            e.setCriteria(criterionIO.getList(e.getElementID()));
        }
        return module;
    }


    /**
     * Returns an Evidence record with completed element & criteria
     * @param claimID
     * @param moduleID
     * @param role
     * @return
     */
    public static ArrayList<Evidence> getCompleteEvidence(int claimID, String moduleID, Role role) {
        EvidenceIO evidenceIO = new EvidenceIO(role);
        ArrayList<Evidence> evidence = evidenceIO.getEvidence(claimID, moduleID);
        return evidence;
    }

    /**
     *
     * @param courseID
     * @param role
     * @param campus
     * @param discipline
     * @return
     */
    public static Course getCompleteCourse(String courseID, Role role, String campusID, int disciplineID) {
        Course completeCourse = Util.getCourseWithModules(campusID, disciplineID, courseID, role);
        for (Module module : completeCourse.getAllModules()) {
            Module m = Util.getCompleteModule(module.getModuleID(), role);
            module.setElements(m.getElements());
        }
        return completeCourse;
    }

    /**
     *
     * @param claimID
     * @param studentID
     * @param role
     * @return
     */
    public static ArrayList<ClaimedModule> getCompleteClaimedModuleList(int claimID, String studentID, Role role) {

        ClaimedModuleIO claimedModuleIO = new ClaimedModuleIO(role);
        ProviderIO providerIO = new ProviderIO(role);
        ArrayList<ClaimedModule> claimedModules = claimedModuleIO.getList(claimID, studentID);
        if (claimedModules != null) {
            for (ClaimedModule cm : claimedModules) {
                cm.setProviders(providerIO.getList(claimID, cm.getModuleID()));
                cm.setEvidence(Util.getCompleteEvidence(claimID, cm.getModuleID(), role));
            }
        } else {
            claimedModules = new ArrayList<ClaimedModule>();
        }
        return claimedModules;
    }

    /**
     *
     * @param studentID
     * @param claimID
     * @param role
     * @return A claim with all claimedModules which each contain evidence, elements
     * and criteria, where applicable.
     */
    public static Claim getCompleteClaim(String studentID, int claimID, Role role) {
        ClaimIO claimIO = new ClaimIO(role);
        UserIO userIO = new UserIO(role);
        CampusIO campusIO = new CampusIO(role);
        DisciplineIO disciplineIO = new DisciplineIO(role);
        CourseIO courseIO = new CourseIO(role);
        Claim claim = claimIO.getByID(claimID);
        if (claim == null){return null;}
        if (claim.getAssessorID() != null) {
            claim.setAssessor(userIO.getByID(claim.getAssessorID()));
        }
        if (claim.getDelegateID() != null) {
            claim.setDelegate(userIO.getByID(claim.getDelegateID()));
        } else {
            claim.setDelegateID("");
        }
        if (claim.getCampusID() != null) {
            claim.setCampus(campusIO.getByID(claim.getCampusID()));
        }
        if (claim.getDisciplineID() != null) {
            claim.setDiscipline(disciplineIO.getByID(claim.getDisciplineID()));
        }
        if (claim.getCourseID() != null) {
            claim.setCourse(courseIO.getByID(claim.getCourseID()));
        }
        claim.setClaimedModules(Util.getCompleteClaimedModuleList(claimID, studentID, role));

        return claim;
    }

    /**
     *
     * @param campusID
     * @param role
     * @return A campus with all disciplines and courses, courses do not have modules set
     */
    public static Campus getCampusWithDisciplinesAndCourses(String campusID, Role role) {
        CampusIO campusIO = new CampusIO(role);
        DisciplineIO disciplineIO = new DisciplineIO(role);
        CourseIO courseIO = new CourseIO(role);
        Campus campus = campusIO.getByID(campusID);
        campus.setDisciplines(disciplineIO.getList(campusID));
        for (Discipline d : campus.getDisciplines()) {
            d.setCourses(courseIO.getList(campusID, d.getDisciplineID()));
        }
        return campus;
    }

    /**
     * Takes a claim that has it's object references set (i.e. ClaimedModule list and
     * Evidence objects for each ClaimedModule record in that list) and updates everything
     * in the database.
     * @param claim
     */
//    public static void updateCompleteClaim(Claim claim, Role role) {
//        ClaimIO claimIO = new ClaimIO(role);
//        ClaimedModuleIO claimedModuleIO = new ClaimedModuleIO(role);
//        EvidenceIO evidenceIO = new EvidenceIO(role);
//        ProviderIO providerIO = new ProviderIO(role);
//
//    }


}
