package data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import dbUtil.dbUtil;

public class states {
	private static Connection con=null;
	private static String[] states=new String[50];
	
	public static String[] getAllStates() throws Exception{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = dbUtil.connect();
			String stmtString = "SELECT state FROM states;";
			pstmt = con.prepareStatement(stmtString);
			rs = pstmt.executeQuery();
			int i=0;
			while (rs.next()) {
				states[i]=rs.getString(1);
				i++;
			}
			rs.close();
			pstmt.close();
		} finally {
			dbUtil.close(con, pstmt, rs);
		}
		return states;
	}
}
