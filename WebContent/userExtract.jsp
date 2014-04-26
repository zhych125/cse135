<%@ page import="data.users" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<p>
<%
    users user=(users)session.getAttribute("user");
%>
Welcome <%=user.getName() %> !
</p>
