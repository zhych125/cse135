<%@ page import="data.users"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<%
        boolean signup=false;
        users user=new users();
        user.setName(request.getParameter("user"));
        if(request.getParameter("age")!=null&&!request.getParameter("age").equals("")) {
            user.setAge(Integer.parseInt(request.getParameter("age")));
        }
        user.setRole(request.getParameter("role"));
        user.setState(request.getParameter("state"));
        try{
            users.addUser(user);
            signup=true;
        }catch(Exception e) {
        	session.setAttribute("signup_error",e.getMessage());
        }
        session.setAttribute("signup", signup);
        session.setAttribute("signup_name",request.getParameter("user"));
        response.sendRedirect("welcome.jsp");
    %>