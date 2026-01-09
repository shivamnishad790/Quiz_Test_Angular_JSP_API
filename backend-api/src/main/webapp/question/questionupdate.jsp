<%-- 
    Document   : qustionupdate
    Author     : kshiv
--%>

<%@page import="com.mycompany.quizapi.DatabaseConnection"%>
<%@page import="org.json.JSONObject"%>
<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%
    response.setHeader("Access-Control-Allow-Origin", "*");
    response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
    response.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");
    response.setHeader("Access-Control-Allow-Credentials", "true");

    if (!request.getMethod().equalsIgnoreCase("POST")) {
        JSONObject ob = new JSONObject();
        ob.put("status", "Error");
        ob.put("message", "API must be called with POST method");
        out.print(ob.toString());
        return;
    }

    String id = request.getParameter("id");
    String quizid = request.getParameter("quizid");
    String question = request.getParameter("question");
    String ans1 = request.getParameter("ans1");
    String ans2 = request.getParameter("ans2");
    String ans3 = request.getParameter("ans3");
    String ans4 = request.getParameter("ans4");
    String correctans = request.getParameter("correctans");

    if (id == null || quizid == null || question == null || ans1 == null || ans2 == null || ans3 == null || ans4 == null || correctans == null
            || id.trim().equals("") || quizid.trim().equals("") || question.trim().equals("") || ans1.trim().equals("")
            || ans2.trim().equals("") || ans3.trim().equals("") || ans4.trim().equals("") || correctans.trim().equals("")) {

        JSONObject ob = new JSONObject();
        ob.put("status", "Error");
        ob.put("message", "All fields are required");
        out.print(ob.toString());
        return;
    }

    DatabaseConnection db = new DatabaseConnection();
    String cmd = "UPDATE question SET "
            + "quizid='" + quizid + "', "
            + "question='" + question + "', "
            + "ans1='" + ans1 + "', "
            + "ans2='" + ans2 + "', "
            + "ans3='" + ans3 + "', "
            + "ans4='" + ans4 + "', "
            + "correctans='" + correctans + "' "
            + "WHERE id='" + id + "'";

    JSONObject ob = new JSONObject();
    if (db.executeIUD(cmd)) {
        ob.put("status", "Success");
        ob.put("message", "Question updated successfully");
    } else {
        ob.put("status", "Error");
        ob.put("message", "Question not updated");
    }
    out.print(ob.toString());
%>
