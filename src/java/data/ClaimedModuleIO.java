package data;

import domain.ClaimedModule;
import domain.User.Role;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Handles IO for ClaimedModule objects.
 * @author Adam Shortall, Bryce Carr, Mitchell Carr, Todd Wiggins
 * @version 1.004
 * <b>Created:</b> Unknown
 * <b>Change Log:</b>  08/04/2013: Made small changes to incorporate guideFileAddress DB field.
 *                  24/04/2013: Added header comments to match code conventions.
 *                  05/05/2013: Updated delete to reflect DB
 *                  06/05/2013: Fixed 'delete' method to send the parameters in to the database correctly.
 *                  15/05/2013: MC: Updated call to ClaimedModule where deprecated constructor was used
 *                              MC: Fixed 'fn_UpdateClaimedModule' call to reflect current DB
 *                              MC: Updated 'getList' to reflect changes made to ClaimedModule
 * <b>Purpose:</b>  Controller class for interaction with database's ClaimedModule table.
 */
public class ClaimedModuleIO extends RPL_IO <ClaimedModule> {

    private enum Field {
        MODULE_ID("moduleID"),
        CLAIM_ID("claimID"),
        APPROVED("approved"),
        ARRANGEMENT_NO("arrangementNo"),
        FUNCTIONAL_CODE("functionalCode"),
        OVERSEAS_EVIDENCE("overseasEvidence"),
        RECOGNITION("recognition");

        public final String name;

        Field(String name) {
            this.name = name;
        }

        @Override
        public String toString() {
            return this.name;
        }
    }

    public ClaimedModuleIO(Role role) {
        super(role);
    }

    /**
     * Inserts a new ClaimedModule.
     * @param claimedModule the ClaimedModule to insert.
     * @throws SQLException if ClaimedModule already exists in DB,
     *          or Module/Claim doesn't exist.
     */
    public void insert(ClaimedModule claimedModule) throws SQLException {
        
        String moduleID = claimedModule.getModuleID();
        int claimID = claimedModule.getClaimID();

        String sql = "SELECT fn_InsertClaimedModule(?,?)";
        SQLParameter p1 = new SQLParameter(moduleID);
        SQLParameter p2 = new SQLParameter(claimID);

        super.doPreparedStatement(sql, p1, p2);
    }

    /**
     * Updates a ClaimedModule with new information.
     * @param claimedModule ClaimedModule to update
     * @throws SQLException if ClaimedModule specified doesn't exist in DB
     */
    public void update(ClaimedModule claimedModule) throws SQLException {
        
        String sql = "SELECT fn_UpdateClaimedModule(?,?,?,?,?,?,?,?)";
        String moduleID = claimedModule.getModuleID();
        int claimID = claimedModule.getClaimID();
        boolean approved = claimedModule.isApproved();
        String arrangementNo = claimedModule.getArrangementNo();
        String functionalCode = claimedModule.getFunctionalCode();
        boolean overseasEvidence = claimedModule.isOverseasEvidence();
        char recognition = claimedModule.getRecognition();

        SQLParameter p1 = new SQLParameter(moduleID);
        SQLParameter p3 = new SQLParameter(claimID);
        SQLParameter p4 = new SQLParameter(approved);
        SQLParameter p5 = new SQLParameter(arrangementNo);
        SQLParameter p6 = new SQLParameter(functionalCode);
        SQLParameter p7 = new SQLParameter(overseasEvidence);
        SQLParameter p8 = new SQLParameter(recognition);

        super.doPreparedStatement(sql, p1, p3, p4, p5, p6, p7, p8);
    }

    /**
     * Deletes a ClaimedModule
     * @param claimedModule ClaimedModule to delete from database
     * @throws SQLException if ClaimedModule doesn't exist
     */
    public void delete(ClaimedModule claimedModule) throws SQLException {
        
        String moduleID = claimedModule.getModuleID();
        int claimID = claimedModule.getClaimID();

        String sql = "SELECT fn_DeleteClaimedModule(?,?)";
        SQLParameter p1 = new SQLParameter(claimID);
        SQLParameter p2 = new SQLParameter(moduleID);

        super.doPreparedStatement(sql, p1, p2);
    }

    /**
     * Returns a list of ClaimedModule for a Claim.
     * @param claimID ID of Claim for which the returned ClaimedModule objects 
     *              pertain to.
     * @param studentID ID of the student whose Claim the returned modules belong to
     * @return a list of ClaimedModule objects with the ClaimID passed in
     */
    public ArrayList<ClaimedModule> getList(int claimID) {
        
        String sql = "SELECT * FROM fn_ListClaimedModules(?)";
        SQLParameter p1 = new SQLParameter(claimID);

        try {
            ResultSet rs = super.doPreparedStatement(sql, p1);
            ArrayList<ClaimedModule> list = new ArrayList<ClaimedModule>();
            boolean approved, overseasEvidence;
            char recognition;
            String moduleID;
            String arrangementNo;
            String functionalCode;
            ClaimedModule module;
            while (rs.next()) {
                claimID = rs.getInt(Field.CLAIM_ID.name);
                moduleID = rs.getString(Field.MODULE_ID.name);
                approved = rs.getBoolean(Field.APPROVED.name);
                arrangementNo = rs.getString(Field.ARRANGEMENT_NO.name);
                functionalCode = rs.getString(Field.FUNCTIONAL_CODE.name);
                overseasEvidence = rs.getBoolean(Field.OVERSEAS_EVIDENCE.name);
                if (rs.getString(Field.RECOGNITION.name) != null) {
                    recognition = rs.getString(Field.RECOGNITION.name).charAt(0);
                } else {
                    recognition = ' ';
                }
                module = new ClaimedModule(claimID, moduleID, "");
                module.setApproved(approved);
                module.setArrangementNo(arrangementNo);
                module.setFunctionalCode(functionalCode);
                module.setOverseasEvidence(overseasEvidence);
                module.setRecognition(recognition);
                list.add(module);
            }
            return list;
        } catch (SQLException ex) {
            Logger.getLogger(ClaimedModuleIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    /**
     * Add provider to a claimed module.
     * @param claimID ClaimID of the ClaimedModule targeted
     * @param moduleID ModuleID of the ClaimedModule targeted
     * @param providerID ID of Provider to assign to the ClaimedModule
     * @throws SQLException If any of the IDs passed in aren't valid,
     *          or a ClaimedModuleProvider with those IDs already exists
     */
    public void addProvider(int claimID, String moduleID, char providerID) throws SQLException {
        String sql = "SELECT fn_AddProviderToClaimedModule(?,?,?)";

        SQLParameter p1 = new SQLParameter(claimID);
        SQLParameter p2 = new SQLParameter(moduleID);
        SQLParameter p3 = new SQLParameter(providerID);

        super.doPreparedStatement(sql, p1, p2, p3);
    }
}
