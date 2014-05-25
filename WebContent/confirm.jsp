<%@ page import="java.util.ArrayList,data.*" %>
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
try {  
    String credit_card=request.getParameter("credit_card");
	ArrayList<carts> purchased = carts.purchase(user,credit_card);
	
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
        for(carts item:purchased) {
     %>
        <tr>

            <td><%=item.getProduct().getName() %></td>
            <td><%=item.getProduct().getSKU() %></td>
            <td><%=item.getProduct().getCategory()%></td>
            <td>$<%=products.intToPrice(item.getProduct().getPrice()) %>
            </td>
            <td><%=item.getQuantity() %></td>
            <%totalPrice+=item.getQuantity()*item.getProduct().getPrice(); %>
            <td>$<%=products.intToPrice(item.getProduct().getPrice()*item.getQuantity()) %></td>
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