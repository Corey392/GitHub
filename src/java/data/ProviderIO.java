package data;

import domain.Provider;
import domain.User.Role;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * @author Adam Shortall, James, Bryce Carr
 * @version 1.010
 * Modified:	07/05/2013
 * Changelog:	07/05/2013: Bryce Carr:	Added update() method.
 */
public class ProviderIO extends RPL_IO<Provider> {

    public enum Field {
        PROVIDER_ID("providerID"),
        NAME("name");
        
        public final String name;
        
        Field(String name) {
            this.name = name;
        }
    }
    
    public ProviderIO(Role role) {
        super(role);
    }
    
    /**
     * Inserts a new provider. 
     * @param provider the provider to insert.
     * @throws SQLException If the provider ID is not unique.
     */
    public void insert(Provider provider) throws SQLException{
        char providerID = provider.getProviderID();
        String name = provider.getName();
        String sql = "SELECT fn_InsertProvider(?,?)";
        
        SQLParameter p1 = new SQLParameter(providerID);
        SQLParameter p2 = new SQLParameter(name);
        
        super.doPreparedStatement(sql, p1, p2);
    }
    
    /**
     * Updates the name of the provider.
     * @param provider The provider object with updated name
     * @throws SQLException if the ID is invalid
     */
    public void update(Provider provider) throws SQLException {
        String name = provider.getName();
        char id = provider.getProviderID();
        String sql = "SELECT fn_UpdateProvider(?,?)";
        SQLParameter p1 = new SQLParameter(id);
        SQLParameter p2 = new SQLParameter(name);        
        super.doPreparedStatement(sql, p1, p2);
    }

    /**
     * Deletes the specified provider.
     * @param provider the provider to delete.
     * @throws SQLException if no such provider existed in the DB.
     */
    public void delete(Provider provider) throws SQLException {
        char providerID = provider.getProviderID();
        String sql = "SELECT fn_DeleteProvider(?)";
        SQLParameter p1 = new SQLParameter(providerID);
        
        super.doPreparedStatement(sql, p1);
    }
    
    /**
     * Returns a provider with data from the database.
     * @param provider Provider to retrieve from DB
     * @return provider with data from the database.
     *          Null if they don't exist
     */
    public Provider getByID(Provider provider) {
        char providerID = provider.getProviderID();
        String sql = "SELECT * FROM fn_GetProvider(?)";
        SQLParameter p1 = new SQLParameter(providerID);
        try {
            ResultSet rs = super.doPreparedStatement(sql, p1);
            if (rs.next()) {
                String name = rs.getString("name");
                return new Provider(providerID, name);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ProviderIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
    
    /**
     * Returns a list of providers for a claimed module.
     * @param claimID ClaimID of the ClaimedModule to retrieve providers for
     * @param moduleID ModuleID of the ClaimedModule to retrieve providers for
     * @return Returns an ArrayList<Provider> of providers attached to a ClaimedModule
     */
    public ArrayList<Provider> getList(int claimID, String moduleID) {
        ArrayList<Provider> list = new ArrayList<Provider>();
        String sql = "SELECT * FROM fn_ListProviders(?,?)";
        SQLParameter p1 = new SQLParameter(claimID);
        SQLParameter p2 = new SQLParameter(moduleID);
        try {
            ResultSet rs = super.doPreparedStatement(sql, p1, p2);
            char providerID;
            String name;
            while (rs.next()) {
                providerID = rs.getString("providerID").charAt(0);
                name = rs.getString("name");
                list.add(new Provider(providerID, name));
            }
        } catch (SQLException ex) {
            Logger.getLogger(ProviderIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
    
    /**
     * @return a list of all providers in the database.
     */
    public ArrayList<Provider> getList() {
        ArrayList<Provider> list = new ArrayList<Provider>();
        String sql = "SELECT * FROM fn_ListProviders()";
        try {
            ResultSet rs = super.doQuery(sql);
            char providerID;
            String name;
            while (rs.next()) {
                providerID = rs.getString("providerID").charAt(0);
                name = rs.getString("name");
                list.add(new Provider(providerID, name));
            }
        } catch (SQLException ex) {
            Logger.getLogger(ProviderIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
}