<%@ page import="java.util.HashMap,data.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
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
    } else {
        response.sendRedirect("user_error.jsp");
    } 
    %>

<%
HashMap<Integer,products> productsMap=(HashMap<Integer,products>)session.getAttribute("product_order");
if (productsMap==null) {
	productsMap=new HashMap<Integer,products>();
}
String credit_card=request.getParameter("credit_card");
try{
	products.purchase(productsMap, user,credit_card);
	
%>
<head>
<link type="text/css" rel="stylesheet" href="stylesheet.css"/>
<title>Confirmation</title>
</head>
<body>
<h3>Congratulations, Your Order has been processed</h3>
<h3>You Have Bought: </h3>
 <table>
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
     for(products product:productsMap.values()) {
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
            <td>Total Purchase:</td>
            <td>$<%=products.intToPrice(totalPrice)%></td>
        </tr>
    </table>
<a href="product_browsing.jsp">Continue Shopping!</a>
</body>
<%
    session.removeAttribute("product_order");
} catch(Exception e) {
%>
<head>
<title>Error</title>
</head>
<body>
<p class="error"><%=e.getMessage() %></p>
<a href="product_browsing.jsp">Continue Shopping!</a>
</body>
<%
}
%>



</html>