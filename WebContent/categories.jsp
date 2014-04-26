<%@ page import="data.*,java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
<head>
<title>Categories</title>
</head>
<body>
	<%@ include file="user.jsp"%>
	<%
int category_id=0;
if(request.getParameter("category_id")!=null) {
	category_id=Integer.parseInt(request.getParameter("category_id"));
}
String name=null;
if(request.getParameter("name")!=null&&!request.getParameter("name").equals("")) {
	name=request.getParameter("name");
}
String action=request.getParameter("action");
if(action!=null&&action.equals("insert")) {
	categories category=new categories();
	category.setName(name);
	category.setDescription(request.getParameter("description"));
	try {
		   categories.save(category);
	} catch (Exception e){
		out.println(e.getMessage());
	}
} else if(action!=null&&action.equals("update")) {
	categories category=new categories();
	category.setId(category_id);
	category.setName(name);
	category.setDescription(request.getParameter("description"));
	try {
		categories.update(category);
	} catch(Exception e) {
		out.println(e.getMessage());
	}
} else if(action!=null&&action.equals("delete")) {
	try {
		categories.delete(category_id);
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
			<form action="categories.jsp" method="POST">
				<input name="action" type="hidden" value="update" /> <input
					name="category_id" type="hidden" value="<%=category.getId() %>" />
				<td><input name="name" type="text"
					value="<%=category.getName() %>" /></td>
				<td><textarea name="description"><%=category.getDescription() %></textarea></td>
				<td><input type="submit" value="Update" /></td>
			</form>
			<%if(products.listProducts(category.getId()).size()==0) { %>
			<form action="categories.jsp" method="POST">
				<input name="action" type="hidden" value="delete" /> <input
					name="category_id" type="hidden" value="<%=category.getId() %>" />
				<td><input type="submit" value="Delete" /></td>
			</form>
			<%} %>
		</tr>
		<%
}
%>
		<tr>
			<form action="categories.jsp" method="POST">
				<input name="action" type="hidden" value="insert" />
				<td><input name="name" type="text" /></td>
				<td><textarea name="description"></textarea></td>
				<td><input type="submit" value="Insert" /></td>
			</form>
		</tr>
	</table>
</body>
</html>