package domain;

import java.io.Serializable;

/**
 * @author David, James, Adam Shortall
 */
public class Provider implements Comparable<Provider>, Serializable {
    
    private char providerID;
    private String name;

    public Provider() {
        this(' ',"");
    }

    public Provider(char providerID, String name) {
        this.providerID = providerID;
        this.name = name;
    }

    /**
     * @return Name of the provider
     */
    public String getName() {
        return name;
    }

    /**
     * @param name Name of the provider
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * @return Unique ID identifying this provider
     */
    public char getProviderID() {
        return providerID;
    }

    /**
     * @param providerID Unique ID identifying this provider
     */
    public void setProviderID(char providerID) {
        this.providerID = providerID;
    }

    @Override
    public String toString() {
        return this.providerID == ' ' ? "" : this.providerID + ": " + this.name;
    }

    @Override
    public int compareTo(Provider that) {
        if (this.providerID < that.providerID) {
            return -1;
        } 
        return (this.providerID == that.providerID ? 0 : 1);
    }
}