/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package util;

/**
 *
 * @author Adam Shortall
 */
public enum RPLFragment {
    HEADER("/WEB-INF/jspf/header.jspf"),
    FOOTER("/WEB-INF/jspf/footer.jspf"),
    MAINTENANCE_OPTIONS("/WEB-INF/jspf/maintenanceOptions.jspf"),
    JAVASCRIPT("/RPLScripts.js");
    
    public final String relativeAddress;
    public final String absoluteAddress;
    
    RPLFragment(String relativeAddress) {
        this.relativeAddress = relativeAddress;
        this.absoluteAddress = RPLPage.ROOT + relativeAddress;
    }
    
    @Override
    public String toString() {
        return this.absoluteAddress;
    }
}
