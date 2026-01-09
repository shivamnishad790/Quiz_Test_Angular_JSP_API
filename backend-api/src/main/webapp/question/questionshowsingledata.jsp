<%-- 
    Document   : qustionshowsingledata
    Created on : 6 Dec 2025, 7:22:10 am
    Author     : kshiv
--%>

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

String cmd = "select * from question where id = '"+id+"'";
ResultSet rs = db.executeSelect(cmd);
if(rs.next()){

JSONObject data = new JSONObject();

data.put("id", rs.getString("id"));
data.put("quizid", rs.getString("quizid"));
data.put("question", rs.getString("question"));
data.put("ans1", rs.getString("ans1"));
data.put("ans2", rs.getString("ans2"));
data.put("ans3", rs.getString("ans3"));
data.put("ans4", rs.getString("ans4"));
data.put("correctans", rs.getString("correctans"));

out.print(data.toString());


}

else{
JSONObject ob = new JSONObject();
ob.put("status","Error");
ob.put("message", "Data Not Found for id");
out.print(ob.toString());

}

%>