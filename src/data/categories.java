package data;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import dbUtil.dbUtil;
public class categories {
	private static Connection con=null;
	private int id;
	private String name;
	private String description;
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
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	
	public static void save(categories category) throws Exception{
        PreparedStatement pstmt=null;
		try{
	        con=dbUtil.connect();
	        pstmt=con.prepareStatement("INSERT INTO categories(name,description) Values(?,?)"); 
	        pstmt.setString(1, category.getName());
	        pstmt.setString(2, category.getDescription());
	        pstmt.executeUpdate();
	        pstmt.close();
	    }finally {
	    	if (con!=null) {
	    		dbUtil.close(con, pstmt, null);
	        }
	    }
	}
	
	public static void update(categories oldCategory,categories newCategory) throws Exception{
		PreparedStatement pstmt=null;
		try{
	        con=dbUtil.connect();
	        pstmt=con.prepareStatement("UPDATE categories SET name=?,description=? WHERE name=?"); 
	        pstmt.setString(1, newCategory.getName());
	        pstmt.setString(2, newCategory.getDescription());
	        pstmt.setString(3, oldCategory.getName());
	        pstmt.executeUpdate();
	        pstmt.close();
	    }finally {
	    	if (con!=null) {
	    		dbUtil.close(con, pstmt, null);
	        }
	    }
	}
	
	public static void delete(categories category) throws Exception {
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
	        con=dbUtil.connect();
	        if (category.getId()==0) {
	        	pstmt=con.prepareStatement("SELECT id FROM categories WHERE name =?");
	        	pstmt.setString(1, category.getName());
	        	rs=pstmt.executeQuery();
	        	if (rs.next()) {
	        		category.setId(rs.getInt(1));
	        	}
	        	rs.close();
	        	pstmt.close();
	        }
	        pstmt=con.prepareStatement("SELECT * FROM products WHERE category_id=?");
	        pstmt.setInt(1, category.getId());
	        rs=pstmt.executeQuery();
	        if(rs.next()) {
	        	throw new Exception("Can't delete this category, have products references to it!");
	        }
	        rs.close();
	        pstmt.close();
	        pstmt=con.prepareStatement("DELETE FROM categories WHERE name=?"); 
	        pstmt.setString(1, category.getName());
	        pstmt.executeUpdate();
	        pstmt.close();
	    }finally {
	    	dbUtil.close(con, pstmt, rs);
	    }
	}
	
	public static ArrayList<categories> listAll() throws Exception {
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		ArrayList<categories> list=new ArrayList<categories>();
		try{
	        con=dbUtil.connect();
	        pstmt=con.prepareStatement("SELECT * FROM categories");
	        rs=pstmt.executeQuery();
	        while (rs.next()) {
	        	categories category =new categories();
	        	category.setId(rs.getInt(1));
	        	category.setName(rs.getString(2));
	        	category.setDescription(rs.getString(3));
	        	list.add(category);
	        }
	        rs.close();
	        pstmt.close();
	    }finally {
	    	dbUtil.close(con, pstmt, rs);
	    }
		return list;
	}
}
