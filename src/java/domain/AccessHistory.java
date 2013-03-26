/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package domain;

import java.util.Calendar;
import java.text.SimpleDateFormat;
import data.AccessHistoryIO;

/**
 * Records and retrieves all users access history
 * 
 * @author Ben Morrison
 */

public class AccessHistory implements Comparable<AccessHistory> {
    private String accessID;
    private String userID;
    private String accessTime;
    private String accessType;
    
    public void setAccessID(String accessID) { this.accessID = accessID; }
    public String getAccessID() { return this.accessID; }
    
    public void setUserID(String userID) { this.userID = userID; }
    public String getUserID() { return this.userID; }
    
    public void setAccessTime(String accessTime) { this.accessTime = accessTime; }
    public String getAccessTime() { return this.accessTime; }
    
    public void setAccessType(String accessType) { this.accessType = accessType; }
    public String getAccessType() { return this.accessType; }
    
    public int compareTo(AccessHistory history) {
        return this.accessID.compareTo(history.getAccessID());
    }
}