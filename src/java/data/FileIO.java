package data;

import domain.ClaimFile;
import domain.User.Role;
import java.io.File;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

/** Purpose:    Manages communication with the File table in the Database. Also removes the physical file when calling a delete method.
 *  @author     Todd Wiggins
 *  @version    1.010
 *	Created:    13/05/2013
 *	Change Log: 15/05/2013: TW: Fixed removal of Physical file, also now removes directory if no other files exist within the claims/id/ directory.
 */
public class FileIO extends RPL_IO<ClaimFile> {

	public enum Field {
		FILE_ID("fileID"),
		CLAIM_ID("claimID"),
		FILENAME("filename");

		public final String name;

		Field(String name) {
			this.name = name;
		}
	}

	/**
	 * Creates a new instance of the FileIO class to access the database with the role specified.
	 * @param role Role of the currently logged in user.
	 */
	public FileIO(Role role) {
		super(role);
	}

	/**
	 * Processes the list of ClaimFiles and checks the FileID, if the file ID is '-1' signifying 'new' then an 'insert' will take place otherwise an update will take place.
	 * @param files The files to be inserted into the Database.
	 * @throws SQLException Exception thrown by Database, check Database log or Tomcat Logs for more information if not caught elsewhere.
	 */
	public void insertOrUpdate(ArrayList<ClaimFile> files) throws SQLException {
		for (ClaimFile claimFile : files) {
			if (claimFile.getFileID() == -1) {
				insert(claimFile);
			} else {
				update(claimFile);
			}
		}
	}

	/**
	 * Inserts the file into the database. Does not effect the physical file.
	 * Note: If you only have 1 file to upload send it through wrapped in an ArrayList.
	 * @param file The ClaimFile to be inserted into the Database.
	 * @throws SQLException Exception thrown by Database, check Database log or Tomcat Logs for more information if not caught elsewhere.
	 */
	public void insert(ClaimFile file) throws SQLException {

		String sql = "SELECT fn_insertFile(?,?);";
		SQLParameter p1 = new SQLParameter(file.getClaimID());
		SQLParameter p2 = new SQLParameter(file.getFilename());

		super.doPreparedStatement(sql, p1, p2);
	}

	/**
	 * Updates the file in the database. Does not effect the physical file.
	 * @param file The ClaimFile to be updated in the Database.
	 * @throws SQLException Exception thrown by Database, check Database log or Tomcat Logs for more information if not caught elsewhere.
	 */
	public void update(ClaimFile file) throws SQLException {

		String sql = "SELECT fn_updateFile(?,?,?);";
		SQLParameter p1 = new SQLParameter(file.getFileID());
		SQLParameter p2 = new SQLParameter(file.getClaimID());
		SQLParameter p3 = new SQLParameter(file.getFilename());

		super.doPreparedStatement(sql, p1, p2, p3);
	}

	/**
	 * Removes files from the Database and the File System.
	 * @param files The files to be removed from the Database and removed from the File System.
	 * @throws SQLException Exception thrown by Database, check Database log or Tomcat Logs for more information if not caught elsewhere.
	 */
	public void delete(ClaimFile claimFile) throws SQLException {

		String sql = "SELECT fn_deleteFile(?);";
		SQLParameter p1 = new SQLParameter(claimFile.getFileID());

		super.doPreparedStatement(sql, p1);

		String directory = ClaimFile.directoryClaims + claimFile.getClaimID() + "/";
		File file = new File(directory + claimFile.getFilename());
		file.delete();
		if (file.list() == null || file.list().length == 0) {
			file = new File(directory);
			file.delete();
		}

	}

	/**
	 * Removes all files that are associated with a particular claim ID both from the File System and Database even if the references are not correct..
	 * @throws SQLException Exception thrown by Database, check Database log or Tomcat Logs for more information if not caught elsewhere.
	 * @param claimID ID of the claim to delete files attached to
	 */
	public void deleteByClaim(int claimID) throws SQLException {

		String sql = "SELECT fn_deleteFiles(?);";
		SQLParameter p1 = new SQLParameter(claimID);

		super.doPreparedStatement(sql, p1);

		File directory = new File(ClaimFile.directoryClaims + claimID + "/");
		if (directory.isDirectory()) {
			directory.delete();
		}
	}

	/**
	 * Gets the file associated with the specified file ID.
	 * @param fileID The ID of the file to get the information for.
	 * @return The ClaimFile details as stored in the database.
	 * @throws SQLException Exception thrown by Database, check Database log or Tomcat Logs for more information if not caught elsewhere.
	 */
	public ClaimFile getFileByID(int fileID) throws SQLException {

		String sql = "SELECT * FROM fn_getFileByID(?)";
		SQLParameter p1 = new SQLParameter(fileID);

		ResultSet results = super.doPreparedStatement(sql, p1);

		ClaimFile cf = null;
		while (results.next()) {
			cf = new ClaimFile(results.getInt(Field.FILE_ID.name),results.getInt(Field.CLAIM_ID.name),results.getString(Field.FILENAME.name));
		}
		return cf;
	}

	/**
	 * Gets all the files associated with the specified claim ID.
	 * @param claimID The claim to get the files for.
	 * @return The list of files currently in the database associated with the claim ID specified.
	 * @throws SQLException Exception thrown by Database, check Database log or Tomcat Logs for more information if not caught elsewhere.
	 */
	public ArrayList<ClaimFile> getList(int claimID) throws SQLException {

		String sql = "SELECT * FROM fn_getAllFiles(?) ORDER BY filename";
		SQLParameter p1 = new SQLParameter(claimID);

		ResultSet results = super.doPreparedStatement(sql, p1);

		ArrayList<ClaimFile> files = new ArrayList<ClaimFile>();
		while (results.next()) {
			files.add(new ClaimFile(results.getInt(Field.FILE_ID.name),results.getInt(Field.CLAIM_ID.name),results.getString(Field.FILENAME.name)));
		}
		return files;
	}
}
