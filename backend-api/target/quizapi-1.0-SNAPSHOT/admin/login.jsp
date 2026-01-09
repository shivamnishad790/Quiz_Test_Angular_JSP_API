<%-- 
    Document   : adminlogin
    Created on : 9 Dec 2025
    Author     : kshiv
--%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.mycompany.quizapi.DatabaseConnection"%>
<%@page import="org.json.JSONObject"%>
<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%
    response.setHeader("Access-Control-Allow-Origin", "*");
    response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
    response.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");
    response.setHeader("Access-Control-Allow-Credentials", "true");

    if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
        response.setStatus(200);
        return;
    }

    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        JSONObject ob = new JSONObject();
        ob.put("status","Error");
        ob.put("message","Use POST");
        out.print(ob.toString());
        return;
    }

    String username = request.getParameter("username");
    String password = request.getParameter("password");

    // echo what arrived (for debugging)
    JSONObject dbg = new JSONObject();
    dbg.put("username", username == null ? JSONObject.NULL : username);
    dbg.put("password", password == null ? JSONObject.NULL : password);

    // if missing, return early with debug info
    if (username == null || password == null) {
        dbg.put("status","Error");
        dbg.put("message","Missing params");
        out.print(dbg.toString());
        return;
    }

    DatabaseConnection db = new DatabaseConnection();
    String cmd = "SELECT * FROM admin WHERE username='" + username.replace("'", "''") + "' AND password='" + password.replace("'", "''") + "'";
    ResultSet rs = null;
    try {
        rs = db.executeSelect(cmd);
        if (rs.next()) {
            dbg.put("status","Success");
            dbg.put("message","Login Successful");
            dbg.put("id", rs.getString("id"));
            dbg.put("username", rs.getString("username"));
        } else {
            dbg.put("status","Error");
            dbg.put("message","Invalid username or password (0 rows)");
        }
    } catch (Exception ex) {
        dbg.put("status","Error");
        dbg.put("message","Exception: " + ex.getMessage());
    }
    out.print(dbg.toString());
%>
