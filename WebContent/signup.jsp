<%@ page import="data.users" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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