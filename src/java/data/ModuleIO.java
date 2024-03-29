package data;

import domain.Module;
import domain.User.Role;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * @author James, Adam Shortall, Bryce Carr
 * @version 1.020
 * Created: Unknown
 * Modified:	29/04/2013
 * Changelog:	29/04/2013: BC:	Fixed SQL SELECT statement calling fn_listmodulesnotinacourse (function name was wrong)
 *		30/04/2013: BC:	Updated addCore() and addElective() to call newly-added DB functions
 *		04/05/2013: BC:	Updated removeCore() and removeElective() to call newly-added DB functions
 */
public class ModuleIO extends RPL_IO<Module> {

    public enum Field {
        MODULE_ID("moduleID"),
        NAME("name"),
        INSTRUCTIONS("instructions");

        public final String name;

        Field(String name) {
            this.name = name;
        }
    }

    public ModuleIO(Role role) {
        super(role);
    }

    /**
     * Inserts a module.
     * @param module The module to insert
     * @throws SQLException if moduleID is not unique
     */
    public void insert(Module module) throws SQLException{
        String instructions = module.getInstructions();
        String moduleID = module.getModuleID();
        String name = module.getName();
        String sql = "SELECT fn_InsertModule(?,?,?)";
        SQLParameter p1 = new SQLParameter(moduleID);
        SQLParameter p2 = new SQLParameter(name);
        SQLParameter p3 = new SQLParameter(instructions);
        super.doPreparedStatement(sql, p1, p2, p3);
    }

    /**
     * Updates a module with new module info.
     * @param module The module with updated data.
     * @param oldID The ID of the module in the database.
     * @throws SQLException if new module ID is not unique.
     */
    public void update(Module module, String oldID) throws SQLException {
        String moduleID = module.getModuleID();
        String instructions = module.getInstructions();
        String name = module.getName();
        String sql = "SELECT fn_UpdateModule(?,?,?,?)";
        SQLParameter p1 = new SQLParameter(oldID);
        SQLParameter p2 = new SQLParameter(moduleID);
        SQLParameter p3 = new SQLParameter(name);
        SQLParameter p4 = new SQLParameter(instructions);
        super.doPreparedStatement(sql, p1, p2, p3, p4);
    }

    /**
     * Deletes a module and all dependent elements etc.
     * @param module the module to delete
     * @throws SQLException if module does not exist in DB
     */
    public void delete(Module module) throws SQLException {
        String moduleID = module.getModuleID();
        String sql = "SELECT fn_DeleteModule(?)";
        SQLParameter p1 = new SQLParameter(moduleID);
        super.doPreparedStatement(sql, p1);
    }

    /**
     * Gets a Module by its ID.
     * @param moduleID the ID of the module to retrieve
     * @return the module that was found. Otherwise, null.
     */
    public Module getByID(String moduleID){

        String sql = "SELECT * FROM fn_GetModuleByID(?)";
        SQLParameter p1 = new SQLParameter(moduleID);
        try {
            ResultSet rs = super.doPreparedStatement(sql, p1);
            while(rs.next()){
                String instructions = rs.getString(Field.INSTRUCTIONS.name);
                String name = rs.getString(Field.NAME.name);
                return new Module(moduleID, name, instructions);
            }
        } catch (SQLException e) {
            System.err.println(e.getMessage() + "\n Error Code: " + e.getErrorCode());
        }
        return null;
    }

