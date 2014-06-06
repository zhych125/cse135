<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="data.*,java.util.ArrayList" %>
<!DOCTYPE HTML>

<table>
        <tr>
            <th>Row</th>
            <th>State</th>
            <th>Category</th>
            <!-- <th>Age</th> -->
        </tr>
        <tr>
        <form action="sales_analytics.jsp" method="GET">
            <input name="action" type="hidden" value="run"/>
            <td>
                <%
                String rowParameter=request.getParameter("row");
                String[] rows=new String[2];
                rows[0]="Customers";
                rows[1]="States";
                %>
                <select name="row">
                <% 
                for(String rowName:rows) {
                %>
                  <option value="<%=rowName %>"
                    <%    
                    if(rowParameter!=null&&rowParameter.equals(rowName)) {
                    %>
                    selected="selected"
                    <%  
                    }
                    %>
                    >
                    <%=rowName %>
                  </option>  
                <%                
                }
                %> 
                </select> 
            </td>
            <td>
            <%
            String[] statesList=states.getAllStates();
            String stateName=request.getParameter("state");
            
            %>
                <select name="state">
                    <option value="-1" 
                    <%    
                    if(stateName!=null&&stateName.equals("-1")) {
                    %>
                    selected="selected"
                    <%  
                    }
                    %>
                    >All States</option>
                    <%
                    for(String currentState:statesList) {
                    %>
                    <option value="<%=currentState %>"
                    <%    
                    if(stateName!=null&&stateName.equals(currentState)) {
                    %>
                    selected="selected"
                    <%  
                    }
                    %>
                    ><%=currentState %></option> 
                    <%
                    }
                    %>      
		        </select>
            </td>
            <td>
            <%
            String categoryIdString=request.getParameter("category");
            int categoryId=-1;
            if(categoryIdString!=null) {
            	categoryId=Integer.parseInt(categoryIdString);
            }
            %>
               <select name="category">
                    <option value="-1"
                    <%
                    if(categoryId==-1) {
                    %>
                    selected="selected"
                    <%  
                    }
                    %>
                    >All Categories</option>
                    <% 
                    ArrayList<categories> categoryList=categories.listAll();
                    for(categories category:categoryList) {
                    %>
                    <option value="<%= category.getId()%>"
                    <%
                    if(categoryId==category.getId()) {
                    %>
                    selected="selected"
                    <%  
                    }
                    %>
                    ><%= category.getName() %></option>
                    <%
                    }
                    %>
               </select>
            </td>
            <%-- <td>
            <%
            String ageString = request.getParameter("age");
            int ageNumber = -1;
            if(ageString!=null) {
            	ageNumber=Integer.parseInt(ageString);
            }
            %>
              
               <select name="age">
                    <option value="-1"
                    <%
                    if(ageNumber==-1) {
                    %>
                    selected="selected"
                    <%  
                    }
                    %>
                    >All Ages</option>
                    <option value="1"
                    <%
                    if(ageNumber==1) {
                    %>
                    selected="selected"
                    <%  
                    }
                    %>
                    >12-18</option>
                    <option value="2"
                    <%
                    if(ageNumber==2) {
                    %>
                    selected="selected"
                    <%  
                    }
                    %>
                    >18-45</option>
                    <option value="3"
                    <%
                    if(ageNumber==3) {
                    %>
                    selected="selected"
                    <%  
                    }
                    %>
                    >45-65</option>
                    <option value="4"
                    <%
                    if(ageNumber==4) {
                    %>
                    selected="selected"
                    <%  
                    }
                    %>
                    >65-</option>
               </select>
            </td> --%>
            <td>
                <input type="submit" value="Run Query"/>
            </td>
        </form>
    </tr>
</table>
        