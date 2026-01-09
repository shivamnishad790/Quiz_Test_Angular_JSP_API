<%-- 
    Document   : dashboardstats
    Created on : 20 Dec 2025, 1:33:10 pm
    Author     : kshiv
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.mycompany.quizapi.DatabaseConnection"%>
<%@page contentType="application/json" pageEncoding="UTF-8"%>

<%
/* ===== CORS ===== */
response.setHeader("Access-Control-Allow-Origin", "*");
response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
response.setHeader("Access-Control-Allow-Headers", "Content-Type");
if ("OPTIONS".equalsIgnoreCase(request.getMethod())) return;
/* ================= */

DatabaseConnection db = new DatabaseConnection();
JSONObject res = new JSONObject();

/* Total Quiz */
ResultSet rs1 = db.executeSelect("SELECT COUNT(*) total FROM quiz");
rs1.next();
res.put("totalQuiz", rs1.getInt("total"));

/* Active Quiz (example: quiztime not empty) */
ResultSet rs2 = db.executeSelect("SELECT COUNT(*) total FROM quiz WHERE quiztime!=''");
rs2.next();
res.put("activeQuiz", rs2.getInt("total"));

/* Total Attempts */
ResultSet rs3 = db.executeSelect("SELECT COUNT(*) total FROM attempt");
rs3.next();
res.put("totalAttempts", rs3.getInt("total"));

/* Total Students */
ResultSet rs4 = db.executeSelect("SELECT COUNT(DISTINCT email) total FROM attempt");
rs4.next();
res.put("totalStudents", rs4.getInt("total"));

res.put("status", "Success");
out.print(res.toString());
%>
