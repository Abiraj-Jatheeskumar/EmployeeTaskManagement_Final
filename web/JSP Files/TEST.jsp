<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%@ page import="app.classes.MD5" %>
<!DOCTYPE html>
<html>
<head>
    <title>MD5 Hash Test</title>
</head>
<body>
    <h1>MD5 Hash Test</h1>

    <%
        String password = "password123";
        String hash = MD5.getMd5(password);
        out.println("Password: " + password + "<br>");
        out.println("MD5 Hash: " + hash + "<br>");
        out.println("Hash Length: " + hash.length() + "<br>");
        
        String inputPassword = "123";
        String inputHash = MD5.getMd5(inputPassword);
        if (hash.equals(inputHash)) {
            out.println("Password verified");
        } else {
            out.println("Password not verified");
        }
    %>
</body>
</html>
