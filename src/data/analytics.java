package data;

import dbUtil.dbUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;

public class analytics {

	private static Connection con=null;
	
	private static ArrayList<KeyValue> getUserSalesRaw(String state,int age,int cid,int next) throws Exception{
		ArrayList<KeyValue> userList = new ArrayList<KeyValue>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String userSql = "SELECT u.id as uid, u.name FROM users u WHERE u.role='customer' ";
		if(!state.equals("-1")) {
			userSql=userSql + " AND u.state=? ";
		}
		if(age!=-1) {
			userSql=userSql + " AND u.age BETWEEN ? AND ? ";
		}
		userSql=userSql+"ORDER BY u.name ASC LIMIT 20 ";
		if(next!=0) {
			userSql=userSql+" OFFSET ?";
		}
		String joinProductsSales = "SELECT sa.uid,sa.price*sa.quantity AS amount FROM sales sa ";
		if(cid!=-1) {
			joinProductsSales = joinProductsSales + ",products p WHERE p.cid=? AND p.id=sa.pid";
		}
		String stmtString = "SELECT t.name, sum(s.amount) FROM ("
				+ userSql+") t LEFT OUTER JOIN ( "
				+ joinProductsSales +" ) s ON t.uid=s.uid GROUP BY t.name ORDER BY t.name ASC";
		
		try {
			pstmt = con.prepareStatement(stmtString);
			int index = 1;
			if(!state.equals("-1")) {
				pstmt.setString(index, state);
				index++;
			}
			if(age!=-1) {
				switch (age) {
				case 1:
					pstmt.setInt(index,12);
					index++;
					pstmt.setInt(index, 18);
					index++;
					break;
				case 2:
					pstmt.setInt(index,18);
					index++;
					pstmt.setInt(index, 45);
					index++;
					break;
				case 3:
					pstmt.setInt(index,45);
					index++;
					pstmt.setInt(index, 65);
					index++;
					break;
				case 4:
					pstmt.setInt(index,65);
					index++;
					pstmt.setInt(index, 120);
					index++;
					break;
				}
			}
			if(next!=0) {
				pstmt.setInt(index, 20*next);
				index++;
			}
			if(cid!=-1) {
				pstmt.setInt(index, cid);
				index++;
			}
			rs = pstmt.executeQuery();
			while(rs.next()) {
				KeyValue item = new KeyValue();
				item.key = rs.getString(1);
				item.value=rs.getInt(2);
				userList.add(item);
			}
		} finally {
			dbUtil.close(null, pstmt, rs);
		}
		return userList; 
	}
	
