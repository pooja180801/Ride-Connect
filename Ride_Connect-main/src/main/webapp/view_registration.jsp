<%@ page import="com.services.authentication.AuthenticationUtil" %>
<%
if (!AuthenticationUtil.isAuthenticated(request)) {
    // If the user is not authenticated, redirect to the login page
    response.sendRedirect("index.jsp"); // Replace "login.jsp" with your login page URL
}
%>
<%@page import="com.services.database.DatabaseConnection"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@include file="structure.jsp"%>

<h4>All Reservations</h4>

<%
try {
    String username = (String) request.getSession().getAttribute("username");
    DatabaseConnection dbConnection = new DatabaseConnection();
    Connection connection = dbConnection.getConnection();
    PreparedStatement ps = connection.prepareStatement("SELECT * FROM vehicle_service WHERE username=?");
    ps.setString(1, username);
    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
%>
<table>
    <thead>
        <tr>
            <th>Booking ID</th>
            <th>Date</th>
            <th>Time</th>
            <th>Location</th>
            <th>Vehicle Number</th>
            <th>Mileage</th>
            <th>Message</th>
            <th></th>
        </tr>
    </thead>
    <tbody>
        <%
        do {
        %>
        <tr>
            <td><%= rs.getString(1) %></td>
            <td><%= rs.getString(2) %></td>
            <td><%= rs.getString(3) %></td>
            <td><%= rs.getString(4) %></td>
            <td><%= rs.getString(5) %></td>
            <td><%= rs.getString(6) %></td>
            <td><%= rs.getString(7) %></td>
        </tr>
        <%
        } while (rs.next());
        %>
    </tbody>
</table>
<%
    } else {
%>
<p>No reservations found.</p>
<%
    }
    rs.close(); // Close the ResultSet.
    dbConnection.closeConnection(connection); // Close the database connection.
} catch (Exception e) {
    // Handle exceptions here, e.g., display an error message or log the exception.
    e.printStackTrace();
}
%>
