/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package util;

/**
 *
 * @author Adam Shortall
 */
public final class RPLError {
    
    public final FieldError fieldError;
    public final String message;
    
    public RPLError() {
        this(FieldError.NONE);
    }
    
    public RPLError(FieldError error) {
        this.fieldError = error;
        message = error.message;
    }
    
    public RPLError(String message) {
        this.fieldError = FieldError.NONE;
        this.message = message;
    }
    
    public String getMessage() {
        return this.message;
    }
        
    @Override
    public String toString() {
        return this.message;
    }
}