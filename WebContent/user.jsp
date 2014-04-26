<%@ page import="data.users"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<h1>
	<%
	users user=null;
	if(session.getAttribute("user")!=null) {
		user=(users)session.getAttribute("user");

	%>
	Welcome
    <%=user.getName() %>
    !
	<jsp:include page="navigation.jsp">
    <jsp:param name="role" value="<%=user.getRole()%>" />
    </jsp:include>
	<%
	} else {
        response.sendRedirect("login.html");
    } %>
</h1>
