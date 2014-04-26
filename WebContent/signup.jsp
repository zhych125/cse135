<%@ page import="data.users" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
<%@ include file="login.html" %>
    <%
        users user=new users();
        user.setName(request.getParameter("user"));
        user.setAge(Integer.parseInt(request.getParameter("age")));
        user.setRole(request.getParameter("role"));
        user.setState(request.getParameter("state"));
        try{
            users.addUser(user);
    %>
        <p><%=user.getName() %> has successfully signed up!</p>
        
    <%
        }catch(Exception e) {
        	out.println(e.getMessage());
        }
    %>

</body>
</html>