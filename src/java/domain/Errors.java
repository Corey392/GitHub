/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package domain;

/**
 *
 * @author Kyoungho Lee
 */
public class Errors {    
    
    //Instance fields
    private String errorID;
    private String errorMessage;
    private boolean enabled;

    public Errors() {}

    public Errors(String errorID, String errorMessage, boolean enabled) {
        this.errorID = errorID;
        this.errorMessage = errorMessage;
        this.enabled = enabled;
    }

    public boolean isEnabled() {
        return enabled;
    }

    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }

    public String getErrorID() {
        return errorID;
    }

    public void setErrorID(String errorID) {
        this.errorID = errorID;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }
    
    
}
