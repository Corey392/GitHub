package data;

import domain.Element;
import domain.User.Role;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * <b>Purpose:</b>  Controller class for interaction with database's Element table.
 * @author James, Adam Shortall, Bryce Carr, Todd Wiggins
 * @version 1.03
 * <b>Created:</b>  Unknown<br/>
 * <b>Modified:</b> 29/04/2013<br/>
 * <b>Change Log:</b>  08/04/2013:  Bryce Carr: Added code to incorporate moduleID DB field.<br/>
 *                  24/04/2013: Bryce Carr  Added header comments to match code conventions.<br/>
 *                  29/04/2013: TW: Added check if data was returned from DB in 'getId' before trying to use the data.<br/>
 */
public class ElementIO extends RPL_IO <Element> {

    public enum Field {
        ELEMENT_ID("elementID"),
        MODULE_ID("moduleID"),
        DESCRIPTION("description");

        public final String name;

        Field(String name) {
            this.name = name;
        }
    }

    public ElementIO(Role role) {
        super(role);
    }

    /**
     * Inserts or Updates an Element object depending on the function parameter.
     * @param element the element object to save
     * @param function whether to insert or update
     * @throws SQLException if Element already existed in DB or otherwise couldn't be inserted
     */
    public void insert(Element element) throws SQLException{
        String moduleID = element.getModuleID();
        String description = element.getDescription();
        String sql = "SELECT fn_InsertElement(?,?)";
        SQLParameter p1 = new SQLParameter(moduleID);
        SQLParameter p2 = new SQLParameter(description);
        super.doPreparedStatement(sql, p1, p2);
    }

    /**
     * Updates the description field of a specified element.
     * @param element The element object with updated description
     * @throws SQLException if Element didn't exist in DB or otherwise couldn't be updated
     */
    public void update(Element element) throws SQLException {
        Integer elementID = element.getElementID();
        String moduleID = element.getModuleID();
        String description = element.getDescription();
        String sql = "SELECT fn_UpdateElement(?,?,?)";
        SQLParameter p1 = new SQLParameter(elementID);
        SQLParameter p2 = new SQLParameter(moduleID);
        SQLParameter p3 = new SQLParameter(description);
        super.doPreparedStatement(sql, p1, p2, p3);
    }

    /**
     * Deletes an element.
     * @param element Element to delete from the database
     * @throws SQLException if Element didn't exist or couldn't be deleted
     */
    public void delete(Element element) throws SQLException {
        Integer elementID = element.getElementID();
        String moduleID = element.getModuleID();
        String sql = "SELECT fn_DeleteElement(?,?)";
        SQLParameter p1 = new SQLParameter(elementID);
        SQLParameter p2 = new SQLParameter(moduleID);
        super.doPreparedStatement(sql, p1, p2);
    }

    /**
     * Returns an element by ID.
     * @param moduleID ModuleID of the Element to be retrieved
     * @param elementID ElementID of the Element to be retrieved
     * @return Element with IDs corresponding to values passed in.
     *          If Element couldn't be found, returns blank Element object.
     */
    public Element getByID(String moduleID, int elementID) {
        
        Element element = new Element();
        
        String sql = "SELECT * FROM fn_GetElement(?,?)";
        SQLParameter p1 = new SQLParameter(moduleID);
        SQLParameter p2 = new SQLParameter(elementID);
        
        try {
            ResultSet rs = super.doPreparedStatement(sql, p1, p2);
            element = new Element(elementID, moduleID);
            rs.next();
    		if (rs.getRow() > 0) {
			element.setDescription(rs.getString(Field.DESCRIPTION.name()));
		}
        } catch (SQLException ex) {
            Logger.getLogger(ElementIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return element;
    }
    
    /**
     * Gets a list of Elements that belong to a specific module.
     * @param moduleID the ID of the module to retrieve elements for
     * @return list of elements belonging to that module.
     *          If Module doesn't exist in DB, returns null.
     */
    public ArrayList<Element> getList(String moduleID){
        
        try {
            String sql = "SELECT * FROM fn_GetModuleElements(?)";
            SQLParameter p1 = new SQLParameter(moduleID);
            ResultSet rs = super.doPreparedStatement(sql, p1);
            ArrayList<Element> elements = new ArrayList<Element>();
            while (rs.next()) {
                int elementID = rs.getInt(Field.ELEMENT_ID.name);
                String description = rs.getString(Field.DESCRIPTION.name);
                Element element = new Element(elementID, moduleID, description);
                elements.add(element);
            }
            return elements;
        } catch (SQLException e) {
            System.err.println(e.getMessage() + "\n Error Code: " + e.getErrorCode());
        }
        return null;
    }
}