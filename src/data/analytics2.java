package data;

import dbUtil.dbUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

public class analytics2 {

  private static Connection con=null;
  
  private static void dropTempTables() throws Exception {
	  Statement stmt=null;
	  try {
		  stmt=con.createStatement();
		  stmt.executeUpdate("DROP TABLE IF EXISTS usersales;");
		  stmt.executeUpdate("DROP TABLE IF EXISTS statesales");
		  stmt.executeUpdate("DROP TABLE IF EXISTS productsales");
	  } finally {
		  stmt.close();
	  }
  }
  
  private static ArrayList<KeyValue> getUserSales(String state,int cid) throws Exception{
    ArrayList<KeyValue> userList = new ArrayList<KeyValue>();
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    Statement stmt=null;
    String stmtString = "CREATE TEMPORARY TABLE usersales AS (SELECT u.name,u.id, sum(s.amount) as total FROM ";
    stmtString+="( SELECT r.name,r.id FROM users r WHERE r.role='customer' ";
    if(!state.equals("-1")) {
      stmtString+=" AND r.state=? ";
    }
    stmtString+=") ";
    stmtString+= " u LEFT OUTER JOIN ";
    if(cid!=-1) {
      stmtString+=" (SELECT a.uid,a.amount FROM user_category_amount a WHERE a.cid=?) ";
    } else {
      stmtString+=" user_category_amount ";
    }
    stmtString+="s ON u.id=s.uid GROUP BY u.name,u.id ORDER BY total DESC NULLS LAST LIMIT 20 )";
    try {
      pstmt = con.prepareStatement(stmtString);
      int index = 1;
      if(!state.equals("-1")) {
        pstmt.setString(index, state);
        index++;
      }
      
      if(cid!=-1) {
        pstmt.setInt(index, cid);
        index++;
      }
      pstmt.executeUpdate();
      stmt = con.createStatement();
      rs=stmt.executeQuery("SELECT name, total FROM usersales ORDER BY total DESC NULLS LAST");
      while(rs.next()) {
        KeyValue item = new KeyValue();
        item.key = rs.getString(1);
        item.value=rs.getInt(2);
        userList.add(item);
      }
    } finally {

    	dbUtil.close(null, pstmt, rs);
    	if(stmt!=null) {
    		stmt.close();
    	}
    }
    return userList; 
  }
  
  private static ArrayList<KeyValue> getStateSales(String state, int cid) throws Exception {
    ArrayList<KeyValue> stateList = new ArrayList<KeyValue>();
    PreparedStatement pstmt= null;
    Statement stmt = null;
    ResultSet rs = null;
    String stmtString = "CREATE TEMPORARY TABLE statesales AS (SELECT st.state,sum(s.amount) as total FROM ";
    if(!state.equals("-1")) {
      stmtString+=" (SELECT state FROM states WHERE state=?) ";
    } else {
      stmtString+=" states ";
    }
    stmtString+="st LEFT OUTER JOIN ";
    if(cid!=-1) {
      stmtString+=" (SELECT state,amount FROM state_category_amount WHERE cid=?) ";
    } else {
      stmtString+=" state_category_amount ";
    }
    stmtString+= " s on st.state=s.state ";
    stmtString+=" GROUP BY st.state ORDER BY total DESC NULLS LAST LIMIT 20) ";
    try {
      pstmt = con.prepareStatement(stmtString);
      int index = 1;
      if(!state.equals("-1")) {
        pstmt.setString(index, state);
        index++;
      }
      if(cid!=-1) {
        pstmt.setInt(index, cid);
        index++;
      }
      pstmt.executeUpdate();
      stmt=con.createStatement();
      rs=stmt.executeQuery("SELECT state,total FROM statesales ORDER BY total DESC NULLS LAST ");
      while(rs.next()) {
        KeyValue item = new KeyValue();
        item.key = rs.getString(1);
        item.value=rs.getInt(2);
        stateList.add(item);
      }
    } finally {
    	dbUtil.close(null, pstmt, rs);
  		if(stmt!=null) {
  			stmt.close();
  		}
    }
    return stateList; 
  }

