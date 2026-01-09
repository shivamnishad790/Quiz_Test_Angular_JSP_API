/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.quizapi;

import java.sql.*;

public class DatabaseConnection {

    Connection con;

    public DatabaseConnection() {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/apiquiztest", "root", "root");
        } catch (Exception ex) {

        }
    }

    public boolean executeIUD(String cmd) {
        int x = 0;
        try {
            Statement stmt = con.createStatement();
            x = stmt.executeUpdate(cmd);
        } catch (Exception ex) {
            x = 0;
        }
        return x > 0;
    }

    public ResultSet executeSelect(String cmd) {
        ResultSet rs = null;
        try {
            Statement stmt = con.createStatement();
            rs = stmt.executeQuery(cmd);
        } catch (Exception ex) {
            rs = null;
        }
        return rs;
    }

}