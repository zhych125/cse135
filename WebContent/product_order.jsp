<%@ page import="data.*,java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
<head>
<link type="text/css" rel="stylesheet" href="stylesheet.css"/>
<title>Product Order</title>
</head>
<body>
	<!--check user identity  -->
	<%
    users user=null;
    String role=null;
    if(session.getAttribute("user")!=null) {
        user=(users)session.getAttribute("user");
        role=user.getRole();
        if(!role.equals("customer")) {
        	session.setAttribute("user_error", "Owner can't order, please "
        			+"log in using owner's account");
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


	<!--get products that are already ordered  -->
	<%
     HashMap<Integer,products> productsMap;
     if (session.getAttribute("product_order")==null) {
           productsMap=new HashMap<Integer,products>();
     } else {
           productsMap=(HashMap<Integer,products>)session.getAttribute("product_order");
     }
     %>

	<!--control code-->
	<% 
    products newProduct=null;
    String action=request.getParameter("action");
    if(action!=null&&action.equals("add_order")) {
    	newProduct=new products(); 
    	newProduct.setId(Integer.parseInt(request.getParameter("product_id")));
    	newProduct.setName(request.getParameter("name"));
    	newProduct.setSKU(request.getParameter("SKU"));
    	newProduct.setCategory_id(Integer.parseInt(request.getParameter("category_id")));
    	newProduct.setCategory(request.getParameter("category"));
    	newProduct.setPrice(Integer.parseInt(request.getParameter("price")));
    } else if(action!=null&&action.equals("confirm_add")) {
    	products added=null;
    	if(productsMap.containsKey(Integer.parseInt(request.getParameter("product_id")))) {
    		added=productsMap.get(Integer.parseInt(request.getParameter("product_id")));
    	} else {
    		 added=new products(); 
    		 added.setId(Integer.parseInt(request.getParameter("product_id")));
	         added.setName(request.getParameter("name"));
	         added.setSKU(request.getParameter("SKU"));
	         added.setCategory_id(Integer.parseInt(request.getParameter("category_id")));
	         added.setCategory(request.getParameter("category"));
	         added.setPrice(Integer.parseInt(request.getParameter("price")));
    	}
    	int requestAmount=0;
    	try {
    		requestAmount=Integer.parseInt(request.getParameter("number"));
    	} catch (Exception e){
    		out.println("Not valid amount");
    	}
    	if(requestAmount>0){
    		added.setNum(requestAmount+added.getNum());
            productsMap.put(Integer.parseInt(request.getParameter("product_id")), added);
        }
        session.setAttribute("product_order", productsMap);
        response.sendRedirect("product_browsing.jsp");
    }
%>

	<!--presentation  -->
	<table class="table_browsing">
		<tr>
			<th>Name</th>
			<th>SKU</th>
			<th>Category</th>
			<th>Price</th>
			<th>Number</th>
		</tr>
		<%
     for(products product:productsMap.values()) {
     %>
		<tr>

			<td><%=product.getName() %></td>
			<td><%=product.getSKU() %></td>
			<td><%=product.getCategory()%></td>
			<td>$<%=products.intToPrice(product.getPrice()) %>
			</td>
			<td><%=product.getNum() %></td>
		</tr>
		<%
     }
     if (newProduct!=null) {
%>

		<tr>
			<td><%=newProduct.getName() %></td>
			<td><%=newProduct.getSKU() %></td>
			<td><%=newProduct.getCategory()%></td>
			<td>$<%=products.intToPrice(newProduct.getPrice()) %></td>
			<form action="product_order.jsp" method="POST">
			<td><input type="text" size="4" name="number" value="1" /></td>
			<input type="hidden" name="action" value="confirm_add" />
			<input type="hidden" name="product_id"
				value="<%=newProduct.getId()%>" />
			<input type="hidden" name="name" value="<%=newProduct.getName() %>" />
			<input type="hidden" name="SKU" value="<%=newProduct.getSKU() %>" />
			<input type="hidden" name="category"
				value="<%=newProduct.getCategory() %>" />
			<input type="hidden" name="category_id"
				value="<%=newProduct.getCategory_id() %>" />
			<input type="hidden" name="price" value="<%=newProduct.getPrice() %>" />
			<td><div class="button"><input type="submit" /></div></td>
			</form>
        </tr>
			<% }%>
	</table>	
</body>
</html>