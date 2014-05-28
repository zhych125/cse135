package data;

import dbUtil.dbUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;

public class analytics {

	private static Connection con=null;
	
	private static void dropTempTable() throws Exception {
		String sql = "DROP TABLE IF EXISTS tempuser ;"
				+ " DROP TABLE IF EXISTS tempuserstate;"
				+ " DROP TABLE IF EXISTS tempproduct;";
		PreparedStatement pstmt = null;
		try {
			pstmt=con.prepareStatement(sql);
			pstmt.executeUpdate();
		} finally {
			dbUtil.close(null, pstmt, null);
		}
	}
	private static void createTempUserTable(String state,int age,int next) throws Exception {
		String userSql = "SELECT u.id as uid,u.name FROM users u WHERE u.role='customer'";
		if(!state.equals("-1")) {
			userSql=userSql + " AND u.state=? ";
		}
		if(age!=-1) {
			userSql=userSql + " AND u.age>? AND u.age<=? ";
		}
		
		String sql = "CREATE TEMPORARY TABLE tempuser AS "
				+ userSql
				+ "ORDER BY name ASC LIMIT 20";
		if(next!=0) {
			sql=sql+" OFFSET ?";
		}
		PreparedStatement pstmt = null;
		try {
			pstmt=con.prepareStatement(sql);
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
			if(next!=0) {
				pstmt.setInt(index, 20*next);
				index++;
			}
			pstmt.executeUpdate();
		} finally {
			dbUtil.close(null, pstmt, null);
		}
	}
	