  private static ArrayList<KeyValue> getProductSales(String state,int cid) throws Exception {
    ArrayList<KeyValue> productList = new ArrayList<KeyValue>();
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    Statement stmt = null;
    String stmtString="CREATE TEMPORARY TABLE productsales AS (SELECT p.name,p.id,sum(s.amount) AS total FROM ";
    if(cid!=-1) {
      stmtString+=" ( SELECT d.name,d.id FROM products d WHERE d.cid=? ) ";
    } else {
      stmtString+=" products ";
    }
    stmtString+=" p LEFT OUTER JOIN ";
    if(!state.equals("-1")) {
      stmtString+=" (SELECT pid,amount FROM state_product_amount WHERE state=?) ";
    } else {
      stmtString+=" state_product_amount ";
    }
    stmtString+="s ON s.pid=p.id GROUP BY p.name,p.id ORDER BY total DESC NULLS LAST LIMIT 10)";
    try {
      pstmt = con.prepareStatement(stmtString);
      int index=1;
      if(cid!=-1) {
        pstmt.setInt(index, cid);
        index++;
      }
      if(!state.equals("-1")) {
        pstmt.setString(index, state);
        index++;
      }
      pstmt.executeUpdate();
      stmt=con.createStatement();
      rs=stmt.executeQuery("SELECT name,total FROM productsales ORDER BY total DESC NULLS LAST");
      while(rs.next()) {
        KeyValue item = new KeyValue();
        item.key = rs.getString(1);
        item.value=rs.getInt(2);
        productList.add(item);
      }
      
    } finally {
    	dbUtil.close(null, pstmt, rs);
  		if(stmt!=null) {
  			stmt.close();
  		}
    }
    return productList;
  }
  
  private static HashMap<String,HashMap<String,Integer>>
  getRecordForUser(String state,int cid) throws Exception{
    HashMap<String,HashMap<String,Integer>> recordList = new HashMap<String,HashMap<String,Integer>>();
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String stmtString = "SELECT u.name,p.name,s.amount FROM usersales u, productsales p,user_product_amount s"
    		+ " WHERE u.id=s.uid AND p.id=s.pid";
    try {
      pstmt=con.prepareStatement(stmtString);
      rs=pstmt.executeQuery();
      while(rs.next()) {
        if(!recordList.keySet().contains(rs.getString(1))) {
          recordList.put(rs.getString(1), new HashMap<String,Integer>());
        }
        recordList.get(rs.getString(1)).put(rs.getString(2), rs.getInt(3));
      }
    } finally {
      dbUtil.close(null, pstmt, rs);
    }
    return recordList;
  }
  
  private static HashMap<String,HashMap<String,Integer>> 
  getRecordForState(String state,int cid) throws Exception {
    HashMap<String,HashMap<String,Integer>> recordList = new HashMap<String,HashMap<String,Integer>>();
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String stmtString = "SELECT st.state,p.name,s.amount FROM statesales st,productsales p,state_product_amount s"
    		+ " WHERE st.state=s.state AND p.id=s.pid";
    
    try {
      pstmt=con.prepareStatement(stmtString);
      rs=pstmt.executeQuery();
      while(rs.next()) {
        if(!recordList.keySet().contains(rs.getString(1))) {
          recordList.put(rs.getString(1), new HashMap<String,Integer>());
        }
        recordList.get(rs.getString(1)).put(rs.getString(2), rs.getInt(3));
      }
    } finally {
      dbUtil.close(null, pstmt, rs);
    }
    return recordList;    
  }

  public static Table
  getData(String state,int cid, String row) throws Exception {
    Table retTable = new Table();
    try {
      con = dbUtil.connect();
      con.setAutoCommit(false);
      if(row.equals("Customers")) {
        retTable.rows=getUserSales(state,cid);
        retTable.cols = getProductSales(state,cid);
        retTable.table=getRecordForUser(state,cid);
      } else {
        retTable.rows=getStateSales(state,cid);
        retTable.cols = getProductSales(state,cid);
        retTable.table=getRecordForState(state,cid);   
      }
      dropTempTables();
      con.commit();
    } catch(Exception e) {
      con.rollback();
      throw e;
    } finally {
      con.setAutoCommit(true);
      dbUtil.close(con, null, null);      
    }
    return retTable;
  }
  

}