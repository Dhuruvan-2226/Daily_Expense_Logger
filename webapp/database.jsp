<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Database Insert</title>
    <style type="text/css">
    body {
  background-color: gold;
  color: black;
  font-style: italic;
}
    </style>
</head>
<body>
<%
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String suggestion = request.getParameter("message");

    String url = "jdbc:mysql://localhost:3306/WADjPRO";
    String username = "root";
    String pass = "dhuru@22";
    String query = "INSERT INTO suggest (email, name, suggestion) VALUES (?, ?, ?)";
    
    try {
    	Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(url, username, pass);
        PreparedStatement pst = con.prepareStatement(query);
        pst.setString(1, email);
        pst.setString(2, name);
        pst.setString(3, suggestion);
        
        int rows = pst.executeUpdate();
        if (rows >= 1) {
            out.println("Your suggestion has been submitted successfully!");
        } else {
            out.println("Failed to submit your suggestion.");
        }
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("SQL Error: " + e.getMessage());
    } catch (Exception e) {
        e.printStackTrace();
        out.println("An error occurred: " + e.getMessage());
    }
%>
</body>
</html>
