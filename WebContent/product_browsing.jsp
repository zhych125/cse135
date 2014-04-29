<%@ page import="data.*,java.util.ArrayList,java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link type="text/css" rel="stylesheet" href="stylesheet.css"/>
<title>Product Browsing</title>
</head>
<body>
	<!--user identity  -->
	<%
    users user=null;
    if(session.getAttribute("user")!=null) {
        user=(users)session.getAttribute("user");

    %>
	<h1>
		Hello
		<%=user.getName() %>
		!
	</h1>
	<jsp:include page="navigation.jsp">
		<jsp:param name="role" value="<%=user.getRole()%>" />
	</jsp:include>

	<!--get categories  -->
	<%
    } else {
    %>
    <p class="error" ><a href="welcome.jsp">log in</a></p>
    <%	
    }
  int id=0;
  if(request.getParameter("id")!=null) {
    id  =Integer.parseInt(request.getParameter("id"));
  }
  ArrayList<categories> categoryList=categories.listAll();
  HashMap<Integer,categories> categoryMap=new HashMap<Integer,categories>();
  for(categories category:categoryList) {
      categoryMap.put(category.getId(), category);
  }
%>
	<jsp:include page="sidebar.jsp">
		<jsp:param name="page" value="product_browsing" />
	</jsp:include>
	<jsp:include page="search.jsp">
		<jsp:param name="page" value="product_browsing" />
	</jsp:include>


	<!--search action  -->
	<%
String search=null;
if (request.getParameter("search")!=null) {
    search=request.getParameter("search");
}
ArrayList<products> productList=null;
if (search==null) {
    productList=products.listProducts(id);
} else {
	if(user!=null){
		productList=products.searchProducts(id, search);
	} else {
		productList=products.listProducts(id);
    %>
	<p class="error">
		Please login first <a href="welcome.jsp">login in</a>
	</p>
	<%
	}
}
%>

	<!--presentation  -->
	<table>
		<tr>
			<th>Name</th>
			<th>SKU</th>
			<th>Category</th>
			<th>Price</th>
		</tr>
		<% 

for (products product:productList) {
    if(categoryMap.containsKey(product.getCategory_id())) {
%>

		<tr>

			<td><%=product.getName() %></td>
			<td><%=product.getSKU() %></td>
			<td><%=categoryMap.get(product.getCategory_id()).getName() %></td>
			<td>$<%=products.intToPrice(product.getPrice()) %>
			</td>
			<td>
				<form action="product_order.jsp" method="POST">
					<input name="action" value="add_order" type="hidden" /> <input
						name="product_id" value="<%=product.getId()%>" type="hidden" /> <input
						name="name" value="<%=product.getName() %>" type="hidden" /> <input
						name="SKU" value="<%=product.getSKU() %>" type="hidden" /> <input
						name="category_id" value="<%=product.getCategory_id()%>"
						type="hidden" /> <input name="category"
						value="<%=categoryMap.get(product.getCategory_id()).getName()%>"
						type="hidden" /> <input name="price"
						value="<%=product.getPrice() %>" type="hidden" /> <input
						type="submit" value="Buy">
				</form>
			</td>

		</tr>

		<%
    }
}
%>
	</table>

</body>
</html>