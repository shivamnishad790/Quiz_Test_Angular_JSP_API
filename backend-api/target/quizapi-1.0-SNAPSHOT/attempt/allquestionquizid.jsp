<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.mycompany.quizapi.DatabaseConnection"%>
<%@page contentType="application/json" pageEncoding="UTF-8"%>

<%
response.setHeader("Access-Control-Allow-Origin", "*");
response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
response.setHeader("Access-Control-Allow-Headers", "Content-Type");

String quizid = request.getParameter("quizid");

if (quizid == null || quizid.trim().equals("")) {
    JSONObject ob = new JSONObject();
    ob.put("status", "Error");
    ob.put("message", "Quiz ID missing");
    out.print(ob.toString());
    return;
}

DatabaseConnection db = new DatabaseConnection();
ResultSet rs = db.executeSelect(
    "SELECT * FROM question WHERE quizid='" + quizid + "'"
);

JSONArray arr = new JSONArray();

while (rs.next()) {
    JSONObject q = new JSONObject();
    q.put("id", rs.getInt("id"));
    q.put("question", rs.getString("question"));
    q.put("ans1", rs.getString("ans1"));
    q.put("ans2", rs.getString("ans2"));
    q.put("ans3", rs.getString("ans3"));
    q.put("ans4", rs.getString("ans4"));
    q.put("correctans", rs.getString("correctans"));
    arr.put(q);
}

JSONObject finalObj = new JSONObject();
finalObj.put("status", "Success");
finalObj.put("data", arr);

out.print(finalObj.toString());
%>
