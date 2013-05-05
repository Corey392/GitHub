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
 * @author Adam Shortall, Bryce Carr, Mitchell Carr
 * @version 1.02
 * <b>Created:</b> Unknown 
 * <b>Modified:</b> 24/04/2013
 * <b>Change Log:</b>  08/04/2013: Made small changes to incorporate guideFileAddress DB field.
 *                  24/04/2013: Added header comments to match code conventions.
 *                  05/05/2013: Updated delete to reflect DB
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
     * @throws SQLException if data is wrong.
     */
    public void insert(ClaimedModule claimedModule) throws SQLException {
        String sql = "SELECT fn_InsertClaimedModule(?,?)";
        String moduleID = claimedModule.getModuleID();
        int claimID = claimedModule.getClaimID();
        
        SQLParameter p1 = new SQLParameter(moduleID);
        SQLParameter p2 = new SQLParameter(claimID);
        
        super.doPreparedStatement(sql, p1, p2);
    }

    /**
     * Updates a ClaimedModule with new information.
     * @param claimedModule
     * @throws SQLException 
     */
    public void update(ClaimedModule claimedModule) throws SQLException {
        String sql = "SELECT fn_UpdateClaimedModule(?,?,?,?,?,?,?,?)";
        String moduleID = claimedModule.getModuleID();
        String studentID = claimedModule.getStudentID();
        int claimID = claimedModule.getClaimID();
        boolean approved = claimedModule.isApproved();
        String arrangementNo = claimedModule.getArrangementNo();
        String functionalCode = claimedModule.getFunctionalCode();
        boolean overseasEvidence = claimedModule.isOverseasEvidence();
        char recognition = claimedModule.getRecognition();
        
        SQLParameter p1 = new SQLParameter(moduleID);
        SQLParameter p2 = new SQLParameter(studentID);
        SQLParameter p3 = new SQLParameter(claimID);
        SQLParameter p4 = new SQLParameter(approved);
        SQLParameter p5 = new SQLParameter(arrangementNo);
        SQLParameter p6 = new SQLParameter(functionalCode);
        SQLParameter p7 = new SQLParameter(overseasEvidence);
        SQLParameter p8 = new SQLParameter(recognition);
        
        super.doPreparedStatement(sql, p1, p2, p3, p4, p5, p6, p7, p8);
    }
    
    /**
     * Deletes a ClaimedModule
     * @param claimedModule
     * @throws SQLException 
     */
    public void delete(ClaimedModule claimedModule) throws SQLException {
        String sql = "SELECT fn_DeleteClaimedModule(?,?)";
        String moduleID = claimedModule.getModuleID();
        int claimID = claimedModule.getClaimID();
        
        SQLParameter p1 = new SQLParameter(moduleID);
        SQLParameter p2 = new SQLParameter(claimID);
        
        super.doPreparedStatement(sql, p1, p2);
    }
    
    /**
     * Returns a list of ClaimedModule for a Claim.
     * @param claim
     * @return 
     */
    public ArrayList<ClaimedModule> getList(int claimID, String studentID) {
        ArrayList<ClaimedModule> list = null;
        String sql = "SELECT * FROM fn_ListClaimedModules(?)";
        SQLParameter p1 = new SQLParameter(claimID);
        
        try {
            ResultSet rs = super.doPreparedStatement(sql, p1);
            list = new ArrayList<ClaimedModule>();
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
                module = new ClaimedModule(claimID, studentID, moduleID);
                module.setApproved(approved);
                module.setArrangementNo(arrangementNo);
                module.setFunctionalCode(functionalCode);
                module.setOverseasEvidence(overseasEvidence);
                module.setRecognition(recognition);
                list.add(module);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ClaimedModuleIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
    
    /**
     * Add provider to a claimed module.
     * @param claimID
     * @param moduleID
     * @param provider
     */
    public void addProvider(int claimID, String moduleID, char providerID) throws SQLException {
        String sql = "SELECT fn_AddProviderToClaimedModule(?,?,?)";
        
        SQLParameter p1 = new SQLParameter(claimID);
        SQLParameter p2 = new SQLParameter(moduleID);
        SQLParameter p3 = new SQLParameter(providerID);
        
        super.doPreparedStatement(sql, p1, p2, p3);
    }
}
