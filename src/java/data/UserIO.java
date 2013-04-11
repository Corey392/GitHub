package data;

import domain.Campus;
import domain.Course;
import domain.Discipline;
import domain.User;
import domain.User.Role;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**	@author     Adam Shortall, Todd Wiggins
 *  @version    1.2
 *	Created:    ?
 *	Modified:   09/04/2013
 *	Change Log: 1.1: TW: Updated to match current version of database.
 *				1.2: TW: Corrected data type for postcode.
 *	Purpose:    UserIO is for IO of all user types. Whatever subclass of user the user is, the student level connection will be used to connect to the database.
 */
public class UserIO extends RPL_IO<User> {
    public static final char ADMIN_CODE = 'A';
    public static final char CLERICAL_CODE = 'C';
    public static final char STUDENT_CODE = 'S';
    public static final char TEACHER_CODE = 'T';

    public enum Field {
        USER_ID("userID"),
        ROLE("role"),
        PASSWORD("password"),
        FIRST_NAME("firstName"),
        LAST_NAME("lastName"),
        EMAIL("email"),
        STUDENT_ID("studentID"),
        TEACHER_ID("teacherID"),
        COURSE_COORDINATOR("courseCoordinator");

        public final String name;

        Field(String name) {
            this.name = name;
        }
    }

    /**
     * Constructs a UserIO with a database connection that has
     * Student level privileges.
     */
    public UserIO(Role role) {
        super(role);
    }

    /**
     * Inserts the user into the database.
     *
     * @param user the user to insert
     */
    public void insert(User user) throws SQLException{
        String userID = user.getUserID();
        String email = user.getEmail();
        String firstName = user.getFirstName();
        String lastName = user.getLastName();
        String sql = null;
        SQLParameter p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13;
        ResultSet rs;
        switch (user.role) {
            case CLERICAL:
                sql = "SELECT fn_InsertClerical(?)";
                p1 = new SQLParameter(userID);
                rs = super.doPreparedStatement(sql, p1);
                if (rs.next()) {
                    user.setPassword(rs.getString(1)); // Randomly generated password
                }
                break;
            case STUDENT:
				//Student Values Only
				String otherName = user.getOtherName();
				String addressLine1 = user.getAddress()[0];
				String addressLine2 = user.getAddress()[1];
				String town = user.getTown();
				String state = user.getState();
				int postcode = user.getPostCode();
				String phoneNumber = user.getPhoneNumber();
				String studentID = user.getStudentID();
				boolean staff = user.isStaff();

                sql = "SELECT fn_InsertStudent(?,?,?,?,?,?,?,?,?,?,?,?,?)";
                p1 = new SQLParameter(userID);
                p2 = new SQLParameter(email);
                p3 = new SQLParameter(firstName);
                p4 = new SQLParameter(lastName);
				p5 = new SQLParameter(otherName);
				p6 = new SQLParameter(addressLine1);
				p7 = new SQLParameter(addressLine2);
				p8 = new SQLParameter(town);
                p9 = new SQLParameter(state);
                p10 = new SQLParameter(postcode);
				p11 = new SQLParameter(phoneNumber);
				p12 = new SQLParameter(studentID);
				p13 = new SQLParameter(staff);
                super.doPreparedStatement(sql, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13);
				//Returns a generated password
                break;
            case ADMIN: // same as TEACHER
            case TEACHER:
                sql = "SELECT fn_InsertTeacher(?,?,?,?,?)";
				p1 = new SQLParameter(userID);
                p2 = new SQLParameter(userID);
                p3 = new SQLParameter(firstName);
                p4 = new SQLParameter(lastName);
                p5 = new SQLParameter(email);
                rs = super.doPreparedStatement(sql, p1, p2, p3, p4, p5);
                if (rs.next()) {
                    user.setPassword(rs.getString(1)); // Randomly generated password
                }
                break;
            default:
                throw new IllegalArgumentException("Invalid role for user");
        }
    }

