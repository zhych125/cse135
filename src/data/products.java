package data;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import dbUtil.dbUtil;

public class products {

	private static Connection con=null;
	private String name;
	private String SKU;
	private int category_id;
	private int price;
	private int id;
	
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
	public String getSKU() {
		return SKU;
	}
	public void setSKU(String sKU) {
		SKU = sKU;
	}
	public int getCategory_id() {
		return category_id;
	}
	public void setCategory_id(int category_id) {
		this.category_id = category_id;
	}
	public int getPrice() {
		return price;
	}
	public void setPrice(int price) {
		this.price = price;
	}
	
	public static void addProduct(products product) throws Exception{
		PreparedStatement pstmt=null;
		try{
	        con=dbUtil.connect();
	        pstmt=con.prepareStatement("INSERT INTO products(name,SKU,category_id,price) VALUES(?,?,?,?);"); 
	        pstmt.setString(1, product.getName());
	        pstmt.setString(2, product.getSKU());
	        pstmt.setInt(3, product.getCategory_id());
	        pstmt.setInt(4, product.getPrice());
	        pstmt.executeUpdate();
	        pstmt.close();
	    }finally {
	    		dbUtil.close(con, pstmt, null);
	    }
	}
	
	public static void updateProduct(products product) throws Exception {
		PreparedStatement pstmt=null;
		try{
	        con=dbUtil.connect();
	        pstmt=con.prepareStatement("UPDATE products SET name=?,SKU=?,category_id=?,price=? WHERE id=?;"); 
	        pstmt.setString(1, product.getName());
	        pstmt.setString(2, product.getSKU());
	        pstmt.setInt(3, product.getCategory_id());
	        pstmt.setInt(4, product.getPrice());
	        pstmt.setInt(5, product.getId());
	        pstmt.executeUpdate();
	        pstmt.close();
	    }finally {
	    		dbUtil.close(con, pstmt, null);
	    }
	}
	
	public static void deleteProduct(int id) throws Exception{
		PreparedStatement pstmt=null;
		try{
	        con=dbUtil.connect();
	        pstmt=con.prepareStatement("DELETE FROM products WHERE id=?"); 
	        pstmt.setInt(1, id);
	        pstmt.executeUpdate();
	        pstmt.close();
	    }finally {
	    		dbUtil.close(con, pstmt, null);
	    }
	}
	
	public static ArrayList<products> listProducts(int category_id) throws Exception{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<products> list=null;
		try {
			con=dbUtil.connect();
			if (category_id!=0) {
				pstmt=con.prepareStatement("SELECT * FROM products WHERE category_id=?;");
				pstmt.setInt(1, category_id);
			} else {
				pstmt=con.prepareStatement("SELECT * FROM products;");
			}
			rs=pstmt.executeQuery();
			list=new ArrayList<products>();
			while(rs.next()) {
				products product=new products();
				product.setId(rs.getInt(1));
				product.setName(rs.getString(2));
				product.setSKU(rs.getString(3));
				product.setCategory_id(rs.getInt(4));
				product.setPrice(rs.getInt(5));
				list.add(product);
			}
			rs.close();
			pstmt.close();
		} finally {
			dbUtil.close(con, pstmt, rs);
		}
		return list;
	}
	
	public static ArrayList<products> searchProducts(int category_id,String search) throws Exception {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<products> list=null;
		try {
			con=dbUtil.connect();
			if (category_id!=0) {
				pstmt=con.prepareStatement("SELECT * FROM products WHERE category_id=? AND name LIKE ?;");
				pstmt.setInt(1, category_id);
				pstmt.setString(2, "%"+search+"%");
			} else {
				pstmt=con.prepareStatement("SELECT * FROM products WHERE name LIKE ?;");
				pstmt.setString(1, "%"+search+"%");
			}
			rs=pstmt.executeQuery();
			list=new ArrayList<products>();
			while(rs.next()) {
				products product=new products();
				product.setId(rs.getInt(1));
				product.setName(rs.getString(2));
				product.setSKU(rs.getString(3));
				product.setCategory_id(rs.getInt(4));
				product.setPrice(rs.getInt(5));
				list.add(product);
			}
			rs.close();
			pstmt.close();
		} finally {
			dbUtil.close(con, pstmt, rs);
		}
		return list;
	}
	
}
