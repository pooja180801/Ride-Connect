package com.services.database;


	

	import java.io.FileNotFoundException;
	import java.io.IOException;
	import java.io.InputStream;
	import java.sql.Connection;
	import java.sql.DriverManager;
	import java.sql.SQLException;
	import java.util.Properties;


		public class DatabaseConnection {
		    private static String url = "jdbc:mysql://172.187.178.153:3306/isec_assessment2";
		    private static String username = "isec";
		    private static String password = "EUHHaYAmtzbv";

		    public DatabaseConnection() {
		       
		    }

		    public static Connection getConnection() {
		        Connection connection = null;
		        try {
		            // Load the JDBC driver
		            Class.forName("com.mysql.cj.jdbc.Driver");

		            // Establish the connection
		            connection = DriverManager.getConnection(url, username, password);
		        } catch (ClassNotFoundException e) {
		            e.printStackTrace();
		        } catch (SQLException e) {
		            e.printStackTrace();
		        }
		        return connection;
		    }


		    public  void closeConnection(Connection connection) {
		        if (connection != null) {
		            try {
		                connection.close();
		            } catch (SQLException e) {
		                e.printStackTrace(); // Handle errors appropriately
		            }
		        }
		    }
		}



