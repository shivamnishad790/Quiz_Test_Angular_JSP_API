<%-- 
    Document   : showsingledata
    Created on : 6 Dec 2025, 7:17:46 am
    Author     : kshiv
--%>

<%@page import="com.mycompany.quizapi.DatabaseConnection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="org.json.JSONObject"%>
<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%
/* --- Add CORS Headers --- */
response.setHeader("Access-Control-Allow-Origin", "*");
response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
response.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");
response.setHeader("Access-Control-Allow-Credentials", "true");

if(!request.getMethod().equalsIgnoreCase("GET"))
{

JSONObject ob = new JSONObject();
ob.put("status","Error");
ob.put("message", "API must call with GET API");
out.print(ob.toString());
return;
}

String id = request.getParameter("id");
if(id==null)
{
JSONObject ob = new JSONObject();
ob.put("status","Error");
ob.put("message", "Id is requied");
out.print(ob.toString());
return;
}



DatabaseConnection db = new DatabaseConnection();

String cmd = "select * from quiz where id = '"+id+"'";
ResultSet rs = db.executeSelect(cmd);
if(rs.next()){

JSONObject data = new JSONObject();

data.put("id", rs.getString("id"));
data.put("quizcode", rs.getString("quizcode"));
data.put("quizname", rs.getString("quizname"));
data.put("quizdesc", rs.getString("quizdesc"));
data.put("totalquestions", rs.getString("totalquestions"));
data.put("quiztime", rs.getString("quiztime"));


out.print(data.toString());


}

else{
JSONObject ob = new JSONObject();
ob.put("status","Error");
ob.put("message", "Data Not Found for id");
out.print(ob.toString());

}

%>