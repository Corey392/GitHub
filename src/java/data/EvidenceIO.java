/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
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
        STUDENT_ID("studentID"),
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
        String sql = "SELECT fn_InsertEvidence(?,?,?,?,?)";
        
        String studentID = evidence.getStudentID();
        int claimID = evidence.getClaimID();
        Integer elementID = evidence.getElementID();
        String description = evidence.getDescription();
        String moduleID = evidence.getModuleID();
        
        SQLParameter p1, p2, p3, p4, p5;
        p1 = new SQLParameter(studentID);
        p2 = new SQLParameter(claimID);
        p3 = new SQLParameter(elementID);
        p4 = new SQLParameter(description);
        p5 = new SQLParameter(moduleID);
        
        super.doPreparedStatement(sql, p1, p2, p3, p4, p5);
    }
    
    /**
     * Updates evidence. Calls one of two database funcitons depending
     * on whether the claim type is RPL or PREVIOUS_STUDIES. Claim
     * type is determined by evidence.elementID.
     * @param evidence
     * @throws SQLException 
     */
    public void update(Evidence evidence) throws SQLException {
        String sql;

        String studentID, moduleID;
        int claimID, elementID;
        String description, assessorNote;
        boolean approved;        
        
        studentID = evidence.getStudentID();
        claimID = evidence.getClaimID();
        moduleID = evidence.getModuleID();
        description = evidence.getDescription();
        approved = evidence.isApproved();
        assessorNote = evidence.getAssessorNote();
        elementID = evidence.getElementID();
        
        SQLParameter p1, p2, p3, p4, p5, p6, p7;
        p1 = new SQLParameter(studentID);
        p2 = new SQLParameter(claimID);
        p3 = new SQLParameter(moduleID);
        p4 = new SQLParameter(description);
        p5 = new SQLParameter(approved);
        p6 = new SQLParameter(assessorNote);
        p7 = new SQLParameter(elementID);
        
        if (elementID == Util.INT_ID_EMPTY) { // Determines claim type
            sql = "SELECT fn_UpdateEvidence(?,?,?,?,?,?)";
            super.doPreparedStatement(sql, p1, p2, p3, p4, p5, p6);
        } else {
            sql = "SELECT fn_UpdateEvidence(?,?,?,?,?,?,?)";
            super.doPreparedStatement(sql, p1, p2, p3, p4, p5, p6, p7);
        }
    }
    
    /**
     * 
     * @param claimID
     * @param studentID
     * @param moduleID
     * @return 
     */
    public Evidence getByID(int claimID, String studentID, String moduleID, Integer elementID) {
        String sql = "SELECT * FROM fn_GetEvidence(?,?,?,?)";
        Evidence evidence = null;
        SQLParameter p1, p2, p3, p4;
        p1 = new SQLParameter(claimID);
        p2 = new SQLParameter(studentID);
        p3 = new SQLParameter(moduleID);
        p4 = new SQLParameter(elementID);
        try {
            ResultSet rs = super.doPreparedStatement(sql, p1, p2, p3, p4);
            if (rs.next()) {
                boolean approved = rs.getBoolean(Field.APPROVED.name);
                String assessorNote = rs.getString(Field.ASSESSOR_NOTE.name);
                String description = rs.getString(Field.DESCRIPTION.name);
                evidence = new Evidence(claimID, studentID, moduleID, description);
                evidence.setElementID(elementID);
                evidence.setApproved(approved);
                evidence.setAssessorNote(assessorNote);
            }
        } catch (SQLException ex) {
            Logger.getLogger(EvidenceIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return evidence;
    }
    
    /**
     * Returns a list of evidence for a claimedModule.
     * @param claimedModule
     * @return 
     */
    public ArrayList<Evidence> getList(int claimID, String studentID, String moduleID) {
        ArrayList<Evidence> list = null;
        
        String sql = "SELECT * FROM fn_ListEvidence(?,?,?)";
        SQLParameter p1, p2, p3;
        p1 = new SQLParameter(studentID);
        p2 = new SQLParameter(claimID);
        p3 = new SQLParameter(moduleID);
        
        ResultSet rs;
        try {
            rs = super.doPreparedStatement(sql, p1, p2, p3);
            list = new ArrayList<Evidence>();
            int elementID;
            boolean approved;
            String description;
            String assessorNote;
            while (rs.next()) {
                elementID = rs.getInt(Field.ELEMENT_ID.name); // returns 0 if elementID is null
                approved = rs.getBoolean(Field.APPROVED.name);
                assessorNote = rs.getString(Field.ASSESSOR_NOTE.name);
                description = rs.getString(Field.DESCRIPTION.name);
                Evidence evidence = new Evidence(claimID, studentID, moduleID);
                evidence.setApproved(approved);
                evidence.setAssessorNote(assessorNote);
                evidence.setDescription(description);
                evidence.setElementID(elementID);
                list.add(evidence);
            }
        } catch (SQLException ex) {
            Logger.getLogger(EvidenceIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
}