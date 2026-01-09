<%-- 
    Document   : attemptsubmit
    Created on : 10 Dec 2025, 9:13:06 pm
    Author     : kshiv
--%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.mycompany.quizapi.DatabaseConnection"%>
<%@page contentType="application/json" pageEncoding="UTF-8"%>

<%
    // ===== CORS =====
    response.setHeader("Access-Control-Allow-Origin", "*");
    response.setHeader("Access-Control-Allow-Methods", "POST, OPTIONS");
    response.setHeader("Access-Control-Allow-Headers", "Content-Type");

    if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
        return;
    }

    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        out.print("{\"status\":\"Error\",\"message\":\"POST only\"}");
        return;
    }

    String attemptid = request.getParameter("attemptid");
    String answersStr = request.getParameter("answers");

    if (attemptid == null || answersStr == null) {
        out.print("{\"status\":\"Error\",\"message\":\"Missing params\"}");
        return;
    }

    DatabaseConnection db = new DatabaseConnection();

    int correct = 0;
    int wrong = 0;

    JSONArray answers = new JSONArray(answersStr);

    for (int i = 0; i < answers.length(); i++) {
        JSONObject obj = answers.getJSONObject(i);

        int qid = obj.getInt("questionid");
        String userans = obj.getString("userans");

        // fetch correct answer
        String qSql = "SELECT correctans FROM question WHERE id=" + qid;
        ResultSet rs = db.executeSelect(qSql);

        String correctAns = "";
        if (rs.next()) {
            correctAns = rs.getString("correctans");
        }

        boolean isCorrect = userans.equalsIgnoreCase(correctAns);

        if (isCorrect) {
            correct++;
        } else {
            wrong++;
        }

        // insert into attempt_answer
        String ins = "INSERT INTO attempt_answer(attemptid,questionid,userans,correctans,iscorrect) VALUES("
                + attemptid + ","
                + qid + ",'"
                + userans + "','"
                + correctAns + "',"
                + (isCorrect ? 1 : 0) + ")";

        db.executeIUD(ins);
    }

    int total = correct + wrong;

    // update attempt table
    String upd = "UPDATE attempt SET correct='" + correct + "', wrong='" + wrong
            + "', totalquestions='" + total + "' WHERE id=" + attemptid;

    db.executeIUD(upd);

    JSONObject res = new JSONObject();
    res.put("status", "Success");
    res.put("correct", correct);
    res.put("wrong", wrong);
    res.put("total", total);

    out.print(res.toString());
%>
