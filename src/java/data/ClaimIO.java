/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
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
 * @author Adam Shortall
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
        SQLParameter p1, p2, p3, p4, p5;

        p1 = new SQLParameter(studentID);
        p2 = new SQLParameter(campusID);
        p3 = new SQLParameter(disciplineID);
        p4 = new SQLParameter(courseID);
        p5 = new SQLParameter(claimType.value);

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
        String sql;
        switch (super.role) {
            case ADMIN:
            case TEACHER:
                sql = "SELECT fn_UpdateClaim(?,?,?,?,?,?,?,?,?,?)";
                break;
            case STUDENT:
                sql = "SELECT fn_UpdateClaim(?,?,?,?,?,?)";
                break;
            default: return;
        }
        int claimID = claim.getClaimID();
        String studentID = claim.getStudentID();
        String campusID = claim.getCampus().getCampusID();
        int disciplineID = claim.getDiscipline().getDisciplineID();
        Boolean assessorApproved = claim.getAssessorApproved();
        Boolean delegateApproved = claim.getDelegateApproved();
        Option option = claim.getOption();
        Character optionValue = null;
        if (option != null) {
            optionValue = option.value;
        } else {
            optionValue = Option.OTHER_PROVIDER.value;
        }
        Boolean requestComp = claim.getRequestCompletion();
        Date dateResolved = claim.getDateResolved();
        String assessorID = claim.getAssessorID();
        String delegateID = claim.getDelegateID();
        
        SQLParameter p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11,p12;
        p1 = new SQLParameter(claimID);
        p2 = new SQLParameter(studentID);        
        p7 = new SQLParameter(optionValue);
        p12 = new SQLParameter(claim.getStatus().code);
        
        switch (super.role) {
            case ADMIN:
            case TEACHER:
                p5 = new SQLParameter(assessorApproved);
                p6 = new SQLParameter(delegateApproved);
                p8 = new SQLParameter(requestComp);
                p9 = new SQLParameter(dateResolved);
                p10 = new SQLParameter(assessorID);
                p11 = new SQLParameter(delegateID);
                super.doPreparedStatement(sql, p1, p2, p5, p6, p7, p8, p9, p10, p11, p12);
                break;
            case STUDENT:
                p3 = new SQLParameter(campusID);
                p4 = new SQLParameter(disciplineID);
                super.doPreparedStatement(sql, p1, p2, p3, p4, p7, p12);
            default: return;
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
        
        SQLParameter p1, p2;
        p1 = new SQLParameter(claimID);
        p2 = new SQLParameter(studentID);
        
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
        SQLParameter p1, p2;
        p1 = new SQLParameter(claimID);
        p2 = new SQLParameter(studentID);
        
        ResultSet rs;
        try {
            rs = super.doPreparedStatement(sql, p1, p2);
            
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
        SQLParameter p1;
        p1 = new SQLParameter(user.getUserID());
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
        int claimID = 0;
        String studentID = null;
        String campusID = null;
        String courseID = null;
        Integer disciplineID = null;
        String assessorID = null;
        String delegateID = null;
        Boolean assessorApproved = null;
        Boolean delegateApproved = null;
        Option option = null;
        Status status = null;
        ClaimType claimType = null;
        Date dateMade = null;
        Date dateResolved = null;
        Boolean requestCompletion = null;
        
        claimID = rs.getInt(Field.CLAIM_ID.name);
        studentID = rs.getString(Field.STUDENT_ID.name);
        assessorApproved = rs.getBoolean(Field.ASSESSOR_APPROVED.name);
        delegateApproved = rs.getBoolean(Field.DELEGATE_APPROVED.name);
        campusID = rs.getString(Field.CAMPUS_ID.name);
        courseID = rs.getString(Field.COURSE_ID.name); 
        disciplineID = rs.getInt(Field.DISCIPLINE_ID.name);
        assessorID = rs.getString(Field.ASSESSOR_ID.name);
        delegateID = rs.getString(Field.DELEGATE_ID.name);                 
        String opt = rs.getString(Field.OPTION.name);
        if (opt != null) option = Option.getFromChar(opt.charAt(0));
System.out.println("===>" + Field.STATUS.name);        
        status = Status.getFromInt(rs.getInt(Field.STATUS.name));
        claimType = ClaimType.getFromBool(rs.getBoolean(Field.CLAIM_TYPE.name)); 
        dateMade = rs.getDate(Field.DATE_MADE.name);
        dateResolved = rs.getDate(Field.DATE_RESOLVED.name);
        requestCompletion = rs.getBoolean(Field.REQUEST_COMPLETION.name);
        
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
