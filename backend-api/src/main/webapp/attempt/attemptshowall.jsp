<%-- 
    Document   : attemptshowall
    Created on : 20 Dec 2025, 1:01:43 pm
    Author     : kshiv
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.mycompany.quizapi.DatabaseConnection"%>
<%@page contentType="application/json" pageEncoding="UTF-8"%>

<%
/* ================= CORS (VERY IMPORTANT) ================= */
response.setHeader("Access-Control-Allow-Origin", "*");
response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
response.setHeader("Access-Control-Allow-Headers", "Content-Type");
response.setHeader("Access-Control-Allow-Credentials", "true");

if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
    response.setStatus(200);
    return;
}
/* ========================================================= */

DatabaseConnection db = new DatabaseConnection();

String sql = "SELECT id,name,mobile,email,collegename,quizcode,correct,totalquestions FROM attempt ORDER BY id DESC";
ResultSet rs = db.executeSelect(sql);

JSONArray arr = new JSONArray();

while (rs.next()) {
    JSONObject ob = new JSONObject();
    ob.put("id", rs.getInt("id"));
    ob.put("name", rs.getString("name"));
    ob.put("mobile", rs.getString("mobile"));
    ob.put("email", rs.getString("email"));
    ob.put("collegename", rs.getString("collegename"));
    ob.put("quizcode", rs.getString("quizcode"));
    ob.put("correct", rs.getString("correct"));
    ob.put("totalquestions", rs.getString("totalquestions"));
    arr.put(ob);
}

JSONObject res = new JSONObject();
res.put("status", "Success");
res.put("data", arr);

out.print(res.toString());
%>