	private static ArrayList<KeyValue> getStateSalesRaw(String state,int age, int cid,int next) throws Exception {
		ArrayList<KeyValue> stateList = new ArrayList<KeyValue>();
		PreparedStatement pstmt= null;
		ResultSet rs = null;
		String stateQuery = "SELECT t.state FROM states t ";
		if(!state.equals("-1")) {
			stateQuery= stateQuery + "WHERE t.state=?";
		}
		stateQuery = stateQuery + " ORDER BY t.state ASC LIMIT 20 ";
		if(next!=0) {
			stateQuery = stateQuery + "OFFSET ?";
		}
		String userSql = "SELECT r.state,r.id,r.name FROM users r WHERE r.role='customer'";
		if(age!=-1) {
			userSql=userSql + " AND r.age between ? AND ?";
		}
		String stateSql = "SELECT sta.state,u.id AS uid,u.name FROM ( "
				+stateQuery+" ) sta LEFT OUTER JOIN ("
				+userSql+" ) u ON sta.state=u.state"; 
		String joinProductsSales = "SELECT sa.uid,sa.price*sa.quantity AS amount FROM sales sa ";
		if(cid!=-1) {
			joinProductsSales = joinProductsSales + ",products p WHERE p.cid=? AND p.id=sa.pid";
		}
		String stmtString = "SELECT st.state, sum(s.amount) FROM ("
				+ stateSql
				+" ) st LEFT OUTER JOIN ( "
				+ joinProductsSales +" ) s ON st.uid=s.uid GROUP BY st.state ORDER BY st.state ASC";
		try {
			pstmt = con.prepareStatement(stmtString);
			int index = 1;
			if(!state.equals("-1")) {
				pstmt.setString(index, state);
				index++;
			}
			if(next!=0) {
				pstmt.setInt(index, 20*next);
				index++;
			}
			if(age!=-1) {
				switch (age) {
				case 1:
					pstmt.setInt(index,12);
					index++;
					pstmt.setInt(index, 18);
					index++;
					break;
				case 2:
					pstmt.setInt(index,18);
					index++;
					pstmt.setInt(index, 45);
					index++;
					break;
				case 3:
					pstmt.setInt(index,45);
					index++;
					pstmt.setInt(index, 65);
					index++;
					break;
				case 4:
					pstmt.setInt(index,65);
					index++;
					pstmt.setInt(index, 120);
					index++;
					break;
				}
			}
			
			if(cid!=-1) {
				pstmt.setInt(index, cid);
				index++;
			}
			rs = pstmt.executeQuery();
			while(rs.next()) {
				KeyValue item = new KeyValue();
				item.key = rs.getString(1);
				item.value=rs.getInt(2);
				stateList.add(item);
			}
		} finally {
			dbUtil.close(null, pstmt, rs);
		}
		return stateList; 
	}
	
	
	private static ArrayList<KeyValue> getProductSalesRaw(String state,int age,int cid,int next) throws Exception {
		ArrayList<KeyValue> productList = new ArrayList<KeyValue>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String productSql="SELECT p.id pid,p.name FROM products p ";
		if(cid!=-1) {
				productSql =productSql + " WHERE p.cid=?";
		}
		productSql = productSql + " ORDER BY p.name ASC LIMIT 10 ";
		if(next!=0) {
			productSql = productSql + " OFFSET ?";
		}
		String salesQuery = "SELECT sa.pid,sa.price*sa.quantity as amount FROM sales sa ";
		if(!state.equals("-1")||age!=-1) {
			salesQuery = salesQuery + ",users u WHERE u.id=sa.uid";
			if(!state.equals("-1")) {
				salesQuery = salesQuery + " AND u.state=?";
			}
			if(age!=-1) {
				salesQuery = salesQuery + " AND u.age BETWEEN ? AND ?";
			}
			
		}
		String joinProductsSales = "SELECT p.name,sum(s.amount) FROM "
				+ "("
				+ productSql
				+ " ) p "
				+ " LEFT OUTER JOIN ("
				+ salesQuery
				+" ) s ON p.pid=s.pid GROUP BY p.name ORDER BY p.name ASC";
		
		try {
			pstmt = con.prepareStatement(joinProductsSales);
			int index=1;
			if(cid!=-1) {
				pstmt.setInt(index, cid);
				index++;
			}
			if(next!=0) {
				pstmt.setInt(index, 10*next);
				index++;
			}
			if(!state.equals("-1")) {
				pstmt.setString(index, state);
				index++;
			}
			if(age!=-1) {
				switch (age) {
				case 1:
					pstmt.setInt(index,12);
					index++;
					pstmt.setInt(index, 18);
					index++;
					break;
				case 2:
					pstmt.setInt(index,18);
					index++;
					pstmt.setInt(index, 45);
					index++;
					break;
				case 3:
					pstmt.setInt(index,45);
					index++;
					pstmt.setInt(index, 65);
					index++;
					break;
				case 4:
					pstmt.setInt(index,65);
					index++;
					pstmt.setInt(index, 120);
					index++;
					break;
				}	
			}
			rs=pstmt.executeQuery();
			while(rs.next()) {
				KeyValue item = new KeyValue();
				item.key = rs.getString(1);
				item.value=rs.getInt(2);
				productList.add(item);
			}
			
		} finally {
			dbUtil.close(null, pstmt, rs);
		}
		return productList;
	}
	
	
	public static Table
	getDataRaw(String state,int age,int cid,int next_row,int next_col, String row) throws Exception {
		Table retTable = new Table();
		try {
			con = dbUtil.connect();
			con.setAutoCommit(false);
			if(row.equals("Customers")) {
				retTable.rows=getUserSalesRaw(state,age,cid,next_row);
				retTable.cols = getProductSalesRaw(state,age,cid,next_col);
				retTable.table=getRecordForUserRaw(state,age,cid,next_row,next_col);
			} else {
				retTable.rows=getStateSalesRaw(state,age,cid,next_row);
				retTable.cols = getProductSalesRaw(state,age,cid,next_col);
				retTable.table=getRecordForStateRaw(state,age,cid,next_row,next_col);		
			}
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
	
	private static HashMap<String,HashMap<String,Integer>>
	getRecordForUserRaw(String state,int age,int cid,int next_row,int next_col) throws Exception{
		HashMap<String,HashMap<String,Integer>> recordList = new HashMap<String,HashMap<String,Integer>>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String userSql = "SELECT us.id AS uid, us.name FROM users us WHERE us.role='customer'";
		if(!state.equals("-1")) {
			userSql=userSql + " AND us.state=? ";
		}
		if(age!=-1) {
			userSql=userSql + " AND us.age BETWEEN ? AND ? ";
		}
		userSql+= "ORDER BY name ASC LIMIT 20";
		if(next_row!=0) {
			userSql=userSql+" OFFSET ?";
		}
		String productSql = "SELECT pr.id pid,pr.name FROM products pr ";
		if(cid!=-1) {
				productSql =productSql + " WHERE pr.cid=?";
		}
		productSql = productSql + " ORDER BY pr.name ASC LIMIT 10 ";
		if(next_col!=0) {
			productSql = productSql + " OFFSET ?";
		}
		String stmtString = "SELECT u.name,p.name,sum(s.price*s.quantity) FROM ("
				+ userSql 
				+") u, "
				+ "("
				+ productSql
				+" ) p, sales s WHERE p.pid=s.pid AND u.uid=s.uid GROUP BY u.name,p.name ";
		
		try {
			pstmt=con.prepareStatement(stmtString);
			int index=1;
			if(!state.equals("-1")) {
				pstmt.setString(index, state);
				index++;
			}
			if(age!=-1) {
				switch (age) {
				case 1:
					pstmt.setInt(index,12);
					index++;
					pstmt.setInt(index, 18);
					index++;
					break;
				case 2:
					pstmt.setInt(index,18);
					index++;
					pstmt.setInt(index, 45);
					index++;
					break;
				case 3:
					pstmt.setInt(index,45);
					index++;
					pstmt.setInt(index, 65);
					index++;
					break;
				case 4:
					pstmt.setInt(index,65);
					index++;
					pstmt.setInt(index, 120);
					index++;
					break;
				}	
			}
			if(next_row!=0) {
				pstmt.setInt(index, 20*next_row);
				index++;
			}
			if(cid!=-1) {
				pstmt.setInt(index, cid);
				index++;
			}
			if(next_col!=0) {
				pstmt.setInt(index, 10*next_col);
			}
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
	getRecordForStateRaw(String state,int age,int cid,int next_row,int next_col) throws Exception {
		HashMap<String,HashMap<String,Integer>> recordList = new HashMap<String,HashMap<String,Integer>>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String stateQuery = "SELECT t.state FROM states t ";
		if(!state.equals("-1")) {
			stateQuery= stateQuery + "WHERE t.state=?";
		}
		stateQuery = stateQuery + " ORDER BY t.state ASC LIMIT 20 ";
		if(next_row!=0) {
			stateQuery = stateQuery + "OFFSET ?";
		}
		String stateSql = "SELECT sta.state,u.id AS uid FROM ( "
				+stateQuery+" ) sta, users u WHERE "
				+" sta.state=u.state AND u.role='customer' ";
		if(age!=-1) {
			stateSql=stateSql + " AND u.age between ? AND ?";
		}
		String productSql="SELECT pr.id AS pid,pr.name FROM products pr ";
		if(cid!=-1) {
				productSql =productSql + " WHERE pr.cid=?";
		}
		productSql = productSql + " ORDER BY pr.name ASC LIMIT 10 ";
		if(next_col!=0) {
			productSql = productSql + " OFFSET ?";
		}
		String stmtString = "SELECT st.state,p.name,sum(s.price*s.quantity) FROM ("
				+ stateSql
				+" ) st,"
				+ "("
				+ productSql
				+ " ) p, sales s WHERE p.pid=s.pid AND st.uid=s.uid GROUP BY st.state,p.name ";
		
		try {
			pstmt=con.prepareStatement(stmtString);
			int index=1;
			if(!state.equals("-1")) {
				pstmt.setString(index, state);
				index++;
			}
			if(next_row!=0) {
				pstmt.setInt(index, 20*next_row);
				index++;
			}
			if(age!=-1) {
				switch (age) {
				case 1:
					pstmt.setInt(index,12);
					index++;
					pstmt.setInt(index, 18);
					index++;
					break;
				case 2:
					pstmt.setInt(index,18);
					index++;
					pstmt.setInt(index, 45);
					index++;
					break;
				case 3:
					pstmt.setInt(index,45);
					index++;
					pstmt.setInt(index, 65);
					index++;
					break;
				case 4:
					pstmt.setInt(index,65);
					index++;
					pstmt.setInt(index, 120);
					index++;
					break;
				}	
			}
			if(cid!=-1) {
				pstmt.setInt(index, cid);
				index++;
			}
			if(next_col!=0) {
				pstmt.setInt(index, 10*next_col);
				index++;
			}
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
}