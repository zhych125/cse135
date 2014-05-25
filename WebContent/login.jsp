<%@ page import="data.users"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
<%
String name=null;
if(request.getParameter("user")!=null) {
	name=request.getParameter("user");
} 
%>
<% 
users user=new users();
user.setName(name);
users result=null;
try{
	result=users.fetchUser(user);
} catch(Exception e) {
	session.setAttribute("login_error", e.getMessage());
	response.sendRedirect("welcome.jsp");
}
if (result!=null) {
	session.setAttribute("user", result);
       if(result.getRole().equals("owner")) {
           response.sendRedirect("categories.jsp");

       } else {
       	response.sendRedirect("product_browsing.jsp"); 
       }
} else {
	session.setAttribute("login_error", "The provided name " + name+ " is not known");
	response.sendRedirect("welcome.jsp");
}

%>
</body>
</html>