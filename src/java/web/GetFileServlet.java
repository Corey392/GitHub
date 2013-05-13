package web;

import data.FileIO;
import domain.Claim;
import domain.ClaimFile;
import domain.User;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/** Purpose:    Gets the file requested from system.
 *  @author     Todd Wiggins
 *  @version    1.000
 *	Created:    14/05/2013
 *	Change Log:
 */
public class GetFileServlet extends HttpServlet {
	private static final int BUFFER_SIZE = 4096;

	/**
	 * Handles the HTTP <code>GET</code> method.
	 * @param request  servlet request
	 * @param response servlet response
	 * @throws ServletException if a servlet-specific error occurs
	 * @throws IOException      if an I/O error occurs
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		if (request.getParameter("id") != null) {
			//Get session User & Claim.
			HttpSession session = request.getSession();
			User user = (User) session.getAttribute("user");
			Claim claim = (Claim) session.getAttribute("claim");

			ClaimFile claimFile;

			try {
				claimFile = new FileIO(user.role).getFileByID(Integer.parseInt(request.getParameter("id")));
			} catch (SQLException ex) {
				Logger.getLogger(GetFileServlet.class.getName()).log(Level.SEVERE, null, ex);
				claimFile = null;
			}

			if (claimFile != null) {
				File file = new File(ClaimFile.directoryClaims + claimFile.getClaimID() + "/" + claimFile.getFilename());

				//UP TO HERE
				int length = 0;
				ServletOutputStream outStream = response.getOutputStream();
				ServletContext context  = getServletConfig().getServletContext();
				String mimetype = context.getMimeType(file.getAbsolutePath());

				if (mimetype == null) {
					mimetype = "application/octet-stream";
				}
				response.setContentType(mimetype);
				response.setContentLength((int)file.length());
				String fileName = file.getName();

				// sets HTTP header
				response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

				byte[] byteBuffer = new byte[BUFFER_SIZE];
				DataInputStream in = new DataInputStream(new FileInputStream(file));

				// reads the file's bytes and writes them to the response stream
				while ((length = in.read(byteBuffer)) != -1) {
					outStream.write(byteBuffer,0,length);
				}
				in.close();
				outStream.close();
			}
		}
	}

	/**
	 * Returns a short description of the servlet.
	 * @return a String containing servlet description
	 */
	@Override
	public String getServletInfo() {
		return "Gets the file request from the system.";
	}// </editor-fold>
}
