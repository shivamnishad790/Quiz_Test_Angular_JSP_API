<%-- 
    Document   : quizshowalldata
    Created on : 6 Dec 2025, 7:16:56 am
    Author     : kshiv
--%>

<%@page import="org.json.JSONArray"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.mycompany.quizapi.DatabaseConnection"%>
<%@page import="org.json.JSONObject"%>
<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%
    /* --- Add CORS Headers --- */
    response.setHeader("Access-Control-Allow-Origin", "*");
    response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
    response.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");
    response.setHeader("Access-Control-Allow-Credentials", "true");

    if (!request.getMethod().equalsIgnoreCase("GET")) {
        JSONObject ob = new JSONObject();
        ob.put("status", "success");

        ob.put("message", "API must call With get method");
        out.print(ob.toString());
        return;
    }

    DatabaseConnection db = new DatabaseConnection();
    String cmd = "select * from quiz";
    ResultSet rs = db.executeSelect(cmd);

    JSONArray array = new JSONArray();
    while (rs.next()) {
        JSONObject ob = new JSONObject();
        ob.put("id", rs.getString("id"));
        ob.put("quizcode", rs.getString("quizcode"));
        ob.put("quizname", rs.getString("quizname"));
        ob.put("quizdesc", rs.getString("quizdesc"));
        ob.put("totalquestions", rs.getString("totalquestions"));
        ob.put("quiztime", rs.getString("quiztime"));

        array.put(ob);
    }

    out.print(array.toString());
%>