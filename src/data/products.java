package data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import data.users;
import dbUtil.dbUtil;

public class products {

	private static Connection con = null;
	private String name;
	private String SKU;
	private int category_id;
	private String category;
	private int price;
	private int id;
	private int num;
	
	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public int getNum() {
		return num;
	}
	
	public void setNum(int num) {
		this.num=num;
	}
	
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

	public static void addProduct(products product) throws Exception {
		PreparedStatement pstmt = null;
		try {
			con = dbUtil.connect();
			pstmt = con
					.prepareStatement("INSERT INTO products(name,SKU,category_id,price) VALUES(?,?,?,?);");
			pstmt.setString(1, product.getName());
			pstmt.setString(2, product.getSKU());
			pstmt.setInt(3, product.getCategory_id());
			pstmt.setInt(4, product.getPrice());
			pstmt.executeUpdate();
			pstmt.close();
		} finally {
			dbUtil.close(con, pstmt, null);
		}
	}

	public static void updateProduct(products product) throws Exception {
		PreparedStatement pstmt = null;
		try {
			con = dbUtil.connect();
			pstmt = con
					.prepareStatement("UPDATE products SET name=?,SKU=?,category_id=?,price=? WHERE id=?;");
			pstmt.setString(1, product.getName());
			pstmt.setString(2, product.getSKU());
			pstmt.setInt(3, product.getCategory_id());
			pstmt.setInt(4, product.getPrice());
			pstmt.setInt(5, product.getId());
			pstmt.executeUpdate();
			pstmt.close();
		} finally {
			dbUtil.close(con, pstmt, null);
		}
	}

	public static void deleteProduct(int id) throws Exception {
		PreparedStatement pstmt = null;
		try {
			con = dbUtil.connect();
			pstmt = con.prepareStatement("DELETE FROM products WHERE id=?");
			pstmt.setInt(1, id);
			pstmt.executeUpdate();
			pstmt.close();
		} finally {
			dbUtil.close(con, pstmt, null);
		}
	}

	public static ArrayList<products> listProducts(int category_id)
			throws Exception {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<products> list = new ArrayList<products>();;
		try {
			con = dbUtil.connect();
			if (category_id != 0) {
				pstmt = con.prepareStatement("SELECT * FROM products WHERE category_id=?;");
				pstmt.setInt(1, category_id);
			} else {
				pstmt = con.prepareStatement("SELECT * FROM products;");
			}
			rs = pstmt.executeQuery(); 
			while (rs.next()) {
				products product = new products();
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

	public static ArrayList<products> searchProducts(int category_id,
			String search) throws Exception {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<products> list = new ArrayList<products>();;
		try {
			con = dbUtil.connect();
			if (category_id != 0) {
				pstmt = con
						.prepareStatement("SELECT * FROM products WHERE category_id=? AND LOWER(name) LIKE ?;");
				pstmt.setInt(1, category_id);
				pstmt.setString(2, ("%" + search + "%").toLowerCase());
			} else {
				pstmt = con
						.prepareStatement("SELECT * FROM products WHERE LOWER(name) LIKE ?;");
				pstmt.setString(1, ("%" + search + "%").toLowerCase());
			}
			rs = pstmt.executeQuery();

			while (rs.next()) {
				products product = new products();
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

	public static String intToPrice(int price) {
		String sprice = String.format("%.2f", (float) price / 100);
		return sprice;
	}

	public static int priceToInt(String price) {
		int iprice=0;
		try {
			iprice = (int) (Float.parseFloat(price) * 100);
		} catch (Exception e){
			return 0;
		}
		return iprice;
	}
	
	public static void purchase(HashMap<Integer,products> productsMap,users user,String credit_card) throws Exception{
		PreparedStatement pstmt = null;
		PreparedStatement pstmtQuery=null;
		ResultSet rs=null;
		if (user==null||!user.getRole().equals("customer")) {
			throw new Exception("Not a valid customer");
		}
		if(productsMap==null||productsMap.isEmpty()) {
			throw new Exception("Nothing to purchase");
		}
		String regex = "[0-9]+";
		if(credit_card==null||credit_card.isEmpty()||!credit_card.matches(regex)||credit_card.length()<16||credit_card.length()>16) {
			throw new Exception("Invalid credit card number");
		}
		try {
			con = dbUtil.connect();
			con.setAutoCommit(false);
			pstmt = con.prepareStatement("INSERT INTO purchase(customer_id,product_id,amount,credit_card) VALUES(?,?,?,?);");
			pstmtQuery=con.prepareStatement("SELECT id FROM products WHERE id=?;");
			pstmt.setInt(1, user.getId());
			pstmt.setString(4, credit_card);
			for(int product_id:productsMap.keySet()) {
				pstmtQuery.setInt(1, product_id);
				rs=pstmtQuery.executeQuery();
				if(!rs.next()) {
					throw new Exception("product no longer exists");
				}
				pstmt.setInt(2,product_id);
				pstmt.setInt(3, productsMap.get(product_id).getNum());
				pstmt.executeUpdate();
			}
			con.commit();
			pstmt.close();
		} catch(SQLException e) {
			con.rollback();
			throw e;
		} catch (Exception e) {
			if (e.getMessage().equals("product no longer exists")) {
				con.rollback();
			}
			throw e;
		}	finally {
			con.setAutoCommit(true);
			dbUtil.close(null, pstmtQuery, null);
			dbUtil.close(con, pstmt, rs);
		}
	}

}
