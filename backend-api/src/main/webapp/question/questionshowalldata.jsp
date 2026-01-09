<%@page import="org.json.JSONArray"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.mycompany.quizapi.DatabaseConnection"%>
<%@page import="org.json.JSONObject"%>
<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%
response.setHeader("Access-Control-Allow-Origin", "*");
response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
response.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");
response.setHeader("Access-Control-Allow-Credentials", "true");

if(!request.getMethod().equalsIgnoreCase("GET"))
{
    JSONObject ob = new JSONObject();
    ob.put("status","Error");
    ob.put("message","API must call with GET method");
    out.print(ob.toString());
    return;
}

String quizid = request.getParameter("quizid");

DatabaseConnection db = new DatabaseConnection();
String cmd;

if(quizid != null && !quizid.trim().equals("")) {
    cmd = "select * from question where quizid='"+quizid+"'";
} else {
    cmd = "select * from question";
}

ResultSet rs = db.executeSelect(cmd);

JSONArray array = new JSONArray();
while(rs.next()){
    JSONObject ob = new JSONObject();
    ob.put("id", rs.getString("id"));
    ob.put("quizid", rs.getString("quizid"));
    ob.put("question", rs.getString("question"));
    ob.put("ans1", rs.getString("ans1"));
    ob.put("ans2", rs.getString("ans2"));
    ob.put("ans3", rs.getString("ans3"));
    ob.put("ans4", rs.getString("ans4"));
    ob.put("correctans", rs.getString("correctans"));

    array.put(ob);
}

out.print(array.toString());
%>
