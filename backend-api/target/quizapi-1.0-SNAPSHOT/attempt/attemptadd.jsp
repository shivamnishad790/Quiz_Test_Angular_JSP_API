<%@page import="java.sql.ResultSet"%>
<%@page import="com.mycompany.quizapi.DatabaseConnection"%>
<%@page import="org.json.JSONObject"%>
<%@page contentType="application/json" pageEncoding="UTF-8"%>

<%
    // ================= CORS =================
    response.setHeader("Access-Control-Allow-Origin", "*");
    response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
    response.setHeader("Access-Control-Allow-Headers", "Content-Type");
    response.setHeader("Access-Control-Max-Age", "86400");

    // ================= OPTIONS =================
    if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
        response.setStatus(200);
        return;
    }

    // ================= POST CHECK =================
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        JSONObject ob = new JSONObject();
        ob.put("status", "error");
        ob.put("message", "Only POST allowed");
        out.print(ob.toString());
        return;
    }

    // ================= READ PARAMS =================
    String name = request.getParameter("name");
    String mobile = request.getParameter("mobile");
    String email = request.getParameter("email");
    String collegename = request.getParameter("collegename");
    String quizcode = request.getParameter("quizcode");

    if (name == null || mobile == null || email == null || collegename == null || quizcode == null
            || name.trim().equals("") || mobile.trim().equals("") || email.trim().equals("")
            || collegename.trim().equals("") || quizcode.trim().equals("")) {

        JSONObject ob = new JSONObject();
        ob.put("status", "error");
        ob.put("message", "All fields required");
        out.print(ob.toString());
        return;
    }

    DatabaseConnection db = new DatabaseConnection();

    // ================= INSERT =================
    String insertSql
            = "INSERT INTO attempt(name,mobile,email,collegename,quizcode,date,time,correct,wrong,totalquestions) "
            + "VALUES('" + name + "','" + mobile + "','" + email + "','" + collegename + "','" + quizcode
            + "', NOW(), NOW(), 0, 0, 0)";

    if (db.executeIUD(insertSql)) {

        // ================= GET LAST INSERT ID =================
        ResultSet rs = db.executeSelect("SELECT LAST_INSERT_ID() AS id");
        int attemptId = 0;

        if (rs.next()) {
            attemptId = rs.getInt("id");
        }

        JSONObject ob = new JSONObject();
        ob.put("status", "success");
        ob.put("message", "Attempt started successfully");
        ob.put("id", attemptId);   // 🔥 IMPORTANT
        out.print(ob.toString());

    } else {
        JSONObject ob = new JSONObject();
        ob.put("status", "error");
        ob.put("message", "Database insert failed");
        out.print(ob.toString());
    }
%>
