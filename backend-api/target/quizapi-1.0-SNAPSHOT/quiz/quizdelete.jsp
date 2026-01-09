<%-- 
    Document   : delete
    Created on : 6 Dec 2025, 7:18:07 am
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
    if (!request.getMethod().equalsIgnoreCase("GET")) {
        JSONObject ob = new JSONObject();
        ob.put("status", "Error");
        ob.put("Message", "API must call be GET method");
        out.print(ob.toString());
        return;

    }
    String id = request.getParameter("id");
    if (id == null) {
        JSONObject ob = new JSONObject();
        ob.put("status", "Error");
        ob.put("Message", "ID is required Parameter");
        out.print(ob.toString());
        return;
    }

    DatabaseConnection db = new DatabaseConnection();
    String cmd = "delete from quiz where id='" + id + "'";
    if (db.executeIUD(cmd)) {
        JSONObject ob = new JSONObject();
        ob.put("status", "Success");
        ob.put("Message", "Data Delete Successfully");
        out.print(ob.toString());
        return;
    } else {
        JSONObject ob = new JSONObject();
        ob.put("status", "Error");
        ob.put("Message", "Data Delete Not Successfully");
        out.print(ob.toString());
    }


%>
