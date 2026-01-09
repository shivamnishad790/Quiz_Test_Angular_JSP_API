<%-- 
    Document   : attemptresult
    Created on : 16 Dec 2025, 12:07:11 pm
    Author     : kshiv
--%>


<%@page import="java.sql.ResultSet"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.mycompany.quizapi.DatabaseConnection"%>
<%@page contentType="application/json" pageEncoding="UTF-8"%>

<%
response.setHeader("Access-Control-Allow-Origin", "*");

String attemptid = request.getParameter("attemptid");
JSONObject obj = new JSONObject();

if (attemptid == null) {
    obj.put("status", "Error");
    obj.put("message", "Attempt ID missing");
    out.print(obj.toString());
    return;
}

try {
    DatabaseConnection db = new DatabaseConnection();

    String sql = "SELECT * FROM attempt WHERE id='" + attemptid + "'";
    ResultSet rs = db.executeSelect(sql);

    if (rs.next()) {

        int total = rs.getInt("totalquestions");
        int correct = rs.getInt("correct");
        int wrong = rs.getInt("wrong");

        obj.put("status", "Success");

        // 👤 USER INFO
        obj.put("name", rs.getString("name"));
        obj.put("quizcode", rs.getString("quizcode"));

        // 📊 RESULT INFO
        obj.put("total", total);
        obj.put("attempt", correct + wrong);
        obj.put("unattempt", total - (correct + wrong));
        obj.put("correct", correct);
        obj.put("wrong", wrong);

    } else {
        obj.put("status", "Error");
        obj.put("message", "Result not found");
    }

} catch (Exception e) {
    obj.put("status", "Error");
    obj.put("message", e.getMessage());
}

out.print(obj.toString());
%>
