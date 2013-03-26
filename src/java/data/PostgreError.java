/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package data;

/**
 * Error codes that can be generated by PostgreSQL for
 * SQLException.getSQLState(). These codes are the ones
 * that the application will need to respond to.
 * 
 * @author Adam Shortall
 */
public enum PostgreError {
    INTEGRITY_CONSTRAINT_VIOLATION("23000"),
    NOT_NULL_VIOLATION("23502"),
    FOREIGN_KEY_VIOLATION("23503"),
    UNIQUE_VIOLATION("23505"),
    CHECK_VIOLATION("23514"),
    INSUFFICIENT_PRIVILEGE("42501");
    
    public final String code;
    
    PostgreError(String code) {
        this.code = code;
    }
    
    @Override
    public String toString() {
        return code;
    }
}
