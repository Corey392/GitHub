package data;

import domain.Claim;
import domain.Claim.ClaimType;
import domain.Claim.Option;
import domain.Claim.Status;
import domain.User;
import domain.User.Role;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Handles I/O for Claim made by the Student 
 * and assessed by assessors.
 * 
 * @author Adam Shortall, Bryce Carr
 * @version 1.02
 * <b>Created:</b>  Unknown
 * <b>Modified:</b> 24/04/2013
 * <b>Change Log:</b>  08/04/2013:   Made small changes to incorporate the guideFileAddress DB field.
 *              24/04/2013:   Added header comments to match code conventions.
 * <b>Purpose:</b>  Controller class for interaction between application and database's Claim table. 
 */
public class ClaimIO extends RPL_IO <Claim> {

    public enum Field {
        CLAIM_ID("claimID"),
        STUDENT_ID("studentID"),
        DATE_MADE("dateMade"),
        DATE_RESOLVED("dateResolved"),
        CLAIM_TYPE("claimType"),
        COURSE_ID("courseID"),
        CAMPUS_ID("campusID"),
        DISCIPLINE_ID("disciplineID"),
        ASSESSOR_APPROVED("assApproved"),
        DELEGATE_APPROVED("delApproved"),
        OPTION("option"),
        REQUEST_COMPLETION("requestComp"),
        ASSESSOR_ID("assessorID"),
        DELEGATE_ID("delegateID"),
        STATUS("status");
        
        public final String name;
        
        Field(String name) {
            this.name = name;
        }
    }
    
    public ClaimIO(Role role) {
        super(role);
    }

    /**
     * Inserts a new claim. Some fields are set automatically:
     * claimID, dateMade and submitted.
     * @param claim the claim to insert.
     * @throws SQLException the data is wrong.
     */
    public void insert(Claim claim) throws SQLException {
        String studentID = claim.getStudentID();
        String campusID = claim.getCampusID();
        String courseID = claim.getCourseID();
        Integer disciplineID = claim.getDisciplineID();
        ClaimType claimType = claim.getClaimType();
        
        String sql = "SELECT fn_InsertClaim(?,?,?,?,?)";

        SQLParameter p1 = new SQLParameter(studentID);
        SQLParameter p2 = new SQLParameter(campusID);
        SQLParameter p3 = new SQLParameter(disciplineID);
        SQLParameter p4 = new SQLParameter(courseID);
        SQLParameter p5 = new SQLParameter(claimType.value);

        super.doPreparedStatement(sql, p1, p2, p3, p4, p5);
    }

    /**
     * Updates a claim with new claim data. Different
     * users have different priviliges so this works
     * differently depending on ther user's role.
     * @param claim the claim containing new claim data
     * @throws SQLException 
     */
    public void update(Claim claim) throws SQLException {
        
        Role role = super.role;
        
        if (!(role == Role.ADMIN || role == Role.TEACHER || role == Role.STUDENT)){
            return;
        }
        
        String sql;
        int claimID = claim.getClaimID();
        String studentID = claim.getStudentID();
        Option option = claim.getOption();
        Character optionValue = (option != null) ? option.value : Option.OTHER_PROVIDER.value;
        
        SQLParameter p1 = new SQLParameter(claimID);
        SQLParameter p2 = new SQLParameter(studentID);
        SQLParameter p3;
        SQLParameter p4;
        SQLParameter p5 = new SQLParameter(optionValue);
        
        if (role == Role.STUDENT) {
            sql = "SELECT fn_UpdateClaim(?,?,?,?,?)";
            String campusID = claim.getCampus().getCampusID();
            int disciplineID = claim.getDiscipline().getDisciplineID();
                
            p3 = new SQLParameter(campusID);
            p4 = new SQLParameter(disciplineID);
                
            super.doPreparedStatement(sql, p1, p2, p3, p4, p5);
        }else {
            sql = "SELECT fn_UpdateClaim(?,?,?,?,?,?,?,?,?)";
            Boolean assessorApproved = claim.getAssessorApproved();
            Boolean delegateApproved = claim.getDelegateApproved();
            Boolean requestComp = claim.getRequestCompletion();
            Date dateResolved = claim.getDateResolved();
            String assessorID = claim.getAssessorID();
            String delegateID = claim.getDelegateID();
                
            p3 = new SQLParameter(assessorApproved);
            p4 = new SQLParameter(delegateApproved);
            SQLParameter p6 = new SQLParameter(requestComp);
            SQLParameter p7 = new SQLParameter(dateResolved);
            SQLParameter p8 = new SQLParameter(assessorID);
            SQLParameter p9 = new SQLParameter(delegateID);
                
            super.doPreparedStatement(sql, p1, p2, p3, p4, p5, p6, p7, p8, p9);
        }
           
    }
    
