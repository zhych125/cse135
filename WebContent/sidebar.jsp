<%@ page import="data.categories,java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<ul class="sidebar">
	<li class="sidebarli">
		<% if(request.getParameter("page").equals("products")) {%>
		<a href="products.jsp" >All Categories</a>
		<% }else { %>
		<a href="product_browsing.jsp" >All Categories</a>
		<%} %>	
	</li>
	<%
        ArrayList<categories> categoryList=categories.listAll();
        for (categories category:categoryList) {
    %>
	<li class="sidebarli">
		<% if(request.getParameter("page").equals("products")) {%>
		<a href="products.jsp?cid=<%=category.getId() %>"><%=category.getName() %></a>
		<% }else { %>
		<a href="product_browsing.jsp?cid=<%=category.getId() %>" ><%=category.getName() %></a>
		<%} %>
	</li>

	<%
    }
    %>
</ul>