/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package util;

import domain.ClaimRecord;
import javax.servlet.ServletRequest;

/**
 *
 * @author rpl
 */
public class RPLPaging {
    
    /**
     * 
     * @param pageNo
     * @return 
     */
    public static int[] calculatePageNum(int pageNo) {
        
        int[] rtnPageNum = new int[2];
        
        rtnPageNum[0] = pageNo * 10;
        rtnPageNum[1] = ((pageNo - 1) * 10 + 1);
        
        return rtnPageNum;
    }
    
    /**
     * 
     * @param iRowCntPerPage
     * @param iRowCntData
     * @param action
     * @param target
     * @param request
     * @return 
     */
    public static String printPageNumber(String varName
                                       , String frmName
                                       , ServletRequest request)
    {
        StringBuffer oHtmlBuf = new StringBuffer();  
        
        int iRowCntPerPage = 10;
        int iRowCntData = Integer.parseInt((String)request.getAttribute(varName));

        int iMaxLists = 10;
        int iTemp = (int)(iRowCntData) % iRowCntPerPage;
        int iTotPageCnt = 0;

        if(iTemp == 0) {
                iTotPageCnt = (int)((iRowCntData) / iRowCntPerPage);
        } else {
                iTotPageCnt = (int)((iRowCntData) / iRowCntPerPage) + 1 ;
        }

        iTemp = iTotPageCnt % iMaxLists;
        int iTotPageSetCnt = 0;

        if(iTemp == 0) {
                iTotPageSetCnt = iTotPageCnt / iMaxLists;
        } else {
                iTotPageSetCnt = iTotPageCnt / iMaxLists + 1;
        }

        int iCurrentPageSetNo = 0;
        String sCurrentPageNo = null;

        // 현재 페이지번호를 구한다.
        ClaimRecord oClaimRecord = null;
        oClaimRecord = (ClaimRecord)request.getAttribute("claimRecordParam");
        if(oClaimRecord == null) {
                sCurrentPageNo = "1"; //처음 들어올때는 첫번째 페이지 번호
        } else {
                sCurrentPageNo = String.valueOf(oClaimRecord.getPageNo());
        }

        // 현재 페이지세트를 구한다.
        if(oClaimRecord == null) {
                iCurrentPageSetNo = 1; //처음 들어올때는 첫번째 페이지셋
        } else {
            iCurrentPageSetNo = Integer.parseInt(oClaimRecord.getPageNo().toString());
        }

        int iPageSetLastPageNo = iCurrentPageSetNo * iMaxLists;
        if(iPageSetLastPageNo > iTotPageCnt) {
            iPageSetLastPageNo = iTotPageCnt;
        }

        if(iRowCntData != 0) {
                // HTML로 출력할 스트링을 만든다.
                oHtmlBuf.append("<center>\n");
                oHtmlBuf.append("    <table border='0' cellspacing='0' cellpadding='0'>\n");
                oHtmlBuf.append("    <tr>\n");
                oHtmlBuf.append("        <td>\n");
                oHtmlBuf.append("            <a href='#' onlick='document." + frmName+ ".pageNo.value=1;document." + frmName+ ".submit(); return false;'><<</a> \n");
        }

        // 페이지 세트를 찍는다
        for(int iInx = ((iCurrentPageSetNo-1)*iMaxLists+1); iInx <= iPageSetLastPageNo ; iInx++) {

                oHtmlBuf.append("            <a href'#' onclick='document." + frmName+ ".pageNo.value="+iInx+";document." + frmName+ ".submit(); return false;'>");

                if(iInx == Integer.parseInt(sCurrentPageNo)) {
                    oHtmlBuf.append("<font color='#FF0000'><b>");
                }
                oHtmlBuf.append("<span style='font-size:14px;' style='cursor:pointer;'>");
                oHtmlBuf.append(iInx);
                oHtmlBuf.append("</span>");

                if(iInx == Integer.parseInt(sCurrentPageNo)) {
                    oHtmlBuf.append("</b></font>");
                }

                oHtmlBuf.append("</a>\n");
        }

        if(iRowCntData != 0) {
                oHtmlBuf.append("            <a href='#' onclick='document." + frmName+ ".pageNo.value="+iTotPageCnt+";document." + frmName+ ".submit(); return false;'>>></a> " );
                oHtmlBuf.append("        </td>");
                oHtmlBuf.append("    </tr>");
                oHtmlBuf.append("    </table>");
        }

/*        oHtmlBuf.append("<input type='hidden' name='CurrentPageNo'		value='" + sCurrentPageNo 		+ "'>\n");
        oHtmlBuf.append("<input type='hidden' name='TargetPageNo'		value='" + sCurrentPageNo 		+ "'>\n");
        oHtmlBuf.append("<input type='hidden' name='TotPageCnt'			value='" + iTotPageCnt 			+ "'>\n");
        oHtmlBuf.append("<input type='hidden' name='RowCnt'				value='" + iRowCntPerPage 		+ "'>\n");
        oHtmlBuf.append("<input type='hidden' name='TotRowCnt'			value='" + iRowCntData 			+ "'>\n");
        oHtmlBuf.append("<input type='hidden' name='CurrentPageSetNo'	value='" + iCurrentPageSetNo 	+ "'>\n");
        oHtmlBuf.append("<input type='hidden' name='TargetPageSetNo'	value='" + iCurrentPageSetNo 	+ "'>\n");
        oHtmlBuf.append("<input type='hidden' name='TotPageSetCnt'		value='" + iTotPageSetCnt 		+ "'>\n");
        * 
        */
        oHtmlBuf.append("<input type='hidden' name='pageNo'		value=''>\n");
        oHtmlBuf.append("<input type='hidden' name='view'		value='view'>\n");
        
        oHtmlBuf.append("</center>    \n");

//        oHtmlBuf.append("<SCRIPT LANGUAGE='JavaScript'>    \n");
//        oHtmlBuf.append("	js_pageCntPerPageSet = "+iMaxLists+"\n");
//        oHtmlBuf.append("</SCRIPT>");

        return oHtmlBuf.toString();
    }
    
}
