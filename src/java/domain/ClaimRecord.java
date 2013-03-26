/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package domain;

import util.FieldError;

/**
 *
 * @author David Gibbins
 * @author Adam Shortall
 */
public class ClaimRecord {   
    
    public enum Field {
        ID("^[0-9]{3}$", FieldError.CAMPUS_ID), 
        NAME("^[\\w+\\s\\w]+$", FieldError.CAMPUS_NAME);

        public final String pattern;
        public final FieldError fieldError;
        
        Field(String pattern, FieldError fieldError) {
            this.pattern = pattern;
            this.fieldError = fieldError;
        }
    }
    
    //Instance fields
    private Integer claimID;
    private String studentID;
    private Integer claimSeq;
    private String workerID;
    private String workTime;
    private Integer workType;
    private Integer workResult;
    
    private String studentName;
    private String workerName;
    private String workTypeName;
    private String workResultName;
    
    private Integer pageNo;
    
    private String courseID;
    private String campusID;
    private String courseName;
    private String campusName;
    private Integer claimType;

    public ClaimRecord() {}
    
    /**
     * Constructor
     */
    public ClaimRecord(Integer claimID
                     , String studentID
                     , Integer claimSeq
                     , String workerID
                     , String workTime
                     , Integer workType
                     , Integer workResult
                     , String campusID
                     , String courseID
                     , String claimType) {
        this.claimID = claimID;
        this.studentID = studentID;
        this.claimSeq = claimSeq;
        this.workerID = workerID;
        this.workTime = workTime;
        this.workType = workType;
        this.workResult = workResult;
        this.campusID = campusID;
        this.courseID = courseID;
        
        if(claimType.equals("RPL"))
            this.claimType = 0;
        else this.claimType = 1;
        
        switch(this.workResult) {
            case 0: this.workResultName = "Disapproved"; break;
            case 1: this.workResultName = "Approved"; break;
        }
        
        switch(this.workType) {
            case 0: this.workTypeName = "Claim"; break;
            case 1: this.workTypeName = "View"; break;
            case 2: this.workTypeName = "Update"; break;
            case 3: this.workTypeName = "Delete"; break;
            case 4: this.workTypeName = "Withdrawal"; break;
        }
    }

    public ClaimRecord(String workerID
                     , Integer workType
                     , Integer workResult
                     , Integer pageNo
                     , Integer claimType) {
        this.workerID = workerID;
        this.workType = workType;
        this.workResult = workResult;
        this.pageNo = pageNo;
        this.claimType = claimType;
    }    
    
    /**
     * 
     * @param workerID
     * @param workType
     * @param workResult 
     */
    public ClaimRecord(String workerID
                     , Integer workType
                     , Integer workResult
                     , Integer pageNo
                     , String courseID
                     , String campusID
                     , Integer claimType) {
        this.workerID = workerID;
        this.workType = workType;
        this.workResult = workResult;
        this.pageNo = pageNo;
        this.courseID = courseID;
        this.campusID = campusID;
        this.claimType = claimType;
    }
    
    public Integer getClaimID() {
        return claimID;
    }

    public Integer getClaimSeq() {
        return claimSeq;
    }

    public String getStudentID() {
        return studentID;
    }

    public Integer getWorkResult() {
        return workResult;
    }

    public String getWorkTime() {
        return workTime;
    }

    public Integer getWorkType() {
        return workType;
    }

    public String getWorkerID() {
        return workerID;
    }

    public void setClaimID(Integer claimID) {
        this.claimID = claimID;
    }

    public void setClaimSeq(Integer claimSeq) {
        this.claimSeq = claimSeq;
    }

    public void setStudentID(String studentID) {
        this.studentID = studentID;
    }

    public void setWorkResult(Integer workResult) {
        this.workResult = workResult;
        switch(this.workResult) {
            case 0: this.workResultName = "Disapproved"; break;
            case 1: this.workResultName = "Approved"; break;
        }
    }

    public void setWorkTime(String workTime) {
        this.workTime = workTime;
    }

    public void setWorkType(Integer workType) {
        this.workType = workType;
        switch(this.workType) {
            case 0: this.workTypeName = "Claim"; break;
            case 1: this.workTypeName = "View"; break;
            case 2: this.workTypeName = "Update"; break;
            case 3: this.workTypeName = "Delete"; break;
            case 4: this.workTypeName = "Withdrawal"; break;
        }
    }

    public void setWorkerID(String workerID) {
        this.workerID = workerID;
        
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getWorkResultName() {
        return workResultName;
    }

    public void setWorkResultName(String workResultName) {
        this.workResultName = workResultName;
    }

    public String getWorkTypeName() {
        return workTypeName;
    }

    public void setWorkTypeName(String workTypeName) {
        this.workTypeName = workTypeName;
    }

    public String getWorkerName() {
        return workerName;
    }

    public void setWorkerName(String workerName) {
        this.workerName = workerName;
    }

    public Integer getPageNo() {
        return pageNo;
    }

    public void setPageNo(Integer pageNo) {
        this.pageNo = pageNo;
    }

    public String getCampusID() {
        return campusID;
    }

    public void setCampusID(String campusID) {
        this.campusID = campusID;
    }

    public String getCourseID() {
        return courseID;
    }

    public void setCourseID(String courseID) {
        this.courseID = courseID;
    }

    public String getCampusName() {
        return campusName;
    }

    public void setCampusName(String campusName) {
        this.campusName = campusName;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public Integer getClaimType() {
        return claimType;
    }

    public void setClaimType(Integer claimType) {
        this.claimType = claimType;
    }
    
    
    
     /**
     * 
     * @return toString of superclass
     
    @Override
    public String toString() {
        if (claimID == 0) {
            return "";
        }
        if (studentID == null || studentID.isEmpty()) {
            return "";
        }
        return this.claimID + ": " + this.studentID + ": " + this.claimSeq + ": " + this.workerID + ": " + this.workTime + ": " + this.workType + ": " + this.workResult;
    }*/
}
