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
	ArrayList<carts> cart = null;
	
    try{
    	cart = carts.listCart(user);
    } catch(Exception e) {
        
    }
     %>

	<!--control code-->
	<% 
    products newProduct=null;
    String action=request.getParameter("action");
    if(action!=null&&action.equals("add_order")) {
    	newProduct=new products(); 
    	newProduct.setId(Integer.parseInt(request.getParameter("pid")));
    	newProduct.setName(request.getParameter("name"));
    	newProduct.setSKU(request.getParameter("SKU"));
    	newProduct.setCategory(request.getParameter("category"));
    	newProduct.setCid(Integer.parseInt(request.getParameter("category_id")));
    	newProduct.setPrice(Integer.parseInt(request.getParameter("price")));
    } else if(action!=null&&action.equals("confirm_add")) {
    	products added=new products(); 
	    added.setId(Integer.parseInt(request.getParameter("pid")));
	    added.setPrice(Integer.parseInt(request.getParameter("price")));
    	int requestQuantity=0;
    	try {
    		requestQuantity=Integer.parseInt(request.getParameter("quantity"));
    		if(requestQuantity>0){
                carts.addToCart(user, added, requestQuantity);
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
     for(carts item:cart) {
    	   
     %>
		<tr>

			<td><%=item.getProduct().getName() %></td>
			<td><%=item.getProduct().getSKU() %></td>
			<td><%=item.getProduct().getCategory()%></td>
			<td>$<%=products.intToPrice(item.getProduct().getPrice()) %>
			</td>
			<td><%=item.getQuantity() %></td>
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
			<td><input type="text" size="4" name="quantity" value="1" /></td>
			<input type="hidden" name="action" value="confirm_add" />
			<input type="hidden" name="pid" value="<%=newProduct.getId() %>" />
			<input type="hidden" name="price" value="<%=newProduct.getPrice() %>"/>
			<td><div class="button"><input type="submit" /></div></td>
			</form>
        </tr>
			<% }%>
	</table>	
</body>
</html>