package data;

import java.sql.Types;

/**
 * Used as a parameter for prepared or callable statements.
 * 
 * @author Adam Shortall
 */
public class SQLParameter {
    /** Name of the parameter in the database's function. */
    public final String name;
    /** The parameter's value. */
    public final Object value;
    /** The type of data, e.g. DATE, VARCHAR etc. Automatically set 
     by checking instanceof value. */
    public final int type;
    
    /** 
     * Constructs a SQLParameter with a value. Name is ignored, 
     * type is set automatically. Use this for databases that do
     * not allow for specifying a parameter name in JDBC.
     * 
     * @param value the value of the parameter, could be a String, Date etc.
     */
    public SQLParameter(Object value) {
        this("", value);
    }
    
    /**
     * Constructs a SQLParameter with a name and value. Type is 
     * set automatically. Use this when the database does allow
     * for named parameters through JDBC, rather than just positional.
     * 
     * @param name name of the parameter.
     * @param value the value of the parameter, could be a String, Date etc.
     * @throws IllegalArgumentException if value is not of a supported type
     */
    public SQLParameter(String name, Object value) {        
        this.name = name;
        this.value = value;
        if (value == null) {
            type = Types.NULL;
        } else if (value instanceof java.sql.Date) {
            type = Types.DATE;
        } else if (value instanceof String) {
            type = Types.VARCHAR;
        } else if (value instanceof Integer) {
            type = Types.INTEGER;
        } else if (value instanceof byte[]) {
            type = Types.BINARY;
        } else if (value instanceof Character) {
            type = Types.CHAR;
        } else if (value instanceof Boolean) {
            type = Types.BOOLEAN;
        } else {
            throw new IllegalArgumentException("Invalid type for SQLParameter.");
        }
    }
}