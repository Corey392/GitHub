/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package domain;

/**
 * 
 * @author David, James
 * @author Adam Shortall
 */
public class Provider implements Comparable<Provider> {
    private char providerID;
    private String name;
    
    public Provider() {
        this(' ',"");
    }

    public Provider(char providerID, String name) {
        this.providerID = providerID;
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public char getProviderID() {
        return providerID;
    }

    public void setProviderID(char providerID) {
        this.providerID = providerID;
    }

    @Override
    public String toString() {
        if (this.providerID == ' ') return "";
        return this.providerID + ": " + this.name;
    }

    @Override
    public int compareTo(Provider that) {
        if (this.providerID < that.providerID) {
            return -1;
        } return (this.providerID == that.providerID ? 0 : 1);
    }        
}
