package data;

import domain.Evidence;
import domain.User.Role;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/** Handles I/O for Evidence provided by the Student in the database.
 *  @author     Adam Shortall, Mitchell Carr, Todd Wiggins
 *  @version    1.030
 *	Created:    ?
 *	Change Log: 06/05/2013: TW: Added Evidence ArrayList for getEvidence method.
 *				08/05/2013: TW: Updated 'update' method for updated Database function, added insertAndOrUpdate method, added checking 'updated' flag on for each instance of Evidence in update and insert methods.
 */
public class EvidenceIO extends RPL_IO<Evidence> {

    public enum Field {
        CLAIM_ID("claimID"),
        ELEMENT_ID("elementID"),
        DESCRIPTION("description"),
        MODULE_ID("moduleID"),
        APPROVED("approved"),
        ASSESSOR_NOTE("assessorNote");

        public final String name;

        Field(String name) {
            this.name = name;
        }
    }

    public EvidenceIO(Role role) {
        super(role);
    }

	/**
	 * Convenience method, performs an 'Insert' to new Evidence items and then an 'Update' for any non-new Evidence items.
	 * @author Todd Wiggins
	 * @param evidence ArrayList of Evidence with the 'updated' field set.
	 * @throws SQLException For any failures from the database
	 */
	public void insertAndOrUpdate(ArrayList<Evidence> evidence) throws SQLException {
		this.insert(evidence);
		this.update(evidence);
	}

    public void insert(ArrayList<Evidence> evidence) throws SQLException {
		for (Evidence evi : evidence) {
			if (!evi.isUpdated()) {
				String sql = "SELECT fn_InsertEvidence(?,?,?,?)";

				int claimID = evi.getClaimID();
				Integer elementID = evi.getElementID();
				String description = evi.getDescription();
				String moduleID = evi.getModuleID();

				SQLParameter p1 = new SQLParameter(claimID);
				SQLParameter p2 = new SQLParameter(elementID);
				SQLParameter p3 = new SQLParameter(description);
				SQLParameter p4 = new SQLParameter(moduleID);

				super.doPreparedStatement(sql, p1, p2, p3, p4);
			}
		}
    }

    /**
     * Updates evidence. Calls one of two database functions depending
     * on whether the claim type is RPL or PREVIOUS_STUDIES. Claim
     * type is determined by evidence.elementID.
     * @param evidence
     * @throws SQLException
     */
    public void update(ArrayList<Evidence> evidence) throws SQLException {
        String sql;
		for (Evidence evi : evidence) {
			if (evi.isUpdated()) {
				int claimID = evi.getClaimID();
				int elementID = evi.getElementID();
				String moduleID = evi.getModuleID();
				String description = evi.getDescription();
				boolean approved = evi.isApproved();
				String assessorNote = evi.getAssessorNote();

				SQLParameter p1 = new SQLParameter(claimID);
				SQLParameter p2 = new SQLParameter(elementID);
				SQLParameter p3 = new SQLParameter(moduleID);
				SQLParameter p4 = new SQLParameter(description);
				SQLParameter p5 = new SQLParameter(approved);
				SQLParameter p6 = new SQLParameter(assessorNote);

				sql = "SELECT fn_UpdateEvidence(?,?,?,?,?,?)";
				super.doPreparedStatement(sql, p1, p2, p3, p4, p5, p6);
			}
		}
    }

    /**
     *
     * @param claimID
     * @param moduleID
     * @return
     */
    public Evidence getByID(int claimID, String moduleID, Integer elementID) {

        String sql = "SELECT * FROM fn_GetEvidence(?,?,?)";

        SQLParameter p1 = new SQLParameter(claimID);
        SQLParameter p2 = new SQLParameter(moduleID);
        SQLParameter p3 = new SQLParameter(elementID);

        try {
            ResultSet rs = super.doPreparedStatement(sql, p1, p2, p3);
            if (rs.next()) {
                boolean approved = rs.getBoolean(Field.APPROVED.name);
                String assessorNote = rs.getString(Field.ASSESSOR_NOTE.name);
                String description = rs.getString(Field.DESCRIPTION.name);
                Evidence evidence = new Evidence(claimID, moduleID, description);
                evidence.setElementID(elementID);
                evidence.setApproved(approved);
                evidence.setAssessorNote(assessorNote);
                return evidence;
            }

        } catch (SQLException ex) {
            Logger.getLogger(EvidenceIO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return null;

    }

   /**
     * Returns evidence for a claimedModule.
     * @param claimedModule
     * @return
     */
    public ArrayList<Evidence> getEvidence(int claimID, String moduleID) {
        String sql = "SELECT * FROM fn_ListEvidence(?,?)";

        SQLParameter p1 = new SQLParameter(claimID);
        SQLParameter p2 = new SQLParameter(moduleID);

        try {

            ResultSet rs = super.doPreparedStatement(sql, p1, p2);
            ArrayList<Evidence> evidence = new ArrayList<Evidence>();

            if (rs.next()) {
                int elementID = rs.getInt(Field.ELEMENT_ID.name); // returns 0 if elementID is null
                boolean approved = rs.getBoolean(Field.APPROVED.name);
                String assessorNote = rs.getString(Field.ASSESSOR_NOTE.name);
                String description = rs.getString(Field.DESCRIPTION.name);
				Evidence e = new Evidence(claimID, moduleID);
                e.setApproved(approved);
                e.setAssessorNote(assessorNote);
                e.setDescription(description);
                e.setElementID(elementID);
				evidence.add(e);
            }

            return evidence;

        } catch (SQLException ex) {
            Logger.getLogger(EvidenceIO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return null;

    }
}
