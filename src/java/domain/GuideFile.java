/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package domain;

/**
 *  Model class of a Guide File for a Course.
 * @author Bryce
 * Created:	23/05/2013
 * Modified:	23/05/2013
 * Version:	1.000
 * Changelog:	23/05/2013: Bryce Carr: Created class, copied and reworked basic fields and constructors from ClaimFile.java
 */
public class GuideFile {

    public final static String DIRECTORY_GUIDE_FILES = ClaimFile.directoryAbsolute + "/guideFiles/";
    public final static String FILE_NAME = "guideFile.txt";
    //Class variables/members
    private int fileID;
    private String courseID;
    private String filename;

    /**
     * Constructor for a Guide File ready to be added to the File table in the
     * Database.
     *
     * @param courseID The ID of the Course for this file to be associated with.
     * @param filename The actual filename including it's extension.
     */
    public GuideFile(String courseID, String filename) {
	this(-1, courseID, filename);
    }

    /**
     * @param fileID The integer ID for the file as stored in the database, use
     * -1 if this is a new file.
     * @param courseID The ID of the Course for this file to be associated with.
     * @param filename The actual filename including it's extension.
     */
    public GuideFile(int fileID, String courseID, String filename) {
	this.fileID = fileID;
	this.courseID = courseID;
	this.filename = filename;
    }

    /**
     * @return the fileID
     */
    public int getFileID() {
	return fileID;
    }

    /**
     * @return the courseID
     */
    public String getCourseID() {
	return courseID;
    }

    /**
     * @return the filename
     */
    public String getFilename() {
	return filename;
    }

    /**
     * @param fileID the fileID to set
     */
    public void setFileID(int fileID) {
	this.fileID = fileID;
    }

    /**
     * @param courseID the courseID to set
     */
    public void setCourseID(String courseID) {
	this.courseID = courseID;
    }

    /**
     * @param filename the filename to set
     */
    public void setFilename(String filename) {
	this.filename = filename;
    }
}
