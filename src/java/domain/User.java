package domain;

import data.UserIO;
import java.util.ArrayList;
import java.util.regex.Pattern;

/**	@author     Adam Shortall, Todd Wiggins
 *  @version    1.2
 *	Created:    ?
 *	Modified:   10/04/2013
 *	Change Log: 1.1: TW: Updated to match current version of database.
 *				1.2: TW: Corrected data type for postcode to match database. Updated constructors for all elements/db columns.
 *	Purpose:    Represents a user of the system. A user can have one
 *				of four roles, and has a unique username, an encrypted
 *				password, firstName, lastName and email address. Students
 *				also have otherName, address1, address2, town, state,
 *				postcode, phone, studentID and staff fields.
 */
public class User implements Comparable<User> {
    private ArrayList<Claim> claims;
    private String userID;
    private String firstName;
    private String lastName;
	private String otherName;
	private String address1;
	private String address2;
	private String town;
	private String state;
	private int postCode;
	private String phone;
    private String email;
    private String studentID;
	private boolean staff;
    private String password;
    private Status status;

    public final Role role;

    public User() {
        this(Role.STUDENT);
    }

    public User(Role role) {
        this("","","","",role);
    }

    public User(String userID, Role role) {
        this(userID, "", "", "", role);
    }

    /**
     * Constructor for a user without a specified password.
     */
    public User(
            String userID,
            String firstName,
            String lastName,
            String email,
            Role role) {
        this(userID, firstName, lastName, email, role, "");
    }

    public User(
            String userID,
            String firstName,
            String lastName,
            String email,
            Role role,
            String password) {
        this(userID, firstName, lastName, email, role, password, false);
    }

    /**
     * Old Constructor for a user loaded form the database.
     */
    public User(
            String userID,
            String firstName,
            String lastName,
            String email,
            Role role,
            String password,
            boolean courseCoordinator) {
        this(userID, firstName, lastName, "", "", "", "", "", 0, "", email, "", courseCoordinator, role, password);
    }

    /**
     * Constructor for a user loaded form the database.
     */
    public User(
            String userID,
            String firstName,
            String lastName,
			String otherName,
			String address1,
			String address2,
			String town,
			String state,
			int postCode,
			String phone,
			String email,
			String studentID,
			boolean staff,
            Role role,
			String password) {
        this.userID = userID;
        this.firstName = firstName;
        this.lastName = lastName;
		this.otherName = otherName;
		this.address1 = address1;
		this.address2 = address2;
		this.town = town;
		this.state = state;
		this.postCode = postCode;
		this.phone = phone;
        this.email = email;
		this.studentID = studentID;
		this.staff = staff;
		this.password = password;
        this.role = role;
        this.status = Status.NOT_LOGGED_IN;
    }

    /**
     * Specifies a field to validate.
     */
    public enum Field {
        USER_ID,
        EMAIL,
        PASSWORD,
        FIRST_NAME,
        LAST_NAME;
    }

    /**
     * The role of a user is defined here.
     * The char is used in the database.
     */
    public enum Role {
        ADMIN(
                UserIO.ADMIN_CODE,
                "^\\w+(\\.\\w+)+@tafe\\.nsw\\.edu\\.au$",
                "^(?=.*[a-zA-Z])(?=.*[0-9])[a-zA-Z0-9]{8,16}$",
                "^\\w+(\\.\\w+)+@tafe\\.nsw\\.edu\\.au$"),
        CLERICAL(
                UserIO.CLERICAL_CODE,
                "^\\w+(\\.\\w+)+@tafe\\.nsw\\.edu\\.au$",
                "^(?=.*[a-zA-Z])(?=.*[0-9])[a-zA-Z0-9]{8,16}$",
                "^\\w+(\\.\\w+)+@tafe\\.nsw\\.edu\\.au$"),
        STUDENT(
                UserIO.STUDENT_CODE,
                "^\\w+(\\.\\w+)+@tafensw\\.net\\.au$",
                "^(?=.*[a-zA-Z])(?=.*[0-9])[a-zA-Z0-9]{8,16}$",
                "^[0-9]{9}$"),
        TEACHER(
                UserIO.TEACHER_CODE,
                "^\\w+(\\.\\w+)+@tafe\\.nsw\\.edu\\.au$",
                "^(?=.*[a-zA-Z])(?=.*[0-9])[a-zA-Z0-9]{8,16}$",
                "^\\w+(\\.\\w+)+@tafe\\.nsw\\.edu\\.au$");

        public final char code;
        public final String emailPattern;
        public final String passwordPattern;
        public final String userIDPattern;
        public final String namePattern;

        Role(char code, String emailPattern, String passwordPattern, String userIDPattern) {
            this.code = code;
            this.emailPattern = emailPattern;
            this.passwordPattern = passwordPattern;
            this.userIDPattern = userIDPattern;
            this.namePattern = "^[a-zA-Z]+$";
        }

