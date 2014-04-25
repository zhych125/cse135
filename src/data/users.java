package data;
import java.sql.*;
import javax.sql.*;
import javax.naming.*;
public class users {
private static Connection con=null;

	public static void addUser(String name,String age,String role, String state) throws Exception {
	    try{
	        PreparedStatement preparedInsert;
	        
	        InitialContext cxt=new InitialContext();
	        DataSource ds = (DataSource) cxt.lookup( "java:/comp/env/jdbc/postgres" );

	        if ( ds == null ) {
	            throw new Exception("Data source not found!");
	        
	        } 
	        con=ds.getConnection();
	        String insertString = "INSERT INTO users(name,age,state,role) Values(?,?,?,?)";
	        preparedInsert=con.prepareStatement(insertString); 
	        preparedInsert.setString(1, name);
	        preparedInsert.setInt(2,Integer.parseInt(age));
	        preparedInsert.setString(3,role);
	        preparedInsert.setString(4,state);
	        preparedInsert.executeUpdate();
	        if (preparedInsert!=null) {
	            preparedInsert.close();
	        }
	    } catch (SQLException e ) {
	        throw e;
	    }finally {
	        try{
	            if (con!=null) {
	                con.close();
	            }
	        } catch (SQLException e) {
	            throw e;
	        }
	    }
	}
	public static String checkUser(String user) throws Exception{
		String result=null;
		try{
	        PreparedStatement pstmt;
	        ResultSet rs;
	        InitialContext cxt=new InitialContext();
	        DataSource ds = (DataSource) cxt.lookup( "java:/comp/env/jdbc/postgres" );

	        if ( ds == null ) {
	            throw new Exception("Data source not found!");
	        
	        } 
	        con=ds.getConnection();
	        String stmtString = "SELECT role FROM users Where name=?";
	        pstmt=con.prepareStatement(stmtString);
	        pstmt.setString(1, user);

	        rs=pstmt.executeQuery();
	        if (rs.next()) {
	            result=rs.getString(1);
	        }
	        rs.close();
	        pstmt.close();
	    } catch (SQLException e ) {
	        throw e;
	    }finally {
	        try{
	            if (con!=null) {
	                con.close();
	            }
	        } catch (SQLException e) {
	            throw e;
	        }
	    }
		return result;
	}
}
