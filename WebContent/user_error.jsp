<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>User Error</title>
</head>
<body>
<%
    if(session.getAttribute("user_error")!=null) {
    	String user_error=(String)session.getAttribute("user_error");
    	session.removeAttribute("user_error");
%>
    <h1><%=user_error %></h1>
<% 

    } else {
%>
    <h1>Please log in first</h1>
<% 
    }
%>

    <h2><a href="welcome.jsp">log in</a></h2>
</body>
</html>