<%@ page import="data.*,java.util.ArrayList,java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Product Browsing</title>
</head>
<body>
    <%@ include file="user.jsp" %>
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
    <jsp:param name="page" value="product_browsing"/>
</jsp:include>
<jsp:include page="search.jsp">
    <jsp:param name="page" value="product_browsing"/>
</jsp:include>

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

                <td><%=product.getName() %></td>
                <td><%=product.getSKU() %></td>
                <td><%=categoryMap.get(product.getCategory_id()).getName() %>
                </td>
                <td>$<%=products.intToPrice(product.getPrice()) %>
               </td>
               <td>
               <a href="product_order.jsp?product_id=<%=product.getId() %>">Buy</a>
               </td>
      </tr>
        <%
    }
}
%>
    </table>

</body>
</html>