<%@ page import="data.*,java.util.ArrayList,java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
<head>
<title>Products</title>
</head>
<body>
	<%@ include file="user.jsp"%>
	<% 
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
    <jsp:param name="page" value="products"/>
</jsp:include>
<jsp:include page="search.jsp">
    <jsp:param name="page" value="products"/>
</jsp:include>
	<%
int product_id=0;
if(request.getParameter("product_id")!=null)
	product_id=Integer.parseInt(request.getParameter("product_id"));	
String name=null;	
if (request.getParameter("name")!=null&&!request.getParameter("name").equals("")) {
    name=request.getParameter("name");
}
String SKU=null;
if(request.getParameter("SKU")!=null&&!request.getParameter("SKU").equals("")) {
    SKU=request.getParameter("SKU");
}
int category_id=0;
if(request.getParameter("category")!=null) {
    category_id=Integer.parseInt(request.getParameter("category"));
}
int price=0;
if(request.getParameter("price")!=null&&!request.getParameter("price").equals("")) {
    price=products.priceToInt(request.getParameter("price"));
}
String action=request.getParameter("action");
if(action!=null&&action.equals("insert")) {
	products product=new products();
	product.setName(name);
	product.setSKU(SKU);
    product.setCategory_id(category_id);
	product.setPrice(price);
	try{
		   products.addProduct(product);
	} catch(Exception e) {
		out.println(e.getMessage());
	}
} else if (action!=null&&action.equals("update")) {
	products product=new products();
    product.setId(product_id);
    product.setName(name);
	product.setSKU(SKU);
    product.setCategory_id(category_id);
    product.setPrice(price);

    try{
        products.updateProduct(product);
    } catch(Exception e) {
    	out.println(e.getMessage());
    }
} else if(action!=null&&action.equals("delete")) {
	try{
		products.deleteProduct(product_id);
	} catch(Exception e) {
		out.println(e.getMessage());
	}
}
%>

	<%
String search=null;
if (request.getParameter("search")!=null) {
    search=request.getParameter("search");
}
ArrayList<products> productList=null;
if (search==null) {
    productList=products.listProducts(id);
} else {
    productList=products.searchProducts(id, search);
}
%>
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
			<form action="products.jsp?id=<%=id %>" method="POST">
				<input name="action" type="hidden" value="update" /> <input
					name="product_id" type="hidden" value="<%=product.getId() %>" />
				<td><input name="name" type="text"
					value="<%=product.getName() %>" /></td>
				<td><input name="SKU" type="text"
					value="<%=product.getSKU() %>" /></td>
				<td>
					<select name="category">
						<% for (categories category:categoryList) { %>
						<option value="<%=category.getId()%>"
							<%if(product.getCategory_id()==category.getId()) { %>
							selected="selected" <%} %>>
							<%=category.getName() %></option>
						<% } %>
				</select>
				</td>

				<td>$<input name="price" type="text"
					value="<%=products.intToPrice(product.getPrice()) %>" /></td>
				<td><input type="submit" value="Update" /></td>
			</form>
			<form action="products.jsp?id=<%=id %>" method="POST">
				<input name="action" type="hidden" value="delete" /> <input
					name="product_id" type="hidden" value="<%=product.getId() %>" />
				<td><input type="submit" value="Delete" /></td>
			</form>
		</tr>
		<%
        }
}
%>
		<tr>
			<form action="products.jsp?id=<%=id %>" method="POST">
				<input name="action" type="hidden" value="insert" />
				<td><input name="name" type="text" /></td>
				<td><input name="SKU" type="text" /></td>
				<td>
					<select name="category">
						<% for (categories category:categoryList) { %>
						<option value="<%=category.getId()%>" 
						<% if (id==category.getId()) {%>
						selected="selected"
						<%} %>>
						<%=category.getName() %></option>
						<% } %>
				</select>
				</td>
				<td>$<input name="price" type="text" /></td>
				<td><input type="submit" value="Insert" /></td>
			</form>
		</tr>
	</table>

</body>
</html>