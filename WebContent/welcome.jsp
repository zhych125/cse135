<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
<p class="welcome">Welcome!</p>
<%@ include file="login.html"%>
<%
    if(session.getAttribute("signup")!=null) {
    	boolean signup=(Boolean) session.getAttribute("signup");
    	session.removeAttribute("signup");
    	String name=(String) session.getAttribute("signup_name");
    	session.removeAttribute("signup_name");
    	if(signup==true) {
%>
<p class="success"><%=name %> has successfully signup!
</p>
<%
    	} else {
    	String signup_error=(String) session.getAttribute("signup_error");
    	session.removeAttribute("signup_error");
%>
<p class="error">
	Signup unsuccessful with error message:
	<%=signup_error %></p>
<%
    	}
    } else if(session.getAttribute("login_error")!=null) {
        String login_error=(String) session.getAttribute("login_error");
        session.removeAttribute("login_error");
%>
<p class="error"><%=login_error %></p>
<%
    }
%>
</body>
</html>