    /**
     * Deletes a claim, and all claimed modules/evidence for that claim.
     * @param claim the claim to delete.
     * @throws SQLException 
     */

    public void delete(Claim claim) throws SQLException {        
        int claimID = claim.getClaimID();
        String studentID = claim.getStudentID();
        String sql = "SELECT fn_DeleteClaim(?,?)";
        
        SQLParameter p1 = new SQLParameter(claimID);
        SQLParameter p2 = new SQLParameter(studentID);
        
        super.doPreparedStatement(sql, p1, p2);
    }
    
    /**
     * Gets a claim from the database, identified by a studentID and
     * a claimID.
     * @param claimID
     * @param studentID
     * @return 
     */
    public Claim getByID(int claimID, String studentID) {
        
        String sql = "SELECT * FROM fn_GetClaimByID(?,?)";
        SQLParameter p1 = new SQLParameter(claimID);
        SQLParameter p2 = new SQLParameter(studentID);
        
        try {
            ResultSet rs = super.doPreparedStatement(sql, p1, p2);
            
            if (rs.next()) {
                return this.getClaimFromRS(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ClaimIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
    
    /**
     * Returns a list of the user's claims. For students these
     * are claims that the student has made. For teachers, these
     * are claims the assessor has assessed previously, and is
     * assigned to assess. 
     * 
     * @param user The user who's claims to get
     * @return list of the user's claims
     */
    public ArrayList<Claim> getList(User user) throws SQLException {
        ArrayList<Claim> list = new ArrayList<Claim>();
        String sql;
        if (user.role == Role.STUDENT) {
            sql = "SELECT * FROM fn_ListClaimsByStudent(?)";
        } else {
            sql = "SELECT * FROM fn_ListClaimsByTeacher(?)";
        }
        SQLParameter p1 = new SQLParameter(user.getUserID());
        ResultSet rs = super.doPreparedStatement(sql, p1);
        
        while (rs.next()) {
            list.add(this.getClaimFromRS(rs));
        }
        return list;
    }
    
    /**
     * Gets a claim from the result set.
     * @param rs the ResultSet pointing to a claim record.
     * @return the claim that the ResultSet's cursor is pointing at.
     * @throws SQLException if database threw an exception, check SQLState for vendor error code.
     */
    private Claim getClaimFromRS(ResultSet rs) throws SQLException {
        
        int claimID = rs.getInt(Field.CLAIM_ID.name);
        String studentID = rs.getString(Field.STUDENT_ID.name);
        Boolean assessorApproved = rs.getBoolean(Field.ASSESSOR_APPROVED.name);
        Boolean delegateApproved = rs.getBoolean(Field.DELEGATE_APPROVED.name);
        String campusID = rs.getString(Field.CAMPUS_ID.name);
        String courseID = rs.getString(Field.COURSE_ID.name); 
        Integer disciplineID = rs.getInt(Field.DISCIPLINE_ID.name);
        String assessorID = rs.getString(Field.ASSESSOR_ID.name);
        String delegateID = rs.getString(Field.DELEGATE_ID.name);                 
        String opt = rs.getString(Field.OPTION.name);
        Option option = (opt != null) ? Option.getFromChar(opt.charAt(0)) : null;

        System.out.println("===>" + Field.STATUS.name);    

        Status status = Status.getFromInt(rs.getInt(Field.STATUS.name));
        ClaimType claimType = ClaimType.getFromBool(rs.getBoolean(Field.CLAIM_TYPE.name)); 
        Date dateMade = rs.getDate(Field.DATE_MADE.name);
        Date dateResolved = rs.getDate(Field.DATE_RESOLVED.name);
        Boolean requestCompletion = rs.getBoolean(Field.REQUEST_COMPLETION.name);
        
        return new Claim(
                        claimID, 
                        studentID, 
                        campusID, 
                        disciplineID, 
                        courseID, 
                        assessorApproved, 
                        delegateApproved, 
                        option, 
                        status, 
                        claimType,
                        dateMade, 
                        dateResolved,
                        requestCompletion,
                        assessorID,
                        delegateID);
    }
}
