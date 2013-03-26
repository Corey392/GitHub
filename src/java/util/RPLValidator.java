/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package util;

/**
 *
 * @author rpl
 */
public class RPLValidator {

    public static int fixParseIntEx(String fixStr, int replaceNum) {
        if (fixStr != null) fixStr = fixStr.replaceAll(",", "");
        return (fixStr == null || fixStr.equals("")) ? replaceNum : Integer.parseInt(fixStr);
    }
}
