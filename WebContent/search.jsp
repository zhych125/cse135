<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<% 
   int id=0;
   if(request.getParameter("id")!=null) {
     id=Integer.parseInt(request.getParameter("id")); 
   }


	%>
<div class="search"> 
<h2>Search:
  <% if(request.getParameter("page").equals("products")) {
   %>   
    <form action="products.jsp" method="GET">
        <input type="text" name="search"/>
        <input type="hidden" name="id" value="<%=id %>"/>
        <input type="submit" name="Search"/>
    </form>
    <%} else { %>
     <form action="product_browsing.jsp" method="GET">
     <input type="text" name="search"/>
     <input type="hidden" name="id" value="<%=id %>"/>
     <input type="submit" name="Search"/>
     </form>
     <%} %>
</h2>
</div>