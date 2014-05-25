<%@ page import="data.*,java.util.ArrayList,java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
<head>
<link type="text/css" rel="stylesheet" href="stylesheet.css"/>
<title>Products</title>
</head>
<body>
	<!--user identity  -->
	<%
    users user=null;
    if(session.getAttribute("user")!=null) {
        user=(users)session.getAttribute("user");
        String role=user.getRole();
        if(role.equals("customer")) {
        	session.setAttribute("user_error", "Customer can't log in as Owner");
        	response.sendRedirect("user_error.jsp");
        }
    %>
	<h1>
		Hello
		<%=user.getName() %>
		!
	</h1>
	<jsp:include page="navigation.jsp">
		<jsp:param name="role" value="<%=role%>" />
	</jsp:include>
	<%
    } else {
        response.sendRedirect("user_error.jsp");
    } %>

	<!--get categories  -->
	<% 
  int cid=0;
  if(request.getParameter("cid")!=null) {
	cid  =Integer.parseInt(request.getParameter("cid"));
  }
  ArrayList<categories> categoryList=categories.listAll();
  HashMap<Integer,categories> categoryMap=new HashMap<Integer,categories>();
  for(categories category:categoryList) {
	  categoryMap.put(category.getId(), category);
  }
%>
	<jsp:include page="sidebar.jsp">
		<jsp:param name="page" value="products" />
	</jsp:include>
	<jsp:include page="search.jsp">
		<jsp:param name="page" value="products" />
	</jsp:include>

	<!--request parameter parsing  -->
	<%
int pid=0;
if(request.getParameter("pid")!=null) {
	pid=Integer.parseInt(request.getParameter("pid"));
}
String regex = "[0-9]+";	
String SKU=null;
if(request.getParameter("SKU")!=null
&&!request.getParameter("SKU").equals("")
&&request.getParameter("SKU").matches(regex)) {
    SKU=request.getParameter("SKU");
}

String name=null;	
if (request.getParameter("name")!=null&&!request.getParameter("name").equals("")) {
    name=request.getParameter("name");
}

int category_id=0;
if(request.getParameter("category")!=null) {
    category_id=Integer.parseInt(request.getParameter("category"));
}
int price=0;
if(request.getParameter("price")!=null&&!request.getParameter("price").equals("")) {
    price=products.priceToInt(request.getParameter("price"));
}

/*request action parsing  */
String action=request.getParameter("action");
if(action!=null&&action.equals("insert")) {
	products product=new products();
	product.setName(name);
	product.setSKU(SKU);
    product.setCid(category_id);
	product.setPrice(price);
	try{
		   products.addProduct(product);
		   out.println("product " +product.getName()+" has been successfully added");
	} catch(Exception e) {
		out.println("Failure to insert new product");
	}
} else if (action!=null&&action.equals("update")) {
	products product=new products();
	product.setId(pid);
    product.setName(name);
	product.setSKU(SKU);
    product.setCid(category_id);
    product.setPrice(price);

    try{
        products.updateProduct(product);
        out.println("product " +product.getName()+" has been successfully updated");
    } catch(Exception e) {
    	out.println("Failure to update product");
    }
} else if(action!=null&&action.equals("delete")) {
	try{
		products.deleteProduct(pid);
		out.println("product " +name+" has been successfully deleted");
	} catch(Exception e) {
		out.println("Failure to delete product");
	}
}

/* search action  */
String search=null;
if (request.getParameter("search")!=null) {
    search=request.getParameter("search");
}
ArrayList<products> productList=null;
if (search==null) {
    productList=products.listProducts(cid);
} else {
    productList=products.searchProducts(cid, search);
}
%>

	<!--presentation -->
	<table>
		<tr id="product">
			<th>Name</th>
			<th>SKU</th>
			<th>Category</th>
			<th>Price</th>
		</tr>
		<% 

for (products product:productList) {
        if(categoryMap.containsKey(product.getCid())) {
%>
		<tr id="product">
			<form action="products.jsp?id=<%=cid %>" method="POST">
				<input name="action" type="hidden" value="update" /> 
				<input name="pid" type="hidden" value="<%=product.getId() %>" />
				<td><input name="name" type="text"
					value="<%=product.getName() %>" /></td>
				<td><input name="SKU" type="text"
					value="<%=product.getSKU() %>" /></td>
				<td><select name="category">
						<% for (categories category:categoryList) { %>
						<option value="<%=category.getId()%>"
							<%if(product.getCid()==category.getId()) { %>
							selected="selected" <%} %>>
							<%=category.getName() %></option>
						<% } %>
				</select></td>

				<td>$<input name="price" type="text"
					value="<%=products.intToPrice(product.getPrice()) %>" /></td>
				<td><div class="button"><input type="submit" value="Update" /></div></td>
			</form>
			<form action="products.jsp?id=<%=cid %>" method="POST">
				<input name="action" type="hidden" value="delete" />
				 <input name="pid" type="hidden" value="<%=product.getId() %>" />
				 <input name="name" type="hidden" value="<%=product.getName() %>" />
				<td><div class="button"><input type="submit" value="Delete" /></div></td>
			</form>
		</tr>
		<%
        }
}
%>
		<tr id="product">
			<form action="products.jsp?id=<%=cid %>" method="POST">
				<input name="action" type="hidden" value="insert" />
				<td><input name="name" type="text" /></td>
				<td><input name="SKU" type="text" /></td>
				<td><select name="category">
						<% for (categories category:categoryList) { %>
						<option value="<%=category.getId()%>"
							<% if (cid==category.getId()) {%> selected="selected" <%} %>>
							<%=category.getName() %></option>
						<% } %>
				</select></td>
				<td>$<input name="price" type="text" /></td>
				<td><div class="button"><input type="submit" value="Insert" /></div></td>
			</form>
		</tr>
	</table>

</body>
</html>