	private static void createTempUserStateTable(String state,int age,int next) throws Exception {
		String stateSql = "SELECT t.state FROM states t ";
		if(!state.equals("-1")) {
			stateSql= stateSql + "WHERE t.state=?";
		}
		stateSql = stateSql + " ORDER BY t.state ASC LIMIT 20 ";
		if(next!=0) {
			stateSql = stateSql + "OFFSET ?";
		}
		String userSql = "SELECT r.state,r.id,r.name FROM users r WHERE r.role='customer'";
		if(age!=-1) {
			userSql=userSql + " AND r.age>? AND r.age<=?";
		}
		
		String sql = "CREATE TEMPORARY TABLE tempuserstate AS "
				+ "SELECT st.state,u.id AS uid,u.name FROM ( "
				+ stateSql+" ) st LEFT OUTER JOIN ("
				+ userSql+" ) u ON st.state=u.state ORDER BY st.state ASC"; 
		
		
		PreparedStatement pstmt = null;
		try {
			pstmt=con.prepareStatement(sql);
			int index=1;
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

			pstmt.executeUpdate();
		} finally {
			dbUtil.close(null, pstmt, null);
		}
	}
	
	
	private static ArrayList<KeyValue> getUserSales(String state,int age,int cid) throws Exception{
		ArrayList<KeyValue> userList = new ArrayList<KeyValue>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String joinProductsSales = "SELECT sa.uid,sa.price*sa.quantity AS amount FROM sales sa ";
		if(cid!=-1) {
			joinProductsSales = joinProductsSales + ",products p WHERE p.cid=? AND p.id=sa.pid";
		}
		String stmtString = "SELECT t.name, sum(s.amount) FROM tempuser t LEFT OUTER JOIN ( "
				+ joinProductsSales +" ) s ON t.uid=s.uid GROUP BY t.name ORDER BY t.name ASC";
		
		try {
			pstmt = con.prepareStatement(stmtString);
			int index = 1;
			if(cid!=-1) {
				pstmt.setInt(index, cid);
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
	
	private static ArrayList<KeyValue> getStateSales(String state,int age, int cid) throws Exception {
		ArrayList<KeyValue> stateList = new ArrayList<KeyValue>();
		PreparedStatement pstmt= null;
		ResultSet rs = null;
		String joinProductsSales = "SELECT sa.uid,sa.price*sa.quantity AS amount FROM sales sa ";
		if(cid!=-1) {
			joinProductsSales = joinProductsSales + ",products p WHERE p.cid=? AND p.id=sa.pid";
		}
		String stmtString = "SELECT st.state, sum(s.amount) FROM tempuserstate st LEFT OUTER JOIN ( "
				+ joinProductsSales +" ) s ON st.uid=s.uid GROUP BY st.state ORDER BY st.state ASC";
		try {
			pstmt = con.prepareStatement(stmtString);
			int index = 1;
			if(cid!=-1) {
				pstmt.setInt(index, cid);
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
	
	private static void createTempProductTable(int cid, int next) throws Exception {
		PreparedStatement pstmt = null;
		String productSql = "CREATE TEMPORARY TABLE tempproduct AS "
				+ "SELECT p.id pid,p.name FROM products p ";
		if(cid!=-1) {
				productSql =productSql + " WHERE p.cid=?";
		}
		productSql = productSql + " ORDER BY p.name ASC LIMIT 10 ";
		if(next!=0) {
			productSql = productSql + " OFFSET ?";
		}
		try {
			pstmt = con.prepareStatement(productSql);
			int index = 1;
			if(cid!=-1) {
				pstmt.setInt(index, cid);
				index++;
			}
			if(next!=0) {
				pstmt.setInt(index, 10*next);
			}
			pstmt.executeUpdate();
		} finally {
			dbUtil.close(null, pstmt, null);
		}
	}
	
	private static ArrayList<KeyValue> getProductSales(String state,int age) throws Exception {
		ArrayList<KeyValue> productList = new ArrayList<KeyValue>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String salesQuery = "SELECT sa.pid,sa.price*sa.quantity as amount FROM sales sa ";
		if(!state.equals("-1")||age!=-1) {
			salesQuery = salesQuery + ",users u WHERE u.id=sa.uid";
			if(!state.equals("-1")) {
				salesQuery = salesQuery + " AND u.state=?";
			}
			if(age!=-1) {
				salesQuery = salesQuery + " AND u.age>? AND u.age<=?";
			}
			
		}
		
		String joinProductsSales = "SELECT p.name,sum(s.amount) FROM "
				+ " tempproduct p "
				+ " LEFT OUTER JOIN ("
				+ salesQuery
				+" ) s ON p.pid=s.pid GROUP BY p.name ORDER BY p.name ASC";
		
		try {
			pstmt = con.prepareStatement(joinProductsSales);
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
	getData(String state,int age,int cid,int next_row,int next_col, String row) throws Exception {
		Table retTable = new Table();
		try {
			con = dbUtil.connect();
			con.setAutoCommit(false);
			if(row.equals("Customers")) {
				createTempUserTable(state,age,next_row);
				createTempProductTable(cid,next_col);
				retTable.rows=getUserSales(state,age,cid);
				retTable.cols = getProductSales(state,age);
				retTable.table=getRecordForUser();
			} else {
				createTempUserStateTable(state,age,next_row);
				createTempProductTable(cid,next_col);
				retTable.rows=getStateSales(state,age,cid);
				retTable.cols = getProductSales(state,age);
				retTable.table=getRecordForState();		
			}
			con.commit();
		} catch(Exception e) {
			con.rollback();
			throw e;
		} finally {
			dropTempTable();
			con.setAutoCommit(true);
			dbUtil.close(con, null, null);
		}
		return retTable;
	}	
	
	
	private static HashMap<String,HashMap<String,Integer>>
	getRecordForUser() throws Exception{
		HashMap<String,HashMap<String,Integer>> recordList = new HashMap<String,HashMap<String,Integer>>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String stmtString = "SELECT u.name,p.name,sum(s.price*s.quantity) FROM tempuser u LEFT OUTER JOIN "
				+ "(tempproduct p LEFT OUTER JOIN sales s ON p.pid=s.pid) ON u.uid=s.uid GROUP BY u.name,p.name "
				+ " ORDER BY u.name ASC,p.name ASC";
		
		try {
			pstmt=con.prepareStatement(stmtString);
			rs=pstmt.executeQuery();
			String old = "--";
			while(rs.next()) {
				if(!rs.getString(1).equals(old)) {
					recordList.put(rs.getString(1), new HashMap<String,Integer>());
					old = rs.getString(1);
				}
				recordList.get(rs.getString(1)).put(rs.getString(2), rs.getInt(3));
			}
		} finally {
			dbUtil.close(null, pstmt, rs);
		}
		return recordList;
	}
	
	private static HashMap<String,HashMap<String,Integer>> 
	getRecordForState() throws Exception {
		HashMap<String,HashMap<String,Integer>> recordList = new HashMap<String,HashMap<String,Integer>>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String stmtString = "SELECT st.state,p.name,sum(s.price*s.quantity) FROM tempuserstate st LEFT OUTER JOIN "
				+ "(tempproduct p LEFT OUTER JOIN sales s ON p.pid=s.pid) ON st.uid=s.uid GROUP BY st.state,p.name "
				+ "ORDER BY st.state ASC, p.name ASC";
		
		try {
			pstmt=con.prepareStatement(stmtString);
			rs=pstmt.executeQuery();
			String old = "--";
			while(rs.next()) {
				if(!rs.getString(1).equals(old)) {
					recordList.put(rs.getString(1), new HashMap<String,Integer>());
					old = rs.getString(1);
				}
				recordList.get(rs.getString(1)).put(rs.getString(2), rs.getInt(3));
			}
		} finally {
			dbUtil.close(null, pstmt, rs);
		}
		return recordList;		
	}
}