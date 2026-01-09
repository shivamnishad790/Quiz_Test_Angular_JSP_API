<%-- 
    Document   : add
    Created on : 6 Dec 2025, 7:16:18 am
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

    if (!request.getMethod().equalsIgnoreCase("POST")) {

        JSONObject ob = new JSONObject();
        ob.put("status", "Error");
        ob.put("Message", "API Must Call With Post Method");
        out.print(ob.toString());
        return;
    }

    String a = request.getParameter("quizcode");
    String b = request.getParameter("quizname");
    String c = request.getParameter("quizdesc");
    String d = request.getParameter("totalquestions");
    String e = request.getParameter("quiztime");
    
    if (a == null || b == null || c == null || d == null || e == null) {
        JSONObject ob = new JSONObject();
        ob.put("status", "Error");
        ob.put("message", "Data Con Not be blank");
        out.print(ob.toString());
        return;
    }
    DatabaseConnection db = new DatabaseConnection();
    String cmd = " insert into quiz(quizcode,quizname,quizdesc,totalquestions,quiztime) values('" + a + "','" + b + "','" + c + "','" + d + "','" + e + "')";
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