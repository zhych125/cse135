<%@ page import="data.*,java.util.ArrayList"%>
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
	ArrayList<products> productsList=new ArrayList<products>();
    try{
     productsList=cart.getCart(user);
    } catch(Exception e) {
        
    }
     %>

	<!--control code-->
	<% 
    products newProduct=null;
    String action=request.getParameter("action");
    if(action!=null&&action.equals("add_order")) {
    	newProduct=new products(); 
    	newProduct.setName(request.getParameter("name"));
    	newProduct.setSKU(request.getParameter("SKU"));
    	newProduct.setCategory(request.getParameter("category"));
    	newProduct.setCategory_id(Integer.parseInt(request.getParameter("category_id")));
    	newProduct.setPrice(Integer.parseInt(request.getParameter("price")));
    } else if(action!=null&&action.equals("confirm_add")) {
    	products added=new products(); 
	         added.setSKU(request.getParameter("SKU"));
    	int requestAmount=0;
    	try {
    		requestAmount=Integer.parseInt(request.getParameter("number"));
    		if(requestAmount>0){
                added.setNum(requestAmount);
                cart.addToCart(added, productsList, user);
            }
    	} catch (Exception e){
    		out.println("Adding failed");
    	}
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
     for(products product:productsList) {
    	   
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
			<input type="hidden" name="SKU" value="<%=newProduct.getSKU() %>" />
			<td><div class="button"><input type="submit" /></div></td>
			</form>
        </tr>
			<% }%>
	</table>	
</body>
</html>