        public static Role roleFromChar(char c) {
            switch (c) {
                case UserIO.ADMIN_CODE:
                    return ADMIN;
                case UserIO.CLERICAL_CODE:
                    return CLERICAL;
                case UserIO.STUDENT_CODE:
                    return STUDENT;
                case UserIO.TEACHER_CODE:
                    return TEACHER;
                default:
                    throw new IllegalArgumentException("Invalid character to represent user role");
            }
        }
    }

    /**
     * Defines the status of the user within the website, e.g.
     * whether they are logged in or not.
     */
    public enum Status {
        LOGGED_IN,
        NOT_LOGGED_IN;
    }
    /**
     * Validates a specified field of a user by checking it against a pattern.
     * @param user the user with fields to be validated
     * @param field the field to validate
     * @return true if the field is valid
     */
    public boolean validateField(Field field) {
        switch(field) {
            case USER_ID:
                return Pattern.matches(this.role.userIDPattern, this.userID);
            case EMAIL:
                return Pattern.matches(this.role.emailPattern, this.email);
            case PASSWORD:
                return Pattern.matches(this.role.passwordPattern, this.password);
            case FIRST_NAME:
                return Pattern.matches(this.role.namePattern, this.firstName);
            case LAST_NAME:
                return Pattern.matches(this.role.namePattern, this.lastName);
            default:
                throw new IllegalArgumentException("Invalid field");
        }
    }

    public void logIn() {
        this.status = Status.LOGGED_IN;
    }

    /**
     *
     * @return claims for a User
     */
    public ArrayList<Claim> getClaims() {
        return claims;
    }

    /**
     *
     * @param claims
     */
    public void setClaims(ArrayList<Claim> claims) {
        this.claims = claims;
    }

    /**
     * @return the userID
     */
    public String getUserID() {
        return userID;
    }

    /**
     * @param userID the userID to set
     */
    public void setUserID(String userID) {
        this.userID = userID;
    }

    /**
     * @return the firstName
     */
    public String getFirstName() {
        return firstName;
    }

    /**
     * @param firstName the firstName to set
     */
    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    /**
     * @return the lastName
     */
    public String getLastName() {
        return lastName;
    }

    /**
     * @param lastName the lastName to set
     */
    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    /**
     * @return the emailAddress
     */
    public String getEmail() {
        return email;
    }

    /**
     * @param emailAddress the emailAddress to set
     */
    public void setEmail(String email) {
        this.email = email;
    }

    /**
     * @return the password
     */
    public String getPassword() {
        return password;
    }

    /**
     * @param password the password to set
     */
    public void setPassword(String password) {
        this.password = password;
    }

	/**
	 * @param otherName the otherName for the user (eg. middle)
	 */
	public void setOtherName(String otherName) {
		this.otherName = otherName;
	}

	/**
	 * @return otherName the otherName for the user (eg. middle)
	 */
	public String getOtherName() {
		return this.otherName;
	}

	/**
	 * @param line1 Address Line 1, eg. Unit 1 with a line 2 or 123 Fake Street
	 * @param line2 Address Line 2, eg. ...(line1) + 123 Fake Street
	 */
	public void setAddress(String line1, String line2) {
		this.address1 = line1;
		this.address2 = line2;
	}

	/**
	 * @return String[], index 0 address line 1, index 1 address line 2
	 */
	public String[] getAddress() {
		return new String[] {this.address1, this.address2};
	}

	/**
	 * @param town the users address field for town
	 */
	public void setTown(String town) {
		this.town = town;
	}

	/**
	 * @return town the users address field for town
	 */
	public String getTown() {
		return this.town;
	}

	/**
	 * @param state the users address field for state
	 */
	public void setState(String state) {
		this.state = state;
	}

	/**
	 * @return state the users address field for state
	 */
	public String getState() {
		return this.state;
	}

	/**
	 * @param postCode the users address field for postCode
	 */
	public void setPostCode(int postCode) {
		this.postCode = postCode;
	}

	/**
	 * @return postCode the users address field for postCode
	 */
	public int getPostCode() {
		return this.postCode;
	}

	/**
	 * @param phone the phone number for the user
	 */
	public void setPhoneNumber(String phone) {
		this.phone = phone;
	}

	/**
	 * @return the phone number for the user
	 */
	public String getPhoneNumber() {
		return this.phone;
	}

	/**
	 * @param studentID the student id for this user
	 */
	public void setStudentID(String studentID) {
		this.studentID = studentID;
	}

	/**
	 * @return the student id for this user
	 */
	public String getStudentID() {
		return this.studentID;
	}

	/**
	 * @param staff is this user a staff member (only applicable for students)
	 */
	public void setStaff(boolean staff) {
		this.staff = staff;
	}

	/**
	 * @return staff is this user a staff member (only applicable for students)
	 */
	public boolean isStaff() {
		return this.staff;
	}

    /**
     * @return the role
     */
    public Role getRole() {
        return role;
    }

    /**
     * Returns the status
     * @return the status
     */
    public Status getStatus() {
        return this.status;
    }

    /**
     * Sets the status
     * @param status the status to set
     */
    public void setStatus(Status status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return this.userID;
    }

    @Override
    public int compareTo(User that) {
        return this.userID.compareTo(that.userID);
    }
}
