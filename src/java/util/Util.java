/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
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
 *
 * @author Adam Shortall
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
        course.setElectiveModules(moduleIO.getListOfElectives(campusID, disciplineID, courseID));
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
        ArrayList<Criterion> criteria = criterionIO.getList(elementID, moduleID);
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
        
        if (module == null) return new Module();
        module.setElements(elementIO.getList(moduleID));
        for (Element e : module.getElements()) {
            e.setCriteria(criterionIO.getList(e.getElementID(), moduleID));
        }
        return module;
    }
    
    
    /**
     * Returns an Evidence record with completed element & criteria
     * @param claimID
     * @param studentID
     * @param moduleID
     * @param elementID
     * @param role
     * @return 
     */
    public static Evidence getCompleteEvidence(int claimID, String studentID, String moduleID, Integer elementID, Role role) {
        EvidenceIO evidenceIO = new EvidenceIO(role);
        Evidence evidence = evidenceIO.getByID(claimID, studentID, moduleID, elementID);
        if (!(elementID == null || elementID == Util.INT_ID_EMPTY)) {
            evidence.setElement(Util.getCompleteElement(elementID, moduleID, role));
        }
        return evidence;
    }
    
    /**
     * Returns a list of all Evidence for a claimed module, completed with elements and criteria.
     * @param claimID
     * @param studentID
     * @param moduleID
     * @param role
     * @return 
     */
    public static ArrayList<Evidence> getCompleteEvidenceList(int claimID, String studentID, String moduleID, Role role) {
        ArrayList<Evidence> list;
        EvidenceIO evidenceIO = new EvidenceIO(role);
        list = evidenceIO.getList(claimID, studentID, moduleID);
        for (Evidence e : list) {
            e.setElement(Util.getCompleteElement(e.getElementID(), moduleID, role));
        }
        return list;
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
        ArrayList<ClaimedModule> claimedModules = new ArrayList<ClaimedModule>();
        ClaimedModuleIO claimedModuleIO = new ClaimedModuleIO(role);
        ProviderIO providerIO = new ProviderIO(role);
        claimedModules = claimedModuleIO.getList(claimID, studentID);
        if (claimedModules != null) {
            for (ClaimedModule cm : claimedModules) {
                cm.setProviders(providerIO.getList(claimID, studentID, cm.getModuleID()));
                cm.setEvidence(Util.getCompleteEvidenceList(claimID, studentID, cm.getModuleID(), role));   
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
        Claim claim = claimIO.getByID(claimID, studentID);
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
     * Evidence objects for each ClaimedModule record in that list) and updates everyting
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
    
    public static ClaimRecord getCompleteClaimRecord(ClaimRecord pClaimRecord, Role role) {

        UserIO oUserIO = new UserIO(role); // for viewer
        User oUser = oUserIO.getStudentInfo(pClaimRecord.getStudentID());
        pClaimRecord.setStudentName(oUser.getFirstName() + oUser.getLastName());
        
        oUser = oUserIO.getStudentInfo(pClaimRecord.getWorkerID());
        if(oUser == null) {
            oUser = oUserIO.getTeacherInfo(pClaimRecord.getWorkerID());
        }
        pClaimRecord.setWorkerName(oUser.getFirstName() + oUser.getLastName());
        
        if(pClaimRecord.getWorkTime().length() > 18) {
            pClaimRecord.setWorkTime(pClaimRecord.getWorkTime().substring(0, 19));
        }
        
        // campus
        CampusIO oCampusIO = new CampusIO(role);
        Campus oCampus = oCampusIO.getByID(pClaimRecord.getCampusID());
        if(oCampus != null) {
            pClaimRecord.setCampusName(oCampus.getName());
        }
        
        // course
        CourseIO oCourseIO = new CourseIO(role);
        Course oCourse = oCourseIO.getByID(pClaimRecord.getCourseID());
        if(oCourse != null) {
            pClaimRecord.setCourseName(oCourse.getCourseID() + ":" + oCourse.getName());
        }
        
        return pClaimRecord;
    }    
}
