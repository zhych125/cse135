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
String credit_card=request.getParameter("credit_card");
try{
	products.purchase(productsMap, user,credit_card);
	
%>
<head>
<title>Confirmation</title>
</head>
<body>
<p>Congratulations, Your Order has been processed</p>
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
<p><%=e.getMessage() %></p>
<a href="product_browsing.jsp">Continue Shopping!</a>
</body>
<%
}
%>



</html>