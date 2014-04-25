<%@ page import="data.users" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%@ include file="login.html" %>
<%
String name=request.getParameter("user");
%>
<% 
users user=new users();
user.setName(name);
try{
	users result=users.checkUser(user);
	if (result!=null) {
		session.setAttribute("user", result);
%>
<jsp:forward page="temp.jsp"/>
<%
	} else {
		%>
<p> User doesn't exists,please signup first!</p>
<%
	}
} catch(Exception e) {
	out.println(e.getMessage());
}
%>
</body>
</html>