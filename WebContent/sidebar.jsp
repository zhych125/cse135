<%@ page import="data.categories,java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<table class="sidebar">
	<tr>
		<% if(request.getParameter("page").equals("products")) {%>
		<a href="products.jsp">All Categories</a>
		<% }else { %>
		<a href="product_browsing.jsp">All Categories</a>
		<%} %>
	</tr>
	<br />
	<%
        ArrayList<categories> categoryList=categories.listAll();
        for (categories category:categoryList) {
    %>
	<tr>
		<% if(request.getParameter("page").equals("products")) {%>
		<a href="products.jsp?id=<%=category.getId() %>"><%=category.getName() %></a>
		<% }else { %>
		<a href="product_browsing.jsp?id=<%=category.getId() %>"><%=category.getName() %></a>
		<%} %>
	</tr>
	<br />

	<%
    }
    %>
</table>