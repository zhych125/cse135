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
    } 
    String action = request.getParameter("action");
    Table table = null;
    String state = null;
    int age = 0;
    int cid = 0;
    String row = "Customers";
    int next_row = 0;
    int next_col = 0;
    if(action==null||action.equals("run")) {
    %>
    	<%@ include file="selection.jsp" %>
    <%
        if(action!=null&&action.equals("run")) {
        	state = request.getParameter("state");
        	//age = Integer.parseInt(request.getParameter("age"));
        	cid = Integer.parseInt(request.getParameter("category"));
        	row = request.getParameter("row");
            long start=System.currentTimeMillis();
        	table=analytics2.getData(state, cid, row);
            long end=System.currentTimeMillis();
        	out.println("Finish, running time:"+(end-start)+"ms");
        }
    }
    /* else if(action.equals("next_row_pressed")||action.equals("next_col_pressed")){
        state = request.getParameter("state");
        age = Integer.parseInt(request.getParameter("age"));
        cid = Integer.parseInt(request.getParameter("category"));
        row = request.getParameter("row");
        next_row = Integer.parseInt(request.getParameter("next_row"));
        next_col = Integer.parseInt(request.getParameter("next_col"));
        table=analytics.getDataRaw(state, age, cid, next_row, next_col, row);
    }
     */
    if(action!=null) {
    %>
    	<table id="id2">
    	   <tr>
    	       <th>
    	       </th>
    <%
    for(KeyValue kv:table.cols) {
    %>
              <th>
                <b><%=kv.key+" ($"+ kv.value+")"  %></b>
              </th>
              
    <%
    }
    %>
    	   </tr>
    <%
      int index = 0;
      for(KeyValue kv:table.rows) {
    %>
        <tr>
            <td>
              <b><%=kv.key+" ($"+ kv.value+")"  %></b>
            </td>
            
            <%
            for(int i=0;i<table.cols.size();i++) {
            	if(table.table.containsKey(kv.key)&&table.table.get(kv.key).containsKey(table.cols.get(i).key)) {
            %>
            <td>
              <%="$" + table.table.get(kv.key).get(table.cols.get(i).key) %>
            </td>
            <%
            	} else {
            %>
            <td>
            $0
            </td>
            <%
            	}
            }
            
            %>
            
        </tr>
        
    	
    <%	
    }
    %>
 </table>
<%--     <%
    if(table.rows.size()==20) {
    %>    
    <form action="sales_analytics.jsp" method="GET">
    <input name="action" type="hidden" value="next_row_pressed"/>
    <input name="state" type="hidden" value="<%=state %>"/>
    <input name="age" type="hidden" value="<%=age %>"/>
    <input name="category" type="hidden" value="<%=cid %>"/>
    <input name="row" type="hidden" value="<%=row %>"/>
    <input name="next_row" type="hidden" value="<%=next_row+1 %>"/>
    <input name="next_col" type="hidden" value="<%=next_col %>"/>
    <input type="submit" value="Next 20 rows"/>
    </form>
    <%
    }
    %>
    <%
    if(table.cols.size()==10) {
    %>
    <form action="sales_analytics.jsp" method="GET">
    <input name="action" type="hidden" value="next_col_pressed"/>
    <input name="state" type="hidden" value="<%=state %>"/>
    <input name="age" type="hidden" value="<%=age %>"/>
    <input name="category" type="hidden" value="<%=cid %>"/>
    <input name="row" type="hidden" value="<%=row %>"/>
    <input name="next_row" type="hidden" value="<%=next_row %>"/>
    <input name="next_col" type="hidden" value="<%=next_col+1 %>"/>
    <input type="submit" value="Next 10 cols"/>
    </form>
    <%
    }
    %> --%>
    <%
    
}
    %>
    
    
    
</body>