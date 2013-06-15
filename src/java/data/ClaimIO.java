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
 * Handles I/O for Claim made by the Student and assessed by assessors.
 * @author Adam Shortall, Bryce Carr, Mitch Carr, Todd Wiggins
 * @version 1.030
 * <b>Created:</b>  Unknown
 * <b>Modified:</b> 06/05/2013
 * <b>Change Log:</b>  08/04/2013:   Made small changes to incorporate the guideFileAddress DB field.
 *              24/04/2013:   Added header comments to match code conventions.
 *              01/05/2013:   Updated update(Claim) method to reflect change 2.090 to functions.sql
 *              01/05/2013:   Updated deleteClaim(Claim) and getById(Claim) methods to reflect change 2.091 to functions.sql
 *              04/05/2013:   Implemented getTotalClaims() method
 *              06/05/2013:   Fixed update method
 *              06/05/2013: TW: Added 'deleteDraft' method.
 *              15/06/2013: TW: Updated 'update' method to reflect DB changes and Assessor Approval
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
     * @param claim The Claim to insert into the database.
     * @throws SQLException if the Claim already exists in the database
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
     * Updates a database Claim entry with new data. Different
     * users have different privileges, so this works
     * differently depending on their role.
     * @param claim The Claim whose database record needs updating.
     * @throws SQLException if the Claim didn't already exist in the database.
     */
    public void update(Claim claim) throws SQLException {

        Role role = super.role;

        if (role == Role.CLERICAL){
            return;	//Clerical has no access to claims.
        }

        String sql;
        int claimID = claim.getClaimID();
        Option option = claim.getOption();
        Character optionValue = (option != null) ? option.value : Option.OTHER_PROVIDER.value;
        Integer status = claim.getStatus().code;

        SQLParameter p1 = new SQLParameter(claimID);
        SQLParameter p2;
        SQLParameter p3;
        SQLParameter p4 = new SQLParameter(optionValue);
        SQLParameter p9 = new SQLParameter(status);
		SQLParameter p10;

        if (role == Role.STUDENT) {
            sql = "SELECT fn_UpdateClaim(?,?,?,?,?)";
            String campusID = claim.getCampus().getCampusID();
            int disciplineID = claim.getDiscipline().getDisciplineID();

            p2 = new SQLParameter(campusID);
            p3 = new SQLParameter(disciplineID);

            super.doPreparedStatement(sql, p1, p2, p3, p4, p9);

			sql = "SELECT fn_assignclaim(?,?)";
			String assessorID = claim.getAssessorID();
			p10 = new SQLParameter(assessorID);
			super.doPreparedStatement(sql, p1, p10);
        } else {	//Assessor OR Delegate
            sql = "SELECT fn_UpdateClaim(?,?,?,?,?,?,?,?)";
            Boolean assessorApproved = claim.getAssessorApproved();
            Boolean delegateApproved = claim.getDelegateApproved();
            Boolean requestComp = claim.getRequestCompletion();
            String assessorID = claim.getAssessorID();
            //String delegateID = claim.getDelegateID();
			//TODO: Remove comment above and line below when Delegates are Automatically assigned
			String delegateID = "demo_deb"; //HACK as not working - for Demonstration

            p2 = new SQLParameter(assessorApproved);
            p3 = new SQLParameter(delegateApproved);
            SQLParameter p5 = new SQLParameter(requestComp);
            SQLParameter p7 = new SQLParameter(assessorID);
            SQLParameter p8 = new SQLParameter(delegateID);

            super.doPreparedStatement(sql, p1, p2, p3, p4, p5, p7, p8, p9);
        }

    }

    /**
     * Deletes a claim, and all claimed modules/evidence for that claim.
     * @param claim the claim to delete.
     * @throws SQLException if the Claim didn't already exist.
     */
    public void delete(Claim claim) throws SQLException {
        int claimID = claim.getClaimID();
        String sql = "SELECT fn_DeleteClaim(?)";

        SQLParameter p1 = new SQLParameter(claimID);

        super.doPreparedStatement(sql, p1);
    }

    /**
     * Deletes a draft claim, and all claimed modules/evidence for that claim.
     * If it isn't a draft claim, the command will do nothing.
     * @param claim The claim to delete.
     * @throws SQLException The claim doesn't exist.
     */
    public void deleteDraft(Claim claim) throws SQLException {
        int claimID = claim.getClaimID();
        String sql = "SELECT fn_DeleteDraftClaim(?)";

        SQLParameter p1 = new SQLParameter(claimID);

        super.doPreparedStatement(sql, p1);
    }

    /**
     * Gets a claim from the database, identified by a ClaimID.
     * @param claimID ID of the Claim to retrieve from the database.
     * @return Claim retrieved from the database
     */
    public Claim getByID(int claimID) {

        String sql = "SELECT * FROM fn_GetClaimByID(?)";
        SQLParameter p1 = new SQLParameter(claimID);

        try {
            ResultSet rs = super.doPreparedStatement(sql, p1);

            if (rs.next()) {
                return this.getClaimFromRS(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ClaimIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    /**
     * Returns a list of the user's claims. For students, these
     * are claims that the student has made. For teachers, these
     * are claims an assessor has assessed previously, and is
     * assigned to assess.
     *
     * @param user The user whose claims we want to grab
     * @return list of the user's claims
     * @throws SQLException If the User isn't in the database.
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
     * @return total number of claims in DB
     * @throws SQLException If the ResultSet returned contains data different
     *          than expected at the time of this method's creation.
     */
    public int getTotalClaims() throws SQLException {
        String sql = "SELECT * FROM fn_GetClaimTotal()";
        ResultSet rs = super.doPreparedStatement(sql);
        return rs.next() ? rs.getInt(1) : 0;
    }

    /**
     * Gets a Claim from the ResultSet passed in.
     * @param rs the ResultSet containing a Claim record.
     * @return the claim that the ResultSet's cursor is pointing at.
     * @throws SQLException if ResultSet passed in didn't contain a valid Claim.
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