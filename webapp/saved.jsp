<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.*, java.util.ArrayList, java.util.HashMap" %>
 <%@ page import="java.sql.*" %>
<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Saved Expenses</title>

    <style>

        .topnav a {

            float: right;

            color: black;

            padding: 14px 16px;

            font-size: 17px;

            text-decoration: underline;

        }

        

        .topnav {

            overflow: hidden;

        }

        

        .topnav a:hover {

            background-color: white;

            color: black;

        }

        

        .topnav a.active {

            background-color: yellow;

        }

        

        body {

            background-color: gold;

            color: black;

            font-style: italic;

        }

        

        h1, h2 {

            text-align: center;

            text-decoration: underline;

            margin-top: 50px;

        }
        .summary {
			display:flex;
			justify-content:space-between;        
        }

    </style>

</head>

<body>

    <div class="topnav">

        <a href="about.html">About Us</a>

        <a href="contact.html">Contact Us</a>

        <a class="active" href="saved.jsp">Saved</a>

        <a href="main.html">Home</a>

    </div>

    <h1>Daily Expense Logger</h1>

    <h2>Your Saved Expenses at a Glance</h2>

    <%

        String category = request.getParameter("category");

        String name = request.getParameter("pname");

        String date = request.getParameter("pdate");

        String details = request.getParameter("details");

        long amount = 0;



        if (request.getParameter("amount") != null && !request.getParameter("amount").isEmpty()) {

            amount = Long.parseLong(request.getParameter("amount"));

        }

        if (date == null || date.isEmpty()) date = "No date provided";

        if (details == null || details.isEmpty()) details = "No details provided";

        ArrayList<HashMap<String, String>> expenseList = 

            (ArrayList<HashMap<String, String>>) session.getAttribute("expenseList");

        if (expenseList == null) {

            expenseList = new ArrayList<>();

            session.setAttribute("expenseList", expenseList);

        }
        if (category != null && name != null && request.getParameter("amount") != null) {

            HashMap<String, String> expense = new HashMap<>();

            expense.put("category", category);

            expense.put("name", name);

            expense.put("date", date);

            expense.put("amount", String.valueOf(amount));

            expense.put("details", details);

            expenseList.add(expense);

        }
        long totalAmount=0;
        for (HashMap<String, String> expense : expenseList)
            totalAmount += Long.parseLong(expense.get("amount"));
        
        String url="jdbc:mysql://localhost:3306/WADjPRO";
        String username="root";
        String pass="dhuru@22";
        String query="INSERT INTO expenses (category, name, date, amount, details) VALUES (?, ?, ?, ?, ?)";
        try{
        	Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con=DriverManager.getConnection(url,username,pass);
        PreparedStatement pst=con.prepareStatement(query);
        pst.setString(1,category);
        pst.setString(2, name);
        pst.setString(3,date);
        pst.setLong(4,amount);
        pst.setString(5,details);
        int rows=pst.executeUpdate();
        if(rows>=1)
        {
        	System.out.println("Inserted");
        }
        else
        {
        	System.out.println("Not Inserted");
        }
        pst.close();
        con.close();
        }
        catch (ClassNotFoundException e) {
            e.printStackTrace();
            System.out.println("MySQL JDBC Driver not found.");
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("SQL Exception: " + e.getMessage());
        }
    %>

    
<div class="summary">
    <h3>Saved Expenses</h3>
	<h3>Totally Spent:<%=totalAmount %></h3></div>
    <table border="1" cellpadding="10" cellspacing="0" style="width:80%; margin: 0 auto; text-align:center;">

        <tr>

            <th>Category</th>

            <th>Name</th>

            <th>Date</th>

            <th>Amount</th>

            <th>Details</th>

        </tr>

        <%

            for (HashMap<String, String> expense : expenseList) {

        %>

            <tr>

                <td><%= expense.get("category") %></td>

                <td><%= expense.get("name") %></td>

                <td><%= expense.get("date") %></td>

                <td><%= expense.get("amount") %></td>

                <td><%= expense.get("details") %></td>

            </tr>
        <%
            }

        %>
    </table>
</body>
</html>

