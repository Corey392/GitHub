package data;

import domain.Evidence;
import domain.User.Role;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import util.Util;
/**
 * Handles I/O for Evidence provided by the Student
 * in the database.
 * 
 * @author Adam Shortall
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

    public void insert(Evidence evidence) throws SQLException {
        
        String sql = "SELECT fn_InsertEvidence(?,?,?,?)";
        
        int claimID = evidence.getClaimID();
        Integer elementID = evidence.getElementID();
        String description = evidence.getDescription();
        String moduleID = evidence.getModuleID();
        
        SQLParameter p1 = new SQLParameter(claimID);
        SQLParameter p2 = new SQLParameter(elementID);
        SQLParameter p3 = new SQLParameter(description);
        SQLParameter p4 = new SQLParameter(moduleID);
        
        super.doPreparedStatement(sql, p1, p2, p3, p4);
    }
    
    /**
     * Updates evidence. Calls one of two database functions depending
     * on whether the claim type is RPL or PREVIOUS_STUDIES. Claim
     * type is determined by evidence.elementID.
     * @param evidence
     * @throws SQLException 
     */
    public void update(Evidence evidence) throws SQLException {
        
        String sql;
        
        int claimID = evidence.getClaimID();
        String moduleID = evidence.getModuleID();
        String description = evidence.getDescription();
        boolean approved = evidence.isApproved();
        String assessorNote = evidence.getAssessorNote();
        int elementID = evidence.getElementID();
        
        SQLParameter p1 = new SQLParameter(claimID);
        SQLParameter p2 = new SQLParameter(moduleID);
        SQLParameter p3 = new SQLParameter(description);
        SQLParameter p4 = new SQLParameter(approved);
        SQLParameter p5 = new SQLParameter(assessorNote);
        
        if (elementID == Util.INT_ID_EMPTY) { // Determines claim type
            sql = "SELECT fn_UpdateEvidence(?,?,?,?,?)";
            super.doPreparedStatement(sql, p1, p2, p3, p4, p5);
        } else {
            sql = "SELECT fn_UpdateEvidence(?,?,?,?,?,?)";
            SQLParameter p6 = new SQLParameter(elementID);
            super.doPreparedStatement(sql, p1, p2, p3, p4, p5, p6);
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
     * Returns a list of evidence for a claimedModule.
     * @param claimedModule
     * @return 
     */
    public ArrayList<Evidence> getList(int claimID, String moduleID) {
        
        String sql = "SELECT * FROM fn_ListEvidence(?,?)";
        
        SQLParameter p1 = new SQLParameter(claimID);
        SQLParameter p2 = new SQLParameter(moduleID);
        
        try {
            
            ResultSet rs = super.doPreparedStatement(sql, p1, p2);
            ArrayList<Evidence> list = new ArrayList<Evidence>();

            while (rs.next()) {
                int elementID = rs.getInt(Field.ELEMENT_ID.name); // returns 0 if elementID is null
                boolean approved = rs.getBoolean(Field.APPROVED.name);
                String assessorNote = rs.getString(Field.ASSESSOR_NOTE.name);
                String description = rs.getString(Field.DESCRIPTION.name);
                Evidence evidence = new Evidence(claimID, moduleID);
                evidence.setApproved(approved);
                evidence.setAssessorNote(assessorNote);
                evidence.setDescription(description);
                evidence.setElementID(elementID);
                list.add(evidence);
            }
            
            return list;
            
        } catch (SQLException ex) {
            Logger.getLogger(EvidenceIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return null;
        
    }
}
