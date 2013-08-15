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
    HEADER("/WEB-INF/jspf/header_1.jspf"),
    FOOTER("/WEB-INF/jspf/footer_1.jspf"),
    MAINTENANCE_OPTIONS("/WEB-INF/jspf/maintenanceOptions.jspf"),
    JAVASCRIPT("/scripts/RPLScripts.js"),
    GOOGLE_JQUERY_MIN_JS("http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"),
    JQUERY_LOCAL_MIN("/scripts/jquery-1.10.2.min.js"),
    JQUERY_UI("http://code.jquery.com/ui/1.10.3/jquery-ui.js"),
    JQUERY_UI_THEMES_CSS("http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css"),
    RPL_CSS("/css/rpl.css"),
    MAIN_CSS("/css/main.css"),
    PANEL_CSS("/css/panel.css"),
    TAB_CSS("/css/style.css");

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
