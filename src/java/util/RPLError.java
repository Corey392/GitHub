package util;

/**
 * @author Adam Shortall
 */
public final class RPLError {
    
    public final FieldError fieldError; //Explicit error object holding more info
    public final String message; //String detailing the nature of this error
    
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
    
    /**
     * @return Error message detailing the nature of this error
     */
    public String getMessage() {
        return this.message;
    }
        
    @Override
    public String toString() {
        return this.message;
    }
}