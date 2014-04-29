<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link type="text/css" rel="stylesheet" href="stylesheet.css"/>
<title>User Error</title>
</head>
<body>
	<%
    if(session.getAttribute("user_error")!=null) {
    	String user_error=(String)session.getAttribute("user_error");
    	session.removeAttribute("user_error");
%>
	<p class="error"><%=user_error %></p>
	<% 

    } else {
%>
	<p class="error">Please log in first</p>
	<% 
    }
%>

	<p>
		<a href="welcome.jsp">log in</a>
	</p>
</body>
</html>