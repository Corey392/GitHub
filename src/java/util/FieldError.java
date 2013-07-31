package util;

/**
 * @author Adam Shortall, Bryce Carr, Todd Wiggins
 * @version: 1.006
 * Modified:    08/04/2013: Bryce Carr: Added message: COURSE_GUIDE_FILE_ADDRESS.
 *              11/04/2013: Todd Wiggins: Added messages: TERMS_AND_COND, RESET_FAILED, RESET_SENT.
 *              24/04/2013: Bryce Carr: Added header comments to match code conventions.
 *				25/04/2013: Todd Wiggins: Added 4 x 'NOT_SELECTED' error messages.
 *				06/05/2013: Todd Wiggins: Added CLAIM_DELETE_NOT_DRAFT error.
 *				15/05/2013: Todd Wiggins: Added CLAIM_DELETE_NOT_SELECTED error.
 * <b>Purpose:</b>  Defines error messages for different input fields on pages in the
 * RPL website. These messages are displayed to the user next to the fields that
 * they are associated with.
 */
public enum FieldError {
    NONE(""),
    NAME("Name should only contain letters, no spaces or special characters"),
    PASSWORD_CONFIRM("Passwords didn't match"),
    STUDENT_ID("Student number must be 9 digits"),
    STUDENT_UNIQUE("This student number and/or email address is already registered"),
    PASSWORD_COMPLEXITY("Password must contain at least one letter, one number, and be 8-16 characters long"),
    STUDENT_EMAIL("You must use your TAFE email address, e.g. Your.Name@tafensw.net.au"),
	TERMS_AND_COND("You must agree to the Terms & Conditions, and Privacy Policy to use the RPL Assist service."),//Added by: Todd Wiggins
    CAMPUS_ID("Campus ID can only be 3 integers (e.g. '803')"),
    CAMPUS_NAME("Campus name should not contain any special characters"),
    CAMPUS_UNIQUE("Campus ID must be unique"),
    DISCIPLINE_NAME("Invalid discipline name"),
    COURSE_ID("Course ID must be 5 digits only"),
    COURSE_NAME("Invalid course name"),
    COURSE_GUIDE_FILE_ADDRESS("Invalid guide file address for course"),
    COURSE_UNIQUE("Course ID must be unique"),
    MODULE_UNIQUE("Module ID must be unique"),
    MODULE_ID("Module ID must be 9-10 characters long"),
    TEACHER_ID("Teacher ID/email  must follow the pattern: First.Last@tafe.nsw.edu.au"),
    TEACHER_UNIQUE("This teacher ID is already in the system, account has not been created."),
	RESET_FAILED("The Student Number or Email address you provided was unable to be found. Please verify your details and try again."),//Added by: Todd Wiggins
	RESET_SENT("Your new password has been sent to your TAFE email address on record."),//Added by: Todd Wiggins
	PASSWORD_INCORRECT("The password you supplied was incorrect, remember your Password must contain at least one letter, one number, and be 8-16 characters long."),//Added by: Todd Wiggins
	SUCCESSFUL_UPDATE("Your details have been successfully updated."),//Added by: Todd Wiggins
	CAMPUS_NOT_SELECTED("A campus was not selected, please select a Campus from the list."),//Added by: Todd Wiggins
	DISCIPLINE_NOT_SELECTED("A discipline was not selected, please select a Discipline from the list."),//Added by: Todd Wiggins
	COURSE_NOT_SELECTED("A course was not selected, please select a Course from the list."),//Added by: Todd Wiggins
	CLAIM_TYPE_NOT_SELECTED("A claim type was not selected, please select a Claim Type from the list."),//Added by: Todd Wiggins
	CLAIM_DELETE_NOT_DRAFT("The claim you selected cannot be deleted, only claims in a 'Draft' status can be deleted."),//Added by: Todd Wiggins
	CLAIM_DELETE_NOT_SELECTED("Please select a claim before trying to delete.");//Added by: Todd Wiggins

    public String message;

    FieldError(String message) {
        this.message = message;
    }

    @Override
    public String toString() {
        return this.message;
    }
}
