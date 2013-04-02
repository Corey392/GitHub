package data;

import domain.ClaimRecord;
import domain.User.Role;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import util.RPLPaging; 

/**
 *
 * @author James, Adam Shortall
 */
public class ClaimRecordIO extends RPL_IO<ClaimRecord> {
    
    public enum Field {
        CLAIM_ID("claimID"),
        STUDENT_ID("studentID"),
        CLAIM_SEQ("claimSeq"),
        WORK_TIME("workTime"),
        WORKER_ID("workerID"),
        WORK_TYPE("workType"),
        WORK_RESULT("workResult"),
        CAMPUS_ID("campusID"),
        COURSE_ID("courseID"),
        CLAIM_TYPE("claimType");
        
        public final String name;
        
        Field(String name) {
            this.name = name;
        }
    }
    
    public ClaimRecordIO(Role role) {
        super(role);
    }
    
    /**
     * Returns a list of all claim records according to a specific user.
     * @return all claim records in the database
     */
    public ArrayList<ClaimRecord> getList(ClaimRecord pClaimRecord, String role) {
        ArrayList<ClaimRecord> list = null;
        String claimType = "";
        String sql = "SELECT * FROM fn_ListClaimRecords(?, ?, ?, ?, ?, ?, ?);";
        SQLParameter p1 = new SQLParameter(pClaimRecord.getWorkerID());
        SQLParameter p2 = new SQLParameter(pClaimRecord.getWorkType());
        SQLParameter p3 = new SQLParameter(pClaimRecord.getWorkResult());
        int[] pageNum = RPLPaging.calculatePageNum(pClaimRecord.getPageNo());
        SQLParameter p4 = new SQLParameter(pageNum[1]);
        SQLParameter p5 = new SQLParameter(pageNum[0]);
        SQLParameter p6 = new SQLParameter(role);
        SQLParameter p7 = new SQLParameter(pClaimRecord.getClaimType());
        
        try {
            ResultSet rs = super.doPreparedStatement(sql, p1, p2, p3, p4, p5, p6, p7);
            list = new ArrayList<ClaimRecord>();
            while (rs.next()) {
                switch(rs.getInt(Field.CLAIM_TYPE.name)) {
                    case 0: claimType = "RPL"; break;
                    case 1: claimType = "Previous Studies"; break;    
                }
                ClaimRecord oClaimRecord = new ClaimRecord(rs.getInt(Field.CLAIM_ID.name)
                                             , rs.getString(Field.STUDENT_ID.name)
                                             , rs.getInt(Field.CLAIM_SEQ.name)
                                             , rs.getString(Field.WORKER_ID.name)
                                             , rs.getString(Field.WORK_TIME.name)
                                             , rs.getInt(Field.WORK_TYPE.name)
                                             , rs.getInt(Field.WORK_RESULT.name)
                                             , rs.getString(Field.CAMPUS_ID.name)
                                             , rs.getString(Field.COURSE_ID.name)
                                             , claimType
                                               );
                list.add(oClaimRecord);
            }
        } catch (SQLException ex) {
            Logger.getLogger(CampusIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
    
    /**
     * Returns the number of all claim records according to a specific user.
     * @param pClaimRecord
     * @param role
     * @return the number of records
     */
    public int getListCount(ClaimRecord pClaimRecord, String role) {
        Integer listCount = 0;
        String sql = "SELECT * FROM fn_listclaimrecordsCount(?, ?, ?, ?, ?);";
        SQLParameter p1 = new SQLParameter(pClaimRecord.getWorkerID());
        SQLParameter p2 = new SQLParameter(pClaimRecord.getWorkType());
        SQLParameter p3 = new SQLParameter(pClaimRecord.getWorkResult());
        SQLParameter p4 = new SQLParameter(role);
        SQLParameter p5 = new SQLParameter(pClaimRecord.getClaimType());
        
        try {
            ResultSet rs = super.doPreparedStatement(sql, p1, p2, p3, p4, p5);
            if (rs.next()) {
                listCount = rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(CampusIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return listCount;
    }    

    /**
     * Inserts a new campus record.
     * @param campus The campus to insert.
     * @throws SQLException If the campusID is not unique.
     */
    public void insert(ClaimRecord pClaimRecord) throws SQLException {
        String sql = "SELECT fn_InsertClaimRecords(?,?,?,?,?,?,?,?,?)";
        SQLParameter p1 = new SQLParameter(pClaimRecord.getClaimID());
        SQLParameter p2 = new SQLParameter(pClaimRecord.getStudentID());
        SQLParameter p3 = new SQLParameter(getSequence(pClaimRecord));
        SQLParameter p4 = new SQLParameter(pClaimRecord.getWorkerID());
//        SQLParameter p5 = new SQLParameter(pClaimRecord.getWorkTime());
        SQLParameter p5 = new SQLParameter(pClaimRecord.getWorkType());
        SQLParameter p6 = new SQLParameter(pClaimRecord.getWorkResult());
        SQLParameter p7 = new SQLParameter(pClaimRecord.getCampusID());
        SQLParameter p8 = new SQLParameter(pClaimRecord.getCourseID());
        SQLParameter p9 = new SQLParameter(pClaimRecord.getClaimType());
        super.doPreparedStatement(sql, p1, p2, p3, p4, p5, p6, p7, p8, p9);
    }
    
    /**
     * Acquire sequence number
     * @param pClaimRecord
     * @return 
     */
    public int getSequence(ClaimRecord pClaimRecord) {
        
        int maxSeq = 0;
        String sql = "SELECT fn_GetSequenceClaimRecords(?,?) as maxSeq";
        SQLParameter p1 = new SQLParameter(pClaimRecord.getClaimID());
        SQLParameter p2 = new SQLParameter(pClaimRecord.getStudentID());
        
        try {
            ResultSet rs = super.doPreparedStatement(sql, p1, p2);
            if(rs.next()) {
                maxSeq = rs.getInt("maxSeq");
            }
            rs.close();
        } catch (SQLException ex) {
            Logger.getLogger(ClaimRecordIO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            
        }

        return maxSeq;
    }
    
}
