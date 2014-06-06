package data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import dbUtil.dbUtil;

public class products {

	private static Connection con = null;
	private int id;
	private int cid;
	private String name;
	private String SKU;
	private int price;
	private String category;
	
	

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getCid() {
		return cid;
	}

	public void setCid(int cid) {
		this.cid = cid;
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

	public void setSKU(String SKU) {
		this.SKU = SKU;
	}

	public int getPrice() {
		return price;
	}

	public void setPrice(int price) {
		this.price = price;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public static void addProduct(products product) throws Exception {
		PreparedStatement pstmt = null;
		try {
			con = dbUtil.connect();
			pstmt = con
					.prepareStatement("INSERT INTO products(cid,name,SKU,price) VALUES(?,?,?,?);");
			pstmt.setInt(1, product.getCid());
			pstmt.setString(2, product.getName());
			pstmt.setString(3, product.getSKU());
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
			if(product.getId()==0) {
				throw new Exception();
			}
			con = dbUtil.connect();
			pstmt = con
					.prepareStatement("UPDATE products SET cid=?,name=?,SKU=?,price=? WHERE id=?;");
			pstmt.setInt(1, product.getCid());
			pstmt.setString(2, product.getName());
			pstmt.setString(3, product.getSKU());
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

	public static ArrayList<products> listProducts(int cid)
			throws Exception {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<products> list = new ArrayList<products>();;
		try {
			con = dbUtil.connect();
			if (cid != 0) {
				pstmt = con.prepareStatement("SELECT * FROM products WHERE cid=?;");
				pstmt.setInt(1, cid);
			} else {
				pstmt = con.prepareStatement("SELECT * FROM products;");
			}
			rs = pstmt.executeQuery(); 
			while (rs.next()) {
				products product = new products();
				product.setId(rs.getInt(1));
				product.setCid(rs.getInt(2));
				product.setName(rs.getString(3));
				product.setSKU(rs.getString(4));				
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

	public static ArrayList<products> searchProducts(int cid,
			String search) throws Exception {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<products> list = new ArrayList<products>();;
		try {
			con = dbUtil.connect();
			if (cid != 0) {
				pstmt = con
						.prepareStatement("SELECT * FROM products WHERE category_id=? AND LOWER(name) LIKE ?;");
				pstmt.setInt(1, cid);
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
				product.setCid(rs.getInt(2));
				product.setName(rs.getString(3));
				product.setSKU(rs.getString(4));
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
		String sprice = String.format("%d",price);
		return sprice;
	}

	public static int priceToInt(String price) {
		int iprice=0;
		try {
			iprice = (int) (Integer.parseInt(price));
		} catch (Exception e){
			return 0;
		}
		return iprice;
	}

}
