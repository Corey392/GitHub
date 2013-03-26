///*
// * To change this template, choose Tools | Templates
// * and open the template in the editor.
// */
//package util;
//
//import java.util.*;
//
///**
// *
// * @author James
// */
//public enum RPLHomePage {
//    STUDENT_HOME(RPLPage.STUDENT_HOME, ""),
//    TEACHER_HOME(RPLPage.TEACHER_HOME, ""),
//    ADMIN_HOME(RPLPage.ADMIN_HOME, "");
//    // TODO: Add welcome messages.
//    public final RPLPage rplPage;
//    public final String message;
//    ArrayList<Link> links;
//    
//    RPLHomePage(RPLPage rplPage, String message){
//        this.rplPage = rplPage;
//        this.message = message;
//    }
//    
//    public ArrayList<Link> getLinks(){
//        if (rplPage == RPLPage.STUDENT_HOME){
//            Link l1 = new Link("Create Claim","addClaim");
//            Link l2 = new Link("View Claims","viewClaims");
//            Link l3 = new Link("Logout", "logout");
//            links.add(l1);
//            links.add(l2);
//            links.add(l3);
//        }
//        else if (rplPage == RPLPage.TEACHER_HOME){
//            Link l1 = new Link("Review Claims","reviewClaims");
//            Link l2 = new Link("Logout", "logout");
//            links.add(l1);
//            links.add(l2);
//        }
//        else {
//            Link l1 = new Link("Data Entry","dataEntry");
//            Link l2 = new Link("modifyCourse","modifyCourse");
//            Link l3 = new Link("Assign Teacher","assignTeacher");
//            Link l4 = new Link("Logout", "logout");
//            links.add(l1);
//            links.add(l2);
//            links.add(l3);
//            links.add(l4);
//        }
//        return links;
//    }
//}
