<%@ page import="data.users"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
<%@ include file="login.html"%>
<%
String name=null;
if(request.getParameter("user")!=null) {
	name=request.getParameter("user");
} 
%>
<% 
users user=new users();
user.setName(name);
try{
	users result=users.checkUser(user);
	if (result!=null) {
		session.setAttribute("user", result);
        if(result.getRole().equals("owner")) {
%>
<jsp:forward page="categories.jsp" />
<%
        } else {
%>
<jsp:forward page="product_browsing.jsp" />
<%
        }
	} else {
		%>
<p>User doesn't exists,please signup first!</p>
<%
	}
} catch(Exception e) {
	out.println(e.getMessage());
}
%>
</body>
</html>