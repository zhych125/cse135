<%@ page import="data.users" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%@ include file="login.html" %>
    <%
        String name=request.getParameter("user");
        String age=request.getParameter("age");
        String role = request.getParameter("role");
        String state = request.getParameter("state");
        try{
            users.addUser(name,age,role,state);
    %>
        <p><%=name %> has successfully signed up!</p>
        
    <%
        }catch(Exception e) {
        	out.println(e.getMessage());
        }
    %>

</body>
</html>