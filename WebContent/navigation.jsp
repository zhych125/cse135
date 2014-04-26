<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<nav>
	<ul>
		<%
   if (request.getParameter("role").equals("owner")) { %>
		<li><a href="categories.jsp">Categories</a></li>
		<li><a href="products.jsp">Product</a></li>
		<%} else { %>
		<li><a href="product_browsing.jsp">Product Browsing</a></li>
		<li><a href="shopping_cart.jsp">Buy Shopping Cart</a></li>
		<%} %>
	</ul>
</nav>