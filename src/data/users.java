package data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import dbUtil.dbUtil;

public class users {
	private static Connection con = null;
	private int id;
	private String name;
	private int age;
	private String role;
	private String state;
	
	
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public static void addUser(users user) throws Exception {
		PreparedStatement pstmt = null;
		try {
			con = dbUtil.connect();
			String insertString = "INSERT INTO users(name,role,age,state) Values(?,?,?,?);";
			pstmt = con.prepareStatement(insertString);
			pstmt.setString(1, user.getName());
			pstmt.setString(2, user.getRole());
			pstmt.setInt(3, user.getAge());
			pstmt.setString(4, user.getState());
			
			pstmt.executeUpdate();
			pstmt.close();
		} finally {
			dbUtil.close(con, pstmt, null);
		}
	}

	public static users fetchUser(users user) throws Exception {
		users result = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = dbUtil.connect();
			String stmtString = "SELECT * FROM users Where name=?;";
			pstmt = con.prepareStatement(stmtString);
			pstmt.setString(1, user.getName());
			rs = pstmt.executeQuery();
			if (rs.next()) {
				result = new users();
				result.setId(rs.getInt(1));
				result.setName(rs.getString(2));
				result.setRole(rs.getString(3));
				result.setAge(rs.getInt(4));
				result.setState(rs.getString(5));
				
			}
			rs.close();
			pstmt.close();
		} finally {
			dbUtil.close(con, pstmt, rs);
		}
		return result;
	}
}
