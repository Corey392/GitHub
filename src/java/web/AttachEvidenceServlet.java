package web;

import data.FileIO;
import domain.Claim;
import domain.ClaimFile;
import domain.User;
import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.tomcat.util.http.fileupload.FileItem;
import org.apache.tomcat.util.http.fileupload.FileItemFactory;
import org.apache.tomcat.util.http.fileupload.FileUploadException;
import org.apache.tomcat.util.http.fileupload.disk.DiskFileItemFactory;
import org.apache.tomcat.util.http.fileupload.servlet.ServletFileUpload;
import util.RPLPage;

/**	Purpose:    Handles uploading evidence files to a claim. (NOT Finished)
 *  @author     Todd Wiggins
 *  @version    1.000
 *	Created:    13/05/2013
 *	Change Log:
 *  References: http://www.avajava.com/tutorials/lessons/how-do-i-upload-a-file-to-a-servlet.html
 */
public class AttachEvidenceServlet extends HttpServlet {

	/**Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
	 * @param request  servlet request
	 * @param response servlet response
	 * @throws ServletException if a servlet-specific error occurs
	 * @throws IOException      if an I/O error occurs
	 */
	protected void processRequest(HttpServletRequest request, HttpServletResponse response)	throws ServletException, IOException {
		String url = RPLPage.ATTACH_EVIDENCE.relativeAddress;
		//Get session User & Claim.
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute("user");
		Claim claim = (Claim) session.getAttribute("claim");

		//Get ready for database activity
		FileIO fileIO = new FileIO(user.role);
		//Get any files currently attached to this claim
		ArrayList<ClaimFile> claimFiles;
		try {
			claimFiles = fileIO.getList(claim.getClaimID());
		} catch (SQLException ex) {
			Logger.getLogger(AttachEvidenceServlet.class.getName()).log(Level.SEVERE, null, ex);
			claimFiles = new ArrayList<ClaimFile>();
		}

		String[] values = request.getParameterValues("remove");
		if (values != null) {

		for (String v : values) {
			System.out.println("Values ::: "+v);
		}

		}
		String fileFolder = claim.getClaimID() + "/";
		File fileFolderLocation = new File(ClaimFile.directoryClaims+fileFolder);

		if (ServletFileUpload.isMultipartContent(request)) {	//Was the form submitted with files?
			FileItemFactory factory = new DiskFileItemFactory();
			ServletFileUpload upload = new ServletFileUpload(factory);
			try {
				//Get the files
				List<FileItem> files = upload.parseRequest(request);
				Iterator<FileItem> it = files.iterator();

				while (it.hasNext()) {
					FileItem fileItem = it.next();
					if (!fileItem.isFormField()) {
						//Ensure the folder for the files exists otherwise create it.
						fileFolderLocation.mkdirs();
						//Generate the file name and location to save the files uploaded.
						String fileName = fileItem.getName();
						File fileSaveLocation = new File(ClaimFile.directoryClaims+fileFolder+fileName);
						//Save the file to the new loaction.
						fileItem.write(fileSaveLocation);

						//Add the file references to the database.
						claimFiles.add(new ClaimFile(claim.getClaimID(), fileName));
						System.out.println("File Uploaded to: "+fileSaveLocation.getAbsolutePath());
					}
				}
				//Update the database
				fileIO.insertOrUpdate(claimFiles);
			} catch (FileUploadException ex) {
				Logger.getLogger(AttachEvidenceServlet.class.getName()).log(Level.SEVERE, null, ex);
			} catch (Exception e) {
				Logger.getLogger(AttachEvidenceServlet.class.getName()).log(Level.SEVERE, null, e);
			}

			//Update the filelist.
			try {
				claimFiles = fileIO.getList(claim.getClaimID());
			} catch (SQLException ex) {
				Logger.getLogger(AttachEvidenceServlet.class.getName()).log(Level.SEVERE, null, ex);
			}
		} else if (request.getParameter("remove") != null) {
			//User clicked the 'Remove' button.
			if (request.getParameter("selected") != null) {
				int fileID = Integer.parseInt(request.getParameter("selected"));
				try {
					fileIO.delete(new ClaimFile(fileID,claim.getClaimID()));
				} catch (SQLException ex) {
					request.setAttribute("error", "There was an error while trying to remove this file, please advise the Site Administrator.");
					Logger.getLogger(AttachEvidenceServlet.class.getName()).log(Level.SEVERE, null, ex);
				}
			} else {
				request.setAttribute("error", "Not a valid file was selected, please use the radio buttons to select a file.");
			}
		}

		session.setAttribute("claim", claim);
		session.setAttribute("claimFiles", claimFiles);

		RequestDispatcher dispatcher = request.getRequestDispatcher(url);
		dispatcher.forward(request, response);
	}

	// <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
	/**Handles the HTTP <code>GET</code> method.
	 * @param request  servlet request
	 * @param response servlet response
	 * @throws ServletException if a servlet-specific error occurs
	 * @throws IOException      if an I/O error occurs
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		processRequest(request, response);
	}

	/**Handles the HTTP <code>POST</code> method.
	 * @param request  servlet request
	 * @param response servlet response
	 * @throws ServletException if a servlet-specific error occurs
	 * @throws IOException      if an I/O error occurs
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)	throws ServletException, IOException {
		processRequest(request, response);
	}

	/**Returns a short description of the servlet.
	 * @return a String containing servlet description
	 */
	@Override
	public String getServletInfo() {
		return "Attach Evidencet to an existing Claim";
	}// </editor-fold>
}
