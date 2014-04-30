<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<div id="nav" style="background-color:#00BBFF">
	<ul>
		<%
   if (request.getParameter("role").equals("owner")) { %>
		<li><a href="categories.jsp" style="text-decoration:none">Categories</a></li>
		<li><a href="products.jsp" style="text-decoration:none">Product</a></li>
		<li><a href="product_browsing.jsp" style="text-decoration:none">Product Browsing</a></li>
		<%} else { %>
		<li><a href="product_browsing.jsp" style="text-decoration:none">Product Browsing</a></li>
		<li><a href="shopping_cart.jsp" style="text-decoration:none">Buy Shopping Cart</a></li>
		<%} %>
	</ul>
</div>