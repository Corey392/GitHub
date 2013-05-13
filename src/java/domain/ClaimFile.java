package domain;

import java.io.Serializable;

/** Purpose:    Used for storing data from the 'File' table in the database. Type is 'ClaimFile' as 'File' is a recognized Java class that will be used within the same class.
 *  @author     Todd Wiggins
 *  @version    1.000
 *	Created:    13/05/2013
 *	Change Log:
 */
public class ClaimFile implements Serializable {
	//Constant Declarations
	/**
	 * The directory on the local machine (server) where the files are stored. (Eg. '/usr/uploads/').
	 * Type specific sub-folders should be added after this directory (Eg. '/claims/' or '/help/').
	 */
	public static final String directoryAbsolute = "C:/Uploads/";
	/**
	 * The sub-directory of 'directoryAbsolute' where files for claims are stored.
	 * Files should be stored in another sub-directory per claim (Eg. '1/' for Claim ID '1').
	 * Convention will be ' directoryClaims + claimID + "/" + fileID from Database '.
	 */
	public static final String directoryClaims = directoryAbsolute + "claims/";

	//Class variables/members
	private int fileID;
	private int claimID;
	private String filename;

	/**
	 * Method to add Files ready to be added to the File table in the Database.
	 * @param claimID The ID of the claim for this file to be associated with.
	 * @param filename The actual filename including it's extension.
	 */
	public ClaimFile(int claimID, String filename) {
		this(-1,claimID,filename);
	}

	/**
	 * Method to add Files without a filename (used when deleting from list).
	 * @param fileID The integer ID for the file as stored in the database, use -1 if this is a new file.
	 * @param claimID The ID of the claim for this file to be associated with.
	 */
	public ClaimFile(int fileID, int claimID) {
		this(fileID,claimID,"");
	}

	/**
	 * Method to hold File information for the File table in the Database.
	 * @param fileID The integer ID for the file as stored in the database, use -1 if this is a new file.
	 * @param claimID The ID of the claim for this file to be associated with.
	 * @param filename The actual filename including it's extension.
	 */
	public ClaimFile(int fileID, int claimID, String filename) {
		this.fileID = fileID;
		this.claimID = claimID;
		this.filename = filename;
	}

	/** @return The ID of the claim this ClaimFile is associated with. */
	public int getClaimID() {
		return claimID;
	}

	/** @return The integer ID for the file as stored in the database, will be -1 if this is a new file. */
	public int getFileID() {
		return fileID;
	}

	/** @return The actual filename including it's extension. */
	public String getFilename() {
		return filename;
	}

	/** @param claimID The ID of the claim this ClaimFile is associated with. */
	public void setClaimID(int claimID) {
		this.claimID = claimID;
	}

	/** @param fileID The integer ID for the file as stored in the database, use -1 if this is a new file. */
	public void setFileID(int fileID) {
		this.fileID = fileID;
	}

	/** @param filename The actual filename including it's extension. */
	public void setFilename(String filename) {
		this.filename = filename;
	}
}