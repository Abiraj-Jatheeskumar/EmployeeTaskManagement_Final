<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="app.classes.DbConnector" %>
<%@ page import="app.classes.Files" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete File</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            background-color: #f0f2f5; 
            margin: 0;
            font-family: 'Arial', sans-serif;
        }

        .card-container {
            max-width: 800px;
            width: 100%;
            background-color: #ffffff;
            border-radius: 15px;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
            padding: 20px;
            margin: 20px;
            transition: box-shadow 0.3s, transform 0.5s, opacity 0.5s;
            opacity: 0;
            transform: scale(0.9);
            animation: fadeInUp 0.5s forwards;
        }

        .card-container:hover {
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.3);
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: scale(0.9);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }

        .btn-primary {
            background-color: #343a40;
            border: none;
            border-radius: 5px;
            transition: background-color 0.3s, transform 0.2s;
        }

        .btn-primary:hover {
            background-color: #a777e3;
            transform: scale(1.05); 
        }

        .alert {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="card-container">
        <h1>Delete File</h1>
        <%
            Connection conn = null;
            try {
                int fileId = Integer.parseInt(request.getParameter("file_id"));
                
                conn = DbConnector.getConnection();
                if (conn == null) {
                    throw new SQLException("Failed to establish a connection to the database.");
                }
                
                Files.deleteFileById(conn, fileId); 

                out.println("<div class='alert alert-success'>File deleted successfully!</div>");
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<div class='alert alert-danger'>An error occurred: " + e.getMessage() + "</div>");
            } finally {
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
        %>
        <a href="home.jsp" class="btn btn-primary">Back to Home</a>
    </div>
</body>
</html>
