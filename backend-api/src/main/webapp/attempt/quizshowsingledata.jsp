<%@page import="java.sql.ResultSet"%>
<%@page import="com.mycompany.quizapi.DatabaseConnection"%>
<%@page import="org.json.JSONObject"%>
<%@page contentType="application/json" pageEncoding="UTF-8"%>

<%
/* ===== CORS HEADERS (TOP MOST) ===== */
response.setHeader("Access-Control-Allow-Origin", "*");
response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
response.setHeader("Access-Control-Allow-Headers", "Content-Type");
response.setHeader("Access-Control-Allow-Credentials", "true");

/* ===== Preflight OPTIONS ===== */
if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
    response.setStatus(200);
    return;
}

/* ===== Only GET allowed ===== */
if (!"GET".equalsIgnoreCase(request.getMethod())) {
    JSONObject ob = new JSONObject();
    ob.put("status", "Error");
    ob.put("message", "Use GET method");
    out.print(ob.toString());
    return;
}

String quizcode = request.getParameter("quizcode");

if (quizcode == null || quizcode.trim().equals("")) {
    JSONObject ob = new JSONObject();
    ob.put("status", "Error");
    ob.put("message", "quizcode missing");
    out.print(ob.toString());
    return;
}

DatabaseConnection db = new DatabaseConnection();
String cmd = "SELECT * FROM quiz WHERE quizcode='" + quizcode.replace("'", "''") + "'";
ResultSet rs = db.executeSelect(cmd);

if (rs.next()) {
    JSONObject data = new JSONObject();
    data.put("id", rs.getString("id"));
    data.put("quizname", rs.getString("quizname"));
    data.put("quizdesc", rs.getString("quizdesc"));
    data.put("quizcode", rs.getString("quizcode"));
    data.put("quiztime", rs.getString("quiztime"));
    data.put("totalquestions", rs.getString("totalquestions"));

    JSONObject res = new JSONObject();
    res.put("status", "Success");
    res.put("data", data);

    out.print(res.toString());
} else {
    JSONObject ob = new JSONObject();
    ob.put("status", "Error");
    ob.put("message", "Quiz not found");
    out.print(ob.toString());
}
%>
