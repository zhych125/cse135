<%@ page import="data.*,java.util.ArrayList" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
<head>
<link type="text/css" rel="stylesheet" href="stylesheet.css"/>
<title>Shopping Cart</title>
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
     session.setAttribute("orders", productsList);
    } catch(Exception e) {
    	
    }
     %>
     
        <!--presentation  -->
    <table class="table_browsing">
        <tr>
            <th>Name</th>
            <th>SKU</th>
            <th>Category</th>
            <th>Price</th>
            <th>Amount</th>
            <th>Total Price</th>
        </tr>
        <%
        int totalPrice=0;
     for(products product:productsList) {

     %>
        <tr>

            <td><%=product.getName() %></td>
            <td><%=product.getSKU() %></td>
            <td><%=product.getCategory()%></td>
            <td>$<%=products.intToPrice(product.getPrice()) %>
            </td>
            <td><%=product.getNum() %></td>
            <%totalPrice+=product.getNum()*product.getPrice(); %>
            <td>$<%=products.intToPrice(product.getPrice()*product.getNum()) %></td>
        </tr>
        <%
        
     }
        %>
         <tr>
            <td>    </td>
            <td>    </td>
            <td>    </td>
            <td>    </td>
            <td>Total:</td>
            <td>$<%=products.intToPrice(totalPrice)%></td>
        </tr>
    </table>
    <form action="confirm.jsp" method="POST">
        <p class="creditcard">Credit Card Number: <input type="text" size="20" name="credit_card"/>
       <input type="submit" value="Purchase"/></p>
    </form> 
</body>
</html>