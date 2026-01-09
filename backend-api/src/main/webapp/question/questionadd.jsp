<%-- 
    Document   : qustionadd
    Created on : 6 Dec 2025, 7:21:07 am
    Author     : kshiv
--%>

<%@page import="com.mycompany.quizapi.DatabaseConnection"%>
<%@page import="org.json.JSONObject"%>
<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%
/* --- Add CORS Headers --- */
response.setHeader("Access-Control-Allow-Origin", "*");
response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
response.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");
response.setHeader("Access-Control-Allow-Credentials", "true");
    
    if(!request.getMethod().equalsIgnoreCase("POST"))
    {
    
    JSONObject ob  = new JSONObject();
    ob.put("status", "Error");
    ob.put("Message", "API Must Call With Post Method");
    out.print(ob.toString());
    return;
}
    
    String a = request.getParameter("quizid");
    String b = request.getParameter("question");
    String c = request.getParameter("ans1");
    String d = request.getParameter("ans2");
    String e = request.getParameter("ans3");
    String f = request.getParameter("ans4");
    String g = request.getParameter("correctans");
if(a==null || b==null || c==null || d==null || e==null || f==null || g==null)
{
JSONObject ob = new JSONObject();
 ob.put("status", "Error");
       ob.put("message", "Data Con Not be blank");
       out.print(ob.toString());
       return;
}
    DatabaseConnection db = new DatabaseConnection();
    String cmd = " insert into question(quizid,question,ans1,ans2,ans3,ans4,correctans) values('" + a + "','" + b + "','" + c + "','" + d + "','"+e+"','"+f+"','"+g+"')";
    if (db.executeIUD(cmd)) {
       JSONObject ob = new JSONObject();
       ob.put("status", "Success");
       ob.put("message", "Data Insert Successfully");
       out.print(ob.toString());
    } else {
        JSONObject ob = new JSONObject();
       ob.put("status", "Success");
       ob.put("message", "Data Not Insert Successfully");
       out.print(ob.toString());
    }


%>