    /**
     * Updates an existing user. Since a user's ID can be changed, the updated ID is expected
     * to be in the user parameter, while the previous ID is provided in the oldID parameter.
     * @param user The user with updated data.
     * @param oldID The previous userID of the user (may be the same as the user object's userID)
     * @throws SQLException if the updated ID or email address is not unique
     */
    public void update(User user, String oldID) throws SQLException {
        String userID = user.getUserID();
        String firstName = user.getFirstName();
        String lastName = user.getLastName();
        String email = user.getEmail();
        String password = user.getPassword();
        String sql = null;
        SQLParameter p1, p2, p3, p4, p5, p6;
        MessageDigest md = null;
        try {
            md = MessageDigest.getInstance("MD5");
        } catch (NoSuchAlgorithmException ex) {
            Logger.getLogger(UserIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        switch (user.role) {
            case ADMIN:
                sql = "SELECT fn_UpdateUser(?,?,?)";
                p1 = new SQLParameter(oldID);
                p2 = new SQLParameter(userID);
                p3 = new SQLParameter(password);
                super.doPreparedStatement(sql, p1, p2, p3);
                break;
            case STUDENT:
                sql = "SELECT fn_UpdateStudent(?,?,?,?,?,?)";
                p1 = new SQLParameter(oldID);
                p2 = new SQLParameter(userID);
                p3 = new SQLParameter(firstName);
                p4 = new SQLParameter(lastName);
                p5 = new SQLParameter(email);
                p6 = new SQLParameter(password);
                super.doPreparedStatement(sql, p1, p2, p3, p4, p5, p6);
                break;
            case TEACHER:
                sql = "SELECT fn_UpdateTeacher(?,?,?,?,?,?)";
                p1 = new SQLParameter(oldID);
                p2 = new SQLParameter(userID);
                p3 = new SQLParameter(firstName);
                p4 = new SQLParameter(lastName);
                p5 = new SQLParameter(email);
                p6 = new SQLParameter(password);
                super.doPreparedStatement(sql, p1, p2, p3, p4, p5, p6);
                break;
            default:
                throw new IllegalArgumentException("Invalid role for user");
        }
    }

    /**
     * Deletes a user, and every record that depended on that user record.
     * @param user The user to delete.
     * @throws SQLException
     */
    public void delete(User user) throws SQLException {
        String sql = null;
        String userID = user.getUserID();
        SQLParameter p1 = new SQLParameter(userID);
        switch (user.role) {
            case ADMIN:
                sql = "SELECT fn_DeleteUser(?)";
                break;
            case STUDENT:
                sql = "SELECT fn_DeleteStudent(?)";
                break;
            case TEACHER:
                sql = "SELECT fn_DeleteTeacher(?)";
                break;
            default:
                throw new IllegalArgumentException("Invalid role for user");
        }
        super.doPreparedStatement(sql, p1);
    }

    /**
     * Verifies whether a user, with the current username and password
     * set, matches a user in the database. If a match is found, the
     * user's role is returned, otherwise null is returned.
     *
     * @param user the user to verify
     * @return the verified user's Role, else null
     */
    public Role verifyLogin(User user) {
        String userID = user.getUserID();
        String password = user.getPassword();
        String sql = "SELECT fn_VerifyLogin(?,?)";
        SQLParameter p1, p2;
        p1 = new SQLParameter(userID);
        p2 = new SQLParameter(password);
        try {

            ResultSet rs = super.doPreparedStatement(sql, p1, p2);
            if(rs.next()) {
                String codeString = rs.getString(1);
                if (codeString == null) { return null; }
                char code = codeString.charAt(0);
                switch (code) {
                    case ADMIN_CODE:
                        return Role.ADMIN;
                    case CLERICAL_CODE:
                        return Role.CLERICAL;
                    case STUDENT_CODE:
                        return Role.STUDENT;
                    case TEACHER_CODE:
                        return Role.TEACHER;
                    default:
                        throw new SQLException("Incorrect value for role in database from fn_VerifyLogin");
                }
            }
        } catch (SQLException e) {
            System.err.println("UserIO.verifyLogin " + e.getMessage());
        }
        return null;
    }

    /**
     * @return a list of clerical and teacher/admin users.
     */
    public ArrayList<User> getListOfTeacherAndAdminUsers() {
        ResultSet rs;
        try {
            String sql = "SELECT * FROM fn_ListTeacherAndAdminUsers()";
            rs = super.doQuery(sql);
            return this.getListFromResultSet(rs);
        } catch (SQLException ex) {
            Logger.getLogger(UserIO.class.getName()).log(Level.SEVERE, null, ex);
            return new ArrayList<User>();
        }
    }

    /**
     * Gets a user by ID, by calling the appropriate function in the DB
     * and returning the user object. The user parameter should contain
     * the user's ID and role.
     *
     * @param user the user object with an ID to try to match in the DB,
     * and with a defined role.
     * @return the user object, updated with data from the DB.
     */
    public User getByID(String userID) {
        switch (role) {
            case CLERICAL:
                return new User(userID, role);
            case STUDENT:
                return this.getStudent(userID);
            case ADMIN:
            case TEACHER:
                return this.getTeacher(userID);
            default:
                throw new IllegalArgumentException("Invalid role for user in User.getByID(User)");
        }
    }

    /**
     * Returns a list of delegates for a specified discipline.
     * @param campus
     * @param discipline
     * @return
     */
    public ArrayList<User> getListOfDelegates(Campus campus, Discipline discipline) {
        ArrayList<User> list = null;
        String campusID = campus.getCampusID();
        int disciplineID = discipline.getDisciplineID();
        String sql = "SELECT * FROM fn_ListDelegates(?,?)";
        SQLParameter p1 = new SQLParameter(campusID);
        SQLParameter p2 = new SQLParameter(disciplineID);
        try {
            ResultSet rs = super.doPreparedStatement(sql, p1, p2);
            list = new ArrayList<User>();
            String teacherID, email, firstName, lastName;
            while (rs.next()) {
                teacherID = rs.getString(Field.TEACHER_ID.name);
                email = rs.getString(Field.EMAIL.name);
                firstName = rs.getString(Field.FIRST_NAME.name);
                lastName = rs.getString(Field.LAST_NAME.name);
                list.add(new User(teacherID, firstName, lastName, email, Role.TEACHER));
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    /**
     * Returns a list of assessors for a specified course.
     * @param campus
     * @param discipline
     * @param course
     * @return
     */
    public ArrayList<User> getListOfAssessors(Campus campus, Discipline discipline, Course course) {
        ArrayList<User> list = null;
        String campusID = campus.getCampusID();
        int disciplineID = discipline.getDisciplineID();
        String courseID = course.getCourseID();
        String sql = "SELECT * FROM fn_ListAssessors(?,?,?)";
        SQLParameter p1 = new SQLParameter(campusID);
        SQLParameter p2 = new SQLParameter(disciplineID);
        SQLParameter p3 = new SQLParameter(courseID);
        try {
            ResultSet rs = super.doPreparedStatement(sql, p1, p2, p3);
            list = new ArrayList<User>();
            String teacherID, email, firstName, lastName;
            boolean courseCoordinator;
            while (rs.next()) {
                teacherID = rs.getString(Field.TEACHER_ID.name);
                email = rs.getString(Field.EMAIL.name);
                firstName = rs.getString(Field.FIRST_NAME.name);
                lastName = rs.getString(Field.LAST_NAME.name);
                courseCoordinator = rs.getBoolean(Field.COURSE_COORDINATOR.name);
                list.add(new User(teacherID, firstName, lastName, email, Role.TEACHER, "", courseCoordinator));
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    /**
     * Returns a student user from the database.
     * @param userID
     * @return
     */
    private User getStudent(String userID) {
        return new User(userID, Role.STUDENT);
        /*String sql = "SELECT * FROM fn_GetStudentUser(?)";
        SQLParameter p1 = new SQLParameter(userID);
        try {
            ResultSet rs = super.doPreparedStatement(sql, p1);
            if (rs.next()) {
                String firstName = rs.getString(Field.FIRST_NAME.name);
                String lastName = rs.getString(Field.LAST_NAME.name);
                String email = rs.getString(Field.EMAIL.name);
                return new User(userID, firstName, lastName, email, Role.STUDENT);
            }
            return null;
        } catch (SQLException ex) {
            Logger.getLogger(UserIO.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }*/
    }

    /**
     * Kyoungho Lee
     */
    public User getStudentInfo(String userID) {
        String sql = "SELECT * FROM fn_GetStudentUser(?)";
        SQLParameter p1 = new SQLParameter(userID);
        try {
            ResultSet rs = super.doPreparedStatement(sql, p1);
            if (rs.next()) {
                String firstName = rs.getString(Field.FIRST_NAME.name);
                String lastName = rs.getString(Field.LAST_NAME.name);
                String email = rs.getString(Field.EMAIL.name);
                return new User(userID, firstName, lastName, email, Role.STUDENT);
            }
            return null;
        } catch (SQLException ex) {
            Logger.getLogger(UserIO.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }

    /**
     * Returns a teacher user from the database; note that the
     * teacher may be an admin user.
     * @param userID
     * @return
     */
    private User getTeacher(String userID) {
        String sql = "SELECT * FROM fn_GetTeacherUser(?)";
        SQLParameter p1 = new SQLParameter(userID);
        try {
            ResultSet rs = super.doPreparedStatement(sql, p1);
            if (rs.next()) {
                String firstName = rs.getString(Field.FIRST_NAME.name);
                String lastName = rs.getString(Field.LAST_NAME.name);
                String email = rs.getString(Field.EMAIL.name);
                String codeString = rs.getString(Field.ROLE.name);
                char code = codeString.charAt(0);
                Role role = Role.roleFromChar(code);
                return new User(userID, firstName, lastName, email, role);
            }
            return null;
        } catch (SQLException ex) {
            Logger.getLogger(UserIO.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }

    /**
     * Kyoungho Lee
     */
    public User getTeacherInfo(String userID) {
        String sql = "SELECT * FROM fn_GetTeacherUser(?)";
        SQLParameter p1 = new SQLParameter(userID);
        try {
            ResultSet rs = super.doPreparedStatement(sql, p1);
            if (rs.next()) {
                String firstName = rs.getString(Field.FIRST_NAME.name);
                String lastName = rs.getString(Field.LAST_NAME.name);
                String email = rs.getString(Field.EMAIL.name);
                String codeString = rs.getString(Field.ROLE.name);
                char code = codeString.charAt(0);
                Role role = Role.roleFromChar(code);
                return new User(userID, firstName, lastName, email, role);
            }
            return null;
        } catch (SQLException ex) {
            Logger.getLogger(UserIO.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }

    /**
     * Creates a list of users from a ResultSet.
     * @param rs set of user records from the database.
     * @return a list of users from a ResultSet.
     */
    private ArrayList<User> getListFromResultSet(ResultSet rs) {
        ArrayList<User> list = new ArrayList<User>();
        try {
            while (rs.next()) {
                String id = rs.getString(Field.USER_ID.name);
                String codeString = rs.getString(Field.ROLE.name);

                char code = codeString.charAt(0);
                Role role = Role.roleFromChar(code);
                list.add(new User(id, role));
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    /**
     * Resets a user's password to a new randomly generated password.
     * @param userID identifies the user.
     * @return the password that was generated.
     */
    public String resetPassword(String userID) {
        String sql = "SELECT fn_ResetPassword(?)";
        try {
            ResultSet rs = super.doPreparedStatement(sql, p(userID));
            rs.next();
            return rs.getString(1);
        } catch (SQLException ex) {
            Logger.getLogger(UserIO.class.getName()).log(Level.SEVERE, "resetPassword()", ex);
            return null;
        }
    }

	/**Validates a users ID or email address if they already exist in the database.
	 * @param userIdOrEmail A String being either the users ID (eg. studentID) or email address allowing the use for teachers/admin/assessors.
	 * @return A String containing the users email address if they exist or an empty string "" if they were not found.
	 */
	public String validateUserIdOrEmail(String userIdOrEmail) {
		String sql = "SELECT fn_doesUserExist(?)";
		try {
			ResultSet rs = super.doPreparedStatement(sql, p(userIdOrEmail));
			rs.next();
			return rs.getString(1);
		} catch (SQLException ex) {
            Logger.getLogger(UserIO.class.getName()).log(Level.SEVERE, "validateUserIdOrEmail()", ex);
            return "";
		}
	}
}
