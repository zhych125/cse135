<%@ page import="data.*,java.util.ArrayList" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
<head>
<title>Category</title>
</head>
<body>
<%@ include file="userExtract.jsp" %>
<jsp:include page="navigation.jsp">
<jsp:param name="role" value="<%=user.getRole()%>"/>
</jsp:include>
<%
String action=request.getParameter("action");
if(action!=null&&action.equals("insert")) {
	categories category=new categories();
	category.setName(request.getParameter("name"));
	category.setDescription(request.getParameter("description"));
	try {
		   categories.save(category);
	} catch (Exception e){
		out.println(e.getMessage());
	}
} else if(action!=null&&action.equals("update")) {
	categories category=new categories();
	category.setId(Integer.parseInt(request.getParameter("id")));
	category.setName(request.getParameter("name"));
	category.setDescription(request.getParameter("description"));
	try {
		categories.update(category);
	} catch(Exception e) {
		out.println(e.getMessage());
	}
} else if(action!=null&&action.equals("delete")) {
	int id=Integer.parseInt(request.getParameter("id"));
	try {
		categories.delete(id);
	} catch(Exception e) {
		out.println(e.getMessage());
	}
}
%>
<table>
    <tr>
        <th>Category</th>
        <th>Description</th>
    </tr>
<% 
ArrayList<categories> list=categories.listAll();
for (categories category:list) {
%>
    <tr>
        <form action="category.jsp" method="POST">
            <input name="action" type="hidden" value="update"/>
            <input name="id" type="hidden" value="<%=category.getId() %>"/>
            <td><input name="name" type="text" value="<%=category.getName() %>"/></td>
            <td><textarea name="description" ><%=category.getDescription() %></textarea></td>
           <td><input type="submit" value="Update"/></td>
        </form>
        <form action="category.jsp" method="POST">
            <input name="action" type="hidden" value="delete"/>
            <input name ="id" type="hidden" value="<%=category.getId() %>"/>
            <td><input type="submit" value="Delete"/></td>
        </form>     
    </tr>
<%
}
%>
<tr>
<form action="category.jsp" method="POST">
    <input name="action" type="hidden" value="insert"/>
    <td><input name="name" type="text"/></td>
    <td><textarea name="description" ></textarea></td>
   <td><input type="submit" value="Insert"/></td>
</form>
</tr>
</table>
</body>
</html>