    /**
     * @param courseID ID of the course to retrieve core modules from
     * @return ArrayList<Module> of core modules from a course.
     *          If they can't be retrieved, null.
     */
    public ArrayList<Module> getListOfCores(String courseID) {

        String sql = "SELECT * FROM fn_ListCores(?)";
        SQLParameter p1 = new SQLParameter(courseID);
        try {
            ResultSet rs = super.doPreparedStatement(sql, p1);
            return this.getListFromResultSet(rs);
        } catch (SQLException ex) {
            Logger.getLogger(ModuleIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    /**
     * @param courseID ID of the course to retrieve elective modules from
     * @return ArrayList<Module> of elective modules from a course.
     *          If they can't be retrieved, null.
     */
    public ArrayList<Module> getListOfElectives(String courseID) {

        String sql = "SELECT * FROM fn_ListElectives(?)";
        SQLParameter p1 = new SQLParameter(courseID);
        
        try {
            ResultSet rs = super.doPreparedStatement(sql, p1);
            return this.getListFromResultSet(rs);
        } catch (SQLException ex) {
            Logger.getLogger(ModuleIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    /**
     * @return all modules in the DB. If there aren't any, or the DB isn't
     *          set up properly, returns null.
     */
    public ArrayList<Module> getList() {

        String sql = "SELECT * FROM fn_ListModules();";
        try {
            ResultSet rs = super.doQuery(sql);
            return this.getListFromResultSet(rs);
        } catch (SQLException ex) {
            Logger.getLogger(ModuleIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    /**
     * @param courseID ID of the course to retrieve modules not pertaining to
     * @return ArrayList<Module> of modules not in a specific course.
     *          If they can't be retrieved, returns null
     */
    public ArrayList<Module> getListNotInCourse(String courseID) {

        String sql = "SELECT * FROM fn_ListModulesNotInACourse(?)";
        SQLParameter p1 = new SQLParameter(courseID);
        try {
            ResultSet rs = super.doPreparedStatement(sql, p1);
            return this.getListFromResultSet(rs);
        } catch (SQLException ex) {
            Logger.getLogger(ModuleIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    /**
     * @param courseID ID of the course to retrieve non-core modules for.
     * @return ArrayList<Module> of non-core modules for a course.
     *          If they can't be retrieved, returns null.
     */
    public ArrayList<Module> getListNotCoreInCourse(String courseID) {

        String sql = "SELECT * FROM fn_ListModulesNotCoreInCourse(?)";
        SQLParameter p1 = new SQLParameter(courseID);
        try {
            ResultSet rs = super.doPreparedStatement(sql, p1);
            return this.getListFromResultSet(rs);
        } catch (SQLException ex) {
            Logger.getLogger(ModuleIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    /**
     * Adds a core module to a course.
     * @param courseID ID of the course to have a module added to
     * @param moduleID ID of the module to add to a course
     * @throws SQLException the module could not be added as a core to the course.
     */
    public void addCore(String courseID, String moduleID) throws SQLException {

        String sql = "SELECT fn_insertcoursemodulecore(?,?)";
        SQLParameter p1 = new SQLParameter(courseID);
        SQLParameter p2 = new SQLParameter(moduleID);

        super.doPreparedStatement(sql, p1, p2);
    }

    /**
     * Adds an elective module to a campus-discipline-course
     * @param campusID Campus ID of the CampusDisciplineCourse
     * @param disciplineID Discipline ID of the CampusDisciplineCourse
     * @param courseID Course ID of the CampusDisciplineCourse
     * @param moduleID ID of the module to add to a CampusDisciplineCourse
     * @throws SQLException if the module already existed, or the CampusDisciplineCourse didn't exist
     */
    public void addElective(String campusID, int disciplineID, String courseID, String moduleID) throws SQLException {

        String sql = "SELECT fn_insertcoursemoduleelective(?,?,?,?)";
        SQLParameter p1 = new SQLParameter(campusID);
        SQLParameter p2 = new SQLParameter(disciplineID);
        SQLParameter p3 = new SQLParameter(courseID);
        SQLParameter p4 = new SQLParameter(moduleID);

        super.doPreparedStatement(sql, p1, p2, p3, p4);
    }

    /**
     * Removes a module as an elective module for a specified course at a campus-discipline.
     * @param campusID Campus ID of the CampusDisciplineCourse
     * @param disciplineID Discipline ID of the CampusDisciplineCourse
     * @param courseID Course ID of the CampusDisciplineCourse
     * @param moduleID ID of the module to remove from a CampusDisciplineCourse
     * @throws SQLException if the module or CampusDisciplineCourse didn't exist
     */
    public void removeElective(String campusID, int disciplineID, String courseID, String moduleID) throws SQLException {
        String sql = "SELECT fn_removemoduleelective(?,?,?,?)";
        SQLParameter p1 = new SQLParameter(campusID);
        SQLParameter p2 = new SQLParameter(disciplineID);
        SQLParameter p3 = new SQLParameter(courseID);
        SQLParameter p4 = new SQLParameter(moduleID);

        super.doPreparedStatement(sql, p1, p2, p3, p4);
    }

    /**
     * Removes a core module from a course.
     * @param courseID the course to remove a core module from
     * @param moduleID the ID of the module to remove
     * @throws SQLException if course or module specified didn't exist
     */
    public void removeCore(String courseID, String moduleID) throws SQLException {
        String sql = "SELECT fn_removemodulecore(?,?)";
        SQLParameter p1 = new SQLParameter(courseID);
        SQLParameter p2 = new SQLParameter(moduleID);

        super.doPreparedStatement(sql, p1, p2);
    }

    /**
     * Takes a ResultSet of Modules and returns them in a list.
     * @param rs ResultSet to retrieve modules from
     * @return list of Module objects
     * @throws SQLException If the module in the ResultSet doesn't exist
     */
    private ArrayList<Module> getListFromResultSet(ResultSet rs) throws SQLException {

        ArrayList<Module> list = new ArrayList<Module>();
        String moduleID;

        while (rs.next()) {
            moduleID = rs.getString(Field.MODULE_ID.name);
            list.add(getModuleById(moduleID));
        }
        return list;
    }
    
    /**
     * Gets a module from the database by its ID
     * @param moduleID Unique ID of a module
     * @return Module with corresponding ID. If non-existent, null.
     */
    private Module getModuleById(String moduleID){
        
        String sql = "SELECT * FROM fn_getmodulebyid(?)";
        SQLParameter p1 = new SQLParameter(moduleID);
        try {
            ResultSet rs = super.doPreparedStatement(sql, p1);
            if (rs.next()){
                return this.getModuleFromResultSet(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ModuleIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
        
    }
    
    /**
     * Gets a module from a dataset
     * @param rs ResultSet to retrieve the Module from
     * @return Module within ResultSet passed in
     * @throws SQLException if the ResultSet wasn't of Module objects
     */
    private Module getModuleFromResultSet(ResultSet rs) throws SQLException {

        String moduleID = rs.getString(Field.MODULE_ID.name);
        String name = rs.getString(Field.NAME.name);
        String guide = rs.getString(Field.INSTRUCTIONS.name);
        return new Module(moduleID, name, guide);
        
    }
    
}