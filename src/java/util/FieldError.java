/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package util;

/**
 * Defines error messages for different input fields on pages in the
 * RPL website. These messages are displayed to the user next to the
 * fields that they are associated with.
 * @author Adam Shortall
 */
public enum FieldError {
    NONE(""),
    NAME("Name should only contain letters, no spaces or special characters"),
    PASSWORD_CONFIRM("Passwords didn't match"),
    STUDENT_ID("Student number must be 9 digits"),
    STUDENT_UNIQUE("This student number and/or email address is already registered"),
    PASSWORD_COMPLEXITY("Password must contain at least one letter and one number, and be 8-16 characters long"),
    STUDENT_EMAIL("You must use your TAFE email address, e.g. Your.Name@tafensw.net.au"),
	TERMS_AND_COND("You must agree to the Terms & Conditions, and Privacy Policy to use the RPL Assist service."),
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
    TEACHER_UNIQUE("This teacher ID is already in the system, account has not been created.");

    public String message;

    FieldError(String message) {
        this.message = message;
    }

    @Override
    public String toString() {
        return this.message;
    }
}
